module apb_master#(
	parameter DATA_WIDTH = 16,
		  MEM_DEPTH = 1024,
		  ADDR_WIDTH = $clog2(MEM_DEPTH))(
	input wire pclk,
	input wire prst,
	input wire t_valid,
	input wire pready,
	input wire pwrite_in,
	input wire [1:0]psel_in,
	input wire [DATA_WIDTH-1 : 0]pwdata_in,
	input wire [ADDR_WIDTH-1 : 0]paddr_in,
	input wire [DATA_WIDTH-1 : 0]prdata,

	output reg [DATA_WIDTH-1 : 0]pwdata,
	output reg [ADDR_WIDTH-1 : 0]paddr,
	output reg pwrite,
        output reg psel1,psel2,psel3,psel4,  //assuming multiple apb_slaves
	output reg penable
);

wire [3:0]psel_d_out; // output of the apb_slave decoder in master
reg [DATA_WIDTH-1:0]prdata_buff;
typedef enum logic[2:0]{IDLE = 3'b100,
			SETUP = 3'b010,
			ACCESS = 3'b001} apb_states;
apb_states state;


  always@(posedge pclk) begin
    if(prst) begin
	state <= IDLE;
	pwdata <= {DATA_WIDTH{1'b0}};
	paddr <= {ADDR_WIDTH{1'b0}};
	penable <= 1'b0;
	psel1 <= 1'b0;
	psel2 <= 1'b0;
	pwrite <= 1'b0;
    end else begin
	case(state) 
	  IDLE : begin
	     psel1 <= 1'b0;
	     psel2 <= 1'b0;
	     penable <= 1'b0;
	     if(t_valid) state <= SETUP;
	     else state <= IDLE;
	  end // idle

	  SETUP : begin
		{psel4,psel3,psel2,psel1} <= psel_d_out;
		penable <= 1'b0;
		pwrite <= pwrite_in;
		paddr <= paddr_in;
		pwdata <= pwdata_in;
		state <= ACCESS;
	  end //setup

	  ACCESS : begin
		penable <= 1'b1;
		prdata_buff <= prdata;
		
		if(pready && t_valid) begin
		   state <= SETUP;
		   prdata_buff <= prdata;
		end else if(pready && !t_valid) begin
		   state <= IDLE;
		   prdata_buff <= prdata;
		end else if(!pready) state <= ACCESS;
	     end //access
	endcase
    end   
  end 

   decoder f1(.in(psel_in), .out({psel_d_out})); // slave address decoder 

endmodule 



// considering there is some other interface which gives the 
// psel_in,paddr_in,pwdata_in,pwrite_in signals like apb_bridge
// there is  decoder for managng the multipule slaves 
// we get the address in psel_in to select a particular slave 
// designed the decoder inside the master for cleaner output 
