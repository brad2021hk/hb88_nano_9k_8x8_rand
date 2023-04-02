//Implements a Fibonacci LFSR to generate pseudo-random bit sequence.  
//Generate 3 levels of xNOR, so definitely limiter of clock speed.  

module prand64
(
    input clk,
    input pReset,
    input runRand,
    input [63:0] seed,
    output [63:0] randNum
);

reg [63:0] randValue = 64'h0123456789ABCDEF;
reg r_XNOR = 0;

always @(posedge clk) begin
    if (pReset == 1'b1) begin
        randValue <= seed;
    end
    else begin 
        if (runRand == 1'b1) begin
            //Found LFSR Taps here:  https://docs.xilinx.com/v/u/en-US/xapp052
            r_XNOR <= randValue[63] ^~ randValue[62] ^~ randValue[60] ^~ randValue[59];
            randValue <= {randValue[62:0], r_XNOR};
        end
    end
    

end

assign randNum = randValue;


endmodule

