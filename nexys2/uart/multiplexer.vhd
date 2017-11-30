-- Time multiplexer for seven segment LED displays

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplexer is
	generic (
		-- Counter width
		N : integer := 18
	);

	port (
		clk, rst : in std_logic;
		hex0, hex1, hex2, hex3 : in std_logic_vector (3 downto 0);
		seg : out std_logic_vector (6 downto 0);
		an : out std_logic_vector (3 downto 0)
	);
end entity;

architecture behav of multiplexer is
	signal count : unsigned (N-1 downto 0);
	signal sel : unsigned (1 downto 0); -- Counter MSBs
	signal hex : std_logic_vector (3 downto 0);
begin
	hex_to_ss : entity work.hex_to_ss
		port map (hex => hex, ss => seg);

	process (clk, rst)
	begin
		if rst = '1' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			count <= count + 1;
		end if;
	end process;

	sel <= count(N-1 downto N-2);

	--process (all)
	process (sel, hex0, hex1, hex2, hex3)
	begin
		case sel is
			when "00" =>
				an <= "1110";
				hex <= hex0;
			when "01" =>
				an <= "1101";
				hex <= hex1;
			when "10" =>
				an <= "1011";
				hex <= hex2;
			when "11" =>
				an <= "0111";
				hex <= hex3;
			when others =>
				an <= "1111";
				hex <= hex0;
		end case;
	end process;
end architecture;
