library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Reg is
    Port ( input : in  STD_LOGIC_VECTOR (31 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC);
end Reg;



architecture Behavioral of Reg is

begin

	process(input, CLK)

	begin

		if rising_edge(CLK) then
			output<=input;
		else
			--
		end if;
	end process;

end Behavioral;

