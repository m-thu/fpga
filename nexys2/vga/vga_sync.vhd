-- VGA pixel counter and sync generator

-- ghdl -a --std=08 vga_sync.vhd

-- 640x480 @ 60 Hz
-- ===============
--
-- Screen refresh rate: 60 Hz
-- Vertical refresh   : 31.46875 kHz
-- Pixel frequency    : 25.175 MHz ~ 25 MHz
--
-- Line:
-- =====
--
-- Visible area: 640 pixels
-- Front porch :  16 pixels
-- Sync pulse  :  96 pixels
-- Back porch :   48 pixels
-- ------------------------
--               800 pixels
--
-- Frame:
-- ======
--
-- Visible area: 480 lines
-- Front porch :  10 lines
-- Sync pulse  :   2 lines
-- Back porch  :  33 lines
-- -----------------------
--               525 lines
--
--
-- Horizontal timing:
-- ==================
--
-- |Pixel                                               |
-- |0                             639|   655| 751|   799|
-- _________________________________________      ______|
--                                   |      |    |      |
-- Hsync pulse                       |      |    |      |
--                                   |      ------      |
--                                   |                  |
-- |<---- Visible display (640) ---->|<---->|<-->|<---->|
--                                      ^     ^     ^
--                                      |     |     |
--                                      |     |     -- Back porch  (48)
--                                      |     -------- Sync pulse  (96)
--                                      -------------- Front porch (16)
--
-- Vertical timing:
-- ================
--
-- |Line                                                |
-- |0                             479|   489| 491|   524|
-- _________________________________________      ______|
--                                   |      |    |      |
-- Vsync pulse                       |      |    |      |
--                                   |      ------      |
--                                   |                  |
-- |<---- Visible display (480) ---->|<---->|<-->|<---->|
--                                      ^     ^     ^
--                                      |     |     |
--                                      |     |     -- Back porch  (33)
--                                      |     -------- Sync pulse  ( 2)
--                                      -------------- Front porch (10)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
	port (
		clk, rst     : in std_Logic;
		-- Pixel coordinates
		x, y         : out std_logic_vector (9 downto 0);
		-- Horizontal and vertical sync
		hsync, vsync : out std_logic;
		-- Indicates visible display area
		visible      : out std_logic
	);
end entity;

architecture behav of vga_sync is
	-- Horizontal timing
	constant H_VISIBLE     : integer := 640;
	constant H_FRONT_PORCH : integer :=  16;
	constant H_SYNC        : integer :=  96;
	constant H_BACK_PORCH  : integer :=  48;
	-- Vertical timing
	constant V_VISIBLE     : integer := 480;
	constant V_FRONT_PORCH : integer :=  10;
	constant V_SYNC        : integer :=   2;
	constant V_BACK_PORCH  : integer :=  33;

	-- Enable signal for the pixel counters @25 MHz
	signal en : std_logic;
	-- Vertical counter
	signal vcount : unsigned (9 downto 0);
	-- Horizontal counter
	signal hcount : unsigned (9 downto 0);
begin
	-- Generate enable signal @25 MHz
	process (clk, rst)
	begin
		if rst = '1' then
			en <= '0';
		elsif rising_edge(clk) then
			en <= not en;
		end if;
	end process;

	-- Horizontal and vertical counters
	process (clk, rst)
	begin
		if rst = '1' then
			vcount <= (others => '0');
			hcount <= (others => '0');
		elsif rising_edge(clk) then
			if en = '1' then
				if hcount = (H_VISIBLE+H_FRONT_PORCH
				             +H_SYNC+H_BACK_PORCH-1) then
					hcount <= (others => '0');

					if vcount = (V_VISIBLE+V_FRONT_PORCH
					             +V_SYNC+V_BACK_PORCH-1) then
						vcount <= (others => '0');
					else
						vcount <= vcount + 1;
					end if;
				else
					hcount <= hcount + 1;
				end if;
			end if;
		end if;
	end process;

	-- Pixel counters
	x <= std_logic_vector(hcount);
	y <= std_logic_vector(vcount);

	-- Horizontal sync
	hsync <=
		'1' when (hcount >= (H_VISIBLE+H_FRONT_PORCH))
		         and (hcount < (H_VISIBLE+H_FRONT_PORCH+H_SYNC))
		else '0';

	-- Vertical sync
	vsync <=
       		'1' when (vcount >= (V_VISIBLE+V_FRONT_PORCH))
		         and (vcount < (V_VISIBLE+V_FRONT_PORCH+V_SYNC))
		else '0';

	-- Visible flag
	visible <=
       		'1' when (hcount < H_VISIBLE) and (vcount < V_VISIBLE)
		else '0';
end architecture;
