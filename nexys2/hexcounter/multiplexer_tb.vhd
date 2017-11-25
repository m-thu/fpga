-- Testbench for seven segment LED multiplexer

-- ghdl -a --std=08 multiplexer_tb.vhd
-- ghdl -r --std=08 multiplexer_tb --wave=multiplexer_tb.ghw
-- gtkwave multiplexer_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity multiplexer_tb is
end entity;

architecture behav of multiplexer_tb is
	constant T : time := 20 ns; -- 50 MHz
	signal clk, rst : std_logic;
	signal hex0, hex1, hex2, hex3 : std_logic_vector (3 downto 0);
	signal seg : std_logic_vector (6 downto 0);
	signal an : std_logic_vector (3 downto 0);
begin
	-- Unit under test
	uut : entity work.multiplexer
		generic map (N => 3)
		port map (clk => clk, rst => rst,
		          hex0 => hex0, hex1 => hex1, hex2 => hex2, hex3 => hex3,
			  seg => seg, an => an);

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

	-- Stimulti
	process
		variable i : integer;
	begin
		hex0 <= x"1";
		hex1 <= x"2";
		hex2 <= x"3";
		hex3 <= x"4";
		wait until falling_edge(clk);

		for i in 1 to 64 loop
			wait until falling_edge(clk);
		end loop;

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
