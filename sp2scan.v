`timescale 1ns / 1ps
module ps2scan(
input clk, //50Mʱ���ź�
input rst,  //��λ�ź�
input ps2k_clk,   //PS2�ӿ�ʱ���ź�
input ps2k_data,  //PS2�ӿ������ź�
output reg[7:0] temp_data,  //��ǰ�������ݼĴ���
output reg[3:0] num, //�����Ĵ���
output neg_ps2k_clk   // ps2k_clk�½��ر�־λ
);
//------------------------------------------
reg ps2k_clk_r0,ps2k_clk_r1,ps2k_clk_r2;  //ps2k_clk״̬�Ĵ���
//wire pos_ps2k_clk;     // ps2k_clk�����ر�־λ
always @ (posedge clk or negedge rst) begin
    if(!rst) begin
           ps2k_clk_r0 <= 1'b0;
           ps2k_clk_r1 <= 1'b0;
           ps2k_clk_r2 <= 1'b0;
       end
    else begin                         //����״̬�������˲�
           ps2k_clk_r0 <= ps2k_clk;
           ps2k_clk_r1 <= ps2k_clk_r0;
           ps2k_clk_r2 <= ps2k_clk_r1;
       end
end
assign neg_ps2k_clk = ~ps2k_clk_r1 & ps2k_clk_r2;    //�½���
//------------------------------------------


always @ (posedge clk or negedge rst) begin
    if(!rst) begin
           num <= 4'd0;
           temp_data <= 8'd0;
       end
    else if(neg_ps2k_clk) begin //��⵽ps2k_clk���½���
           case (num)
              4'd0:  num <= num+1'b1;
              4'd1:  begin
                         num <= num+1'b1;
                         temp_data[0] <= ps2k_data;  //bit0
                     end
              4'd2:  begin
                         num <= num+1'b1;
                         temp_data[1] <= ps2k_data;  //bit1
                     end
              4'd3:  begin
                         num <= num+1'b1;
                         temp_data[2] <= ps2k_data;  //bit2
                     end
              4'd4:  begin
                         num <= num+1'b1;
                         temp_data[3] <= ps2k_data;  //bit3
                     end
              4'd5:  begin
                         num <= num+1'b1;
                         temp_data[4] <= ps2k_data;  //bit4
                     end
              4'd6:  begin
                         num <= num+1'b1;
                         temp_data[5] <= ps2k_data;  //bit5
                     end
              4'd7:  begin
                         num <= num+1'b1;
                         temp_data[6] <= ps2k_data;  //bit6
                     end
              4'd8:  begin
                         num <= num+1'b1;
                         temp_data[7] <= ps2k_data;  //bit7
                     end
              4'd9:  begin
                         num <= num+1'b1;  //��żУ��λ����������
                     end
              4'd10: begin
                         num <= 4'd0;  // num����
                     end
              default: ;
              endcase
       end
end
endmodule
