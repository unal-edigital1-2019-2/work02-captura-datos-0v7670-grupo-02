`timescale 1ns / 1ps

module Testbench;

	// Inputs
	reg clk;
	reg rst;
	reg VSYNC;
	reg HREF;
	reg PCLK;
	reg [7:0] D;
	reg CBtn;

	// Outputs
	wire VGA_Hsync_n;
	wire VGA_Vsync_n;
	wire [3:0] VGA_R;
	wire [3:0] VGA_G;
	wire [3:0] VGA_B;
	wire CAM_xclk;
	wire CAM_pwdn;
	wire CAM_reset;

	// Instantiate the Unit Under Test (UUT)
	test_cam uut (
		.clk(clk), 
		.rst(rst), 
		.VGA_Hsync_n(VGA_Hsync_n), 
		.VGA_Vsync_n(VGA_Vsync_n), 
		.VGA_R(VGA_R), 
		.VGA_G(VGA_G), 
		.VGA_B(VGA_B), 
		.CAM_xclk(CAM_xclk), 
		.CAM_pwdn(CAM_pwdn), 
		.CAM_reset(CAM_reset), 
		.VSYNC(VSYNC), 
		.HREF(HREF), 
		.PCLK(PCLK), 
		.D(D), 
		.CBtn(CBtn)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		VSYNC = 0;
		HREF = 0;
		PCLK = 0;
		D = 0;
		CBtn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

