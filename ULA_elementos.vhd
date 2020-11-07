library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_elementos is
	generic ( data_width : natural := 32);
	port (
        A: in std_logic_vector((data_width-1) downto 0);
        B: in std_logic_vector((data_width-1) downto 0);
        commandULA : in std_logic_vector(2 downto 0);
        flag_zero: out std_logic;
		outp : out std_logic_vector((data_width-1) downto 0)
	);
end entity;

architecture rtl of ULA_elementos is
    signal outMuxB, outAddSub, outMux, SLT, outMux4x1 : std_logic_vector((data_width-1) downto 0);
    signal sel : std_logic_vector(1 downto 0);
    signal overflow, negB : std_logic;
	constant zero_vector : std_logic_vector((data_width-2) downto 0) := (OTHERS => '0');
    begin
        sel <= commandULA(1 downto 0);
        negB <= commandULA(2);

        mux_notB_component: entity work.mux2x1
        generic map (data_width => data_width)
        port map(A => B,
                B => not B,
                sel => negB,
                outp => outMuxB);

        mux_jump_component: entity work.mux4x1
		generic map (data_width => data_width)
		port map(A => A and B,
				B => A or B,
				C => outAddSub,
				D => SLT,
				sel => sel,
                outp => outMux4x1);

        add_diferenciado_component: entity work.Add32
        port map(a => A,
                 b => outMuxB,
                 carry_in => negB,
                 r => outAddSub,
                 overflow => overflow);

        -- SLT <= zero_vector & (overflow xor outAddSub(data_width-1));
        SLT <= std_logic_vector(to_unsigned(1, data_width)) when unsigned(A) < unsigned(B) else (others => '0');


        flag_zero <= '1' when (unsigned(outMux4x1) = 0) else '0';

		outp <= outMux4x1;

end architecture;