`timescale 1ns / 1ps

module mux3(
    input [31:0] d0, d1, d2,
    input [1:0] sel,
    output reg [31:0] y
    );
    
    always @(*) begin
        case(sel)   
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d2;
        endcase
    end 
    
endmodule
