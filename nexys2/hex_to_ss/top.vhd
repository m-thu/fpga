library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		sw : in std_logic_vector (3 downto 0);
		seg : out std_logic_vector (6 downto 0);
		an : out std_logic_vector (3 downto 0);
		dp : out std_logic
	);
end top;

architecture behav of top is
begin
	hex_to_ss : entity work.hex_to_ss
		port map (ss => seg, hex => sw(3 downto 0));

	an <= "1110";
	dp <= '1';
end behav;
