`timescale 1ns / 1ps
module ShowDiv(                           //50MHz��2Hz��Ƶ
    input clk,                        //50MHz��ʱ��
    input rst_n,                      //��ʼ
    output reg cnt_en                 //�����ź�
    );
	 
 	 reg [24:0] cnt_div;               //50MHz��ʱ��

always@(posedge clk or negedge rst_n) //clk��������Ч��rst_n�½�����Ч
     begin
         if(~rst_n)
             cnt_div <= 25'h0;
         else if(cnt_div == 25'd24_999_999)
             cnt_div <= 25'h0;
        else
            cnt_div <= cnt_div + 25'h1;
    end

always@(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
             cnt_en <= 1'b0;
         else if(cnt_div == 25'd24_999_999)
             cnt_en <= 1'b1;
        else
            cnt_en <= 1'b0;
    end

endmodule
