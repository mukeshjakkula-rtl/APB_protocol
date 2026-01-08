module apb_slave_tb#(parameter DATA_WIDTH = 16,
                               MEM_DEPTH  = 1024,
                               ADDR_WIDTH = $clog2(MEM_DEPTH))();
   reg pclk,prst;  
   reg [DATA_WIDTH-1:0]pwdata;
   reg [ADDR_WIDTH-1:0]paddr; 
   reg pwrite;
   reg psel,penable;
   wire [ADDR_WIDTH-1:0]prdata;
   wire pready;
   
   apb_slave dut(.pclk(pclk), .prst(prst), .psel(psel), .paddr(paddr), .pwdata(pwdata), .prdata(prdata), .pwrite(pwrite), .penable(penable), .pready(pready));
   
initial begin
    pclk = 1'b0;
    prst = 1'b1;
#10 prst = 1'b0;
end 

always #5 pclk = ~pclk;

initial begin
  @(posedge pclk) psel = 1'b1;
		  penable = 1'b0;
                  paddr = 20;
                  pwrite = 1'b1;
                  pwdata = 100;
 #15         // @(posedge clk) is not working so matched the posedge with the dealy 
 penable = 1'b1;

  #25  psel = 1'b1;
		  penable = 1'b0;
                  paddr = 20;
                  pwrite = 1'b0;
 #35         // @(posedge clk) is not working so matched the posedge with the dealy 
 penable = 1'b1;

end 

initial begin
   $dumpfile("apb_wave.vcd");
   $dumpvars(0,apb_slave_tb);
end 

initial #500 $finish;



endmodule
