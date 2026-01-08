module apb_master_tb #(DATA_WIDTH = 16,
		      MEM_DEPTH = 1024,
		      ADDR_WIDTH = $clog2(MEM_DEPTH))();

  reg pclk;
  reg prst;
  reg t_valid;
  reg pready;
  reg pwrite_in;
  reg [1:0]psel_in;
  reg [DATA_WIDTH-1 : 0]pwdata_in;
  reg [ADDR_WIDTH-1 : 0]paddr_in;
  reg [DATA_WIDTH-1 : 0]prdata;
  
  wire [DATA_WIDTH-1 : 0]pwdata;
  wire [ADDR_WIDTH-1 : 0]paddr;
  wire pwrite;
  wire psel1,psel2,psel3,psel4;
  wire penable;

apb_master dut (.pclk(pclk), 
		.prst(prst), 
		.t_valid(t_valid), 
		.pready(pready), 
		.pwdata_in(pwdata_in), 
		.paddr_in(paddr_in), 
		.prdata(prdata), 
		.pwdata(pwdata), 
		.paddr(paddr), 
		.pwrite(pwrite), 
		.psel1(psel1),
		.psel2(psel2),
		.psel3(psel3),
		.psel4(psel4),
		.penable(penable),
		.pwrite_in(pwrite_in),
		.psel_in(psel_in));


initial begin
    pclk = 1'b0;
    prst = 1'b1;
#8  prst = 1'b0;
end 
  always #5 pclk = ~pclk;

 initial begin
     @(posedge pclk)  t_valid = 1'b1;
     
     @(posedge pclk) psel_in = 2'b01;
	 pwrite_in = 1'b1;
         pwdata_in = 20;
         paddr_in = 10;
 end 


 initial begin
   $dumpfile("wave.vcd");
   $dumpvars(0,apb_master_tb);
 end
  
 initial #500 $finish;
endmodule 
