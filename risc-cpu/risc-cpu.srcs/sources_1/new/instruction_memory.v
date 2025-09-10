`timescale 1ns / 1ps

module instruction_memory(
    input [31:0] addr,
    output [31:0] read_data
    );
    
    reg [31:0] instruction_mem [63:0];
    
    initial begin
        $readmemb("add_demo.mem", instruction_mem);
    end 
    
    assign read_data = instruction_mem[addr[31:2]]; // byte addressing
    
endmodule
