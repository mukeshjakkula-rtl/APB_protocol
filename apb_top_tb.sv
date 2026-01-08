module apb_top_tb#(
	parameter DATA_WIDTH = 16,
		  MEM_DEPTH = 1024,
		  ADDR_WIDTH = $clog2(MEM_DEPTH));
  
  logic p_clk;
  logic p_rst;
  logic t_valid;
  logic p_write_in;
  logic [1:0]p_sel_in;
  logic [DATA_WIDTH-1 : 0]pw_data_in;
  logic [ADDR_WIDTH-1 : 0]p_addr_in;
  logic [DATA_WIDTH-1 : 0]pr_data_out;
  logic [DATA_WIDTH-1 : 0]pw_data_out;

 apb_ms_top dut(.p_clk(p_clk),
		.p_rst(p_rst),
		.t_valid(t_valid),
		.p_write_in(p_write_in),
		.p_sel_in(p_sel_in),
		.pw_data_in(pw_data_in),
		.p_addr_in(p_addr_in),
		.pr_data_out(pr_data_out),
		.pw_data_out(pw_data_out));		

   initial begin
      p_clk = 1'b0;
      p_rst = 1'b1;
  #10 p_rst = 1'b0;
   end 
   always #5 p_clk = ~p_clk;
   
   initial begin
      #15 	      t_valid = 1'b1;
 		      p_write_in = 1'b1;
                      p_sel_in = 2'b01;
                      p_addr_in = 20;
                      pw_data_in = 15;
    
      #25              t_valid = 1'b0;
                       p_sel_in = 2'b00;

      #35              t_valid = 1'b1;
                       p_sel_in = 2'b01;
                       p_addr_in = 20;
                       p_write_in = 1'b0;

     #10                p_sel_in = 2'b00; 
		       t_valid = 1'b0;                      
       
   

        
   end
   initial begin
     $dumpfile("ms_ave.vcd");
     $dumpvars(0,apb_top_tb);
   end 


  initial #500 $finish;



 

endmodule 
