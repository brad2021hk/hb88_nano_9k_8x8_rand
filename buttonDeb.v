//Simple button debounce logic.  

module buttonDebounce
(
    input clk,
    input button_in, 
    output button_out
);

reg [14:0] slow_clock_counter;
reg slow_clk;
reg first_stage = 0;
reg second_stage = 0;
reg button_out_reg1 = 0;
reg button_out_reg2 = 0;
reg button_out_reg3 = 0;

//Generates a slows clock that is 2^14 slower than input clock.  
//Also synchronizes the debounced output back to the faster clock.  
always @(posedge clk) begin
    slow_clock_counter <= slow_clock_counter+1;
    slow_clk <= slow_clock_counter[14];
    button_out_reg2 <= button_out_reg1;
    button_out_reg3 <= button_out_reg2;
end

//Uses the slower clock to debuounce the input signal.  
always @(posedge slow_clk) begin
    button_out_reg1 <= second_stage && first_stage;
    second_stage <= first_stage;
    first_stage <= button_in;
end

assign button_out = button_out_reg2;

endmodule
