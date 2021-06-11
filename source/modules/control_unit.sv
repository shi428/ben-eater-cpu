module control_unit 
(
    input logic CLK,
    input logic nRST,
    input logic ctrl_en,
    input logic [3:0] opcode,
    input logic zero,
    input logic carry,
    output logic halt,
    output logic addressWEN,
    output logic ramWEN,
    output logic ramREN,
    output logic iWEN,
    output logic iREN,
    output logic aWEN,
    output logic aREN,
    output logic aluREN,
    output logic sub,
    output logic bWEN,
    output logic outputWEN,
    output logic pcEN,
    output logic pcREN,
    output logic jump,
    output logic flagWEN
);


logic [2:0] count, next_count;
always_comb begin
    next_count = count; 
    halt = '0;
    addressWEN = '0; 
    ramWEN = '0;
    ramREN = '0;
    iWEN = '0;
    iREN = '0;
    aWEN = '0;
    aREN = '0;
    aluREN = '0;
    sub = '0;
    bWEN = '0;
    outputWEN= 1'b0;
    pcEN = '0;
    pcREN = '0;
    jump = '0;
    flagWEN = '0;
    if (ctrl_en) begin
        next_count = count + 1;
    end
    case (count) 
        3'b000: begin
            addressWEN = 1'b1;
            pcREN = 1'b1;
        end
        3'b001: begin
            ramREN = 1'b1;
            iWEN = 1'b1;
            pcEN = 1'b1;
        end
        3'b010: begin
            case (opcode) 
                4'b0001: begin //LDA
                    addressWEN = 1'b1;
                    iREN = 1'b1;
                end
                4'b0010: begin //ADD
                    addressWEN = 1'b1;
                    iREN = 1'b1;
                end
                4'b0011: begin //SUB
                    addressWEN = 1'b1;
                    iREN = 1'b1;
                end
                4'b0100: begin //STA
                    addressWEN = 1'b1;
                    iREN = 1'b1;
                end
                4'b0101: begin //LDI
                    iREN = 1'b1;
                    aWEN = 1'b1;
                end
                4'b0110: begin //JMP
                    iREN = 1'b1;
                    jump = 1'b1;
                end
                4'b1110: begin //OUT
                    aREN = 1'b1;
                    outputWEN = 1'b1;
                end
                4'b1111: begin //HALT
                    halt = 1'b1;
                end
                4'b0111: begin //JC
                    if (carry) begin
                        iREN = 1'b1;
                        jump = 1'b1;
                    end
                end
                4'b1000: begin //JZ
                    if (zero) begin
                        iREN = 1'b1;
                        jump = 1'b1;
                    end
                end
            endcase
        end
        3'b011: begin
            case (opcode)
                4'b0001: begin //LDA
                    ramREN = 1'b1;
                    aWEN = 1'b1;
                end
                4'b0010: begin //ADD
                    ramREN = 1'b1;
                    bWEN = 1'b1;
                end
                4'b0011: begin //SUB
                    ramREN = 1'b1;
                    bWEN = 1'b1;
                end
                4'b0100: begin //STA
                    ramWEN = 1'b1;
                    aREN = 1'b1;
                end
            endcase
        end
        3'b100: begin
            next_count = '0;
            case (opcode) 
                4'b0010: begin //ADD
                    aWEN = 1'b1;
                    aluREN = 1'b1;
                    flagWEN = 1'b1;
                end
                4'b0011: begin //SUB
                    aWEN = 1'b1;
                    aluREN = 1'b1;
                    flagWEN = 1'b1;
                end
            endcase
        end
    endcase
end

always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
        count <= '0;
    end
    else begin
        count <= next_count;
    end
end
endmodule

