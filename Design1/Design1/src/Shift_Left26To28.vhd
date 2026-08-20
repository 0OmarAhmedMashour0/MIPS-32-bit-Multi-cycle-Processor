library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Shift_Left26To28 is
	port(
	SL_in  : in std_logic_vector(25 downto 0);	
	
	SL_out : out std_logic_vector(27 downto 0) 
	);		
end Shift_Left26To28;



architecture Behavioral of Shift_Left26To28 is 
begin
  
	SL_out <= SL_in & "00" ;
	 
 end Behavioral;
