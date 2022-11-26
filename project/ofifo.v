// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module ofifo (clk, in, out, rd, wr, o_full, reset, o_ready, o_valid);

  parameter col  = 8;
  parameter bw = 4;
  parameter psum_bw = 16 ; 
  input  clk;
  input  [col-1:0] wr;
  input  rd;
  input  reset;
  input  [col*psum_bw-1:0] in;
  output [col*psum_bw-1:0] out;
  output o_full;
  output o_ready;
  output o_valid;

  wire [col-1:0] empty;
  wire [col-1:0] full;
  reg  rd_en;
  
  genvar i;
  genvar j;
  
  assign o_ready = (full == 8'b00000000) ;
  assign o_full  = !(full == 8'b00000000) ;
  assign o_valid = (empty == 8'b00000000) ; // empty has 1 if col'm has no entries

  for (i=0; i<col ; i=i+1) begin// : col_num
    for (j= 0; j < 4 ; j = j + 1) begin //: jth_entry\\\
        fifo_depth64 #(.bw(bw)) fifo_instance (
          .rd_clk(clk),
          .wr_clk(clk),
          .rd(rd_en),
          .wr(wr[i]),
          .o_empty(empty[i]),
          .o_full(full[i]),
          .in( in[(i*psum_bw)  - 1 + ((j+1)*bw) :(i*psum_bw)+(j*bw)]),
          .out(out[(i*psum_bw) - 1 + ((j+1)*bw) :(i*psum_bw)+(j*bw)]),
          .reset(reset));
    end
  end 


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 0;
   end
   else
      
    if (rd) begin 
      rd_en <= 1 ; 
      end else begin 
        rd_en <= 0 ; 
      end 
 
  end

 

endmodule

