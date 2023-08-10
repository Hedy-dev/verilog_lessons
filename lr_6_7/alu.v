module alu
#(parameter addab = 4'b0000, inca = 4'b0001, incb = 4'b0010,
 andab = 4'b0011, orab = 4'b0100, nega = 4'b0101,
 shal = 4'b0110, shar = 4'b0111,
 passa = 4'b1000, passb = 4'b1001)
(input [7:0] a, b,
 input [3:0] opsel,
 output reg [7:0] f);
always @(a or b or opsel)
 begin
 case (opsel)
 addab: f = a + b;
 inca:  f = a + 1;
 incb:  f = b + 1;
 andab: f = a & b;
 orab:  f = a | b;
 nega:  f = !a;
 shal:  f = a << 1;
 shar:  f = a >> 1;
 passa: f = a;
 passb: f = b;
 default: f = 8'bX;
 endcase
 end
endmodule
