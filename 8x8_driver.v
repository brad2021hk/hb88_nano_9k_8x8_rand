
//Takes a 64-bit value and then displays it on an 8x8 LED matrix.  LSB goes right side
//of top row.  This uses persistence of vision.  Only 1 row is lit at a time.  The row scan
//is fast enough to fool eyes into seeing all rows lit.  
module led8x8drv
(
    input clk,
    input [63:0] data,
    output [7:0] LEDrow, 
    output [7:0] LEDcol
);

reg [63:0] array = 0;
reg [7:0] colBuff = 0;
reg [7:0] rowBuff = 0;
reg [13:0] clockCounter = 0;
reg [2:0] byteCounter = 0;

always @(posedge clk) begin
    //This code is a little tricky.  It basically counts up and when MSB is 1, it indicates it is
    //time to move to the next row.  This simplifies the comparator to only need to check a single
    //bit.  
    clockCounter <= clockCounter + 1;
    if (clockCounter[13] == 1) begin
        clockCounter <= 0;

        //Only flops new data after a complete scan of 8x8.  Every frame is coherent.
        if (byteCounter == 0) begin
            array <= data;
        end

        //Should generate a Mux for connecting column buffer to right byte in the 64-bit array.
        //Also generate a decoder for row select, which is one hot.  I attempted to generate the 
        //cases with a for loop, but wasn't happy with the syntax or code generated.  
        
        case (byteCounter[2:0])
            0: begin
                colBuff = array[7:0];
                rowBuff = 8'b00000001;
            end
            1: begin
                colBuff = array[15:8];
                rowBuff = 8'b00000010;
            end
            2: begin
                colBuff = array[23:16];
                rowBuff = 8'b00000100;
            end
            3: begin
                colBuff = array[31:24];
                rowBuff = 8'b00001000;
            end
            4: begin
                colBuff = array[39:32];
                rowBuff = 8'b00010000;
            end
            5: begin
                colBuff = array[47:40];
                rowBuff = 8'b00100000;
            end
            6: begin
                colBuff = array[55:48];
                rowBuff = 8'b01000000;
            end
            7: begin
                colBuff = array[63:56];
                rowBuff = 8'b10000000;
            end
            
        endcase
       
        byteCounter <= byteCounter + 1;
        
    end
 
end

assign LEDcol = colBuff;
assign LEDrow = rowBuff;

endmodule

