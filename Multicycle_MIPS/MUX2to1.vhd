library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity MUX2to1 is
    Port ( a_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           b_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           sel_comp : in  STD_LOGIC;
           output_comp : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX2to1;



architecture Behavioral of MUX2to1 is

begin

	process(a_comp, b_comp, sel_comp)
	begin

		if sel_comp = '0' then
			output_comp <= a_comp;
		elsif sel_comp = '0' then
			output_comp <= b_comp;
		else
			output_comp <= b_comp;
		end if;
	end process;

end Behavioral;

