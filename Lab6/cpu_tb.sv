module cpu_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [15:0] in;
    reg clk, reset, s, load, err;

    // outputs
    wire [15:0] out;
    wire N, V, Z, w;

    // Instantiating the cpu module
    cpu DUT (
        .clk(clk),
        .reset(reset),
        .s(s),
        .load(load),
        .in(in),
        .out(out),
        .N(N),
        .V(V),
        .Z(Z),
        .w(w)
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
        err = 0;

        // perform a reset
        s = 0; 
        load = 0; 
        in = 16'd0;
        reset = 1; 
        #10;

        assert (w == 1'b1) $display("PASS! In the Wait State");
            else begin
                $error("FAIL! Not in the Wait State");
                err = 1'b1;
            end

        reset = 0;
        #10;

    
        //=================== TEST MOVImm 7 TIMES =====================================================
        // MOVImm #1: MOV R0, #11
        in = 16'b1101000000001011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;
        
        assert (cpu_tb.DUT.DP.REGFILE.R0 == 16'd11) $display("PASS! MOVImm #1 was successful");
            else begin
                $error("FAIL! MOVImm #1 was not successful");
                err = 1'b1;
            end

        // MOVImm #2: MOV R1, #-16
        in = 16'b1101000111110000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R1 == 16'b1111111111110000) $display("PASS! MOVImm #2 was successful");
            else begin
                $error("FAIL! MOVIm #2 was not successful");
                err = 1'b1;
            end

        // MOVImm #3: MOV R2, #0
        in = 16'b1101001000000000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R2 == 16'd0) $display("PASS! MOVImm #3 was successful");
            else begin
                $error("FAIL! MOVImm #3 was not successful");
                err = 1'b1;
            end


        // MOVImm #4: MOV R3, #5
        in = 16'b1101001100000101; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R3 == 16'd5) $display("PASS! MOVImm #4 was successful");
            else begin
                $error("FAIL! MOVImm #4 was not successful");
                err = 1'b1;
            end

        //=================== TEST ALU MOV 3 TIMES =====================================================
        // Reg to Reg Mov #1: MOV R4, R3    (No shift into empty reg) R4 = 5
        in = 16'b1100000010000011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R3 == 16'd5) $display("PASS! MOV #1 was successful");
            else begin
                $error("FAIL! MOV #1 was not successful");
                err = 1'b1;
            end        
        
        // Reg to Reg Mov #2: MOV R4, R1    (Negative value from reg into a reg that had a value) R4 = -16
        in = 16'b1100000010000001; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R4 == 16'b1111111111110000) $display("PASS! MOV #2 was successful");
            else begin
                $error("FAIL! MOV #2 was not successful");
                err = 1'b1;
            end

        // Reg to Reg Mov #3: MOV R6, R0, LRL #1   (LRL shifted value)   R6 = 5
        in = 16'b1100000011010000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R6 == 16'd5) $display("PASS! MOV #3 was successful");
            else begin
                $error("FAIL! MOV #3 was not successful");
                err = 1'b1;
            end

        //=================== TEST ADD 3 TIMES =====================================================
        // ADD #1: ADD R7, R6, R3              (Regular ADD with no shift between two positives) R7 = 10
        in = 16'b1010011011100011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'd10) $display("PASS! ADD #1 was successful");
            else begin
                $error("FAIL! ADD #1 was not successful");
                err = 1'b1;
            end

        // ADD #2: ADD R7, R1, R3            (ADD with a negative and positve) R7 = -11
        in = 16'b1010000111100011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'b1111111111110101) $display("PASS! ADD #2 was successful");
            else begin
                $error("FAIL! ADD #2 was not successful");
                err = 1'b1;
            end

        // ADD #3: ADD R7, R0, R3, LSL#1          (ADD with LSL) R7 = 21
        in = 16'b1010000011101011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'd21) $display("PASS! ADD #3 was successful");
            else begin
                $error("FAIL! ADD #3 was not successful");
                err = 1'b1;
            end

        //=================== TEST AND 3 TIMES =====================================================
        // AND #1: AND R7, R3, R0                          (AND no shift) R7 = 1
        in = 16'b1011001111100000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'd1) $display("PASS! AND #1 was successful");
            else begin
                $error("FAIL! AND #1 was not successful");
                err = 1'b1;
            end

        // AND #2: AND R7, R0, R2                 (AND with zero and a value) R7 = 0
        in = 16'b1011000011100010; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'd0) $display("PASS! AND #2 was successful");
            else begin
                $error("FAIL! AND #2 was not successful");
                err = 1'b1;
            end   


        // AND #3: AND R7, R0, R3, LSL#1              (AND with a value LSL) R7 = 10
        in = 16'b1011000011101011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'd10) $display("PASS! AND #3 was successful");
            else begin
                $error("FAIL! AND #3 was not successful");
                err = 1'b1;
            end

        //=================== TEST MVN 3 TIMES =====================================================
        // MVN #1: MVN R7, R0               (Invert a num) R7 = -12
        in = 16'b1011100011100000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'b1111111111110100) $display("PASS! MVN #1 was successful");
            else begin
                $error("FAIL! MVN #1 was not successful");
                err = 1'b1;
            end


        // MVN #2: MVN R7, R2               (Invert 0) R7 = all 1's
        in = 16'b1011100011100010; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'b1111111111111111) $display("PASS! MVN #2 was successful");
            else begin
                $error("FAIL! MVN #2 was not successful");
                err = 1'b1;
            end

        // MOVN #3: MVN R7, R3, LSL#1       (Invert with shift) R7 = 1111111111110101
        in = 16'b1011100011101011; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.DP.REGFILE.R7 == 16'b1111111111110101) $display("PASS! MVN #3 was successful");
            else begin
                $error("FAIL! MVN #3 was not successful");
                err = 1'b1;
            end

        
        
        //=================== Get some diff reg values for cmp =====================================================
        
        // MOVImm #3: MOV R7, #127
        
        in = 16'b1101011101111111; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        // MOVImm #4: MOV R6, #-1
        in = 16'b1101011011111111; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;
        
        //=================== TEST CMP 3 TIMES =====================================================
        // CMP #1: CMP R0, R0           (Check if Z flag is set)
        in = 16'b1010100000000000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.Z == 1'b1) $display("PASS! CMP #1 was successful");
            else begin
                $error("FAIL! CMP #1 was not successful %d", cpu_tb.DUT.Z);
                err = 1'b1;
            end
        
        // CMP #2: CMP R3, R0                 (Check if N flag is set) R0 = 11, R3 = 5, (R3- R0)
        in = 16'b1010101100000000; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.N == 1'b1) $display("PASS! CMP #2 was successful");
            else begin
                $error("FAIL! CMP #2 was not successful %d", cpu_tb.DUT.N);
                err = 1'b1;
            end


        // subtracts the value of Operand2 from the value in Rn
        // CMP #3: CMP R7, R6                          (Check if V flag is set)
        in = 16'b1010111100000110; // load in into instruction reg
        load = 1;
        #10;

        load = 0; // set s to enter next state (WriteImm)
        s = 1;
        #10;
        
        s = 0;
        @(posedge w);
        #10;

        assert (cpu_tb.DUT.V == 1'b1) $display("PASS! CMP #3 was successful");
            else begin
                $error("FAIL! CMP #3 was not successful %d", cpu_tb.DUT.N);
                err = 1'b1;
            end

        $stop;
    end

endmodule: cpu_tb