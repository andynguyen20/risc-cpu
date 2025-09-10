`timescale 1ns / 1ps

module alu(
    input [31:0] a, b,
    input [2:0] alu_control,
    output reg [31:0] alu_result,
    output zero
    );
    
    always @(*) begin
        case(alu_control)
            3'b000: alu_result = a + b;
            3'b001: alu_result = a - b;
            3'b010: alu_result = a & b;
            3'b011: alu_result = a | b;
            3'b101: alu_result = ($signed(a) < $signed(b)) ? 32'd1 : {32{1'b0}};
            default: alu_result = {32{1'b0}};
        endcase
    end
    
    
    assign zero = (alu_result == {32{1'b0}}) ? 1'b1 : 1'b0;
    
    
endmodule
