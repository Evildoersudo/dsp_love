module dsp_love_top(
    input wire clk_50m,
    input wire rst_n,
//音频接口
//    input wire [15:0] audio_data,   //音频信号
//    input wire audio_clk,   //音频时钟
//    input wire audio_valid,
//    input wire ipd,
    inout 	wire			iic_0_scl,              
	inout 	wire			iic_0_sda,   
	output 	wire			led,
	input 	wire			I2S_ADCDAT,
	input 	wire			I2S_ADCLRC,
	input 	wire			I2S_BCLK,
	output 	wire			I2S_DACDAT,
	input 		wire		I2S_DACLRC,
	output 		wire		I2S_MCLK,
//LCD接口
    output               lcd_de,      //LCD 数据使能信号
    output               lcd_hs,      //LCD 行同步信号
    output               lcd_vs,      //LCD 场同步信号
    output               lcd_clk,     //LCD 像素时钟
    inout        [15:0]  lcd_rgb,     //LCD RGB565颜色数据
    output               lcd_rst,
    output               lcd_bl,
//uart接口
    input wire uart_rx
);

wire [15:0] audio_data;

pinpuxianshi_top pinpuxianshi_inst(
    .clk_50m(clk_50m),
    .rst_n(rst_n),
    .audio_data(audio_data),
    .audio_clk(audio_clk),
    .audio_valid(1'b1),
    .lcd_de(lcd_de),
    .lcd_hs(lcd_hs),
    .lcd_vs(lcd_vs),
    .lcd_clk(lcd_clk),
    .lcd_rgb(lcd_rgb),
    .lcd_rst(lcd_rst),
    .lcd_bl(lcd_bl)
);

/*
FFT_Rom_out   U_fft_rom
(
   .clk  (audio_clk ),
   .rst  (~rst_n ),
//   .ipd  (ipd ),
   .ipd  (1'b1 ),
   .dout (audio_data)
);
*/

clk_48k clk_48k_inst(
    .clk_50m(clk_50m),
    .rst_n(rst_n),
    .clk_out(audio_clk)
);

audio_lookback audio_lookback_inst(
		.clk				(clk_50m				),                    
		.reset_n			(rst_n			),                                   
		.iic_0_scl			(iic_0_scl			),              
		.iic_0_sda			(iic_0_sda			),   
	    .led				(led				),
		.I2S_ADCDAT			(I2S_ADCDAT			),
		.I2S_ADCLRC			(I2S_ADCLRC			),
		.I2S_BCLK			(I2S_BCLK			),
		.I2S_DACDAT			(I2S_DACDAT			),
		.I2S_DACLRC			(I2S_DACLRC			),
		.I2S_MCLK			(I2S_MCLK			),
        .K					(K					),
//		.clk_48k			(clk_48k),
		//.dacfifo_write		(dacfifo_write		),
		.dac_data_positive  (audio_data)
);

 top_desk_ctrl top_desk_inst(
    .Clk			(clk_50m		)	,
    .Reset_n		(rst_n)	,
    .uart_rx		(uart_rx)	,
	.K           (K)
);

endmodule