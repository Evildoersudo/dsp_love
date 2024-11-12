module top_desk_ctrl(
    Clk,
    Reset_n,
    //Led,
    uart_rx,
	K
);

    input Clk;
    input Reset_n;
//output Led;
    input uart_rx;
    //output	[1:0]led;
    // wire [1:0]up_or_down;
    // wire [15:0]sample_fs;
	output	wire	[3:0]K;
    wire [7:0]rx_data;
    wire rx_done;
    parameter Baud_Set = 3'd4;
    
    // counter_led_4 counter_led(
        // .Clk(Clk),
        // .Reset_n(Reset_n),
        // .Ctrl(ctrl),
        // .Time(time_set),
        // .Led(Led)
    // ); 

    uart_cmd uart_cmd(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .K(K)
    );
    
    uart_byte_rx uart_byte_rx(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Baud_Set(Baud_Set),
        .uart_rx(uart_rx),
        .Data(rx_data),
        .Rx_Done(rx_done)  
    ); 

endmodule
