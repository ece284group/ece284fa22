module core (clk, inst, ofifo_valid, D_xmem, sfp_out, reset);

parameter bw = 4 ; 
parameter psum_bw = 16 ; 
parameter col = 8 ; 
parameter row = 8 ; 

input clk ; 
input reset ; 
input [38:0] inst ; 
input [bw*row-1:0] D_xmem ; 
output ofifo_valid ; 
output [psum_bw*col-1:0] sfp_out ; 


wire CEN_sram ; 
wire WEN_sram ; 
wire [10:0] A_sram ; 


wire CEN_pmem_q;
wire WEN_pmem_q;
wire [13:0] A_pmem_q;

wire [col*psum_bw-1:0] sram_out ; 

wire [bw*row-1:0] Q_xmem ; 

wire [bw*row-1:0] core_ip ; 
reg [bw*row-1:0] core_ip_q ; 

assign core_ip = core_ip_q ; 
assign	CEN_pmem_q = inst[35];
assign	WEN_pmem_q = inst[34];
assign	A_pmem_q   = inst[33:20];

assign	CEN_sram = inst[19]; 
assign	WEN_sram = inst[18]; 
assign	A_sram   = inst[17:7]; 



sram_32b_w2048  sram (
	.CLK(clk) , 
	.D(D_xmem) , 
	.Q(Q_xmem) , 
	.CEN(CEN_sram), // CEN_xmem_q
	.WEN(WEN_sram) , // WEN_xmem_q
	.A(A_sram) ) ;  // A_xmem_q

 

sram_128b  psum_sram (
	.CLK(clk) , 
	.D(sfp_out) , 
	.Q( sram_out) , 
	.CEN(CEN_pmem_q), // CEN_pmem_q
	.WEN(WEN_pmem_q) , // WEN_pmem_q
	.A(A_pmem_q) ) ;  // A_pmem_q

corelet  #(.bw(bw), .col(col), .row(row)) corelet_instance ( // has SFP, OFIFO, MAC, L0
	.clk(clk), 
	.inst(inst),
	.ofifo_valid(ofifo_valid),
        .D_xmem(Q_xmem), 
        .sfp_out(sfp_out), 
	.reset(reset) , 
	.sram_p(sram_out)) ; 


always @ (posedge clk) begin
/*	
if () begin 
	core_ip_q = D_xmem ; 
end else begin 
	core_ip_q = Q_xmem ; 
end 
*/
end 


endmodule


