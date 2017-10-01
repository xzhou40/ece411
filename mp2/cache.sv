import lc3b_types::*;

module cache
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



cpu cpu
cache cache

endmodule : cache