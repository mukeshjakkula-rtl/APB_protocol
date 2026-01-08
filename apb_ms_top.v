module apb_ms_top#(
	parameter DATA_WIDTH = 16,
		  MEM_DEPTH = 1024,
		  ADDR_WIDTH = $clog2(MEM_DEPTH))(
   input wire p_clk,
   input wire p_rst,
   input wire t_valid,
   input wire p_write_in,
   input wire [1:0]p_sel_in,
   input wire [DATA_WIDTH-1 : 0]pw_data_in, // in -m
   input wire [ADDR_WIDTH-1 : 0]p_addr_in,  // in -m
   output reg [DATA_WIDTH-1 : 0]pr_data_out, // glue logic signals to verify
   output reg [DATA_WIDTH-1 : 0]pw_data_out //glue logic signals to verify
);
   wire [DATA_WIDTH-1 : 0]pr_data_w; // s - m
   wire [DATA_WIDTH-1 : 0]pw_data_w; // m - s
   wire [ADDR_WIDTH-1 : 0]p_addr_w; // m - s
   wire p_write_w; // m - s
   wire p_sel1_w; // m - s
   wire p_enable_w; // m - s
   wire p_ready_w; // s - m
   wire p_sel2_w,p_sel3_w,p_sel4_w; // extra slaves signals
  
   
  apb_master f1(.pclk(p_clk), 
		.prst(p_rst), 
		.t_valid(t_valid),
		.pwrite_in(p_write_in),
		.psel_in(p_sel_in),
		.pwdata_in(pw_data_in),
		.paddr_in(p_addr_in),
		.pready(p_ready_w),
		.prdata(pr_data_w),
		.paddr(p_addr_w),
		.pwdata(pw_data_w),
		.pwrite(p_write_w),
		.psel1(p_sel1_w),
		.psel2(p_sel2_w),
		.psel3(p_sel3_w),
		.psel4(p_sel4_w),
		.penable(p_enable_w));

   apb_slave f2(.pclk(p_clk),
		.prst(p_rst),
		.psel(p_sel1_w),
		.paddr(p_addr_w),
		.pwdata(pw_data_w),
		.pwrite(p_write_w),
		.prdata(pr_data_w),
		.pready(p_ready_w),
		.penable(p_enable_w));
		
   assign pr_data_out  = pr_data_w;
   assign pw_data_out  = pw_data_w;

endmodule 
