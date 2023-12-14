`timescale 1ns / 1ps

`include "pipeline.sv"

//------------------------------------------------------------------------------

module testbench();

  logic       clock;
  logic       reset;

  initial clock = 0;
  initial reset = 1;

  always #5 clock = ~clock;

  initial begin
  end

  initial begin
    reset = 1;
    #10;
    reset = 0;
  end

  function automatic logic[31:0] scramble(logic[31:0] x);
    logic[31:0] seed;
    seed = 32'h79518753;
    x ^= seed;
    x ^= x >> 16;
    x *= 32'h85ebca6b;
    x ^= x >> 13;
    x *= 32'hc2b2ae35;
    x ^= x >> 16;
    scramble = x;
  endfunction

  //----------------------------------------

  logic[15:0] us_data;
  logic       us_valid;
  logic       us_ready;

  logic[15:0] ds_data;
  logic       ds_valid;
  logic       ds_ready;
  logic[15:0] ds_out;

  //----------------------------------------

  pipeline my_pipeline(
    .clock  (clock),
    .reset  (reset),
    .us_data   (us_data),
    .us_valid  (us_valid),
    .us_ready  (us_ready),
    .ds_data   (ds_data),
    .ds_valid  (ds_valid),
    .ds_ready  (ds_ready)
  );

  logic[15:0] counter;
  initial counter = 0;
  always @(posedge clock) counter <= counter + 1;

  logic[31:0] scrambled;
  assign scrambled = scramble(counter);

  always_comb begin
    us_valid = scrambled[1];
    us_data  = (scrambled[1] && us_ready) ? counter : 16'hXXXX;
    ds_ready = scrambled[0];
    ds_out   = (ds_valid && scrambled[0]) ? ds_data : 16'hXXXX;
  end

  always @(posedge clock) begin
  end

  initial begin
    int i;

    $dumpfile("pinwheel.vcd");
    $dumpvars(0, testbench);
    $display("================================================================================");
    $display("Hello World");

    for (i = 0; i < 200; i++) begin
      @(posedge clock);
    end

    $display("Done");
    $display("================================================================================");
    $finish();
  end

endmodule

//------------------------------------------------------------------------------
