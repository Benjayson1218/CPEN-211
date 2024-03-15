`timescale 1 ps/ 1 ps

module tb_lab3_gate();
    // Declare Signals to Connect Device Under Test (DUT)
    reg [9:0] sim_switches;
    reg [3:0] sim_buttons;
    wire [6:0] sim_HEX0, sim_HEX1, sim_HEX2, sim_HEX3, sim_HEX4, sim_HEX5;
    reg [9:0] sim_LEDR;

    // Instantiating the lab3_top module
    lab3_top DUT (
        .SW(sim_switches),
        .KEY(~sim_buttons), // need to invert bec DE1 has -ve logic buttons
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
        
        // 1st test: try displaying the each digit type and the error message when not in state g or m
        sim_switches = 10'b0000000001; //display 1 on HEX0
        #5; 
        sim_switches = 10'b0000000010; //display 2 on HEX0
        #5; 
        sim_switches = 10'b0000000011; //display 3 on HEX0 and so on..
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
        sim_switches = 10'b0000001010; // display ErrOr on HEX4 to HEX0
        #5; 
        sim_switches = 10'b0000001011; // display ErrOr on HEX4 to HEX0
        #5; 
        sim_switches = 10'b0000001100; // display ErrOr on HEX4 to HEX0 same for last 3 lines too..
        #5;
        sim_switches = 10'b0000001101;
        #5;
        sim_switches = 10'b0000001110;
        #5;
        sim_switches = 10'b0000001111;
        #15; // long delay at the end to see when we start a new test
        

        
        // 2nd test: lets try inputting the lock's correct code
        // first reset lock
        sim_buttons = 4'b1000; // hold rst
        #5;
        sim_buttons = 4'b1001; // toggle clk
        #5;
        sim_buttons = 4'b1000;
        #5;
        sim_buttons = 4'b0000; // release rst
        #5;

        // now input lock code one at a time
        sim_switches = 10'b0000000000; // 0 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000111; // 7 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000000; // 0 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;
        
        sim_switches = 10'b0000001000; // 8 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #15; //long delay to differentiate between tests



        // 3rd test: include an extra input
        sim_switches = 10'b0000001111; // this would give ErrOr if lock isnt closed or open but lock is open so HEX3 to HEX0 should continue to display OPEn
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #15; //long delay to differentiate between tests

        

        // 4th test: input 3 correct digits and then 1 wrong digit and then 2 correct digits
        // reset lock
        sim_buttons = 4'b1000; // hold rst
        #5;
        sim_buttons = 4'b1001; // toggle clk
        #5;
        sim_buttons = 4'b1000;
        #5;
        sim_buttons = 4'b0000; // release rst
        #5;

        // input code into lock 
        sim_switches = 10'b0000000000; // 0 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000111; // 7 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000001000; // 8 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #15;  //long delay to differentiate between tests



        // 5th test: including a reset in the middle of inputing digits 
        // reset lock
        sim_buttons = 4'b1000; // hold rst
        #5;
        sim_buttons = 4'b1001; // toggle clk
        #5;
        sim_buttons = 4'b1000;
        #5;
        sim_buttons = 4'b0000; // release rst
        #5;

        // start inputting lock code
        sim_switches = 10'b0000000000; // 0 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        // reset lock
        sim_buttons = 4'b1000; // hold rst
        #5;
        sim_buttons = 4'b1001; // toggle clk
        #5;
        sim_buttons = 4'b1000;
        #5;
        sim_buttons = 4'b0000; // release rst
        #5;       

        // input a wrong lock code
        sim_switches = 10'b0000000111; // 7 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000010; // 2 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000001000; // 8 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000000; // 0 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;

        sim_switches = 10'b0000000001; // 1 on switches
        #5;
        sim_buttons = 4'b0001; // toggle clk
        #5;
        sim_buttons = 4'b0000;
        #5;
        
        $stop;
    end

endmodule: tb_lab3_gate
