-- Hexadecimal to seven-segment LED decoder

-- ghdl -a --std=08 hex_to_ss.vhd

--     a
--   ------
-- f |    | b
--   | g  |
--   ------
-- e |    | c
--   |    |
--   ------
--     d
--
-- Common anode, individual cathodes
--
-- ss : out std_logic_vector (6 downto 0)
-- (g,f,e,d,c,b,a)

library ieee;
use ieee.std_logic_1164.all;

entity hex_to_ss is
	port (
		-- Hexadecimal nibble
		hex : in std_logic_vector (3 downto 0);
		-- Segments
		ss : out std_logic_vector (6 downto 0)
	);
end entity;

architecture behav of hex_to_ss is
	signal ssi : std_logic_vector (6 downto 0);
begin
	with hex select ssi <=
		"0111111" when "0000", -- 0x0
		"0000110" when "0001", -- 0x1
		"1011011" when "0010", -- 0x2
		"1001111" when "0011", -- 0x3
		"1100110" when "0100", -- 0x4
		"1101101" when "0101", -- 0x5
		"1111101" when "0110", -- 0x6
		"0000111" when "0111", -- 0x7
		"1111111" when "1000", -- 0x8
		"1101111" when "1001", -- 0x9
		"1011111" when "1010", -- 0xa
		"1111100" when "1011", -- 0xb
		"0111001" when "1100", -- 0xc
		"1011110" when "1101", -- 0xd
		"1111001" when "1110", -- 0xe
		"1110001" when "1111", -- 0xf
		"0000000" when others;

	ss <= not(ssi);
end architecture behav;
