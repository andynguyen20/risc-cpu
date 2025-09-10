`timescale 1ns / 1ps

module cpu(
    input clk, reset,
    output [31:0] write_data, data_addr,
    output mem_write
    );
    
    wire [31:0] pc, instr, read_data;
    
    processor pu(.clk(clk), .reset(reset), .pc(pc), .instr(instr), .mem_write(mem_write), .alu_result(data_addr), .write_data(write_data),
    .read_data(read_data));
    
    instruction_memory imem(.addr(pc), .read_data(instr));
    
    data_memory dmem(.clk(clk), .write_en(mem_write), .addr(data_addr), .write_data(write_data), .read_data(read_data));
    
endmodule
