module cache_datapath (
	input clk,

    /* outputs to cpu */
    output lc3b_word mem_rdata,
    /* inputs from cpu */
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,

    /* inputs from memory */
    input lc3b_cacheline pmem_rdata,
    /* outputs to memory */
    output lc3b_word pmem_address,
    output lc3b_cacheline pmem_wdata,

    /* control signals */
    output logic hit_A,
    output logic hit_B
);

lc3b_index index;
lc3b_cacheline cachelinemux_out;

//some assignments
assign index = mem_address[6:4];
assign pmem_address = {mem_address[15:7],8'd0};


/******************LRU**********************/
array #(.width(1)) LRU
(
	.clk,
	.write(),
	.index,
	.datain(LRU_input),
	.dataout(LRU_out)
);

/******************way A********************/
logic hit_A;
logic vbA;
lc3b_tag tagA;
logic dbA;
logic tag_compare_A_out;
lc3b_cacheline dataA;

/************arrays****************/
array #(.width(1)) valid_bit_A
(
	.clk,
	.write(),
	.index,
	.datain(valid_input_A),
	.dataout(vbA)
);

array #(.width(9)) tag_store_A
(
	.clk,
	.write(),
	.index,
	.datain(mem_address[15:7]),
	.dataout(tagA)
);

array #(.width(1)) dirty_bit_A
(
	.clk,
	.write(),
	.index,
	.datain(dirty_input_A),
	.dataout(dbA)
);

array data_store_A
(
	.clk,
	.write(),
	.index,
	//should change this for final
	.datain(pmem_rdata),
	.dataout(dataA)
);
////////////////////////////////////

compare tag_compare_A
(
	.a(mem_address[15:7]),
	.b(tagA),
	.out(tag_compare_A_out)
);
assign hit_A = vbA & tag_compare_A_out;

/////////////////////////////////////////////




/******************way B********************/
logic hit_B;
logic vbB;
lc3b_tag tagB;
logic dbB;
logic tag_compare_B_out;
lc3b_cacheline dataB;

/************arrays****************/
array #(.width(1)) valid_bit_B
(
	.clk,
	.write(),
	.index,
	.datain(valid_input_B),
	.dataout(vbB)
);

array #(.width(9)) tag_store_B
(
	.clk,
	.write(),
	.index,
	.datain(mem_address[15:7]),
	.dataout(tagB)
);

array #(.width(1)) dirty_bit_B
(
	.clk,
	.write(),
	.index,
	.datain(dirty_input_B),
	.dataout(dbB)
);

array data_store_B
(
	.clk,
	.write(),
	.index,
	//should change this for final
	.datain(pmem_rdata),
	.dataout(dataB)
);
////////////////////////////////////

compare tag_compare_B
(
	.a(mem_address[15:7]),
	.b(tagB),
	.out(tag_compare_B_out)
);
assign hit_B = vbB & tag_compare_B_out;

/////////////////////////////////////////////

mux2 cachelinemux
(
	.sel(),
	.a(dataA),
	.b(dataB),
	.f(cachelinemux_out),
)


endmodule : cache_datapath