`timescale 1ns / 1ps

module data_memory(
    input clk,
    input write_en,
    input [31:0] addr, write_data, 
    output [31:0] read_data
    );
    
    reg [31:0] RAM [63:0];
    
    always @(posedge clk) begin
        if (write_en)
            RAM[addr[31:2]] <= write_data;
    end 
    
    assign read_data = RAM[addr[31:2]];
    
endmodule
