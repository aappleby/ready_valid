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
(
    input  logic      clock,
    input  logic      reset,

    input  logic[7:0] data,
    input  logic      data_valid,
    output logic      data_ready,

    output logic[7:0] result,
    output logic      result_valid,
    input  logic      result_ready
);

    logic[7:0] temp;
    logic[7:0] temp_next;
    logic      done;

    initial begin
    end

    always_comb begin
        temp_next = temp + 7;
        done = (temp_next[3:0] == 0);
        data_ready = done;
    end

    always @(posedge clock) begin
        if (reset) begin
            temp <= 0;
        end else begin
            if (done && data_valid) begin
                temp <= data;
            end else begin 
                temp <= temp_next;
            end
        end
    end


endmodule
