`timescale 1ns / 1ps

module alu_decoder(
    input opb5, 
    input [2:0] funct3,
    input funct7b5,
    input [1:0] alu_op,
    output reg [2:0] alu_control
    );
    
    wire RtypeSub;
    assign RTypeSub = funct7b5 & opb5; //true for R-type subtract
    
    always @(*) begin
        case(alu_op)
            2'b00: alu_control = 3'b000; // load and store addition
            2'b01: alu_control = 3'b001; // branching subtraction 
            default: 
                case(funct3)
                    3'b000: 
                        if(RTypeSub)
                            alu_control = 3'b001; //sub
                        else 
                            alu_control = 3'b000; //add
                    3'b010: alu_control = 3'b101; //slt
                    3'b110: alu_control = 3'b011; //or
                    3'b111: alu_control = 3'b010; //and   
                    default: alu_control = 3'bxxx; //expansion port coming soon
                endcase
        endcase
    end
    
endmodule
