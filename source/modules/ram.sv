module ram
(
    input logic CLK,
    input logic WEN,
    input logic [3:0] addr,
    input logic [7:0] store,
    output logic [7:0] load
);

logic [7:0] mem [15:0];
logic [7:0] next_mem [15:0];
always_comb begin
    next_mem = mem;
    if (WEN) begin
        next_mem[addr] = store;
    end
end

always_ff @(posedge CLK) begin
    mem <= next_mem;
end

assign load = mem[addr];
endmodule
