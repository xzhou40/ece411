module adder #(parameter width = 16)
(
    input [width-1:0] a,
	 input [width-1:0] b,
    output logic [width-1:0] out
);

assign out = a + b;

endmodule : adder