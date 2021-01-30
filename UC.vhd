library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity UC is
    port
    (
        opcode: in std_logic_vector(5 downto 0);
        funct: in std_logic_vector(5 downto 0);


        enableWriteD, enableWriteRAM: out std_logic;
        ULAop: out std_logic_vector(2 downto 0);
        mux_xnw, mux_ime_RT : out std_logic_vector(1 downto 0);
        muxRT_RD, mux_beq_bne, mux_jump_beq, mux_jump_j, mux_jump_jr, muxRT_RD_R31: out std_logic
    );
end entity;

architecture rtl of UC is
    -- Definicao dos OPCODE e FUNCT das instrucoes do MIPS
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

begin
    -- habilita escrita no registrador de destino nos casos necessarios
    enableWriteD <= '1' when (opcode = o_load or opcode = o_addi or opcode = o_ori or opcode = o_andi or
                        opcode = o_slti or (opcode = o_type_r and funct /= f_jr) or opcode = o_jal) else '0';

    -- Comunica ao UC_ULA como ela deve interpretar a instrucao atual e os pontos de controle que tem que ativar
    ULAop <= "000" when (opcode = o_load or opcode = o_store) else
             "001" when (opcode = o_beq or opcode = o_bne)    else
             "010" when (opcode = o_type_r) else
             "011" when (opcode = o_andi)   else
             "100" when (opcode = o_ori)    else
             "101" when (opcode = o_addi)   else
             "110" when (opcode = o_slti)   else
             "111";

    -- Mux que chaveia entre a saida da ULA, RAM ,Signal_Extender do LUI e PC+4 
    mux_xnw <= "01" when opcode = o_load else
               "10" when opcode = o_jal else
               "11" when opcode = o_lui else
               "00";

    -- Mux que chaveia entre RT_RD e Registrador31 (vra)
    muxRT_RD_R31 <= '1' when opcode = o_jal else '0';

    -- Mux que chaveira BRANCH ou PC+4
    mux_jump_beq <= '1' when (opcode = o_beq) or (opcode = o_bne) else '0';

    -- Mux que chaveira entre signal_extender do JUMP ou PC+4/Branch
    mux_jump_j <= '1' when (opcode = o_jmp or opcode = o_jal) else '0';

    -- Mux que chaveira entre registrador de JUMP e PC+4/Branch/Jump
    mux_jump_jr <= '1' when opcode = o_type_r and funct = f_jr else '0';

    -- Mux que escolhe se RT ou RD possui o endereco de escrita
    muxRT_RD <= '1' when (opcode = o_type_r) else '0';

    -- Mux que escolhe qual valor entra na ULA
    mux_ime_RT <= "01" when (opcode = o_load or opcode = o_store or
                             opcode = o_addi or opcode = o_slti) else
                  "10" when (opcode = o_andi or opcode = o_ori) else "00";

    -- habilita a escrita da RAM quando o opcode for store
    enableWriteRAM <= '1' when opcode = o_store else '0';

    -- Mux que chaveira entre tipos de branchs, branch equal ou branch not equal
    mux_beq_bne <= '1' when opcode = o_bne else '0';

end architecture;
