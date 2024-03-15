module shifter(in,shift,sout);
    input [15:0] in;
    input [1:0] shift;
    output [15:0] sout;
    
    reg [15:0] sout;
    
    // handle the various shift options
    always_comb begin
        case(shift)
            2'b00: sout = in; // no shift
            2'b01: sout = in << 1; // shift left by 1
            2'b10: sout = in >> 1; // shift right by 1
            2'b11: begin
                    sout = in >> 1; // shift right by 1
                    sout[15] = in[15]; // make MSB == copy of B[15]
                    end
            default: sout = 16'bxxxxxxxxxxxxxxxx;
        endcase
    end
endmodule
