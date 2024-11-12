//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.10.01 (64-bit)
//Part Number: GW5A-LV25UG324ES
//Device: GW5A-25
//Device Version: A
//Created Time: Wed Oct 23 21:20:41 2024

module fir_data (dout, wre, wad, di, rad, clk);

output [15:0] dout;
input wre;
input [5:0] wad;
input [15:0] di;
input [5:0] rad;
input clk;

wire wad4_inv;
wire wad5_inv;
wire lut_f_0;
wire lut_f_1;
wire lut_f_2;
wire lut_f_3;
wire [3:0] ram16sdp_inst_0_dout;
wire [7:4] ram16sdp_inst_1_dout;
wire [11:8] ram16sdp_inst_2_dout;
wire [15:12] ram16sdp_inst_3_dout;
wire [3:0] ram16sdp_inst_4_dout;
wire [7:4] ram16sdp_inst_5_dout;
wire [11:8] ram16sdp_inst_6_dout;
wire [15:12] ram16sdp_inst_7_dout;
wire [3:0] ram16sdp_inst_8_dout;
wire [7:4] ram16sdp_inst_9_dout;
wire [11:8] ram16sdp_inst_10_dout;
wire [15:12] ram16sdp_inst_11_dout;
wire [3:0] ram16sdp_inst_12_dout;
wire [7:4] ram16sdp_inst_13_dout;
wire [11:8] ram16sdp_inst_14_dout;
wire [15:12] ram16sdp_inst_15_dout;
wire mux_o_0;
wire mux_o_1;
wire mux_o_3;
wire mux_o_4;
wire mux_o_6;
wire mux_o_7;
wire mux_o_9;
wire mux_o_10;
wire mux_o_12;
wire mux_o_13;
wire mux_o_15;
wire mux_o_16;
wire mux_o_18;
wire mux_o_19;
wire mux_o_21;
wire mux_o_22;
wire mux_o_24;
wire mux_o_25;
wire mux_o_27;
wire mux_o_28;
wire mux_o_30;
wire mux_o_31;
wire mux_o_33;
wire mux_o_34;
wire mux_o_36;
wire mux_o_37;
wire mux_o_39;
wire mux_o_40;
wire mux_o_42;
wire mux_o_43;
wire mux_o_45;
wire mux_o_46;
wire gw_vcc;

assign gw_vcc = 1'b1;

INV inv_inst_0 (.I(wad[4]), .O(wad4_inv));

INV inv_inst_1 (.I(wad[5]), .O(wad5_inv));

LUT4 lut_inst_0 (
  .F(lut_f_0),
  .I0(wre),
  .I1(wad4_inv),
  .I2(wad5_inv),
  .I3(gw_vcc)
);
defparam lut_inst_0.INIT = 16'h8000;
LUT4 lut_inst_1 (
  .F(lut_f_1),
  .I0(wre),
  .I1(wad[4]),
  .I2(wad5_inv),
  .I3(gw_vcc)
);
defparam lut_inst_1.INIT = 16'h8000;
LUT4 lut_inst_2 (
  .F(lut_f_2),
  .I0(wre),
  .I1(wad4_inv),
  .I2(wad[5]),
  .I3(gw_vcc)
);
defparam lut_inst_2.INIT = 16'h8000;
LUT4 lut_inst_3 (
  .F(lut_f_3),
  .I0(wre),
  .I1(wad[4]),
  .I2(wad[5]),
  .I3(gw_vcc)
);
defparam lut_inst_3.INIT = 16'h8000;
RAM16SDP4 ram16sdp_inst_0 (
    .DO(ram16sdp_inst_0_dout[3:0]),
    .DI(di[3:0]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16sdp_inst_0.INIT_0 = 16'h0000;
defparam ram16sdp_inst_0.INIT_1 = 16'h0000;
defparam ram16sdp_inst_0.INIT_2 = 16'h0000;
defparam ram16sdp_inst_0.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_1 (
    .DO(ram16sdp_inst_1_dout[7:4]),
    .DI(di[7:4]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16sdp_inst_1.INIT_0 = 16'h0000;
defparam ram16sdp_inst_1.INIT_1 = 16'h0000;
defparam ram16sdp_inst_1.INIT_2 = 16'h0000;
defparam ram16sdp_inst_1.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_2 (
    .DO(ram16sdp_inst_2_dout[11:8]),
    .DI(di[11:8]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16sdp_inst_2.INIT_0 = 16'h0000;
defparam ram16sdp_inst_2.INIT_1 = 16'h0000;
defparam ram16sdp_inst_2.INIT_2 = 16'h0000;
defparam ram16sdp_inst_2.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_3 (
    .DO(ram16sdp_inst_3_dout[15:12]),
    .DI(di[15:12]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_0),
    .CLK(clk)
);

defparam ram16sdp_inst_3.INIT_0 = 16'h0000;
defparam ram16sdp_inst_3.INIT_1 = 16'h0000;
defparam ram16sdp_inst_3.INIT_2 = 16'h0000;
defparam ram16sdp_inst_3.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_4 (
    .DO(ram16sdp_inst_4_dout[3:0]),
    .DI(di[3:0]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16sdp_inst_4.INIT_0 = 16'h0000;
defparam ram16sdp_inst_4.INIT_1 = 16'h0000;
defparam ram16sdp_inst_4.INIT_2 = 16'h0000;
defparam ram16sdp_inst_4.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_5 (
    .DO(ram16sdp_inst_5_dout[7:4]),
    .DI(di[7:4]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16sdp_inst_5.INIT_0 = 16'h0000;
defparam ram16sdp_inst_5.INIT_1 = 16'h0000;
defparam ram16sdp_inst_5.INIT_2 = 16'h0000;
defparam ram16sdp_inst_5.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_6 (
    .DO(ram16sdp_inst_6_dout[11:8]),
    .DI(di[11:8]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16sdp_inst_6.INIT_0 = 16'h0000;
defparam ram16sdp_inst_6.INIT_1 = 16'h0000;
defparam ram16sdp_inst_6.INIT_2 = 16'h0000;
defparam ram16sdp_inst_6.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_7 (
    .DO(ram16sdp_inst_7_dout[15:12]),
    .DI(di[15:12]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_1),
    .CLK(clk)
);

defparam ram16sdp_inst_7.INIT_0 = 16'h0000;
defparam ram16sdp_inst_7.INIT_1 = 16'h0000;
defparam ram16sdp_inst_7.INIT_2 = 16'h0000;
defparam ram16sdp_inst_7.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_8 (
    .DO(ram16sdp_inst_8_dout[3:0]),
    .DI(di[3:0]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_2),
    .CLK(clk)
);

defparam ram16sdp_inst_8.INIT_0 = 16'h0000;
defparam ram16sdp_inst_8.INIT_1 = 16'h0000;
defparam ram16sdp_inst_8.INIT_2 = 16'h0000;
defparam ram16sdp_inst_8.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_9 (
    .DO(ram16sdp_inst_9_dout[7:4]),
    .DI(di[7:4]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_2),
    .CLK(clk)
);

defparam ram16sdp_inst_9.INIT_0 = 16'h0000;
defparam ram16sdp_inst_9.INIT_1 = 16'h0000;
defparam ram16sdp_inst_9.INIT_2 = 16'h0000;
defparam ram16sdp_inst_9.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_10 (
    .DO(ram16sdp_inst_10_dout[11:8]),
    .DI(di[11:8]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_2),
    .CLK(clk)
);

defparam ram16sdp_inst_10.INIT_0 = 16'h0000;
defparam ram16sdp_inst_10.INIT_1 = 16'h0000;
defparam ram16sdp_inst_10.INIT_2 = 16'h0000;
defparam ram16sdp_inst_10.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_11 (
    .DO(ram16sdp_inst_11_dout[15:12]),
    .DI(di[15:12]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_2),
    .CLK(clk)
);

defparam ram16sdp_inst_11.INIT_0 = 16'h0000;
defparam ram16sdp_inst_11.INIT_1 = 16'h0000;
defparam ram16sdp_inst_11.INIT_2 = 16'h0000;
defparam ram16sdp_inst_11.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_12 (
    .DO(ram16sdp_inst_12_dout[3:0]),
    .DI(di[3:0]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_3),
    .CLK(clk)
);

defparam ram16sdp_inst_12.INIT_0 = 16'h0000;
defparam ram16sdp_inst_12.INIT_1 = 16'h0000;
defparam ram16sdp_inst_12.INIT_2 = 16'h0000;
defparam ram16sdp_inst_12.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_13 (
    .DO(ram16sdp_inst_13_dout[7:4]),
    .DI(di[7:4]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_3),
    .CLK(clk)
);

defparam ram16sdp_inst_13.INIT_0 = 16'h0000;
defparam ram16sdp_inst_13.INIT_1 = 16'h0000;
defparam ram16sdp_inst_13.INIT_2 = 16'h0000;
defparam ram16sdp_inst_13.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_14 (
    .DO(ram16sdp_inst_14_dout[11:8]),
    .DI(di[11:8]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_3),
    .CLK(clk)
);

defparam ram16sdp_inst_14.INIT_0 = 16'h0000;
defparam ram16sdp_inst_14.INIT_1 = 16'h0000;
defparam ram16sdp_inst_14.INIT_2 = 16'h0000;
defparam ram16sdp_inst_14.INIT_3 = 16'h0000;

RAM16SDP4 ram16sdp_inst_15 (
    .DO(ram16sdp_inst_15_dout[15:12]),
    .DI(di[15:12]),
    .WAD(wad[3:0]),
    .RAD(rad[3:0]),
    .WRE(lut_f_3),
    .CLK(clk)
);

defparam ram16sdp_inst_15.INIT_0 = 16'h0000;
defparam ram16sdp_inst_15.INIT_1 = 16'h0000;
defparam ram16sdp_inst_15.INIT_2 = 16'h0000;
defparam ram16sdp_inst_15.INIT_3 = 16'h0000;

MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(ram16sdp_inst_0_dout[0]),
  .I1(ram16sdp_inst_4_dout[0]),
  .S0(rad[4])
);
MUX2 mux_inst_1 (
  .O(mux_o_1),
  .I0(ram16sdp_inst_8_dout[0]),
  .I1(ram16sdp_inst_12_dout[0]),
  .S0(rad[4])
);
MUX2 mux_inst_2 (
  .O(dout[0]),
  .I0(mux_o_0),
  .I1(mux_o_1),
  .S0(rad[5])
);
MUX2 mux_inst_3 (
  .O(mux_o_3),
  .I0(ram16sdp_inst_0_dout[1]),
  .I1(ram16sdp_inst_4_dout[1]),
  .S0(rad[4])
);
MUX2 mux_inst_4 (
  .O(mux_o_4),
  .I0(ram16sdp_inst_8_dout[1]),
  .I1(ram16sdp_inst_12_dout[1]),
  .S0(rad[4])
);
MUX2 mux_inst_5 (
  .O(dout[1]),
  .I0(mux_o_3),
  .I1(mux_o_4),
  .S0(rad[5])
);
MUX2 mux_inst_6 (
  .O(mux_o_6),
  .I0(ram16sdp_inst_0_dout[2]),
  .I1(ram16sdp_inst_4_dout[2]),
  .S0(rad[4])
);
MUX2 mux_inst_7 (
  .O(mux_o_7),
  .I0(ram16sdp_inst_8_dout[2]),
  .I1(ram16sdp_inst_12_dout[2]),
  .S0(rad[4])
);
MUX2 mux_inst_8 (
  .O(dout[2]),
  .I0(mux_o_6),
  .I1(mux_o_7),
  .S0(rad[5])
);
MUX2 mux_inst_9 (
  .O(mux_o_9),
  .I0(ram16sdp_inst_0_dout[3]),
  .I1(ram16sdp_inst_4_dout[3]),
  .S0(rad[4])
);
MUX2 mux_inst_10 (
  .O(mux_o_10),
  .I0(ram16sdp_inst_8_dout[3]),
  .I1(ram16sdp_inst_12_dout[3]),
  .S0(rad[4])
);
MUX2 mux_inst_11 (
  .O(dout[3]),
  .I0(mux_o_9),
  .I1(mux_o_10),
  .S0(rad[5])
);
MUX2 mux_inst_12 (
  .O(mux_o_12),
  .I0(ram16sdp_inst_1_dout[4]),
  .I1(ram16sdp_inst_5_dout[4]),
  .S0(rad[4])
);
MUX2 mux_inst_13 (
  .O(mux_o_13),
  .I0(ram16sdp_inst_9_dout[4]),
  .I1(ram16sdp_inst_13_dout[4]),
  .S0(rad[4])
);
MUX2 mux_inst_14 (
  .O(dout[4]),
  .I0(mux_o_12),
  .I1(mux_o_13),
  .S0(rad[5])
);
MUX2 mux_inst_15 (
  .O(mux_o_15),
  .I0(ram16sdp_inst_1_dout[5]),
  .I1(ram16sdp_inst_5_dout[5]),
  .S0(rad[4])
);
MUX2 mux_inst_16 (
  .O(mux_o_16),
  .I0(ram16sdp_inst_9_dout[5]),
  .I1(ram16sdp_inst_13_dout[5]),
  .S0(rad[4])
);
MUX2 mux_inst_17 (
  .O(dout[5]),
  .I0(mux_o_15),
  .I1(mux_o_16),
  .S0(rad[5])
);
MUX2 mux_inst_18 (
  .O(mux_o_18),
  .I0(ram16sdp_inst_1_dout[6]),
  .I1(ram16sdp_inst_5_dout[6]),
  .S0(rad[4])
);
MUX2 mux_inst_19 (
  .O(mux_o_19),
  .I0(ram16sdp_inst_9_dout[6]),
  .I1(ram16sdp_inst_13_dout[6]),
  .S0(rad[4])
);
MUX2 mux_inst_20 (
  .O(dout[6]),
  .I0(mux_o_18),
  .I1(mux_o_19),
  .S0(rad[5])
);
MUX2 mux_inst_21 (
  .O(mux_o_21),
  .I0(ram16sdp_inst_1_dout[7]),
  .I1(ram16sdp_inst_5_dout[7]),
  .S0(rad[4])
);
MUX2 mux_inst_22 (
  .O(mux_o_22),
  .I0(ram16sdp_inst_9_dout[7]),
  .I1(ram16sdp_inst_13_dout[7]),
  .S0(rad[4])
);
MUX2 mux_inst_23 (
  .O(dout[7]),
  .I0(mux_o_21),
  .I1(mux_o_22),
  .S0(rad[5])
);
MUX2 mux_inst_24 (
  .O(mux_o_24),
  .I0(ram16sdp_inst_2_dout[8]),
  .I1(ram16sdp_inst_6_dout[8]),
  .S0(rad[4])
);
MUX2 mux_inst_25 (
  .O(mux_o_25),
  .I0(ram16sdp_inst_10_dout[8]),
  .I1(ram16sdp_inst_14_dout[8]),
  .S0(rad[4])
);
MUX2 mux_inst_26 (
  .O(dout[8]),
  .I0(mux_o_24),
  .I1(mux_o_25),
  .S0(rad[5])
);
MUX2 mux_inst_27 (
  .O(mux_o_27),
  .I0(ram16sdp_inst_2_dout[9]),
  .I1(ram16sdp_inst_6_dout[9]),
  .S0(rad[4])
);
MUX2 mux_inst_28 (
  .O(mux_o_28),
  .I0(ram16sdp_inst_10_dout[9]),
  .I1(ram16sdp_inst_14_dout[9]),
  .S0(rad[4])
);
MUX2 mux_inst_29 (
  .O(dout[9]),
  .I0(mux_o_27),
  .I1(mux_o_28),
  .S0(rad[5])
);
MUX2 mux_inst_30 (
  .O(mux_o_30),
  .I0(ram16sdp_inst_2_dout[10]),
  .I1(ram16sdp_inst_6_dout[10]),
  .S0(rad[4])
);
MUX2 mux_inst_31 (
  .O(mux_o_31),
  .I0(ram16sdp_inst_10_dout[10]),
  .I1(ram16sdp_inst_14_dout[10]),
  .S0(rad[4])
);
MUX2 mux_inst_32 (
  .O(dout[10]),
  .I0(mux_o_30),
  .I1(mux_o_31),
  .S0(rad[5])
);
MUX2 mux_inst_33 (
  .O(mux_o_33),
  .I0(ram16sdp_inst_2_dout[11]),
  .I1(ram16sdp_inst_6_dout[11]),
  .S0(rad[4])
);
MUX2 mux_inst_34 (
  .O(mux_o_34),
  .I0(ram16sdp_inst_10_dout[11]),
  .I1(ram16sdp_inst_14_dout[11]),
  .S0(rad[4])
);
MUX2 mux_inst_35 (
  .O(dout[11]),
  .I0(mux_o_33),
  .I1(mux_o_34),
  .S0(rad[5])
);
MUX2 mux_inst_36 (
  .O(mux_o_36),
  .I0(ram16sdp_inst_3_dout[12]),
  .I1(ram16sdp_inst_7_dout[12]),
  .S0(rad[4])
);
MUX2 mux_inst_37 (
  .O(mux_o_37),
  .I0(ram16sdp_inst_11_dout[12]),
  .I1(ram16sdp_inst_15_dout[12]),
  .S0(rad[4])
);
MUX2 mux_inst_38 (
  .O(dout[12]),
  .I0(mux_o_36),
  .I1(mux_o_37),
  .S0(rad[5])
);
MUX2 mux_inst_39 (
  .O(mux_o_39),
  .I0(ram16sdp_inst_3_dout[13]),
  .I1(ram16sdp_inst_7_dout[13]),
  .S0(rad[4])
);
MUX2 mux_inst_40 (
  .O(mux_o_40),
  .I0(ram16sdp_inst_11_dout[13]),
  .I1(ram16sdp_inst_15_dout[13]),
  .S0(rad[4])
);
MUX2 mux_inst_41 (
  .O(dout[13]),
  .I0(mux_o_39),
  .I1(mux_o_40),
  .S0(rad[5])
);
MUX2 mux_inst_42 (
  .O(mux_o_42),
  .I0(ram16sdp_inst_3_dout[14]),
  .I1(ram16sdp_inst_7_dout[14]),
  .S0(rad[4])
);
MUX2 mux_inst_43 (
  .O(mux_o_43),
  .I0(ram16sdp_inst_11_dout[14]),
  .I1(ram16sdp_inst_15_dout[14]),
  .S0(rad[4])
);
MUX2 mux_inst_44 (
  .O(dout[14]),
  .I0(mux_o_42),
  .I1(mux_o_43),
  .S0(rad[5])
);
MUX2 mux_inst_45 (
  .O(mux_o_45),
  .I0(ram16sdp_inst_3_dout[15]),
  .I1(ram16sdp_inst_7_dout[15]),
  .S0(rad[4])
);
MUX2 mux_inst_46 (
  .O(mux_o_46),
  .I0(ram16sdp_inst_11_dout[15]),
  .I1(ram16sdp_inst_15_dout[15]),
  .S0(rad[4])
);
MUX2 mux_inst_47 (
  .O(dout[15]),
  .I0(mux_o_45),
  .I1(mux_o_46),
  .S0(rad[5])
);
endmodule //fir_data
