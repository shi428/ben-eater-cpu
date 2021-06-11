`ifndef CPU_IF_VH
`define CPU_IF_VH

interface cpu_if;
    logic mode;
    logic halt;
    logic WEN;
    logic [6:0] display [2:0];
    logic [7:0] instr;
    logic [3:0] addr;
    logic [7:0] ramload;
    modport cpu (
        input mode, instr, addr, WEN,
        output halt, display, ramload
    );

    modport tb (
        input halt, display, ramload,
        output mode, instr, addr, WEN
    );
endinterface
`endif
