`timescale 1ns / 1ps

module cpu_tb;

    reg clk, reset;
    wire [31:0] write_data, data_addr;
    wire mem_write;
    
    cpu dut(.clk(clk), .reset(reset), .write_data(write_data), .data_addr(data_addr), .mem_write(mem_write));
    
    initial begin
        reset <= 1'b1;
        #20;
        reset <= 1'b0;
    end
    
    initial clk = 1'b0;
    always #5 clk = ~clk;

endmodule
