library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC is
	port
	(
        opcode: in std_logic_vector(5 downto 0);
        funct: in std_logic_vector(5 downto 0);

        enableWriteD, enableWriteRAM: out std_logic;
        commandULA: out std_logic_vector(2 downto 0);
        mux_jump : out std_logic_vector(1 downto 0);
        mux_xnw, muxRT_RD, mux_ime_RT: out std_logic
	);
end entity;

architecture rtl of UC is
    constant f_add: std_logic_vector(5 downto 0) := "100000";
    constant f_sub: std_logic_vector(5 downto 0) := "100010";
    constant f_and: std_logic_vector(5 downto 0) := "100100";
    constant f_or:  std_logic_vector(5 downto 0) := "100101";
    constant f_less: std_logic_vector(5 downto 0) := "101010";

    constant f_load:  std_logic_vector(5 downto 0) := "100011";
    constant f_beq:   std_logic_vector(5 downto 0) := "000100";
    constant f_jmp:   std_logic_vector(5 downto 0) := "000010";
    constant f_store: std_logic_vector(5 downto 0) := "101011";

begin
    enableWriteD <= '1' when (opcode = "000000") or (opcode = f_load) else '0';
    commandULA <= "000" when (unsigned(opcode) = 0 and funct = f_add) else -- add
                  "001" when (unsigned(opcode) = 0 and funct = f_sub) else  -- sub
                  "010" when (unsigned(opcode) = 0 and funct = f_and) else  -- and
                  "011" when (unsigned(opcode) = 0 and funct = f_or) else  -- or
                  "100" when (unsigned(opcode) = 0 and funct = f_less) else  -- menor
                  "000";
    mux_xnw <= '1' when opcode = f_load else '0';
    mux_jump <= "01" when opcode = f_beq else "10" when opcode = f_jmp else "00";
    muxRT_RD <= '0' when opcode = f_beq or opcode = f_load or opcode = f_jmp else '1';
    mux_ime_RT <= '1' when opcode = f_beq or opcode = f_load or opcode = f_jmp else '0';
    enableWriteRAM <= '1' when opcode = f_store else '0';


end architecture;
