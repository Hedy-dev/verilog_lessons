module shift_8x64_taps(
 input clk, shift,
 input  [3:0] sr_in,
 output [7:0] sr_tap_one, sr_tap_two, sr_tap_three, sr_out );
 reg [3:0] sr [63:0];
 integer n;
always@(posedge clk) begin
 if (shift == 1'b1) begin
    for (n = 63; n>0; n = n-1) begin
        sr[n] <= sr[n-1];
    end
    sr[0] <= sr_in;
 end
end
// выходы входной последовательности sr_in
assign sr_tap_one = sr[15]; // с задержкой на 16 тактов
assign sr_tap_two = sr[31]; // с задержкой на 32 такта
assign sr_tap_three = sr[47]; // с задержкой на 48 тактов
assign sr_out = sr[63]; // с задержкой на 64 такта
endmodule