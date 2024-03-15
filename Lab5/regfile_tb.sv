module regfile_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg sim_clk;
    reg [2:0] sim_writenum;
    reg sim_write;
    reg [2:0] sim_readnum;
    reg [15:0] sim_data_in;
    wire [15:0] sim_data_out;
    reg err;
    reg [7:0] total_error;

    // Instantiating the regfile module
    regfile DUT (
        .data_in(sim_data_in),
        .writenum(sim_writenum),
        .write(sim_write),
        .readnum(sim_readnum),
        .clk(sim_clk),
        .data_out(sim_data_out)
    );


    // get the clk signal generating
    initial begin 
        sim_clk = 0; #5;
        forever begin 
            sim_clk = 1; #5;
            sim_clk = 0; #5;
        end
    end

    // test the various cases
    initial begin
        err = 0; // set error to 0 initially
        total_error = 0;
    
        //====== test if data is written to regs if write is high (write = 1) =========
        sim_write = 1'b1;

        //check R0:
        sim_writenum = 3'd0;
        sim_readnum = 3'd0;
        sim_data_in = 16'd547;
        #10;
        assert (sim_data_out == 16'd547) $display("PASS! R0 was successfully written to.");
            else begin
                $error("FAIL! R0 was not written to.");
                err = 1'b1;
                total_error[0] = 1'b1;
            end

        //check R1:
        sim_writenum = 3'd1;
        sim_readnum = 3'd1;
        sim_data_in = 16'd234;
        #10;
        assert (sim_data_out == 16'd234) $display("PASS! R1 was successfully written to.");
            else begin
                $error("FAIL! R1 was not written to.");
                err = 1'b1;
                total_error[1] = 1'b1;
            end

        //check R2:
        sim_writenum = 3'd2;
        sim_readnum = 3'd2;
        sim_data_in = 16'd763;
        #10;
        assert (sim_data_out == 16'd763) $display("PASS! R2 was successfully written to.");
            else begin
                $error("FAIL! R2 was not written to.");
                err = 1'b1;
                total_error[2] = 1'b1;
            end

        //check R3:
        sim_writenum = 3'd3;
        sim_readnum = 3'd3;
        sim_data_in = 16'd95;
        #10;
        assert (sim_data_out == 16'd95) $display("PASS! R3 was successfully written to.");
            else begin
                $error("FAIL! R3 was not written to.");
                err = 1'b1;
                total_error[3] = 1'b1;
            end

        //check R4:
        sim_writenum = 3'd4;
        sim_readnum = 3'd4;
        sim_data_in = 16'd10;
        #10;
        assert (sim_data_out == 16'd10) $display("PASS! R4 was successfully written to.");
            else begin
                $error("FAIL! R4 was not written to.");
                err = 1'b1;
                total_error[4] = 1'b1;
            end

        //check R5:
        sim_writenum = 3'd5;
        sim_readnum = 3'd5;
        sim_data_in = 16'd544;
        #10;
        assert (sim_data_out == 16'd544) $display("PASS! R5 was successfully written to.");
            else begin
                $error("FAIL! R5 was not written to.");
                err = 1'b1;
                total_error[5] = 1'b1;
            end
        
        //check R6:
        sim_writenum = 3'd6;
        sim_readnum = 3'd6;
        sim_data_in = 16'd64;
        #10;
        assert (sim_data_out == 16'd64) $display("PASS! R6 was successfully written to.");
            else begin
                $error("FAIL! R6 was not written to.");
                err = 1'b1;
                total_error[6] = 1'b1;
            end
        
        //check R7:
        sim_writenum = 3'd7;
        sim_readnum = 3'd7;
        sim_data_in = 16'd3;
        #10;
        assert (sim_data_out == 16'd3) $display("PASS! R7 was successfully written to.");
            else begin
                $error("FAIL! R7 was not written to.");
                err = 1'b1;
                total_error[7] = 1'b1;
            end
        //$stop;
    end

endmodule: regfile_tb