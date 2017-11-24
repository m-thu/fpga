library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		clk : in std_logic;
		seg : out std_logic_vector (6 downto 0);
		an : out std_logic_vector (3 downto 0);
		dp : out std_logic
	);
end top;

architecture behav of top is
	constant N : integer := 4; -- 16 bit counter
	signal count : std_logic_vector (N-1 downto 0);
	signal rst : std_logic := '0';
begin
	-- 0.25 s / (1/50 MHz) = 125e5
	-- log2(125e5) = 23.6 = 24
	counter : entity work.counter
		generic map (N => N, DEL => 125e5, N_DEL => 24)
		port map (clk => clk, count => count, rst => rst);
	hex_to_ss : entity work.hex_to_ss
		port map (ss => seg, hex => count);

	an <= "1110";
	dp <= '1';
end behav;
