library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Controller is
	Port(
		clk: in std_logic;
		reset: in std_logic;
		resetOut: out std_logic;
		leftBT, rightBT: in std_logic;
		start: out std_logic);
end Controller;

Architecture Main of Controller is
	type State_Type is (menu, play);
	signal state : State_Type := menu;
	
Begin
	
	Process(clk,reset)
	Begin
	
		if (reset = '0') then
			state <= menu;
		elsif (clk'event and clk = '1') then
			case state is
				when menu=>
					start <= '0';
					if (leftBT = '0' or rightBT = '0') then
						resetOut <= '1';
						state <= play;
					end if;
				when play=>
					resetOut <= '0';
					start <= '1';
			end case;
		end if;
	end Process;
	
end Main;
			