`timescale 1ns / 1ps

module Testbench;

	// Inputs
	reg VSYNC;
	reg HREF;
	reg PCLK;
	reg [7:0] D;
	reg CBtn;

	// Outputs
	wire [7:0] data;
	wire [16:0] addr;
	wire regwrite;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	Capturador_DD uut (
		.VSYNC(VSYNC), 
		.HREF(HREF), 
		.PCLK(PCLK), 
		.D(D), 
		.CBtn(CBtn), 
		.data(data), 
		.addr(addr), 
		.regwrite(regwrite)
	);

	initial begin
		// Initialize Inputs
		VSYNC = 0;
		HREF = 0;
		PCLK = 0;
		D = 0;
		CBtn = 0;	
		
		i=0;
		
		#1 D=0;	
	end
	
	always begin
		#2 D=D+1;
	end
	
	always begin
		#10 VSYNC = 1;
		#10 VSYNC = 0;
		#10;
		for(i=0; i<=3; i=i+1)begin
			HREF = 1; #16
			HREF = 0; #6;
		end
	end
	
	always begin
		#95 CBtn = 1;
		#5 CBtn = 0;
	end

	always #1 PCLK = ~PCLK;
      
endmodule

