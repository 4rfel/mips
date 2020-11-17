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
    -- Declaracoes das functs utilizados
    constant f_add: std_logic_vector(5 downto 0) := "100000";
    constant f_sub: std_logic_vector(5 downto 0) := "100010";
    constant f_and: std_logic_vector(5 downto 0) := "100100";
    constant f_or:  std_logic_vector(5 downto 0) := "100101";
    constant f_slt: std_logic_vector(5 downto 0) := "101010";

begin
    -- Determina pontos de cotrole da ULA.
    commandULA <= "000" when (ULAop = "010" and funct = f_and) or (ULAop = "011") else -- caso operacao AND usada
                  "001" when (ULAop = "010" and funct = f_or)  or (ULAop = "100") else  -- caso operacao OR
                  "010" when (ULAop = "010" and funct = f_add) or (ULAop = "101") or (ULAop = "000") else  -- caso operacao ADD
                  "110" when (ULAop = "010" and funct = f_sub) or (ULAop = "001") else  -- caso operacao SUB
                  "111" when (ULAop = "010" and funct = f_slt) or (ULAop = "110") else  -- caso operacao SLT
                  "000";

end architecture;
