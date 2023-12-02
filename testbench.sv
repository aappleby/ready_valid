`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/30/2023 10:58:49 PM
// Design Name:
// Module Name: testbench
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

`include "pipeline.sv"

module testbench();

  logic       clock;
  logic       reset;

  logic[15:0] data;
  logic       data_valid;
  logic       data_ready;

  logic[15:0] result;
  logic       result_valid;
  logic       result_ready;

  //----------------------------------------

  initial clock = 0;
  always #5 clock = ~clock;

  //----------------------------------------

  initial begin
    //data = 0;
    //data_valid = 1;
    result_ready = 1;
  end

  /*
  always @(posedge clock) begin
    if (data_valid && data_ready) begin
      data <= data + 1;
    end
  end
  */

  //----------------------------------------

  pipeline my_pipeline(
    .clock(clock),
    .reset(reset),
    .data(data),
    .data_valid(data_valid),
    .data_ready(data_ready),
    .result(result),
    .result_valid(result_valid),
    .result_ready(result_ready)
  );


  initial begin
    $dumpfile("pinwheel.vcd");
    $dumpvars(0, testbench);
    $display("================================================================================");
    $display("Hello World");

    reset = 1;
    data = 0;

    #10

    reset = 0;
    data = 0;

    #150

    $display("Done");
    $display("================================================================================");
    $finish();
  end

endmodule
