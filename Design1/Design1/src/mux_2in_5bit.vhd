library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2in_5bit is
	port(
	--input
	input_1   : in std_logic_vector(4 downto 0);
	input_2   : in std_logic_vector(4 downto 0);
	mux_select: in std_logic;
	
	--output
	output    :	out std_logic_vector(4 downto 0)	
	);
end mux_2in_5bit;

architecture Behavioral of mux_2in_5bit is
begin 
	with mux_select select
	output <= input_1 when '0',
	          input_2 when others;
end Behavioral;