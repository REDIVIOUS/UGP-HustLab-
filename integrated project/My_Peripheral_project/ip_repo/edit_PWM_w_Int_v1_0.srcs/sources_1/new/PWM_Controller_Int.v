`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/20 14:19:31
// Design Name: 
// Module Name: PWM_Controller_Int
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


module PWM_Controller_Int #(
    parameter integer period = 20)
    (
        input Clk,
        input [31:0] DutyCycle,
        input Reset,
        output reg [1:0] PWM_out,
        output reg Interrupt,
        output reg[period-1:0] count
    );
    always @(posedge Clk)
        if(!Reset)
            count <= 0;
        else
            count <= count + 1;
    always @(posedge Clk)
        if(count < DutyCycle)
            PWM_out <= 2'b01;
        else
            PWM_out <= 2'b10;
    always @(posedge Clk)
        if(!Reset)
            Interrupt <= 0;
        else if (DutyCycle > 990000)
            Interrupt <= 1;
        else 
            Interrupt <= 0;
endmodule
