interface RegArr_if(input logic clk , input logic rst);
    logic en;
    logic we,re1,re2;
    logic [2:0] waddr, raddr1, raddr2;
    logic [31:0] wdata,rdata1,rdata2;


    modport RegArr(input we, re1 , re2, waddr, raddr1, raddr2, clk, rst, wdata,en,
                    output rdata1, rdata2);
    
endinterface



module Reg_Arr(RegArr_if.RegArr RegIf);

  // Register array: 8 registers, each 32-bit wide
  logic [31:0] register [7:0];


  // State encoding
  typedef enum logic [1:0] {
    IDEAL = 2'b00,
    WRITE = 2'b01,
    READ  = 2'b10,
    DONE  = 2'b11
  } state;

  state curr_state, next_state;

  property no_rw_overlap;
    @(posedge RegIf.clk) disable iff ( RegIf.rst) 
    !(RegIf.we && ((RegIf.re1 && RegIf.raddr1 ==  RegIf.waddr) || ( RegIf.re2 &&  RegIf.raddr2 ==  RegIf.waddr)));
  endproperty

  assert property(no_rw_overlap) else $error("Read/Write to same address %b at time %0t", RegIf.waddr,$time);




  // FSM: Next State Logic
  always_comb begin
    case (curr_state)
      IDEAL: begin
        if (RegIf.en && RegIf.we)
          next_state = WRITE;
        else if (RegIf.en && (RegIf.re1 || RegIf.re2))
          next_state = READ;
        else
          next_state = IDEAL;
      end

      WRITE: next_state = DONE;
      READ:  next_state = DONE;
      DONE:  next_state = IDEAL;
      default: next_state = IDEAL;
    endcase
  end

  // FSM: State Register
  always_ff @(posedge RegIf.clk or posedge RegIf.rst) begin
  if (RegIf.rst) begin
    curr_state <= IDEAL;
    for (int i = 0; i < 8; i++)
      register[i] <= 32'b0;
  end else begin
    curr_state <= next_state;
    if (next_state == WRITE)
      register[RegIf.waddr] <= RegIf.wdata;
  end
end


  // Register Read Logic
  always_comb begin
    if (curr_state == READ) begin
      RegIf.rdata1 = (RegIf.re1) ? register[RegIf.raddr1] : 32'bz;
      RegIf.rdata2 = (RegIf.re2) ? register[RegIf.raddr2] : 32'bz;
    end else begin
      RegIf.rdata1 = 32'bz;
      RegIf.rdata2 = 32'bz;
    end
  end

endmodule




