library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		clk : in std_logic;
		seg : out std_logic_vector (6 downto 0);
		an : out std_logic_vector (3 downto 0);
		dp : out std_logic
	);
end top;

architecture behav of top is
	constant N : integer := 16; -- 16 bit counter
	signal count : std_logic_vector (N-1 downto 0);
	signal rst : std_logic := '0';
	signal rst_cnt : unsigned (1 downto 0) := "00";
begin
	-- 0.25 s / (1/50 MHz) = 125e5
	-- log2(125e5) = 23.6 = 24
	counter : entity work.counter
		generic map (N => N, DEL => 125e5, N_DEL => 24)
		port map (clk => clk, count => count, rst => rst);

	multiplexer : entity work.multiplexer
		port map (clk => clk, rst => rst,
		          hex0 => count(3 downto 0),
			  hex1 => count(7 downto 4),
			  hex2 => count(11 downto 8),
			  hex3 => count(15 downto 12),
			  seg => seg, an => an);
	process (clk)
	begin
		if rising_edge(clk) then
			if rst_cnt /= "11" then
				rst_cnt <= rst_cnt + 1;
				rst <= '1';
			else
				rst_cnt <= "11";
				rst <= '0';
			end if;
		end if;
	end process;

	dp <= '1';
end behav;
