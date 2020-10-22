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

    -- Declaracao dos registradores:
    shared variable registrador : memoria_t;

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