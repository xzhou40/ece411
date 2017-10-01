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
assign pmem_address = {mem_address[15:7],8'd0};


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
mux2 cachelinemux
(
	.sel(way_sel),
	.a(dataA),
	.b(dataB),
	.f(cachelinemux_out),
);
assign pmem_wdata = cachelinemux_out;

mux16 lowerbytemux
(
	.sel({mem_address[3:1],1'b0}),
	.a(cachelinemux_out[0:7]),
	.b(cachelinemux_out[8:15]),
	.c(cachelinemux_out[16:23]),
	.d(cachelinemux_out[24:31]),
	.e(cachelinemux_out[32:39]),
	.f(cachelinemux_out[40:47]),
	.g(cachelinemux_out[48:55]),
	.h(cachelinemux_out[56:63]),
	.i(cachelinemux_out[64:71]),
	.j(cachelinemux_out[72:79]),
	.k(cachelinemux_out[80:87]),
	.l(cachelinemux_out[88:95]),
	.m(cachelinemux_out[96:103]),
	.n(cachelinemux_out[104:111]),
	.o(cachelinemux_out[112:119]),
	.p(cachelinemux_out[119:127]),
	.out(mem_rdata[7:0])
);

mux16 higherbytemux
(
	.sel({mem_address[3:1],1'b1}),
	.a(cachelinemux_out[0:7]),
	.b(cachelinemux_out[8:15]),
	.c(cachelinemux_out[16:23]),
	.d(cachelinemux_out[24:31]),
	.e(cachelinemux_out[32:39]),
	.f(cachelinemux_out[40:47]),
	.g(cachelinemux_out[48:55]),
	.h(cachelinemux_out[56:63]),
	.i(cachelinemux_out[64:71]),
	.j(cachelinemux_out[72:79]),
	.k(cachelinemux_out[80:87]),
	.l(cachelinemux_out[88:95]),
	.m(cachelinemux_out[96:103]),
	.n(cachelinemux_out[104:111]),
	.o(cachelinemux_out[112:119]),
	.p(cachelinemux_out[119:127]),
	.out(mem_rdata[15:8])
);


endmodule : cache_datapath