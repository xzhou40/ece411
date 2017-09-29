import lc3b_types::*;

/*
 * ZEXT(mem[])
 */
module pick_and_zext
(
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,
    output lc3b_word f
);

always_comb
begin
	if(mem_address[0] == 0)
		f = {8'h00, mem_wdata[7:0]};
	else
		f = {8'h00, mem_wdata[15:8]};
end

endmodule : pick_and_zext
