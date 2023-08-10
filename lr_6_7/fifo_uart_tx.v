`include "fifo.v"
module uart_tx (
        input wire clk_50M,                             //тактовая частота
        output reg uart_tx = 1,                 //линия UART TxD
        input wire [7:0]uart_tx_data,                   //байт для отправки
        input wire uart_tx_start,                       //сигнал загрузки байта
        output reg uart_tx_busy = 0                     //идёт передача
);
parameter MAIN_CLK = (50_000_000);              //опорная частота 50MHz
parameter UART_CLK = (9600);                    //чатота UART
reg tx_clk_9600 = 0;                            //линия частоты UART
reg [9:0]tx_reg = 10'b1xxxxxxxx0;               //регистр UART (StartBit = 0, StopBit = 1, биты данных не определены)
reg [3:0]tx_cur_bit =4'd9;                      //индекс передаваемого бита
reg fifo_rst;                                   //сброс FIFO (не используется)
wire [7:0]fifo_out;                             //выход FIFO
wire fifo_get;                                  //сигнал выгрузки байта из FIFO
assign fifo_get = (tx_cur_bit == 4'b0) ? 1'b1 : 1'b0;   //выгружаем байт при отправке старт бита
wire fifo_full;                                 //индикатор заполненности FIFO (не используется)
wire fifo_empty;                                //индикатор пустоты FIFO
fifo uart_tx_fifo (clk_50M, fifo_rst, uart_tx_data, fifo_out, uart_tx_start, fifo_get, fifo_full, fifo_empty);  //объявляем экземпляр буфера
initial begin
        uart_tx = 1;                            //устанавливаем tx в 1 при старте
end
always @(posedge clk_50M) begin : baud_rate_generator
        reg [13:0]clkr_9600 = 0;                        //счётчик для формирования несущей частоты UART
        clkr_9600 = clkr_9600 + 14'b1;          //инкремент счётчика
        if(clkr_9600 >= (MAIN_CLK/UART_CLK/2)) begin
                clkr_9600 = 14'b0;
                tx_clk_9600 = ~tx_clk_9600;             //формируем фронт несущей частоты
        end
end
always @(posedge tx_clk_9600) begin : uart_transmitter
        if((uart_tx_busy == 0) && (fifo_empty == 0)) begin //если ничего не передаём, но FIFO не пуст
                tx_cur_bit = 0;         //обнуляем индекс передаваемого бита
                uart_tx_busy = 1;               //ставим признак передачи данных
        end else if(tx_cur_bit <= 9) begin      //если ещё не вся посылка передана
                if(tx_cur_bit == 0)             //если передаётся стартбит
                        tx_reg[8:1] = fifo_out; //выгружаем новый байт из FIFO в регистр передатчика
                uart_tx = tx_reg[tx_cur_bit];                   //выставляем бит на линию передатчика
                tx_cur_bit = tx_cur_bit + 4'b0001;              //инкремент счётчика передаваемого бита
                if((tx_cur_bit == 10) && (fifo_empty == 0))     //если полностью передали байт, но в FIFO есть ещё
                        tx_cur_bit = 4'b0;      //на следующем шаге выставить стартбит
        end else                                //всё что было передали
                uart_tx_busy = 0;               //обнуляем индикатор передачи данных
end
endmodule
