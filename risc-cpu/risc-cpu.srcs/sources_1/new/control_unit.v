`timescale 1ns / 1ps

module control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5,
    input zero,
    output [1:0] result_src,
    output mem_write,
    output pc_src,
    output alu_src,
    output reg_write,
    output jump,
    output [1:0] imm_src,
    output [2:0] alu_control
    );
    
   wire [1:0] alu_op;
   wire branch; 
   
   main_decoder md(.op(op), .result_src(result_src), .mem_write(mem_write), .branch(branch),
    .alu_src(alu_src), .reg_write(reg_write), .jump(jump), .imm_src(imm_src), .alu_op(alu_op));
    
   alu_decoder ad(.opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5), .alu_op(alu_op), .alu_control(alu_control));
   
   assign pc_src = branch & zero | jump;
    
endmodule
