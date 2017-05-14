`timescale 1ns / 1ps
module ShowCnt(
    input clk,
    input rst_n,
    input cnt_en,
    output reg [7:0] cnt_data
    );
	 
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n )                  //����
	     cnt_data <= 8'h90;
    else if(cnt_en)
        begin
	             if(cnt_data == 8'h99)
		              cnt_data <= 8'h00;   //������99�󣬴�0��ʼ
                else if(cnt_data[3:0] == 4'h9)
		              cnt_data <= cnt_data + 8'h7;//��λΪ9����λ
                else
			           cnt_data <= cnt_data + 8'h1;        
	     end
 end

endmodule