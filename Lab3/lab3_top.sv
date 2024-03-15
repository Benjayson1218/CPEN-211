//`define SL 4 // state length
`define Sa 4'b0000
`define Sb 4'b0001
`define Sc 4'b0010
`define Sd 4'b0011
`define Se 4'b0100
`define Sf 4'b0101
`define Sg 4'b0110
`define Sh 4'b0111
`define Si 4'b1000
`define Sj 4'b1001
`define Sk 4'b1010
`define Sl 4'b1011
`define Sm 4'b1100

// off
`define OFF 7'b1111111

// ErrOr
`define E 7'b0000110
`define r 7'b0101111
// O is displayed the same as 0

// OPEn
`define P 7'b0001100
`define n 7'b0101011
// O is displayed the same as 0

// CLOSED
`define C 7'b1000110
`define L 7'b1000111
`define S 7'b0010010
// O is displayed the same as 0
// E is already defined in ErrOr
// D is displayed the same as 0

// Digits
`define ZERO  7'b1000000
`define ONE   7'b1111001
`define TWO   7'b0100100
`define THREE 7'b0110000
`define FOUR  7'b0011001
`define FIVE  7'b0010010
`define SIX   7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE  7'b0010000


module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // note: modified to reg bec we are changing value in always block
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low
  
  // put your solution code here!
  wire [3:0] in = SW[3:0]; // we are only using SW0 to SW3
  reg [3:0] present_state; // present state of state machine (4-bit bus)

  // always block for Moore machine (Type 2)
  always_ff @(posedge clk) begin
    if(~rst_n) begin // handle synchronous active low reset
      present_state = `Sa;
    end else begin // no reset triggered, handle states
      case(present_state)
        `Sa: begin if(in == 4'b0000)  // correct 1st digit entered
                present_state = `Sb;
              else  // not correct digit
                present_state = `Sh;
        end
        `Sb: begin if(in == 4'b0001) // correct 2nd digit entered
                present_state = `Sc;
              else  // not correct digit
                present_state = `Si;
        end      
        `Sc: begin if(in == 4'b0111) // correct 3rd digit entered
                present_state = `Sd;
              else  // not correct digit
                present_state = `Sj;
        end      
        `Sd: begin if(in == 4'b0000)  // correct 4th digit entered
                present_state = `Se;
              else  // not correct digit
                present_state = `Sk;
        end      
        `Se: begin if(in == 4'b0010)  // correct 5th digit entered
                present_state = `Sf;
              else  // not correct digit
                present_state = `Sl; 
        end
        `Sf: begin if(in == 4'b1000) // correct 6th digit entered
                present_state = `Sg;
              else // not correct digit
                present_state = `Sm;
        end
        `Sg:  present_state = `Sg;     // stay in Sg until we reset
        `Sl:  present_state = `Sm;     // had to reverse order for sl to sh so that we dont update all at once
        `Sk:  present_state = `Sl;    
        `Sj:  present_state = `Sk; 
        `Si:  present_state = `Sj; 
        `Sh:  present_state = `Si;  
        `Sm:  present_state = `Sm;       // stay in Sm until we reset
        default: present_state = 4'bxxxx;
      endcase
    end // end else statement
  end // end always block for Moore machine

  // always block for Combinational logic
  always @(*) begin
    // update displays here
    case(in)
      4'd0: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 0
              HEX0 = `ZERO;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd1: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 1
              HEX0 = `ONE;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd2: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 2
              HEX0 = `TWO;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd3: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 3
              HEX0 = `THREE;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd4: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 4
              HEX0 = `FOUR;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd5: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 5
              HEX0 = `FIVE;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd6: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 6
              HEX0 = `SIX;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd7: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 7
              HEX0 = `SEVEN;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd8: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 8
              HEX0 = `EIGHT;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      4'd9: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin
              // display decimal 9
              HEX0 = `NINE;
              HEX1 = `OFF;
              HEX2 = `OFF;
              HEX3 = `OFF;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end
      end
      default: begin if(present_state == `Sg) begin
              // display OPEn
              HEX0 = `n;          
              HEX1 = `E;
              HEX2 = `P;
              HEX3 = `ZERO;
              HEX4 = `OFF;
              HEX5 = `OFF;
            end 
            else if(present_state == `Sm) begin
              // display CLOSED
              HEX0 = `ZERO;
              HEX1 = `E;
              HEX2 = `S;
              HEX3 = `ZERO;
              HEX4 = `L;
              HEX5 = `C;
            end 
            else begin // display ErrOr
              HEX0 = `r;
              HEX1 = `ZERO;
              HEX2 = `r;
              HEX3 = `r;
              HEX4 = `E;
              HEX5 = `OFF;
            end
      end
    endcase
  end // end the always block for Combinational logic
endmodule
