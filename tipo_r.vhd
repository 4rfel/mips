library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity tipo_r is
	generic
	(
		rom_width : natural := 32;
		regs_address_width : natural := 5;
		word_width : natural := 32
	);
	port
	(
		clk : in std_logic
	);
end entity;

architecture rtl of tipo_r is
	signal outPC, outInc, outRom : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
	signal opcode, CTRULA : std_logic_vector(5 downto 0);
	signal RSEND, RTEND, RDEND : std_logic_vector((regs_address_width-1) downto 0);
	signal outS, outT, outULA : std_logic_vector((word_width-1) downto 0);
	signal enableWriteD : std_logic;
	signal commandULA : std_logic_vector(2 downto 0);

	begin
		opcode <= outRom(31 downto 26);
		RSEND <= outRom(25 downto 21);
		RTEND <= outRom(20 downto 16);
		RDEND <= outRom(15 downto 11);
		CTRULA <= outRom(5 downto 0);


		rom_component: entity work.ROM
		port map(clk => clk,
				Endereco => outPC,
				Dado => outRom);
		
		PC_component: entity work.registrador
		generic map(data_width => rom_width)
		port map(DIN => outInc,
				DOUT => outPC,
				ENABLE => '1',
				CLK => clk,
				RST => '0');

		adder_component: entity work.adder
		port map(A => outPC,
				B => std_logic_vector(to_unsigned(4, rom_width)),
				outp => outInc);

		banco_registradores_component: entity work.bancoRegistradores
		generic map(larguraDados => word_width)
		port map(clk => clk,
				enderecoS => RSEND,
				enderecoT => RTEND,
				enderecoD => RDEND,
				dadoEscritaD => outULA,
				escreveD => enableWriteD,
				saidaS => outS,
				saidaT => outT);

		ula_component: entity work.ULA
		generic map(data_width => word_width)
		port map(S => outS,
				T => outT,
				sel => commandULA,
				outp => outULA);
				
		UC_component: entity work.UC
		port map(opcode => opcode,
				funct =>CTRULA,
				enableWriteD => enableWriteD,
				commandULA => commandULA);


end architecture;
