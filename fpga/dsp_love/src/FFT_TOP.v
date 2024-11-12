module FFT_TOP
#(parameter WIDTH=16)
(
    input    wire                       clk    ,
    input    wire                       rst     ,
    input    wire                       fft_rst ,
    input    wire                       start     ,//FFT运算使能信号，高电平有效
    input    wire              [WIDTH-1:0]   xn_re,//FFT输入数据
//    output   wire    signed  [WIDTH-1:0] xk_re      ,//输出数据的实部
//    output   wire    signed  [WIDTH-1:0] xk_im      ,//输出的数据虚部
//    output   reg                        FFT_IT,     //高电平有效，表示转换完成
//    output      wire			[9:0]		     idx     ,
//	input      wire					    sod     ,//时域启动信号 
//	input      wire					    ipd     ,//表示正在采样输入数据
//	input		wire					     eod, //表示数据输入完成
//	output      wire					    busy    ,//表示正在进行fft运算
	output      wire					    data_soud    ,//表示正在卸载第一个数据
	output      wire					    data_opd     ,//表示正输出的数据有效
	output      wire					    data_eoud 	,   //表示完成数据卸载
    output      wire    [15:0]                amp
);

wire    [WIDTH-1:0]xk_re;
wire    [WIDTH-1:0]xk_im;
wire    [WIDTH-1:0]xn_im;
assign xn_im=16'd0;//对输入的数据虚部直接赋值0
wire soud;
wire opd;
wire eoud;


// always @(posedge    clk or negedge  rst)
// begin
    // if(!rst)
        // idx_reg<=10'd0;
    // else    if(ipd==1'b1)//ipd为高电平表示正在输入数据
    // begin
        // if(idx_reg==11'd1024)
            // idx_reg<=10'd0;
        // else
            // idx_reg<=idx_reg+1'b1;
    // end
    // else
        // idx_reg<=10'd0;
// end
/*
FFT_div FFT_clock_div(//五分频
        .clkout(clk_fft), //output clkout0
        .hclkin(clk), //input clkin
		.resetn(~rst)
    );
*/
/*
FFT_Rom_out   U_fft_rom
(
   .clk  (clk ),
   .rst  (rst ),
   .ipd  (ipd ),
   .dout (xn_re)
);
*/
   
FFT_first FFT_Top_Inst(
//		.idx(idx), //output [9:0] idx 装载数据是指示下一个触发沿要装在的数据序列位置
		.xk_re(xk_re), //output [15:0] xk_re,转换后序列的实部
		.xk_im(xk_im), //output [15:0] xk_im
//		.sod(sod), //output sodq，时域启动信号，高电平有效，表示下一个触发边沿开始将采样数据输入
//		.ipd(ipd), //output ipd，高电平有效，表示正在采样输入数据
//		.eod(eod), //output eod，高电平有效，表示数据输入完成
//		.busy(busy), //output busy，高电平有效，表示正在进行fft运算
		.soud(soud), //output soud=，高电平有效，表示正在卸载第一个数据
		.opd(opd), //output opd，高电平有效，表示正输出的数据有效
		.eoud(eoud), //output eoud，高电平有效，表示完成数据卸载
		.xn_re(xn_re), //input [15:0] xn_re
		.xn_im(xn_im), //input [15:0] xn_im
		.start(start), //input start，同步启动信号，高电平有效，至少保持一个时钟周期，只在内核空闲时采样，启动一次变换
//		.clk(clk_fft), //input clk
        .clk(clk),
		.rst(fft_rst) //input rst
	);
	
//计算幅值
data_modulus data_modulus(
    .clk_50m(clk),
    .rst_n(!rst),
    //FFT ST接口
    .source_real(xk_re),
    .source_imag(xk_im),
    .source_sop(soud),
    .source_eop(eoud),
    .source_valid(opd),
    //取模运算后的数据接口
    .data_modulus(amp),  
    .data_sop(data_soud),
    .data_eop(data_eoud),
    .data_valid(data_opd)
);

endmodule