`timescale 1 ns / 1 ns

module alu_tb;
logic [7:0] port_a, port_b;
logic sub;
logic [7:0] output_port;
logic zero, overflow;
alu ALU
(
    port_a,
    port_b,
    sub,
    output_port,
    overflow,
    zero
);

logic [7:0] expected_output_port;
logic expected_overflow, expected_zero;

string test_case;
int test_case_num;
string sample;
int sample_num;

task check_outputs; begin
    #(2ns);
    if (output_port != expected_output_port) begin
        $error("Incorrect output port for test case %d: %s sample %d: %s Expected: %d Obtained: %d", test_case_num, test_case, sample_num, sample, expected_output_port, output_port);
        return ;
end
    if (overflow != expected_overflow) begin
        $error("Incorrect overflow for test case %d: %s sample %d: %s Expected: %d Obtained: %d", test_case_num, test_case, sample_num, sample, expected_overflow, overflow);
        return ;
    end
    if (zero != expected_zero) begin
        $error("Incorrect zero for test case %d: %s sample %d: %s Expected: %d Obtained: %d", test_case_num, test_case, sample_num, sample, expected_zero, zero);
        return ;
    end
    $info("Correct outputs for test case %d: %s sample %d: %s", test_case_num, test_case, sample_num, sample);
end
endtask

task set_inputs(
    input logic SUB,
    input [7:0] PORT_A,
    input [7:0] PORT_B
);
begin
    sub = SUB;
    port_a = PORT_A;
    port_b = PORT_B;
end
endtask

task set_expected (
    input [7:0] output_port,
    input logic overflow,
    input logic zero
);
begin
    expected_output_port = output_port;
    expected_overflow = overflow;
    expected_zero = zero;
end
endtask

initial begin
    test_case = "addition";
    test_case_num = 1;
    sample_num = 1;
    sample = "basic";
    set_inputs(0, 8'd10, 8'd20);
    set_expected(8'd30, 0, 0);
    check_outputs;
    sample_num++;
    sample = "overflow";
    set_inputs(0, 8'd200, 8'd100);
    set_expected(8'd44, 1, 0);
    check_outputs;
    sample_num++;
    sample = "zero";
    set_inputs(0, 0, 0);
    set_expected(0, 0, 1);
    check_outputs;

    test_case = "subtraction";
    test_case_num++;
    sample_num = 1;
    sample = "basic";
    set_inputs(1, 8'd30, 8'd20);
    set_expected(8'd10, 0, 0);
    check_outputs;
    sample_num++;
    sample = "overflow";
    set_inputs(1, 8'd200, 8'd201);
    set_expected(8'd255, 1, 0);
    check_outputs;
    sample_num++;
    sample = "zero";
    set_inputs(1, 5, 5);
    set_expected(0, 0, 1);
    check_outputs;
    $finish;
end
endmodule
