module Reverberation(
    input           rst_n,
    input           Clk,
    input           Write_En,
    input           Write_Clk,
    input   [15:0]  Write_Data,
    input           Read_En,
    input           Read_Clk,
    output  [15:0]  Read_Data,
    input   [9:0]   Delay_Num
);

    wire            Reverberation_Input_Almost_Full;
    reg     [15:0]  Reverberation_Input_Data;
    wire    [15:0]  Reverberation_Input_To_Output_Data;
    reg     [15:0]  Reverberation_Input_Back_To_Input_Data;

    always @ (posedge Clk or negedge rst_n) begin
        if ( ~rst_n ) begin
            Reverberation_Input_Data <= 16'b0;
        end
        else if ( Reverberation_Input_Almost_Full ) begin
            Reverberation_Input_Data <= Write_Data + ( Reverberation_Input_To_Output_Data >> 1);
        end
        else begin
            Reverberation_Input_Data <= Write_Data;
        end
    end

	Reverberation_Num Reverberation_Input(
		.Data(Reverberation_Input_Data), //input [15:0] Data
		.WrClk(Write_Clk), //input WrClk
		.RdClk(Write_Clk), //input RdClk
		.WrEn(Write_En), //input WrEn
		.RdEn(Reverberation_Input_Almost_Full), //input RdEn
		.AlmostEmptyTh(), //input [9:0] AlmostEmptyTh
		.AlmostFullTh(Delay_Num), //input [9:0] AlmostFullTh
		.Almost_Empty(), //output Almost_Empty
		.Almost_Full(Reverberation_Input_Almost_Full), //output Almost_Full
		.Q(Reverberation_Input_To_Output_Data), //output [15:0] Q
		.Empty(), //output Empty
		.Full() //output Full
	);

	Reverberation_Num Reverberation_Output(
		.Data(Reverberation_Input_To_Output_Data), //input [15:0] Data
		.WrClk(Write_Clk), //input WrClk
		.RdClk(Read_Clk), //input RdClk
		.WrEn(Reverberation_Input_Almost_Full), //input WrEn
		.RdEn(Read_En), //input RdEn
		.AlmostEmptyTh(), //input [9:0] AlmostEmptyTh
		.AlmostFullTh(), //input [9:0] AlmostFullTh
		.Almost_Empty(), //output Almost_Empty
		.Almost_Full(), //output Almost_Full
		.Q(Read_Data), //output [15:0] Q
		.Empty(), //output Empty
		.Full() //output Full
	);

endmodule
