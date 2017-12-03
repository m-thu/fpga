library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		clk   : in std_logic;
		red   : out std_logic_vector (2 downto 0);
		green : out std_logic_vector (2 downto 0);
		blue  : out std_logic_vector (1 downto 0);
		hsync, vsync : out std_logic;
		led : out std_logic_vector (7 downto 0);
		sw : in std_logic_vector (7 downto 0)
	);
end top;

architecture behav of top is
	signal rst : std_logic := '0';
	signal visible : std_logic;
	signal sw_debounced : std_logic_vector (7 downto 0);
begin
	vga_sync : entity work.vga_sync
		port map (
			clk => clk, rst => rst,
			hsync => hsync, vsync => vsync,
			visible => visible
		);

	(red(2),red(1),red(0),green(2),green(1),green(0),blue(1),blue(0)) <=
       		sw_debounced when visible = '1'
       		else std_logic_vector'("00000000");

	sw7 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(7),level=>sw_debounced(7));
	sw6 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(6),level=>sw_debounced(6));
	sw5 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(5),level=>sw_debounced(5));
	sw4 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(4),level=>sw_debounced(4));
	sw3 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(3),level=>sw_debounced(3));
	sw2 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(2),level=>sw_debounced(2));
	sw1 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(1),level=>sw_debounced(1));
	sw0 : entity work.debounce
		port map (clk=>clk,rst=>rst,switch=>sw(0),level=>sw_debounced(0));

	led <= sw_debounced;
end behav;
