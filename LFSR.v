module LFSR #(parameter WIDTH = 16, parameter SEED = 16'hACE1)
  (
   input              i_Clock,
   input              i_Enable,
   output [7:0]   o_LFSR_Byte
   );

  reg [WIDTH-1:0] r_LFSR = SEED;

  always @(posedge i_Clock)
  begin
    if (i_Enable)
      r_LFSR <= {r_LFSR[WIDTH-2:0], r_LFSR[WIDTH-1] ^ r_LFSR[6] ^ r_LFSR[4] ^ r_LFSR[3]};
  end

  assign o_LFSR_Byte = r_LFSR[7:0];
endmodule
