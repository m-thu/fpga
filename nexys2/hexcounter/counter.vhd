-- Binary counter with delay (reset: active high)

-- ghdl -a --std=08 counter.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic (
		-- Number of bits
		N : integer := 16;
		-- Delay (clock cycles)
		DEL : integer;
		-- Delay counter width
		N_DEL : integer
	);

	port (
		clk, rst : in std_logic;
		count : out std_logic_vector (N-1 downto 0)
	);
end counter;

architecture behav of counter is
	signal counti : unsigned (N-1 downto 0);
begin
	process (clk, rst)
		variable delay : unsigned (N_DEL-1 downto 0);
	begin
		if rst = '1' then
			counti <= (others => '0');
			delay := (others => '0');
		elsif rising_edge(clk) then
			if delay = DEL then
				delay := (others => '0');
				counti <= counti + 1;
			else
				delay := delay + 1;
			end if;
		end if;
	end process;

	count <= std_logic_vector(counti);
end behav;
