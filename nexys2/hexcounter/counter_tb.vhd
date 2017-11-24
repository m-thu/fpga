-- Testbench for binary counter

-- ghdl -a --std=08 counter_tb.vhd
-- ghdl -r --std=08 counter_tb --wave=counter_tb.ghw
-- gtkwave counter_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end entity;

architecture behav of counter_tb is
	constant T : time := 20 ns; -- 50 MHz
	constant N : integer := 4;  -- 4 bit counter
	signal clk, rst : std_logic;
	signal value : std_logic_vector (N-1 downto 0);
begin
	-- Unit under test
	uut : entity work.counter 
		generic map (N => N, DEL => 1, N_DEL => 1)
		port map (clk => clk, rst => rst, count => value);

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
		for i in 1 to 64 loop
			wait until falling_edge(clk);
		end loop;

		assert false report "Testbench finished"
			severity failure;
	end process;
end architecture;
