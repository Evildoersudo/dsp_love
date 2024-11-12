`timescale 1ns/1ps
module  fft_tb;

reg     clk     ;
reg     rst     ;
reg     start   ;
localparam  WIDTH=16;
wire			[9:0]		     idx     ;
wire					    sod     ;//时域启动信号 
wire					    ipd     ;//表示正在采样输入数据
wire					    busy    ;//表示正在进行fft运算
wire					    data_soud    ;//表示正在卸载第一个数据
wire					    data_opd     ;//表示正输出的数据有效
wire					    data_eoud 	;   //表示完成数据卸载
wire					     eod; //表示数据输入完成
wire    [16:0]                amp;
wire      [WIDTH-1:0] xk_re      ;//输出数据的实部
wire     [WIDTH-1:0] xk_im      ;//输出的数据虚部

initial begin
    clk=0;
    forever #10 clk=~clk;
end
initial begin
    rst=1'b0;
    #20
    rst=1'b1;
    #20
    rst=1'b0;
end
initial begin
    start=1'b0;
    #50
    start=1'b1;
    #40
    start=1'b0;
	#5000000;
	$finish;
end
GSR GSR(.GSRI(1'b1));
FFT_TOP   
#(.WIDTH(WIDTH))
FFT_first_Inst
(
.clk    (clk    )      ,
.rst    (rst    )          ,
.start  (start  )      ,//FFT运算使能信号，高电平有效
.xk_re  (xk_re  )      ,//输出数据的实部
.xk_im  (xk_im  )          ,//输出的数据虚部
.idx    (idx    )      ,
.sod    (sod    )      ,//时域启动信号 
.ipd    (ipd    )      ,//表示正在采样输入数据
.busy   (busy   )      ,//表示正在进行fft运算
.data_soud   (data_soud   )      ,//表示正在卸载第一个数据
.data_opd    (data_opd    )      ,//表示正输出的数据有效
.data_eoud 	(data_eoud 	)      ,   //表示完成数据卸载
.eod    (eod    )  , //表示数据输入完成
.amp    (amp)
);
// initial	begin
	// $fsdbDumpfile("fft.fsdb");
	// $fsdbDumpvars;
// end

endmodule