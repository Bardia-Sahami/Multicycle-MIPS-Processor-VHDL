library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MultiCycle_MIPS is
    Port ( CLKmain_out : out  STD_LOGIC;
	CurrentPC_out : out  STD_LOGIC_VECTOR (31 downto 0);
	 NextPC_out : out  STD_LOGIC_VECTOR (31 downto 0);
	 ALUout_out : out  STD_LOGIC_VECTOR (31 downto 0);
	 CLKmain, Reset : in  STD_LOGIC);
end MultiCycle_MIPS;

architecture Behavioral of MultiCycle_MIPS is

COMPONENT ALUControl
	PORT(
		Func_comp : IN std_logic_vector(5 downto 0);
		ALUop_comp : IN std_logic_vector(1 downto 0);          
		ALUcon_comp : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
COMPONENT ALU
	PORT(
		A_comp : IN std_logic_vector(31 downto 0);
		B_comp : IN std_logic_vector(31 downto 0);
		ALUControl_comp : IN std_logic_vector(3 downto 0);          
		Output_comp : OUT std_logic_vector(31 downto 0);
		Zero_comp : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT ControlUnit
	PORT(
		OP : IN std_logic_vector(5 downto 0);
		CLK : IN std_logic;          
		RegDst : OUT std_logic;
		MemToReg : OUT std_logic;
		RegWrite : OUT std_logic;
		MemRead : OUT std_logic;
		MemWrite : OUT std_logic;
		Branch : OUT std_logic;
		PCWrite : OUT std_logic;
		IorD : OUT std_logic;
		IRWrite : OUT std_logic;
		ALUop : OUT std_logic_vector(1 downto 0);
		PCSource : OUT std_logic_vector(1 downto 0);
		ALUSrcB : OUT std_logic_vector(1 downto 0);
		Reset   : IN std_logic; 
		ALUSrcA : OUT std_logic
		);
	END COMPONENT;

--MUX 2 input 32 Bit--	
COMPONENT MUX2to1
	PORT(
		a_comp : IN std_logic_vector(31 downto 0);
		b_comp : IN std_logic_vector(31 downto 0);
		sel_comp : IN std_logic;          
		output_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
--MUX 2 input 5 Bit--	
COMPONENT MUXRegDst
	PORT(
		a_comp : IN std_logic_vector(4 downto 0);
		b_comp : IN std_logic_vector(4 downto 0);
		sel_comp : IN std_logic;          
		output_comp : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

--MUX 4 input 32 bit--	
COMPONENT MUX4to1
	PORT(
		a_comp : IN std_logic_vector(31 downto 0);
		b_comp : IN std_logic_vector(31 downto 0);
		c_comp : IN std_logic_vector(31 downto 0);
		d_comp : IN std_logic_vector(31 downto 0);
		sel_comp : IN std_logic_vector(1 downto 0);          
		output_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT Memory
	PORT(
		memwrite_comp : IN std_logic;
		memread_comp : IN std_logic;
		Wdata_comp : IN std_logic_vector(31 downto 0);
		address_comp : IN std_logic_vector(31 downto 0);
		IORD_comp : IN std_logic;
		CLK_comp : IN std_logic;          
		Rdata_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

COMPONENT InstructionReg
	PORT(
		Input_comp : IN std_logic_vector(31 downto 0);
		Sig_comp : IN std_logic;
		CLK_comp : IN std_logic;          
		Output_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT Reg
	PORT(
		input : IN std_logic_vector(31 downto 0);
		CLK : IN std_logic;          
		output : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT RegisterFile
	PORT(
		rs_comp : IN std_logic_vector(4 downto 0);
		rt_comp : IN std_logic_vector(4 downto 0);
		rd_comp : IN std_logic_vector(4 downto 0);
		WriteData_comp : IN std_logic_vector(31 downto 0);
		RegWrite_comp : IN std_logic;        
		ReadData1_comp : OUT std_logic_vector(31 downto 0);
		ReadData2_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT ShiftLeft2
	PORT(
		a_comp : IN std_logic_vector(31 downto 0);          
		b_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT ShiftLeft2J
	PORT(
		a_comp : IN std_logic_vector(25 downto 0);          
		b_comp : OUT std_logic_vector(27 downto 0)
		);
	END COMPONENT;
	
COMPONENT SignExtend
	PORT(
		a_comp : IN std_logic_vector(15 downto 0);          
		b_comp : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	signal ZeroFlag,sigBranch,sigPCWrite,sigIorD,sigMemRead,sigMemWrite,sigMemToReg,sigIRWrite,sigALUSrcA,sigRegWrite,sigRegDst:std_logic;
	signal sigPCSource,sigALUSrcB,sigALUOp: std_logic_vector(1 downto 0);
	signal Instruction,PCin,PCout,ALUOutout,sigaddress,MEMout,MemDatain,MDRout,WriteDatain,Ain,Bin,SignExtendOut,ShiftLeftOut,Aout,ALUin1,ALUin2,ALUresult: std_logic_vector(31 downto 0);
	signal WriteRegisterin: std_logic_vector (4 downto 0);
	signal op: std_logic_vector (3 downto 0);
	signal PCJump: std_logic_vector (31 downto 0);
	
begin

	CLKmain_out <= CLKmain;
	ALUOut_out <= ALUOutout;
	CurrentPC_out <= PCout;
	NextPC_out <= PCin;
	Inst_ALUControl: ALUControl PORT MAP(
		Func_comp => Instruction(5 downto 0),
		ALUop_comp => sigALUOp,
		ALUcon_comp => op
	);
	
	Inst_ALU: ALU PORT MAP(
		A_comp => ALUin1,
		B_comp => ALUin2,
		ALUControl_comp => op,
		Output_comp => ALUresult,
		Zero_comp => ZeroFlag
	);
	
	MemoryDataRegister: Reg PORT MAP(
		input => MEMout,
		output => MDRout,
		CLK => CLKmain
	);

	Inst_ControlUnit: ControlUnit PORT MAP(
		OP => Instruction(31 downto 26),
		RegDst => sigRegDst,
		MemToReg => sigMemtoReg,
		RegWrite => sigRegWrite,
		MemRead => sigMemRead,
		MemWrite => sigMemWrite,
		Branch => sigBranch,
		PCWrite => sigPCWrite,
		IorD => sigIorD,
		IRWrite => sigIRWrite,
		ALUop => sigALUOp,
		PCSource => sigPCSource,
		ALUSrcB => sigALUSrcB,
		ALUSrcA => sigALUSrcA,
		Reset => Reset,
		CLK => CLKmain
	);
	
	Inst_InstructionReg: InstructionReg PORT MAP(
		Input_comp => MEMout,
		Output_comp => Instruction,
		Sig_comp => sigIRWrite,
		CLK_comp => CLKmain
	);
	
	PC: InstructionReg PORT MAP(
		Input_comp => PCin,
		Output_comp => PCout,
		Sig_comp => (ZeroFlag and sigBranch) or sigPCWrite,
		CLK_comp => CLKmain
	);
	
	ALUmux: MUX2to1 PORT MAP(
		a_comp => ALUOutout,
		b_comp => MDRout,
		sel_comp => sigMemtoReg,
		output_comp => WriteDatain
	);
	
	MUXmem: MUX2to1 PORT MAP(
		a_comp => PCout,
		b_comp => ALUOutout,
		sel_comp => sigIorD,
		output_comp => sigaddress
	);
	
	MUXregA: MUX2to1 PORT MAP(
		a_comp => PCout,
		b_comp => Aout,
		sel_comp => sigALUSrcA,
		output_comp => ALUin1
	);

	MUXregB: MUX4to1 PORT MAP(
		a_comp => MemDatain,
		b_comp => "00000000000000000000000000000100",
		c_comp => SignExtendOut,
		d_comp => ShiftLeftOut,
		sel_comp => sigALUSrcB,
		output_comp => ALUin2
	);
	
	MUXpc: MUX4to1 PORT MAP(
		a_comp => ALUresult,
		b_comp => ALUOutout,
		c_comp => PCJump,
		d_comp => "00000000000000000000000000000000",
		sel_comp => sigPCsource,
		output_comp => PCin
	);
	
	Inst_MUXRegDst: MUXRegDst PORT MAP(
		a_comp => Instruction(20 downto 16),
		b_comp => Instruction(15 downto 11),
		sel_comp => sigRegDst,
		output_comp => WriteRegisterin 
	);
	
	Inst_Memory: Memory PORT MAP(
		memwrite_comp => sigMemWrite,
		memread_comp => sigMemRead,
		Wdata_comp => MemDataIn,
		Rdata_comp => MemOut,
		address_comp => sigAddress,
		IORD_comp => sigIorD,
		CLK_comp => CLKmain
	);

	RegA: Reg PORT MAP(
		input => Ain,
		output => Aout,
		CLK => CLKmain
	);

	RegB: Reg PORT MAP(
		input => Bin,
		output => MemDatain,
		CLK => CLKmain 
	);
	
	RegALUout: Reg PORT MAP(
		input => ALUresult,
		output => ALUOutout,
		CLK => CLKmain
	);
	
	Inst_RegisterFile: RegisterFile PORT MAP(
		ReadData1_comp => Ain,
		ReadData2_comp => Bin,
		rs_comp => Instruction(25 downto 21),
		rt_comp => Instruction(20 downto 16),
		rd_comp => WriteRegisterin,
		WriteData_comp => WriteDataIn,
		RegWrite_comp => sigRegWrite
	);
	
	Inst_ShiftLeft2: ShiftLeft2 PORT MAP(
		a_comp => SignExtendOut,
		b_comp => ShiftLeftOut
	);
	
	Inst_ShiftLeft2_J: ShiftLeft2J PORT MAP(
		a_comp => Instruction(25 downto 0),
		b_comp => PCJump(27 downto 0)
	);
	PCJump (31 downto 28) <= PCOut (31 downto 28);
	

	Inst_SignExtend: SignExtend PORT MAP(
		a_comp => Instruction(15 downto 0),
		b_comp => SignExtendOut
	);

end Behavioral;

