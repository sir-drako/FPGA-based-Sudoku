--------------------------------------------------------------------
-- address counter decoder
--------------------------------------------------------------------

--------------------------------------------------------------------
-- combinational logic component used for determining
-- when to enable the appropiate column

-- this module ensures that the RAM conents
-- (row/column/digit information) is properly
-- "printed" out to the Sudoku game grid
--------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all, ieee.std_logic_1164.all;

entity addr_decoder is
	port(
		-- the current address selected will be bits 7-0, and the 8th bit will be for the
		-- ADDR_OE line
		-- When the address counter is asserting the RAM's address line,
		-- then the normal column selection will take place. However, when the ADDR_OE line becomes LOW,
		-- then the combinational circuit will make sure that all columns are off, so that when the 
		-- position register asserts the RAM line, an erreonous column is not briefly flashed during the write cycle
		D : in std_logic_vector(8 downto 0);
		COL_SEL : out std_logic_vector(8 downto 0);
		SHIFT_OUT : out std_logic
	);
	
end entity addr_decoder;


architecture cathode of addr_decoder is
begin
	-- this code outputs all the loaded shift register values to the output buffer
	SHIFT_OUT	<=	'1' when (D(3 downto 0)="0001") else 
					'0';
	
	-- the following "with select" code handles when to select the correct column 
	-- without causing LED ghosting
	
	-- the "with select" code also handles the column switching once all 
	-- the shift register output buffers are updated
	-- by including the 9th bit, we can avoid the position register turning on a random column
	-- during the RAM write cycle
	
	-- with the external LED driver, the pins are set HIGH so that the appropiate column is turned on
	-- (common cathode)
	with D(8 downto 0) select
	COL_SEL <=  "000000001" when 9x"112" | 9x"113" | 9x"114" | 9x"115" | 9x"116" | 9x"117" | 9x"118",
				"000000010" when 9x"122" | 9x"123" | 9x"124" | 9x"125" | 9x"126" | 9x"127" | 9x"128",
				"000000100" when 9x"132" | 9x"133" | 9x"134" | 9x"135" | 9x"136" | 9x"137" | 9x"138",
				"000001000" when 9x"142" | 9x"143" | 9x"144" | 9x"145" | 9x"146" | 9x"147" | 9x"148",
				"000010000" when 9x"152" | 9x"153" | 9x"154" | 9x"155" | 9x"156" | 9x"157" | 9x"158",
				"000100000" when 9x"162" | 9x"163" | 9x"164" | 9x"165" | 9x"166" | 9x"167" | 9x"168",
				"001000000" when 9x"172" | 9x"173" | 9x"174" | 9x"175" | 9x"176" | 9x"177" | 9x"178",
				"010000000" when 9x"182" | 9x"183" | 9x"184" | 9x"185" | 9x"186" | 9x"187" | 9x"188",
				"100000000" when 9x"102" | 9x"103" | 9x"104" | 9x"105" | 9x"106" | 9x"107" | 9x"108",
				"000000000" when others;			
end cathode;