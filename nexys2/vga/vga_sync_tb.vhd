-- Testbench for VGA pixel counter and sync generator

-- ghdl -a --std=08 vga_sync_tb.vhd
-- ghdl -r --std=08 vga_sync_tb --wave=vga_sync_tb.ghw
-- gtkwave vga_sync_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity vga_sync_tb is
end entity;

architecture behav of vga_sync_tb is
	constant T : time := 20 ns; -- 50 MHz

	signal clk, rst : std_logic := '0';
	signal x, y : std_logic_vector (9 downto 0);
	signal hsync, vsync, visible : std_logic;
begin
	-- Unit under test
	uut : entity work.vga_sync
		--generic map ()
		port map (
			clk => clk, rst => rst,
			x => x, y => y,
			hsync => hsync, vsync => vsync,
			visible => visible
		);

	-- Clock generator
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;

	-- Reset
	rst <= '1', '0' after T;

	-- Stimuli
	process
	begin
		wait for 2*T;

		wait until vsync;
		wait until vsync;

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
