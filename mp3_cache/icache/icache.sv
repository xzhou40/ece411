import lc3b_types::*;

module icache
(
    input clk,

    /* outputs to cpu */
    output mem_resp,
    output lc3b_word mem_rdata,
    /* inputs from cpu */
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,

    /* inputs from memory */
    input pmem_resp,
    input lc3b_cacheline pmem_rdata,
    /* outputs to memory */
    output pmem_read,
    output pmem_write,
    output lc3b_word pmem_address,
    output lc3b_cacheline pmem_wdata
);

logic hit_A;
logic hit_B;
logic dbA;
logic dbB;
logic vbA;
logic vbB;
logic LRU_out;

logic way_sel;
logic dinmux_sel;
logic LRU_input;
logic pmemmux_sel;
logic valid_input;
logic dirty_input;

logic load_LRU;
logic load_validA;
logic load_tagA;
logic load_dirtyA;
logic load_dataA;

logic load_validB;
logic load_tagB;
logic load_dirtyB;
logic load_dataB;

logic mem_write;
lc3b_word mem_wdata;

assign mem_write = 1'b0;
assign mem_wdata = 16'd0;

cache_datapath icache_datapath(.*);
cache_control icache_control(.*);

endmodule : cache