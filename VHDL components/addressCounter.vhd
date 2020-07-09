library ieee;
use ieee.std_logic_1164.all,
	ieee.numeric_std.all;

entity addressCounter is 
	port(
		CLK,CNT_EN,OE : in std_logic;
		Q : out std_logic_vector(7 downto 0) 
	);
end entity addressCounter;

architecture logic of addressCounter is 
	signal temp_Q : std_logic_vector(7 downto 0):=x"00";
	constant COUNTCOLUMN : std_logic_vector(7 downto 0):=x"10";
	constant COUNTROW : std_logic_vector(7 downto 0):=x"01";
begin
	count : process(CLK) is
	begin
		if rising_edge(CLK) then
			if CNT_EN='1' then
				case temp_Q is
					--increase row counter and reset LSBs when at last column
					when x"08"|x"18"|x"28"|x"38"|x"48"|x"58"|x"68"|x"78"  =>
						temp_Q <= std_logic_vector(unsigned(temp_Q) + unsigned(COUNTCOLUMN));
						temp_Q(3 downto 0) <= x"0";

					--reset both when at last row/column
					when x"88" =>
						temp_Q<= x"00";		
					
					--otherwise count through each row
					when others =>
						temp_Q <= std_logic_vector(unsigned(temp_Q) + unsigned(COUNTROW));
						
				end case;
			end if;
		end if;
	end process;
	
	--tri state
	data_out : process(temp_Q,OE) is
	begin
		if OE='0' then
			Q <=x"ZZ";
		else
			--update outputs for next memory address
			Q <= temp_Q;
		end if;
	end process;	
end architecture logic;
