module pinpuxianshi_top(
    input wire clk_50m,
    input wire rst_n,
//音频接口
    input wire [15:0] audio_data,   //音频信号
    input wire audio_clk,   //音频时钟
    input wire audio_valid,
//LCD接口
    output               lcd_de,      //LCD 数据使能信号
    output               lcd_hs,      //LCD 行同步信号
    output               lcd_vs,      //LCD 场同步信号
    output               lcd_clk,     //LCD 像素时钟
    inout        [15:0]  lcd_rgb,     //LCD RGB565颜色数据
    output               lcd_rst,
    output               lcd_bl
);

wire [15:0] amp;
wire soud;
wire opd;
wire eoud;
wire start;
wire fft_rst_n;
wire fifo_full;
wire rd_en;
wire [15:0] fifo_rd_data;


FFT_TOP FFT_TOP_Inst(
    .clk(clk_50m),
    .rst(~rst_n),
    .fft_rst(~fft_rst_n),
    .start(start),
    .xn_re(fifo_rd_data),
    .data_soud(soud),
    .data_opd(opd),
    .data_eoud(eoud),
    .amp(amp)
);

lcd_top lcd_top_inst(
    .clk_50m(clk_50m),
    .rst_n(rst_n),
    .lcd_de(lcd_de),
    .lcd_hs(lcd_hs),
    .lcd_vs(lcd_vs),
    .lcd_clk(lcd_clk),
    .lcd_rgb(lcd_rgb),
    .lcd_rst(lcd_rst),
    .lcd_bl(lcd_bl),
    .fft_data(amp),
    .fft_sop(soud),
    .fft_eop(eoud),
    .fft_valid(opd)
);

fifo_top u2_async_fifo_1024x16b(
		.Data(audio_data), //input [15:0] Data
		.Reset(~rst_n), //input Reset
		.WrClk(audio_clk), //input WrClk
		.RdClk(clk_50m), //input RdClk
		.WrEn(audio_valid), //input WrEn
		.RdEn(rd_en), //input RdEn
		.Wnum(), //output [10:0] Wnum
		.Q(fifo_rd_data), //output [15:0] Q
		.Empty(), //output Empty
		.Full(fifo_full) //output Full
);//音频信号->fft输入

//FIFO读出的数据转换成Avalon-ST(Stream)接口
fifo_to_st u_fifo_to_st(
    .clk_50m        (clk_50m),
    .rst_n          (rst_n),
    //FIFO读控制接口
    .fifo_full(fifo_full),
    .start(start),
    .rd_en(rd_en),
    //FFT复位信号    
    .fft_rst_n      (fft_rst_n)
);

endmodule