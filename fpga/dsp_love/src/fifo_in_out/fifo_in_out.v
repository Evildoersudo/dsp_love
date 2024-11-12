module fifo_in_out(
    input clk,                    
		input reset_n,                                   
		inout iic_0_scl,              
		inout iic_0_sda,   
	    output led,
		
		input I2S_ADCDAT,
		input I2S_ADCLRC,
		input I2S_BCLK,
		output I2S_DACDAT,
		input I2S_DACLRC,
		output I2S_MCLK,
        input [31:0] Q_1,//输入数据
        input dsp_to_data_en,//输出到播放器使能 将其至高后，每个clk输入一次
        input RdEn_i,//启动读
        output [31:0] Q_o,
		output		beep_ctrl,
        output Almost_Full_o,//当将要输出到Q_o的数据满128个后，其至高             
        output empty_o,//提示fifo为空
		output	clk_1MHz
);

wire	beep_ctrl=1'b0;
audio_lookback audio_lookback(
		.clk(clk),                    
		.reset_n(reset_n),                                   
		.iic_0_scl(iic_0_scl),              
		.iic_0_sda(iic_0_sda),   
	    .led(led),
		
		.I2S_ADCDAT(I2S_ADCDAT),
		.I2S_ADCLRC(I2S_ADCLRC),
		.I2S_BCLK(I2S_BCLK),
		.I2S_DACDAT(I2S_DACDAT),
		.I2S_DACLRC(I2S_DACLRC),
		.I2S_MCLK(I2S_MCLK),

        .Q_o(Q_o),//读出数据
        .Empty_o(empty_o),//提示fifo为空
        .Almost_Full_o(Almost_Full_o),//提示存完128个
        .RdEn_i(RdEn_i),//启动读
        .Q_1(Q_1),
        .dsp_to_data_en(dsp_to_data_en),
		.Read_Clk(clk_1MHz),
		.Write_Clk(clk_1MHz)
);
 clock_1Mhz	clock_1Mhz_inst(
   .clk_50MHz	(clk)			,
   .rst_n		(reset_n		)			,
   .clk_1MHz    (clk_1MHz)
);
endmodule