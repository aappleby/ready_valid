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

  always @* begin
    logic[31:0] scrambled;
    scrambled = scramble(counter);
    ds_ready = scrambled[0];
  end

  always @(posedge clock) begin
    if (reset) begin
      counter <= 16'h7890;
      us_data <= 16'hXXXX;
      us_valid <= 0;
    end else begin
      if (us_valid && us_ready) begin
        us_data <= 16'hXXXX;
        us_valid <= 0;
      end
      if (!us_valid && (counter[2:0] == 0)) begin
        us_data <= counter;
        us_valid <= 1;
      end
      counter <= counter + 1;
    end
  end

  initial begin
    $dumpfile("pinwheel.vcd");
    $dumpvars(0, testbench);
    $display("================================================================================");
    $display("Hello World");

    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);


    $display("Done");
    $display("================================================================================");
    $finish();
  end

endmodule

//------------------------------------------------------------------------------
