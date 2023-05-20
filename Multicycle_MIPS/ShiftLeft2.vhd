library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ShiftLeft2 is
    Port ( a_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           b_comp : out  STD_LOGIC_VECTOR (31 downto 0));
end ShiftLeft2;



architecture Behavioral of ShiftLeft2 is

begin

	b_comp(31 downto 2) <= a_comp(29 downto 0);
	b_comp(1 downto 0) <= "00";

end Behavioral;

