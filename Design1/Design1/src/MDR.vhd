library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDR is 
	Port(
	--INPUTS
	Clock     : in std_logic;
	Data_In   : in std_logic_vector(31 downto 0);
	reset_neg : in std_logic;	
	--OUTPUTS
	Data_Out  : out std_logic_vector(31 downto 0)
	);
end MDR;

architecture behavior of MDR is
  type mem_data_type is array (0 downto 0) of std_logic_vector(31 downto 0);
  signal MemDataReg: mem_data_type := ((others => (others => '0')));
Begin
	process(Clock)
	begin
	if reset_neg = '0' then -- reset
           MemDataReg(0) <= (others => '0');
	elsif rising_edge(Clock) then
		   MemDataReg(0) <= Data_In;
		   end if;
	end process;
	
	
	Data_Out <= MemDataReg(0);
	
end behavior;