library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC_ULA is
	port
	(
        ULAop: in std_logic_vector(2 downto 0);
        funct: in std_logic_vector(5 downto 0);

        commandULA: out std_logic_vector(2 downto 0)
	);
end entity;

architecture rtl of UC_ULA is
    constant f_add: std_logic_vector(5 downto 0) := "100000";
    constant f_sub: std_logic_vector(5 downto 0) := "100010";
    constant f_and: std_logic_vector(5 downto 0) := "100100";
    constant f_or:  std_logic_vector(5 downto 0) := "100101";
    constant f_slt: std_logic_vector(5 downto 0) := "101010";

begin
    commandULA <= "000" when (ULAop = "010" and funct = f_and) or (ULAop = "011") else -- and
                  "001" when (ULAop = "010" and funct = f_or)  or (ULAop = "100")  else  -- or
                  "010" when (ULAop = "010" and funct = f_add) or (ULAop = "101") else  -- add
                  "110" when (ULAop = "010" and funct = f_sub) or (ULAop = "001") else  -- sub
                  "111" when (ULAop = "010" and funct = f_slt) or (ULAop = "110") else  -- slt
                  "000";

end architecture;
