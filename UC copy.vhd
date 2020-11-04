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
        mux_xnw, muxRT_RD, mux_ime_RT, mux_beq_bne: out std_logic
	);
end entity;

architecture rtl of UC is
    constant f_add: std_logic_vector(5 downto 0) := "100000";
    constant f_sub: std_logic_vector(5 downto 0) := "100010";
    constant f_and: std_logic_vector(5 downto 0) := "100100";
    constant f_or:  std_logic_vector(5 downto 0) := "100101";
    constant f_slt: std_logic_vector(5 downto 0) := "101010";

    constant o_load:  std_logic_vector(5 downto 0) := "100011";
    constant o_beq:   std_logic_vector(5 downto 0) := "000100";
    constant o_jmp:   std_logic_vector(5 downto 0) := "000010";
    constant o_store: std_logic_vector(5 downto 0) := "101011";

    constant o_addi: std_logic_vector(5 downto 0) := "001000";
    constant o_ori:  std_logic_vector(5 downto 0) := "001101";
    constant o_andi: std_logic_vector(5 downto 0) := "001100";
    constant o_slti: std_logic_vector(5 downto 0) := "001010";

    constant o_bne:  std_logic_vector(5 downto 0) := "000101";
    constant o_jal:  std_logic_vector(5 downto 0) := "000011";
    constant f_jr:   std_logic_vector(5 downto 0) := "001000";
    constant o_jr:   std_logic_vector(5 downto 0) := "000000";

    signal tipo_i : std_logic;
    signal write_i : std_logic;

begin
    tipo_i <= '1' when (opcode = o_beq or opcode = o_load or opcode = o_jmp or 
                        opcode = o_addi or opcode = o_ori or opcode = o_andi or
                        opcode = o_slti) else '0';

    write_i <= '1' when (opcode = o_load or opcode = o_addi or opcode = o_ori or opcode = o_andi or
                        opcode = o_slti) else '0';

    enableWriteD <= '1' when (opcode = "000000") or (write_i = '1') else '0';

    commandULA <= "000" when (unsigned(opcode) = 0 and funct = f_and) or (opcode = o_andi) else  -- and
                  "001" when (unsigned(opcode) = 0 and funct = f_or) or (opcode = o_ori) else  -- or
                  "010" when (unsigned(opcode) = 0 and funct = f_add) or (opcode = o_addi) else -- add
                  "011" when (unsigned(opcode) = 0 and funct = f_sub) or (opcode = o_beq) or (opcode = o_bne) else  -- sub
                  "111" when (unsigned(opcode) = 0 and funct = f_slt) or (opcode = o_slti) else  -- menor
                  "000";

    mux_xnw <= '1' when opcode = o_load else '0';

    mux_jump <= "01" when (opcode = o_beq) or (opcode = o_bne) else "10" when opcode = o_jmp else "11" when opcode = o_jmp else "00";

    muxRT_RD <= not tipo_i;

    mux_ime_RT <= tipo_i;

    enableWriteRAM <= '1' when opcode = o_store else '0';

    mux_beq_bne <= '1' when opcode = o_bne else '0';

end architecture;
