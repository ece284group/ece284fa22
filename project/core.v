module core (clk, inst, ofifo_valid, D_xmem, sfp_out, reset);

parameter bw = 4 ; 
parameter col = 8 ; 
parameter row = 8 ; 

input clk ; 
input reset ; 
input inst ; 
input D_xmem ; 
input ofifo_valid ; 
output sfp_out ; 

sram_32b_w2048  sram (
	.CLK(clk) , 
	.D(D_xmem) , 
	.Q() , 
	.CEN(inst[19]), // CEN_xmem_q
	.WEN(inst[18]) , // WEN_xmem_q
	.A(inst[17:7]) ) ;  // A_xmem_q

 

sram_32b_w2048  psum_sram (
	.CLK(clk) , 
	.D( ) , 
	.Q( ) , 
	.CEN(inst[32]), // CEN_pmem_q
	.WEN(inst[31]) , // WEN_pmem_q
	.A(inst[30:20]) ) ;  // A_pmem_q

corelet  #(.bw(bw), .col(col), .row(row)) core_instance ( // has SFP, OFIFO, MAC, L0
	.clk(clk), 
	.inst(inst),
	.ofifo_valid(ofifo_valid),
        .D_xmem(D_xmem), 
        .sfp_out(sfp_out), 
	.reset(reset)) ; 


always @ (posedge clk) begin


end 


endmodule


