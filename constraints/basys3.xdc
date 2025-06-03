## Clock signal
set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports clk]; # 100MHz clock

## Reset button
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports rst]; # Center button

## VGA Output
set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports vga_red[0]]; 
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports vga_red[1]]; 
set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports vga_red[2]]; 
set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports vga_red[3]]; 
set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports vga_green[0]]; 
set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports vga_green[1]]; 
set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports vga_green[2]]; 
set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports vga_green[3]]; 
set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports vga_blue[0]]; 
set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports vga_blue[1]]; 
set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports vga_blue[2]]; 
set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports vga_blue[3]]; 
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports vga_hsync]; 
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports vga_vsync]; 

## PS/2 Keyboard
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports ps2_clk]; 
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports ps2_data]; 

## 7-Segment Display
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports seg[0]]; 
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports seg[1]]; 
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports seg[2]]; 
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports seg[3]]; 
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports seg[4]]; 
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports seg[5]]; 
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports seg[6]]; 
set_property -dict { PACKAGE_PIN U2    IOSTANDARD LVCMOS33 } [get_ports an[0]]; 
set_property -dict { PACKAGE_PIN U4    IOSTANDARD LVCMOS33 } [get_ports an[1]]; 
set_property -dict { PACKAGE_PIN V4    IOSTANDARD LVCMOS33 } [get_ports an[2]]; 
set_property -dict { PACKAGE_PIN W4    IOSTANDARD LVCMOS33 } [get_ports an[3]]; 