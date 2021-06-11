module clkdiv (
    input logic CLK,
    input logic nRST,
    input logic [15:0] div,
    output logic divCLK
);

logic [19:0] count;
logic [19:0] next_count;
logic nextDivCLK;
always_comb begin
    next_count = count;
    nextDivCLK = divCLK;
    if (next_count + 1 == (div << 8)) begin
        next_count = 0;
        nextDivCLK = 1'b1;
    end
    else begin
        next_count = count + 1;
        nextDivCLK = 1'b0;
    end
end

always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
        count <= '0;
        divCLK <= '0;
    end
    else begin
        count <= next_count;
        divCLK <= nextDivCLK;
    end
end
endmodule
