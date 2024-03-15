module datapath_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [15:0] datapath_in;
    reg [2:0] writenum, readnum;
    reg write, clk, loada, loadb, loadc, loads, asel, bsel, vsel, err;
    reg [1:0] ALUop, shift;
    
    wire [15:0] datapath_out;
    wire Z_out;

    // Instantiating the datapath module
    datapath DUT (
        .clk(clk),
        .readnum(readnum),
        .vsel(vsel),
        .loada(loada),
        .loadb(loadb),
        .shift(shift),
        .asel(asel),
        .bsel(bsel),
        .ALUop(ALUop),
        .loadc(loadc),
        .loads(loads),
        .writenum(writenum),
        .write(write),  
        .datapath_in(datapath_in),
        .Z_out(Z_out),
        .datapath_out(datapath_out)
    );

    // get the clk signal generating
    initial begin 
        clk = 0; #5;
        forever begin 
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    // test the various cases
    initial begin
        err = 0; // set error to 0 initially
        loada = 1'b0;
        loadb = 1'b0;
        asel = 1'b0;
        bsel = 1'b0;
        vsel = 1'b0;
        shift = 2'b00;
        ALUop = 2'b00;
        loadc = 1'b0;
        loads = 1'b0;
        #10;

        //===== Load Some Values Into the Registers =====
        vsel = 1'b1;
        write = 1'b1;
        writenum = 3'd0;
        datapath_in = 16'd7; // WRITE the value 7 to R0
        #10;
        writenum = 3'd1; 
        datapath_in = 16'd2; // WRITE the value 2 to R1
        #10;
        writenum = 3'd2; 
        datapath_in = 16'd39; // WRITE the value 39 to R2
        #10;
        writenum = 3'd3; 
        datapath_in = 16'd12; // WRITE the value 12 to R3
        #10;
        writenum = 3'd7; 
        datapath_in = 16'b1100110001011100; // WRITE the value 52316 to R7
        #10;

        //===== Test #1: Addition with LSL =====
        write = 1'b0; // READ value of R1 and store in reg A
        readnum = 3'd1;
        loada = 1'b1;
        #10;
        readnum = 3'b0; // READ value of R0 and store in reg B
        loada = 1'b0;
        loadb = 1'b1;
        #10;
        loadb = 1'b0;
        shift = 2'b01; // SHIFT B left by one
        ALUop = 2'b00; // ADD A to B
        loadc = 1'b1;
        loads = 1'b1;
        #10;
        assert (datapath_out == 16'd16) $display("PASS! Addition with LSL was successful");
            else begin
                $error("FAIL! Addition with LSL was not successful");
                err = 1'b1;
            end
        assert (Z_out == 1'b0) $display("PASS! Z_out wasn't flagged");
            else begin
                $error("FAIL! Z_out was flagged");
                err = 1'b1;
            end
        loadc = 1'b0;
        loads = 1'b0;
        vsel = 1'b0; // feedback data_out into data_in
        write = 1'b1; 
        writenum = 3'd2; // WRITE addition result into register 2
        #10;
        
        //===== Test #2: Subtraction with a Zero Outcome =====
        write = 1'b0; // READ value of R1 and store in reg A and B
        readnum = 3'd3;
        loada = 1'b1;
        loadb = 1'b1;
        shift = 2'b00; // NO SHIFT 
        ALUop = 2'b01; // SUBTRACT A and B
        #10;
        loadc = 1'b1;
        loads = 1'b1;
        #10;
        assert (datapath_out == 16'd0) $display("PASS! Subtraction successful");
            else begin
                $error("FAIL! Subtraction was not successful");
                err = 1'b1;
            end
        assert (Z_out == 1'b1) $display("PASS! Z_out was flagged");
            else begin
                $error("FAIL! Z_out was not flagged");
                err = 1'b1;
            end
        loadc = 1'b0;
        loads = 1'b0;
        #10;
         
        //===== Test #3: ANDing 2 Registers =====   
        write = 1'b0; // READ value of R0 and store in reg A
        readnum = 3'd0;
        loada = 1'b1;
        #10;
        readnum = 3'd3; // READ value of R3 and store in reg B
        loada = 1'b0;
        loadb = 1'b1;
        #10;
        loadb = 1'b0;
        shift = 2'b00; // NO SHIFT 
        ALUop = 2'b10; // AND A with B
        loadc = 1'b1;
        loads = 1'b1;
        #10;
        assert (datapath_out == 16'd4) $display("PASS! AND operation was successful");
            else begin
                $error("FAIL! AND operation was not successful");
                err = 1'b1;
            end
        assert (Z_out == 1'b0) $display("PASS! Z_out wasn't flagged");
            else begin
                $error("FAIL! Z_out was flagged");
                err = 1'b1;
            end
        loadc = 1'b0;
        loads = 1'b0;
        #10;
        
        //===== Test #4: NOT 1 Register =====
        write = 1'b0; 
        readnum = 3'd7; // READ value of R7 and store in reg B
        loadb = 1'b1;
        #10;
        loadb = 1'b0;
        shift = 2'b00; // NO SHIFT 
        ALUop = 2'b11; // NOT B
        loadc = 1'b1;
        loads = 1'b1;
        #10;
        assert (datapath_out == 16'b0011001110100011) $display("PASS! NOT operation was successful");
            else begin
                $error("FAIL! NOT operation was not successful");
                err = 1'b1;
            end
        assert (Z_out == 1'b0) $display("PASS! Z_out wasn't flagged");
            else begin
                $error("FAIL! Z_out was flagged");
                err = 1'b1;
            end
        loadc = 1'b0;
        loads = 1'b0;
        #10;

        //$stop;
    end

endmodule: datapath_tb