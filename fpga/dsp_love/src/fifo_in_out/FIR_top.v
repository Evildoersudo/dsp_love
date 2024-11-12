module FIR_top
(
	input		wire			clk				,
	input		wire			rst_n			,
	input		wire	[15:0]	fs				,//采样率
	input		wire	[15:0]	f_ln			,//滤波器截止频率
	input		wire			en_fir_top		,//应一直为高电平，使能滤波器模块生成系数,out_fir_data_valid为低时拉低
	input		wire			en_fir_deal		,//当input_en为高电平时，这个信号要一直拉高，开始滤波运算
	input		wire	signed[15:0]	xin				,//输入音频信号
	output		wire	signed	[15:0]	yout			,//输出音频信号
	output		wire				input_en		,///告诉外部模块可以输入数据
	output		wire			valid				,//输出数据有效信号，高电平表示一直在输出数据
	output		wire		out_fir_data_valid		//表示模块当前正在输出滤波器抽头系数,第一个系数计算完拉高，最后一个系数计算完拉低
	
);
reg							en_fir_top_reg	;//对输入的使能信号打一拍
wire	signed	[15:0]		fir_value		;//滤波器系数
wire			[5:0]		out_cnt			;//当前滤波器系数输出的索引值
wire						out_ing_valid	;//一个脉冲表示一个数据输出

always @(posedge clk	or negedge	rst_n)begin
	if(!rst_n)
		en_fir_top_reg<=1'b0;
	else	if(en_fir_top)
		en_fir_top_reg<=1'b1;
	else
		en_fir_top_reg<=1'b0;
end




FIR_firwin_generator_haimming	FIR_firwin_generator_haimming_inst
(
	.clk			(clk				)	,
	.rst_n			(rst_n				)	,
	.en_fir			(en_fir_top_reg		)	,//高电平使能运算
	.fs				(fs					)	,//采样率
	.f_ln			(f_ln				)	,//滤波器过渡带下频点
	.out_valid		(out_fir_data_valid	)	,//表示模块当前正在输出滤波器抽头系数,第一个系数计算完拉高，最后一个系数计算完拉低
	.fir_value		(fir_value			)	,
	.out_cnt		(out_cnt			)	,//当前滤波器系数输出的索引值
	.out_ing_valid	(out_ing_valid		)		//一个脉冲表示一个数据输出
);

FIR_deal  	FIR_deal_inst
  (
    .rstn				(rst_n				)		,//复位，低有效
    .clk				(clk				)		,//工作频率，即采样频率
    .en					(en_fir_deal		)		,//输入数据有效信号，en信号如果是异步的，会造成亚稳态
    .xin				(xin				)		,//输入混合频率的信号数据
	.out_ing_valid		( out_ing_valid)		,//滤波器抽头系数输入有效信号，一个脉冲接收一个系数
	.out_cnt			(out_cnt			)		,//当前输出的滤波器抽头信号索引值，当加到FIR_level/2时不再接收信号，当fir_data_valid为低电平时，out_cnt为低电平
	.fir_data			(fir_value			)		,//当前输入的滤波器抽头系数值	
    .valid				(valid				)		,//输出数据有效信号
    .yout				(yout				)		,//输出数据，低频信号，即250KHz,滤波器系数扩大了15位
	.fir_data_rec_valid	(input_en)					//表示滤波器抽头系数接收完成，可以接收信号数据进行运算
    );



endmodule


























