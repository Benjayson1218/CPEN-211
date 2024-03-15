module tb_lab3();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [9:0] sim_switches;
    reg [3:0] sim_buttons;
    wire [6:0] sim_HEX0, sim_HEX1, sim_HEX2, sim_HEX3, sim_HEX4, sim_HEX5;
    reg [9:0] sim_LEDR;
    
    // Instantiating the lab3_top module
    lab3_top DUT (
        .SW(sim_switches),
        .KEY(~sim_buttons),
        .HEX0(sim_HEX0),
        .HEX1(sim_HEX1),
        .HEX2(sim_HEX2),
        .HEX3(sim_HEX3),
        .HEX4(sim_HEX4),
        .HEX5(sim_HEX5),
        .LEDR(sim_LEDR)
    );

    // Initial Test Script
    initial begin
        // Start out by Setting Buttons to "Not-Pushed" and Switches to "off" position
        sim_switches = 10'd0;
        sim_buttons = 4'b0000;

        // Wait Five Simulation Timesteps to Allow Those Changes to Happen
        #5;
        // Technically zero should be displayed right now on HEX0
        
        // 1st test: try displaying the each digit type on HEX0 and the ErrOr message when not in state g or m
        sim_switches = 10'b0000000001; // display 1 on HEX0
        #5; 
        sim_switches = 10'b0000000010; // display 2 on HEX0 and so on..
        #5; 
        sim_switches = 10'b0000000011;
        #5; 
        sim_switches = 10'b0000000100;
        #5; 
        sim_switches = 10'b0000000101;
        #5; 
        sim_switches = 10'b0000000110;
        #5; 
        sim_switches = 10'b0000000111;
        #5; 
        sim_switches = 10'b0000001000;
        #5; 
        sim_switches = 10'b0000001001;
        #5; 
        sim_switches = 10'b0000001010; // the next values are > 9 so display ErrOr
        #5; 
        sim_switches = 10'b0000001011;
        #5; 
        sim_switches = 10'b0000001100;
        #5;
        sim_switches = 10'b0000001101;
        #5;
        sim_switches = 10'b0000001110;
        #5;
        sim_switches = 10'b0000001111;
        #15; // long delay at the end to see when we start a new test
        

        
        // 2nd test: lets try inputting the lock's correct code
        // reset lock
        sim_buttons = 4'b1000; // hold reset
        sim_buttons = 4'b1001; // press
        #5;
        sim_buttons = 4'b1000; // release clk
        #5;
        sim_buttons = 4'b0000; // release reset
        #5;

        // now input each digit one by one
        sim_switches = 10'b0000000000; // 0 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000111; // 7 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000000; // 0 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;
        
        sim_switches = 10'b0000001000; // 8 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;



        // 3rd test: include an extra input
        sim_switches = 10'b0000001111; // should give error but display continues with OPEn
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #15; //long delay to differentiate between tests


        
        // 4th test: input 3 correct digit and then 1 wrong digit and then 2 correct digits
        // reset the lock
        sim_buttons = 4'b1000; // hold reset
        sim_buttons = 4'b1001; // press
        #5;
        sim_buttons = 4'b1000; // release clk
        #5;
        sim_buttons = 4'b0000; // release reset
        #5;

        // input each digit one by one
        sim_switches = 10'b0000000000; // 0 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000111; // 7 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000001000; // 8 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #15;  //long delay to differentiate between tests
        


        // 5th test: including a reset in the middle of inputing digits 
        // reset the lock
        sim_buttons = 4'b1000; // hold reset
        sim_buttons = 4'b1001; // press
        #5;
        sim_buttons = 4'b1000; // release clk
        #5;
        sim_buttons = 4'b0000; // release reset
        #5;

        // start inputting the some digits
        sim_switches = 10'b0000000000; // 0 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        // reset the lock
        sim_buttons = 4'b1000; // hold reset
        sim_buttons = 4'b1001; // press
        #5;
        sim_buttons = 4'b1000; // release clk
        #5;
        sim_buttons = 4'b0000; // release reset
        #5;        

        // input digits (not the correct lock's code)
        sim_switches = 10'b0000000111; // 7 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000001000; // 8 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000000; // 0 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        sim_buttons = 4'b0001; // press and release clk
        #5;
        sim_buttons = 4'b0000;
        #5;
        
        $stop;
    end

endmodule: tb_lab3
