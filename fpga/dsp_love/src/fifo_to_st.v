module fifo_to_st(
    input      clk_50m,
    input      rst_n,
    //FIFO读控制接口
    input fifo_full,    //fifo写满信号
    output  reg   start,     //开始FFT转换
    output  reg   rd_en,       //开始读取FIFO数据
    //FFT复位信号
    output reg fft_rst_n       //FFT 复位信号
);

//parameter define
parameter TRANSFORM_LEN = 1024; //FFT采样点数:1024

//reg define
reg  [1:0]      state;
reg  [4:0]  delay_cnt;
reg  [10:0]  fft_cnt;   

//*****************************************************
//**                    main code
//***************************************************** 


//产生驱动FFT ip核的控制信号
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        state     <= 2'd0;
        rd_en     <= 1'b0;
        fft_rst_n <= 1'b0;
        fft_cnt   <= 10'd0;
        delay_cnt <= 5'd0;
        start <= 1'b0;
    end
    else begin
        case(state)
            2'd0:begin
                fft_cnt   <= 10'd0;
                if(delay_cnt < 5'd31) begin //延时32个时钟周期，用于FFT复位
                    delay_cnt <= delay_cnt + 1'b1;
                    fft_rst_n <= 1'b0;
                end
                else begin
                    state <= 1'b1;
                    fft_rst_n <= 1'b1;
                end
            end
            2'd1:begin
                if(fifo_full)
                    state <=2'd2;
                else
                    state <=2'd1;
            end
            2'd2: begin
                start <= 1'd1;
                rd_en <= 1'd1;
                state <=2'd3;
            end
            2'd3:begin
                start <= 1'd0;
                if(fft_cnt < TRANSFORM_LEN)
                    fft_cnt <= fft_cnt + 1'b1;
                else begin
                    fft_cnt <= 10'd0;
                    state <= 2'd1;
                    rd_en <= 1'd0;
                end
            end
            default: state <= 2'd0;
        endcase
    end
end

endmodule 