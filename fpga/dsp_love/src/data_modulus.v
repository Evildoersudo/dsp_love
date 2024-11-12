module data_modulus(
    input             clk_50m,
    input             rst_n,
    //FFT ST接口
    input   [15:0]    source_real,
    input   [15:0]    source_imag,
    input             source_sop,
    input             source_eop,
    input             source_valid,
    //取模运算后的数据接口
    output  [15:0]    data_modulus,  
    output            data_sop,
    output            data_eop,
    output            data_valid
);

//*****************************************************
//**                    main code
//***************************************************** 

//取实部和虚部的平方和
reg  [31:0] amp_reg; 
reg  [15:0] data_real; 
reg  [15:0] data_imag;
always @ (posedge clk_50m or negedge rst_n) begin 
    if(!rst_n) begin 
        amp_reg <= 32'd0; 
        data_real   <= 16'd0; 
        data_imag   <= 16'd0; 
    end 
    else begin 
        if(source_real[15]==1'b0)               //由补码计算原码 
            data_real <= source_real; 
        else 
            data_real <= ~source_real + 1'b1; 
             
        if(source_imag[15]==1'b0)               //由补码计算原码 
           data_imag <= source_imag; 
        else 
            data_imag <= ~source_imag + 1'b1;             
                                                 //计算原码平方和 
        amp_reg <= (data_real*data_real) + (data_imag*data_imag); 
    end 
end
  
//对信号进行打拍
reg [18:0] source_valid_d;
reg [18:0] source_eop_d;
reg [18:0] source_sop_d;
assign data_eop = source_eop_d[18];
assign data_sop = source_sop_d[18];
assign data_valid = source_valid_d[18];

always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        source_eop_d <= 19'd0;
        source_valid_d <= 19'd0;
        source_sop_d <= 19'd0;
    end
    else begin
        source_valid_d <= {source_valid_d[17:0],source_valid};
        source_eop_d <= {source_eop_d[17:0],source_eop};
        source_sop_d <= {source_sop_d[17:0],source_sop};
    end
end


//例化sqrt模块,开根号运算
sqrt sqrt_inst 
(
    .clk(clk_50m),
    .rst_n(rst_n),
    .i_vaild(1'b1),
    .data_i(amp_reg),
    .data_o(data_modulus)
 );

endmodule 