module cccomp 
(
    input [2:0] nzp,
    input [2:0] cc,
    output logic out
);

always_comb
begin
	if ((nzp[2] && cc[2])||(nzp[1] && cc[1])||(nzp[0] && cc[0]))
		out = 1'b1;
	else
		out = 1'b0;
end

endmodule : cccomp
