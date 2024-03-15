module lab7_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [3:0] KEY;
    reg [9:0] SW;
    reg err;
    wire [9:0] LEDR;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instantiating the cpu module
    lab7_top DUT(
        .KEY(~KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
        );
    
    // get the clk signal generating
    initial begin 
        KEY[0] = 0; #5;
        forever begin 
            KEY[0] = 1; #5;
            KEY[0] = 0; #5;
        end
    end

    initial begin 
        // initialize inputs to zero
        err = 0;
        KEY[3:0] = 4'd0;
        SW[9:0] = 10'd0;
        
        // perfrom a reset
        KEY[1] = 1;
        #10;
        KEY[1] = 0;
        #10;


        SW = 8'd15;
        

        // check if instructions are loaded into memory
        assert (DUT.MEM.mem[0] == 16'b1101000000001001) $display("PASS! Instruction #1 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #1 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[1] == 16'b0110000000000000) $display("PASS! Instruction #2 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #2 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[2] == 16'b0110000001000000) $display("PASS! Instruction #3 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #3 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[3] == 16'b1101010000001111) $display("PASS! Instruction #4 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #4 Not Loaded into RAM");
                err = 1'b1;
            end
        
        assert (DUT.MEM.mem[4] == 16'b1011010001101010) $display("PASS! Instruction #5 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #5 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[5] == 16'b1101000100001010) $display("PASS! Instruction #6 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #6 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[6] == 16'b0110000100100000) $display("PASS! Instruction #7 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #7 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[7] == 16'b1000000101100000) $display("PASS! Instruction #8 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #8 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[8] == 16'b1110000000000000) $display("PASS! Instruction #9 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #9 Not Loaded into RAM");
                err = 1'b1;
            end
        
        assert (DUT.MEM.mem[9] == 16'b0000000101000000) $display("PASS! Instruction #10 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #10 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[10] == 16'b0000000100000000) $display("PASS! Instruction #11 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #11 Not Loaded into RAM");
                err = 1'b1;
            end
        
        #500;

        // check the register values
        assert (DUT.CPU.DP.REGFILE.R0 == 16'h140) $display("PASS! R0 has the value of 0x140");
            else begin
                $error("FAIL! R0 has the incorrect value");
                err = 1'b1;
            end
        
        assert (DUT.CPU.DP.REGFILE.R2 == 16'd15) $display("PASS! R2 has the value of 15");
            else begin
                $error("FAIL! R2 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.DP.REGFILE.R4 == 16'd15) $display("PASS! R4 has the value of 15");
            else begin
                $error("FAIL! R4 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.DP.REGFILE.R3 == 16'd14) $display("PASS! R3 has the value of 14");
            else begin
                $error("FAIL! R3 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.DP.REGFILE.R1 == 16'h100) $display("PASS! R1 has the value of 0x100");
            else begin
                $error("FAIL! R1 has the incorrect value");
                err = 1'b1;
            end
 
        #10;
            
        $stop;
    end
    
endmodule