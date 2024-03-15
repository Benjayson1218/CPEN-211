module regfile(data_in,writenum,write,readnum,clk,data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;
    wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    wire [7:0] decodedWriteNum, load, select;

    //==== writing circuitry ==================================
    // instanciate the first 3:8 decoder
    Dec #(3,8) dec1(writenum,decodedWriteNum);

    // the AND gate part
    assign load = {8{write}} & decodedWriteNum;
    
    // instanciate the 8 registers of 16-bits each
    vDFFE #(16) reg0(clk, load[0], data_in, R0);
    vDFFE #(16) reg1(clk, load[1], data_in, R1);
    vDFFE #(16) reg2(clk, load[2], data_in, R2);
    vDFFE #(16) reg3(clk, load[3], data_in, R3);
    vDFFE #(16) reg4(clk, load[4], data_in, R4);
    vDFFE #(16) reg5(clk, load[5], data_in, R5);
    vDFFE #(16) reg6(clk, load[6], data_in, R6);
    vDFFE #(16) reg7(clk, load[7], data_in, R7);


    //==== reading circuitry ==================================
    // instanciate the second 3:8 decoder
    Dec #(3,8) dec2(readnum,select);

    // instanciate the mux
    Mux8 #(16) mux(R7, R6, R5, R4, R3, R2, R1, R0, select, data_out);

endmodule


// module for register with load enable
module vDFFE(clk, en, in, out);  
    parameter n = 1;  // width  
    input clk, en;  
    input  [n-1:0] in;  
    output [n-1:0] out;  
    reg    [n-1:0] out;  
    wire   [n-1:0] next_out;  

    assign next_out = en ? in : out; 

    always @(posedge clk)    
        out = next_out;      
endmodule


// module for decoder
module Dec(a,b);
    parameter n = 2;
    parameter m = 4;

    input [n-1:0] a;
    output [m-1:0] b;

    wire [m-1:0] b = 1 << a;
endmodule


// module for a mux
module Mux8(a7, a6, a5, a4, a3, a2, a1, a0, select, out);
    parameter k = 1;  
    input [k-1:0] a0, a1, a2, a3, a4, a5, a6, a7;  // inputs  
    input [7:0] select; // one-hot select  
    output[k-1:0] out;  
    wire [k-1:0] out = ({k{select[0]}} & a0) | ({k{select[1]}} & a1) | ({k{select[2]}} & a2) | ({k{select[3]}} & a3) |
                       ({k{select[4]}} & a4) | ({k{select[5]}} & a5) | ({k{select[6]}} & a6) | ({k{select[7]}} & a7);
endmodule


// module for a mux (LAB 6 ADDITION)
module Mux4(mdata, sximm8, PC, C, vsel, out);
  parameter k = 1;
  input [k-1:0] mdata, sximm8, PC, C;  // inputs  
  input [1:0] vsel; // binary select 
  output [k-1:0] out;
  reg [k-1:0] out;

  always @(*) begin
    case (vsel)
	    2'b00: out = C;
	    2'b01: out = PC;
	    2'b10: out = sximm8;
	    2'b11: out = mdata;
    endcase
  end
endmodule


// module for a mux (LAB 6 ADDITION)
module Mux3(Rm, Rd, Rn, nsel, regLocation);
    parameter k = 1;  
    input [k-1:0] Rn, Rd, Rm;  // inputs  
    input [2:0] nsel; // one-hot select  
    output[k-1:0] regLocation;  
    wire [k-1:0] regLocation = ({k{nsel[0]}} & Rm) | ({k{nsel[1]}} & Rd) | ({k{nsel[2]}} & Rn);
endmodule


