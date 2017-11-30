library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		clk  : in std_logic;
		rx   : in std_logic;
		tx   : out std_logic;
		seg  : out std_logic_vector (6 downto 0);
		an   : out std_logic_vector (3 downto 0);
		dp   : out std_logic;
		sw   : in std_logic_vector (7 downto 0);
		led  : out std_logic_vector (7 downto 0);
		btn0 : in std_logic
	);
end top;

architecture behav of top is
	signal rst     : std_logic := '0';
	signal tick    : std_logic;
	signal rx_done : std_logic;
	signal rx_data : std_logic_vector (7 downto 0);
	signal buf     : std_logic_vector (7 downto 0);
	signal button  : std_logic;
	signal tx_done : std_logic;
	signal start   : std_logic;

	type tx_state_type is (IDLE, TRANSMIT);
	signal tx_state, next_tx_state : tx_state_type;
	signal tx_data, next_tx_data : std_logic_vector (7 downto 0);
begin
	-- Baudrate generator: 9600 Baud
	baudrate_gen : entity work.baudrate_gen
		port map (clk => clk, rst => rst, tick => tick);

	-- Multiplexer for seven-segment LED display
	multiplexer : entity work.multiplexer
		port map (
			clk => clk, rst => rst,
			seg => seg, an => an,
			hex0 => buf(3 downto 0),
			hex1 => buf(7 downto 4),
			hex2 => (others => '0'),
			hex3 => (others => '0')
		);

	-- Uart receiver (9600, N, 8, 1)
	uart_rx : entity work.uart_rx
		port map (
			clk => clk, rst => rst,
			tick => tick, rx => rx,
			done => rx_done, data => rx_data
		);

	-- Register for data bytes received by the UART
	process (clk, rst)
	begin
		if rst = '1' then
			buf <= (others => '0');
		elsif rising_edge(clk) then
			if rx_done = '1' then
				buf <= rx_data;
			end if;
		end if;
	end process;

	-- Debouncer for button 0
	debounce : entity work.debounce
		port map (
			clk => clk, rst => rst,
			switch => btn0, level => button
		);

	-- Uart transmitter (9600, N, 8, 1)
	uart_tx : entity work.uart_tx
		port map (
			clk => clk, rst => rst,
			tick => tick, tx => tx,
			start_tx => start,
			done => tx_done, data => tx_data
		);

	-- TX FSM
	process (clk, rst)
	begin
		if rst = '1' then
			tx_state <= IDLE;
			tx_data <= (others => '0');
		elsif rising_edge(clk) then
			tx_state <= next_tx_state;
			tx_data <= next_tx_data;
		end if;
	end process;

	process (tx_state, tx_data, button, sw, tx_done)
	begin
		-- Defaults
		next_tx_state <= tx_state;
		next_tx_data <= tx_data;
		start <= '0';

		case tx_state is
			when IDLE =>
				-- Start transmission on button press
				if button = '1' then
					-- Load switch positions into TX buffer
					next_tx_data <= sw;
					-- Assert tx_start for one clock cycle
					start <= '1';
					-- Transmit data
					next_tx_state <= TRANSMIT;
				end if;

			when TRANSMIT =>
				-- Wait for transmission to finish
				if tx_done = '1' then
					next_tx_state <= IDLE;
				end if;
		end case;
	end process;

	-- Connect switches to LEDs
	led <= sw;

	-- Disable decimal point
	dp <= '1';
end behav;
