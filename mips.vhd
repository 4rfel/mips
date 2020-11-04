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
		clk : in std_logic;
		-- SW : in std_logic_vector(9 downto 0);
		-- KEY : in std_logic_vector(3 downto 0);

		-- LEDR : out std_logic_vector(9 downto 0);
		-- HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0)

		enableWriteD_out : out std_logic;
		enableWriteRAM_out : out std_logic;
		commandULA_out : out std_logic_vector(2 downto 0);
		mux_jump_out : out std_logic_vector(1 downto 0);
		mux_xnw_out : out std_logic;
		muxRT_RD_out : out std_logic;
		mux_ime_RT_out : out std_logic;
		mux_beq_bne_out : out std_logic;
		d_addr_out : out std_logic_vector(4 downto 0);

		outULA_out : out std_logic_vector(31 downto 0);

		S_out, T_out, out_xnw_out : out std_logic_vector((word_width-1) downto 0);
		outPC_out, dist_out, outBeq_out : out std_logic_vector((rom_width-1) downto 0);
		flag_zero_out : out std_logic
	);
end entity;

architecture rtl of mips is
	signal outPC, outInc, outRom, dist, outBeq, outMuxJmp, jump_abs : std_logic_vector((rom_width-1) downto 0) := (others =>'0');
	signal opcode, CTRULA : std_logic_vector(5 downto 0);
	signal RSEND, RTEND, RDEND, out_muxRT_RD : std_logic_vector((regs_address_width-1) downto 0);
	signal outS, outRAM, outT, outULA, out_mux_ime_RT, out_xnw : std_logic_vector((word_width-1) downto 0);
	signal out_signal_extender : std_logic_vector((word_width-1) downto 0);
	signal enableWriteD, enableWriteRAM : std_logic := '0';
	signal commandULA, ULAop : std_logic_vector(2 downto 0);
	signal selMuxJump : std_logic_vector(1 downto 0);
	signal ime_j : std_logic_vector(25 downto 0);

	signal muxRT_RD, mux_ime_RT, mux_xnw, flag_zero, outAnd, out_mux_beq_bne, mux_beq_bne : std_logic;
	

	-- signal clk : std_logic := '0';

	begin
		opcode <= outRom(31 downto 26);
		RSEND <= outRom(25 downto 21);
		RTEND <= outRom(20 downto 16);
		RDEND <= outRom(15 downto 11);
		CTRULA <= outRom(5 downto 0);
		ime_j <= outRom(25 downto 0);


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

		ula_component: entity work.ULA_elementos
		generic map(data_width => word_width)
		port map(A => outS,
				B => out_mux_ime_RT,
				commandULA => commandULA,
				outp => outULA,
				flag_zero => flag_zero);
				
		UC_component: entity work.UC
		port map(opcode => opcode,
				enableWriteD => enableWriteD,
				enableWriteRAM => enableWriteRAM,
				ULAop => ULAop,
				mux_jump => selMuxJump,
				mux_xnw => mux_xnw,
				muxRT_RD => muxRT_RD,
				mux_ime_RT => mux_ime_RT,
				mux_beq_bne => mux_beq_bne);

		UC_ULA_component: entity work.UC_ULA
		port map(ULAop => ULAop,
				funct => CTRULA,
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

		outAnd <= selMuxJump(0) and out_mux_beq_bne;

		mux_beq_bne_component: entity work.mux2x1
		generic map (data_width => 1)
		port map(A(0) => flag_zero,
				B(0) => not flag_zero,
				sel => mux_beq_bne,
				outp(0) => out_mux_beq_bne);

		mux_jump_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => outInc,
				B => outBeq,
				C => jump_abs,
				D => jump_abs,
				sel => selMuxJump(1) & outAnd,
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
				sel => mux_ime_RT,
				outp => out_mux_ime_RT);
		
		mux_xnw_component: entity work.mux2x1
		generic map (data_width => 32)
		port map(A => outULA,
				B => outRAM,
				sel => mux_xnw,
				outp => out_xnw);

		combiner_component: entity work.combiner_PC_ime
		port map(ime => ime_j,
				PC => outInc(3 downto 0),
				outp => jump_abs);
		
		outULA_out <= outULA;

		enableWriteD_out <= enableWriteD;
		enableWriteRAM_out <= enableWriteRAM;
		commandULA_out <= commandULA;
		mux_jump_out <= selMuxJump;
		mux_xnw_out <= mux_xnw;
		muxRT_RD_out <= muxRT_RD;
		mux_ime_RT_out <= mux_ime_RT;
		mux_beq_bne_out <= mux_beq_bne;
		S_out <= outS;
		T_out <= out_mux_ime_RT;
		d_addr_out <= out_muxRT_RD;
		out_xnw_out <= out_xnw;
		outPC_out <= outPC;
		flag_zero_out <= flag_zero;
		dist_out <= dist;
		outBeq_out <= outBeq;
		



end architecture;
