library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity shift_left is
    generic ( 
            data_width : natural := 8;
            shift_amount : natural := 1);
	port (
		A : in std_logic_vector((data_width-1) downto 0);
		outp : out std_logic_vector((data_width-1) downto 0)
	);
end entity;

architecture rtl of shift_left is
	begin
        process is
            outp <= shift_left(unsigned(A), shift_amount);
        end process;

end architecture;