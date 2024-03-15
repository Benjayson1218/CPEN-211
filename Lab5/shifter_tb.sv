module shifter_tb();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [15:0] sim_in;
    reg [1:0] sim_shift;
    wire [15:0] sim_sout;
    reg err;
    reg [3:0] total_error;

    // Instantiating the shifter module
    shifter DUT (
        .in(sim_in),
        .shift(sim_shift),
        .sout(sim_sout)
    );

    // test the various cases
    initial begin
        err = 0; // set error to 0 initially
        total_error = 0;
        sim_in = 16'b1111000011001111;
        
        //===== Test the Operation that doesn't Change the Input =====
        sim_shift = 2'b00;
        #5;
            assert (sim_sout == 16'b1111000011001111) $display("PASS! NO SHIFT was successful");
            else begin
                $error("FAIL! NO SHIFT not successful");
                err = 1'b1;
                total_error[0] = 1'b1;
            end

        //===== Test Shift Left where LSB Should be 0 =====
        sim_shift = 2'b01;
        #5;
            assert (sim_sout == 16'b1110000110011110) $display("PASS! LEFT SHIFT was successful");
            else begin
                $error("FAIL! LEFT SHIFT not successful");
                err = 1'b1;
                total_error[1] = 1'b1;
            end

        //===== Test Shift Right where MSB Should be 0 =====
        sim_shift = 2'b10;
        #5;
            assert (sim_sout == 16'b0111100001100111) $display("PASS! RIGHT SHIFT was successful");
            else begin
                $error("FAIL! RIGHT SHIFT not successful");
                err = 1'b1;
                total_error[2] = 1'b1;
            end

        //==== Test Shift Right where MSB Should be copy of B[15] ====
        sim_shift = 2'b11;
        #5;
            assert (sim_sout == 16'b1111100001100111) $display("PASS! LEFT SHIFT MSB COPY was successful");
            else begin
                $error("FAIL! LEFT SHIFT MSB COPY not successful");
                err = 1'b1;
                total_error[3] = 1'b1;
            end

        //$stop;
    end

endmodule: shifter_tb