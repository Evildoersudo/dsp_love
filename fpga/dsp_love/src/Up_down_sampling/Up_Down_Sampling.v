module Up_Down_Sampling(
    input               Clk,
    input               Rst_n,
    input               Write_en,
    input               N_Judege,//此为用于判断是升采样还是降采样
    input   [15:0]      Q_in,
    
    output  reg [15:0]  Q_out,
    input   [3:0]       V,
    input               Read_en,
    output              Sampling_Empty,
    output              Sampling_Full,
    input               Write_Clk,//输入fifo用
    input               Read_Clk
);

    reg                 Sampling_Empty1;//用于标志实际待输出区
    reg                 Sampling_Full1;//用于标志实际待输出区
    
    reg                 Write_en1;//用于写入实际待输出区
    reg                 Read_en1;//用于读出实际fifo
    wire                Fifo_Empty;

    reg [9:0]           Output_Pin;
    reg [9:0]           Input_Pin;
    reg  [15:0]          Sampling_Cun[256:0];
    reg [3:0]           Add_Lei;
	reg [15:0]          Q_last;
    wire[15:0]          Q_o;
    reg [15:0]          Sampling_Input;
    assign Sampling_Empty = Sampling_Empty1;
    assign Sampling_Full = ((Input_Pin + 10'b1) == Output_Pin) ||(Input_Pin == 10'hff && Output_Pin == 10'B0);//Sampling_Full1;
    always @ (posedge Clk or negedge Rst_n) begin//shuruzhizhen指针
        if ( ~Rst_n ) begin
            Input_Pin <= 10'b0;
            Sampling_Full1 <= 1'b0;
        end

        else if (Write_en1) begin

            if(Sampling_Full )begin
                // if( Input_Pin +1'b1 != Output_Pin ) begin
                    // Sampling_Full1 <= 1'b0;
                // end
            end

			// else if( ((Input_Pin + 10'b1) == Output_Pin) ||(Input_Pin == 10'hff && Output_Pin == 10'B0)) begin
				// Sampling_Full1 <= 1'b1;        
			// end

            else if( Input_Pin == 10'hff) begin
                Sampling_Cun [ Input_Pin ] <= Sampling_Input;
                Input_Pin <= 10'b0;

            end
            else begin
                Input_Pin <= Input_Pin + 1'b1;
                Sampling_Cun [ Input_Pin ] <= Sampling_Input;
            end
        end
    end

    always @ (posedge Read_Clk or negedge Rst_n) begin//shuchuzhizhen
        if ( ~Rst_n ) begin 
            Output_Pin <= 10'b0;
            Sampling_Empty1 <= 1'b0;
            Q_out <= 16'b0;
        end
        else if ( Read_en ) begin

            if(Sampling_Empty1 == 1'b1)begin
                if( Input_Pin != Output_Pin ) begin
                    Sampling_Empty1 <= 1'b0;
                end
            end
            else if( Output_Pin == Input_Pin ) begin
                Sampling_Empty1 <= 1'b1;
            end
            else if( Output_Pin == 10'hff ) begin

                Q_out <= Sampling_Cun [ Output_Pin ]; 
                Output_Pin <= 10'b0;
            end
           
            else begin
                Q_out <= Sampling_Cun [ Output_Pin ]; 
                Output_Pin <= Output_Pin + 1'b1;
            end
        end
    end

    always @ (posedge Clk or negedge Rst_n) begin//shurubianhua
        if ( ~Rst_n ) begin 
            Add_Lei <= 4'b0;
            Write_en1 <= 1'b0;
            Read_en1 <= 1'b0;
			Q_last <= 16'b0;
        end
        else if ( N_Judege == 1'b0 ) begin//shengcaiyangg升采样
            if ( Add_Lei == 0) begin

                    if ( ~Sampling_Full && ~Fifo_Empty) begin
                        Read_en1 <= 1'b1;
                        if(V != 0) begin
                            Add_Lei <= Add_Lei + 1'b1;
                        end
                        Write_en1 <= 1'b1;
                        Sampling_Input <= Q_o;

                    end
                    else begin
                        Read_en1 <= 1'b0;
                        Write_en1 <= 1'b0; 
                    end

            end

            else if(  Add_Lei == V) begin
                Read_en1 <= 1'b0;
                if ( ~Sampling_Full ) begin
                    Add_Lei <= 4'b0;
                    Write_en1 <= 1'b1;
                    Sampling_Input <= 16'b0;
                end
                else begin
                    Write_en1 <= 1'b0; 
                end
            end

            else begin
                Read_en1 <= 1'b0;
                if ( ~Sampling_Full ) begin
                    Add_Lei <= Add_Lei + 1'b1;
                    Write_en1 <= 1'b1;
                    Sampling_Input <= 16'b0;
                end
                else begin
                    Write_en1 <= 1'b0; 
                end
            end
        end
        else if ( N_Judege == 1'b1 ) begin//shengcaiyanggjiang采样
            if ( Add_Lei == 0) begin
                if ( ~Sampling_Full && ~Fifo_Empty) begin
                    Read_en1 <= 1'b1;
                    Add_Lei <= Add_Lei + 1'b1;
                    Write_en1 <= 1'b1;
                    Sampling_Input <= Q_o;
											Q_last <= Q_o;
                end
                else begin
					Read_en1 <= 1'b0;
					Write_en1 <= 1'b0; 
                end
            end
            else if(  Add_Lei == V) begin
			if(Q_last != Q_o) begin
                if ( ~Sampling_Full &&~Fifo_Empty) begin
                    Read_en1 <= 1'b1;
                    Add_Lei <= 4'b0;
                    Write_en1 <= 1'b0;
                    Sampling_Input <= Q_o;
											Q_last <= Q_o;
                end
                else begin
                    Read_en1 <= 1'b0;
                    Write_en1 <= 1'b0;
                end
			end
            end
            else begin
			if(Q_last != Q_o) begin
                if ( ~Sampling_Full && ~Fifo_Empty) begin
                    Read_en1 <= 1'b1;
                    Add_Lei <= Add_Lei + 1'b1;
                    Write_en1 <= 1'b0;
                    Sampling_Input <= Q_o;
											Q_last <= Q_o;
                end
                else begin
                    Read_en1 <= 1'b0;
                    Write_en1 <= 1'b0; 
                end
			end
            end
        end
    end

    fifo_input fifo_input1(
		.Data(Q_in), //input [15:0] Data
		.WrClk(Write_Clk), //input WrClk
		.RdClk(Clk), //input RdClk
		.WrEn(Write_en), //input WrEn
		.RdEn(Read_en1), //input RdEn
		.AlmostEmptyTh(10'h128), //input [9:0] AlmostEmptyTh
		.AlmostFullTh(10'h128), //input [9:0] AlmostFullTh
		.Almost_Empty( ), //output Almost_Empty
		.Almost_Full( ), //output Almost_Full
		.Q(Q_o), //output [15:0] Q
		.Empty(Fifo_Empty), //output Empty
		.Full() //output Full
	);

endmodule