library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Rafael dos Santos, Thomas Queiroz, Joao Pedro Meirellez

entity mips is
     port ( clk_soninho : in std_logic;
            SW          : in std_logic_vector(9 downto 0);
            KEY         : in std_logic_vector(3 downto 0);

            LEDR : out std_logic_vector(9 downto 0);
            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0);
end entity;

architecture rtl of mips is
    signal clk : std_logic := '0';
    signal PC_out, PC_in, ULA_out, XNW_out, out_mux_sleep : out std_logic_vector(31 downto 0);

    begin

        mips_component: entity work.mips
        port map(clk => clk,
                PC => PC_out,
                ULA => ULA_out,
                MUX_XNW_OUT => XNW_out);

        clk_botao_component: entity work.edgeDetector
        port map(clk => clk_soninho,
                entrada => not KEY(0),
                saida => clk);

    	mux_sleep_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => PC_out,
				B => ULA_out,
				C => XNW_out,
				D => XNW_out,
				sel => SW(1 downto 0),
				outp => out_mux_sleep);

		conversorHEX0: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(3 downto 0),
				saida7seg => outHex0);

		conversorHEX1: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(7 downto 4),
				saida7seg => outHex1);

		conversorHEX2: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(11 downto 8),
				saida7seg => outHex2);

		conversorHEX3: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(15 downto 12),
				saida7seg => outHex3);

		conversorHEX4: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(19 downto 16),
				saida7seg => outHex4);

		conversorHEX5: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(23 downto 20),
				saida7seg => outHex5);

		HEX0 <= outHex0;
		HEX1 <= outHex1;
		HEX2 <= outHex2;
		HEX3 <= outHex3;
		HEX4 <= outHex4;
		HEX5 <= outHex5;

end  architecture;