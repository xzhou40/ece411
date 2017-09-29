import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input pmem_resp,
    input lc3b_cacheline pmem_rdata,
    output pmem_read,
    output pmem_write,
    output lc3b_word pmem_address,
    output lc3b_cacheline pmem_wdata
);



cpu cpu
cache cache

endmodule : mp2
