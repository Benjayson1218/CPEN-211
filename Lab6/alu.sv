module ALU(Ain,Bin,ALUop,out,status);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output [2:0] status;

    reg [15:0] out;
    reg [2:0] status;
    
    // compute out and handle V flag
    always_comb begin
        case(ALUop)
            2'b00: begin
                out = Ain + Bin;
                // check if if 2 -ve nums = a +ve OR 2 +ve nums = a -ve 
                if((Ain[15] & Bin[15] & ~out[15]) | (~Ain[15] & ~Bin[15] & out[15]))
                    status[0] = 1'b1;
                else
                    status[0] = 1'b0;
            end
            2'b01: begin
                out = Ain - Bin;
                // (check if A is -ve and B is +ve and out is +ve) OR (check if A is +ve and B is -ve and out is -ve)
                if((Ain[15] & ~Bin[15] & ~out[15]) | (~Ain[15] & Bin[15] & out[15]))
                    status[0] = 1'b1;
                else
                    status[0] = 1'b0;
            end
            2'b10: begin
                out = Ain & Bin;
                status[0] = 1'b0;
            end
            2'b11: begin
                out = ~Bin;
                status[0] = 1'b0;
            end
            default: out = 16'bxxxxxxxxxxxxxxxx;
        endcase

        // handle Z flag
        if(out == 16'd0) 
            status[2] = 1'b1;
        else
            status[2] = 1'b0;

        // handle N flag
        if(out[15] == 1'b1) 
            status[1] = 1'b1;
        else
            status[1] = 1'b0;
    
    end
endmodule
