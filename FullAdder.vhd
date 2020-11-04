Library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
    port(
        a, b, c:      in std_logic;
        soma, vaium: out std_logic 
    );
end entity;

architecture rtl of FullAdder is
begin
    soma <= (a xor b) xor c;
    vaium <= ((a xor b) and c) or (a and b);
    
end architecture;