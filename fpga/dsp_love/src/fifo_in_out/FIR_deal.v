/*作者：dsp_love*/
/*===================
本模块实现了接收外部发送的滤波器抽头系数以及信号，进行FIR滤波器运算，并输出。
Fir模块输入的数据应该由fifo输出，输出时钟为12.5Mhz。因为128阶fir模块例化了16个硬核乘法器，要算64个乘法，四个50Mhz时钟周期才能算完一次滤波数据。故需要使输入的数据每隔四个50Mhz的时钟周期输入一次。
同样fir模块输出的数据也应该输出到fifo然后给到wm8960
*/
module FIR_deal  
  (
    input                		rstn				,  //复位，低有效
    input                		clk					,   //工作频率，即采样频率
    input                		en					,    //输入数据有效信号，en信号如果是异步的，会造成亚稳态
    input 	 	signed		[15:0]  xin					,   //输入混合频率的信号数据
	input				 		out_ing_valid		,//滤波器抽头系数输入有效信号，高电平表示一直在输入系数
	input		 		[5:0]	out_cnt				,//当前输出的滤波器抽头信号索引值，当加到FIR_level/2时不再接收信号，当fir_data_valid为低电平时，out_cnt为低电平
	input 	signed 		[15:0]	fir_data			,//当前输入的滤波器抽头系数值	
    output 	wire       			valid				, //输出数据有效信号
    output 	reg signed	[15:0]  	yout				,   //输出数据，低频信号，即250KHz,滤波器系数扩大了15位
	output	reg					fir_data_rec_valid	//表示滤波器抽头系数接收完成，可以接收信号数据进行运算
    );
parameter FIR_level=100;
reg		[5:0]	mult_cnt	;
reg				fir_data_wre		;
wire	signed[15:0]		fir_data_reg_add;
reg		signed[15:0]		fir_data_reg_add_temp	;
reg             valid_mult_r ;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
		fir_data_wre<=1'b0;
	end
	else if(out_ing_valid&&out_cnt!=6'd49)
		fir_data_wre<=1'b1;
	else if(en)
		fir_data_wre<=1'b0;
	else
		fir_data_wre<=fir_data_wre;
end
	
fir_data fir_data_ram(
        .dout(fir_data_reg_add), //output [15:0] dout
        .wre(fir_data_wre), //input wre
        .wad(out_cnt), //input [5:0] wad
        .di(fir_data), //input [15:0] di
        .rad(mult_cnt), //input [5:0] rad
        .clk(clk) //input clk
);
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
		fir_data_reg_add_temp<=16'sd0;
	end
	else
		fir_data_reg_add_temp<=fir_data_reg_add;
end

//当滤波器系数输入完成后，fir_data_rec_valid输出一个脉冲,存储波形数据模块接收后，将en拉高，此模块开始滤波器计算
always @(posedge clk or negedge rstn) begin
    if (!rstn) 
		fir_data_rec_valid<=1'b0;
	else if(out_cnt==6'd49&&out_ing_valid==1'b1)
		fir_data_rec_valid<=1'b1;
	else
		fir_data_rec_valid<=fir_data_rec_valid;
end

//data en delay 
reg [3:0]            en_r ;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        en_r[3:0]      <= 'b0 ;
    end
    else begin
        en_r[3:0]      <= {en_r[2:0], en} ;
    end
end      

//(1) FIR_level 组移位寄存器
reg   signed    [15:0]    xin_reg[FIR_level-1:0];
reg [8:0]            i, j ;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        for (i=0; i<(FIR_level-1); i=i+1) begin
            xin_reg[i]  <= 16'sd0;
        end
    end
    else if (en&&mult_cnt==7'd49) begin
        xin_reg[0] <= xin ;
        for (j=0; j<(FIR_level-1); j=j+1) begin
            xin_reg[j+1] <= xin_reg[j] ; //周期性移位操作
        end
    end
end

//Only 8 multipliers needed because of the symmetry of FIR filter coefficient
//(2) 系数对称，16个移位寄存器数据进行首位相加
reg   signed     [15:0]    add_reg;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        add_reg<= 16'sd0 ;
    end
    else if (en_r[0]) begin
        add_reg <= xin_reg[mult_cnt] + xin_reg[FIR_level-1-mult_cnt] ;
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) 
		mult_cnt<=7'd0;
	else if(mult_cnt==7'd49)
		mult_cnt<=7'd0;
	else if(en_r[1])begin
		mult_cnt<=mult_cnt+1'b1;
	end
	else
		mult_cnt<=mult_cnt;
end
//在乘法器外部对乘法器输入的数据进行寄存

//流水线式乘法器
 wire   signed     [31:0]   mout_wire; 
 //reg	signed		[30:0]	mout_reg[3:0];//定义一个长度为四的数组，每个周期输出的mout_wire给到一个mout_reg，在第四个周期进行累加
fir_mult fir_mult_inst(//一个时钟周期就可以算完
	.dout(mout_wire), //output [31:0] dout
	.a(add_reg), //input [15:0] a		
	.b(fir_data_reg_add_temp), //input [15:0] b
	.clk(clk), //input clk
	.ce(en_r[1]), //input ce,时钟使能信号
	.reset(~rstn) //input reset
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) 
		valid_mult_r<=1'b0;
	else if(valid_mult_r==1'b1)
		valid_mult_r<=1'b0;//计算完成后立即清零
	else if(en_r[1])
		valid_mult_r<=1'b1;//因为乘法器计算只需要一个时钟周期，只需要对使能信号打一拍即可
	else
		valid_mult_r<=valid_mult_r;
end
reg		signed	[33:0]yout_t_reg_add;

always @(posedge clk or negedge rstn)begin
	if(!rstn)
		yout_t_reg_add<=34'sd0;
	else if(mult_cnt==7'd1&&valid_mult_r)
		yout_t_reg_add<=mout_wire;
	else 
		yout_t_reg_add<=yout_t_reg_add+mout_wire;
end
reg done; // 标志信号，用于检测计数器是否已经到达 99
reg		[6:0]count;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        count <= 7'd0;    // 复位时计数器清零
        done <= 1'b0;     // 清除已完成标志
    end
    else if (valid_mult_r&&mult_cnt==7'd1 && !done) begin
        if (count < 7'd99) begin
            count <= count + 1'b1; // en 高且未到达 99 时自增
        end
        else begin
            count <= 7'd0;    // 达到 99 时清零
            done <= 1'b1;     // 标志为已完成，停止计数
        end
    end
end
//流水线算完之后再将yout_t_reg进行累加
always @(posedge clk or negedge rstn)begin
	if(!rstn)
		yout<=16'sd0;
	else if(valid_mult_r&&mult_cnt==7'd1&&done)
		yout<=yout_t_reg_add>>>16;//滤波器系数扩大了15位，结果需减少15位,这里可能需要修改成右移15位
	else 
		yout<=yout;
end
assign 	valid = valid_mult_r&&(mult_cnt==7'd1);

endmodule