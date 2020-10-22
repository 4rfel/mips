library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC is
	port
	(
        opcode: in std_logic_vector(4 downto 0);
        enableWriteC: std_logic
	);
end entity;

architecture rtl of UC is
    begin

end architecture;