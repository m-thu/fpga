-- Testbench for debouncer

-- ghdl -a --std=08 debounce_tb.vhd
-- ghdl -r --std=08 debounce_tb --wave=debounce_tb.ghw
-- gtkwave debounce_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity debounce_tb is
end entity;

architecture behav of debounce_tb is
	constant T : time := 20 ns; -- 50 MHz
	signal clk, rst, switch, level : std_logic := '0';
begin
	-- Unit under test
	uut : entity work.debounce
		generic map (DELAY => 10, N_DELAY => 4)
		port map (clk => clk, rst => rst,
			  switch => switch, level => level);

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
		switch <= '0';
		wait for T/3;
		switch <= '1';
		wait for 5*T;
		switch <= '0';
		wait for 5*T;

		switch <= '1';
		wait for 15*T;

		switch <= '0';
		wait for 5*T;
		switch <= '1';
		wait for 5*T;

		switch <= '0';
		wait for 15*T;

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
