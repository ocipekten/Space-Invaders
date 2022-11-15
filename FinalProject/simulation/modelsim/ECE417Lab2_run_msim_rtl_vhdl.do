transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib PLL
vmap PLL PLL
vlog -vlog01compat -work PLL +incdir+C:/Users/Lab\ 402/Desktop/FinalProject/PLL/synthesis/submodules {C:/Users/Lab 402/Desktop/FinalProject/PLL/synthesis/submodules/PLL_pll_0.v}
vcom -93 -work work {C:/Users/Lab 402/Desktop/FinalProject/vga.vhd}
vcom -93 -work work {C:/Users/Lab 402/Desktop/FinalProject/subR.vhd}
vcom -93 -work PLL {C:/Users/Lab 402/Desktop/FinalProject/PLL/synthesis/PLL.vhd}
vcom -93 -work work {C:/Users/Lab 402/Desktop/FinalProject/LFSR.vhd}
vcom -93 -work work {C:/Users/Lab 402/Desktop/FinalProject/sync.vhd}

