// states
`define Wait 5'b00000
`define Add_A 5'b00001
`define Add_B 5'b00010
`define Add_C 5'b00011
`define Add_D 5'b00100
`define CMP_A 5'b00101
`define CMP_B 5'b00110
`define CMP_C 5'b00111
`define And_A 5'b01000
`define And_B 5'b01001
`define And_C 5'b01010
`define And_D 5'b01011
`define MVN_A 5'b01100
`define MVN_B 5'b01101
`define MVN_C 5'b01110
`define MOV_A 5'b01111
`define MOV_B 5'b10000
`define MOV_C 5'b10001
`define MOV_Imm 5'b10010

module cpu(clk, reset, s, load, in, out, N, V, Z, w); 
input clk, reset, s, load; 
input [15:0] in; 
output [15:0] out; 
output N, V, Z, w;

wire [15:0] instructionData, sximm5, sximm8, mdata; // C = out
wire [2:0] regLocation, opcode, nsel;
wire [1:0] ALUop, shift, op, vsel;
wire [7:0] PC;
wire loada, loadb, loadc, loads, asel, bsel, write;

// assign zero to mdata and PC for now
assign mdata = 16'b0;
assign PC = 8'b0;


// connect together decoder, state machine, instruction register, and datapath here
// Instantiate instruction register
vDFFE #(16) instruct_reg(clk, load, in, instructionData);

// Instatntiate the decoder
instructionDecoder InstructDecode(instructionData, opcode, op, nsel, ALUop, sximm5, sximm8, shift, regLocation);

// Instantiate state control machine
stateMachine stateControl(s, reset, w, opcode, op, clk, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write); 

// instantiate the datapath
datapath DP(clk, regLocation, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, regLocation, write, {N,V,Z}, out, mdata, sximm8, PC, sximm5);

endmodule





module instructionDecoder(instructionData, opcode, op, nsel, ALUop, sximm5, sximm8, shift, regLocation); 

input [15:0] instructionData;
input [2:0] nsel;
output [1:0] ALUop, shift, op;
output [15:0] sximm5, sximm8;
output [2:0] regLocation, opcode;

wire [2:0] Rn, Rd, Rm;
wire [4:0] imm5;
wire [7:0] imm8;

assign ALUop = instructionData [12:11];
assign imm5 =instructionData [4:0];
assign imm8 = instructionData [7:0];
assign shift = instructionData [4:3];
assign Rn = instructionData [10:8];
assign Rd = instructionData [7:5];
assign Rm =instructionData [2:0];
assign op = instructionData [12:11];
assign opcode = instructionData [15:13];

Mux3 #(3) regLocationMux(Rm, Rd, Rn, nsel, regLocation); // mux to select reg

assign sximm5 = { {11{imm5[4]}}, imm5}; // extend the sign
assign sximm8 = { {8{imm8[7]}}, imm8}; // extend the sign
endmodule











module stateMachine(s, reset, w, opcode, op, clk, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write); 
input clk, reset, s;
input [2:0] opcode; 
input [1:0] op; 
output reg [2:0] nsel;
output reg [1:0] vsel;
output reg loada, loadb, loadc, loads, asel, bsel, write, w;

reg [4:0] present_state; // present state of state machine (5-bit bus)

 always_ff @(posedge clk) begin
    if(reset) begin // handle synchronous reset
      present_state = `Wait;
    end else begin // no reset triggered, handle states
      case(present_state)
        `Wait: begin
            if(s == 1'b1) begin   
                // ALU INSTRUCTIONS 
                if(opcode == 3'b101) begin
                    // add operation
                    if(op == 2'b00)
                        present_state <= `Add_A;

                    // cmp operation
                    else if(op == 2'b01)
                        present_state <= `CMP_A;

                    // and operation
                    else if(op == 2'b10)
                        present_state <= `And_A;
                    
                    // mvn operation
                    else if(op == 2'b11)
                        present_state <= `MVN_A;

                    // not a valid alu operation
                    else
                        present_state <= `Wait;
                    end // end for if statement alu instructions

                // MOV INSTRUCTIONS
                else if(opcode == 3'b110) begin
                    // mov reg value to reg
                    if(op == 2'b00)
                        present_state <= `MOV_A;

                    // immediate mov
                    else if(op == 2'b10)
                        present_state <= `MOV_Imm;

                    // not a valid mov instruction
                    else
                        present_state <= `Wait;

                    end // end for if statement mov instructions

                // not a valid opcode         
                else
                    present_state <= `Wait; 
            end // end for if statement of checking s == 1

            // s != 1, stay in wait
            else
                present_state <= `Wait;
        end // end of the begin for the wait state

        `Add_A: present_state <= `Add_B;
        `Add_B: present_state <= `Add_C;
        `Add_C: present_state <= `Add_D;
        `Add_D: present_state <= `Wait;
        `CMP_A: present_state <= `CMP_B;
        `CMP_B: present_state <= `CMP_C;
        `CMP_C: present_state <= `Wait;
        `And_A: present_state <= `And_B;
        `And_B: present_state <= `And_C;
        `And_C: present_state <= `And_D;
        `And_D: present_state <= `Wait;
        `MVN_A: present_state <= `MVN_B;
        `MVN_B: present_state <= `MVN_C;
        `MVN_C: present_state <= `Wait;
        `MOV_A: present_state <= `MOV_B;
        `MOV_B: present_state <= `MOV_C;
        `MOV_C: present_state <= `Wait;
        `MOV_Imm: present_state <= `Wait;
        default: present_state <= `Wait;
      endcase
    end // end else statement
  end // end always block for Moore machine

always @(*) begin
    case(present_state)                                                        //   w   n   v a b c s as bs wr
        `Add_A: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_100_00_1_0_0_0_0_0_0;
        `Add_B: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_1_0_0_0_0_0;
        `Add_C: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_0_1_0_0_0_0;
        `Add_D: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_010_00_0_0_0_0_0_0_1;
        `CMP_A: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_100_00_1_0_0_0_0_0_0;
        `CMP_B: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_1_0_0_0_0_0;
        `CMP_C: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_0_0_1_0_0_0;
        `And_A: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_100_00_1_0_0_0_0_0_0;
        `And_B: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_1_0_0_0_0_0;
        `And_C: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_0_1_0_0_0_0;
        `And_D: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_010_00_0_0_0_0_0_0_1;
        `MVN_A: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_1_0_0_0_0_0;
        `MVN_B: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_0_1_0_1_0_0;
        `MVN_C: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_010_00_0_0_0_0_0_0_1;
        `MOV_A: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_1_0_0_0_0_0;
        `MOV_B: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_001_00_0_0_1_0_1_0_0;
        `MOV_C: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_010_00_0_0_0_0_0_0_1;
        `MOV_Imm: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b0_100_10_0_0_0_0_0_0_1;
        default: {w, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write} = 13'b1_001_00_0_0_0_0_0_0_0; // wait state is defualt
    endcase // end case statement
end // end for combinational logic always block
endmodule // end statemachine module
