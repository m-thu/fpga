library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		clk, btn0 : in std_logic;
		seg : out std_logic_vector (6 downto 0);
		an : out std_logic_vector (3 downto 0);
		dp : out std_logic
	);
end top;

architecture behav of top is
	signal rst : std_logic := '0';
	signal button : std_logic;
	signal count : unsigned (3 downto 0);
begin
	hex_to_ss : entity work.hex_to_ss
		port map (hex => std_logic_vector(count), ss => seg);

	debounce : entity work.debounce
		port map (clk => clk, rst => rst,
			  switch => btn0, level => button);

	process (clk, rst)
		-- 100 ms / (1/50 MHz) = 5e6
		-- log2(5e6) = 22.3 = 23
		variable delay : unsigned (22 downto 0);
	begin
		if rst = '1' then
			count <= (others => '0');
			delay := (others => '0');
		elsif rising_edge(clk) then
			if delay = 5e6 then
				delay := (others => '0');
				if button = '1' then
					count <= count + 1;
				end if;
			else
				delay := delay + 1;
			end if;
		end if;
	end process;

	dp <= '1';
	an <= "1110";
end behav;
