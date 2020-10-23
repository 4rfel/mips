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
    signal f_add: std_logic_vector(5 downto 0) := "100000";
    signal f_sub: std_logic_vector(5 downto 0) := "100010";
    signal f_and: std_logic_vector(5 downto 0) := "100100";
    signal f_or: std_logic_vector(5 downto 0) := "100101";
    signal f_less: std_logic_vector(5 downto 0) := "101010";
begin
    enableWriteD <= '1' when opcode = "000000" else '0';
    commandULA <= "000" when (unsigned(opcode) = 0 and funct = f_add) else -- add
                  "001" when (unsigned(opcode) = 0 and funct = f_sub) else  -- sub
                  "010" when (unsigned(opcode) = 0 and funct = f_and) else  -- and
                  "011" when (unsigned(opcode) = 0 and funct = f_or) else  -- or
                  "100" when (unsigned(opcode) = 0 and funct = f_less) else  -- menor
                  "000";

end architecture;
