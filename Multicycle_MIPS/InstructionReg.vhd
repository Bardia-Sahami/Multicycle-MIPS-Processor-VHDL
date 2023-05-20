library IEEE;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;



entity InstructionReg is
    Port ( Input_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           Output_comp : out  STD_LOGIC_VECTOR (31 downto 0);
           Sig_comp : in  STD_LOGIC;
			  CLK_comp : in STD_LOGIC);
end InstructionReg;



architecture Behavioral of InstructionReg is

begin

	process(Input_comp, Sig_comp, CLK_comp)

	begin
		if rising_edge(CLK_comp) and Sig_comp = '1' then
			Output_comp <= Input_comp;
		else 
			Output_comp <= (others => '0');
		end if;
	end process;

end Behavioral;

