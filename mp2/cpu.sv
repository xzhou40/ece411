import lc3b_types::*;

module cpu
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

/* Instantiate MP 0 top level blocks here */

logic [1:0] pcmux_sel;
logic load_pc;
logic storemux_sel;
logic load_ir;
logic load_regfile;
logic [1:0] regfilemux_sel;
logic [1:0] alumux_sel;
logic [1:0] marmux_sel;
logic [1:0] mdrmux_sel;
logic load_mar;
logic load_mdr;
logic load_cc;
logic destmux_sel;
logic br_adder_mux_sel;
lc3b_aluop aluop;
lc3b_opcode opcode;
logic branch_enable;
logic enable_jsrr;
logic enable_imm;
logic [1:0] ad;
logic ldbmux_sel;
logic offset6mux_sel;

cpu_control cpu_control(.*);
cpu_datapath cpu_datapath(.*);

endmodule : cpu
