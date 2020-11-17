library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Add32 is
    port(
        a   :  in STD_LOGIC_VECTOR(31 downto 0);
        b   :  in STD_LOGIC_VECTOR(31 downto 0);
		carry_in : in std_logic;
        overflow : out std_logic;
        r   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;


architecture rtl of Add32 is
    signal carry : STD_LOGIC_VECTOR(31 downto 0);

    component FullAdder is
    port(
        a,b,c:      in STD_LOGIC;
        soma,vaium: out STD_LOGIC
    );
    end component;

begin
	-- Realiza 32 Full Adders utilizando CarryIn
  	add0 : FullAdder port map ( a(0),  b(0),  carry_in,  r(0),  carry(0));
  	add1 : FullAdder port map ( a(1),  b(1),  carry(0),  r(1),  carry(1));
  	add2 : FullAdder port map ( a(2),  b(2),  carry(1),  r(2),  carry(2));
  	add3 : FullAdder port map ( a(3),  b(3),  carry(2),  r(3),  carry(3));
  	add4 : FullAdder port map ( a(4),  b(4),  carry(3),  r(4),  carry(4));
  	add5 : FullAdder port map ( a(5),  b(5),  carry(4),  r(5),  carry(5));
  	add6 : FullAdder port map ( a(6),  b(6),  carry(5),  r(6),  carry(6));
  	add7 : FullAdder port map ( a(7),  b(7),  carry(6),  r(7),  carry(7));
  	add8 : FullAdder port map ( a(8),  b(8),  carry(7),  r(8),  carry(8));
  	add9 : FullAdder port map ( a(9),  b(9),  carry(8),  r(9),  carry(9));
  	add10: FullAdder port map (a(10), b(10),  carry(9), r(10), carry(10));
  	add11: FullAdder port map (a(11), b(11), carry(10), r(11), carry(11));
  	add12: FullAdder port map (a(12), b(12), carry(11), r(12), carry(12));
  	add13: FullAdder port map (a(13), b(13), carry(12), r(13), carry(13));
  	add14: FullAdder port map (a(14), b(14), carry(13), r(14), carry(14));
  	add15: FullAdder port map (a(15), b(15), carry(14), r(15), carry(15));
  	add16: FullAdder port map (a(16), b(16), carry(15), r(16), carry(16));
  	add17: FullAdder port map (a(17), b(17), carry(16), r(17), carry(17));
  	add18: FullAdder port map (a(18), b(18), carry(17), r(18), carry(18));
  	add19: FullAdder port map (a(19), b(19), carry(18), r(19), carry(19));
  	add20: FullAdder port map (a(20), b(20), carry(19), r(20), carry(20));
  	add21: FullAdder port map (a(21), b(21), carry(20), r(21), carry(21));
  	add22: FullAdder port map (a(22), b(22), carry(21), r(22), carry(22));
  	add23: FullAdder port map (a(23), b(23), carry(22), r(23), carry(23));
  	add24: FullAdder port map (a(24), b(24), carry(23), r(24), carry(24));
  	add25: FullAdder port map (a(25), b(25), carry(24), r(25), carry(25));
  	add26: FullAdder port map (a(26), b(26), carry(25), r(26), carry(26));
  	add27: FullAdder port map (a(27), b(27), carry(26), r(27), carry(27));
  	add28: FullAdder port map (a(28), b(28), carry(27), r(28), carry(28));
  	add29: FullAdder port map (a(29), b(29), carry(28), r(29), carry(29));
  	add30: FullAdder port map (a(30), b(30), carry(29), r(30), carry(30));
  	add31: FullAdder port map (a(31), b(31), carry(30), r(31), carry(31));

	-- Testa se ocorreu overflow
	overflow <= carry(30) xor carry(31);

end architecture;
