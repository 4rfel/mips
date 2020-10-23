library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM IS
	 generic (
			dataWidth: natural := 32;
			addrWidth: natural := 32;
			memoryAddrWidth:  natural := 6 );   -- 64 posicoes de 32 bits cada
	 port ( clk      : in  STD_LOGIC;
			Endereco : in  std_logic_vector (addrWidth-1 downto 0);
			Dado     : out std_logic_vector (dataWidth-1 downto 0) );
end entity;

architecture assincrona of ROM is
	type blocoMemoria is array(0 to 2**memoryAddrWidth - 1) of std_logic_vector(dataWidth-1 downto 0);

	signal memROM: blocoMemoria;
	attribute ram_init_file : string;
	attribute ram_init_file of memROM:
	signal is "assembly.mif";

-- Utiliza uma quantidade menor de endereços locais:
	 signal EnderecoLocal : std_logic_vector(memoryAddrWidth-1 downto 0);

begin
	EnderecoLocal <= Endereco(memoryAddrWidth+1 downto 2);
	Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
end architecture;