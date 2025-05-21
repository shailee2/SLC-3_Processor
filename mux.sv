module mux_2_to_1(
    input logic [15:0] data0,
    input logic [15:0] data1,
    input logic select,
   
    output logic [15:0] data_out
    );
   
    always_comb
    begin
        case(select)
            1'b0: data_out = data0;
            1'b1: data_out = data1;
            default: data_out = 16'b0;
        endcase
    end        
         
endmodule

module mux_3_to_1(
    input logic [15:0] data0,
    input logic [15:0] data1,
    input logic [15:0] data2,
    input logic [1:0] select,
   
    output logic [15:0] data_out
    );
   
    always_comb
    begin
        case(select)
            2'b00: data_out = data0;
            2'b01: data_out = data1;
            2'b10: data_out = data2;
            default: data_out = 16'b0;
        endcase
    end        
         
endmodule

module mux_4_to_1(
    input logic [15:0] data0,
    input logic [15:0] data1,
    input logic [15:0] data2,
    input logic [15:0] data3,
    input logic [1:0] select,
    
    output logic [15:0] data_out
    );
    
    always_comb
    begin
       case(select)
        2'b00: data_out = data0;
        2'b01: data_out = data1;
        2'b10: data_out = data2;
        2'b11: data_out = data3;
        default: data_out = 16'b0;
       endcase 
    end            
endmodule

//module mux_4_to_1_4bit(
//    input logic [3:0] data0,
//    input logic [3:0] data1,
//    input logic [3:0] data2,
//    input logic [3:0] data3,
//    input logic [1:0] select,
    
//    output logic [3:0] data_out
//    );
    
//    always_comb
//    begin
//       case(select)
//        2'b00: data_out = data0;
//        2'b01: data_out = data1;
//        2'b10: data_out = data2;
//        2'b11: data_out = data3;
//        default: data_out = 16'b0;
//       endcase 
//    end            
//endmodule


module mux_5_to_1(
    input logic [15:0] data0,
    input logic [15:0] data1,
    input logic [15:0] data2,
    input logic [15:0] data3,
    input logic [15:0] data4,
    input logic [3:0] select,
   
    output logic [15:0] data_out
    );
   
    always_comb
    begin
        case(select)
            4'b0000: data_out = data0;
            4'b0001: data_out = data4;
            4'b0010: data_out = data1;
            4'b0100: data_out = data2;
            4'b1000: data_out = data3;
            default: data_out = data0;
        endcase
    end
endmodule
    
module mux_8_to_1(
    input logic [15:0] data0,
    input logic [15:0] data1,
    input logic [15:0] data2,
    input logic [15:0] data3,
    input logic [15:0] data4,
    input logic [15:0] data5,
    input logic [15:0] data6,
    input logic [15:0] data7,
    input logic [2:0] select,
   
    output logic [15:0] data_out
    );
   
    always_comb
    begin
        case(select)
            3'b000: data_out = data0;
            3'b001: data_out = data1;
            3'b010: data_out = data2;
            3'b011: data_out = data3;
            3'b100: data_out = data4;
            3'b101: data_out = data5;
            3'b110: data_out = data6;
            3'b111: data_out = data7;
            default: ;
        endcase
    end        
endmodule
