library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
	port(
	--INPUTS
	clk          : in std_logic;
	reset_neg    : in std_logic;
	reg_write    : in std_logic;
	read_reg1    : in std_logic_vector(4 downto 0);
	read_reg2    : in std_logic_vector(4 downto 0);
	write_reg    : in std_logic_vector(4 downto 0);
	write_data   : in std_logic_vector(31 downto 0);
	--OUTPUTS
	read_data1   : out std_logic_vector(31 downto 0);
	read_data2   : out std_logic_vector(31 downto 0)
	
	);
end Registers;


architecture behavior of Registers is

type register_type is array (0 to 31) of std_logic_vector(31 downto 0);
signal reg : register_type := ((others => (others => '0')));


begin 
	
	
	process(read_reg1,read_reg2,reg)
	begin
		read_data1 <= reg(to_integer(unsigned(read_reg1)));
		read_data2 <= reg(to_integer(unsigned(read_reg2)));
	end process; 
	
	process(clk)
	begin
	 if reset_neg = '0' then -- reset
           reg(to_integer(unsigned(write_reg))) <= (others => '0');	
	 elsif rising_edge(clk) and reg_write='1' and write_reg /="00000" then
	       reg(to_integer(unsigned(write_reg))) <= write_data;
	 end if;
	 
	end process;
	
	
end behavior;