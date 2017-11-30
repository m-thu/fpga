-- Testbench for UART RX

-- ghdl -a --std=08 baudrate_gen.vhd
-- ghdl -a --std=08 uart_rx_tb.vhd
-- ghdl -r --std=08 uart_rx_tb --wave=uart_rx_tb.ghw
-- gtkwave uart_rx_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity uart_rx_tb is
end entity;

architecture behav of uart_rx_tb is
	constant T : time := 20 ns; -- 50 MHz
	constant BITLENGTH : delay_length := 104.167 us; -- 9600 Baud

	signal clk, rst : std_logic := '0';
	signal tick : std_logic := '0';
	signal rx : std_logic := '1';
	signal done : std_logic := '0';
	signal data : std_logic_vector (7 downto 0);

	procedure transmit (
		signal rx : out std_logic;
		constant data : std_logic_vector (0 to 7)
	) is
	begin
		rx <= '0',                       -- Start bit
		      data(0) after 1*BITLENGTH, -- D0
		      data(1) after 2*BITLENGTH, -- D1
		      data(2) after 3*BITLENGTH, -- D2
		      data(3) after 4*BITLENGTH, -- D3
		      data(4) after 5*BITLENGTH, -- D4
		      data(5) after 6*BITLENGTH, -- D5
		      data(6) after 7*BITLENGTH, -- D6
		      data(7) after 8*BITLENGTH, -- D7
		      '1'     after 9*BITLENGTH; -- Stop bit
	end procedure;

begin
	-- Baudrate: 9600
	baudrate_gen : entity work.baudrate_gen
		port map (clk => clk, rst => rst, tick => tick);

	-- Unit under test
	uut : entity work.uart_rx
		--generic map ()
		port map (
			clk => clk, rst => rst, tick => tick,
			rx => rx, done => done, data => data
		);

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

	-- Stimuli
	process
	begin
		wait for 2*T;
	
		--            LSB                                MSB
		--            D0   D1   D2   D3   D4   D5   D6   D7
		transmit(rx, ('0', '0', '0', '0', '0', '0', '0', '0'));
		wait until done;
		report "Sent     data: 00000000";
		report "Received data: " & to_string(data);
		assert data = "00000000";

		--            LSB                                MSB
		--            D0   D1   D2   D3   D4   D5   D6   D7
		transmit(rx, ('1', '1', '1', '1', '1', '1', '1', '1'));
		wait until done;
		report "Sent     data: 11111111";
		report "Received data: " & to_string(data);
		assert data = "11111111";

		--            LSB                                MSB
		--            D0   D1   D2   D3   D4   D5   D6   D7
		transmit(rx, ('1', '0', '1', '0', '1', '0', '1', '0'));
		wait until done;
		report "Sent     data: 01010101";
		report "Received data: " & to_string(data);
		assert data = "01010101";

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
