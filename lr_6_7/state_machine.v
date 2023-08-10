module state_machine
(input up_down, clk, reset,
 output reg lsb, msb);
 reg [1:0] present_state, next_state;
 parameter [1:0] st_zero = 2'b11, st_one = 2'b01, st_two =2'b10, st_three = 2'b00;
always @(up_down or present_state or reset)
 begin
 if (reset) next_state = st_zero;
       else
           present_state = next_state;
 case (present_state)
 st_zero: if (up_down == 0) begin
            next_state = st_one; lsb = 0; msb = 0;
          end
          else begin
            next_state = st_three; lsb = 1; msb = 1;
          end
 st_one: if (up_down == 0) begin
            next_state = st_two; lsb = 1; msb = 0;
         end
         else begin
            next_state = st_zero; lsb = 0; msb = 0;
         end
 st_two: if (up_down == 0) begin
            next_state = st_three; 
            lsb = 0; 
            msb = 1;
         end
         else begin
            next_state = st_one; lsb = 1; msb = 0;
         end
 st_three: if (up_down == 0) begin
            next_state = st_zero; lsb = 1; msb = 1;
           end
           else begin
            next_state = st_two; lsb = 0; msb = 1;
           end
 endcase
end
endmodule

