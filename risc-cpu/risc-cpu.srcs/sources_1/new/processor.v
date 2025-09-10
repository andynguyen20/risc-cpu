`timescale 1ns / 1ps

module processor(
    input clk, reset,
    input [31:0] instr, 
    input [31:0] read_data,
    output [31:0] pc,
    output mem_write,
    output [31:0] alu_result,
    output [31:0] write_data
    );
    
    wire pc_src, alu_src, reg_write, jump, zero;
    wire [1:0] result_src, imm_src;
    wire [2:0] alu_control;
    
    control_unit c(.op(instr[6:0]), .funct3(instr[14:12]), .funct7b5(instr[30]), .zero(zero), .result_src(result_src), 
    .mem_write(mem_write), .pc_src(pc_src), .alu_src(alu_src), .reg_write(reg_write), .jump(jump), .imm_src(imm_src), .alu_control(alu_control));

    datapath dp(.clk(clk), .reset(reset), .result_src(result_src), .pc_src(pc_src), .alu_src(alu_src), .reg_write(reg_write), .imm_src(imm_src), 
    .alu_control(alu_control), .zero(zero), .pc(pc), .instr(instr), .alu_result(alu_result), .write_data(write_data), .read_data(read_data));    
    
endmodule
