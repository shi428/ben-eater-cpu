module alu 
(
    input logic [7:0] port_a,
    input logic [7:0] port_b,
    input logic sub,
    output logic [7:0] output_port,
    output logic overflow,
    output logic zero
);
logic [7:0] sub_bus;
assign output_port = sub ? port_a - port_b : port_a + port_b;
assign sub_bus = ~port_b + 1;
assign overflow = sub ? (port_a[7] | sub_bus[7]) & output_port[7] : (port_a[7] | port_b[7]) & !output_port[7];
assign zero = ~(|output_port[7:0]);
endmodule
