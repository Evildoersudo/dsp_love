module FFT_Rom_out(//接受输入数据使能信号，输出rom的一个16位二进制数据
    clk     ,
    rst     ,
    ipd     ,
    dout    );
input           clk     ;
input           rst     ;
input           ipd     ;
output   wire[15:0]dout  ;
reg     [9:0]   addr    ;

always @(posedge clk or posedge rst)
begin
    if(rst)
        addr<=10'd0;
    else    if(ipd)
        addr<=addr+1'b1;
end 



fft_rom2 u_FFT_data
(
    .dout(dout),
    .clk(clk),
    .oce(1'b1),
    .ce(ipd),
    .reset(rst),
    .ad(addr)
);
endmodule

