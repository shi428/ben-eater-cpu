module register 
#(
    parameter WIDTH = 8
)
( 
    input logic CLK,
    input logic nRST,
    input logic WEN,
    output logic [WIDTH - 1: 0] wdat,
    output logic [WIDTH - 1: 0] rdat
);

logic [WIDTH - 1: 0] next_val;
always_comb begin
    next_val = rdat;
    if (WEN) begin
        next_val = wdat;
    end
end

always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
        rdat <= '0;
    end
    else begin
        rdat <= next_val;
    end
end
endmodule
