gui_open_window Wave
gui_sg_create clk_100_25_24_group
gui_list_add_group -id Wave.1 {clk_100_25_24_group}
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.test_phase}
gui_set_radix -radix {ascii} -signals {clk_100_25_24_tb.test_phase}
gui_sg_addsignal -group clk_100_25_24_group {{Input_clocks}} -divider
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.CLK_IN1}
gui_sg_addsignal -group clk_100_25_24_group {{Output_clocks}} -divider
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.dut.clk}
gui_list_expand -id Wave.1 clk_100_25_24_tb.dut.clk
gui_sg_addsignal -group clk_100_25_24_group {{Status_control}} -divider
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.RESET}
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.LOCKED}
gui_sg_addsignal -group clk_100_25_24_group {{Counters}} -divider
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.COUNT}
gui_sg_addsignal -group clk_100_25_24_group {clk_100_25_24_tb.dut.counter}
gui_list_expand -id Wave.1 clk_100_25_24_tb.dut.counter
gui_zoom -window Wave.1 -full
