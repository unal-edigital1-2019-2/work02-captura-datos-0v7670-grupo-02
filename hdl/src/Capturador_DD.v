`timescale 1ns / 1ps

module Capturador_DD (VSYNC,HREF,PCLK,D,CBtn,data,addr,regwrite);
	
	input VSYNC;
	input HREF;
	input PCLK;
	input [7:0] D;
	input CBtn;
	output reg [7:0] data = 8'b0;
	output reg [16:0] addr = 17'b0;
	output reg regwrite = 0;
	
	reg [1:0] state = 0;
	
	always@(posedge PCLK)begin
		case(state)
			0://Inactivo
			if(CBtn) state = 1;
			1://Reinicia
			if(VSYNC) state = 2;
			2://Inicia
			if(HREF) state = 3;
			3://Activo
			if(VSYNC) state = 0;
		endcase
	end
	
	always@(posedge PCLK)begin
		if(state==2)begin
			addr = 17'b11111111111111111;
			regwrite = 1;
		end
	end
	
	always@(posedge PCLK)begin
		if(HREF & state[1])begin
			if(regwrite)begin
				regwrite = 0;
				data [7:2] = {D[7:5],D[2:0]};
				addr = addr + 1;
			end else begin
				data [1:0] = D[4:3];
				regwrite = 1;
			end
		end
	end
	
endmodule
