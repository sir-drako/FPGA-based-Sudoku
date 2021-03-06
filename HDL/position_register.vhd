--------------------------------------------------------------------
-- DFFE registers
--------------------------------------------------------------------

--------------------------------------------------------------------
-- temporary storage for the player's position input
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity position_register is
	port(
		-- 2 seperate registers for row and column position data
		CLK : in std_logic;
		ROW_EN,COL_EN : in std_logic; -- enable row/column latch 
		ROW_IN,COL_IN : in std_logic_vector(3 downto 0); -- row/column data inputs		
		
		-- bits 7-4 of the output vector will be the column position (MSBs)
		-- bits 3-0 of the output vector will be the row position (LSBs)
		Q : out std_logic_vector(7 downto 0) 
	);
end entity position_register;

architecture logic of position_register is 
begin 
	-- if a clk transition is detected, the enable signals are checked
	-- if ROW_EN is on, then latch in row information (LSBs) 
	-- if COL_EN is on, then latch in column information (MSBs)
	latch_row : process(CLK) is
	begin
		if rising_edge(CLK) then
			if ROW_EN='1' then	
				Q(3 downto 0) <= ROW_IN;
			end if;	
		end if;
	end process;
	
	latch_column : process(CLK) is
	begin
		if rising_edge(CLK) then
			if COL_EN='1' then	
				Q(7 downto 4) <= COL_IN;
			end if;	
		end if;
	end process;
end architecture logic;
