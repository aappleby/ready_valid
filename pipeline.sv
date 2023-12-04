`timescale 1ns / 1ps

/*
us_valid ds_ready empty done

0 0 0 0 - keep working
0 1 0 0 - keep working
1 0 0 0 - keep working
1 1 0 0 - keep working

0 1 1 0 - hold because empty and no input
0 0 1 0 - hold because empty and no input
1 0 1 0 - move in to data
1 1 1 0 - move in to data

0 0 0 1 - hold because out not ready
1 0 0 1 - hold because out not ready
0 1 0 1 - move data to out
1 1 0 1 - move data to out, move in to data

0 0 1 1 - can't be both empty and done
0 1 1 1 - can't be both empty and done
1 0 1 1 - can't be both empty and done
1 1 1 1 - can't be both empty and done
*/

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

  //----------------------------------------

  function automatic logic[31:0] scramble(logic[31:0] x);
    x ^= seed;
    x ^= x >> 16;
    x *= 32'h85ebca6b;
    x ^= x >> 13;
    x *= 32'hc2b2ae35;
    x ^= x >> 16;
    scramble = x;
  endfunction

  logic[15:0] scrambled;
  assign scrambled = scramble(temp);

  //----------------------------------------

  logic[15:0] temp;
  logic       empty;

  logic[15:0] temp_next;
  logic       empty_next;

  always @* begin
    logic done;
    logic ds_move;
    logic us_move;
    done = temp < 16'h2000;

    ds_move    = !empty && done && ds_ready;
    us_move    = empty || ds_move;

    us_ready   = us_move;
    empty_next = us_move && !us_valid;
    ds_valid   = !empty && done;
    ds_data    = ds_valid ? temp : 16'hXXXX;

    if      (!empty && !done)      temp_next = scrambled;
    else if (us_ready && us_valid) temp_next = us_data;
    else                           temp_next = temp;


  end

  //----------------------------------------

  always @(posedge clock) begin
    if (reset) begin
      temp  <= 16'hXXXX;
      empty <= 1;
    end else begin
      temp  <= temp_next;
      empty <= empty_next;
    end
  end

  //----------------------------------------

endmodule

//------------------------------------------------------------------------------
