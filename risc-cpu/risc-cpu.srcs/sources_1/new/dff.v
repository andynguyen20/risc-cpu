`timescale 1ns / 1ps

module dff(
    input clk, 
    input reset,
    input [31:0] d,
    output reg [31:0] q
    );
    
    always @(posedge(clk), posedge(reset)) begin
        if(reset)
            q <= {32{1'b0}};
        else 
            q <= d;
    end     
    
endmodule

