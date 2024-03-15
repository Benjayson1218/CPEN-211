module ALU_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [15:0] sim_Ain;
    reg [15:0] sim_Bin;
    reg [1:0] sim_ALUop;
    wire [15:0] sim_out;
    wire sim_Z;
    reg err;
    reg [15:0] total_error;

    // Instantiating the ALU module
    ALU DUT (
        .Ain(sim_Ain),
        .Bin(sim_Bin),
        .ALUop(sim_ALUop),
        .out(sim_out),
        .Z(sim_Z)
    );

    // test the various cases
    initial begin
        err = 0; // set error to 0 initially
        total_error = 0;
        
        //===== Test an Addition and Confirm Z is Low =====
        sim_Ain = 16'd6;
        sim_Bin = 16'd12;
        sim_ALUop = 2'b00;
        #5;
        assert (sim_out == 16'd18) $display("PASS! Addition was successful");
            else begin
                $error("FAIL! Addition was not successful");
                err = 1'b1;
                total_error[0] = 1'b1;
            end

        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[1] = 1'b1;
            end

        //===== Test another Addition and Confirm Z is Low =====
        sim_Ain = 16'd500;
        sim_Bin = 16'd300;
        sim_ALUop = 2'b00;
        #5;
        assert (sim_out == 16'd800) $display("PASS! Addition was successful");
            else begin
                $error("FAIL! Addition was not successful");
                err = 1'b1;
                total_error[2] = 1'b1;
            end

        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[3] = 1'b1;
            end

        //===== Test a Subtraction and Confrim Z is Low =====
        sim_Ain = 16'd30;
        sim_Bin = 16'd15;
        sim_ALUop = 2'b01;
        #5;
        assert (sim_out == 16'd15) $display("PASS! Subtraction was successful.");
            else begin
                $error("FAIL! Subtraction was not successful.");
                err = 1'b1;
                total_error[4] = 1'b1;
            end

        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[5] = 1'b1;
            end

        //===== Test a Subtraction and Confrim Z is High =====
        sim_Ain = 16'd25;
        sim_Bin = 16'd25;
        sim_ALUop = 2'b01; // subtract 25 from 25
        #5;
        assert (sim_out == 16'd0) $display("PASS! Subtraction was successful.");
            else begin
                $error("FAIL! Subtraction was not successful.");
                err = 1'b1;
                total_error[6] = 1'b1;
            end

        assert (sim_Z == 1'b1) $display("PASS! Z was set");
            else begin
                $error("FAIL! Z was not set");
                err = 1'b1;
                total_error[7] = 1'b1;
            end

        //===== Test an AND Operation and Confirm Z is Low =====
        sim_Ain = 16'b1010110101111100;
        sim_Bin = 16'b1000100011101101;
        sim_ALUop = 2'b10;
        #5;
        assert (sim_out == 16'b1000100001101100) $display("PASS! AND was successful.");
            else begin
                $error("FAIL! AND was not successful.");
                err = 1'b1;
                total_error[8] = 1'b1;
            end

        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[9] = 1'b1;
            end

        //===== Test another AND Operation and Confirm Z is Low =====
        sim_Ain = 16'b0011010111001010;
        sim_Bin = 16'b1110001001001110;
        sim_ALUop = 2'b10;
        #5;
        assert (sim_out == 16'b0010000001001010) $display("PASS! AND was successful.");
            else begin
                $error("FAIL! AND was not successful.");
                err = 1'b1;
                total_error[10] = 1'b1;
            end

        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[11] = 1'b1;
            end

        //===== Test an Not Operation and Confirm Z is Low =====
        sim_Ain = 16'b1010011010100010;
        sim_Bin = 16'b1100110001011100;
        sim_ALUop = 2'b11;
        #5;
        assert (sim_out == 16'b0011001110100011) $display("PASS! ~B was successful.");
            else begin
                $error("FAIL! ~B was not successful.");
                err = 1'b1;
                total_error[12] = 1'b1;
            end
            
        assert (sim_Z == 1'b0) $display("PASS! Z is low");
            else begin
                $error("FAIL! Z is high");
                err = 1'b1;
                total_error[13] = 1'b1;
            end

        //===== Test another Not Operation and Confirm Z was Set =====
        sim_Ain = 16'b1011110010100010;
        sim_Bin = 16'b1111111111111111;
        sim_ALUop = 2'b11;
        #5;
        assert (sim_out == 16'd0) $display("PASS! ~B was successful.");
            else begin
                $error("FAIL! ~B was not successful.");
                err = 1'b1;
                total_error[14] = 1'b1;
            end

        assert (sim_Z == 1'b1) $display("PASS! Z was set");
            else begin
                $error("FAIL! Z was not set");
                err = 1'b1;
                total_error[15] = 1'b1;
            end

        //$stop;
    end

endmodule: ALU_tb