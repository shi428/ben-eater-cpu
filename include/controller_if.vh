`ifndef CONTROLLER_IF_VH
`define CONTROLLER_IF_VH

interface controller_if;
    logic zero, carry;
    logic halt;
    logic addressWEN;
    logic ramWEN, ramREN;
    logic iWEN, iREN;
    logic aWEN, aREN;
    logic aluREN;
    logic sub;
    logic bWEN;
    logic outputWEN;
    logic pcEN, pcREN, jump;
    logic flagWEN;

    modport cpu (
        output zero, carry,
        halt,
        addressWEN,
        ramWEN, ramREN,
        iWEN, iREN,
        aWEN, aREN,
        aluREN,
        sub, 
        bWEN,
        outputWEN,
        pcEN, pcREN, jump,
        flagWEN
    );
endinterface
`endif
