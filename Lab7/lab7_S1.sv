module lab7_S1();
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


        
        

        // check if instructions are loaded into memory
        assert (DUT.MEM.mem[0] == 16'b1101000000001011) $display("PASS! Instruction #1 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #1 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[1] == 16'b1101001100000101) $display("PASS! Instruction #2 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #2 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[2] == 16'b1100000011010000) $display("PASS! Instruction #3 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #3 Not Loaded into RAM");
                err = 1'b1;
            end

        assert (DUT.MEM.mem[3] == 16'b1010011011100011) $display("PASS! Instruction #4 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #4 Not Loaded into RAM");
                err = 1'b1;
            end
        
        assert (DUT.MEM.mem[4] == 16'b1010111000000111) $display("PASS! Instruction #5 Loaded into RAM");
            else begin
                $error("FAIL! Instruction #5 Not Loaded into RAM");
                err = 1'b1;
            end


        #500;

        
        // check the register values
        assert (DUT.CPU.DP.REGFILE.R0 == 16'd11) $display("PASS! R0 has the value of 11");
            else begin
                $error("FAIL! R0 has the incorrect value");
                err = 1'b1;
            end
        
        assert (DUT.CPU.DP.REGFILE.R3 == 16'd5) $display("PASS! R3 has the value of 5");
            else begin
                $error("FAIL! R3 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.DP.REGFILE.R6 == 16'd5) $display("PASS! R6 has the value of 5");
            else begin
                $error("FAIL! R6 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.DP.REGFILE.R7 == 16'd10) $display("PASS! R7 has the value of 10");
            else begin
                $error("FAIL! R7 has the incorrect value");
                err = 1'b1;
            end

        assert (DUT.CPU.N == 1'b1) $display("PASS! N Flag was HIGH for CMP");            
            else begin
                $error("FAIL! N Flag was not HIGH for CMP");
                err = 1'b1;
            end
        
        #10;
            
        $stop;
    end
    
endmodule