module rw_fifo_ctrl(
    input             clk_50m,
    input             lcd_clk,
    input             rst_n,
    //FFT输入数据
    input      [15:0] fft_data,        //FFT频谱数据
    input             fft_sop,         //SOP包开始信号
    input             fft_eop,         //EOP包结束信号
    input             fft_valid,       //FFT频谱数据有效信号
    
    input             data_req,        //数据请求信号
    input             fft_point_done,  //FFT当前频谱绘制完成
    output reg [9:0]  fft_point_cnt,   //FFT频谱位置
    //FIFO控制端口  
    input             fifo_rd_empty,   //FIFO读空信号
    input      [9:0]  fifo_wr_cnt,     //FIFO当前缓存的数据量
    output reg        fifo_rd_req,     //FIFO读请求信号
    output     [15:0] fifo_wr_data,    //FIFO写数据
    output            fifo_wr_req      //FIFO写请求信号
);

//parameter define
parameter TRANSFORM_LEN = 1024;        //FFT采样点数:1024

//reg define
reg  [1:0]    wr_state;
reg  [9:0]    wr_cnt;
reg           wr_en;
reg           fft_valid_r;
reg  [15:0]   fft_data_r;

//*****************************************************
//**                    main code
//***************************************************** 

//产生fifo写请求信号
assign fifo_wr_req  = fft_valid_r && wr_en;
assign fifo_wr_data = fft_data_r;

//将数据与有效信号延时一个时钟周期
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        fft_data_r  <= 16'd0;
        fft_valid_r <= 1'b0;
    end
    else begin
        fft_data_r  <= fft_data;
        fft_valid_r <= fft_valid;
    end     
end

//控制FIFO写端口，每次向FIFO中写入前半帧（512个）数据
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        wr_state <= 2'd0;
        wr_en    <= 1'b0;
        wr_cnt   <= 10'd0;
    end
    else begin
        case(wr_state)
            2'd0: begin             //等待一帧数据的开始信号
                if(fft_sop) begin   //进入写数据过程，拉高写使能wr_en
                    wr_state <= 2'd1; 
                    wr_en    <= 1'b1;
                end
                else begin          
                    wr_state <= 2'd0;
                    wr_en    <= 1'b0;
                end
            end
            2'd1: begin             
                if(fifo_wr_req)     //对写入FIFO中的数据计数
                    wr_cnt   <= wr_cnt + 1'b1;
                else
                    wr_cnt   <= wr_cnt;
                                    //由于FFT得到的数据具有对称性，因此只取一帧数据的一半
                if(wr_cnt < TRANSFORM_LEN/2 - 1'b1) begin
                    wr_en    <= 1'b1;
                    wr_state <= 2'd1;
                end
                else begin
                    wr_en    <= 1'b0;
                    wr_state <= 2'd2;
                end
            end
            2'd2: begin             //当FIFO中的数据被读出一半的时候，进入下一帧数据写过程
                if(fifo_wr_cnt == TRANSFORM_LEN/4) begin
                    wr_cnt   <= 10'd0;
                    wr_state <= 2'd0;
                end
                else 
                    wr_state <= 2'd2;
            end
            default: 
                    wr_state <= 2'd0;
        endcase
    end     
end

//产生FIFO读请求信号和当前从FIFO中读到的第几个点，fft_point_cnt（0~512-1）
always @(posedge lcd_clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_rd_req <= 1'b0;
        fft_point_cnt <= 10'b0;
    end
    else begin
        if(!fifo_rd_empty) begin   //FIFO非空
            fifo_rd_req <= data_req;
            if(fft_point_done) begin
                if(fft_point_cnt == TRANSFORM_LEN/2 - 1)
                    fft_point_cnt <= 1'b0;
                else
                    fft_point_cnt <= fft_point_cnt + 1'b1;            
            end            
        end    
    end
end

endmodule 
