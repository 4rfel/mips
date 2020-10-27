library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity mips is
	generic
	(
		rom_width : natural := 32;
		regs_address_width : natural := 5;
		word_width : natural := 32
	);
	port
	(
		-- clk : in std_logic;
		SW : in std_logic_vector(9 downto 0);
		KEY : in std_logic_vector(3 downto 0);

		LEDR : out std_logic_vector(9 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0) 
	);
end entity;

architecture rtl of mips is
	signal outPC, outInc, outRom, dist, outBeq, outMuxJmp : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
	signal opcode, CTRULA : std_logic_vector(5 downto 0);
	signal RSEND, RTEND, RDEND, out_muxRT_RD : std_logic_vector((regs_address_width-1) downto 0);
	signal outS, outRAM, outT, outULA, out_mux_ime_Rt, out_xnw : std_logic_vector((word_width-1) downto 0);
	signal out_signal_extender : std_logic_vector((word_width-1) downto 0);
	signal enableWriteD, enableWriteRAM : std_logic := '0';
	signal commandULA : std_logic_vector(2 downto 0);
	signal selMuxJump : std_logic_vector(1 downto 0);
	signal muxRT_RD, mux_ime_Rt, mux_xnw : std_logic;

	signal clk : std_logic := '0';

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
		port map(DIN => outMuxJmp,
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
				enderecoD => out_muxRT_RD,
				dadoEscritaD => out_xnw,
				escreveD => enableWriteD,
				saidaS => outS,
				saidaT => outT);

		ula_component: entity work.ULA
		generic map(data_width => word_width)
		port map(S => outS,
				T => out_mux_ime_Rt,
				sel => commandULA,
				outp => outULA);
				
		UC_component: entity work.UC
		port map(opcode => opcode,
				funct =>CTRULA,
				enableWriteD => enableWriteD,
				enableWriteRAM => enableWriteRAM,
				commandULA => commandULA,
				mux_jump => selMuxJump,
				mux_xnw => mux_xnw,
				muxRT_RD => muxRT_RD,
				mux_ime_RT => mux_ime_RT);

		RAM_component: entity work.RAM
		port map(clk => clk,
				Endereco => outULA,
				Dado_in => outT,
				Dado_out => outRAM,
				we => enableWriteRAM);
		signal_extender_ULA: entity work.signal_extender
		port map(data_in => outRom(15 downto 0),
				data_out => out_signal_extender);

		signal_extender_Beq: entity work.signal_extender_shift
		port map(data_in => outRom(15 downto 0),
				data_out => dist);

		adder_component_beq: entity work.adder
		port map(A => outInc,
				B => dist,
				outp => outBeq);

		mux_jump_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outInc,
				B => outBeq,
				C => (others => '0'),
				D => (others => '0'),
				sel => selMuxJump,
				outp => outMuxJmp);
		
		mux_RT_RD_component: entity work.mux2x1
		generic map (data_width => 5)
		port map(A => RTEND,
				B => RDEND,
				sel => muxRT_RD,
				outp => out_muxRT_RD);

		mux_ime_RT_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outT,
				B => out_signal_extender,
				sel => mux_ime_Rt,
				outp => out_mux_ime_Rt);
		
		mux_xnw_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outULA,
				B => outRAM,
				sel => mux_xnw,
				outp => out_xnw);

end architecture;
