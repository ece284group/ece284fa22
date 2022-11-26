// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_tile (clk, out_s, in_w, out_e, in_n, inst_w, inst_e, reset, valid);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out_s;
input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
output [bw-1:0] out_e; 
input  [1:0] inst_w;
output [1:0] inst_e;
input  [psum_bw-1:0] in_n;
input  clk;
input  reset;
output valid ; 

wire    [1:0] inst_q ; // wire or reg better ???
reg    [bw-1:0] a_q;
reg    [bw-1:0] b_q;
reg    [psum_bw-1:0] c_q;
wire    [psum_bw-1:0] out_s;
wire     load_ready_q; 

reg     [1:0] temp ; // for inst_q 
reg     [psum_bw-1:0] out_temp ; 
reg    load_ready_q_t ; 
reg    [bw-1:0] out_e_t ;
reg     valid_t ;  
reg    [bw-1:0] inst_e_t  ; 

assign inst_e = inst_e_t ; 
assign valid = valid_t ; 
assign out_e = out_e_t ; 
assign out_s = out_temp ; 
assign load_ready_q = load_ready_q_t ; 
assign inst_q = temp ; 
mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
	.out(out_s)
); 

always @ (posedge clk) begin
        if (reset) begin 
                temp[0] = 0 ; 
                temp[1] = 0 ; 
                load_ready_q_t = 1 ; 
        end else begin 
                temp[1] = inst_w[1] ; // always 
                if (inst_w[1] || inst_w[0])  begin 
                        a_q = in_w ; // A 
                        if (inst_w[0] == 1) begin
                                if (load_ready_q == 1) begin 
                                        b_q = in_w ; 
                                        load_ready_q_t = 0 ; 
                                end 
                        end else if(load_ready_q == 0) begin 
                                temp[0] = inst_w[0] ; 
                        end 

                        if (inst_w[1] == 1) begin // execution 
                                c_q = in_n ; 
                        end 

               end 
        inst_e_t = temp ;
        end     
        out_e_t = a_q ; 
        //out_temp = mac_out ; 
        valid_t = inst_e[1] ; 

end

endmodule
