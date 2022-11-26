module corelet (clk, reset, inst, ofifo_valid, D_xmem, sfp_out, sram_p);

parameter row = 8 ; 
parameter col = 8 ; 
parameter bw = 4 ; 
parameter psum_bw = 16; 

input [35:0] inst; 
input clk;
output ofifo_valid;
input [bw*row-1:0] D_xmem; 
output [col*psum_bw-1:0] sfp_out;

reg  [col*psum_bw-1:0] sfp_out_t ; 
input reset; 
input [col*psum_bw-1:0] sram_p ; 

// used
wire [row*bw-1:0] l0_out ; // Reg or Wire
wire [psum_bw*col-1:0] mac_out ; 
wire [col-1:0] mac_valid ; 
wire [col*psum_bw-1:0] ofifo_out ; 
wire [col*psum_bw-1:0] sfp_temp ; 

// still need to assign 
wire ofifo_ready ; 
wire ofifo_full ; 
wire l0_ready ; 
wire l0_full ; 

// constant
reg [127:0] thres = 128'd64 ; 

assign sfp_out = sfp_out_t ; 

mac_array   mac_array_instance (
	.clk(clk) , 
	.reset(reset), 
    .out_s(mac_out), 
    .in_w(l0_out), 
    .in_n(sfp_out), 
    .inst_w(inst[1:0]), 
    .valid(mac_valid) ) ; 

sfp  sfp_instance(
    .out(sfp_temp), 
    .in(sram_p),  // ????????
    .thres(thres), 
    .acc(inst[33]), //acc_q
    .relu(relu), 
    .clk(clk), 
    .reset(reset));

l0 l0_instance (
    .clk(clk), 
    .in(D_xmem), 
    .out(l0_out), 
    .rd(inst[3]), //l0_rd
    .wr(inst[2]), 
    .o_full(l0_full), 
    .reset(reset), 
    .o_ready(l0_ready)) ;

ofifo ofifo_instance(
    .clk(clk), 
    .in(mac_out), 
    .out(ofifo_out), 
    .rd(inst[6]), 
    .wr(mac_valid),  
    .o_full(ofifo_full), 
    .reset(reset), 
    .o_ready(ofifo_ready),
    .o_valid(ofifo_valid));

always @ (posedge clk) begin
    if (inst[35] ) begin 
        sfp_out_t = sfp_temp ; 
    end else begin 
        sfp_out_t = ofifo_out ; 
    end 
end 


endmodule






