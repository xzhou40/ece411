import lc3b_types::*;

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
    output logic hit_B,
    output logic dbA,
    output logic dbB,
    output logic vbA,
    output logic vbB,
    output LRU_out,

    input way_sel,
    input LRU_input,
    input valid_input,
    input dirty_input,

    input logic load_LRU,
    input logic load_validA,
    input logic load_tagA,
    input logic load_dirtyA,
    input logic load_dataA,

    input logic load_validB,
    input logic load_tagB,
    input logic load_dirtyB,
    input logic load_dataB
);

lc3b_index index;
lc3b_cacheline cachelinemux_out;

//some assignments
assign index = mem_address[6:4];
assign pmem_address = {mem_address[15:4],4'd0};


/******************LRU**********************/
array #(.width(1)) LRU
(
	.clk,
	.write(load_LRU),
	.index,
	.datain(LRU_input),
	.dataout(LRU_out)
);

/******************way A********************/
lc3b_tag tagA;
logic tag_compare_A_out;
lc3b_cacheline dataA;

/************arrays****************/
array #(.width(1)) valid_bit_A
(
	.clk,
	.write(load_validA),
	.index,
	.datain(valid_input),
	.dataout(vbA)
);

array #(.width(9)) tag_store_A
(
	.clk,
	.write(load_tagA),
	.index,
	.datain(mem_address[15:7]),
	.dataout(tagA)
);

array #(.width(1)) dirty_bit_A
(
	.clk,
	.write(load_dirtyA),
	.index,
	.datain(dirty_input),
	.dataout(dbA)
);

array data_store_A
(
	.clk,
	.write(load_dataA),
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
lc3b_tag tagB;
logic tag_compare_B_out;
lc3b_cacheline dataB;

/************arrays****************/
array #(.width(1)) valid_bit_B
(
	.clk,
	.write(load_validB),
	.index,
	.datain(valid_input),
	.dataout(vbB)
);

array #(.width(9)) tag_store_B
(
	.clk,
	.write(load_tagB),
	.index,
	.datain(mem_address[15:7]),
	.dataout(tagB)
);

array #(.width(1)) dirty_bit_B
(
	.clk,
	.write(load_dirtyB),
	.index,
	.datain(dirty_input),
	.dataout(dbB)
);

array data_store_B
(
	.clk,
	.write(load_dataB),
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

/************muxes after data array*********/
mux2 #(.width(128)) cachelinemux
(
	.sel(way_sel),
	.a(dataA),
	.b(dataB),
	.f(cachelinemux_out)
);
assign pmem_wdata = cachelinemux_out;

mux16 lowerbytemux
(
	.sel({mem_address[3:1],1'b0}),
	.a(cachelinemux_out[7:0]),
	.b(cachelinemux_out[15:8]),
	.c(cachelinemux_out[23:16]),
	.d(cachelinemux_out[31:24]),
	.e(cachelinemux_out[39:32]),
	.f(cachelinemux_out[47:40]),
	.g(cachelinemux_out[55:48]),
	.h(cachelinemux_out[63:56]),
	.i(cachelinemux_out[71:64]),
	.j(cachelinemux_out[79:72]),
	.k(cachelinemux_out[87:80]),
	.l(cachelinemux_out[95:88]),
	.m(cachelinemux_out[103:96]),
	.n(cachelinemux_out[111:104]),
	.o(cachelinemux_out[119:112]),
	.p(cachelinemux_out[127:120]),
	.out(mem_rdata[7:0])
);

mux16 higherbytemux
(
	.sel({mem_address[3:1],1'b1}),
	.a(cachelinemux_out[7:0]),
	.b(cachelinemux_out[15:8]),
	.c(cachelinemux_out[23:16]),
	.d(cachelinemux_out[31:24]),
	.e(cachelinemux_out[39:32]),
	.f(cachelinemux_out[47:40]),
	.g(cachelinemux_out[55:48]),
	.h(cachelinemux_out[63:56]),
	.i(cachelinemux_out[71:64]),
	.j(cachelinemux_out[79:72]),
	.k(cachelinemux_out[87:80]),
	.l(cachelinemux_out[95:88]),
	.m(cachelinemux_out[103:96]),
	.n(cachelinemux_out[111:104]),
	.o(cachelinemux_out[119:112]),
	.p(cachelinemux_out[127:120]),
	.out(mem_rdata[15:8])
);


endmodule : cache_datapath