module control (
input logic clk,
input logic reset,

input logic  [15:0] ir,
input logic [2:0] nzp,
//input logic ben,

input logic continue_i,
input logic run_i,
input logic [15:0] sr1_data,

output logic ld_mar,
output logic ld_mdr,
output logic ld_ir,
output logic ld_pc,
output logic ld_led,
output logic ld_ben,
output logic ld_reg0,
output logic ld_reg1,
output logic ld_reg2,
output logic ld_reg3,
output logic ld_reg4,
output logic ld_reg5,
output logic ld_reg6,
output logic ld_reg7,
output logic ld_cc,
    
    
output logic gate_pc,
output logic gate_mdr,
output logic gate_marmux,
output logic gate_alu,

//output logic ben,
output logic [1:0] pcmux,
output logic [1:0] addr2mux,
output logic addr1mux,
output logic [2:0] sr1_select,
output logic [2:0] sr2_select, //choosing sr2 register
output logic [1:0] alu_select,
output logic sr2mux, //sr2mux selectbit
output logic mio_en,
    
//You should add additional control signals according to the SLC-3 datapath design
    
output logic mem_mem_ena, // Mem Operation Enable
output logic mem_wr_ena  // Mem Write Enable
);

logic [3:0] instruction;
//logic mio_en; ******************************************************************
enum logic [4:0] {
halted, //0
pause_ir1, //1
pause_ir2, //2
s_18, //3
s_33_1, //4
s_33_2, //5
s_33_3, //6
s_35, //7
s_32, //8
s_1, //9
s_5, //A
s_9, //B
s_6, //C
s_25_1, //D
s_25_2, //E
s_25_3, //10
s_27, //11
s_7, //12
s_23, //13
s_16_1, //14
s_16_2, //15
s_16_3, //16
s_4, //17
s_21, //
s_12,
s_22,
s_0
} state, state_nxt;   // Internal state logic

logic ben;


assign ben = (ir[11]&nzp[2]) + (ir[10]&nzp[1]) + (ir[9]&nzp[0]);

always_ff @ (posedge clk)
begin
if (reset)
state <= halted;
else
state <= state_nxt;
end
   
always_comb
begin

// Default controls signal values so we don't have to set each signal
// in each state case below (If we don't set all signals in each state,
// we can create an inferred latch)
ld_mar = 1'b0;
ld_mdr = 1'b0;
ld_ir = 1'b0;
ld_pc = 1'b0;
ld_led = 1'b0;
ld_ben = 1'b0;
ld_reg0 = 1'b0;
ld_reg1 = 1'b0;
ld_reg2 = 1'b0;
ld_reg3 = 1'b0;
ld_reg4 = 1'b0;
ld_reg5 = 1'b0;
ld_reg6 = 1'b0;
ld_reg7 = 1'b0;
ld_cc = 1'b0;
mio_en = 1'b0;
addr2mux = 2'b00;
addr1mux = 1'b0;
sr2mux = 1'b0;
alu_select = 2'b00;
sr1_select = 3'b000;

gate_pc = 1'b0;
gate_mdr = 1'b0;
gate_alu = 0;
gate_marmux = 0;
    
pcmux = 2'b00;

mem_mem_ena = 1'b0;
mem_wr_ena = 1'b0;
    
    
    
//    state_nxt = state;
    
// Assign relevant control signals based on current state
case (state)
halted: ;
s_18 :
begin
gate_pc = 1'b1;
ld_mar = 1'b1;
pcmux = 2'b00;
ld_pc = 1'b1;
end
s_33_1, s_33_2, s_33_3: //takes 3 clock cycles for data to be available in MDR
begin
mem_mem_ena = 1'b1;
mio_en = 1'b0;
// ld_mdr = 1'b0 bc we don't load MDR yet bc need time to get data
ld_mdr = 1'b1; //now load MDR
end
s_35 :
begin
gate_mdr = 1'b1;
ld_ir = 1'b1;
end
s_32 :
begin
instruction = ir[15:12];
//ld_ben = 1;
end
s_1 :
begin
case (ir[5])
1'b0: 
begin
sr2mux = 1'b1;
sr2_select = ir[2:0];
end
1'b1: sr2mux = 1'b0;
default: ;
endcase
alu_select = 2'b00;
gate_alu = 1'b1;
case (ir[11:9])
3'b000: ld_reg0 = 1;
3'b001: ld_reg1 = 1;
3'b010: ld_reg2 = 1;
3'b011: ld_reg3 = 1;
3'b100: ld_reg4 = 1;
3'b101: ld_reg5 = 1;
3'b110: ld_reg6 = 1;
3'b111: ld_reg7 = 1;
endcase
ld_cc = 1'b1;
sr1_select = ir[8:6];
end
s_5 :
begin
case (ir[5])
1'b0: 
begin
sr2mux = 1'b1;
sr2_select = ir[2:0];
end
1'b1: sr2mux = 1'b0;
default: ;
endcase
alu_select = 2'b01;
gate_alu = 1'b1;
case (ir[11:9])
3'b000: ld_reg0 = 1;
3'b001: ld_reg1 = 1;
3'b010: ld_reg2 = 1;
3'b011: ld_reg3 = 1;
3'b100: ld_reg4 = 1;
3'b101: ld_reg5 = 1;
3'b110: ld_reg6 = 1;
3'b111: ld_reg7 = 1;
endcase
ld_cc = 1'b1;
sr1_select = ir[8:6];
end
s_9:
begin
alu_select = 2'b10;
ld_cc = 1'b1;
gate_alu = 1'b1;
sr1_select = ir[8:6];
case (ir[11:9])
3'b000: ld_reg0 = 1;
3'b001: ld_reg1 = 1;
3'b010: ld_reg2 = 1;
3'b011: ld_reg3 = 1;
3'b100: ld_reg4 = 1;
3'b101: ld_reg5 = 1;
3'b110: ld_reg6 = 1;
3'b111: ld_reg7 = 1;
endcase
end
s_6 , s_7:
begin
sr1_select = ir[8:6];
addr2mux = 2'b10;
addr1mux = 1'b0;
gate_marmux = 1'b1;
ld_mar = 1'b1;
end
s_25_1, s_25_2, s_25_3 :
begin
mem_mem_ena = 1'b1;
mio_en = 1'b0;
ld_mdr = 1'b1;
end
s_27:
begin
gate_mdr = 1'b1;        
ld_cc = 1'b1;
case (ir[11:9])
3'b000: ld_reg0 = 1;
3'b001: ld_reg1 = 1;
3'b010: ld_reg2 = 1;
3'b011: ld_reg3 = 1;
3'b100: ld_reg4 = 1;
3'b101: ld_reg5 = 1;
3'b110: ld_reg6 = 1;
3'b111: ld_reg7 = 1;
endcase
end
s_23 :
begin
sr1_select = ir[11:9];
alu_select = 2'b11;//check this
gate_alu = 1'b1;
mio_en = 1'b1;
ld_mdr = 1'b1;
end
s_16_1, s_16_2, s_16_3 :
begin
gate_mdr = 1'b1;
ld_mar = 1'b0;
mem_wr_ena = 1'b1;
mem_mem_ena = 1'b1;
end
s_4:
begin
gate_pc = 1'b1;
ld_reg7 = 1'b1;
end
s_21:
begin
addr2mux = 2'b00;
addr1mux = 1'b1;
pcmux = 2'b01;
ld_pc = 1'b1;
end
s_12:
begin
sr1_select = ir[8:6];
alu_select = 2'b11;
gate_alu = 1'b1;
pcmux = 2'b10;
ld_pc = 1'b1;
end
s_0:
begin
case (ben)
1'b1:
begin
addr1mux = 1'b1;
addr2mux = 2'b01;
pcmux = 2'b01;
ld_pc = 1;
end
endcase
end
pause_ir1: ld_led = 1'b1;
pause_ir2: ld_led = 1'b1;
default : ;
endcase
end


always_comb
begin
// default next state is staying at current state
state_nxt = state;
    
unique case (state)
halted :
if (run_i)
state_nxt = s_18;
s_18 :
state_nxt = s_33_1; //notice that we usually have 'r' here, but you will need to add extra states instead
s_33_1 :                 //e.g. s_33_2, etc. how many? as a hint, note that the bram is synchronous, in addition,
state_nxt = s_33_2;   //it has an additional output register.
s_33_2 :
state_nxt = s_33_3;
s_33_3 :
state_nxt = s_35;
s_35 :
state_nxt = s_32;
// pause_ir1 and pause_ir2 are only for week 1 such that TAs can see
// the values in ir.
s_32 :
begin
case (ir[15:12])
4'b0001: state_nxt = s_1;
4'b0101: state_nxt = s_5;
4'b1001: state_nxt = s_9;
4'b0000: state_nxt = s_0;
4'b1100: state_nxt = s_12;
4'b0100: state_nxt = s_4;
4'b0110: state_nxt = s_6;
4'b0111: state_nxt = s_7;
4'b1101: state_nxt = pause_ir1;
default: ;
endcase   
end
pause_ir1 :
case (continue_i)
1'b1: state_nxt = pause_ir2;
//1'b0: state_nxt = pause_ir1;
default :; //state_nxt = pause_ir1; *****************
endcase
pause_ir2 :
case (continue_i)
//1'b1: state_nxt = pause_ir2;
1'b0: state_nxt = s_18;
default : ;
endcase
s_1:
state_nxt = s_18;
s_5:
state_nxt = s_18;
s_9:
state_nxt = s_18;
s_6:
state_nxt = s_25_1;
s_25_1:
state_nxt = s_25_2;
s_25_2:
state_nxt = s_25_3;
s_25_3:
state_nxt = s_27;
s_27:
state_nxt = s_18;
s_7:
state_nxt = s_23;
s_23:
state_nxt = s_16_1;
s_16_1:
state_nxt = s_16_2;
s_16_2:
state_nxt = s_16_3;
s_16_3:
state_nxt = s_18;
s_4:
state_nxt = s_21;
s_21:
state_nxt = s_18;
s_12:
state_nxt = s_18;
s_0:
case (ben)
1'b0: state_nxt = s_18;
1'b1: state_nxt = s_22;
default: ;
endcase 
s_22:
state_nxt = s_18;
default :;
endcase
end

endmodule
