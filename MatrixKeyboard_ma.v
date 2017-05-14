`timescale 1ns / 1ps
module MatrixKeyboardMain(
    input clk,
	 input rst_n,
	 input [3:0] row,               //�У�����
	 output reg [3:0] col,          //�У����
	 output reg [3:0] med,
	 output reg [3:0] low
);

reg [5:0] count;     //20ms�ӳ�
reg [2:0] state;     //״̬��־
reg key_flag;        //������־λ
reg clk_500k;
reg [3:0] col_reg;   //�Ĵ�ɨ����
reg [3:0] row_reg;   //�Ĵ�ɨ����

always@(posedge clk or negedge rst_n)   //50kHz�ź����ɣ�ȥ������
begin
    if(~rst_n)
	 begin
	     clk_500k <= 0;
		  count <= 0;
	 end
	 else
	 begin
	     if(count >= 50)
		  begin
		      clk_500k <= ~clk_500k;
				count <=0;
		  end
		  else 
		      count <= count + 1;
	 end
end


always@(posedge clk_500k or negedge rst_n)//ɨ���������
begin
    if(~rst_n)
	 begin
	     col <= 4'b0;
		  state <= 0;
	 end
	 else
	 begin
	     case(state)
		  3'd0:
		  begin
		      col[3:0] <= 4'b0000;
				key_flag <= 1'b0;
				if(row[3:0]!=4'b1111)    //���м����£�ɨ���һ��
				begin
				    state <= 1;
					 col[3:0] <= 4'b1110;
				end
				else 
				    state <= 0;
		  end
		  3'd1:
		  begin
				if(row[3:0]!=4'b1111)    //���м����£�ɨ���һ��
				    state <= 5;          //�ж��Ƿ��ǵ�һ��
				else
            begin				
			       state <= 2;
					 col[3:0] <= 4'b1101;
		      end
		  end
		  3'd2:
		  begin
				if(row[3:0]!=4'b1111)    //���м����£�ɨ��ڶ���
				    state <= 5;          //�ж��Ƿ��ǵڶ���
				else
            begin				
			       state <= 3;
					 col[3:0] <= 4'b1011;
		      end
		  end
		  3'd3:
		  begin
				if(row[3:0]!=4'b1111)    //���м����£�ɨ�������
				    state <= 5;          //�ж��Ƿ��ǵ�����
				else
            begin				
			       state <= 4;
					 col[3:0] <= 4'b0111;
		      end
		  end
		  3'd4:
		  begin
				if(row[3:0]!=4'b1111)    //���м����£�ɨ���һ��
				    state <= 5;          //�ж��Ƿ��ǵ�һ��
				else	
			       state <= 0;
		  end
		  3'd5:
		  begin
		      if(row[3:0]!=4'b1111)
				begin
				col_reg <= col;
				row_reg <= row;    //����
				state <= 5;
				key_flag <= 1'b1;  //�м�����
				end
				else
				state <=0;
		  end
		  endcase
	 end
end

always@(posedge clk_500k )
begin
    if(key_flag == 1'b1)
	 begin
	     case({col_reg,row_reg})
		  8'b1110_1110:{med,low} <= 8'b0000_0100;   //����4
		  8'b1110_1101:{med,low} <= 8'b0000_0101;   //����5
		  8'b1110_1011:{med,low} <= 8'b0100_0000;   //����4
		  8'b1110_0111:{med,low} <= 8'b0101_0000;   //����5                                   
		  8'b1101_1110:{med,low} <= 8'b0000_0011;   //����3
		  8'b1101_1101:{med,low} <= 8'b0000_0110;   //����6
		  8'b1101_1011:{med,low} <= 8'b0011_0000;   //����3
		  
		  8'b1011_1110:{med,low} <= 8'b0000_0010;   //����2
		  8'b1011_1101:{med,low} <= 8'b0000_0111;   //����7
		  8'b1011_1011:{med,low} <= 8'b0010_0000;   //����2
		  8'b1011_0111:{med,low} <= 8'b0111_0000;   //����7
		  8'b0111_1110:{med,low} <= 8'b0000_0001;   //����1                                  
		  8'b1101_0111:{med,low} <= 8'b0110_0000;   //����6
		  8'b0111_1011:{med,low} <= 8'b0001_0000;   //����1
		  default: {med,low} <= 8'b0000_0000;
		 endcase
	end  
end
endmodule


