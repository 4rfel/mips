library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Add32 is
    port(
        a   :  in STD_LOGIC_VECTOR(31 downto 0);
        b   :  in STD_LOGIC_VECTOR(31 downto 0);
		carry_in : in std_logic;
        carry_out : out std_logic;
        q   : out STD_LOGIC_VECTOR(31 downto 0)
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
  	add1 : FullAdder port map ( a(0),  b(0),  carry_in,  q(0),  carry(0));
  	add2 : FullAdder port map ( a(1),  b(1),  carry(0),  q(1),  carry(1));
  	add3 : FullAdder port map ( a(2),  b(2),  carry(1),  q(2),  carry(2));
  	add4 : FullAdder port map ( a(3),  b(3),  carry(2),  q(3),  carry(3));
  	add5 : FullAdder port map ( a(4),  b(4),  carry(3),  q(4),  carry(4));
  	add6 : FullAdder port map ( a(5),  b(5),  carry(4),  q(5),  carry(5));
  	add7 : FullAdder port map ( a(6),  b(6),  carry(5),  q(6),  carry(6));
  	add8 : FullAdder port map ( a(7),  b(7),  carry(6),  q(7),  carry(7));
  	add9 : FullAdder port map ( a(8),  b(8),  carry(7),  q(8),  carry(8));
  	add10: FullAdder port map ( a(9),  b(9),  carry(8),  q(9),  carry(9));
  	add11: FullAdder port map (a(10), b(10),  carry(9), q(10), carry(10));
  	add12: FullAdder port map (a(11), b(11), carry(10), q(11), carry(11));
  	add13: FullAdder port map (a(12), b(12), carry(11), q(12), carry(12));
  	add14: FullAdder port map (a(13), b(13), carry(12), q(13), carry(13));
  	add15: FullAdder port map (a(14), b(14), carry(13), q(14), carry(14));
  	add16: FullAdder port map (a(15), b(15), carry(14), q(15), carry(15));
  	add17: FullAdder port map (a(16), b(16), carry(15), q(16), carry(16));
  	add18: FullAdder port map (a(17), b(17), carry(16), q(17), carry(17));
  	add19: FullAdder port map (a(18), b(18), carry(17), q(18), carry(18));
  	add20: FullAdder port map (a(19), b(19), carry(18), q(19), carry(19));
  	add21: FullAdder port map (a(20), b(20), carry(19), q(20), carry(20));
  	add22: FullAdder port map (a(21), b(21), carry(20), q(21), carry(21));
  	add23: FullAdder port map (a(22), b(22), carry(21), q(22), carry(22));
  	add24: FullAdder port map (a(23), b(23), carry(22), q(23), carry(23));
  	add25: FullAdder port map (a(24), b(24), carry(23), q(24), carry(24));
  	add26: FullAdder port map (a(25), b(25), carry(24), q(25), carry(25));
  	add27: FullAdder port map (a(26), b(26), carry(25), q(26), carry(26));
  	add28: FullAdder port map (a(27), b(27), carry(26), q(27), carry(27));
  	add29: FullAdder port map (a(28), b(28), carry(27), q(28), carry(28));
  	add30: FullAdder port map (a(29), b(29), carry(28), q(29), carry(29));
  	add31: FullAdder port map (a(30), b(30), carry(29), q(30), carry(30));
  	add32: FullAdder port map (a(31), b(31), carry(30), q(31), carry(31));

	carry_out <= carry(31);

end architecture;