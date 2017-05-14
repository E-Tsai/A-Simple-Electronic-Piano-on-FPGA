`timescale 1ns / 1ps

module beat(                           //���Ĳ���ģ��  
    input rst_n,
    input clk,
    output reg beat
    );
//clk = 50MHz, div into 4Hz
//1 pause/ 12 5000 000 clocks
reg [24:0] cnt = 25'h0;

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)                           //�ػ�ʱ
	     cnt <= 25'h0;
	 else if(cnt == 25'd12_499_999)       //����ʱ
	     cnt <= 25'h0;
	 else 
	     cnt <= cnt + 25'h1;
end

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)
	     beat <= 1'b0;
	 else if(cnt == 25'd12_499_999)
	     beat <=1'b1;
	 else
	     beat <= 1'b0;                //ÿ1/4��һ��������
end 

endmodule
