library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC is
	port
	(
        opcode: in std_logic_vector(5 downto 0);

        enableWriteD, enableWriteRAM: out std_logic;
        ULAop: out std_logic_vector(2 downto 0);
        mux_xnw : out std_logic_vector(1 downto 0);
        muxRT_RD, mux_ime_RT, mux_beq_bne, mux_jump_beq, mux_jump_j, mux_jump_jr: out std_logic
	);
end entity;

architecture rtl of UC is
    constant o_load:  std_logic_vector(5 downto 0) := "100011";
    constant o_beq:   std_logic_vector(5 downto 0) := "000100";
    constant o_jmp:   std_logic_vector(5 downto 0) := "000010";
    constant o_store: std_logic_vector(5 downto 0) := "101011";

    constant o_addi: std_logic_vector(5 downto 0) := "001000";
    constant o_ori:  std_logic_vector(5 downto 0) := "001101";
    constant o_andi: std_logic_vector(5 downto 0) := "001100";
    constant o_slti: std_logic_vector(5 downto 0) := "001010";

    constant o_bne:  std_logic_vector(5 downto 0) := "000101";
    constant o_lui:  std_logic_vector(5 downto 0) := "001111";
    constant o_jal:  std_logic_vector(5 downto 0) := "000011";
    constant f_jr:   std_logic_vector(5 downto 0) := "001000";
    constant o_type_r:   std_logic_vector(5 downto 0) := "000000";

    signal tipo_i : std_logic;
    signal write_i : std_logic;

begin
    tipo_i <= '1' when (opcode = o_load or opcode = o_store or opcode = o_jmp or
                        opcode = o_addi or opcode = o_ori or opcode = o_andi or
                        opcode = o_slti) else '0'; -- o_beq and o_bne missing

    write_i <= '1' when (opcode = o_load or opcode = o_addi or opcode = o_ori or opcode = o_andi or
                        opcode = o_slti or opcode = o_type_r) else '0';

    enableWriteD <= '1' when (write_i = '1') else '0';

    ULAop <= "000" when (opcode = o_load or opcode = o_store) else
             "001" when (opcode = o_beq or opcode = o_bne)    else
             "010" when (opcode = o_type_r) else
             "011" when (opcode = o_andi)   else
             "100" when (opcode = o_ori)    else
             "101" when (opcode = o_addi)   else
             "110" when (opcode = o_slti)   else
             "111";

    mux_xnw <= "01" when opcode = o_load else
               "10" when opcode = o_jal else
               "11" when opcode = o_lui else
               "00";

    mux_jump_beq <= '1' when (opcode = o_beq) or (opcode = o_bne) else '0';

    mux_jump_j <= '1' when opcode = o_jmp else '0';

    mux_jump_jr <= '0';

    muxRT_RD <= not tipo_i;

    mux_ime_RT <= tipo_i;

    enableWriteRAM <= '1' when opcode = o_store else '0';

    mux_beq_bne <= '1' when opcode = o_bne else '0';

end architecture;
