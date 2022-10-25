module wokwi(input clk, output led);
  reg [11:0] counter = 12'h0;
    
  always @(posedge clk) begin
    counter <= counter + 1'b1;
  end
    
  assign led = counter[7];
    
endmodule
