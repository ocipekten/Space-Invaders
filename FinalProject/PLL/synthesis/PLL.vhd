-- PLL.vhd

-- Generated using ACDS version 16.1 196

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PLL is
	port (
		clk_in_clk  : in  std_logic := '0'; --  clk_in.clk
		clk_out_clk : out std_logic;        -- clk_out.clk
		reset_reset : in  std_logic := '0'  --   reset.reset
	);
end entity PLL;

architecture rtl of PLL is
	component PLL_pll_0 is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component PLL_pll_0;

begin

	pll_0 : component PLL_pll_0
		port map (
			refclk   => clk_in_clk,  --  refclk.clk
			rst      => reset_reset, --   reset.reset
			outclk_0 => clk_out_clk, -- outclk0.clk
			locked   => open         -- (terminated)
		);

end architecture rtl; -- of PLL
