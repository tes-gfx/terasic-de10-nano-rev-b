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

create_clock -period "1 MHz" [get_ports HPS_I2C0_SCLK]
create_clock -period "1 MHz" [get_ports HPS_I2C1_SCLK]
create_clock -period "1 MHz" [get_ports HDMI_I2C_SCL]
create_clock -period  "48.0 MHz" [get_ports HPS_USB_CLKOUT]

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
set_input_delay  -clock [get_clocks {HDMI_I2C_SCL}] 10 [get_ports {HDMI_I2C_SDA}]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay  -clock [get_clocks {HDMI_I2C_SCL}] 10 [get_ports {HDMI_I2C_SDA}]


#**************************************************************
# Set Clock Groups
#**************************************************************
set HDMI_CLK {u0|pll_pixel_clock|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}
set BUS_CLK {u0|pll_stream|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}

create_generated_clock -add -name {hdmi_tx_clk108} -source [get_pins ${HDMI_CLK}] [get_ports HDMI_TX_CLK]
set_clock_groups -exclusive -group ${HDMI_CLK} -group ${BUS_CLK}


#**************************************************************
# HDMI settings
#**************************************************************
set HDMI_CLK_PERIOD [get_clock_info -period [get_clocks hdmi_tx_clk108]]
set HDMI_TSU 1.0
set HDMI_TH  0.7
set HDMI_PAD 0.3
set HDMI_MAX [expr ${HDMI_CLK_PERIOD} - ${HDMI_TSU} - ${HDMI_PAD}]
set HDMI_MIN [expr ${HDMI_CLK_PERIOD} + ${HDMI_TH}  + ${HDMI_PAD}]

post_message -type info [format "HDMI_MAX = %f" ${HDMI_MAX}]
post_message -type info [format "HDMI_MIN = %f" ${HDMI_MIN}]

set_output_delay -clock [get_clocks hdmi_tx_clk108] -max ${HDMI_MAX} [get_ports {HDMI_TX_D[*]}]
set_output_delay -clock [get_clocks hdmi_tx_clk108] -min ${HDMI_MIN} [get_ports {HDMI_TX_D[*]}]

set_output_delay -clock [get_clocks hdmi_tx_clk108] -max ${HDMI_MAX} [get_ports {HDMI_TX_DE}]
set_output_delay -clock [get_clocks hdmi_tx_clk108] -min ${HDMI_MIN} [get_ports {HDMI_TX_DE}]

set_output_delay -clock [get_clocks hdmi_tx_clk108] -max ${HDMI_MAX} [get_ports {HDMI_TX_HS}]
set_output_delay -clock [get_clocks hdmi_tx_clk108] -min ${HDMI_MIN} [get_ports {HDMI_TX_HS}]

set_output_delay -clock [get_clocks hdmi_tx_clk108] -max ${HDMI_MAX} [get_ports {HDMI_TX_VS}]
set_output_delay -clock [get_clocks hdmi_tx_clk108] -min ${HDMI_MIN} [get_ports {HDMI_TX_VS}]


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from * -to [get_ports {LED[*]}]
set_false_path -from [get_ports {KEY[*]}] -to *

set_false_path -from * -to [get_ports {HPS_I2C0_SCLK}]
set_false_path -from * -to [get_ports {HPS_I2C0_SDAT}]
set_false_path -from * -to [get_ports {HPS_I2C1_SCLK}]
set_false_path -from * -to [get_ports {HPS_I2C1_SDAT}]
set_false_path -from [get_ports {HPS_I2C0_SCLK}] -to *
set_false_path -from [get_ports {HPS_I2C0_SDAT}] -to *
set_false_path -from [get_ports {HPS_I2C1_SCLK}] -to *
set_false_path -from [get_ports {HPS_I2C1_SDAT}] -to *

set_false_path -from [get_ports {HPS_USB_CLKOUT}] -to *
set_false_path -from [get_ports {HPS_USB_DIR}] -to *
set_false_path -from [get_ports {HPS_USB_NXT}] -to *
set_false_path -from * -to [get_ports {HPS_USB_STP}] 
set_false_path -from [get_ports {HPS_USB_DATA[*]}] -to *
set_false_path -from * -to [get_ports {HPS_USB_DATA[*]}]

set_false_path -from * -to [get_ports {HPS_ENET_GTX_CLK}] 
set_false_path -from * -to [get_ports {HPS_ENET_TX_DATA[*]}]
set_false_path -from * -to [get_ports {HPS_ENET_MDC}] 
set_false_path -from * -to [get_ports {HPS_ENET_TX_EN}] 
set_false_path -from * -to [get_ports {HPS_ENET_MDIO}] 
set_false_path -from [get_ports {HPS_ENET_MDIO}] -to *
set_false_path -from [get_ports {HPS_ENET_RX_DV}] -to *
set_false_path -from [get_ports {HPS_ENET_RX_CLK}] -to *
set_false_path -from [get_ports {HPS_ENET_RX_DATA[*]}] -to *

set_false_path -from * -to [get_ports {HPS_UART_TX}]
set_false_path -from [get_ports {HPS_UART_RX}] -to *

set_false_path -from * -to [get_ports {HPS_SD_CLK}] 
set_false_path -from [get_ports {HPS_SD_CMD}] -to *
set_false_path -from [get_ports {HPS_SD_DATA[*]}] -to *
set_false_path -from * -to [get_ports {HPS_SD_CMD}]
set_false_path -from * -to [get_ports {HPS_SD_DATA[*]}]

set_false_path -from * -to [get_ports {HPS_SPIM_CLK}] 
set_false_path -from * -to [get_ports {HPS_SPIM_MOSI}] 
set_false_path -from * -to [get_ports {HPS_SPIM_SS}]
set_false_path -from [get_ports {HPS_SPIM_MISO}] -to *
set_false_path -from [get_ports {HPS_SPIM_SS}] -to *

set_false_path -from [get_ports {HDMI_TX_INT}] -to *
