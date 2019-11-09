`define TimeExpire_KEY 25'b00010000000000000000000000
`define TimeExpire_clock 32'd50000000

module hw(clk, rst, keypadRow, keypadCol,row, col_l, col_r,key,Ledout,State,sec1,sec2,min1,min2,hour1,hour2,switch1,switch2,switch3, vga_hs, vga_vs, vga_r, vga_g, vga_b);

//VGA
output vga_hs, vga_vs;
output [3:0] vga_r, vga_g, vga_b;
reg [1:0]judge;
//reg vga_hs, vga_vs;
//reg [3:0] vga_r, vga_g, vga_b;




input clk,rst;

input [3:0]key;
input State;
input switch1;
input switch2;
input switch3;
output [7:0]Ledout;

output [7:0]row;
output [7:0]col_l;
output [7:0]col_r;

reg [7:0]row;
reg [7:0]col_l;
reg [7:0]col_r;

reg [3:0]area;
reg [2:0]tmp;
reg [2:0]a;
reg [15:0]area0;
reg [15:0]area1;
reg [15:0]area2;
reg [15:0]area3;
reg [15:0]area4;
reg [15:0]area5;
reg [15:0]area6;
reg [15:0]area7;
reg [3:0]x;
reg [31:0]con;
reg [31:0]con2;
reg endstate;

reg [15:0]b0;
reg [15:0]b1;
reg [15:0]b2;
reg [15:0]b3;
reg [15:0]b4;
reg [15:0]b5;
reg [15:0]b6;
reg [15:0]b7;

reg [15:0]s0;
reg [15:0]s1;
reg [15:0]s2;
reg [15:0]s3;
reg [15:0]s4;
reg [15:0]s5;
reg [15:0]s6;
reg [15:0]s7;
reg shine;

//炸彈區，我照網路上的方法無法設亂數QQ
reg [2:0]bomb_a_area;
reg [3:0]bomb_a_num;
reg [2:0]bomb_b_area;
reg [3:0]bomb_b_num;
reg [2:0]bomb_c_area;
reg [3:0]bomb_c_num;
reg [2:0]bomb_d_area;
reg [3:0]bomb_d_num;
reg [2:0]bomb_e_area;
reg [3:0]bomb_e_num;
reg [2:0]bomb_f_area;
reg [3:0]bomb_f_num;
reg [2:0]bomb_g_area;
reg [3:0]bomb_g_num;
reg [2:0]bomb_h_area;
reg [3:0]bomb_h_num;
reg [2:0]bomb_i_area;
reg [3:0]bomb_i_num;
reg [2:0]bomb_j_area;
reg [3:0]bomb_j_num;
reg [2:0]bomb_k_area;
reg [3:0]bomb_k_num;
reg [2:0]bomb_l_area;
reg [3:0]bomb_l_num;
//clock
output [6:0] sec1;
output [6:0] sec2;
output [6:0] min1; 
output [6:0] min2;
output [6:0] hour1;
output [6:0] hour2;
reg [6:0] tmps;
reg [6:0] tmpm;
reg [6:0] tmph;
reg [31:0] count;
//clock
always@(*)
begin
bomb_a_area=0;
bomb_a_num=0;
bomb_b_area=7;
bomb_b_num=15;
bomb_c_area=3;
bomb_c_num=11;
bomb_d_area=4;
bomb_d_num=9;
bomb_e_area=6;
bomb_e_num=15;
bomb_f_area=7;
bomb_f_num=13;
bomb_g_area=7;
bomb_g_num=10;
bomb_h_area=2;
bomb_h_num=2;
bomb_i_area=1;
bomb_i_num=3;
bomb_j_area=1;
bomb_j_num=4;
bomb_k_area=3;
bomb_k_num=3;
bomb_l_area=0;
bomb_l_num=2;
end
//


input [3:0]keypadCol;
output [3:0]keypadRow;	
reg [3:0]keypadRow;
reg [3:0]keypadBuf;
reg [24:0]keypadDelay;

reg [24:0]delayButton;
reg [2:0]flagButton;

//area區，因為area一直出錯所以我就放在一個module
always@(posedge clk)
begin
case (State)

1'b1://遊戲中
begin
	if(area==15) area=area+1+tmp;
	else;
	if(!rst)//若遊戲進行中且reset
	begin
		flagButton = 3'b000;
		delayButton = 25'd0;
		area=0;
	end
	
	else
	begin

			if((!key[0])&&(!flagButton)) flagButton = 3'b001;
			else if((!key[1])&&(!flagButton)) flagButton = 3'b010;
			else if((!key[3])&&(!flagButton)) flagButton = 3'b011;
			else if((!key[2])&&(!flagButton)) flagButton = 3'b100;
			
			else if(flagButton)
			begin
				delayButton = delayButton + 1'b1;
				
				if(delayButton == 25'b1010000000000000000000000)
				begin//若沒有reset 可以正常移動
			case(flagButton)
			
				3'b001://往右
				begin
				flagButton = 3'b000;
				delayButton = 25'd0;
				if(area==3||area==7)//若到最右邊邊界則不做事否則往右
				;
				else	area=area+1;
				end

				3'b010://左
				begin
				flagButton = 3'b000;
				delayButton = 25'd0;
				if(area==0||area==4)	;
	
				else	area=area-1;	
				end

				3'b011://上
				begin
				flagButton = 3'b000;
				delayButton = 25'd0;
				if(area<4)//0 1 2 3 不往上
				;
				else	area=area-4;
				end

				3'b100://下
				begin
				flagButton = 3'b000;
				delayButton = 25'd0;
				if(area>3)//4 5 6 7 不往下
				;
				else
				area=area+4;
				end
			endcase
			
			end
			
			end
			
			else ;
	end
	
	
	
end


1'b0://遊戲開始前
begin
	if(row==0)area=0;
	else
	begin
			case(area)
				0:tmp=0;
				1:tmp=1;
				2:tmp=2;
				3:tmp=3;
				4:tmp=4;
				5:tmp=5;
				6:tmp=6;
				7:tmp=7;
			endcase
			area=15;
	end
end

default:	//遊戲暫停或遊戲結束只有reset可用
		begin if(rst==0)area=0;	end
				
endcase

end
//





Led(State,area,Ledout,tmp,endstate);
TIMECLOCK(clk,rst,sec1,sec2,min1,min2,hour1,hour2,State,endstate);
VGA(.clk(clk), .rst(rst), .vga_hs(vga_hs), .vga_vs(vga_vs), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b), .endstate(endstate), .judge(judge));


//keypad輸入，keypadBuf是keypad讀到的數字，但keypad輸入讀到的數字很奇怪
//所以我讓他按的時候對照燈是對的，但是數字是亂的	
always@(posedge clk)
begin
	if(!rst)
	begin
		keypadRow = 4'b1110;
		keypadBuf = 4'b0000;
		keypadDelay = 25'd0;
		area0=0;area1=0;area2=0;area3=0;
		area4=0;area5=0;area6=0;area7=0;
		s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
		endstate=0;
	end
	else
	begin
		if(keypadDelay == `TimeExpire_KEY)
		begin
			keypadDelay = 25'd0;
			case({keypadRow, keypadCol})
				8'b1110_1110 : keypadBuf = 4'hc;
				8'b1110_1101 : keypadBuf = 4'hd;
				8'b1110_1011 : keypadBuf = 4'he;
				8'b1110_0111 : keypadBuf = 4'hf;
				8'b1101_1110 : keypadBuf = 4'h8;
				8'b1101_1101 : keypadBuf = 4'h9;
				8'b1101_1011 : keypadBuf = 4'ha;
				8'b1101_0111 : keypadBuf = 4'hb;
				8'b1011_1110 : keypadBuf = 4'h4;
				8'b1011_1101 : keypadBuf = 4'h5;
				8'b1011_1011 : keypadBuf = 4'h6;
				8'b1011_0111 : keypadBuf = 4'h7;
				8'b0111_1110 : keypadBuf = 4'h0;
				8'b0111_1101 : keypadBuf = 4'h1;
				8'b0111_1011 : keypadBuf = 4'h2;
				8'b0111_0111 : keypadBuf = 4'h3;
				default     : keypadBuf = keypadBuf;
				endcase
				
				
			if(switch2==1&&switch1==0&&switch3==0)
				begin
				if(keypadCol!=4'b1111)
					begin
					case(area)
					0:begin if(area0[keypadBuf]==1) judge=1;else judge=2;area0[keypadBuf]=1;end
					1:begin if(area1[keypadBuf]==1) judge=1;else judge=2;area1[keypadBuf]=1;end
					2:begin if(area2[keypadBuf]==1) judge=1;else judge=2;area2[keypadBuf]=1;end
					3:begin if(area3[keypadBuf]==1) judge=1;else judge=2;area3[keypadBuf]=1;end
					4:begin if(area4[keypadBuf]==1) judge=1;else judge=2; area4[keypadBuf]=1;end
					5:begin if(area5[keypadBuf]==1) judge=1;else judge=2; area5[keypadBuf]=1;end
					6:begin if(area6[keypadBuf]==1) judge=1;else judge=2; area6[keypadBuf]=1;end
					7:begin if(area7[keypadBuf]==1) judge=1;else judge=2; area7[keypadBuf]=1;end
					endcase
					if(area==bomb_a_area && bomb_a_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_b_area && bomb_b_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_c_area && bomb_c_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_d_area && bomb_d_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_e_area && bomb_e_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_f_area && bomb_f_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_g_area && bomb_g_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_h_area && bomb_h_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_i_area && bomb_i_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_j_area && bomb_j_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_k_area && bomb_k_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if(area==bomb_l_area && bomb_l_num==keypadBuf)
						begin
						area0=0;area1=0;area2=0;area3=0;
						area4=0;area5=0;area6=0;area7=0;
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						endstate=1;
						end
					else if((area0+16'b0000000000000101==16'hffff)&&
							  (area1+16'b0000000000011000==16'hffff)&&
							  (area2+16'b0000000000000100==16'hffff)&&
							  (area3+16'b0000100000001000==16'hffff)&&
							  (area4+16'b0000001000000000==16'hffff)&&
						  	  (area5+16'b0000000000000000==16'hffff)&&
							  (area6+16'b1000000000000000==16'hffff)&&
							  (area7+16'b1010010000000000==16'hffff))
						begin
						s0=0;s1=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;
						{area0[3:0],area1[3:0],area2[3:0],area3[3:0]}=			16'b0000000000011111;
						{area0[7:4],area1[7:4],area2[7:4],area3[7:4]}=			16'b0000000000100000;
						{area0[11:8],area1[11:8],area2[11:8],area3[11:8]}=		16'b0000000001000000;
						{area0[15:12],area1[15:12],area2[15:12],area3[15:12]}=		16'b1000000010000000;
						{area4[3:0],area5[3:0],area6[3:0],area7[3:0]}=			16'b0100000100000000;
						{area4[7:4],area5[7:4],area6[7:4],area7[7:4]}=			16'b0010001000000000;
						{area4[11:8],area5[11:8],area6[11:8],area7[11:8]}=		16'b0001010000000000;
						{area4[15:12],area5[15:12],area6[15:12],area7[15:12]}=		16'b0000100000000000;
						
						
						endstate=1;
						end
					end
				end
			else if(switch1==1&&switch2==0&&switch3==0)
				begin
					if(keypadCol!=4'b1111)
					begin
					case(area)
					0:s0[keypadBuf]=1;
					1:s1[keypadBuf]=1;
					2:s2[keypadBuf]=1;
					3:s3[keypadBuf]=1;
					4:s4[keypadBuf]=1;
					5:s5[keypadBuf]=1;
					6:s6[keypadBuf]=1;
					7:s7[keypadBuf]=1;
					endcase
					end
					else 
					begin 
					end
				end
			else if(switch3==1&&switch2==0&&switch1==0)
				begin
					if(keypadCol!=4'b1111)
					begin
					case(area)
					0:s0[keypadBuf]=0;
					1:s1[keypadBuf]=0;
					2:s2[keypadBuf]=0;
					3:s3[keypadBuf]=0;
					4:s4[keypadBuf]=0;
					5:s5[keypadBuf]=0;
					6:s6[keypadBuf]=0;
					7:s7[keypadBuf]=0;
					endcase
					end
					else 
					begin 
					end
				end
			else begin end
			case(keypadRow)
				4'b1110 : keypadRow = 4'b1101;
				4'b1101 : keypadRow = 4'b1011;
				4'b1011 : keypadRow = 4'b0111;
				4'b0111 : keypadRow = 4'b1110;
				default: keypadRow = 4'b1110;
			endcase
		end
		else
			keypadDelay = keypadDelay + 1'b1;
	end
end

//點亮不是炸彈的燈

always @(posedge clk or posedge !rst)
	begin
	if(!rst)
		begin 
		shine=0;
		end
	else 
		begin
		if(con2==`TimeExpire_clock)
			begin
			con2=0;
			shine=(shine)?0:1;
			end
		else
			begin
			con2=con2+1'b1;
			end
		end		
	end



always @(posedge clk or posedge !rst)
	begin
	if(!rst)
		begin 
		con=2'd0;
		x=0;
		end
	else 
		begin
		if(con==100000)
			begin
			con=2'd0;
			x=x+1;
			if(x==8)
				begin
				x=0;
				end
			else
				begin
				end
			end
		else
			begin
			con=con+2'd1;
			end
		end		
	end

always @(x)
	begin
		b0=area0|s0;b1=area1|s1;b2=area2|s2;b3=area3|s3;
		b4=area4|s4;b5=area5|s5;b6=area6|s6;b7=area7|s7;
	if(shine)
		begin
		case(x)
			0:begin row=8'b01111111;col_l={b0[3:0],b1[3:0]};col_r={b2[3:0],b3[3:0]}; end
			1:begin row=8'b10111111;col_l={b0[7:4],b1[7:4]};col_r={b2[7:4],b3[7:4]}; end
			2:begin row=8'b11011111;col_l={b0[11:8],b1[11:8]};col_r={b2[11:8],b3[11:8]}; end
			3:begin row=8'b11101111;col_l={b0[15:12],b1[15:12]};col_r={b2[15:12],b3[15:12]}; end
			4:begin row=8'b11110111;col_l={b4[3:0],b5[3:0]};col_r={b6[3:0],b7[3:0]}; end
			5:begin row=8'b11111011;col_l={b4[7:4],b5[7:4]};col_r={b6[7:4],b7[7:4]}; end
			6:begin row=8'b11111101;col_l={b4[11:8],b5[11:8]};col_r={b6[11:8],b7[11:8]}; end
			7:begin row=8'b11111110;col_l={b4[15:12],b5[15:12]};col_r={b6[15:12],b7[15:12]}; end
			endcase
		end
	else
		begin
		case(x)
			0:begin row=8'b01111111;col_l={area0[3:0],area1[3:0]};col_r={area2[3:0],area3[3:0]}; end
			1:begin row=8'b10111111;col_l={area0[7:4],area1[7:4]};col_r={area2[7:4],area3[7:4]}; end
			2:begin row=8'b11011111;col_l={area0[11:8],area1[11:8]};col_r={area2[11:8],area3[11:8]}; end
			3:begin row=8'b11101111;col_l={area0[15:12],area1[15:12]};col_r={area2[15:12],area3[15:12]}; end
			4:begin row=8'b11110111;col_l={area4[3:0],area5[3:0]};col_r={area6[3:0],area7[3:0]}; end
			5:begin row=8'b11111011;col_l={area4[7:4],area5[7:4]};col_r={area6[7:4],area7[7:4]}; end
			6:begin row=8'b11111101;col_l={area4[11:8],area5[11:8]};col_r={area6[11:8],area7[11:8]}; end
			7:begin row=8'b11111110;col_l={area4[15:12],area5[15:12]};col_r={area6[15:12],area7[15:12]}; end
		endcase
		end
	end

endmodule


module Led(State,area,Ledout,tmp,endstate);
input endstate;
input State;
input [3:0]area;
input [2:0]tmp;
output [7:0]Ledout;
reg [7:0]Ledout;
always@(area or State or tmp)//area改變或是遊戲結束時需要改變LED燈顯示
begin
case(endstate)
2'b1://遊戲結束全亮
	begin
	Ledout=8'b11111111;
	end
	
default://其他狀況根據area決定誰亮
	begin
		case(area)
			0:Ledout=8'b10000000;//Ledout[7]要接到電路板led R9，Ledout[6]接led R8
			1:Ledout=8'b01000000;
			2:Ledout=8'b00100000;
			3:Ledout=8'b00010000;
			4:Ledout=8'b00001000;
			5:Ledout=8'b00000100;
			6:Ledout=8'b00000010;
			7:Ledout=8'b00000001;
			default:
			begin
				case(tmp)
					0:Ledout=8'b10000000;//Ledout[7]要接到電路板led R9，Ledout[6]接led R8
					1:Ledout=8'b01000000;
					2:Ledout=8'b00100000;
					3:Ledout=8'b00010000;
					4:Ledout=8'b00001000;
					5:Ledout=8'b00000100;
					6:Ledout=8'b00000010;
					7:Ledout=8'b00000001;
				endcase
			end
		endcase
		
	end
endcase		
end
endmodule



module TIMECLOCK(clk,reset,sec1,sec2,min1,min2,hour1,hour2,state,endstate);
input endstate;
input reset;
input clk;
input state;
output [6:0] sec1;
output [6:0] sec2;
output [6:0] min1; 
output [6:0] min2;
output [6:0] hour1;
output [6:0] hour2;
reg [6:0] tmps;
reg [6:0] tmpm;
reg [6:0] tmph;
reg [31:0] count;

always@(posedge clk)
begin
	if(reset==0)
	begin
		tmps=0;
		tmpm=0;
		tmph=0;
		count=32'd0;
	end
	else if(endstate==1)
	begin
		tmps=88;
		tmpm=88;
		tmph=88;
	end
	else if(!state)
	begin
		;
	end
	else 
	begin
//		case (state)
//		1'b1:
//		begin
if(endstate==0)
begin
			if(count==`TimeExpire_clock)
			begin
				tmps=tmps+1;
				count=32'd0;
				if(tmps==60)
				begin
					tmps=0;
					tmpm=tmpm+1;
						if(tmpm==60)
						begin
							tmpm=0;
							tmph=tmph+1;
						end
						else
							tmph=tmph;
				end
				else
					tmpm=tmpm;
			end
			else
				count=count+32'd1;
//		end
//		1'b0:
//		begin
//		;
//		end
//		endcase
	end
		
	end
end
	sevendisplay(.tmp(tmps%10),.out(sec1));
	sevendisplay(.tmp(tmps/10),.out(sec2));
	sevendisplay(.tmp(tmpm%10),.out(min1));
	sevendisplay(.tmp(tmpm/10),.out(min2));
	sevendisplay(.tmp(tmph%10),.out(hour1));
	sevendisplay(.tmp(tmph/10),.out(hour2));
endmodule

module sevendisplay(tmp,out);
input[3:0]tmp;
output [6:0]out;
reg[6:0]out;
always@(tmp)
	begin
	case(tmp)
		0:out=7'b1000000;
		1:out=7'b1111001;
		2:out=7'b0100100;
		3:out=7'b0110000;
		4:out=7'b0011001;
		5:out=7'b0010010;
		6:out=7'b0000010;
		7:out=7'b1111000;
		8:out=7'b0000000;
		9:out=7'b0010000;
	endcase
end
endmodule




module VGA(clk, rst, vga_hs, vga_vs, vga_r, vga_g, vga_b, endstate, judge);

input clk, rst,endstate;
input [1:0] judge;
output vga_hs, vga_vs;
output [3:0] vga_r, vga_g, vga_b;

reg vga_hs, vga_vs;
reg [3:0] vga_r, vga_g, vga_b;

reg [10:0] counths;
reg [9:0] countvs;
reg [9:0] p_h, p_v;
reg valid;

reg [3:0]countVGA;

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		counths <= 11'd0;
		countvs <= 10'd0;
	end
	else
	begin
		if((counths == 11'd1600))
		begin counths <=11'd0; countVGA=0; end
		else
		begin 
		if(counths ==288)countVGA=1;
		if(counths ==608)countVGA=2;
		if(counths ==928)countVGA=3;
		if(counths ==1248)countVGA=4;
		counths <= counths + 16'd1;
		
		end
		
		
		countvs <= (countvs == 10'd525) ? 10'd0 : (counths == 11'd1600) ? countvs + 10'd1 : countvs; 
	end
end

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		vga_hs <= 1'b0;
		vga_vs <= 1'b0;
		valid <= 1'b0;
	end
	else
	begin
		vga_hs <= (counths < 11'd192 || counths > 11'd1568) ? 1'b0 : 1'b1;
		vga_vs <= (countvs < 10'd2 || countvs > 10'd515) ? 1'b0 : 1'b1;
		valid <= (countvs > 10'd35 && countvs < 10'd516 && counths > 11'd288 && counths < 11'd1569) ? 1'b1 : 1'b0;
	end

end

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		vga_r <= 4'd0;
		vga_g <= 4'd0;
		vga_b <= 4'd0;
	end
	else
	begin
			if(valid)
			begin
				if(judge==1&&endstate==0)
				begin
						if(countvs < 10'd155)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd15; end
							
						end

						else if(countvs < 10'd275)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd15; end
						end

						else if(countvs < 10'd395)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd15; end
						end

						else
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd15; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd15; end
						end
					end
			
				else if(judge==2&& endstate==0)	
				begin
						if(countvs < 10'd155)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd0; end
							
						end

						else if(countvs < 10'd275)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd15;	vga_b <= 4'd0; end
						end

						else if(countvs < 10'd395)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd15;	vga_b <= 4'd0; end
						end

						else
						begin

							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd15;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd0; end
						end


				end
				else if(endstate==1)
				begin
						if(countvs < 10'd155)
						begin
							if(countVGA==1)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd15; vga_g <= 4'd0;	vga_b <= 4'd0; end
							
						end

						else if(countvs < 10'd275)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd0; end
						end

						else if(countvs < 10'd395)
						begin
							if(countVGA==1)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd0; vga_g <= 4'd0;	vga_b <= 4'd0; end
						end

						else
						begin

							if(countVGA==1)begin vga_r <= 4'd15;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==2)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==3)begin vga_r <= 4'd0;	vga_g <= 4'd0;	vga_b <= 4'd0; end
							else if(countVGA==4)begin vga_r <= 4'd15; vga_g <= 4'd0;	vga_b <= 4'd0; end
						end
				end
		end
		else
		begin			
				vga_r <= 4'd0;
				vga_g <= 4'd0;
				vga_b <= 4'd0;
		end
	end
end

endmodule
