library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity Shift_Left32To32 is
	port(
	SL_in  : in std_logic_vector(31 downto 0);	 
	
	SL_out : out std_logic_vector(31 downto 0) 
	);
end Shift_Left32To32;



architecture Behavioral of Shift_Left32To32 is 
begin
  
	SL_out <= SL_in(29 downto 0) & "00" ;
	 
 end Behavioral;
