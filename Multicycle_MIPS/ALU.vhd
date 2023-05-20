library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ALU is
    Port ( A_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           B_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUControl_comp : in  STD_LOGIC_VECTOR (3 downto 0);
           Output_comp : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero_comp : out  STD_LOGIC);
end ALU;



architecture Behavioral of ALU is

	signal multi : STD_LOGIC_VECTOR (63 downto 0);
	signal hi, lo : STD_LOGIC_VECTOR (32 downto 0);

begin

	process(A_comp, B_comp, ALUControl_comp)

	begin
		Output_comp <= (others => '0');
		--multi <= (others => '0');
		if (ALUControl_comp = "0100") then -- AND
			Output_comp <= A_comp AND B_comp;
		elsif (ALUControl_comp = "0101") then -- OR 
			Output_comp <= A_comp OR B_comp;
		elsif (ALUControl_comp = "0000") then -- ADD
			Output_comp <= A_comp + B_comp;
		elsif (ALUControl_comp = "0010") then -- ADDU
			Output_comp <= unsigned(A_comp) + unsigned(B_comp);
		elsif (ALUControl_comp = "0001") then -- SUB
			Output_comp <= A_comp - B_comp;
		elsif (ALUControl_comp = "1000") then -- SLT
			if (A_comp < B_comp) then
				Output_comp <= "00000000000000000000000000000001";
			else
				Output_comp <= "00000000000000000000000000000000";
			end if;
		elsif (ALUControl_comp = "1001") then -- SLTU
			if (unsigned(A_comp) < unsigned(B_comp)) then
				Output_comp <= "00000000000000000000000000000001";
			else
				Output_comp <= "00000000000000000000000000000000";
			end if;
		elsif (ALUControl_comp = "0011") then -- SUBU
			Output_comp <= unsigned(A_comp) - unsigned(B_comp);
		elsif (ALUControl_comp = "0111") then -- NOR
			Output_comp <= A_comp NOR B_comp;
		elsif (ALUControl_comp = "0110") then -- XOR
			Output_comp <= A_comp XOR B_comp;
		elsif (ALUControl_comp = "1101") then -- MULTI/HI (MFHI)
			Output_comp <= multi (63 downto 32);
		elsif (ALUControl_comp = "1110") then -- MULTI/LO (MFLO)
			Output_comp <= multi (31 downto 0);
		elsif (ALUControl_comp = "1100") then -- MULTIU
			multi <= unsigned(A_comp) * unsigned(B_comp);
		else
			Output_comp <= (others => '0');
			--multi <= (others => '0');
		end if;

		if (A_comp = B_comp) then
			Zero_comp <= '1';
		else
			Zero_comp <= '0';
		end if;

	end process;

end Behavioral;