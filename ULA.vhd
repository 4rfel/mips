library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULA is
		generic
		(
				data_width : natural := 8
				funct : natural := 6
		);
		port
		(
			A, B:  in STD_LOGIC_VECTOR((data_width-1) downto 0);
			sel:  in STD_LOGIC_VECTOR((funct-1) downto 0);
			outp:    out STD_LOGIC_VECTOR((data_width-1) downto 0)
			-- flag_zero, flag_neg: out std_logic
		);
end entity;

architecture rtl of ULA is
	constant zero : std_logic_vector(data_width-1 downto 0) := (others => '0');

	signal add :       STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal sub :       STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal op_and :    STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal op_or :     STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal op_xor :    STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal op_not :    STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal incA :      STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal decA :      STD_LOGIC_VECTOR((data_width-1) downto 0);
	signal outpp :     std_logic_vector((data_width-1) downto 0);


		begin
			add       <= STD_LOGIC_VECTOR(unsigned(A) + unsigned(B));
			sub       <= STD_LOGIC_VECTOR(unsigned(A) - unsigned(B));
			op_and    <= A and B;
			op_or     <= A or B;
			op_not    <= not A;
			incA      <= STD_LOGIC_VECTOR(unsigned(A) + 1);
			decA      <= STD_LOGIC_VECTOR(unsigned(A) - 1);


			outpp <= add   when (sel = "000") else
					sub    when (sel = "001") else
					op_and when (sel = "010") else
					op_or  when (sel = "011") else
					op_not when (sel = "100") else
					incA   when (sel = "101") else
					decA   when (sel = "110") else
					A      when (sel = "111") else
					A;      -- outra opcao: outp = A

			-- flag_zero <= '1' when unsigned(outpp) = unsigned(zero) else '0';
			-- flag_neg <= '1' when signed(outpp) <= signed(zero) else '0';
		outp <= outpp;


end architecture;