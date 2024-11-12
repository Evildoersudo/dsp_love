/* 
 * file			: FIR_firwin_generator_haimming.v
 * author		: dsp_love
 * lab			: WHU-EIS-LMSWE
 * date			: 2024-10-17
 * version		: v1.0
 * description	: 生成指定阶数、指定类型的FIR滤波窗口
 */
 //固定128阶FIR滤波器系数生成
// `default_nettype none
module FIR_firwin_generator_haimming
(
	input		wire					clk			,
	input		wire					rst_n		,
	input		wire					en_fir		,//上升沿触发窗口计算,为低电平时停止计算
	input		wire			[15:0]	fs			,//采样率
	input		wire			[15:0]	f_ln		,//滤波器过渡带下频点
	output		reg					out_valid		,//表示模块当前正在输出滤波器抽头系数,第一个系数计算完拉高，最后一个系数计算完拉低，//只有当下一次en_fir为高电平时再次拉高
	output		wire	signed	[15:0]	fir_value	,
	output		wire			[5:0]	out_cnt		,//当前滤波器系数输出的索引值
	output		reg						out_ing_valid//一个脉冲表示一个数据输出
);
parameter		fir_level=8'd100;//滤波器阶数
reg			signed		[32:0]		firwin_value_buf		;
reg			signed		[15:0]		firwin_value_buf_d0	;//8-8有符号定点数
reg									busy_reg						;
assign		fir_value=firwin_value_buf_d0	;
//定义状态机状态
localparam		S_IDLE		=		4'd1	;//空闲状态
localparam		S_CAL		=		4'd2	;//正在计算
localparam		S_END		=		4'd4	;//计算完成
reg			[3:0]		state				;//状态机寄存器
reg			[3:0]		state_new			;
     

reg				en_sin						;//cos模块的使能信号
reg 			[15:0] 	sin_phase				;//计算cos的相位值,0~65535（0~2pi）
wire			finish_sin					;//cos计算完成信号，等待finish_cos拉高即可
wire		signed	[16:0]	sin_value_real	;//计算得到的cos函数值
reg			signed	[16:0]	sin_value_reg	;
wire		[15:0]	win_value				;//窗函数值
reg			[3:0]	calcu_cnt				;//完成计算大约需要5个状态
reg		signed	[6:0]	fir_n;//当前滤波器系数的索引值，当END状态结束是加一,可作为rom的读取地址
wire		[31:0]		sample_fs_temp;
wire		[31:0]		fir_win_div_result	;
assign		sample_fs_temp={f_ln, 16'b0};
assign	out_cnt=(fir_n==7'd0)?6'd0:((fir_n-1)&6'h3F);

fir_win_div your_instance_name(
		.clk(clk), //input clk
		.rstn(rst_n), //input rstn
		.dividend(sample_fs_temp), //input [31:0] dividend
		.divisor(fs), //input [15:0] divisor
		.quotient(fir_win_div_result) //output [31:0] quotient
	);
cos_deal fir_cos (
        .clk(clk),
        .rst_n(rst_n),
        .en(en_sin),
        .phase(sin_phase),
        .finish_sin(finish_sin),
        .sin_value_real(sin_value_real)
    );
//从ROM获取窗函数值
haiming_100_rom fir_hamming_value(
        .dout(win_value), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(fir_n) //input [6:0] ad
    );
wire	signed[16:0]win_value_sd;
assign	win_value_sd={1'b0,win_value};
always @(posedge clk	or negedge rst_n)begin
	if(!rst_n)
		out_ing_valid<=1'b0;
	else if(state==S_END)
		out_ing_valid<=1'b1;
	else
		out_ing_valid<=1'b0;
end
always @(posedge clk	or negedge rst_n)begin
	if(!rst_n)
		fir_n<=7'd0;
	else if(fir_n==7'd50||en_fir==1'b0)
		fir_n<=7'd0;
	else if(state==S_END&&en_fir==1'b1)
		fir_n<=fir_n+1'b1;
	else
		fir_n<=fir_n;
end

always @(posedge clk	or negedge rst_n)begin
	if(!rst_n)
		out_valid<=1'b0;
	else if(fir_n==7'd1)//第一个滤波器系数计算完成，拉高out_valid
		out_valid<=1'b1;
	else if(fir_n==7'd50||en_fir==1'b0)
		out_valid<=1'b0;
	else
		out_valid<=out_valid;
end
		
		
	
always @(posedge clk	or negedge rst_n)begin
	if(!rst_n)
		state<=4'd0;
	else
		state<=state_new;
end
//状态机切换
always @(*)begin//posedge clk	or negedge	rst_n
	// if(!rst_n)
		// state_new<=4'd0;
	// else begin
		case(state)
		S_IDLE:begin
			if(en_fir)
				state_new<=S_CAL;
			else
				state_new<=S_IDLE;
		end
		S_CAL:begin
			if((calcu_cnt==4'd9) )
				state_new<=S_END;
			else
				state_new<=S_CAL;
		end
		S_END:begin
			state_new<=S_IDLE;
		end
		default:begin
			state_new<=S_IDLE;
		end
	endcase
	//end
end
//滤波器阶数为固定的128阶，故只需要计算64个系数即可，0~63,s=N-n/2
reg	signed[7:0]	s_mlti2;


always @(posedge clk or  negedge rst_n) begin//生成计算sin时的索引值
	if(!rst_n)begin
		s_mlti2<=8'sd0;
	end
	else if(calcu_cnt==4'd1)begin
		s_mlti2<=8'sd99-fir_n*4'sd2;
	end
	else	begin
		s_mlti2<=s_mlti2;
	end
end
//生成相位值
reg					BP_status;//用于判别是计算过渡带高频点还是低频点，带通滤波器计算相位需要两轮
//BP_status需要在判断cos是否计算完成一轮后再改变，
reg		[31:0]		multi_tmp	;//大位宽，直接用*或/可防止溢出
always @(posedge clk or  negedge rst_n) begin
	if(!rst_n)begin
		multi_tmp<=32'd0;
	end
	else if(calcu_cnt==4'd4)begin			//LP
		multi_tmp	<= ( fir_win_div_result* s_mlti2)>>1;
	end
	else
		multi_tmp<=multi_tmp;
end

always @(posedge clk or  negedge rst_n) begin
	if(!rst_n)
		sin_phase<=16'd0;
	else	if(state==S_CAL)
		sin_phase<=multi_tmp[15:0];
	else	
		sin_phase<=sin_phase;
end
//对cos计算模块进行计时，当finish_cos拉高时，calcu_cnt加一，进入下一个计算状态
//先给en_sin一个脉冲，使能cos模块
always @(posedge clk or  negedge rst_n) begin
	if(!rst_n)
		en_sin<=1'b0;
	else if(calcu_cnt==4'd5&&!en_sin)begin
		en_sin<=1'b1;
	end
	else
		en_sin<=1'b0;
end
//等待finish_cos拉高，当finish_cos拉高时，对cos模块输出的数据进行锁存

always @(posedge clk or  negedge rst_n) begin
	if(!rst_n)
		sin_value_reg<=17'sd0;
	else if(finish_sin==1'b1)
		sin_value_reg<=sin_value_real;
	else	
		sin_value_reg<=sin_value_reg;
end
reg			finish_sin_reg	;//对计算完成信号进行寄存
always @(posedge clk or  negedge rst_n) begin
	if(!rst_n)
		finish_sin_reg<=1'b0;
	else if(finish_sin==1'b1)
		finish_sin_reg<=1'b1;
	else
		finish_sin_reg<=1'b0;
end
//计算窗函数法FIR滤波器系数值
//当fin_cos_reg为高电平时，caclu_cnt加一，此时caclu_cnt为4，进行窗函数法中FIR的分子分母相除
//下一个状态即乘上窗函数值,calcu_cnt此时为5,延迟一个周期计算是为了留出计算乘法的时间
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		firwin_value_buf<=33'sd0;
	else if(calcu_cnt==4'd7)begin		//LP
		//if(fir_n==8'd63)
			//firwin_value_buf		<= (({f_ln, 16'b0} / fs) * 16'sd804) >>> 8;		//3.1415 = 804/256
		//else
		firwin_value_buf		<= (sin_value_reg*( 4'sd2)) / s_mlti2 ;
	end
	else if(calcu_cnt==4'd9)begin//当calcu_cnt等于6且计算低通滤波器时，calcu_cnt直接清零
				//LP,低通滤波器可以直接进行窗函数系数相乘
			firwin_value_buf<=(firwin_value_buf*win_value_sd)>>>16;
	end
	else 
		firwin_value_buf<=firwin_value_buf;
end
//进行calcu_cnt的更新
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		calcu_cnt<=4'd0;
	else begin
		case(state)
		S_IDLE:begin
			calcu_cnt<=4'd0;
		end
		S_CAL:begin
			case(calcu_cnt)
			4'd0,4'd1,4'd2,4'd3,4'd4,4'd5:begin
				calcu_cnt<=calcu_cnt+1'b1;
			end
			4'd6:begin
				if(finish_sin_reg==1'b1)
					calcu_cnt<=calcu_cnt+1'b1;
			end
			4'd7,4'd8,4'd9,4'd10:begin
				calcu_cnt<=calcu_cnt+1'b1;//乘法等待两个周期
			end
			4'd11:begin
				calcu_cnt<=4'd0;//计算LP滤波器，此时已经计算完成，跳转为S_END状态
			end
			default:begin
				calcu_cnt<=calcu_cnt;
			end
			endcase
		end
		S_END:begin
			calcu_cnt<=4'd0;
		end
		default:begin
			calcu_cnt<=calcu_cnt;
		end
		endcase
	end
end
//最后进行移位输出
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		firwin_value_buf_d0<=16'sd0;
	else if(state==S_END)
		firwin_value_buf_d0<=firwin_value_buf[15:0];
	else
		firwin_value_buf_d0<=firwin_value_buf_d0;
end




endmodule			











