import lc3b_types::*;

module mp0
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

logic pcmux_sel;
logic load_pc;
logic storemux_sel;
logic load_ir;
logic load_regfile;
logic regfilemux_sel;
logic alumux_sel;
logic marmux_sel;
logic mdrmux_sel;
logic load_mar;
logic load_mdr;
logic load_cc;
lc3b_aluop aluop;
lc3b_opcode opcode;
logic branch_enable;

control my_control(.*);
datapath my_datapath(.*);

endmodule : mp0
