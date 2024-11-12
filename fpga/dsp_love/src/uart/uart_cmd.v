`timescale 1ns/1ns

module uart_cmd(
    Clk,
    Reset_n,
    rx_data,
    rx_done,
    //ctrl,
    K
);
    
    input Clk;
    input Reset_n;
    input [7:0]rx_data;
    input rx_done;
    //output reg[7:0]ctrl;
    //output reg[15:0]sample_fs;
    output	reg	[3:0]K;
    reg [7:0] data_str [7:0];
	//output reg	[1:0]up_or_down;//1表示升采样，2表示降采样
    always@(posedge Clk)
    if(rx_done)begin
        data_str[7] <=  rx_data;
        data_str[6] <=  data_str[7];
        data_str[5] <=  data_str[6];
        data_str[4] <=  data_str[5];
        data_str[3] <=  data_str[4];
        data_str[2] <=  data_str[3];
        data_str[1] <=  data_str[2];
        data_str[0] <=  data_str[1];        
    end
    
    reg r_rx_done;
    always@(posedge Clk)
        r_rx_done <= rx_done;
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n) begin
        //ctrl <= #1 0;
       K<=0;
	end
	else if(r_rx_done&&(data_str[0] == 8'h55) && (data_str[1] == 8'hA5))begin
         if(data_str[2] == 8'hA6)begin
            K <=  data_str[5][3:0]-1'b1;
            //ctrl <= #1 data_str[2];
        end
		if(data_str[2] == 8'hA7)begin
            K <=  0;
            //ctrl <= #1 data_str[2];
        end
		else begin
			 K<=K;
		end
    end    
    
endmodule
