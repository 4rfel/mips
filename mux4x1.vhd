library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
	-- Total de bits das entradas e saidas
	generic ( data_width : natural := 8);
	port (
		A, B, C, D : in std_logic_vector((data_width-1) downto 0);
		sel : in std_logic_vector(1 downto 0);
		outp : out std_logic_vector((data_width-1) downto 0)
	);
end entity;

architecture rtl of mux4x1 is
	begin
		-- Caso 00 saida eh A, 01 saida eh B, 10 saida eh C e 11 saida eh D
		outp <= A when (sel = "00") else
				B when (sel = "01") else
				C when (sel = "10") else
				D when (sel = "11") else
				A;
end architecture;