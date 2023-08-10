// Генерирование различных комбинаций входных сигналов
  generate
    for (genvar i=0; i<16; i=i+1) begin : GEN_INPUTS
      assign in = i;
      // Инициализация и подключение dut (design under test)
      dut DUT (
        .in(in),
        .out(out)
      );
      
      initial begin
        // Вывод входных и ожидаемых выходных сигналов
        $display("Input: %b", in);
        $display("Expected Output: %b", out);
        #10;
      end
    end
  endgenerate
