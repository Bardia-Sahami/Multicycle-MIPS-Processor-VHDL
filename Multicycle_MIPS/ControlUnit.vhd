library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity ControlUnit is
    Port ( OP 				: in  STD_LOGIC_VECTOR (5 downto 0);
           RegDst 		: out  STD_LOGIC;
           MemToReg 		: out  STD_LOGIC;
           RegWrite 		: out  STD_LOGIC;
           MemRead		: out  STD_LOGIC;
           MemWrite 		: out  STD_LOGIC;
			  PCWrite		: out  STD_LOGIC;
			  IorD			: out  STD_LOGIC;
			  IRWrite		: out  STD_LOGIC;
			  ALUop 			: out  STD_LOGIC_VECTOR (1 downto 0);
			  PCSource		: out  STD_LOGIC_VECTOR (1 downto 0);
           ALUSrcB		: out  STD_LOGIC_VECTOR (1 downto 0);
			  ALUSrcA 		: out  STD_LOGIC;
			  Branch			: out  STD_LOGIC;
			  Reset        : in STD_LOGIC;
			  CLK 			: in  STD_LOGIC);
end ControlUnit;




architecture Behavioral of ControlUnit is

	signal currentState : STD_LOGIC_VECTOR(4 downto 0);
 
begin
 
	process(OP, currentState, CLK)
	 
	begin
      if Reset = '0' then 
			currentState <= "11111";
			
	   elsif rising_edge(CLK) then

			   if currentState = "11111" then    -- reset
						currentState <= "00000";
				elsif currentState = "00000" then -- fetch1
						currentState <= "00001";
				elsif currentState = "00001" then -- fetch2
						currentState <= "00010";	
				elsif currentState = "00010" then -- fetch3
						currentState <= "00011";
				elsif currentState = "00011" then -- decoder
						if OP = "100011" or OP = "101011" then
								currentState <= "00100";
						elsif OP = "000000" then
								currentState <= "01000";
						elsif OP = "001000" then
								currentState <= "01100";
						elsif OP = "001110" then
								currentState <= "01110";
						elsif OP = "001101" then
								currentState <= "01111";
						elsif OP = "001100" then
								currentState <= "10001";
						elsif OP = "001011" then
								currentState <= "10000";
						elsif OP = "001111" then
								currentState <= "10010";
						elsif OP = "000100" then
								currentState <= "01010";
						elsif OP = "000101" then
								currentState <= "01011";
						elsif OP = "000010" then
								currentState <= "10100";
						elsif OP = "000011" then
								currentState <= "10011";
						else
								currentState <= "00000";
						end if;
				elsif currentState = "01000" then  -- Rtype Execute
						currentState <= "01001";
				elsif currentState = "01001" then  -- ALU WB
						currentState <= "00000";
				elsif currentState = "01100" then  -- ADDI Execute
						currentState <= "01101";
				elsif currentState = "01101" then  -- ADDI WB
						currentState <= "00000";
				elsif currentState = "01110" then  -- XORI
						currentState <= "01101";
				elsif currentState = "01111" then  -- ORI
						currentState <= "01101";
				elsif currentState = "10001" then  -- ANDI
						currentState <= "01101";
				elsif currentState = "10000" then  -- SLTI 
						currentState <= "01101";
				elsif currentState = "10010" then  -- LUI
						currentState <= "01101";
				elsif currentState = "01010" then  -- BEQ
						currentState <= "00000";
				elsif currentState = "01011" then  -- BNEQ
						currentState <= "00000";
				elsif currentState = "10100" then  -- JMP
						currentState <= "00000";
				elsif currentState = "10011" then  -- JAL
						currentState <= "00000";
				elsif currentState = "00100" then  -- MemAdr
						if OP = "100011" then
								currentState <= "00101";
						else
								currentState <= "00111";
						end if;
				elsif currentState = "00101" then  -- MemRead
						currentState <= "00110";
				elsif currentState = "00110" then  -- Mem WB
						currentState <= "00000";
				elsif currentState = "00111" then  -- MemWrite
						currentState <= "00000";
				else
						currentState <= "00000";
				end if;
		end if;
	
	
	  --instruction fetch first       
	  if currentState = "00000" then
			  Branch <= '0';
			  PCWrite <= '1';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '1';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "01";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --instruction fetch second      
	  elsif currentState = "00001" then
			  Branch <= '0';
			  PCWrite <= '1';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '1';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "01";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --instruction fetch third     
	  elsif currentState = "00010" then
			  Branch <= '0';
			  PCWrite <= '1';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '1';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "01";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
     --decode     
	  elsif currentState = "00011" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "11";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
     --memAdr   
	  elsif currentState = "00100" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "10";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
     --memRead   
	  elsif currentState = "00101" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '1';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
     --memWriteBack
	  elsif currentState = "00110" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '1';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '1';
			  RegDst <= '0';
			  
	  --memWrite
	  elsif currentState = "00111" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '1';
			  MemRead <= '0';
			  MemWrite <= '1';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --rtype exe
	  elsif currentState = "01000" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "10";
			  ALUSrcB <= "00";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --ALUWrtieback
	  elsif currentState = "01001" then
	 		  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '1';
			  RegDst <= '1';
			  
	  --branch
	  elsif currentState = "01010" then
			  Branch <= '1';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "01";
			  ALUOp <= "01";
			  ALUSrcB <= "00";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --BNEQ
	  elsif currentState = "01011" then
			  Branch <= '1';
			  PCWrite <= '1';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "01";
			  ALUOp <= "01";
			  ALUSrcB <= "00";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --ADDI exe
	  elsif currentState = "01100" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "10";
			  ALUOp <= "00";
			  ALUSrcB <= "10";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --ADDI writeback
	  elsif currentState = "01101" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '1';
			  RegDst <= '0';
			  
	  --XORI
	  elsif currentState = "01110" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "10";
			  ALUOp <= "10";
			  ALUSrcB <= "10";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --ORI
	  elsif currentState = "01111" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "10";
			  ALUOp <= "00";
			  ALUSrcB <= "10";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --SLTI
	  elsif currentState = "10000" then
			  Branch <= '0';
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
      	  PCSource <= "10";
      	  ALUOp <= "11";
			  ALUSrcB <= "10";
			  ALUSrcA <= '1';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --ADDI
	  elsif currentState = "10001" then
			  Branch <= '0';
     		  PCWrite <= '0';
        	  IorD <= '0';
			  MemRead <= '1';
           MemWrite <= '0';
           IRWrite <= '0';
           MemtoReg <= '0';
           PCSource <= "10";
           ALUOp <= "00";
           ALUSrcB <= "10";
           ALUSrcA <= '1';
           RegWrite <= '0';
           RegDst <= '0';

	  --LUI
	  elsif currentState = "10010" then
			  Branch <= '0';
     		  PCWrite <= '0';
        	  IorD <= '0';
			  MemRead <= '1';
           MemWrite <= '0';
           IRWrite <= '0';
           MemtoReg <= '0';
           PCSource <= "10";
           ALUOp <= "10";
           ALUSrcB <= "10";
           ALUSrcA <= '1';
           RegWrite <= '0';
           RegDst <= '0';

	  --JAL
	  elsif currentState = "10011" then
			  Branch <= '0';
     		  PCWrite <= '1';
        	  IorD <= '0';
			  MemRead <= '1';
           MemWrite <= '0';
           IRWrite <= '0';
           MemtoReg <= '0';
           PCSource <= "10";
           ALUOp <= "00";
           ALUSrcB <= "00";
           ALUSrcA <= '0';
           RegWrite <= '1';
           RegDst <= '0';

	  --J
	  elsif currentState = "10100" then
			  Branch <= '0';
     		  PCWrite <= '1';
        	  IorD <= '0';
			  MemRead <= '1';
           MemWrite <= '0';
           IRWrite <= '0';
           MemtoReg <= '0';
           PCSource <= "10";
           ALUOp <= "00";
           ALUSrcB <= "00";
           ALUSrcA <= '0';
           RegWrite <= '0';
           RegDst <= '0';
	  --reset
	  elsif currentState = "11111" then
			  Branch <= '0';
			  PCWrite <= '1';
			  IorD <= '0';
			  MemRead <= '1';
			  MemWrite <= '0';
			  IRWrite <= '1';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "01";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
			  
	  --exception
	  else
			  PCWrite <= '0';
			  IorD <= '0';
			  MemRead <= '0';
			  MemWrite <= '0';
			  IRWrite <= '0';
			  MemtoReg <= '0';
			  PCSource <= "00";
			  ALUOp <= "00";
			  ALUSrcB <= "00";
			  ALUSrcA <= '0';
			  RegWrite <= '0';
			  RegDst <= '0';
	  end if;
	end process;
 
end Behavioral;

