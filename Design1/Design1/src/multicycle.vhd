library ieee;
use ieee.std_logic_1164.all;

entity multicycle is
  port( 	
    CLK        : in std_logic;
    reset_neg  : in std_logic 
	); 
end multicycle;

architecture Behavioral of multicycle is				   

constant PC_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
-- std_logic_vector(31 downto 0)
signal AluOutToMux, ALUOut, ALU_in1, ALU_in2, read_data1_internal, PC_in_internal, 
	read_data2_internal, Jump_address, SL_out_internal_32, output32_internal, 
	ALU_Out_internal, Write_data_internal, Data_In_internal, Data_Out_internal,
	PC_out_internal,result,address_internal, WriteData_internal, MemData_internal, 
	IR_in_internal, IR_out_internal, in_reg_A_internal, in_reg_B_internal, in_reg_ALUOut_internal,
	out_reg_A_internal, out_reg_B_internal, out_reg_ALUOut_internal: std_logic_vector(31 downto 0);	 
-- std_logic_vector(27 downto 0)
signal SL_out_internal_28: std_logic_vector(27 downto 0);
-- std_logic_vector(15 downto 0)
signal input16_internal: std_logic_vector(15 downto 0);
-- std_logic_vector(5 downto 0)
signal op_internal: std_logic_vector(5 downto 0);  
-- std_logic_vector(4 downto 0)
signal Write_register_intrnal: std_logic_vector(4 downto 0);  
-- std_logic_vector(3 downto 0)
signal ALU_control_output: std_logic_vector(3 downto 0);
-- std_logic_vector(1 downto 0)
signal ALUOp_internal, PCSource_internal, ALUSrcB_internal: std_logic_vector(1 downto 0);
-- std_logic
signal PCWrite_inst, ZeroCarry_TL, RegDst_internal, ALUSrcA_internal, MemRead_internal, IRWrite_internal,  
	MemWrite_internal, MemtoReg_internal, RegWrite_internal, Branch_internal,
	Jump_internal, PCWrite_internal, PCWriteCond_internal, IorD_internal: std_logic;
 
	
begin
	
PCWrite_inst <= PCWrite_internal or ( PCWriteCond_internal and ZeroCarry_TL );
Jump_address(31 downto 28) <= PC_out_internal(31 downto 28);

	-- Program Counter
	PC_inst: entity PC  
		port map (
		PC_in     => PC_in_internal,
		PCWrite   => PCWrite_inst,
		CLK       => CLK,
		reset_neg => reset_neg,
		PC_out    => PC_out_internal
		); 	 
 	
	-- MUX 2in 32bit between PC and Memory 
	MUX1_2in_32bit: entity mux_2in_32bit	
		port map(						  
		input_1    => PC_out_internal,
		input_2    => AluOutToMux, 	  

		mux_select => IorD_internal,
		output	   => address_internal
		);	 
		
	-- MEMORY	   
	MEMORY: entity Memory
		port map(
		Address   => address_internal,
		MemWrite  => MemWrite_internal,
        MemRead   => MemRead_internal,
        WriteData => WriteData_internal,
        MemData   => MemData_internal,
		Clock     => CLK,
	    reset_neg => reset_neg
		); 	
		
	-- Instruction_Register	
	INSTRUCTION_REGISTER: entity Instruction_Register
		port map(  
		IR_in     => MemData_internal,
		IRWrite   => IRWrite_internal,
		IR_out	  => IR_out_internal,
		clk       => CLK,
    	reset_neg => reset_neg
		);
	
	-- MDR
	MDR: entity	MDR
		port map(
		Data_In   => MemData_internal,
		Data_Out  => Data_Out_internal,
		Clock     => CLK,  
		reset_neg => reset_neg
		);	  	 
		
	-- Control unit	
	Control_unit: entity Control_Unit
		port map (
		  op          => IR_out_internal(31 downto 26),		
		  RegDst      => RegDst_internal,
		  ALUSrcA     => ALUSrcA_internal,
		  ALUSrcB     => ALUSrcB_internal,
		  MemRead     => MemRead_internal,
		  MemWrite    => MemWrite_internal,
		  MemtoReg    => MemtoReg_internal,
		  RegWrite    => RegWrite_internal,
		  Branch      => Branch_internal,
		  Jump        => Jump_internal,
		  ALUOp       => ALUOp_internal,
		  PCWrite     => PCWrite_internal,
		  PCWriteCond => PCWriteCond_internal,
		  IorD        => IorD_internal,
		  IRWrite     => IRWrite_internal,
		  PCSource    => PCSource_internal,
		  CLK         => CLK,
		  Reset       => reset_neg
		);
	
	-- MUX 2in 5bit between Instruction Register and Registers	
	MUX_2in_5bit: entity mux_2in_5bit	
		port map(						  
		input_1      => IR_out_internal(20 downto 16),
		input_2      => IR_out_internal(15 downto 11), 	  
		mux_select   => RegDst_internal,
		output  	 => Write_register_intrnal
		);						
		
	-- MUX 2in 32bit between MDR and Registers	
	MUX2_2in_32bit: entity mux_2in_32bit	
		port map(						  
		input_1     => AluOutToMux,
		input_2     => Data_Out_internal, 	  

		mux_select  => MemtoReg_internal,
		output	    => Write_data_internal
		);	
	-- Sign Extend
	SignExtend: entity Sign_Extend 
         
		port map (
		input16  => IR_out_internal(15 downto 0),
                   
		output32 => output32_internal
		);	
	
	-- Shift Left 32 to 32  
	ShiftLeft1: entity Shift_Left32To32
         
		port map(
		SL_in  => output32_internal,
                   
		SL_out => SL_out_internal_32
		);			  
		
	-- Shift Left 26 to 28
	ShiftLeft2: entity Shift_Left26To28
         
		port map(
		SL_in  => IR_out_internal(25 downto 0),         
		SL_out => Jump_address(27 downto 0)
		);	  
		
	-- ALU Control
	ALU_CONTROL: entity	ALU_CONTROL
		port map(
		ALUOp  => ALUOp_internal,
		instr  => IR_out_internal(5 downto 0),
	    result => ALU_control_output             
		);	
		
	-- Registers 
	Registers: entity Registers
		port map(
		clk        => CLK,
		reset_neg  => reset_neg,            
		reg_write  => RegWrite_internal,            
		read_reg1  => IR_out_internal(25 downto 21),            
		read_reg2  => IR_out_internal(20 downto 16),           
		write_reg  => Write_register_intrnal,            
		write_data => Write_data_internal,            
		read_data1 => read_data1_internal,           
		read_data2 => read_data2_internal
		);	 
		
	-- ALU
	ALU: entity	ALU
		port map(	 
		operand_1   => ALU_in1,
		operand_2   => ALU_in2,
		ALU_CONTROL => ALU_control_output,
		result      => ALUOut,
		zero        => ZeroCarry_TL
		);	 
		
	-- MUX ARegister and ALU
	MUX3_2in_32bit: entity mux_2in_32bit    
		port map(
		input_1    => PC_out_internal,
		input_2    => out_reg_A_internal,       
        mux_select => ALUSrcA_internal,
		output     => ALU_in1
		);
	
	-- MUX BRegister and ALU
	MUX3_4in_32bit: entity mux_4in_32bit    
		port map(                          
		input_1    => out_reg_B_internal,
		input_2    => PC_increment,
		input_3    => output32_internal,
		input_4    => SL_out_internal_32,
		output     => ALU_in2,
		mux_select => ALUSrcB_internal
		);
		
	-- Last MUX
	MUX_3in_32bit: entity mux_3in_32bit 
		port map(                                 
		input_1    => ALUOut,       
		input_2    => AluOutToMux,        
		input_3    => Jump_address,            
		output     => PC_in_internal,        
		mux_select => PCSource_internal 
		); 
	
	-- Temp Registers
	TempRegisters: entity tempregisters
		port map(
		CLK         => CLK,
        reset_neg   => reset_neg,
        in_reg_A    => read_data1_internal,  
        in_reg_B    => read_data2_internal,
        in_ALU_out  => ALUOut,
        out_reg_A   => out_reg_A_internal,
        out_reg_B   => out_reg_B_internal,					   
        out_ALU_out => AluOutToMux
		);
end Behavioral;
