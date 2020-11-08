library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apendice C (Register Files) do COD (Patterson & Hennessy).

entity bancoRegistradores is
    generic
    (
        larguraDados        : natural := 32;
        larguraEndBancoRegs : natural := 5   --Resulta em 2^5=32 posicoes
    );
-- Leitura de 2 registradores e escrita em 1 registrador simultaneamente.
    port
    (
        clk        : in std_logic;
--
        enderecoS       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoT       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoD       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
--
        dadoEscritaD    : in std_logic_vector((larguraDados-1) downto 0);
--
        escreveD        : in std_logic := '0';
        saidaS          : out std_logic_vector((larguraDados -1) downto 0);
        saidaT          : out std_logic_vector((larguraDados -1) downto 0)
    );
end entity;

architecture comportamento of bancoRegistradores is

    subtype palavra_t is std_logic_vector((larguraDados-1) downto 0);
    type memoria_t is array(2**larguraEndBancoRegs-1 downto 0) of palavra_t;

    function initMemory
        return memoria_t is variable tmp : memoria_t := (others => (others => '0'));
    begin
        -- Inicializa os endereços:
        tmp(0)  := x"00000000";
        tmp(1)  := x"00000000";
        tmp(2)  := x"00000000";
        tmp(3)  := x"00000000";
        tmp(4)  := x"00000000";
        tmp(5)  := x"00000000";
        tmp(6)  := x"00000000";
        tmp(7)  := x"00000000";
        tmp(8)  := x"00000000";
        tmp(9)  := x"0000000A";
        tmp(10) := x"0000000B";
        tmp(11) := x"0000000C";
        tmp(12) := x"0000000D";
        tmp(13) := x"00000016";
        tmp(14) := x"00000000";
        tmp(15) := x"00000000";
        tmp(16) := x"00000000";
        tmp(17) := x"00000000";
        tmp(18) := x"00000000";
        tmp(19) := x"00000000";
        tmp(20) := x"00000000";
        tmp(21) := x"00000000";
        tmp(22) := x"00000000";
        tmp(23) := x"00000000";
        tmp(24) := x"00000000";
        tmp(25) := x"00000000";
        tmp(26) := x"00000000";
        tmp(27) := x"00000000";
        tmp(28) := x"00000000";
        tmp(29) := x"00000000";
        tmp(30) := x"00000000";
        tmp(31) := x"00000000";
        return tmp;
        end initMemory;

    -- Declaracao dos registradores:
    shared variable registrador : memoria_t := initMemory;

begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (escreveD = '1') then
                registrador(to_integer(unsigned(enderecoD))) := dadoEscritaD;
            end if;
        end if;
    end process;

    -- IF endereco = 0 : retorna ZERO
     process(all) is
     begin
         if (unsigned(enderecoS) = 0) then
            saidaS <= (others => '0');
         else
            saidaS <= registrador(to_integer(unsigned(enderecoS)));
         end if;
         if (unsigned(enderecoT) = 0) then
            saidaT <= (others => '0');
         else
            saidaT <= registrador(to_integer(unsigned(enderecoT)));
        end if;
     end process;
end architecture;