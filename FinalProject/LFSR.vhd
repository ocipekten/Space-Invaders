library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



ENTITY LFSR IS
	PORT (
		clk, reset: IN std_logic;
		output: OUT std_logic_vector (7 DOWNTO 0));
END LFSR;

ARCHITECTURE MAIN OF LFSR IS
	SIGNAL Currstate, Nextstate: std_logic_vector (7 DOWNTO 0);
	SIGNAL feedback: std_logic;
BEGIN

	StateReg: PROCESS (clk,reset)
	BEGIN
		IF (reset = '1') THEN
			Currstate <= (0 => '1', OTHERS =>'0');
		ELSIF (clk = '1' AND clk'EVENT) THEN
			Currstate <= Nextstate;
		END IF;
	END PROCESS;

	feedback <= Currstate(4) XOR Currstate(3) XOR Currstate(2) XOR Currstate(0);
	Nextstate <= feedback & Currstate(7 DOWNTO 1);
	output <= Currstate;

END MAIN;