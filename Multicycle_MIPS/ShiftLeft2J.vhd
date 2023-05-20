library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ShiftLeft2J is
    Port ( a_comp : in  STD_LOGIC_VECTOR (25 downto 0);
           b_comp : out  STD_LOGIC_VECTOR (27 downto 0));
end ShiftLeft2J;



architecture Behavioral of ShiftLeft2J is

begin

	b_comp(27 downto 2) <= a_comp(25 downto 0);
	b_comp(1 downto 0) <= "00";

end Behavioral;

