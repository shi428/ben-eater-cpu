module pc (
    input logic CLK,
    input logic nRST,
    input logic count_en,
    input logic WEN,
    input logic [3:0] jaddr,
    output logic [3:0] pc
);

logic [3:0] npc;
always_comb begin
    npc = pc;
    if (count_en) begin
        npc = pc + 1;
    end
    if (WEN) begin
        npc = jaddr;
    end
end

always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
        pc <= '0;
    end
    else begin
        pc <= npc;
    end
end
endmodule
