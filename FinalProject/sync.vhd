library ieee;
library osvvm;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use work.my.all;
use work.PACK.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
start: IN std_logic;
shoot: in std_logic;
spawnEnemy: in std_logic;
BT1, BT2, reset, fireButton : IN STD_LOGIC;
resetRandom: IN std_logic;
random: IN STD_LOGIC_VECTOR(7 downto 0);
R: OUT STD_LOGIC_VECTOR(7 downto 0);
G: OUT STD_LOGIC_VECTOR(7 downto 0);
B: OUT STD_LOGIC_VECTOR(7 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
	-- Display Signals
	SIGNAL RGB: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
	SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;
	SIGNAL displayStartX: integer := 408;
	SIGNAL displayEndX: integer := 408 + 1000;
	SIGNAL displayStartY: integer := 42;
	SIGNAL displayEndY: integer := 42 + 1024;

	-- Enemy Information
	type Enemy_State_Type is (go_left, go_right, go_downl, go_downr);
	signal enemyState: Enemy_State_Type := go_right;
	signal enemyClock: integer := 0;
	constant enemySize: integer := 6;
	constant enemySprite: std_logic_vector(120 downto 0) := "0001101100010100000101101111111011111111111101101110110001111111000001000100000100000100000000000000000000000000000000000";
	
	-- Enemy2 Information
	constant enemy2Sprite: std_logic_vector(120 downto 0) := "0010000100001000000100001011010000111111110001101101100001111110000001111000000001100000000000000000000000000000000000000";
	
	-- Enemy Bullet Information
	signal enemyBulletClock: integer := 0;
	constant enemyBulletSprite: std_logic_vector(120 downto 0) := "1111111111111111111111111111111110111111111000001110000000011100000000010000000000000000000000000000000000000000000000000";
	signal enemyBulletX: integer;
	signal enemyBulletY: integer;
	signal enemyBulletFlag: std_logic;
	signal enemyBulletDraw: std_logic;
	
	-- Player Information
	signal playerRGB: std_logic_vector(3 downto 0);
	constant playerSprite: std_logic_vector(120 downto 0) := "1111111111111111111111111111111110111111111000001110000000011100000000010000000000000000000000000000000000000000000000000";
	constant playerStartX: integer := displayStartX + ((displayEndX - displayStartX) / 2) - (80 / 2);
	constant playerStartY: integer := displayStartY + ((displayEndY - displayStartY) * 5 / 6) - (80 / 2);
	constant playerSize: integer := 6;
	
	-- Bullet Information
	signal bulletClock: integer := 0;
	signal bulletNumber: integer := 0;	
	constant bulletSize: integer := 2;
	constant bulletSprite: std_logic_vector(120 downto 0) := "0000111000000001110000001111111000011111110001111111110111111111110111111111000111111100001111111000000111000000001110000";
	constant NUM_OF_ENEMIES: integer := 20;
	constant LENGTH_OF_ROW: integer := 5;
	
	
BEGIN

	PROCESS(CLK)
	BEGIN
	-- Setting enemy bullet position
	

	
	-- Draw Enemy Bullet
	drawSquare2(CLK,playerRGB,enemyBulletDraw,HPOS,VPOS,enemyBulletX,enemyBulletY,bulletSize,enemyBulletSprite);
	
	END PROCESS;
	
	PROCESS(CLK)
	-- Player Variables
	variable playerPosX: integer := displayStartX + ((displayEndX - displayStartX) / 2) - (playerSize / 2);
	variable playerPosY: integer := displayStartY + ((displayEndY - displayStartY) * 5 / 6) - (playerSize / 2);
	variable playerDraw: std_logic := '0';
	
	-- Enemy Variables
	variable enemyFlag: std_logic_vector(NUM_OF_ENEMIES-1 downto 0) := (others=>'1');
	variable enemyX: integer := displayStartX + 50;
	variable enemyY: integer := displayStartY;
	variable enemyShootIndex: integer := 5;
	variable enemyShootRow: integer;
	
	-- Enemy Bullet Variables


	
	-- Bullet Variables
	variable bulletX: integer;
	variable bulletY: integer;
	variable bulletFlag: std_logic;
	variable bulletDraw: std_logic;
	
	variable clockCounter : integer := 0;
	variable x: integer := 0;
	variable y: integer := 0;
	
	variable enemyDraw: std_logic;
	BEGIN
	IF(CLK'EVENT AND CLK='1')THEN
	R<=(others=>'0');
	G<=(others=>'0');
	B<=(others=>'0');
	
	--Frame control code
	
	if (HPOS < 1688) then
		HPOS <= HPOS + 1;
	else
		HPOS <= 0;
		if (VPOS <= 1066) then
			VPOS <= VPOS + 1;
		else
		VPOS <= 0;
		end if;
	end if;
	
	--Porch control code
	
	if (HPOS > 0 and HPOS < 408) or (VPOS > 0 and VPOS < 42) then
		R<=(others=>'0');
		G<=(others=>'0');
		B<=(others=>'0');
	end if;
	
	--Synch control code
	
	if (HPOS > 48 and HPOS < 160) then
		HSYNC <= '0';
	else
		HSYNC <= '1';
	end if;
	
	if (VPOS > 1 and VPOS < 4) then -- check this again
		VSYNC <= '0';
	else
		VSYNC <= '1';
	end if;
	
	-- Clock Counter
	
	if (HPOS > 48 and HPOS < 160 and VPOS > 1 and VPOS < 4) then
		clockCounter := clockCounter + 1;
		enemyClock <= enemyClock + 1;
		bulletClock <= bulletClock + 1;
		enemyBulletClock <= enemyBulletClock + 1;
	end if;
	
	-- Draw Player
	drawSquare(CLK,playerRGB,playerDraw,HPOS,VPOS,playerPosX,playerPosY,playerSize,playerSprite);
	if (playerDraw = '1') then
		R<=(others=>'0');
		G<=(others=>'1');
		B<=(others=>'0');
	end if;
	
	for i in NUM_OF_ENEMIES-1 downto 0 loop
		x := enemyX+((i mod LENGTH_OF_ROW)*14*enemySize);
		y := enemyY+((i/LENGTH_OF_ROW)*14*enemySize);

	-- Draw Enemies
		if (i < 10) then
			drawSquare(CLK,RGB,enemyDraw,HPOS,VPOS,x,y,enemySize,enemySprite);
		else
			drawSquare(CLK,RGB,enemyDraw,HPOS,VPOS,x,y,enemySize,enemy2Sprite);
		end if;
		
		if (enemyDraw = '1' and enemyFlag(i) = '1') then
			R<=(others=> random(0));
			G<=(others=> random(0));
			B<=(others=>'1');
		end if;
		
		if (bulletX>x-bulletSize and bulletX<x+(enemySize*11) 
		    and bulletY>y-bulletSize and bulletY<y+(enemySize*11) and bulletFlag = '1' and enemyFlag(i) = '1') then
			bulletFlag := '0';
			enemyFlag(i) := '0';
		end if;
	end loop;
	
	-- Movement
	
	if (clockCounter > 80) then
		
		-- Player Movement
		if (BT1 = '0') then
			playerPosX := playerPosX + 2;
		elsif (BT2 = '0') then
			playerPosX := playerPosX - 2;
		else
			playerPosX := playerPosX;
		end if;
		
		-- Bullet Movement
		bulletY := bulletY - 3;
		
		-- Enemy Bullet Movement
		enemyBulletY <= enemyBulletY + 3;
		
		case enemyState is
			when go_right=>
				enemyX := enemyX + 1;
			when go_left=>
				enemyX := enemyX - 1;
			when go_downl=>
				enemyY := enemyY + 1;
			when go_downr=>
				enemyY := enemyY + 1;
		end case;
		
		clockCounter := 0;
	end if;
	
	-- Reset the game

	if (reset = '1') then
		enemyX := displayStartX;
		enemyY := displayStartY;
		enemyState <= go_right;
		clockCounter := 0;
		enemyClock <= 0;
		bulletClock <= 0;
		enemyFlag := (others=>'1');
		bulletFlag := '1';
		enemyBulletClock <= 0;
		enemyShootIndex := (to_integer(unsigned(random) mod 20));
	end if;
	

	
	-- Draw Bullet
	
	drawSquare(CLK,playerRGB,bulletDraw,HPOS,VPOS,bulletX,bulletY,bulletSize,bulletSprite);
	
	if (bulletDraw = '1' and bulletFlag = '1') then
		R<=(others=>'1');
		G<=(others=>'0');
		B<=(others=>'1');
	end if;
	
	-- Enemy Movement
	
	case enemyState is
			when go_right=>
				if (enemyX+(enemySize*11*LENGTH_OF_ROW)+(3*(LENGTH_OF_ROW-1)) >= displayEndX - 50) then
					RGB <= "0010";
					enemyClock <= 0;
					enemyState <= go_downl;					
				end if;
			when go_downl=>
				if (enemyClock > 1000) then
					RGB <= "1000";
					enemyClock <= 0;
					enemyState <= go_left;		
				end if;
			when go_left=>
				if (enemyX <= displayStartX + 50) then
					RGB <= "0100";
					enemyClock <= 0;
					enemyState <= go_downr;					
				end if;
			when go_downr=>
				if (enemyClock > 1000) then
					RGB <= "1000";
					enemyClock <= 0;
					enemyState <= go_right;
				end if;
	end case;
	
	-- Setting bullet's position as the middle of the player ship
	
	if (bulletClock > 10000 * 3 and fireButton = '0') then
		bulletFlag := '1';
		bulletX := playerPosX+(((playerSize*11)-(bulletSize*11))/2);
		bulletY := playerPosY-(bulletSize*11);
		bulletClock <= 0;
	end if;
	
	
	if (enemyBulletDraw = '1' and enemyBulletFlag = '1') then
		R<=(others=>'1');
		G<=(others=>'1');
		B<=(others=>'0');
	end if;	
	
	if (start = '0') then
		R<=(others=>'0');
		G<=(others=>'0');
		B<=(others=>'0');
	end if;
	
--	if (enemyBulletClock > 10000 * 5) then
--		enemyShootIndex := (to_integer(unsigned(random)) mod 20);
--		if (enemyFlag(enemyShootIndex) = '1') then
--			enemyBulletX <= enemyX+((enemyShootIndex mod LENGTH_OF_ROW)*14*enemySize);
--			enemyBulletY <= enemyY+((enemyShootIndex / LENGTH_OF_ROW)*14*enemySize);
--			enemyBulletFlag <= '1';
--			enemyBulletClock <= 0;
--		end if;
--	end if;
	
END IF;
END PROCESS;
END MAIN;