-- Debouncer for buttons/switches

-- ghdl -a --std=08 debounce.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity debounce is
	generic (
		-- Require DELAY number of clock cycles for input to stabilize
		-- 20 ms / (1/50 MHz) = 1e6
		DELAY : integer := 1e6;
		-- Counter width for DELAY
		-- log2(1e6) = 19.9 = 20
		N_DELAY : integer := 20
	);

	port (
		clk, rst, switch : in std_logic;
		level : out std_logic
	);
end entity;

architecture behav of debounce is
begin
	process (clk, rst)
		type state_type is (ZERO, WAIT1, ONE, WAIT0);
		variable state : state_type;
		variable count : unsigned (N_DELAY-1 downto 0);
	begin
		if rst = '1' then
			state := ZERO;
			count := (others => '0');
		elsif rising_edge(clk) then
			case state is
				when ZERO =>
					if switch = '1' then
						state := WAIT1;
						count := to_unsigned(DELAY, count'length);
					else
						state := ZERO;
					end if;

				when WAIT1 =>
					if switch = '1' then
						count := count - 1;
						if (count = 0) then
							state := ONE;
						else
							state := WAIT1;
						end if;
					else
						state := ZERO;
					end if;
				when ONE =>
					if switch = '0' then
						state := WAIT0;
						count := to_unsigned(DELAY, count'length);
					else
						state := ONE;
					end if;

				when WAIT0 =>
					if switch = '0' then
						count := count - 1;
						if (count = 0) then
							state := ZERO;
						else
							state := WAIT0;
						end if;
					else
						state := ONE;
					end if;

				when others =>
					state := ZERO;
			end case;
		end if;

		case state is
			when ZERO =>
				level <= '0';
			when WAIT1 =>
				level <= '0';
			when ONE =>
				level <= '1';
			when WAIT0 =>
				level <= '1';
			when others =>
				level <= '0';
		end case;
	end process;
end architecture;
