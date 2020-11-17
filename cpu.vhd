library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity cpu is
	generic
	(
		rom_width : natural := 32;
		regs_address_width : natural := 5;
		word_width : natural := 32
	);
	port
	(
		clk : in std_logic;
		rst: in std_logic;

		PC : out std_logic_vector((rom_width-1) downto 0);
		ULA : out std_logic_vector(31 downto 0);
		MUX_XNW_OUT : out std_logic_vector((word_width-1) downto 0)

	);
end entity;

architecture rtl of cpu is
	signal outPC, outInc, outRom, dist, outBeq, outMuxJmp_beq, outMuxJmp_j, outMuxJmp_jr, jump_abs, outPc_mais4 : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
	signal opcode, funct : std_logic_vector(5 downto 0);
	signal RSEND, RTEND, RDEND, out_muxRT_RD, out_muxRT_RD_R31 : std_logic_vector((regs_address_width-1) downto 0);
	signal outS, outRAM, outT, outULA, out_mux_ime_RT, out_xnw : std_logic_vector((word_width-1) downto 0);
	signal out_signal_extender, out_mux_sleep : std_logic_vector((word_width-1) downto 0);
	signal enableWriteD, enableWriteRAM : std_logic := '0';
	signal commandULA, ULAop : std_logic_vector(2 downto 0);
	signal mux_xnw, mux_ime_RT : std_logic_vector(1 downto 0);
	signal ime_j : std_logic_vector(25 downto 0);
	signal outHex0, outHex1, outHex2, outHex3, outHex4, outHex5 : std_logic_vector(6 downto 0);
	signal muxRT_RD, flag_zero, out_mux_beq_bne, mux_beq_bne, mux_jump_beq, mux_jump_j, mux_jump_jr, muxRT_RD_R31 : std_logic;
	

	begin
		-- Extrai as informacoes necessarias vinda da ROM
		opcode <= outRom(31 downto 26);
		RSEND <= outRom(25 downto 21);
		RTEND <= outRom(20 downto 16);
		RDEND <= outRom(15 downto 11);
		funct <= outRom(5 downto 0);
		ime_j <= outRom(25 downto 0);

		-- Declaracao da ROM
		rom_component: entity work.ROM
		port map(clk => clk,
				Endereco => outPC,
				Dado => outRom);
		
		-- Declaracao do PC
		PC_component: entity work.registrador
		generic map(data_width => rom_width)
		port map(DIN => outMuxJmp_jr,
				DOUT => outPC,
				ENABLE => '1',
				CLK => clk,
				RST => rst);

		-- Declaracao do componente que incrementa o PC em 4 (PC+4)
		adder_component: entity work.adder
		port map(A => outPC,
				B => std_logic_vector(to_unsigned(4, rom_width)),
				outp => outInc);

		-- Declaracao do componente que incrementa o PC em 4 (PC+4)
		adder_component1: entity work.adder
		port map(A => outPC,
				B => std_logic_vector(to_unsigned(4, rom_width)),
				outp => outPc_mais4);

		-- Declaracao do banco de registradores
		banco_registradores_component: entity work.bancoRegistradores
		generic map(larguraDados => word_width)
		port map(clk => clk,
				enderecoS => RSEND,
				enderecoT => RTEND,
				enderecoD => out_muxRT_RD_R31,
				dadoEscritaD => out_xnw,
				escreveD => enableWriteD,
				saidaS => outS,
				saidaT => outT);

		-- Declaracao da ULA
		ula_component: entity work.ULA_elementos
		generic map(data_width => word_width)
		port map(A => outS,
				B => out_mux_ime_RT,
				commandULA => commandULA,
				outp => outULA,
				flag_zero => flag_zero);
		
		-- Declaracao da Unidade de Controle do fluxo de dados
		UC_component: entity work.UC
		port map(opcode => opcode,
				funct => funct,
				enableWriteD => enableWriteD,
				enableWriteRAM => enableWriteRAM,
				ULAop => ULAop,
				mux_jump_beq => mux_jump_beq,
				mux_jump_j => mux_jump_j,
				mux_jump_jr => mux_jump_jr,
				mux_xnw => mux_xnw,
				muxRT_RD => muxRT_RD,
				muxRT_RD_R31 => muxRT_RD_R31,
				mux_ime_RT => mux_ime_RT,
				mux_beq_bne => mux_beq_bne);

		-- Declaracao da Unidade de Controle da ULA
		UC_ULA_component: entity work.UC_ULA
		port map(ULAop => ULAop,
				funct => funct,
				commandULA => commandULA);

		-- Declaracao da RAM
		RAM_component: entity work.RAM
		port map(clk => clk,
				Endereco => outULA,
				Dado_in => outT,
				Dado_out => outRAM,
				we => enableWriteRAM);

		-- Declaracao do extensor de sinal da ULA
		signal_extender_ULA: entity work.signal_extender
		port map(data_in => outRom(15 downto 0),
				data_out => out_signal_extender);

		-- Offset do endereco de branch
		dist <= out_signal_extender(29 downto 0) & "00";

		-- Declaracao do componente adder para as instrucoes de branch
		adder_component_beq: entity work.adder
		port map(A => outInc,
				B => dist,
				outp => outBeq);

		-- Mux que escolhe entre BEQ e BNE
		mux_beq_bne_component: entity work.mux2x1
		generic map (data_width => 1)
		port map(A(0) => flag_zero,
				B(0) => not flag_zero,
				sel => mux_beq_bne,
				outp(0) => out_mux_beq_bne);

		-- Mux que escolhe entre realizar branch e PC+4
		mux_jump_beq_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outInc,
				B => outBeq,
				sel => mux_jump_beq and out_mux_beq_bne,
				outp => outMuxJmp_beq);

		-- Mux que escolhe entre realizar JUMP e PC+4/Branch
		mux_jump_j_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outMuxJmp_beq,
				B => jump_abs,
				sel => mux_jump_j,
				outp => outMuxJmp_j);

		-- Mux que escolhe entre realizar JR e PC+4/Branch/JUMP
		mux_jump_jr_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outMuxJmp_j,
				B => outS,
				sel => mux_jump_jr,
				outp => outMuxJmp_jr);
		
		-- Mux que escolhe se RT ou RD possui endereco de escrita
		mux_RT_RD_component: entity work.mux2x1
		generic map (data_width => 5)
		port map(A => RTEND,
				B => RDEND,
				sel => muxRT_RD,
				outp => out_muxRT_RD);

		-- Mux que escolhe se RT_RD ou Registrador31 (ra) possui endereco de escrita
		mux_RT_RD_R31_component: entity work.mux2x1
		generic map (data_width => 5)
		port map(A => out_muxRT_RD,
				B => (others => '1'),
				sel => muxRT_RD_R31,
				outp => out_muxRT_RD_R31);
		
		-- Mux que escolhe entre imediato com sinal ou imediato sem sinal ou RT
		mux_ime_RT_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outT,
				B => out_signal_extender,
				C => std_logic_vector(to_unsigned(0, 16)) & outRom(15 downto 0),
				D => (others => '0'),
				sel => mux_ime_RT,
				outp => out_mux_ime_RT);
		
		-- Mux que escolhe entre saida da ULA, saida da RAM, PC+4 e o LUI
		mux_xnw_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outULA,
				B => outRAM,
				C => outPc_mais4,  --jal
				D => outRom(15 downto 0) & std_logic_vector(to_unsigned(0, 16)), ---lui
				sel => mux_xnw,
				outp => out_xnw);

		-- Combina PC com imediato para criar o endereco do JUMP
		combiner_component: entity work.combiner_PC_ime
		port map(ime => ime_j,
				PC => outInc(31 downto 28),
				outp => jump_abs);

		PC <= outPC;		
		ULA <= outULA;
		MUX_XNW_OUT <= out_xnw;

end architecture;
