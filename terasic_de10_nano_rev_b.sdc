#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz" [get_ports FPGA_CLK1_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK2_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK3_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

create_clock -period "400.0 kHz" [get_ports HPS_I2C0_SCLK]
create_clock -period "400.0 kHz" [get_ports HPS_I2C1_SCLK]
create_clock -period  "60.0 MHz" [get_ports HPS_USB_CLKOUT]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay  -clock [get_clocks {HPS_I2C0_SCLK}] 10 [get_ports {HPS_I2C0_SDAT}]
set_input_delay  -clock [get_clocks {HPS_I2C1_SCLK}] 10 [get_ports {HPS_I2C1_SDAT}]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock [get_clocks {HPS_I2C0_SCLK}] 10 [get_ports {HPS_I2C0_SDAT}]
set_output_delay -clock [get_clocks {HPS_I2C1_SCLK}] 10 [get_ports {HPS_I2C1_SDAT}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -exclusive -group u0|pll_stream|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk
set_clock_groups -exclusive -group u0|pll_pixel_clock|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from * -to [get_ports {LED}]
set_false_path -from [get_ports {KEY}] -to *
