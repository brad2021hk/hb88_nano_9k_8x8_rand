//This code generates a sequence of random numbers to display on 8x8 LED Matrix.
//SW1 is a reset and load new seed button.  SW2 changes the rate at which the diplay updates the 
//random number.  The 8 dip switches allows the user to update the seed.  

module top
(
    input clk,
    input [7:0] switch,
    input [3:0] button,
    output [7:0] LEDrow, 
    output [7:0] LEDcol
);

reg [63:0] data_pattern = 0;
wire [7:0] ledRow_w;
wire [7:0] ledCol_w;
wire [63:0] randNum_w;
wire [63:0] seed_w;
wire bt0_w;
wire bt1_w;


//This determines how frequently the display updates with new numbers.
reg [31:0] countCounter = 0;
localparam FAST_COUNT_WAIT = 500000;

//This variable has to be initialized to 1 or the first button press does not work.  
reg [1:0] count_speed = 1;
reg [31:0] countValue_sw = FAST_COUNT_WAIT;
reg [31:0] countValue = FAST_COUNT_WAIT;

led8x8drv matrix (.clk(clk), .data(data_pattern), .LEDrow(ledRow_w), .LEDcol(ledCol_w));
prand64 randomizer (.clk(clk), .pReset(bt0_w), .runRand(1), .seed(seed_w), .randNum(randNum_w));
buttonDebounce bt0 (.clk(clk), .button_in(button[0]), .button_out(bt0_w));
buttonDebounce bt1 (.clk(clk), .button_in(button[1]), .button_out(bt1_w));

//This code fetches new random number and sends it to the 8x8 display.  
always @(posedge clk) begin
    countValue <= countValue_sw;
    countCounter <= countCounter+1;
    if (countCounter > countValue) begin
        countCounter <= 0;

        data_pattern <= randNum_w;
    end
    
end

//Changes rate at which display updates to new value.  
always @(posedge bt1_w) begin
    count_speed <= count_speed+1;
    
    case (count_speed)
        0: countValue_sw = FAST_COUNT_WAIT;
        1: countValue_sw = 5*FAST_COUNT_WAIT;
        2: countValue_sw = 25*FAST_COUNT_WAIT;
        3: countValue_sw = 100*FAST_COUNT_WAIT;
    endcase
    
end

assign LEDrow[7:0] = ~ledRow_w;
//Since there are only 8 switched, it fans the 8-bit pattern to 64 bits.  
assign seed_w[63:0] = {8{switch[7:0]}};

//Reverse order of LED column to be little-endian.  
genvar i;
for (i=0; i<8; i=i+1) begin
    assign LEDcol[i] = ledCol_w[7-i];
end

endmodule
