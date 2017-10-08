import lc3b_types::*;

module cache_control (
	input clk,

    /* CPU */
    output logic mem_resp,
    input logic mem_read,
    input logic mem_write,
    input lc3b_mem_wmask mem_byte_enable,

    /* MEMORY */
    output logic pmem_write,
    output logic pmem_read,
    input logic pmem_resp,

    /* DATAPATH */
    input logic hit_A,
    input logic hit_B,
    input logic dbA,
    input logic dbB,
    input logic vbA,
    input logic vbB,
    input LRU_out,

    output logic way_sel,
    output logic dinmux_sel,
    output logic pmemmux_sel,
    output logic LRU_input,
    output logic valid_input,
    output logic dirty_input,

    output logic load_LRU,
    output logic load_validA,
    output logic load_tagA,
    output logic load_dirtyA,
    output logic load_dataA,

    output logic load_validB,
    output logic load_tagB,
    output logic load_dirtyB,
    output logic load_dataB
);
enum int unsigned {
    /* List of states */
    idle,
    rw,
    write_back,
    read_pmem
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    mem_resp = 1'b0;
    pmem_write = 1'b0;
    pmem_read = 1'b0;
    LRU_input = 1'b0;
    valid_input = 1'b0;
    dirty_input = 1'b0;
    load_LRU = 1'b0;
    load_validA = 1'b0;
    load_tagA = 1'b0;
    load_dirtyA = 1'b0;
    load_dataA = 1'b0;
    load_validB = 1'b0;
    load_tagB = 1'b0;
    load_dirtyB = 1'b0;
    load_dataB = 1'b0;
    way_sel = 1'b0;
    dinmux_sel = 1'b0;
    pmemmux_sel = 1'b0;
    
    /* Actions for each state */
    case(state)
        idle: /* Do nothing */;
        rw: begin
            if (mem_read == 1)
                //read
                if (hit_A == 1)
                begin
                    mem_resp = 1;
                    way_sel = 0;
                    LRU_input = 1;
                    load_LRU = 1;
                end
                else if (hit_B == 1)
                begin
                    mem_resp = 1;
                    way_sel = 1;
                    LRU_input = 0;
                    load_LRU = 1;
                end
                else /*miss or conflict*/
                begin
                end//do nothing
            else
            begin
                //write
                if (hit_A == 1)
                begin
                    way_sel = 0;
                    mem_resp = 1;
                    load_dataA = 1;
                    LRU_input = 1;
                    load_LRU = 1;
                    dinmux_sel = 1;
                    dirty_input = 1;
                    load_dirtyA = 1;
                end
                else if (hit_B == 1)
                begin
                    way_sel = 1;
                    mem_resp = 1;
                    load_dataB = 1;
                    LRU_input = 0;
                    load_LRU = 1;
                    dinmux_sel = 1;
                    dirty_input = 1;
                    load_dirtyB = 1;
                end
                else /*miss or conflict*/
                begin
                end//do nothing
            end
        end
        write_back: begin
            if (LRU_out == 0)
            begin
                //write way A back
                way_sel = 0;
                pmemmux_sel = 1;
                pmem_write = 1;
                dirty_input = 0;
                load_dirtyA = 1;
            end
            else
            begin
                //write way B back
                way_sel = 1;
                pmemmux_sel = 1;
                pmem_write = 1;
                dirty_input = 0;
                load_dirtyB = 1;
            end
        end
        read_pmem: begin
            pmem_read = 1;
            if (LRU_out == 0)
            begin
                //write to way A
                way_sel = 0;
                load_dataA = 1;
                valid_input = 1;
                load_validA = 1;
                load_tagA = 1; 
            end
            else
            begin
                //write to way B
                way_sel = 1;
                load_dataB = 1;
                valid_input = 1;
                load_validB = 1;
                load_tagB = 1;
            end
        end
        default: /* Do nothing */;
    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
     case (state)
        idle: begin
            /*wait for signal from CPU*/
            if (mem_read == 1 || mem_write == 1)
                next_state = rw;
            else
                next_state = idle;
        end
        rw: begin
            /*if hit*/
            if (hit_A == 1 || hit_B == 1)
                next_state = idle;
            /*miss*/
            else if (vbA == 1 && vbB == 1) /*conflict*/
                if (LRU_out == 0 && dbA == 1)
                    next_state = write_back; /*conflict & dirty*/
                else if (LRU_out == 1 && dbB == 1)
                    next_state = write_back; /*conflict & dirty*/
                else
                    next_state = read_pmem; /*just conflict*/
            else /*just miss*/
                next_state = read_pmem;
        end
        write_back: begin
            if (pmem_resp == 0)
                next_state = write_back;
            else
                next_state = read_pmem;
        end
        read_pmem: begin
            if (pmem_resp == 0)
                next_state = read_pmem;
            else
                next_state = rw;
        end
        default: next_state = idle; /*go back to idle for unknown states*/
     endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control