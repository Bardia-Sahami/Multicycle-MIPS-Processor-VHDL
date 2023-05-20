library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- !!! LATCH ISSUE !!!

entity RegisterFile is
    Port ( ReadData1_comp : out  STD_LOGIC_VECTOR (31 downto 0);
           ReadData2_comp : out  STD_LOGIC_VECTOR (31 downto 0);
           rs_comp : in  STD_LOGIC_VECTOR (4 downto 0);
           rt_comp : in  STD_LOGIC_VECTOR (4 downto 0);
           rd_comp : in  STD_LOGIC_VECTOR (4 downto 0);
           WriteData_comp : in  STD_LOGIC_VECTOR (31 downto 0);
			  RegWrite_comp : in STD_LOGIC);
			  
end RegisterFile;



architecture Behavioral of RegisterFile is

	type A is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	signal reg: A;
	signal RegWriteDelay: STD_LOGIC;

begin

	RegWriteDelay <= transport RegWrite_comp after 10 ps;

	process(RegWrite_comp, rd_comp, WriteData_comp)

	begin

		if rs_comp = "00000" then
			ReadData1_comp <= "00000000000000000000000000000000";
		else
			ReadData1_comp <= reg(conv_integer(rs_comp));
		end if;

		if rt_comp = "00000" then
			ReadData2_comp <= "00000000000000000000000000000000";
		else
			ReadData2_comp <= reg(conv_integer(rt_comp));
		end if;

	end process;

	process(RegWrite_comp, WriteData_comp, rd_comp, RegWriteDelay)
		begin
			if RegWriteDelay = '1' AND RegWrite_comp = '1' then
				reg(conv_integer(rd_comp)) <= WriteData_comp;
			else 
				--
			end if;
	end process;

end Behavioral;