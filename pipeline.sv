`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/30/2023 10:38:09 PM
// Design Name:
// Module Name: pipeline
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module pipeline
#(
  parameter constant = 32'h84573215
)
(
  input  logic       clock,
  input  logic       reset,

  input  logic[15:0] data,
  input  logic       data_valid,
  output logic       data_ready,

  output logic[15:0] result,
  output logic       result_valid,
  input  logic       result_ready
);

  logic[15:0] temp;
  logic[15:0] temp_next;
  logic      done;

  initial begin
    temp = 8'b0;
    data_ready = 0;
    result = 0;
    result_valid = 0;
  end

  always_comb begin
    logic[31:0] m;

    m = temp;
    m ^= m >> 9;
    m ^= m << 7;
    m += 16'h1431;
    m ^= 16'h4237;

    temp_next = m;
    done = (temp_next[1:0] == 0);

  end

  always @(posedge clock) begin
    if (reset) begin
      temp <= 0;
    end else begin
      result_valid <= 0;
      data_ready <= 0;

      if (done && data_valid && result_ready) begin

        temp         <= data;
        data_ready   <= 1;

        result       <= temp;
        result_valid <= 1;

      end else begin
        if (!done) temp <= temp_next;
      end
    end
  end


endmodule
