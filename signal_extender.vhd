library ieee;
use ieee.std_logic_1164.all;

entity signal_extender is
    generic
    (
        data_in_width  : natural  :=    16;
        data_out_width : natural  :=    32
    );
    port
    (
        data_in  : in  std_logic_vector(data_in_width-1 downto 0);
        data_out : out std_logic_vector(data_out_width-1 downto 0)
    );
end entity;

architecture comportamento of signal_extender is
    begin
        -- Extente o bit mais significativo da entrada pros novos 16 bits, e saida 32 bits
        data_out((data_out_width-1) downto (data_in_width)) <= (others => data_in(data_in_width-1));
        data_out((data_in_width-1) downto 0) <= data_in;
end architecture;