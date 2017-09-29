import lc3b_types::*;

/*
 * ZEXT(mem[])
 */
module fillzeros
(
    input lc3b_word mem_address,
    input lc3b_word sr,
    output lc3b_word f
);

always_comb
begin
	if(mem_address[0] == 0)
		f = {8'h00, sr[7:0]};
	else
		f = {sr[7:0], 8'h00};
end

endmodule : fillzeros