# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2024-09-13

### Added

- Support for source-based routing algorithm in routers, chimnyes and `floogen`. The route is encoded in the header as a `route_t` field, and each router consumes a couple of bits to determine the output ports. In the chimney, a two-stage encoder was added to first determine the destination ID of the request, and then retrive the pre-computed route to that destination from a table. The `floogen` configuration was extended to support the new routing algorithm, and it will also generate the necessary tables for the chimneys.
- Chimneys now support multiple AXI IDs for non-atomic transactions by specifying the `MaxUniqueids` parameter. This will mitigate ordering of transactions from initially different IDs or endpoints at the expense of some complexity in the `meta_buffer` which then uses `id_queue` to store the meta information required to return responses.
- The conversion from req/rsp with different ID widths from/to NoC has been moved from the chimneys to the `floo_meta_buffer` module.
- Added virtual channel router `floo_vc_router` and corresponding `floo_vc_narrow_wide_chimney`. Currently only supports XY-Routing and mesh topologies.
- Preliminary support for multiple local ports in the routers.
- Additional traffic pattern generation and visualization.
- Added option in `floogen` to define the direction of `connections` to/from routers with `dst_dir` and `src_dir` flags. This replaces the previous `id_offset` flag for that purpose. Specifying the direction of the connection is useful for mesh topologies with `XYRouting`, but also for tile-based implementation, where the order of the ports matters resp. needs to be known.
- `routers` in `floogen`  can no be configured with `degree` to overwrite the number of ports. This is manily useful for tile-based implementations, where all tiles should have identical routers.

### Changed

- `floo_route_comp` now supports source-based routing, and can output both destination ID and a route to the destination.
- The chimneys have an additional port `route_table_i` to receive the pre-computed routing table that is generated by `floogen`.
- System address map was renamed from `AddrMap` to `Sam`.
- The destination field in the flit header have a new type `dst_t` which is either set to `route_t` for the new source-based routing algorithm, and `id_t` for all the other routing algorithms.
- Bumped `idma` dependency to `0.6`
- Renamed `rsvd` field in flits to `payload` to better reflect its purpose.
- Reordered directions in `route_direction_e` to better support multiple local ports.
- Moved all system related rendered parameters from the flit package to its own package in `my_system_floo_noc.sv`. This allows to use the auto-generated routing information for tile-based implementations, that are assembled by hand.
- The `bidirectional` flag for `connections` in `floogen` is set to `true` by default, since uni-directional links are currently not supported.
- The System Address now needs to be passed as a parameter in the `chimneys`, since it is not part of the flit packages anymore.

### Fixed

- The generation of the unique ID has been changed resp. aligned for 2D meshes to increment Y-first and X-second. This way the address range and ID increment are consistent with each other.
- Broadcasted input `id_i` in the chimneys should not throw an error anymore in elaboration.
- The `id_offset` should not be correctly applied in the system address map. Before it resulted in negative coordinates.
- The `axi_ch_e` types now have an explicit bitwidth. Previously, this caused issues during elaboration since a 32-bit integer was used as a type.
- Fixed a typedef in `floo_vc_arbiter` when setting `NumVirtChannels` to 1, that caused issue when compiling with Verilator.
- Fixes issue that the routing table was not renderred when `IdTable` was used as the routing algorithm.

### Removed

- Removed all `floo_synth*` wrapper modules. They are moved to the internal PD repository, since they are not really maintained as part of the FlooNoC repository.

## [0.4.0] - 2024-02-07

### Added

- Added assertions to XY routers with routing optimization enabled to catch packets that want to Y->X which is illegal in XY routing.

### Changed

- The parameters `EnMgrPort` and `EnSbrPort` are swapped in the chimneys to be more consistent. FlooNoC defines subordinate ports as requests that go out of the NoC to AXI subordinates (i.e. memories) that return a response, and manager ports as requests that come into the NoC from AXI managers (i.e. cores).
- The `floo_narrow_wide_join` now uses `axi_riscv_atomics` to filter out atomic operations. The `atop_filter` are still there but are disabled by default.

### Fixed

- Synthesis wrappers now use the more generic `id_t` instead of the deprecated `xy_id_t` type as a parameter.
- The specified ID offset is now also rendered for routers in `floogen`.
- Fixed a template rendering issue where XY routers could not be rendered when the first direction (`EJECT`) was not defined.

### Removed

- Removed `floo_synth_mesh`, `floo_synth_mesh_ruche` & `floo_synth_router_simple` synthesis wrappers, since they are not used anymore.

## [0.3.1] - 2024-01-16

### Added

- `floo_narrow_wide_join` which joins a narrow and a wide AXI bus

### Changed

- Wormhole routing for bursts was removed for some channels in the chimney since it is generally not necessary if the header information is sent in parallel to the payload.

### Fixed

- Output directory passed to `floogen` is now relative to the current working directory instead of the installation folder of `floogen`.
- Write ordering in the narrow-wide version was incorrect. Sending `AW` and `W` beats over different channels would have allowed to arrive them out of order, if multiple managers are sending write requests to the same subordinate, which could result in interleaving of the data. This is now fixed by sending `AW` and `W` beats over the same wide channel. The `AW` and `W` beats are coupled together and wormhole routing prevents interleaving of the data.

## [0.3.0] - 2024-01-09

### Added

- Added NoC generation framework called `floogen`. Also added documentation for `floogen` in the `docs` folder.
- Added Chimney Parameters `EnMgrPort` and `EnSbrPort` to properly parametrize Manager resp. Subordinate-only instances of a chimney
- Added `XYRouteOpt` parameter to router to enable/disable routing optimizations when using `XYRouting`

### Changed

- the exported include folder of the `floo` package is moved to `hw/include`.
- The `LICENSE` file was updated to reflect that the project uses the `Solderpad Hardware License Version 2.1` for all `hw` files and the `Apache License 2.0` for software related files.
- The directory was restructured to accomodate the new `floogen` framework. The `src` was renamed to `hw`, which contains only SystemVerilog code. Test modules and testbenches were also moved to `hw/test` and `hw/tb` respectively. The same holds true for wave files, which are now located in `hw/tb/wave`.
- The SV packages `floo_axi_pkg` and `floo_narrow_wide_pkg` are now generated by `floogen`. The configuration files were moved to the `floogen/examples` folder, and were aligned with the new `floogen` configuration format, that is written in `YAML` instead of `hjson`.
- Reworked the python dependencies to use `pyproject.toml` instead of `requirements.txt`. Furthermore, the python requirement was bumped to `3.10` due to `floogen` (which makes heavy use of the newer `match` syntax)
- Removed `xy_id_i` ports from AXI chimneys in favor of a generic `id_i` port for both `IdTable` and `XYRouting`
- Changed auto-generated package configuration schema. The `header` field is replaced in favor of a `routing` field that better represents the information needed for routing.
- `XYRouting` now also supports a routing table similar to the `IdTable` routing table. Before the destination was determined based on a couple of bits in the address. This however did not allow for a lot of flexibility and requires a larger addres width.

### Fixed

- Fixed missing backpressure in the `NoRoB` version of the reorder buffer, which could lead to overflow of counters

### Removed

- `axi_channel_compare` was removed in favor of `axi_chan_compare` from the `axi` repository.
- Removed flit generation script `flit_gen.py` including configuration files, since this is now integrated into `floogen` (in conjunction with the `--only-pkg` flag)

## [0.2.1] - 2023-10-13

### Changed

- Bump dependencies

## [0.2.0] - 2023-10-04

### Changed

- Renamed `*_flit_pkg` to `*_pkg`
- New naming scheme of ports: All AXI ports are now prefixed with `axi_`, all FlooNoC links are now prefixed with `floo_`
- Renamed `floo_param_pkg` to `floo_test_pkg`
- Renamed AXI `resp_t` structs to `rsp_t`
- Changed configuration format to align with upcoming FlooNoC generation script

### Added

- Table based routing support in `narrow_wide_chimney`
- Support for different number of inputs and outputs in `narrow_wide_router`
- Add wrapper for different types of Reorder Buffers in chimneys
- Support for simple RoB-less chimneys with ID counters

### Fixed

- Test modules `floo_axi_rand_slave` & `floo_dma_test_node` now support `addr_width > 32`
- Fixed synchronization issues for ATOP B and R responses

## [0.1.0] - 2023-06-19

### Added

- Initial early public release
