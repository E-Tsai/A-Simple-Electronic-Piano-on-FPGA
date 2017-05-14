`timescale 1ns / 1ps

module top(
    input         clk,       //50MHzʱ��
    input         rst_n,     //������
    output  [3:0] sel,       //��ʱ����
    output  [7:0] data,      //�������ʾ������
	 output        beep_ma,   //��������Ƶ�ź�
	 output        beep_ch,   //��������Ƶ�ź�
	 input   [1:0] func,      //����ѡ�񣺵���򲥷�
	 
	 input   [3:0] row_ma,    //����������
	 output  [3:0] col_ma,    //���������
	 input   [3:0] row_ch,    //����������
	 output  [3:0] col_ch,    //���������
	 
	 output  [7:0] L,         //��ˮ��

    input         ps2k_clk,  //����ɨ��ʱ��
    input         ps2k_data  //����ɨ����
);

    wire    [7:0] HI_data;   //�������ʾ������
	 wire    [7:0] TONE_data; //�������ʾ������
	 wire          switch;    //������ʱ����         --
    wire          cnt_en;    //������ʱ����            >  �������
    wire    [7:0] cnt_data;  //������ʱ����         --
	 wire          beat;      //���ģ�ÿ��1/4����
	 reg           cnt_5m;    //�������ɸ���Ƶ��

	 wire    [3:0] med_ma0;     //����������do-ti��С��������
	 wire    [3:0] low_ma0;     //����������do-ti
	 wire    [3:0] med_ch0;     //����������do-ti
	 wire    [3:0] low_ch0;     //����������do-ti


	 wire    [3:0] med_ma;     //����������do-ti����������߲�������
	 wire    [3:0] low_ma;     //����������do-ti
	 wire    [3:0] med_ch;     //����������do-ti
	 wire    [3:0] low_ch;     //����������do-ti

	 wire    [3:0] med_ma1;     //����������do-ti��У��
	 wire    [3:0] low_ma1;     //����������do-ti

	 wire    [3:0] med_ma2;     //����������do-ti��������
	 wire    [3:0] low_ma2;     //����������do-ti
	 wire    [3:0] med_ch2;     //����������do-ti
	 wire    [3:0] low_ch2;     //����������do-ti
	 
	 wire    [3:0] med_ma3;     //����������do-ti��ps2��������
	 wire    [3:0] low_ma3;     //����������do-ti
	 wire    [3:0] med_ch3;     //����������do-ti
	 wire    [3:0] low_ch3;     //����������do-ti
	 
	  
    wire    [15:0] data_ps2;
    wire    [7:0]  temp_data;
    wire    [3:0]  num;
    wire           press;
    wire           loose;
    wire           neg_ps2k_clk;
    wire           [2:0]next_state;
	 



    Hello     u_Hello(        //�����ʺ�ģ��
    .clk(clk),
    .rst_n(rst_n),
	 .sel(sel),
    .data(HI_data)
    );


    ToneFromKB_main u_ToneFromKB_main(  //����ת����ģ��
    .clk(clk), 
    .rst_n(rst_n), 
    .data(data_ps2),
	 .low_ma(low_ma3),
	 .med_ma(med_ma3)
    );

    ToneFromKB_Chorus u_ToneFromKB_Chorus(  //����ת����ģ��
    .clk(clk), 
    .rst_n(rst_n), 
    .data(data_ps2),
	 .low_ch(low_ch3),
	 .med_ch(mad_ch3)
    );
	 
	 
    ps2scan u_ps2scan (  //ps2����ɨ��
    .clk(clk), 
    .rst(rst_n), 
    .ps2k_clk(ps2k_clk), 
    .ps2k_data(ps2k_data), 
    .temp_data(temp_data),
	 .num(num),
	 .neg_ps2k_clk(neg_ps2k_clk)
    );
	 
     PS2_FSM u_FSM (  //ps2����ɨ��״̬��
    .temp_data(temp_data), 
    .clk(clk), 
    .rst(rst_n), 
    .num(num),
	 .neg_ps2k_clk(neg_ps2k_clk),
    .data(data_ps2), 
    .press(press), 
    .loose(loose),
	 .next_state(curr_state)
    );
	 
	 MatrixKeyboardMain      u_MatrixKeyboardMain(   //�������ּ���ɨ��  
    .clk(clk),
	 .rst_n(rst_n),
	 .row(row_ma),
	 .col(col_ma),   
	 .med(med_ma0),
	 .low(low_ma0)
    );
	 
	 
	 MatirxKeyboardChorus      u_MatirxKeyboardChorus(   //�������ּ���ɨ��
    .clk(clk),
	 .rst_n(rst_n),
	 .row(row_ch),
	 .col(col_ch),   
	 .med(med_ch0),
	 .low(low_ch0)
    );
	 
	 
    beat       u_beat(       //���Ĳ���ģ��  
    .rst_n(rst_n),
    .clk(clk),
    .beat(beat)
    );
	 
	 
	 SongHz     u_SongHz(    //�������ɸ���Ƶ��ģ��
	 .clk(clk),
	 .rst_n(rst_n),
	 .clk_5m(clk_5m)
	 );
	 

	 
	 beep_ma       u_beep_ma(      //������Ƶ�źŲ���ģ��
	 .beat(beat),
    .clk_5m(clk_5m),
    .beep(beep_ma),  
    .med(med_ma),
    .low(low_ma)
	 );
	 
	
	 
	 beep_ch       u_beep_ch(      //������Ƶ�źŲ���ģ��
	 .beat(beat),
    .clk_5m(clk_5m),
    .beep(beep_ch),  
    .med(med_ch),
    .low(low_ch)
	 );
	 
	 
    SchoolSong  u_SchoolSong(    //����У���ģ��
	 .func(func),
    .beat(beat),
    .clk_5m(clk_5m),
    .med(med_ma1),
    .low(low_ma1)
    );
	 
	 
	 OdeAnDieFreude  u_OdeAnDieFreude(  //������
    .beat(beat),
    .clk_5m(clk_5m),
    .med_ma(med_ma2),
    .low_ma(low_ma2),
	 .med_ch(med_ch2),
    .low_ch(low_ch2)
    );
	 
    WaterLight  u_WaterLight(       //��ˮ��ģ��
    .beat(beat),
    .func(func),
    .L(L),
    .rst_n(rst_n)
    );	 
	 
	 CodeCh  u_CodeCh(          //ѡ����ʾHi��������
	 .data(data),
	 .clk(clk),
	 .rst_n(rst_n),
	 .HI_data(HI_data),
	 .TONE_data(TONE_data),
	 .beat(beat)
	 );
	 
	 
	 Choose    u_Choose(          //ѡ��ģ�飺�ĸ����������������������ģ��
    .func(func),
	 .clk(clk),
    .med_ma1(med_ma1),
    .low_ma1(low_ma1),
	 
    .low_ma(low_ma),
	 .med_ma(med_ma),
	 .med_ch(med_ch),
    .low_ch(low_ch),
	 
	 .med_ma2(med_ma2),
	 .low_ma2(low_ma2),
	 .med_ch2(med_ch2),
	 .low_ch2(low_ch2),
	
    .med_ma3(med_ma3),
	 .low_ma3(low_ma3),
	 .med_ch3(med_ch3),
	 .low_ch3(low_ch3),	
 
	 .med_ch0(med_ch0),
	 .med_ma0(med_ma0),
    .low_ma0(low_ma0),
    .low_ch0(low_ch0)
    );
	 


    //�������ʾ���֣�
    ShowDiv    u_ShowDiv(
    .clk       (clk    ),
    .rst_n     (rst_n    ),
    .cnt_en    (cnt_en )
    );
	 
	 ShowSwitch     u_ShowSwitch(
	 .clk       (clk     ),
	 .switch    (switch  )
	 );
	 
	 ShowCnt        u_ShowCnt(
	 .clk       (clk    ),
    .rst_n     (rst_n    ),
    .cnt_en    (cnt_en ),
	 .cnt_data  (cnt_data )
	 );


    ShowCode    u_ShowCode(        //ֻ��ʾ����������
	 .switch    (switch         ),
    .med       (med_ma    ),
	 .low       (low_ma    ),
    .sel       (sel    ),
    .data      (TONE_data    )
    );	 
	 
	 
 
endmodule