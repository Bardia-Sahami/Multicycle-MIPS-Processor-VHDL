library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- !! UNKNOWN WARNINGS !!

entity Memory is
    Port ( memwrite_comp : in  STD_LOGIC;
           memread_comp : in  STD_LOGIC;
           Wdata_comp : in  STD_LOGIC_VECTOR (31 downto 0);
           Rdata_comp : out  STD_LOGIC_VECTOR (31 downto 0);
           address_comp : in  STD_LOGIC_VECTOR (31 downto 0);
			  IORD_comp: in  STD_LOGIC;
           CLK_comp : in  STD_LOGIC);
end Memory;



architecture Behavioral of Memory is

	type A is  array ( 0 to 63) of STD_LOGIC_VECTOR(7 downto 0);
	signal mem2: A;
	signal mem : A := ( X"20",X"08",X"00",X"0A",X"20",X"09",X"00",X"06",
							  X"20",X"0A",X"00",X"06",X"01",X"09",X"58",X"20",
							  X"AD",X"0B",X"00",X"00",X"11",X"2A",X"00",X"01",
							  X"8D",X"0C",X"00",X"00",X"8D",X"0D",X"00",X"00",
							  X"11",X"09",X"00",X"02",X"01",X"09",X"70",X"24",
							  X"01",X"09",X"78",X"25",X"01",X"09",X"80",X"22",
							  X"01",X"09",X"88",X"2A",X"01",X"28",X"90",X"2A",
							  X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00");

begin

	process(Wdata_comp, address_comp, memread_comp, memwrite_comp, CLK_comp, IORD_comp)

	begin
		--if instruction
		if(memread_comp = '1' and memwrite_comp = '0' and IORD_comp = '0') then
			Rdata_comp(31 downto 24)<= mem(conv_integer(address_comp));
			Rdata_comp(23 downto 16)<= mem(conv_integer(address_comp)+1);
			Rdata_comp(15 downto 8) <= mem(conv_integer(address_comp)+2);
			Rdata_comp(7 downto 0)  <= mem(conv_integer(address_comp)+3);
		--if read and data
		elsif(memread_comp = '1' and memwrite_comp = '0' and IORD_comp = '1') then
			Rdata_comp(31 downto 24)<= mem2(conv_integer(address_comp));
			Rdata_comp(23 downto 16)<= mem2(conv_integer(address_comp)+1);
			Rdata_comp(15 downto 8) <= mem2(conv_integer(address_comp)+2);
			Rdata_comp(7 downto 0)  <= mem2(conv_integer(address_comp)+3);
		--if write and data, write in array mem2.
		elsif(memread_comp = '0' and memwrite_comp = '1' and rising_edge(CLK_comp) and IORD_comp = '1') then
			mem2(conv_integer(address_comp))  <= Wdata_comp(31 downto 24);
			mem2(conv_integer(address_comp)+1)<= Wdata_comp(23 downto 16);
			mem2(conv_integer(address_comp)+2)<= Wdata_comp(15 downto 8);
			mem2(conv_integer(address_comp)+3)<= Wdata_comp(7 downto 0);
		else
			--
		end if;
	end process;

end Behavioral;