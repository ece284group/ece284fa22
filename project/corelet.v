module corelet (clk, reset, inst );

parameter row = 8 ; 
parameter col = 8 ; 
parameter bw = 4 ; 
parameter psum_bw = 16; 

input inst; 
input clk;
input ofifo_valid;
input [bw*row-1:0] D_xmem; 
output [col*psum_bw-1:0] sfp_out;
input reset; 


reg [row*bw-1:0] l0_out ; // Reg or Wire
reg [psum_bw*col-1:0] mac_out ; 



mac_array   mac_array_instance (
	.clk(clk) , 
	.reset(reset), 
    .out_s(mac_out), 
    .in_w(), 
    .in_n(l0_out), 
    .inst_w(), 
    .valid() ) ; 

sfp  sfp_instance(
    .out(sfp_out), 
    .in(mac_out), 
    .thres(), 
    .acc(inst[33]), //acc_q
    .relu(), 
    .clk(clk), 
    .reset(reset));

l0 l0_instance (
    .clk(clk), 
    .in(), 
    .out(l0_out), 
    .rd(inst[3]), //l0_rd
    .wr(inst[2]), 
    .o_full(), 
    .reset(reset), 
    .o_ready()) ;


ofifo ofifo_instance(
    .clk(clk), 
    .in(), 
    .out(), 
    .rd(), 
    .wr(), 
    .o_full(), 
    .reset(reset), 
    .o_ready());
    


always @ (posedge clk) begin


end


endmodule