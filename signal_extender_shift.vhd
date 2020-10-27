use ieee.std_logic_1164.all;

entity signal_extender_shift is
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

architecture comportamento of signal_extender_shift is
    begin
        data_out((data_out_width-1) downto (data_in_width+2)) <= (others => data_in(data_in_width-1));
        data_out((data_in_width+1) downto 2) <= data_in;
        data_out(1 downto 0) <= "00";
end architecture;