library ieee;
use ieee.std_logic_1164.all;

entity combiner_PC_ime is
	generic ( 
        ime_width   : natural := 26;
        addrs_width : natural := 32
	);
	port (
        ime  : in std_logic_vector((ime_width-1) downto 0);
        PC   : in std_logic_vector(3 downto 0);
		outp : out std_logic_vector((addrs_width-1) downto 0)
	);
end entity;

architecture rtl of combiner_PC_ime is
	begin
        outp <= PC & ime & "00";
end architecture;