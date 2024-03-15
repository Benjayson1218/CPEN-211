module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, status_out, C, mdata, sximm8, PC, sximm5);
    input [15:0] mdata, sximm8, sximm5;
    input [7:0] PC;
    input[2:0] writenum, readnum;
    input write, clk, loada, loadb, asel, bsel, loadc, loads;
    input [1:0] shift, ALUop, vsel;

    output [2:0] status_out;
    output [15:0] C;

    wire [15:0] data_in, data_out, in, sout, Ain, Bin, out, Aout; 
    wire [2:0] status; // status[2] = Z, status[1] = N, status[0] = V

    

    // instantiate the 3 main modules (regfile, ALU, and Shifter)
    regfile REGFILE ( // Block 1
        .data_in(data_in),
        .writenum(writenum),
        .write(write),
        .readnum(readnum),
        .clk(clk),
        .data_out(data_out)
    );

    ALU alu ( // Block 2
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(out),
        .status(status)
    );

    shifter SHIFTER ( // Block 8
        .in(in),
        .shift(shift),
        .sout(sout)
    );

    // instatiate registers A, B, and C 
    vDFFE #(16) regA(clk, loada, data_out, Aout); // Block 3
    vDFFE #(16) regB(clk, loadb, data_out, in); // Block 4 
    vDFFE #(16) regC(clk, loadc, out, C); // Block 5

    // Assign the muxes for regs A and B
    assign Ain = asel ? 16'b0 : Aout; // Block 6
    //assign Bin = bsel ? {11'b0, datapath_in[4:0]} : sout; // Block 7 
    assign Bin = bsel ? sximm5 : sout;

    // Assign the mux for data_in
    //assign data_in = vsel ? datapath_in : datapath_out; // Block 9 (lab 5)

    // instatiate a 4 to 1 mux that feeds into the reg file
    Mux4 #(16) dataSelMux(mdata, sximm8, {8'b0,PC}, C, vsel, data_in); // Block 9
    
    // instantiate the status register
    vDFFE #(3) statusReg(clk, loads, status, status_out); // Block 10
    //vDFFE #(1) status(clk, loads, Z, Z_out); // Block 10 (lab 5)
    

endmodule