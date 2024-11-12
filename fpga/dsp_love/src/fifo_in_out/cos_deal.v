//该模块实现了将0~65535（0~2pi)映射到 0-51472（0~pi/2)
//输出-32768~32768（-1~1）
module cos_deal
(
	input		clk			,
	input		rst_n		,
	input		en			,//使能信号,只需要维持一个高电平
	input		[15:0]phase		,
	output	reg	finish_sin	,//cos计算完成信号，维持一个周期的高电平
	output	signed	[16:0]	sin_value_real
);

wire	signed	[16:0]		cos_value;
wire	signed	[16:0]		sin_value;
reg							en_reg	;//对使能信号打拍
reg						en_temp;
reg				[32:0]		phase_deal;
wire	signed	[16:0]		theta_i;
reg				[16:0]		x_i,y_i	;

reg							init	;
reg				[5:0]		cos_cnt	;//计算cos需要十六个周期，故用此计数器计时十六个周期
reg							counting;
reg				[15:0]		phase_mapped;
always	@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
		en_reg<=1'b0;
		en_temp<=1'b0;
	end
	else	begin
		en_temp<=en;
		en_reg<=en_temp;
	end
end
always	@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
		phase_mapped<=16'd0;
	end
	else if(en)begin
		if (phase <= 16'd16384) begin  // 0 ~ pi/2
			phase_mapped = phase;
		end else if (phase <= 16'd32768) begin  // pi/2 ~ pi
			phase_mapped = 16'd32768 - phase;  // 映射到 pi/2
		end else if (phase <= 16'd49152) begin  // pi ~ 1.5pi
			phase_mapped = phase - 16'd32768;   // 映射到 -pi/2
		end else begin  // 1.5pi ~ 2pi
			phase_mapped = 16'd65535 - phase;  // 映射到 -pi/2
		end
	end
end
always	@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        x_i<=0;
        y_i<=0;
	end
     else begin
        x_i<=17'd19898;
        y_i<=0;
    end
end
//使能信号为高电平
always	@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		init<=1'b0;
	else if(en_reg==1'b1)begin
		init<=1'b1;
	end
	else
		init<=1'b0;
end
//当使能信号输入时，计数器同步开始计数
always	@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counting<=1'b0;
		cos_cnt<=6'd0;
	end
	else if(init&&!counting)begin
	//当en_reg为高电平且没有开始计数时，开始计数
		counting<=1'b1;
		cos_cnt<=6'd1;
	end
	else if(counting)begin
		if(cos_cnt==6'd16)begin
			cos_cnt<=6'd0;
			counting<=1'b0;
		end 
		else begin
		cos_cnt<=cos_cnt+1'b1;
		end
	end
end
//当计数器计时了16个周期，finish_cos拉高电平一个周期
always	@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		finish_sin<=1'b0;
	else if(cos_cnt==6'd16)
		finish_sin<=1'b1;
	else
		finish_sin<=1'b0;
end
//当en为高电平时，进行数据的映射
always	@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		phase_deal<=33'd0;
	else if(en)
		phase_deal <= (phase_mapped << 15) + (phase_mapped << 14) + 
              (phase_mapped << 11) + (phase_mapped << 8) + 
              (phase_mapped << 4);

	else
		phase_deal<=phase_deal;
end
assign	theta_i=phase_deal[29:0]>>14;
wire	signed	[16:0]	theta_o				;
wire	signed	[16:0]	y_o				;
// assign cos_value_real=(phase>16'd16384&&phase<16'd49152)?(-cos_value):cos_value;
assign sin_value_real=(phase>16'd32768&&phase<16'd65535)?(-sin_value):sin_value;
cordic_cos cos_inst(
		.clk(clk), //input clk
		.rst(~rst_n), //input rst
		.init(init), //input init
		.x_i(x_i), //input [16:0] x_i
		.y_i(y_i), //input [16:0] y_i
		.theta_i(theta_i), //input [16:0] theta_i
		.x_o(cos_value), //output [16:0] x_o
		.y_o(sin_value), //output [16:0] y_o
		.theta_o(theta_o) //output [16:0] theta_o
	);

endmodule