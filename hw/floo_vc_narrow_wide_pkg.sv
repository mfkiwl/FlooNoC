// Copyright 2022 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// This file is auto-generated. Do not edit! Edit the template file instead

`include "axi/typedef.svh"

package floo_vc_narrow_wide_pkg;

  import floo_pkg::*;

  ////////////////////////
  //   AXI Parameters   //
  ////////////////////////

  typedef enum logic [3:0] {
    NarrowAw = 4'd0,
    NarrowW = 4'd1,
    NarrowAr = 4'd2,
    WideAr = 4'd3,
    NarrowB = 4'd4,
    NarrowR = 4'd5,
    WideB = 4'd6,
    WideAw = 4'd7,
    WideW = 4'd8,
    WideR = 4'd9,
    NumAxiChannels = 4'd10
  } axi_ch_e;


  localparam int unsigned AxiNarrowInAddrWidth = 48;
  localparam int unsigned AxiNarrowInDataWidth = 64;
  localparam int unsigned AxiNarrowInIdWidth = 4;
  localparam int unsigned AxiNarrowInUserWidth = 1;


  localparam int unsigned AxiNarrowOutAddrWidth = 48;
  localparam int unsigned AxiNarrowOutDataWidth = 64;
  localparam int unsigned AxiNarrowOutIdWidth = 2;
  localparam int unsigned AxiNarrowOutUserWidth = 1;


  localparam int unsigned AxiWideInAddrWidth = 48;
  localparam int unsigned AxiWideInDataWidth = 512;
  localparam int unsigned AxiWideInIdWidth = 3;
  localparam int unsigned AxiWideInUserWidth = 1;


  localparam int unsigned AxiWideOutAddrWidth = 48;
  localparam int unsigned AxiWideOutDataWidth = 512;
  localparam int unsigned AxiWideOutIdWidth = 1;
  localparam int unsigned AxiWideOutUserWidth = 1;


  typedef logic [47:0] axi_narrow_in_addr_t;
  typedef logic [63:0] axi_narrow_in_data_t;
  typedef logic [7:0] axi_narrow_in_strb_t;
  typedef logic [3:0] axi_narrow_in_id_t;
  typedef logic [0:0] axi_narrow_in_user_t;
  `AXI_TYPEDEF_ALL_CT(axi_narrow_in, axi_narrow_in_req_t, axi_narrow_in_rsp_t, axi_narrow_in_addr_t,
                      axi_narrow_in_id_t, axi_narrow_in_data_t, axi_narrow_in_strb_t,
                      axi_narrow_in_user_t)


  typedef logic [47:0] axi_narrow_out_addr_t;
  typedef logic [63:0] axi_narrow_out_data_t;
  typedef logic [7:0] axi_narrow_out_strb_t;
  typedef logic [1:0] axi_narrow_out_id_t;
  typedef logic [0:0] axi_narrow_out_user_t;
  `AXI_TYPEDEF_ALL_CT(axi_narrow_out, axi_narrow_out_req_t, axi_narrow_out_rsp_t,
                      axi_narrow_out_addr_t, axi_narrow_out_id_t, axi_narrow_out_data_t,
                      axi_narrow_out_strb_t, axi_narrow_out_user_t)


  typedef logic [47:0] axi_wide_in_addr_t;
  typedef logic [511:0] axi_wide_in_data_t;
  typedef logic [63:0] axi_wide_in_strb_t;
  typedef logic [2:0] axi_wide_in_id_t;
  typedef logic [0:0] axi_wide_in_user_t;
  `AXI_TYPEDEF_ALL_CT(axi_wide_in, axi_wide_in_req_t, axi_wide_in_rsp_t, axi_wide_in_addr_t,
                      axi_wide_in_id_t, axi_wide_in_data_t, axi_wide_in_strb_t, axi_wide_in_user_t)


  typedef logic [47:0] axi_wide_out_addr_t;
  typedef logic [511:0] axi_wide_out_data_t;
  typedef logic [63:0] axi_wide_out_strb_t;
  typedef logic [0:0] axi_wide_out_id_t;
  typedef logic [0:0] axi_wide_out_user_t;
  `AXI_TYPEDEF_ALL_CT(axi_wide_out, axi_wide_out_req_t, axi_wide_out_rsp_t, axi_wide_out_addr_t,
                      axi_wide_out_id_t, axi_wide_out_data_t, axi_wide_out_strb_t,
                      axi_wide_out_user_t)



  /////////////////////////
  //   Header Typedefs   //
  /////////////////////////

  localparam route_algo_e RouteAlgo = XYRouting;
  localparam bit UseIdTable = 1'b0;
  localparam int unsigned NumXBits = 3;
  localparam int unsigned NumYBits = 3;
  localparam int unsigned XYAddrOffsetX = 16;
  localparam int unsigned XYAddrOffsetY = 19;
  localparam int unsigned IdAddrOffset = 0;


  typedef logic [0:0] rob_idx_t;
  typedef logic [1:0] port_id_t;
  typedef logic [2:0] x_bits_t;
  typedef logic [2:0] y_bits_t;
  typedef struct packed {
    x_bits_t  x;
    y_bits_t  y;
    port_id_t port_id;
  } id_t;

  typedef logic route_t;
  typedef id_t dst_t;
  typedef logic [2:0] vc_id_t;


  typedef struct packed {
    logic rob_req;
    rob_idx_t rob_idx;
    dst_t dst_id;
    id_t src_id;
    logic last;
    logic atop;
    axi_ch_e axi_ch;
    vc_id_t vc_id;
    route_direction_e lookahead;
  } hdr_t;



  ////////////////////////
  //   Flits Typedefs   //
  ////////////////////////

  typedef struct packed {
    hdr_t hdr;
    axi_narrow_in_aw_chan_t aw;
  } floo_narrow_aw_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_narrow_in_w_chan_t w;
    logic [13:0] rsvd;
  } floo_narrow_w_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_narrow_in_b_chan_t b;
    logic [64:0] rsvd;
  } floo_narrow_b_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_narrow_in_ar_chan_t ar;
    logic [5:0] rsvd;
  } floo_narrow_ar_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_narrow_in_r_chan_t r;
  } floo_narrow_r_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_wide_in_aw_chan_t aw;
    logic [490:0] rsvd;
  } floo_wide_aw_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_wide_in_w_chan_t w;
  } floo_wide_w_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_wide_in_b_chan_t b;
    logic [65:0] rsvd;
  } floo_wide_b_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_wide_in_ar_chan_t ar;
    logic [6:0] rsvd;
  } floo_wide_ar_flit_t;

  typedef struct packed {
    hdr_t hdr;
    axi_wide_in_r_chan_t r;
    logic [58:0] rsvd;
  } floo_wide_r_flit_t;

  typedef logic [87:0] floo_req_payload_t;
  typedef struct packed {
    hdr_t hdr;
    floo_req_payload_t payload;
  } floo_req_generic_flit_t;

  typedef logic [71:0] floo_rsp_payload_t;
  typedef struct packed {
    hdr_t hdr;
    floo_rsp_payload_t payload;
  } floo_rsp_generic_flit_t;

  typedef logic [577:0] floo_wide_payload_t;
  typedef struct packed {
    hdr_t hdr;
    floo_wide_payload_t payload;
  } floo_wide_generic_flit_t;



  //////////////////////////
  //   Channel Typedefs   //
  //////////////////////////

  typedef union packed {
    floo_narrow_aw_flit_t narrow_aw;
    floo_narrow_w_flit_t narrow_w;
    floo_narrow_ar_flit_t narrow_ar;
    floo_wide_ar_flit_t wide_ar;
    floo_req_generic_flit_t generic;
  } floo_req_chan_t;

  typedef union packed {
    floo_narrow_b_flit_t narrow_b;
    floo_narrow_r_flit_t narrow_r;
    floo_wide_b_flit_t wide_b;
    floo_rsp_generic_flit_t generic;
  } floo_rsp_chan_t;

  typedef union packed {
    floo_wide_aw_flit_t wide_aw;
    floo_wide_w_flit_t wide_w;
    floo_wide_r_flit_t wide_r;
    floo_wide_generic_flit_t generic;
  } floo_wide_chan_t;



  ///////////////////////
  //   Link Typedefs   //
  ///////////////////////

  typedef struct packed {
    logic valid;
    logic credit_v;
    vc_id_t credit_id;
    floo_req_chan_t req;
  } floo_vc_req_t;

  typedef struct packed {
    logic valid;
    logic credit_v;
    vc_id_t credit_id;
    floo_rsp_chan_t rsp;
  } floo_vc_rsp_t;

  typedef struct packed {
    logic valid;
    logic credit_v;
    vc_id_t credit_id;
    floo_wide_chan_t wide;
  } floo_vc_wide_t;


endpackage
