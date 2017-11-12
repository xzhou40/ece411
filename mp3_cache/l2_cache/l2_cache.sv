import lc3b_types::*;

module l2_cache
(
    input clk,

    /* outputs to cpu */
    output mem_resp,
    output lc3b_cacheline mem_rdata,
    /* inputs from cpu */
    input mem_read,
    input mem_write,
    input l2_address mem_address,
    input lc3b_cacheline mem_wdata,

    /* inputs from memory */
    input pmem_resp,
    input l2_cacheline pmem_rdata,
    /* outputs to memory */
    output pmem_read,
    output pmem_write,
    output lc3b_word pmem_address,
    output l2_cacheline pmem_wdata
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

l2_cache_datapath l2_cache_datapath(.*);
l2_cache_control l2_cache_control(.*);

endmodule : cache