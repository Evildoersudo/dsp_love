//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.10.01 (64-bit)
//Part Number: GW5A-LV25UG324ES
//Device: GW5A-25
//Device Version: A
//Created Time: Thu Oct 24 18:33:08 2024

module haiming_100_rom (dout, clk, oce, ce, reset, ad);

output [15:0] dout;
input clk;
input oce;
input ce;
input reset;
input [6:0] ad;

wire [15:0] prom_inst_0_dout_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[15:0],dout[15:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .AD({gw_gnd,gw_gnd,gw_gnd,ad[6:0],gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 16;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'h22F71FFE1D2B1A82180415B5139611AB0FF50E750D2E0C210B4E0AB70A5C0A3D;
defparam prom_inst_0.INIT_RAM_01 = 256'h5BDE586154CF512E4D8049C9460E42523E983AE5373D33A3301B2CA929502614;
defparam prom_inst_0.INIT_RAM_02 = 256'h7F437E8E7D9D7C737B0F797477A3759E736771006E6C6BAE68C765BC628F5F44;
defparam prom_inst_0.INIT_RAM_03 = 256'h6BAE6E6C71007367759E77A379747B0F7C737D9D7E8E7F437FBC7FF87FF87FBC;
defparam prom_inst_0.INIT_RAM_04 = 256'h33A3373D3AE53E984252460E49C94D80512E54CF58615BDE5F44628F65BC68C7;
defparam prom_inst_0.INIT_RAM_05 = 256'h0C210D2E0E750FF511AB139615B518041A821D2B1FFE22F7261429502CA9301B;
defparam prom_inst_0.INIT_RAM_06 = 256'h0000000000000000000000000000000000000000000000000A3D0A5C0AB70B4E;

endmodule //haiming_100_rom
