import lc3b_types::*;

module l2_cache_datapath (
	input clk,

    /* outputs to cpu */
    output lc3b_cacheline mem_rdata,
    /* inputs from cpu */
    input l2_address mem_address,
    input lc3b_cacheline mem_wdata,

    /* inputs from memory */
    input l2_cacheline pmem_rdata,
    /* outputs to memory */
    output lc3b_word pmem_address,
    output l2_cacheline pmem_wdata,

    /* control signals */
    output logic hit_A,
    output logic hit_B,
    output logic dbA,
    output logic dbB,
    output logic vbA,
    output logic vbB,
    output LRU_out,

    input way_sel,
    input dinmux_sel,
    input pmemmux_sel,
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
l2_cacheline cachelinemux_out;
l2_cacheline d_in;
l2_cacheline dinmux_out;
lc3b_cacheline writemux0_out;
lc3b_cacheline writemux1_out;

//some assignments
assign index = mem_address[3:1];


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
l2_tag tagA;
logic tag_compare_A_out;
l2_cacheline dataA;

/************arrays****************/
array #(.width(1)) valid_bit_A
(
	.clk,
	.write(load_validA),
	.index,
	.datain(valid_input),
	.dataout(vbA)
);

array #(.width(8)) tag_store_A
(
	.clk,
	.write(load_tagA),
	.index,
	.datain(mem_address[11:4]),
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

array #(.width(256)) data_store_A
(
	.clk,
	.write(load_dataA),
	.index,
	.datain(dinmux_out),
	.dataout(dataA)
);
////////////////////////////////////

l2_compare tag_compare_A
(
	.a(mem_address[11:4]),
	.b(tagA),
	.out(tag_compare_A_out)
);
assign hit_A = vbA & tag_compare_A_out;

/////////////////////////////////////////////




/******************way B********************/
l2_tag tagB;
logic tag_compare_B_out;
l2_cacheline dataB;

/************arrays****************/
array #(.width(1)) valid_bit_B
(
	.clk,
	.write(load_validB),
	.index,
	.datain(valid_input),
	.dataout(vbB)
);

array #(.width(8)) tag_store_B
(
	.clk,
	.write(load_tagB),
	.index,
	.datain(mem_address[11:4]),
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

array #(.width(256)) data_store_B
(
	.clk,
	.write(load_dataB),
	.index,
	.datain(dinmux_out),
	.dataout(dataB)
);
////////////////////////////////////

l2_compare tag_compare_B
(
	.a(mem_address[11:4]),
	.b(tagB),
	.out(tag_compare_B_out)
);
assign hit_B = vbB & tag_compare_B_out;

/////////////////////////////////////////////

/************muxes after data array*********/
mux2 #(.width(256)) cachelinemux
(
	.sel(way_sel),
	.a(dataA),
	.b(dataB),
	.f(cachelinemux_out)
);
assign pmem_wdata = cachelinemux_out;

mux2 #(.width(128)) rdatamux
(
	.sel(mem_address[0]),
	.a(cachelinemux_out[127:0]),
	.b(cachelinemux_out[255:128]),
	.out(mem_rdata)
);


/************logic for pmem_address************/
mux2 #(.width(8)) tagmux
(
	.sel(way_sel),
	.a(tagA),
	.b(tagB),
	.f(tagmux_out)
);
mux2 pmemmux
(
	.sel(pmemmux_sel),
	.a({mem_address[11:1],5'd0}),
	.b({tagmux_out,mem_address[3:1],5'd0}),
	.f(pmem_address)
);
///////////////////////////////////////////////

/*********input logic for data array*************/
mux2 #(.width(256)) dinmux
(
	.sel(dinmux_sel),
	.a(pmem_rdata),
	.b(d_in),
	.f(dinmux_out)
);

assign d_in = {writemux1_out,writemux0_out};

mux2 #(.width(128)) writemux0
(
	.sel(mem_address[0]==0),
	.a(cachelinemux_out[127:0]),
	.b(mem_wdata),
	.f(writemux0_out)
);
mux2 #(.width(128)) writemux1
(
	.sel(mem_address[0]==1),
	.a(cachelinemux_out[255:128]),
	.b(mem_wdata),
	.f(writemux1_out)
);

//////////////////////////////////////////////////

endmodule : cache_datapath