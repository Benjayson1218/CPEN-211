// states
`define Decode 6'b000000   // updated from Wait state to Decode state for lab 7
`define Add_A 6'b000001
`define Add_B 6'b000010
`define Add_C 6'b000011
`define Add_D 6'b000100
`define CMP_A 6'b000101
`define CMP_B 6'b000110
`define CMP_C 6'b000111
`define And_A 6'b001000
`define And_B 6'b001001
`define And_C 6'b001010
`define And_D 6'b001011
`define MVN_A 6'b001100
`define MVN_B 6'b001101
`define MVN_C 6'b001110
`define MOV_A 6'b001111
`define MOV_B 6'b010000
`define MOV_C 6'b010001
`define MOV_Imm 6'b010010

// Lab 7 definitions
// states
`define IF1 6'b010011
`define IF2 6'b010100
`define UpdatePC 6'b010101
`define RST 6'b010110
// mem_cmd
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10
// memory instructions
`define LDR_A 6'b010111
`define LDR_B 6'b011000
`define LDR_C 6'b011001
`define LDR_D 6'b011010
`define LDR_E 6'b011011
`define STR_A 6'b011100
`define STR_B 6'b011101
`define STR_C 6'b011110
`define STR_D 6'b011111
`define STR_E 6'b100000
// special instruction
`define HALT 6'b100001

module cpu(clk, reset, read_data, write_data, N, V, Z, mem_addr, mem_cmd);
input [15:0] read_data; 
input clk, reset;
output [15:0] write_data; 
output N, V, Z;

// added outputs for lab 7
output [8:0] mem_addr;
output [1:0] mem_cmd;

wire [15:0] instructionData, sximm5, sximm8, mdata; // C = out
wire [2:0] regLocation, opcode, nsel;
wire [1:0] ALUop, shift, op, vsel;
wire [8:0] PC;
wire loada, loadb, loadc, loads, asel, bsel, write;

wire [8:0] next_pc;
wire load_pc, reset_pc, addr_sel, load_ir;

wire load_addr;
wire [8:0] data_address;



// connect together decoder, state machine, instruction register, and datapath here
// Instantiate instruction register
vDFFE #(16) instruct_reg(clk, load_ir, read_data, instructionData);

// Instatntiate the decoder
instructionDecoder InstructDecode(instructionData, opcode, op, nsel, ALUop, sximm5, sximm8, shift, regLocation);

// Instantiate state control machine
stateMachine stateControl(reset, opcode, op, clk, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, mem_cmd, addr_sel, load_pc, reset_pc, load_ir, load_addr);

// instantiate the datapath
datapath DP(clk, regLocation, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, regLocation, write, {Z,N,V}, write_data, read_data, sximm8, PC, sximm5);

// Lab 7 additions 
// PC register
vDFFE #(9) programCounter(clk, load_pc, next_pc, PC);

// 2 to 1 mux +1 counter
assign next_pc = reset_pc ? 9'd0 : PC + 1'b1;

// 2 to 1 mux for addr_sel
assign mem_addr = addr_sel ? PC : data_address;

// Instantiate the data address register
vDFFE #(9) DataAddress_reg(clk, load_addr, write_data[8:0], data_address);

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











module stateMachine(reset, opcode, op, clk, nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, mem_cmd, addr_sel, load_pc, reset_pc, load_ir, load_addr); 
input clk, reset;
input [2:0] opcode; 
input [1:0] op; 
output reg [2:0] nsel;
output reg [1:0] vsel;
output reg loada, loadb, loadc, loads, asel, bsel, write;

output reg [1:0] mem_cmd;
output reg addr_sel, load_pc, reset_pc, load_ir, load_addr;

reg [5:0] present_state; // present state of state machine (6-bit bus)

 always_ff @(posedge clk) begin
    if(reset) begin // handle synchronous reset
      present_state = `RST;
    end else begin // no reset triggered, handle states
      case(present_state)
        `Decode: begin
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
                    present_state <= `Decode;

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
                    present_state <= `Decode;

                end // end for if statement mov instructions

            // STR INSTRUCTIONS
            else if(opcode == 3'b100) begin
                if(op == 2'b00)
                    present_state <= `STR_A;
                else
                    present_state <= `Decode;
                end

            // LDR INSTRUCTIONS
            else if(opcode == 3'b011) begin
                if(op == 2'b00)
                    present_state <= `LDR_A;
                else
                    present_state <= `Decode;
                end

            // HALT INSTRUCTIONS
            else if(opcode == 3'b111)
                present_state <= `HALT;                

            // not a valid opcode         
            else
                present_state <= `Decode;

        end // end of the begin for the decode state

        `Add_A: present_state <= `Add_B;
        `Add_B: present_state <= `Add_C;
        `Add_C: present_state <= `Add_D;
        `Add_D: present_state <= `IF1;
        `CMP_A: present_state <= `CMP_B;
        `CMP_B: present_state <= `CMP_C;
        `CMP_C: present_state <= `IF1;
        `And_A: present_state <= `And_B;
        `And_B: present_state <= `And_C;
        `And_C: present_state <= `And_D;
        `And_D: present_state <= `IF1;
        `MVN_A: present_state <= `MVN_B;
        `MVN_B: present_state <= `MVN_C;
        `MVN_C: present_state <= `IF1;
        `MOV_A: present_state <= `MOV_B;
        `MOV_B: present_state <= `MOV_C;
        `MOV_C: present_state <= `IF1;
        `MOV_Imm: present_state <= `IF1;
        `IF1: present_state <= `IF2;
        `IF2: present_state <= `UpdatePC;
        `UpdatePC: present_state <= `Decode;
        `RST: present_state <= `IF1;
        `LDR_A: present_state <= `LDR_B;
        `LDR_B: present_state <= `LDR_C;
        `LDR_C: present_state <= `LDR_D;
        `LDR_D: present_state <= `LDR_E;
        `LDR_E: present_state <= `IF1;
        `STR_A: present_state <= `STR_B;
        `STR_B: present_state <= `STR_C;
        `STR_C: present_state <= `STR_D;
        `STR_D: present_state <= `STR_E;
        `STR_E: present_state <= `IF1;
        `HALT: present_state <= `HALT;
        default: present_state <= `IF1;
      endcase
    end // end else statement
  end // end always block for Moore machine                             
                                                                          
always @(*) begin      
    case(present_state)
        `Add_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b100_00_1_0_0_0_0_0_0, 7'd0};
        `Add_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_1_0_0_0_0_0, 7'd0};
        `Add_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_0_1_0_0_0_0, 7'd0};
        `Add_D: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b010_00_0_0_0_0_0_0_1, 7'd0};
        `CMP_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b100_00_1_0_0_0_0_0_0, 7'd0};
        `CMP_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_1_0_0_0_0_0, 7'd0};
        `CMP_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_0_0_1_0_0_0, 7'd0};
        `And_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b100_00_1_0_0_0_0_0_0, 7'd0};
        `And_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_1_0_0_0_0_0, 7'd0};
        `And_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_0_1_0_0_0_0, 7'd0};
        `And_D: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b010_00_0_0_0_0_0_0_1, 7'd0};
        `MVN_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_1_0_0_0_0_0, 7'd0};
        `MVN_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_0_1_0_1_0_0, 7'd0};
        `MVN_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b010_00_0_0_0_0_0_0_1, 7'd0};
        `MOV_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_1_0_0_0_0_0, 7'd0};
        `MOV_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b001_00_0_0_1_0_1_0_0, 7'd0};
        `MOV_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b010_00_0_0_0_0_0_0_1, 7'd0};
        `MOV_Imm: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {12'b100_10_0_0_0_0_0_0_1, 7'd0};

        `IF1: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_1_0,`MREAD,3'b0_0_0};
        `IF2: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_1_1,`MREAD,3'b0_0_0};
        `UpdatePC: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_0_0,`MNONE,3'b1_0_0};
        `RST: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_0_0,`MNONE,3'b1_1_0};
        
        `LDR_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b100_00_1_0_0_0_0_0_0_0_0,`MNONE,3'b0_0_0};
        `LDR_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_1_0_0_1_0_0_0,`MNONE,3'b0_0_0};
        `LDR_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_1_0_0_0_0_0_0_0_0,`MNONE,3'b0_0_1};
        `LDR_D: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_1_0_0_0_0_0_0_0_0,`MREAD,3'b0_0_0};
        `LDR_E: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b010_11_1_0_0_0_0_0_1_0_0,`MREAD,3'b0_0_0};
        
        `STR_A: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b100_00_1_0_0_0_0_0_0_0_0,`MNONE,3'b0_0_0};
        `STR_B: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_1_0_0_1_0_0_0,`MNONE,3'b0_0_0};
        `STR_C: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b010_00_0_1_0_0_0_0_0_0_0,`MNONE,3'b0_0_1};
        `STR_D: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_1_0_1_0_0_0_0,`MNONE,3'b0_0_0};
        `STR_E: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_0_0,`MWRITE,3'b0_0_0};

        `HALT: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_0_0,`MNONE,3'b0_0_0};   

        default: {nsel, vsel, loada, loadb, loadc, loads, asel, bsel, write, addr_sel, load_ir, mem_cmd, load_pc, reset_pc, load_addr} = {14'b001_00_0_0_0_0_0_0_0_1_0,`MREAD,3'b0_0_0}; // IF1 state is defualt
    endcase // end case statement
end // end for combinational logic always block
endmodule // end statemachine module
