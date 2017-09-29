import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input pcmux_sel,
    input load_pc,
	input storemux_sel,
	input load_ir,
	input load_regfile,
	input regfilemux_sel, 
	input alumux_sel,
	input marmux_sel,
	input mdrmux_sel,
	input load_mar,
	input load_mdr,
	input load_cc,
	input lc3b_aluop aluop,
	input lc3b_word mem_rdata,
	 
	output lc3b_opcode opcode,
	output lc3b_word mem_wdata,
	output lc3b_word mem_address,
	output branch_enable
    /* declare more ports here */
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word sr1_out;
lc3b_word sr2_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;

lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg storemux_out;

lc3b_offset6 offset6;
lc3b_offset9 offset9;

lc3b_nzp gencc_out;
lc3b_nzp cc_out;

/*
 * storemux
 */
mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

/*branch target adder*/
adder br_adder
(
	.a(adj9_out),
	.b(pc_out),
	.out(br_add_out)
);
/*pc+2*/
plus2 pc_plus2
(
	.in(pc_out),
	.out(pc_plus2_out)
);
/*adj9*/
adj #(.width(9)) adj9
(
	.in(offset9),
	.out(adj9_out)
);


/*
 * IR
 */

ir my_ir
(
	.clk,
	.load(load_ir),
	.in(mem_wdata),
	.opcode(opcode),
	.dest(dest),
	.src1(sr1),
	.src2(sr2),
	.offset6(offset6),
	.offset9(offset9)
);
/*adj6*/
adj #(.width(6)) adj6
(
	.in(offset6),
	.out(adj6_out)
);


/*
 * Register File
 */
regfile my_regfile
(
	.clk,
	.load(load_regfile),
	.in(regfilemux_out),
	.src_a(storemux_out),
	.src_b(sr2),
	.dest(dest),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);
/*regfile mux*/
mux2 regfilemux
(
	.sel(regfilemux_sel),
	.a(alu_out),
	.b(mem_wdata),
	.f(regfilemux_out)
);


/*
 * ALU
 */
/*alu mux*/
mux2 alumux
(
	.sel(alumux_sel),
	.a(sr2_out),
	.b(adj6_out),
	.f(alumux_out)
);
/*alu*/
alu my_alu
(
	.aluop(aluop),
	.a(sr1_out),
	.b(alumux_out),
	.f(alu_out)
);

/*
 * MAR
 */
mux2 marmux
(
	.sel(marmux_sel),
	.a(alu_out),
	.b(pc_out),
	.f(marmux_out)
);
register mar
(
	.clk,
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

/*
 * MDR
 */
mux2 mdrmux
(
	.sel(mdrmux_sel),
	.a(alu_out),
	.b(mem_rdata),
	.f(mdrmux_out)
);
register mdr
(
	.clk,
	.load(load_mdr),
	.in(mdrmux_out),
	.out(mem_wdata)
);

/*
 * cc
 */
gencc my_gencc
(
	.in(regfilemux_out),
	.out(gencc_out)
);
register #(.width(3)) cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);
cccomp nzp_compare
(
	.nzp(dest),
	.cc(cc_out),
	.out(branch_enable)
);



endmodule : datapath
