library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

-- Rafael dos Santos, Thomas Queiroz Shinalder, Joao Pedro Meirelez

entity mips is
	generic
	(
		rom_width : natural := 32;
		regs_address_width : natural := 5;
		word_width : natural := 32
	);
	port
	(
		clk_soninho : in std_logic;
		SW : in std_logic_vector(9 downto 0);
		KEY : in std_logic_vector(3 downto 0);

		LEDR : out std_logic_vector(9 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0)

--		enableWriteD_out : out std_logic;
--		enableWriteRAM_out : out std_logic;
--		commandULA_out : out std_logic_vector(2 downto 0);
--		mux_jump_out : out std_logic_vector(1 downto 0);
--		mux_xnw_out : out std_logic_vector(1 downto 0);
--		muxRT_RD_out : out std_logic;
--		mux_ime_RT_out : out std_logic;
--		mux_beq_bne_out : out std_logic;
--		d_addr_out : out std_logic_vector(4 downto 0);

		PC : out std_logic_vector((rom_width-1) downto 0);
		ULA : out std_logic_vector(31 downto 0);
		MUX_XNW_OUT : out std_logic_vector((word_width-1) downto 0)

--		S_out, T_out, out_xnw_out : out std_logic_vector((word_width-1) downto 0);
--		outPC_out, dist_out, outBeq_out : out std_logic_vector((rom_width-1) downto 0);
--
--        RSEND_out, RTEND_out : out std_logic_vector((regs_address_width-1) downto 0);
--
--		flag_zero_out : out std_logic
	);
end entity;

architecture rtl of mips is
	signal outPC, outInc, outRom, dist, outBeq, outMuxJmp_beq, outMuxJmp_j, outMuxJmp_jr, jump_abs, outPc_mais4 : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
	signal opcode, funct : std_logic_vector(5 downto 0);
	signal RSEND, RTEND, RDEND, out_muxRT_RD, out_muxRT_RD_R31 : std_logic_vector((regs_address_width-1) downto 0);
	signal outS, outRAM, outT, outULA, out_mux_ime_RT, out_xnw : std_logic_vector((word_width-1) downto 0);
	signal out_signal_extender, out_mux_sleep : std_logic_vector((word_width-1) downto 0);
	signal enableWriteD, enableWriteRAM : std_logic := '0';
	signal commandULA, ULAop : std_logic_vector(2 downto 0);
	signal mux_xnw : std_logic_vector(1 downto 0);
	signal ime_j : std_logic_vector(25 downto 0);
	signal outHex0, outHex1, outHex2, outHex3, outHex4, outHex5 : std_logic_vector(6 downto 0);
	signal muxRT_RD, mux_ime_RT, flag_zero, out_mux_beq_bne, mux_beq_bne, mux_jump_beq, mux_jump_j, mux_jump_jr, muxRT_RD_R31 : std_logic;
	

	signal clk : std_logic := '0';

	begin
		opcode <= outRom(31 downto 26);
		RSEND <= outRom(25 downto 21);
		RTEND <= outRom(20 downto 16);
		RDEND <= outRom(15 downto 11);
		funct <= outRom(5 downto 0);
		ime_j <= outRom(25 downto 0);

		clk_botao_component: entity work.edgeDetector
		port map(clk => clk_soninho,
				entrada => not KEY(0),
				saida => clk);

		rom_component: entity work.ROM
		port map(clk => clk,
				Endereco => outPC,
				Dado => outRom);
		
		PC_component: entity work.registrador
		generic map(data_width => rom_width)
		port map(DIN => outMuxJmp_jr,
				DOUT => outPC,
				ENABLE => '1',
				CLK => clk,
				RST => not KEY(1));

		adder_component: entity work.adder
		port map(A => outPC,
				B => std_logic_vector(to_unsigned(4, rom_width)),
				outp => outInc);

		adder_component1: entity work.adder
		port map(A => outPC,
				B => std_logic_vector(to_unsigned(4, rom_width)),
				outp => outPc_mais4);

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

		ula_component: entity work.ULA_elementos
		generic map(data_width => word_width)
		port map(A => outS,
				B => out_mux_ime_RT,
				commandULA => commandULA,
				outp => outULA,
				flag_zero => flag_zero);
				
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

		UC_ULA_component: entity work.UC_ULA
		port map(ULAop => ULAop,
				funct => funct,
				commandULA => commandULA);

		RAM_component: entity work.RAM
		port map(clk => clk,
				Endereco => outULA,
				Dado_in => outT,
				Dado_out => outRAM,
				we => enableWriteRAM);

		signal_extender_ULA: entity work.signal_extender
		port map(data_in => outRom(15 downto 0),
				data_out => out_signal_extender);

		dist <= out_signal_extender(29 downto 0) & "00";

		adder_component_beq: entity work.adder
		port map(A => outInc,
				B => dist,
				outp => outBeq);

		mux_beq_bne_component: entity work.mux2x1
		generic map (data_width => 1)
		port map(A(0) => flag_zero,
				B(0) => not flag_zero,
				sel => mux_beq_bne,
				outp(0) => out_mux_beq_bne);

		mux_jump_beq_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outInc,
				B => outBeq,
				sel => mux_jump_beq and out_mux_beq_bne,
				outp => outMuxJmp_beq);

		mux_jump_j_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outMuxJmp_beq,
				B => jump_abs,
				sel => mux_jump_j,
				outp => outMuxJmp_j);

		mux_jump_jr_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outMuxJmp_j,
				B => outS,
				sel => mux_jump_jr,
				outp => outMuxJmp_jr);
		
		mux_RT_RD_component: entity work.mux2x1
		generic map (data_width => 5)
		port map(A => RTEND,
				B => RDEND,
				sel => muxRT_RD,
				outp => out_muxRT_RD);

		mux_RT_RD_R31_component: entity work.mux2x1
		generic map (data_width => 5)
		port map(A => out_muxRT_RD,
				B => (others => '1'),
				sel => muxRT_RD_R31,
				outp => out_muxRT_RD_R31);
		
		mux_ime_RT_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outT,
				B => out_signal_extender,
				sel => mux_ime_RT,
				outp => out_mux_ime_RT);
		
		mux_xnw_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outULA,
				B => outRAM,
				C => outPc_mais4,  --jal
				D => outRom(15 downto 0) & std_logic_vector(to_unsigned(0, 16)), ---lui
				sel => mux_xnw,
				outp => out_xnw);

		combiner_component: entity work.combiner_PC_ime
		port map(ime => ime_j,
				PC => outInc(31 downto 28),
				outp => jump_abs);

		PC <= outPC;		
		ULA <= outULA;
		MUX_XNW_OUT <= out_xnw;

		mux_sleep_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outPC,
				B => outMuxJmp_jr,
				C => outULA,
				D => out_xnw,
				sel => SW(1 downto 0),
				outp => out_mux_sleep);

		conversorHEX0: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(3 downto 0),
				saida7seg => outHex0);

		HEX0 <= outHex0;

		conversorHEX1: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(7 downto 4),
				saida7seg => outHex1);

		HEX1 <= outHex1;

		conversorHEX2: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(11 downto 8),
				saida7seg => outHex2);
				
		HEX2 <= outHex2;

		conversorHEX3: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(15 downto 12),
				saida7seg => outHex3);
				
		HEX3 <= outHex3;

		conversorHEX4: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(19 downto 16),
				saida7seg => outHex4);
				
		HEX4 <= outHex4;

		conversorHEX5: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(23 downto 20),
				saida7seg => outHex5);
				
		HEX5 <= outHex5;

--		enableWriteD_out <= enableWriteD;
--		enableWriteRAM_out <= enableWriteRAM;
--		commandULA_out <= commandULA;
--		mux_jump_out <= selMuxJump;
--		mux_xnw_out <= mux_xnw;
--		muxRT_RD_out <= muxRT_RD;
--		mux_ime_RT_out <= mux_ime_RT;
--		mux_beq_bne_out <= mux_beq_bne;
--		S_out <= outS;
--		T_out <= out_mux_ime_RT;
--      RSEND_out <= RSEND;
--      RTEND_out <= RTEND;
--		d_addr_out <= out_muxRT_RD;
--		flag_zero_out <= flag_zero;
--		dist_out <= dist;
--		outBeq_out <= outBeq;
		



end architecture;
