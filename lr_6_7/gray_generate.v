module gray_generate
#(parameter SIZE =4)
( input wire [SIZE-1:0]gray,
 output wire [SIZE-1:0]bin
 );
genvar i;
generate
 for (i=0; i<SIZE; i=i+1)
begin: bit
 assign bin[i] = ^gray[SIZE-1:i];
end
endgenerate
endmodule