library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity SignExtend is
    Port ( a_comp : in  STD_LOGIC_VECTOR (15 downto 0);
           b_comp : out  STD_LOGIC_VECTOR (31 downto 0));
end SignExtend;



architecture Behavioral of SignExtend is

begin

	process(a_comp)
	begin

		if a_comp(15) = '0' then
			b_comp(31 downto 16) <=	"0000000000000000";
			b_comp(15 downto 0)  <=	a_comp;
		else
			b_comp(31 downto 16) <=	"1111111111111111";
			b_comp(15 downto 0)  <=	a_comp;

		end if;
	end process;
end Behavioral;

