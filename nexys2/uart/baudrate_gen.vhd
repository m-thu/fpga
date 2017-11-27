-- Baudrate generator (modulo M counter)

-- ghdl -a --std=08 baudrate_gen.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baudrate_gen is
	generic (
		-- f_Clock / (Baudrate * Oversampling)
		-- 50 MHz / (9600 * 16) = 326
		M : integer := 326;
		-- Counter width: log2(M) = 8.3 = 9
		N : integer := 9
	);

	port (
		clk, rst : in std_logic;
		tick : out std_logic
	);
end entity baudrate_gen;

architecture behav of baudrate_gen is
begin
	process (clk, rst)
		variable count : unsigned (N-1 downto 0);
	begin
		if rst = '1' then
			count := (others => '0');
		elsif rising_edge(clk) then
			if count < (M-1) then
				count := count + 1;
			else
				count := (others => '0');
			end if;
		end if;

		if count = (M-1) then
			tick <= '1';
		else
			tick <= '0';
		end if;
	end process;
end architecture;
