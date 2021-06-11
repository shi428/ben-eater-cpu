`timescale 1 ns / 1 ns

`include "controller_if.vh"
`include "cpu_if.vh"

module cpu_tb;
    parameter PERIOD = 10;
    logic CLK = 1, nRST;
    always #(PERIOD / 2) CLK++;

    cpu_if cif();
    controller_if coif();

    cpu CPU(CLK, nRST, cif, coif);


    logic [7:0] a_dat, b_dat;
    logic [6:0] display [2:0];


    task write_mem; begin
        @(posedge CLK);
        cif.WEN = 1;
        @(posedge CLK);
        cif.WEN = 0;
        @(posedge CLK);
    end
    endtask

    function [7:0] convert_display_to_int
    (   
        input logic [6:0] display [2:0]
    );
    logic [3:0] ones, tens;

    begin
        unique casez (display[0])
            7'b1000000: ones = 0;
            7'b1111001: ones = 1;
            7'b0100100: ones = 2;
            7'b0110000: ones = 3;
            7'b0011001: ones = 4;
            7'b0010010: ones = 5;
            7'b0000010: ones = 6;
            7'b1111000: ones = 7;
            7'b0000000: ones = 8;
            7'b0010000: ones = 9;
            7'b0001000: ones = 10;
            7'b0000011: ones = 11;
            7'b0100111: ones = 12;
            7'b0100001: ones = 13;
            7'b0000110: ones = 14;
            7'b0001110: ones = 15;
        endcase
        unique casez (display[1])
            7'b1000000: tens = 0;
            7'b1111001: tens = 1;
            7'b0100100: tens = 2;
            7'b0110000: tens = 3;
            7'b0011001: tens = 4;
            7'b0010010: tens = 5;
            7'b0000010: tens = 6;
            7'b1111000: tens = 7;
            7'b0000000: tens = 8;
            7'b0010000: tens = 9;
            7'b0001000: tens = 10;
            7'b0000011: tens = 11;
            7'b0100111: tens = 12;
            7'b0100001: tens = 13;
            7'b0000110: tens = 14;
            7'b0001110: tens = 15;
        endcase
        convert_display_to_int = {tens, ones};
    end 
    endfunction
    initial begin
        nRST = 1'b0;
        @(posedge CLK);
        nRST = 1'b1;
        cif.mode = 1;
        cif.WEN = 0;
        cif.addr = 0;
        cif.instr = 8'b01010001;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01001110;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01010000;
        write_mem;
        cif.addr++;
        cif.instr = 8'b11100000;
        write_mem;
        cif.addr++;
        cif.instr = 8'b00101110;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01001111;
        write_mem;
        cif.addr++;
        cif.instr = 8'b00011110;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01001101;
        write_mem;
        cif.addr++;
        cif.instr = 8'b00011111;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01001110;
        write_mem;
        cif.addr++;
        cif.instr = 8'b00011101;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01110000;
        write_mem;
        cif.addr++;
        cif.instr = 8'b01100011;
        write_mem;
        cif.mode = 0;
        @(posedge CLK);
        while (convert_display_to_int(cif.display) != 144) begin
            $info("Output value %03d", convert_display_to_int(cif.display));
            #(PERIOD);
        end
        $finish;
    end
endmodule
