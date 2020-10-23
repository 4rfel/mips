library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
	-- Total de bits das entradas e saidas
	generic ( data_width : natural := 8);
	port (
		A, B : in std_logic_vector((data_width-1) downto 0);
		sel : in std_logic;
		outp : out std_logic_vector((data_width-1) downto 0)
	);
end entity;

architecture rtl of mux2x1 is
	begin
		outp <= B when (sel = '1') else A;
end architecture;