LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TB_MIPS IS
END TB_MIPS;

ARCHITECTURE behavior OF TB_MIPS IS 

    COMPONENT MultiCycle_MIPS
        PORT(
            CLKmain_out : out  STD_LOGIC;
            CurrentPC_out : out  STD_LOGIC_VECTOR (31 downto 0);
            NextPC_out : out  STD_LOGIC_VECTOR (31 downto 0);
            ALUout_out : out  STD_LOGIC_VECTOR (31 downto 0);
            CLKmain,reset : in  STD_LOGIC
        );
    END COMPONENT;

    SIGNAL CLKmain,reset : STD_LOGIC := '0';
    SIGNAL CurrentPC_out : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL NextPC_out : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL ALUout_out : STD_LOGIC_VECTOR(31 downto 0);
	 constant clk_period : time := 10 ns;
	 
	 

BEGIN

    uut: MultiCycle_MIPS PORT MAP (
        CurrentPC_out => CurrentPC_out,
        NextPC_out => NextPC_out,
        ALUout_out => ALUout_out,
        CLKmain => CLKmain,
		  reset => reset
    );

   clk_process :process
   begin
		CLKmain <= '0';
		wait for clk_period/2;
		CLKmain  <= '1';
		wait for clk_period/2;
   end process;
   
   stim_proc: process
   begin  
      reset <= '0';
      wait for clk_period*10;
		reset <= '1';
     
      wait;
   end process;

END;