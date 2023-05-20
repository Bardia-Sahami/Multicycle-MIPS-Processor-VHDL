library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MUX4to1 is
    Port ( a_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           b_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           c_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           d_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           sel_comp : in  STD_LOGIC_VECTOR (1 downto 0);
           output_comp : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX4to1;



architecture Behavioral of MUX4to1 is

begin

	process(a_comp, b_comp, c_comp, d_comp, sel_comp)
	begin

		if sel_comp = "00" then 
			output_comp <= a_comp;
		elsif sel_comp = "01" then 
			output_comp <= b_comp;
		elsif sel_comp = "10" then 
			output_comp <= c_comp; 
		elsif sel_comp = "11" then 
			output_comp <= d_comp;
		else
			output_comp <= d_comp;
		end if;

	end process;

end Behavioral;

