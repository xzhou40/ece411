module l2_compare 
(
    input [7:0] a,
    input [7:0] b,
    output logic out
);

always_comb
begin
	if (a == b)
		out = 1'b1;
	else
		out = 1'b0;
end

endmodule : compare