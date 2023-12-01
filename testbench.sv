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


//`include "pipeline.sv"

module testbench();
  
    logic      clock;
    logic      reset;
    logic[7:0] data;
    logic      data_valid;
    logic      data_ready;
    
    initial clock = 0;
    always begin
        #5 clock = ~clock;
    end
    
    
    pipeline my_pipeline(.clock(clock), .reset(reset), .data(data), .data_valid(data_valid), .data_ready(data_ready));
    
    initial begin
        $display("Hello World\n");
        
        reset = 1;
        data = 0;
        data_valid = 0;
        
        #10
        
        reset = 0;
        
        #100
        
        $display("Done");
        $finish();
    end
    
endmodule
