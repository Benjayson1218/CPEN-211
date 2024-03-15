// mem_cmd
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10


module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [1:0] mem_cmd;
    wire [8:0] mem_addr;
    wire [15:0] read_data, write_data;
    wire write;

    reg msel;
    reg [1:0] mread, mwrite;
    wire [15:0] dout, din;
    wire [7:0] read_address, write_address;
    wire N,V,Z;

    reg LEDload, swEN;

    cpu CPU(
        .clk(~KEY[0]), 
        .reset(~KEY[1]), 
        .read_data(read_data), 
        .write_data(write_data), 
        .N(N), 
        .V(V), 
        .Z(Z), 
        .mem_addr(mem_addr), 
        .mem_cmd(mem_cmd) 
    ); 

    

    RAM MEM(
        .clk(~KEY[0]),
        .read_address(mem_addr[7:0]),
        .write_address(mem_addr[7:0]),
        .write(write),
        .din(write_data),
        .dout(dout)
    );

    //Equality statements 
    always_comb begin
        case(mem_cmd)
        `MREAD: begin // read from mem
            mread = 1'b1;
            mwrite = 1'b0;
            end
        `MWRITE: begin // write to mem
            mread = 1'b0;
            mwrite = 1'b1;
            end
        `MNONE: begin // none
            mread = 1'b0;
            mwrite = 1'b0;
            end
        default: begin 
            mread = 1'bx;
            mwrite = 1'bx;
            end
        endcase

        if(mem_addr[8] == 1'b0) 
            msel = 1'b1;
        else
            msel = 1'b0;
    end




    // Stage 3 Additions (circuit 2)
    always_comb begin
        if((mem_addr == 9'h100) & (mem_cmd == `MWRITE))
            LEDload = 1'b1;
        else
            LEDload = 1'b0;
    end

    vDFFE #(8) LEDreg(~KEY[0], LEDload, write_data[7:0], LEDR[7:0]);



    // Stage 3 Additions (circuit 1)
    assign read_data[7:0] = swEN ? SW[7:0] : {8{1'bz}};    
    assign read_data[15:8] = swEN ? 8'd0 : {8{1'bz}}; 
    
    always_comb begin
        if((mem_addr == 9'h140) & (mem_cmd == `MREAD))
            swEN = 1'b1;
        else
            swEN = 1'b0;
    end



    // tri-state driver for dout and AND gate logic
    assign read_data = (msel & mread) ? dout : {16{1'bz}};
    assign write = msel & mwrite;

    // assign HEX5[0] = ~Z;
    // assign HEX5[3] = ~V;
    // assign HEX5[6] = ~N;

    // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
    // sseg H0(write_data[3:0],   HEX0);
    // sseg H1(write_data[7:4],   HEX1);
    // sseg H2(write_data[11:8],  HEX2);
    // sseg H3(write_data[15:12], HEX3);
    // assign HEX4 = 7'b1111111;
    // assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
    // assign LEDR[8] = 1'b0;


endmodule







module RAM(clk,read_address,write_address,write,din,dout);
    parameter data_width = 16; 
    parameter addr_width = 8;
    parameter filename = "data.txt";

    input clk;
    input [addr_width-1:0] read_address, write_address;
    input write;
    input [data_width-1:0] din;
    output [data_width-1:0] dout;
    reg [data_width-1:0] dout;

    reg [data_width-1:0] mem [2**addr_width-1:0];

    initial $readmemb(filename, mem);

    always @ (posedge clk) begin
        if (write)
            mem[write_address] <= din;
        dout <= mem[read_address];      // dout doesn't get din in this clock cycle 
                                        // (this is due to Verilog non-blocking assignment "<=")
    end 
endmodule






module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;

  always @(*) begin
    // update hex displays here
    case(in)
      4'd0: segs = 7'b1000000;
      4'd1: segs = 7'b1111001;
      4'd2: segs = 7'b0100100;
      4'd3: segs = 7'b0110000;
      4'd4: segs = 7'b0011001;
      4'd5: segs = 7'b0010010;
      4'd6: segs = 7'b0000010;
      4'd7: segs = 7'b1111000;
      4'd8: segs = 7'b0000000;
      4'd9: segs = 7'b0010000;
      4'd10: segs = 7'b0001000; // A
      4'd11: segs = 7'b0000011; // b
      4'd12: segs = 7'b1000110; // C
      4'd13: segs = 7'b0100001; // d
      4'd14: segs = 7'b0000110; // E
      4'd15: segs = 7'b0001110; // F
      default: segs = 7'bxxxxxxx;
    endcase
  end 
endmodule
