library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY VGA IS
PORT(
CLOCK_24: IN STD_LOGIC_VECTOR(1 downto 0);
BT1, BT2, BT3, BT4 : IN STD_LOGIC;
VGA_HS,VGA_VS:OUT STD_LOGIC;
VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(7 downto 0);
VGA_CLK: out std_logic
);
END VGA;


ARCHITECTURE MAIN OF VGA IS
SIGNAL VGACLK,RESET:STD_LOGIC;
	
	signal random: std_logic_vector(7 downto 0);
	signal start: std_logic;
	signal shoot: std_logic;
	signal spawnEnemy: std_logic;
	signal resetRandom: std_logic;
	signal resetGame: std_logic;
 
	Component Controller is
		Port(
		clk: in std_logic;
		reset: in std_logic;
		resetOut: out std_logic;
		leftBT, rightBT: in std_logic;
		start: out std_logic);
	end component Controller;
 
	Component SYNC IS
		PORT(
		CLK: IN STD_LOGIC;
		HSYNC: OUT STD_LOGIC;
		VSYNC: OUT STD_LOGIC;
		start: IN std_logic;
		shoot: in std_logic;
		spawnEnemy: in std_logic;
		BT1, BT2, reset, fireButton : IN STD_LOGIC;
		resetRandom: IN std_logic;
		random: IN std_logic_vector(7 downto 0);
		R: OUT STD_LOGIC_VECTOR(7 downto 0);
		G: OUT STD_LOGIC_VECTOR(7 downto 0);
		B: OUT STD_LOGIC_VECTOR(7 downto 0));
	END Component SYNC;
	
	Component LFSR is
		PORT (
		clk, reset: IN std_logic;
		output: OUT std_logic_vector (7 DOWNTO 0));
	End component LFSR;

	component pll is
			port (
				clk_in_clk  : in  std_logic := 'X'; -- clk
				reset_reset : in  std_logic := 'X'; -- reset
				clk_out_clk : out std_logic         -- clk
			);
	end component pll;

BEGIN

 C: pll PORT MAP (CLOCK_24(0),RESET,VGACLK);
 controller1 : Controller Port Map(VGACLK,BT3,resetGame,BT1,BT2,start);
 C1: SYNC PORT MAP(VGACLK,VGA_HS,VGA_VS,start,shoot,spawnEnemy,BT1,BT2,resetGame,BT4,resetRandom,random,VGA_R,VGA_G,VGA_B);
 random1: LFSR PORT MAP(VGACLK,BT3,random);

 VGA_CLK <= VGACLK;
 
 END MAIN;
 