import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input [1:0] pcmux_sel,
    input load_pc,
	input storemux_sel,
	input load_ir,
	input load_regfile,
	input [1:0] regfilemux_sel, 
	input [1:0] alumux_sel,
	input [1:0] marmux_sel,
	input [1:0] mdrmux_sel,
	input ldbmux_sel,
	input destmux_sel,
	input offset6mux_sel,
	input br_adder_mux_sel,
	input load_mar,
	input load_mdr,
	input load_cc,
	input lc3b_aluop aluop,
	input lc3b_word mem_rdata,
	 
	output lc3b_opcode opcode,
	output lc3b_word mem_wdata,
	output lc3b_word mem_address,
	output branch_enable,
	output logic enable_jsrr,
	output logic enable_imm,
	output logic [1:0] ad
    /* declare more ports here */
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word adj5_out;
lc3b_word adj11_out;
lc3b_word sr1_out;
lc3b_word sr2_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;
lc3b_word immmux_out;
lc3b_word br_adder_mux_out;
lc3b_word pick_and_zext_out;
lc3b_word ldbmux_out;
lc3b_word ext6_out;
lc3b_word offset6mux_out;
lc3b_word fillzeros_out;
lc3b_word zadj8_out;

lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg destmux_out;
lc3b_reg storemux_out;

lc3b_offset6 offset6;
lc3b_offset8 offset8;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_imm5 imm5;
lc3b_imm4 imm4;

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
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .c(sr1_out),
    .d(mem_wdata),
    .f(pcmux_out)
);

mux2 br_adder_mux
(
	.sel(br_adder_mux_sel),
	.a(adj9_out),
	.b(adj11_out),
	.f(br_adder_mux_out)
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
	.a(br_adder_mux_out),
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
/*adj11*/
adj #(.width(11)) adj11
(
	.in(offset11),
	.out(adj11_out)
);


/*
 * IR
 */

ir ir
(
	.clk,
	.load(load_ir),
	.in(mem_wdata),
	.opcode(opcode),
	.dest(dest),
	.src1(sr1),
	.src2(sr2),
	.offset6(offset6),
	.offset9(offset9),
	.offset8(offset8),
	.offset11(offset11),
	.imm5(imm5),
	.imm4(imm4),
	.immmux_sel(enable_imm),
	.ir_11(enable_jsrr),
	.ad(ad)
);
/*adj6*/
adj #(.width(6)) adj6
(
	.in(offset6),
	.out(adj6_out)
);
/*ext6*/
ext #(.width(6)) ext6
(
	.in(offset6),
	.out(ext6_out)
);
mux2 offset6mux
(
	.sel(offset6mux_sel),
	.a(adj6_out),
	.b(ext6_out),
	.f(offset6mux_out)
);
/*adj5*/
ext #(.width(5)) adj5
(
	.in(imm5),
	.out(adj5_out)
);


/*
 * Register File
 */
regfile regfile
(
	.clk,
	.load(load_regfile),
	.in(regfilemux_out),
	.src_a(storemux_out),
	.src_b(sr2),
	.dest(destmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);
/*regfile mux*/
mux4 regfilemux
(
	.sel(regfilemux_sel),
	.a(alu_out),
	.b(ldbmux_out),
	.c(br_add_out),
	.d(pc_out),
	.f(regfilemux_out)
);
/*mux for dest(for use of JSR/R)*/
mux2  #(.width(3)) destmux
(
	.sel(destmux_sel),
	.a(dest),
	.b(3'b111),
	.f(destmux_out)
);


/*
 * ALU
 */
/*alu mux*/
mux4 alumux
(
	.sel(alumux_sel),
	.a(sr2_out),
	.b(offset6mux_out),
	.c(adj5_out),
	.d({12'd0, imm4}),
	.f(alumux_out)
);
/*alu*/
alu alu
(
	.aluop(aluop),
	.a(sr1_out),
	.b(alumux_out),
	.f(alu_out)
);

/*
 * MAR
 */
zadj zadj8
(
	.in(offset8),
	.out(zadj8_out)
);
mux4 marmux
(
	.sel(marmux_sel),
	.a(alu_out),
	.b(pc_out),
	.c(mem_wdata),
	.d(zadj8_out),
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
mux4 mdrmux
(
	.sel(mdrmux_sel),
	.a(alu_out),
	.b(mem_rdata),
	.c(fillzeros_out),
	.d(16'd0),
	.f(mdrmux_out)
);
register mdr
(
	.clk,
	.load(load_mdr),
	.in(mdrmux_out),
	.out(mem_wdata)
);
pick_and_zext pick_and_zext
(
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.f(pick_and_zext_out)
);
fillzeros fillzeros
(
	.mem_address(mem_address),
	.sr(sr1_out),
	.f(fillzeros_out)
);
mux2 ldbmux
(
	.sel(ldbmux_sel),
	.a(mem_wdata),
	.b(pick_and_zext_out),
	.f(ldbmux_out)
);

/*
 * cc
 */
gencc gencc
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
