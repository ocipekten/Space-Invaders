	component PLL is
		port (
			clk_out_clk : out std_logic;        -- clk
			clk_in_clk  : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'  -- reset
		);
	end component PLL;

	u0 : component PLL
		port map (
			clk_out_clk => CONNECTED_TO_clk_out_clk, -- clk_out.clk
			clk_in_clk  => CONNECTED_TO_clk_in_clk,  --  clk_in.clk
			reset_reset => CONNECTED_TO_reset_reset  --   reset.reset
		);

