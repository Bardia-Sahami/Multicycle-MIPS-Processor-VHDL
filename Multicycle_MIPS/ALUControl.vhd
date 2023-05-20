library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ALUControl is
    Port ( Func_comp   : in  STD_LOGIC_VECTOR (5 downto 0);
           ALUop_comp  : in  STD_LOGIC_VECTOR (1 downto 0);
           ALUcon_comp : out  STD_LOGIC_VECTOR (3 downto 0));
end ALUControl;



architecture Behavioral of ALUControl is

begin
	process(Func_comp, ALUop_comp)
	begin

		if ALUop_comp = "00" then -- ADD
			ALUcon_comp <= "0000"; 
		elsif ALUop_comp = "01" then -- SUB
			ALUcon_comp <= "0001"; 
		elsif ALUop_comp = "10" then -- Check Function
			if Func_comp = "100000" then -- ADD
				ALUcon_comp <= "0000";
			elsif Func_comp = "100010" then -- SUB
				ALUcon_comp <= "0001";
			elsif Func_comp = "100001" then -- ADDU
				ALUcon_comp <= "0010";
			elsif Func_comp = "100011" then -- SUBU
				ALUcon_comp <= "0011";
			elsif Func_comp = "100100" then -- AND
				ALUcon_comp <= "0100";
			elsif Func_comp = "100101" then -- OR
				ALUcon_comp <= "0101";
			elsif Func_comp = "100110" then -- XOR
				ALUcon_comp <= "0110";
			elsif Func_comp = "100111" then -- NOR
				ALUcon_comp <= "0111";
			elsif Func_comp = "101010" then -- SLT
				ALUcon_comp <= "1000";
			elsif Func_comp = "101011" then -- SLTU
				ALUcon_comp <= "1001";
			elsif Func_comp = "011001" then -- MULTU
				ALUcon_comp <= "1100";
			elsif Func_comp = "010000" then -- MFHI
				ALUcon_comp <= "1101";
			elsif Func_comp = "010010" then -- MFLO
				ALUcon_comp <= "1110";
			else
				ALUcon_comp <= "0000";
			end if;
		 else
			ALUcon_comp <= "0000";
		end if;
	end process;
end Behavioral;

