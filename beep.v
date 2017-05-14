`timescale 1ns / 1ps
module beep_ma(           //��Ƶ�źŲ���ģ��
    input beat,
    input clk_5m,
    output reg beep,  //�����ź�
    input [3:0] med,
    input [3:0] low
    );

reg carrier;
reg [13:0] div;
reg [13:0] org;

always@(posedge clk_5m)
begin
    carrier <= (div == 16383);
    if(carrier)
	     div <= org;
	 else
	     div <= div + 1;
end

always@(posedge carrier)   //�����źŲ���
begin 
	 beep <= ~beep;
end

always@(posedge beat)
begin
    case({med,low})
	 
	 'b0000_0001:org <= 6826;     //����1
	 'b0000_0010:org <= 7871;     //����2
	 'b0000_0011:org <= 8798;     //����3
	 'b0000_0100:org <= 9224;     //����4
	 'b0000_0101:org <= 10005;    //����5
	 'b0000_0110:org <= 10701;    //����6
	 'b0000_0111:org <= 11321;    //����7
	 'b0001_0000:org <= 11606;    //����1
	 'b0010_0000:org <= 12126;    //����2
	 'b0011_0000:org <= 12591;    //����3
	 'b0100_0000:org <= 12804;    //����4
	 'b0101_0000:org <= 13194;    //����5
	 'b0110_0000:org <= 13542;    //����6
	 'b0111_0000:org <= 13852;    //����7
	 'b1000_0000:org <= 13994;    //����1
	 'b1001_0000:org <= 14255;    //����2
	 'b1010_0000:org <= 14487;    //����3
	 
	 'b0000_1000:org <= 10363;    //����6b
	 'b0000_1001:org <= 11873;    //����2b
	 'b0000_1010:org <= 12365;    //����2#
	 'b0000_1011:org <= 13005;    //����5b
	 'b0000_1100:org <= 13373;    //����5#
	 'b0000_1101:org <= 11873;    //����6#
	 
	 'b0000_0000:org <= 16383;    //��ֹ��
	 endcase
end

endmodule