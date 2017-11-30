-- Testbench for UART TX

-- ghdl -a --std=08 baudrate_gen.vhd
-- ghdl -a --std=08 uart_rx.vhd
-- ghdl -a --std=08 uart_tx_tb.vhd
-- ghdl -r --std=08 uart_tx_tb --wave=uart_tx_tb.ghw
-- gtkwave uart_tx_tb.ghw

library ieee;
use ieee.std_logic_1164.all;

entity uart_tx_tb is
end entity;

architecture behav of uart_tx_tb is
	constant T : time := 20 ns; -- 50 MHz
	constant BITLENGTH : delay_length := 104.167 us; -- 9600 Baud

	signal clk, rst : std_logic := '0';
	signal tick : std_logic := '0';
	signal tx_to_rx : std_logic := '1';
	signal start : std_logic := '0';
	signal tx_done, rx_done : std_logic := '0';
	signal tx_data, rx_data : std_logic_vector (7 downto 0);
begin
	-- Baudrate generator: 9600 Baud
	baudrate_gen : entity work.baudrate_gen
		port map (clk => clk, rst => rst, tick => tick);

	-- UART receiver (9600, N, 8, 1)
	uart_rx : entity work.uart_rx
		port map (
			clk => clk, rst => rst, tick => tick,
			rx => tx_to_rx, done => rx_done,
			data => rx_data
		);

	-- Unit under test
	uut : entity work.uart_tx
		--generic map ()
		port map (
			clk => clk, rst => rst, tick => tick,
			start_tx => start, data => tx_data,
			tx => tx_to_rx, done => tx_done
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

		tx_data <= x"00";
		start <= '1';
		wait for T;
		start <= '0';
		wait until rx_done;
		wait until tx_done;
		report "Sent data    : " & to_string(tx_data);
		report "Received data: " & to_string(rx_data);
		assert tx_data = rx_data;

		tx_data <= x"ff";
		wait for T;
		start <= '1';
		wait for T;
		start <= '0';
		wait until rx_done;
		wait until tx_done;
		report "Sent data    : " & to_string(tx_data);
		report "Received data: " & to_string(rx_data);
		assert tx_data = rx_data;

		tx_data <= x"aa";
		wait for T;
		start <= '1';
		wait for T;
		start <= '0';
		wait until rx_done;
		wait until tx_done;
		report "Sent data    : " & to_string(tx_data);
		report "Received data: " & to_string(rx_data);
		assert tx_data = rx_data;

		assert false report "Testbench finished!"
			severity failure;
	end process;
end architecture;
