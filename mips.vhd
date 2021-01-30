library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Rafael dos Santos, Thomas Queiroz, Joao Pedro MeirellezZZzz

entity mips is
     port ( clk_soninho : in std_logic;
            SW          : in std_logic_vector(9 downto 0);
            KEY         : in std_logic_vector(3 downto 0);

            LEDR : out std_logic_vector(9 downto 0);
            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
				);
end entity;

architecture rtl of mips is
	-- Declarando sinais
    signal clk : std_logic := '0'; -- Clock que vai ser utilizado para o componente CPU (depende do botao0)
    signal PC_out, ULA_out, XNW_out, out_mux_sleep : std_logic_vector(31 downto 0);
    signal outHex0, outHex1, outHex2, outHex3, outHex4, outHex5  : std_logic_vector(6 downto 0); -- Sinais que guardam o valor que vai ser utilizado nas conversoes

    begin
		--Compontente CPU
        cpu_component: entity work.cpu
        port map(clk => clk,
                RST => not KEY(1),
                PC => PC_out,
                ULA => ULA_out,
                MUX_XNW_OUT => XNW_out);

		-- Clock funciona com botao
        clk_botao_component: entity work.edgeDetector
        port map(clk => clk_soninho,
                entrada => not KEY(0),
                saida => clk);

		-- Mux que chaveia o que vai ser escrito no diplays de 7 segmentos
    	mux_sleep_component: entity work.mux4x1
		generic map (data_width => 32)
		port map(A => PC_out,
				B => ULA_out,
				C => XNW_out,
				D => XNW_out,
				sel => SW(1 downto 0),
				outp => out_mux_sleep);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX0: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(3 downto 0),
				saida7seg => outHex0);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX1: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(7 downto 4),
				saida7seg => outHex1);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX2: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(11 downto 8),
				saida7seg => outHex2);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX3: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(15 downto 12),
				saida7seg => outHex3);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX4: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(19 downto 16),
				saida7seg => outHex4);

		-- Converte saida do Mux para o display de 7 segmentos em hexadecimal
		conversorHEX5: entity work.conversorHex7Seg
		port map(dadoHex => out_mux_sleep(23 downto 20),
				saida7seg => outHex5);

		-- Ligando saida dos conversores para o Display
		HEX0 <= outHex0; 
		HEX1 <= outHex1;
		HEX2 <= outHex2;
		HEX3 <= outHex3;
		HEX4 <= outHex4;
		HEX5 <= outHex5;

end  architecture;