module ALU(Ain,Bin,ALUop,out,Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output Z;

    reg [15:0] out;
    reg Z;
    
    // cases for different values of ALUop
    always_comb begin
        case(ALUop)
            2'b00: out = Ain + Bin;
            2'b01: out = Ain - Bin;
            2'b10: out = Ain & Bin;
            2'b11: out = ~Bin;
            default: out = 16'bxxxxxxxxxxxxxxxx;
        endcase

        // if the out value is 0, set Z flag to 1
        if(out == 16'd0)
            Z = 1;
        else
            Z = 0;
    end
endmodule
