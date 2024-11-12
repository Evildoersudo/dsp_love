module lcd_top(
    input                clk_50m,
    input                rst_n,    
    //RGB LCD接口
    output               lcd_de,      //LCD 数据使能信号
    output               lcd_hs,      //LCD 行同步信号
    output               lcd_vs,      //LCD 场同步信号
    output               lcd_clk,     //LCD 像素时钟
    output        [15:0]  lcd_rgb,     //LCD RGB565颜色数据
    output               lcd_rst,
    output               lcd_bl ,
    //FFT输入数据                
    input         [15:0] fft_data,    //FFT频谱数据
    input                fft_sop,     //SOP包开始信号
    input                fft_eop,     //EOP包结束信号
    input                fft_valid    //FFT频谱数据有效信号
    );

//wire define
wire [15:0] fifo_rd_data;  //FIFO读数据
wire        fifo_rd_req;   //FIFO读请求信号
wire        fifo_rd_empty; //FIFO读空信号

wire        fifo_wr_req;   //FIFO写请求信号
wire [15:0] fifo_wr_data;  //FIFO写数据
wire [9:0]  fifo_wr_cnt;   //FIFO当前数据个数
wire [9:0]  fft_point_cnt; //FFT频谱位置
wire        fft_point_done;//FFT当前频谱绘制完成
wire        data_req;      //请求数据信号

//*****************************************************
//**                    main code
//***************************************************** 

//fifo读写控制模块
rw_fifo_ctrl u_rw_fifo_ctrl(
    .clk_50m        (clk_50m),
    .lcd_clk        (lcd_clk),
    .rst_n          (rst_n),
        
    .fft_data       (fft_data),
    .fft_sop        (fft_sop),
    .fft_eop        (fft_eop),
    .fft_valid      (fft_valid),
    
    .data_req       (data_req),
    .fft_point_done (fft_point_done),
    .fft_point_cnt  (fft_point_cnt),
    
    .fifo_rd_empty  (fifo_rd_empty), 
    .fifo_wr_cnt    (fifo_wr_cnt),
    .fifo_rd_req    (fifo_rd_req),  
    .fifo_wr_data   (fifo_wr_data),
    .fifo_wr_req    (fifo_wr_req)
);

//FIFO模块
fifo_top u1_async_fifo_1024x16b(
		.Data(fifo_wr_data), //input [15:0] Data
		.Reset(~rst_n), //input Reset
		.WrClk(clk_50m), //input WrClk
		.RdClk(lcd_clk), //input RdClk
		.WrEn(fifo_wr_req), //input WrEn
		.RdEn(fifo_rd_req), //input RdEn
		.Wnum(fifo_wr_cnt), //output [10:0] Wnum
		.Q(fifo_rd_data), //output [15:0] Q
		.Empty(fifo_rd_empty), //output Empty
		.Full() //output Full
	);

//LCD显示顶层模块
lcd_rgb_top  u_lcd_rgb_top(
    .clk            (clk_50m),
    .rst_n          (rst_n ),
    
    .lcd_hs         (lcd_hs),
    .lcd_vs         (lcd_vs),
    .lcd_de         (lcd_de),
    .lcd_rgb        (lcd_rgb),
    .lcd_bl         (lcd_bl),
    .lcd_rst        (lcd_rst),
    .lcd_clk        (lcd_clk),
    
    .fft_point_cnt  (fft_point_cnt),  
    .fft_data       (fifo_rd_data), //频谱的幅度，缩小以适应屏幕尺寸
    .fft_point_done (fft_point_done),
    .data_req       (data_req)            //请求频谱数据输入
    );
      
endmodule 