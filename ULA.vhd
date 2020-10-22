library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULA is
		generic
		(
			data_width : natural := 8
		);
		port
		(
			S, T:    in std_logic_vector((data_width-1) downto 0);
			sel:     in std_logic_vector(2 downto 0);
			outp:    out std_logic_vector((data_width-1) downto 0)
		);
end entity;

architecture rtl of ULA is
	signal add :    std_logic_vector((data_width-1) downto 0);
	signal sub :    std_logic_vector((data_width-1) downto 0);
	signal op_and : std_logic_vector((data_width-1) downto 0);
	signal op_or :  std_logic_vector((data_width-1) downto 0);
	signal outpp :  std_logic_vector((data_width-1) downto 0);
	signal S_menor_T :  std_logic_vector((data_width-1) downto 0);


		begin
			add    <= std_logic_vector(unsigned(S) + unsigned(T));
			sub    <= std_logic_vector(unsigned(S) - unsigned(T));
			op_and <= S and T;
			op_or  <= S or T;
			S_menor_T  <= std_logic_vector(to_unsigned(1, data_width)) when unsigned(S) < unsigned(T) else (others => '0');


			outpp <= add       when (sel = "000") else
					sub        when (sel = "001") else
					op_and     when (sel = "010") else
					op_or      when (sel = "011") else
					S_menor_T  when (sel = "100") else
					S;      -- outra opcao: outp = A

		outp <= outpp;


end architecture;