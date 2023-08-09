module arith_log_operations(
input  [7:0]  a, b,
output [7:0] shl, shr, sar);
//логический сдвиг влево
assign shl = a << b[2:0];
//арифметический сдвиг вправо (сохранение знака числа)
assign sar = a >>> b[2:0]; 
// логический сдвиг вправо (определяется 2-мя битами b)
assign shr = a >> b[1:0];
endmodule
