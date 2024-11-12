module audio_lookback(
		input clk,                    
		input reset_n,                                   
		inout iic_0_scl,              
		inout iic_0_sda,   
	    output led,
		
		input I2S_ADCDAT,
		input I2S_ADCLRC,
		input I2S_BCLK,
		output I2S_DACDAT,
		input I2S_DACLRC,
		output I2S_MCLK,
        input  [3:0] K,
        output	wire	[15:0] dac_data_positive
);

	parameter DATA_WIDTH        = 32;     
	
    Gowin_PLL Gowin_PLL(
        .clkout0(I2S_MCLK), //output clkout0
        .clkin(clk) //input clkin
    );
	
 	wire Init_Done;
	WM8960_Init WM8960_Init(
		.Clk(clk),
		.Rst_n(reset_n),
		.I2C_Init_Done(Init_Done),
		.i2c_sclk(iic_0_scl),
		.i2c_sdat(iic_0_sda)
	);
	
	assign led = Init_Done;
	
	reg adcfifo_read;
	wire [DATA_WIDTH - 1:0] adcfifo_readdata;
	wire adcfifo_empty;

	reg dacfifo_write;
	reg [DATA_WIDTH - 1:0] dacfifo_writedata;
	wire dacfifo_full;

    //取出一个声道音频作为输出
    reg [15:0] dacfifo_writedata111;
	assign dac_data_positive=dacfifo_writedata111;
    always@(posedge clk) begin
        dacfifo_writedata111 <= dacfifo_writedata[15:0];
    end
	
	always @ (posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		begin
			adcfifo_read <= 1'b0;
		end
		else if (~adcfifo_empty)
		begin
			adcfifo_read <= 1'b1;
		end
		else
		begin
			adcfifo_read <= 1'b0;
		end
	end
    reg [3:0]dacfifo_write111;
	always @ (posedge clk or negedge reset_n)
	begin
		if(~reset_n)
			dacfifo_write111 <= 1'd0;
		else if(~dacfifo_full && (~adcfifo_empty)) begin
            if(K == 4'b0) begin
                dacfifo_writedata <= adcfifo_readdata;
                dacfifo_write <= 1'd1;
            end
            else begin
                if(dacfifo_write111 == 1'd0) begin
                    dacfifo_write111 <= dacfifo_write111 + 1'b1;
                    dacfifo_writedata <= adcfifo_readdata;
                    dacfifo_write <= 1'd1;
                end
                else if(dacfifo_write111 == K) begin
                    dacfifo_write111 <= 3'b0;
                    dacfifo_writedata <= adcfifo_readdata;
                    dacfifo_write <= 1'd0;
                end
                else begin
                    dacfifo_write111 <= dacfifo_write111 + 1'b1;
                    dacfifo_writedata <= adcfifo_readdata;
                    dacfifo_write <= 1'd0;
                end
            end
		end
		else begin
			dacfifo_write <= 1'd0;
		end
	end

	i2s_rx 
	#(
		.DATA_WIDTH(DATA_WIDTH) 
	)i2s_rx
	(
		.reset_n(reset_n),
		.bclk(I2S_BCLK),
		.adclrc(I2S_ADCLRC),
		.adcdat(I2S_ADCDAT),
		.adcfifo_rdclk(clk),
		.adcfifo_read(adcfifo_read),
		.adcfifo_empty(adcfifo_empty),
		.adcfifo_readdata(adcfifo_readdata)
	);
	
	i2s_tx
	#(
		 .DATA_WIDTH(DATA_WIDTH)
	)i2s_tx
	(
		 .reset_n(reset_n),
		 .dacfifo_wrclk(clk),
		 .dacfifo_wren(dacfifo_write),
		 .dacfifo_wrdata(dacfifo_writedata),
		 .dacfifo_full(dacfifo_full),
		 .bclk(I2S_BCLK),
		 .daclrc(I2S_DACLRC),
		 .dacdat(I2S_DACDAT)
	);

		 
endmodule
