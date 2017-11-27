-- Testbench for baudrate generator

-- ghdl -a --std=08 baudrate_gen_tb.vhd
-- ghdl -r --std=08 baudrate_gen_tb --wave=baudrate_gen_tb.ghw
-- gtkwave baudrate_gen_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity baudrate_gen_tb is
end entity;

architecture behav of baudrate_gen_tb is
	constant T : time := 20 ns; -- 50 MHz
	signal clk, rst : std_logic := '0';
	signal tick : std_logic;
begin
	-- Unit under test
	uut : entity work.baudrate_gen
		generic map (N => 4, M => 4)
		port map (clk => clk, rst => rst,
			  tick => tick);

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
		variable i : integer;
	begin
		for i in 1 to 16 loop
			wait until falling_edge(clk);
		end loop;

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
