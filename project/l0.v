// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module l0 (clk, in, out, rd, wr, o_full, reset, o_ready);

  parameter row  = 8;
  parameter bw = 4;

  input  clk;
  input  wr;
  input  rd;
  input  reset;
  input  [row*bw-1:0] in;
  output [row*bw-1:0] out;
  output o_full;
  output o_ready;

  wire [row-1:0] empty;
  wire [row-1:0] full;
  reg [row-1:0] rd_en;
  
  genvar i;
  

  wire [row-1:0] full_t ; 
  //reg [row-1:0] ready_t = 0 ; 

  //reg o_full_t = 0 ; 
  //reg o_ready_t ; 

  assign o_ready = (full_t == 8'b00000000) ;
  assign o_full  = !(full_t == 8'b00000000) ; // o_full is 1 if 1 of full_t is 1 ????


  for (i=0; i<row ; i=i+1) begin : row_num
      fifo_depth64 #(.bw(bw)) fifo_instance (
	 .rd_clk(clk),
	 .wr_clk(clk), // ???
	 .rd(rd_en[i]),
	 .wr(wr),
         .o_empty(empty[i]),
         .o_full(full_t[i]),
	 .in(in[(i+1)*bw-1: i*bw]),
	 .out(out[(i+1)*bw-1: i*bw]),
         .reset(reset));
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 8'b00000000;
   end
   else

      /////////////// version1: read all row at a time ////////////////
      // uncomment lines 56-60 for version1
      //if (rd ) begin  // 1 non zero value 
      //   rd_en <= 8'b11111111 ; 
      //end else begin 
      //   rd_en <= 8'b00000000 ; 
      //end 

      
      ///////////////////////////////////////////////////////



      //////////////// version2: read 1 row at a time /////////////////
      if (!(rd) ) begin 
         if (rd_en[0] == 0 ) begin 
            if ( rd_en[1] == 0 ) begin 
               if ( rd_en[2] == 0 ) begin 
                  if ( rd_en[3] == 0 ) begin 
                     if ( rd_en[4] == 0 ) begin 
                        if ( rd_en[5] == 0 ) begin 
                           if ( rd_en[6] == 0 ) begin 
                              if (rd_en[7] == 0) begin 
                                 //rd_en[0] = 0 ; 
                              end else begin 
                                 rd_en[7] <= 0 ; 
                              end 
                           end else begin 
                              rd_en[6] <= 0 ; 
                           end 
                        end else begin 
                           rd_en[5] <= 0 ; 
                        end 
                     end else begin 
                        rd_en[4] <= 0 ; 
                     end 
                  end else begin 
                     rd_en[3] <= 0 ; 
                  end 
               end else begin 
                  rd_en[2] <= 0 ; 
               end 
            end else begin 
               rd_en[1] <= 0 ; 
            end 
         end else begin 
            rd_en[0] <= 0 ; 
         end 
      end else if (rd) begin 
         if (rd_en[0] != 0 ) begin 
            if ( rd_en[1] != 0 ) begin 
               if ( rd_en[2] != 0 ) begin 
                  if ( rd_en[3] != 0 ) begin 
                     if ( rd_en[4] != 0 ) begin 
                        if ( rd_en[5] != 0 ) begin 
                           if ( rd_en[6] != 0 ) begin 
                              if (rd_en[7] != 0) begin 
                                 //rd_en[0] = 0 ; 
                              end else begin 
                                 rd_en[7] <= 1 ; 
                              end 
                           end else begin 
                              rd_en[6] <= 1 ; 
                           end 
                        end else begin 
                           rd_en[5] <= 1 ; 
                        end 
                     end else begin 
                        rd_en[4] <= 1 ; 
                     end 
                  end else begin 
                     rd_en[3] <= 1 ; 
                  end 
               end else begin 
                  rd_en[2] <= 1 ; 
               end 
            end else begin 
               rd_en[1] <= 1 ; 
            end 
         end else begin 
            rd_en[0] <= 1 ; 
         end
      end 
      ///////////////////////////////////////////////////////
    end

endmodule
