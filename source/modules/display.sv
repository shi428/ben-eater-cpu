module display(
    input logic CLK,
    input logic nRST,
    input logic outputEN,
    input logic [7:0] data,
    output logic [6:0] disp [2:0]
);

logic [7:0] data_ff, next_data_ff;
logic [6:0] ones, tens;
always_comb begin
    next_data_ff = data_ff;
    if (outputEN) begin
        next_data_ff = data;
    end
end

always_comb begin: ONES
    unique casez (data_ff[3:0])
      0: ones  = 7'b1000000;
      1: ones  = 7'b1111001;
      2: ones  = 7'b0100100;
      3: ones  = 7'b0110000;
      4: ones  = 7'b0011001;
      5: ones  = 7'b0010010;
      6: ones  = 7'b0000010;
      7: ones  = 7'b1111000;
      8: ones  = 7'b0000000;
      9: ones  = 7'b0010000;
      'ha: ones = 7'b0001000;
      'hb: ones = 7'b0000011;
      'hc: ones = 7'b0100111;
      'hd: ones = 7'b0100001;
      'he: ones = 7'b0000110;
      'hf: ones = 7'b0001110;

    endcase
end

always_comb begin: TENS
    unique casez (data_ff[7:4])
      0: tens = 7'b1000000;
      1: tens = 7'b1111001;
      2: tens = 7'b0100100;
      3: tens = 7'b0110000;
      4: tens = 7'b0011001;
      5: tens = 7'b0010010;
      6: tens = 7'b0000010;
      7: tens = 7'b1111000;
      8: tens = 7'b0000000;
      9: tens = 7'b0010000;
      'ha: tens = 7'b0001000;
      'hb: tens = 7'b0000011;
      'hc: tens = 7'b0100111;
      'hd: tens = 7'b0100001;
      'he: tens = 7'b0000110;
      'hf: tens = 7'b0001110;
    endcase
end

assign disp[0] = ones;
assign disp[1] = tens;
always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
        data_ff = 0;
    end
    else begin
        data_ff <= next_data_ff;
    end
end
endmodule
