module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// Internal connections, follow the datapath block diagram and add the additional needed signals

//load signals
logic ld_mar;
logic ld_mdr;
logic ld_ir;
logic ld_pc;
logic ld_led;
logic ld_cc;
logic ld_reg0;
logic ld_reg1;
logic ld_reg2;
logic ld_reg3;
logic ld_reg4;
logic ld_reg5;
logic ld_reg6;
logic ld_reg7;
logic ld_nzp;
logic ld_ben;
logic [1:0] pcmux; //select for pcmux
logic [1:0] addr2mux; //select
logic addr1mux; //select
logic sr2mux; //select
logic [1:0] alu_select; //select

//tri-state buffer gates
logic gate_pc;
logic gate_mdr;
logic gate_alu;
logic gate_marmux;

//register wires
logic [15:0] mar;
logic [15:0] mdr;
logic [15:0] ir;
logic [15:0] pc;
logic [15:0] alu;
logic [15:0] reg0;
logic [15:0] reg1;
logic [15:0] reg2;
logic [15:0] reg3;
logic [15:0] reg4;
logic [15:0] reg5;
logic [15:0] reg6;
logic [15:0] reg7;
logic [2:0] nzp_data;
logic [2:0] nzp;
logic [2:0] sr1_select; //use signals to access the registers
logic [2:0] sr2_select;
logic [15:0] sr2_data;
logic [15:0] sr1_data;
logic ben_data;
logic ben;
logic [15:0] addr1_out;
logic [15:0] addr2_out;
logic [15:0] sr2_out;
//do I need sr1_out?
logic [15:0] pc_in; //input to pc register
logic [15:0] bus_signal; //output of tri-state buffer mux
logic [15:0] alu_op;
logic [15:0] mio_out;
logic mio_en;

assign mem_addr = mar;
assign mem_wdata = mdr;

// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations,
// but can also lead to confusing code if used too commonly
control cpu_control (
    .*
);

mux_3_to_1 pc_mux(
    .data0(pc + 16'b1),
    .data1(addr2_out + addr1_out),
    .data2(bus_signal),
    .select(pcmux),
    .data_out(pc_in));

mux_5_to_1 tri_state_buffer_mux(
    .data0(16'b0),
    .data1(pc),
    .data2(mdr),
    .data3(alu),
    .data4(addr2_out + addr1_out), //whatevers in the marmux wire
    .select({gate_alu, gate_mdr, gate_pc, gate_marmux}),
    .data_out(bus_signal));
    
mux_8_to_1 sreg1_mux(
    .data0(reg0),
    .data1(reg1),
    .data2(reg2),
    .data3(reg3),
    .data4(reg4),
    .data5(reg5),
    .data6(reg6),
    .data7(reg7),
    .select(sr1_select),
    .data_out(sr1_data) 
);

mux_8_to_1 sreg2_mux(
    .data0(reg0),
    .data1(reg1),
    .data2(reg2),
    .data3(reg3),
    .data4(reg4),
    .data5(reg5),
    .data6(reg6),
    .data7(reg7),
    .select(sr2_select),
    .data_out(sr2_data) 
);

mux_4_to_1 alu_mux(
    .data0(sr2_out + sr1_data), //add
    .data1(sr2_out & sr1_data), //and
    .data2(~sr1_data), //not
    .data3(sr1_data),
    .select(alu_select),
    .data_out(alu)
);


always_comb
begin
    case(bus_signal[15])
        1'b1: nzp_data = 3'b100;
        1'b0: 
        begin
            if(bus_signal == 16'b0)
                nzp_data = 3'b010;
            else
                nzp_data = 3'b001;
        end
        default: ;
    endcase
end

mux_4_to_1 addr2_mux(
    .data0({{5{ir[10]}},ir[10:0]}),
    .data1({{7{ir[8]}},ir[8:0]}),
    .data2({{10{ir[5]}}, ir[5:0]}),
    .data3(16'b0),
    .select(addr2mux),
    .data_out(addr2_out)
);

mux_2_to_1 addr1_mux(
    .data0(sr1_data),
    .data1(pc),
    .select(addr1mux),
    .data_out(addr1_out)
);

mux_2_to_1 sr2_mux(
    .data0({{11{ir[4]}}, ir[4:0]}),
    .data1(sr2_data),
    .select(sr2mux),
    .data_out(sr2_out)
);

mux_2_to_1 mio_en_mux(
    .data0(mem_rdata),
    .data1(bus_signal),
    .select(mio_en),
    .data_out(mio_out)
);


assign led_o = ir;
assign hex_display_debug = ir;


load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (bus_signal),

    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pc_in),

    .data_q(pc)
);

load_reg #(.DATA_WIDTH(16)) mar_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mar),
    .data_i(bus_signal),

    .data_q(mar)
);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mdr),
    .data_i(mio_out), //loads data from memory to MDR

    .data_q(mdr)
);

load_reg #(.DATA_WIDTH(16)) reg_0(
    .clk(clk),
    .reset(reset),

    .load(ld_reg0),
    .data_i(bus_signal),

    .data_q(reg0)
);

load_reg #(.DATA_WIDTH(16)) reg_1(
    .clk(clk),
    .reset(reset),

    .load(ld_reg1),
    .data_i(bus_signal),

    .data_q(reg1)
);

load_reg #(.DATA_WIDTH(16)) reg_2(
    .clk(clk),
    .reset(reset),

    .load(ld_reg2),
    .data_i(bus_signal),

    .data_q(reg2)
);

load_reg #(.DATA_WIDTH(16)) reg_3(
    .clk(clk),
    .reset(reset),

    .load(ld_reg3),
    .data_i(bus_signal), 

    .data_q(reg3)
);

load_reg #(.DATA_WIDTH(16)) reg_4(
    .clk(clk),
    .reset(reset),

    .load(ld_reg4),
    .data_i(bus_signal), 

    .data_q(reg4)
);

load_reg #(.DATA_WIDTH(16)) reg_5(
    .clk(clk),
    .reset(reset),

    .load(ld_reg5),
    .data_i(bus_signal),

    .data_q(reg5)
);

load_reg #(.DATA_WIDTH(16)) reg_6(
    .clk(clk),
    .reset(reset),

    .load(ld_reg6),
    .data_i(bus_signal),

    .data_q(reg6)
);

load_reg #(.DATA_WIDTH(16)) reg_7(
    .clk(clk),
    .reset(reset),

    .load(ld_reg7),
    .data_i(bus_signal),

    .data_q(reg7)
);

load_reg #(.DATA_WIDTH(3)) nzp_reg(
    .clk(clk),
    .reset(reset),

    .load(ld_cc),
    .data_i(nzp_data),

    .data_q(nzp)
);

//load_reg #(.DATA_WIDTH(1)) ben_reg(
//    .clk(clk),
//    .reset(reset),
    
//    .load(ld_ben),
//    .data_i(ben_data),
    
//    .data_q (ben)
//);

endmodule
