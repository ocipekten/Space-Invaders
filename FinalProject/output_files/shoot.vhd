library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PACK is
	procedure drawSquare
		(SIGNAL clk: IN std_logic;
		SIGNAL RGB: out std_logic_vector(3 downto 0);
		draw: out std_logic;
		SIGNAL curX, curY: in integer;
		startX, startY: IN integer;
		size: IN integer;
		sprite: in std_logic_vector(121 downto 0));
		
	procedure drawSquare2
		(SIGNAL clk: IN std_logic;
		SIGNAL RGB: out std_logic_vector(3 downto 0);
		SIGNAL draw: out std_logic;
		SIGNAL curX, curY: in integer;
		startX, startY: IN integer;
		size: IN integer;
		sprite: in std_logic_vector(121 downto 0));
		
	procedure getEnemyToShoot
		(signal random: IN std_logic_vector(7 downto 0);
		enemyFlag: IN std_logic_vector(19 downto 0);
		enemyIndex: out integer);
end PACK;

package body PACK is

	procedure drawSquare
		(SIGNAL clk: IN std_logic;
		SIGNAL RGB: out std_logic_vector(3 downto 0);
		draw: out std_logic;
		SIGNAL curX, curY: in integer;
		startX, startY: IN integer;
		size: IN integer;
		sprite: in std_logic_vector(120 downto 0)) is
	variable xd : std_logic;
	begin
		xd := '0';
		for i in 120 downto 0 loop
			if (curX > startX + (i mod 11)*size and curX < startX + (i mod 11)*size + size + 1
					and curY > startY + (i / 11)*size and curY < startY + size + (i / 11)*size + 1 and sprite(i) = '1') then
				xd := '1';
			end if;
		end loop;
		draw := xd;
	end drawSquare;
	
		procedure drawSquare2
		(SIGNAL clk: IN std_logic;
		SIGNAL RGB: out std_logic_vector(3 downto 0);
		SIGNAL draw: out std_logic;
		SIGNAL curX, curY: in integer;
		startX, startY: IN integer;
		size: IN integer;
		sprite: in std_logic_vector(120 downto 0)) is
	variable xd : std_logic;
	begin
		xd := '0';
		for i in 120 downto 0 loop
			if (curX > startX + (i mod 11)*size and curX < startX + (i mod 11)*size + size + 1
					and curY > startY + (i / 11)*size and curY < startY + size + (i / 11)*size + 1 and sprite(i) = '1') then
				xd := '1';
			end if;
		end loop;
		draw <= xd;
	end drawSquare2;
	
	procedure getEnemyToShoot
		(signal random: IN std_logic_vector(7 downto 0);
		enemyFlag: IN std_logic_vector(19 downto 0);
		enemyIndex: out integer) is
	begin
		for i in 3 downto 0 loop
			if (enemyFlag((to_integer(unsigned(random)) mod 5) * (i * 5)) = '1') then
				enemyIndex := i;
			end if;
		end loop;
	end getEnemyToShoot;
end PACK;