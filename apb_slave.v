module apb_slave#(parameter DATA_WIDTH = 16,
                            MEM_DEPTH = 1024,
                            ADDR_WIDTH = $clog2(MEM_DEPTH))(
   input wire pclk,
   input wire prst,
   input wire [ADDR_WIDTH-1:0]paddr,
   input wire [DATA_WIDTH-1:0]pwdata,
   input wire penable,
   input wire pwrite,
   input wire psel,
   output reg [DATA_WIDTH-1:0]prdata,
   output reg pready
);

reg [DATA_WIDTH-1:0]apb_mem[MEM_DEPTH-1:0];  // 2KB memory slave 
reg [DATA_WIDTH-1:0]apb_data_buff;
reg [ADDR_WIDTH-1:0]apb_addr_buff;
reg apb_pwrite_buff;

typedef enum logic[2:0]{IDLE = 3'b100,
			SETUP = 3'b010,
			ACCESS = 3'b001}apb_states;
apb_states state;

always@(posedge pclk) begin
  if(prst) begin
    state <= IDLE;
    pready <= 1'b0;
    prdata <= {DATA_WIDTH{1'b0}};
    apb_addr_buff <= {ADDR_WIDTH{1'b0}};
    apb_data_buff <= {DATA_WIDTH{1'b0}};
    apb_pwrite_buff <= 1'b0;
    for(integer i = 0;i<ADDR_WIDTH;i++) begin
      apb_mem[i] <= {DATA_WIDTH{1'b0}};
    end
  end else begin
    case(state) 
      IDLE : begin
         pready <= 1'b0;
         prdata <= {DATA_WIDTH{1'b0}};
         if(psel && !penable) begin
            state <= SETUP;
         end else begin
            state <= IDLE;
         end
      end //idle

      SETUP : begin
	 pready <= 1'b0;
         if(pwrite) begin
	    apb_data_buff <= pwdata;
	    apb_addr_buff <= paddr;
	    apb_pwrite_buff <= pwrite;
            if(penable) state <= ACCESS;
            else state <= SETUP;
         end else if(!pwrite) begin
            apb_data_buff <= apb_mem[paddr];
	    apb_addr_buff <= paddr;
	    apb_pwrite_buff <= pwrite;
            if(penable) state <= ACCESS;
            else state <= SETUP;      
         end
      end //setup

      ACCESS : begin
        if(psel && penable) begin
	   if(apb_pwrite_buff) begin
              apb_mem[apb_addr_buff] <= apb_data_buff;
              pready <= 1'b1;
	      state <= IDLE;
           end else if(!apb_pwrite_buff) begin
   	      prdata <= apb_data_buff;
 	      state <= IDLE;
              pready <= 1'b1;
           end
        end else begin
             state <= ACCESS;
             pready <= 1'b0;
        end
     end //access
    endcase
  end
end 
endmodule 


// in setup state we wait for penable to go to the access state and 
// in access state we see if penable is high we latch the datas so this 

// in sepc it is mentioned that untill pready is high
// pdata,paddr,psel,pwrite,penable have
// to be stable but in access state after pready is high the next triggering
// edge only the transaction capturing happens so what if the data changes
// immediately after access state cause the state changes immediatly when
// pready is high 

// so all these things have to happen at the same triggering edge after pready going high 
// state change from access to idle
// capturing the data from master or giving data to master 
// master chnaging the signals according to next transactions 
// so to avoid the race conditions we use internal buffers 



// still we have buffers to get reliable data 
// could cause issues if paddr,pwdata,pwrite changes immediately in access
// state so, // we add buffers for all those signals in setup state 
