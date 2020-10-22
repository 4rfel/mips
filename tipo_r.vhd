library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity inc is
	generic
	(
        rom_width : natural := 32
        regs_address_width : natural :=5
        word_width : natural := 31
    );
    port
    (
        clk : in std_logic
    );
end entity;

architecture rtl of inc is
    signal outPC, outInc, outRom, outIR : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
    signal opcode, CTRULA : std_logic_vector(5 downto 0); 
    signal RSEND, RTEND, RDEND : std_logic_vector((regs_address_width-1) downto 0);
    signal outA, outB, outULA : std_logic_vector((word_width-1) downto 0);
    signal enableWriteC : std_logic;

    begin
        opcode <= outIR(31 downto 26);
        RSEND <= outIR(25 downto 21);
        RTEND <= outIR(20 downto 16);
        RDEND <= outIR(15 downto 11);
        CTRULA <= outIR(5 downto 0);


        rom_component: entity work.ROM
        port map(address => outPC,
                data => outRom);
        
        IR_component: entity work.registrador
        port map(DIN => outRom,
                DOUT => outIR,
                ENABLE => '1',
                CLK => clk,
                RST => '0');

        PC_component: entity work.registrador
        port map(DIN => outInc,
                DOUT => outPC,
                ENABLE => '1',
                CLK => clk,
                RST => '0');

        adder_component: entity work.adder
        port map(A => outPC,
                B => (others=>'0') & "100",
                outp => outInc);

        banco_registradores_component: entity work.bancoRegistradores
        generic map(larguraDados = word_width)
        port map(clk => clk,
                enderecoA => RSEND,
                enderecoB => RDEND,
                enderecoC => RTEND,
                dadoEscritaC => outULA,
                escreveC => enableWriteC,
                saidaA => outA,
                saidaB => outB);

        ula_component: entity work.ULA
        generic map(data_width = word_width)
		port map(A => outA,
				 B => outB,
				 sel => CTRULA,
                 outp => outULA);
                 
        UC_component: entity work.UC
        port map(opcode => opcode,
                enableWriteC => enableWriteC);


end architecture;