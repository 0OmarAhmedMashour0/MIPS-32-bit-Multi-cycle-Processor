library IEEE;
use IEEE.STD_LOGIC_1164.all;   

entity Instruction_Register is
	port(	 
	IR_in     : in  std_logic_vector(31 downto 0);
	IRWrite   : in  std_logic;
	
	clk       : in  std_logic;
    reset_neg : in  std_logic;
	
	IR_out    : out  std_logic_vector(31 downto 0)
	);

end Instruction_Register;



architecture Behavioral of Instruction_Register is 
begin
	
	 process(clk, reset_neg)
     begin
        if reset_neg = '0' then
            IR_out <= (others => '0'); 
        elsif rising_edge(clk) and IRWrite = '1'  then
            IR_out <= IR_in; 
        end if;	 
	end process;
	 

end Behavioral;
