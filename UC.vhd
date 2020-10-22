library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC is
	port
	(
        opcode: in std_logic_vector(5 downto 0);
        funct: in std_logic_vector(5 downto 0);

        enableWriteD: out std_logic;
        commandULA: out std_logic_vector(2 downto 0)

	);
end entity;

architecture rtl of UC is
    begin
        enableWriteD <= '1' when opcode = "000000" else '0';
        commandULA <= "000" when (unsigned(opcode) = 0 and funct = "100000") else -- add
                      "001" when (unsigned(opcode) = 0 and funct = "100010") else  -- sub
                      "010" when (unsigned(opcode) = 0 and funct = "100100") else  -- and
                      "011" when (unsigned(opcode) = 0 and funct = "100101") else  -- or
                      "100" when (unsigned(opcode) = 0 and funct = "101010") else  -- maior
                      "000";

end architecture;