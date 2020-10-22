library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity adder is
	generic
	(
		data_width : natural := 32
	);
	port
	(
		A, B: in STD_LOGIC_VECTOR((data_width-1) downto 0);
		outp:  out STD_LOGIC_VECTOR((data_width-1) downto 0)
	);
end entity;

architecture rtl of adder is
	begin
		outp <= STD_LOGIC_VECTOR(unsigned(A) + unsigned(B));
end architecture;