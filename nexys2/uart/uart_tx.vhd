-- UART TX (9600, N, 8, 1)

-- ghdl -a --std=08 uart_tx.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
	port (
		clk, rst : in std_logic;
		tick : in std_logic;
		start_tx : in std_logic;
		data : in std_logic_vector (7 downto 0);
		tx, done : out std_logic
	);
end entity;

architecture behav of uart_tx is
	type state_type is (IDLE, START, TDATA, STOP);
	signal state, next_state : state_type;

	-- 16 ticks per bit
	constant BITLENGTH : integer := 16;

	-- Shift register (transmit buffer)
	signal shift, next_shift : std_logic_vector (7 downto 0);
	-- Output register (delayed by one clock cycle)
	signal buf, next_buf : std_logic;
	-- Tick counter
	signal tick_count, next_tick_count : unsigned (3 downto 0);
	-- Bit counter (0: LSB, 7: MSB)
	signal n, next_n : unsigned (2 downto 0);
begin
	-- Registers
	process (clk, rst)
	begin
		if rst = '1' then
			state <= IDLE;
			shift <= (others => '0');
			buf <= '1'; -- Idle: high
			tick_count <= (others => '0');
			n <= (others => '0');
		elsif rising_edge(clk) then
			state <= next_state;
			shift <= next_shift;
			buf <= next_buf;
			tick_count <= next_tick_count;
			n <= next_n;
		end if;
	end process;

	-- Connect output register to tx
	tx <= buf;

	-- Next state logic
	process (state, tick, start_tx, data, shift, buf, tick_count, n)
	begin
		-- Defaults
		next_state <= state;
		next_shift <= shift;
		next_buf <= buf;
		next_tick_count <= tick_count;
		next_n <= n;
		done <= '0';

		case state is
			when IDLE =>
				-- Idle : 1
				next_buf <= '1';

				-- Begin with transmission when start signal gets asserted
				if start_tx = '1' then
					-- Reset counter
					next_tick_count <= (others => '0');
					-- Load data into shift buffer
					next_shift <= data;
					-- Transmit start bit
					next_state <= START;
				end if;

			when START =>
				-- Start bit: 0
				next_buf <= '0';

				-- Synchronize to tick signal generated by the baudrate generator
				if tick = '1' then
					if tick_count < (BITLENGTH-1) then
						next_tick_count <= tick_count + 1;
					else
						-- Reset tick counter
						next_tick_count <= (others => '0');
						-- Reset bit counter
						next_n <= (others => '0');
						-- Start transmitting data bits
						next_state <= TDATA;
					end if;
				end if;

			when TDATA =>
				-- Data bits (LSB first)
				next_buf <= shift(0);

				if tick = '1' then
					if tick_count < (BITLENGTH-1) then
						next_tick_count <= tick_count + 1;
					else
						-- Reset tick counter
						next_tick_count <= (others => '0');
						-- Shift transmit buffer, drop LSB
						next_shift <= '0' & shift(7 downto 1);
						-- Check if we have transmitted all data bits
						if n < 7 then
							next_n <= n + 1;
						else
							-- Transmit stop bit
							next_state <= STOP;
						end if;
					end if;
				end if;

			when STOP =>
				-- Stop bit: '1'
				next_buf <= '1';

				if tick = '1' then
					if tick_count < (BITLENGTH-1) then
						next_tick_count <= tick_count + 1;
					else
						-- Assert done signal for one clock cycle
						-- to indicate end of transmission
						done <= '1';
						-- Jump back to the idle state
						next_state <= IDLE;
					end if;
				end if;
		end case;
	end process;
end architecture;
