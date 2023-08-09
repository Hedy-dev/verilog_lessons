module test_log_operations;
reg  [7:0]  a, b;
wire [7:0] shl, shr, sar;
//устанавливаем экземпляр тестируемого модуля
arith_log_operations alo(a, b, shl, shr, sar);
initial begin
a = 8'b10011110;
b = 8'b10010101;
$monitor("a=%b",a,,"b=%b",b,,"shl=%b",shl,,"shr=%b",shr,,"sar=%b",sar);
end
endmodule
