`include "cpu_if.vh"
`include "controller_if.vh"
module cpu
(
    input logic CLK,
    input logic nRST,
    cpu_if.cpu cif,
    controller_if.cpu coif
);
//control signals
logic addressWEN, ramWEN, ramREN, iWEN, iREN, aWEN, aREN, aluREN, bWEN, outputWEN, pcEN, pcREN, jump, flagWEN;
logic sub;
logic overflow, zero, overflow_ff, zero_ff;
logic halt;

logic [7:0] ramdat, IR_dat, A_dat, B_dat, alu_out;
logic [3:0] pc;
logic [7:0] bus;
logic [3:0] addr;

register #(.WIDTH(4)) memAddrReg(CLK, nRST, addressWEN, bus[3:0], addr);

ram r(CLK, cif.mode ? cif.WEN : ramWEN, cif.mode ? cif.addr : addr, cif.mode ? cif.instr : bus, ramdat);

register IR(CLK, nRST, iWEN, bus, IR_dat);

pc PC(CLK, nRST, pcEN, jump, bus[3:0], pc);

register A(CLK, nRST, aWEN, bus, A_dat);

register B(CLK, nRST, bWEN, bus, B_dat);

register #(.WIDTH(2)) flags(CLK, nRST, flagWEN, {overflow, zero}, {overflow_ff, zero_ff});

alu ALU(A_dat, B_dat, sub, alu_out, overflow, zero);

display disp(CLK, nRST, outputWEN, bus, cif.display);
control_unit ctrl (
    CLK, 
    nRST,
    ~cif.mode,
    IR_dat[7:4],
    zero_ff,
    overflow_ff,
    halt,
    addressWEN,
    ramWEN,
    ramREN,
    iWEN,
    iREN, 
    aWEN,
    aREN,
    aluREN,
    sub,
    bWEN,
    outputWEN,
    pcEN,
    pcREN,
    jump,
    flagWEN
);

//bus control
always_comb begin
    bus = '0;
    if (ramREN) begin
        bus = ramdat;
    end
    else if (iREN) begin
        bus = {4'b0, IR_dat[3:0]};
    end
    else if (aREN) begin
        bus = A_dat;
    end
    else if (aluREN) begin
        bus = alu_out;
    end
    else if (pcREN) begin
        bus = {4'b0, pc};
    end
end
assign cif.halt = halt;
assign cif.ramload = ramdat;
assign coif.zero = zero_ff;
assign coif.carry = overflow_ff;
assign coif.halt = halt;
assign coif.addressWEN = addressWEN;
assign coif.ramWEN = ramWEN;
assign coif.ramREN = ramREN;
assign coif.iREN = iREN;
assign coif.iWEN = iWEN;
assign coif.aREN = aREN;
assign coif.aWEN = aWEN;
assign coif.aluREN = aluREN;
assign coif.sub = sub;
assign coif.bWEN = bWEN;
assign coif.outputWEN = outputWEN;
assign coif.pcEN = pcEN;
assign coif.pcREN = pcREN;
assign coif.jump = jump;
assign coif.flagWEN = flagWEN;

endmodule
