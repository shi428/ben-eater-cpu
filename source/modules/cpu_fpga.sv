`include "cpu_if.vh"
module cpu_fpga
(
    input logic CLOCK_50,
    input logic [17:0] SW,
    input logic [3:0] KEY,
    output logic [17:0] LEDR,
    output logic [8:0] LEDG,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5,
    output logic [6:0] HEX6,
    output logic [6:0] HEX7
);

logic clockMode;
logic CLK, nRST, divCLK;
cpu_if cif();
controller_if coif();

cpu CPU(CLK, nRST, cif, coif);

clkdiv DIV(CLOCK_50, nRST, SW[15:0], divCLK);
logic [6:0] digit [7:0];

assign LEDG[3:0] = KEY;
assign nRST = LEDG[0];
assign CLK = clockMode ? LEDG[1] & ~coif.halt: divCLK & ~coif.halt;
assign cif.WEN = ~LEDG[2];
assign LEDG[4] = CLK;
assign LEDG[8] = cif.halt;
assign clockMode = SW[17];
assign cif.mode = SW[16];
assign cif.addr = cif.mode ? SW[11:8] : 0;
assign cif.instr = cif.mode ? SW[7:0] : 0;
assign LEDR =  ~cif.mode ? {SW[17], SW[16], coif.zero, coif.carry, coif.halt, coif.addressWEN, coif.ramWEN, coif.ramREN, coif.iWEN, coif.iREN, coif.aWEN, coif.aREN, coif.aluREN, coif.sub, coif.bWEN, coif.outputWEN, coif.pcEN, coif.pcREN} : SW;
assign LEDG[7:6] = ~cif.mode ? {coif.jump, coif.flagWEN} : 0;
assign digit[0] = cif.ramload[0] ? 7'b1111001 : 7'b1000000;
assign digit[1] = cif.ramload[1] ? 7'b1111001 : 7'b1000000;
assign digit[2] = cif.ramload[2] ? 7'b1111001 : 7'b1000000;
assign digit[3] = cif.ramload[3]? 7'b1111001 : 7'b1000000;
assign digit[4] = cif.ramload[4] ? 7'b1111001 : 7'b1000000;
assign digit[5] = cif.ramload[5] ? 7'b1111001 : 7'b1000000;
assign digit[6] = cif.ramload[6] ? 7'b1111001 : 7'b1000000;
assign digit[7] = cif.ramload[7] ? 7'b1111001 : 7'b1000000;
assign HEX0 = cif.mode ? digit[0] : cif.display[0];
assign HEX1 = cif.mode ? digit[1] : cif.display[1];
assign HEX2 = cif.mode ? digit[2] : 7'b1111111;
assign HEX3 = cif.mode ? digit[3] : 7'b1111111;
assign HEX4 = cif.mode ? digit[4] : 7'b1111111;
assign HEX5 = cif.mode ? digit[5] : 7'b1111111;
assign HEX6 = cif.mode ? digit[6] : 7'b1111111;
assign HEX7 = cif.mode ? digit[7] : 7'b1111111;
endmodule
