library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	generic
	(
		dataWidth : natural := 16;
		addrWidth : natural := 32
	);

	port (
		  address : in std_logic_vector (addrWidth-1 DOWNTO 0);
		  data : out std_logic_vector (dataWidth-1 DOWNTO 0)
	);
end entity;

architecture rtl of ROM is

	type memory_t is array (2**addrWidth -1 downto 0) of std_logic_vector (dataWidth-1 downto 0);
	signal content: memory_t;
	attribute ram_init_file : string;
	attribute ram_init_file of content:
	signal is "assembly.mif";

	begin
		data <= content(to_integer(unsigned(address)));
end architecture;
