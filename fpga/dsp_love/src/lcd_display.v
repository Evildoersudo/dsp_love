module lcd_display(
    input                lcd_pclk,       //时钟
    input                rst_n,          //复位，低电平有效
    input        [10:0]  pixel_xpos,     //当前像素点横坐标
    input        [10:0]  pixel_ypos,     //当前像素点纵坐标  
    input        [10:0]  h_disp,         //LCD屏水平分辨率
    input        [10:0]  v_disp,         //LCD屏垂直分辨率       
    output       [15:0]  pixel_data,     //像素数据
    
    //FFT请求和数据接口
    input        [9:0]   fft_point_cnt,  //FFT频谱位置
    input        [15:0]  fft_data,       //FFT频率幅值
    output               fft_point_done, //FFT当前频谱绘制完成
    output               data_req        //请求数据信号
    );

//parameter define            
localparam BLACK  = 16'b00000_000000_00000;     //RGB565 黑色
localparam WHITE  = 16'b11111_111111_11111;     //RGB565 白色
localparam BLUE  = 16'b00000_000000_11111;     //RGB565 白色

//*****************************************************
//**                    main code
//*****************************************************

//请求像素数据信号
assign data_req = ((pixel_ypos == fft_point_cnt + 7'd78)
                    && (pixel_xpos == h_disp - 1)) ? 1'b1 : 1'b0;

//在要显示图像的列，显示fft_data长度的条纹
assign pixel_data = ((pixel_ypos == fft_point_cnt + 7'd78)
                    && (pixel_xpos <= fft_data[11:2]<<2)) ? BLUE : WHITE;                                 

//fft_point_done标志着一个频点上的频谱绘制完成,该信号会触发fft_point_cnt加1
assign fft_point_done  = ((pixel_ypos == fft_point_cnt + 7'd78)
                    && (pixel_xpos == h_disp - 1)) ? 1'b1 : 1'b0;                    
                    
endmodule 