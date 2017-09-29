import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
	input clk,
	/* Datapath controls */
	input lc3b_opcode opcode,
	input branch_enable,
	input enable_jsrr,
	input enable_imm,
	input logic [1:0] ad,
	output logic load_pc,
	output logic load_ir,
	output logic load_regfile,
	output logic load_mar,
	output logic load_mdr,
	output logic load_cc,
	output logic [1:0] pcmux_sel,
	output logic storemux_sel,
	output logic offset6mux_sel,
	output logic [1:0] alumux_sel,
	output logic destmux_sel,
	output logic br_adder_mux_sel,
	output logic [1:0] regfilemux_sel,
	output logic [1:0] marmux_sel,
	output logic [1:0] mdrmux_sel,
	output logic ldbmux_sel,
	output lc3b_aluop aluop,
	
	/* Memory signals */
	input mem_resp,
	input lc3b_word mem_address,
	output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
    fetch1,
    fetch2,
    fetch3,
    decode,
    s_add,
    s_and,
    s_not,
    br,
    br_taken,
    calc_addr,
    ldr1,
    ldr2,
    str1,
    str2,
    s_lea,
    s_jmp,
    s_jsr1,
    s_jsr2,
    s_shf,
    ldi1,
    ldi2,
    ldi3,
    ldi4,
    sti1,
    sti2,
    ldb1,
    ldb2,
    calc_addr1,
    stb1,
    stb2,
   	trap1,
   	trap2,
   	trap3,
   	trap4
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	load_mar = 1'b0;
	load_mdr = 1'b0;
	load_cc = 1'b0;
	pcmux_sel = 2'b00;
	storemux_sel = 1'b0;
	alumux_sel = 2'b00;
	regfilemux_sel = 2'b00;
	marmux_sel = 2'b00;
	mdrmux_sel = 2'b00;
	destmux_sel = 1'b0;
	ldbmux_sel = 1'b0;
	br_adder_mux_sel = 1'b0;
	aluop = alu_add;
	mem_read = 1'b0;
	mem_write = 1'b0;
	mem_byte_enable = 2'b11;
	offset6mux_sel = 1'b0;
    
	 /* Actions for each state */
    case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 2'b01;
			load_mar = 1;
			/* PC <= PC + 2 */
			pcmux_sel = 2'b00;
			load_pc = 1;
		end
		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 2'b01;
			load_mdr = 1;
		end
		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end
		decode: /* Do nothing */;
		s_add: begin
			/* DR <= SRA + SRB */
			aluop = alu_add;
			load_regfile = 1;
			load_cc = 1;
			if (enable_imm == 1)
				alumux_sel = 2'b10;
			else
				alumux_sel = 2'b00;
		end
		s_and: begin
			/* DR <= SRA & SRB */
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
			if (enable_imm == 1)
				alumux_sel = 2'b10;
			else
				alumux_sel = 2'b00;
		end
		s_not: begin
			/* DR <= !SRA */
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end
		br: /* Do nothing */;
		br_taken: begin
			/* PC<=PC + SEXT(IR[8:0] « 1)*/
			pcmux_sel = 2'b01;
			load_pc = 1;
		end
		calc_addr: begin
			/* MAR <= A + SEXT(IR[5:0] << 1) */
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1;
		end
		ldr1: begin
			/* MDR <= M[MAR] */
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		ldr2: begin
			/* DR <= MDR */
			regfilemux_sel = 2'b01;
			load_regfile = 1;
			load_cc = 1;
		end
		ldi1: begin
			/*MDR = M[MAR]*/
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		ldi2: begin
			/* MAR = MDR */
			marmux_sel = 2'b10;
			load_mar = 1;
		end
		ldi3: begin
			/* MDR <= M[MAR] */
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		ldi4: begin
			/* DR <= MDR */
			regfilemux_sel = 2'b01;
			load_regfile = 1;
			load_cc = 1;
		end
		calc_addr1: begin
			/* MAR <= A + SEXT(IR[5:0]) */
			offset6mux_sel = 1'b1;
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1;
		end
		ldb1: begin
			/* MDR <= M[MAR] */
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
 		ldb2:begin
 			/* DR = PICK_AND_ZEXT(MDR) */
 			ldbmux_sel = 1;
 			regfilemux_sel = 2'b01;
			load_regfile = 1;
			load_cc = 1;
		end

		str1: begin
			/* MDR <= SR */
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end
		str2: begin
			/* M[MAR] <= MDR */
			mem_write = 1;
		end	
		stb1: begin
			/* MDR <= fillzeros(SR) */
			storemux_sel = 1;
			mdrmux_sel = 2'b10;
			aluop = alu_pass;
			load_mdr = 1;
		end
		stb2: begin
			/* M[MAR] <= MDR */
			mem_write = 1;
			if (mem_address[0] == 0)
				mem_byte_enable = 2'b01;
			else
				mem_byte_enable = 2'b10;
		end	
		sti1: begin
			/*MDR = M[MAR]*/
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		sti2: begin	
			/* MAR = MDR */
			marmux_sel = 2'b10;
			load_mar = 1;
		end
		s_lea: begin
			/* DR = PC + (SEXT(PCoffset9) << 1);*/
			regfilemux_sel = 2'b10;
			load_regfile = 1;
			load_cc = 1;
		end
		s_jmp: begin
			/* PC = BaseR*/
			pcmux_sel = 2'b10;
			load_pc = 1;
		end
		s_jsr1: begin
			/* R7 = PC */
			destmux_sel = 1'b1;
			regfilemux_sel= 2'b11;
			load_regfile = 1;
		end
		s_jsr2: begin
			/* PC = PC + (SEXT(PCoffset9) << 1)*/
			/* or PC = BaseR */
			if (enable_jsrr == 0)
			begin
				pcmux_sel = 2'b10;
				load_pc = 1;
			end
			else
			begin
				br_adder_mux_sel = 1'b1;
				pcmux_sel = 2'b01;
				load_pc = 1;
			end
		end
		s_shf: begin
			alumux_sel = 2'b11;
			load_cc = 1;
			load_regfile = 1;
			if (ad[0] == 0)
				aluop = alu_sll;
			else if (ad[1] == 0)
					aluop = alu_srl;
				else
					aluop = alu_sra;
		end
		trap1:begin
			/* R7 = PC */
			destmux_sel = 1'b1;
			regfilemux_sel= 2'b11;
			load_regfile = 1;
		end
		trap2: begin
			/* MAR <= ZEXT(IR[7:0]) << 1*/
			marmux_sel = 2'b11;
			load_mar = 1;
		end
		trap3: begin
			/* MDR = M[MAR]*/
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		trap4: begin
			/*PC = MDR*/
			pcmux_sel = 2'b11;
			load_pc = 1;
		end
		default: /* Do nothing */;
	endcase

end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	 case (state)
		/*fetch*/
		fetch1: next_state = fetch2;
		fetch2: begin
			/*wait for mem*/
			if (mem_resp == 0)
				next_state = fetch2;
			else
				next_state = fetch3;
		end
		fetch3: next_state = decode;
		
		/*decode*/
		decode: begin
			case(opcode)
				op_add: next_state = s_add;
				op_and: next_state = s_and;
				op_not: next_state = s_not;
				op_br: next_state = br;
				op_ldr: next_state = calc_addr;
				op_str: next_state = calc_addr;
				op_lea: next_state = s_lea;
				op_jmp: next_state = s_jmp;
				op_jsr: next_state = s_jsr1;
				op_shf: next_state = s_shf;
				op_ldi: next_state = calc_addr;
				op_sti: next_state = calc_addr;
				op_ldb: next_state = calc_addr1;
				op_stb: next_state = calc_addr1;
				op_trap: next_state = trap1;
				default: next_state = fetch1;
			endcase
		end
		
		/*instructions*/
		s_add: next_state = fetch1;
		s_and: next_state = fetch1;
		s_not: next_state = fetch1;
		
		br: begin
			if (branch_enable == 1'b1)
				next_state = br_taken;
			else
				next_state = fetch1;
		end
		br_taken: next_state = fetch1;
		
		calc_addr: begin
			case(opcode)
				op_ldr: next_state = ldr1;
				op_str: next_state = str1;
				op_ldi: next_state = ldi1;
				op_sti: next_state = sti1;
				default: next_state = fetch1;
			endcase
		end

		calc_addr1: begin
			case(opcode)
				op_ldb: next_state = ldb1;
				op_stb: next_state = stb1;
				default: next_state = fetch1;
			endcase
		end
		
		ldr1: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = ldr1;
			else
				next_state = ldr2;
		end
		ldr2: next_state = fetch1;

		ldi1: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = ldi1;
			else
				next_state = ldi2;
		end
		ldi2: next_state = ldi3;
		ldi3: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = ldi3;
			else
				next_state = ldi4;
		end
		ldi4: next_state = fetch1;
		
		str1: next_state = str2;
		str2: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = str2;
			else
				next_state = fetch1;
		end
		stb1: next_state = stb2;
		stb2: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = stb2;
			else
				next_state = fetch1;
		end

		sti1: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = sti1;
			else
				next_state = sti2;
		end
		sti2: next_state = str1;

		s_lea: next_state = fetch1;
		s_jmp: next_state = fetch1;
		s_jsr1: next_state = s_jsr2;
		s_jsr2: next_state = fetch1;
		s_shf: next_state = fetch1;

		ldb1: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = ldb1;
			else
				next_state = ldb2;
		end
		ldb2: next_state = fetch1;

		trap1: next_state = trap2;
		trap2: next_state = trap3;
		trap3: begin
			/*wait for mem*/
			if (mem_resp == 1'b0)
				next_state = trap3;
			else
				next_state = trap4;
		end
		trap4: next_state = fetch1;

		default: next_state = fetch1; /*go back to fetch1 for unknown states*/
	 endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
