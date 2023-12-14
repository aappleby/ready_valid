`timescale 1ns / 1ps

//------------------------------------------------------------------------------

module pipeline
#(parameter seed = 32'h00001234)
(
  input  logic       clock,
  input  logic       reset,

  input  logic[15:0] us_data,
  input  logic       us_valid,
  output logic       us_ready,

  output logic[15:0] ds_data,
  output logic       ds_valid,
  input  logic       ds_ready
);

  logic[15:0] work;
  logic[15:0] work_next;
  logic       work_done;
  logic       empty;

  //----------------------------------------

  function automatic logic[15:0] scramble(logic[15:0] x);
    x ^= seed;
    x ^= x >> 8;
    x *= 32'h85ebca6b;
    x ^= x >> 5;
    x *= 32'hc2b2ae35;
    x ^= x >> 8;
    scramble = x;
  endfunction

  //----------------------------------------

  always_comb begin
    work_next = scramble(work);
    work_done = work_next < 16'h2000;

    ds_valid = !empty && work_done;
    ds_data  = work_next;

    us_ready = empty || (work_done && ds_ready);
  end

  //----------------------------------------

  always_ff @(posedge clock) begin
    if (reset) begin
      empty <= 1;
    end else begin
      if (us_ready && us_valid) work <= us_data;
      if (!empty && !work_done) work <= work_next;
      empty <= us_ready && !us_valid;

      // this makes it easer to see where 'empty' propagates through
      if (us_ready && !us_valid) work <= 16'hXXXX;
    end
  end

  //----------------------------------------

endmodule

//------------------------------------------------------------------------------
