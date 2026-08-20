library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PC is
	
	port(	 
	PC_in     : in std_logic_vector(31 downto 0)  ;
	PCWrite   : in std_logic ; 
	
	clk       : in  std_logic;
    reset_neg : in  std_logic;
	
	PC_out    : out std_logic_vector(31 downto 0)
	);	 
	
end PC;



architecture Behavioral of PC is
begin
	
    process(clk, reset_neg)
    begin
        if reset_neg = '0' then
            PC_out <= (others => '0'); 
        elsif rising_edge(clk) and PCWrite = '1'  then
            PC_out <= PC_in; 
        end if;	 
	end process;
   	
end Behavioral;

