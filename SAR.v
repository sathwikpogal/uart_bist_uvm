module SAR #(parameter WIDTH = 16)
  (
   input             i_Clock,
   input             i_Enable,
   input [7:0]       i_Data,
   output [WIDTH-1:0] o_SAR
   );

  reg [WIDTH-1:0] r_SAR = 0;

  always @(posedge i_Clock)
  begin
    if (i_Enable)
      r_SAR <= r_SAR + i_Data;
  end

  assign o_SAR = r_SAR;
endmodule


