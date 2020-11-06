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
			A, B :      in std_logic_vector((data_width-1) downto 0);
			commandULA :       in std_logic_vector(2 downto 0);
			outp :      out std_logic_vector((data_width-1) downto 0);
			flag_zero : out std_logic
		);
end entity;

architecture rtl of ULA is
	signal op_add :    std_logic_vector((data_width-1) downto 0);
	signal op_sub :    std_logic_vector((data_width-1) downto 0);
	signal op_and : std_logic_vector((data_width-1) downto 0);
	signal op_or :  std_logic_vector((data_width-1) downto 0);
	signal outpp :  std_logic_vector((data_width-1) downto 0);
	signal S_menor_T :  std_logic_vector((data_width-1) downto 0);


	begin
		op_add    <= std_logic_vector(unsigned(A) + unsigned(B));
		op_sub    <= std_logic_vector(unsigned(A) - unsigned(B));
		op_and <= A and B;
		op_or  <= A or B;
		S_menor_T  <= std_logic_vector(to_unsigned(1, data_width)) when signed(A) < signed(B) else (others => '0');


		outpp <= op_and    when (commandULA = "000") else
				op_or      when (commandULA = "001") else
				op_add     when (commandULA = "010") else
				op_sub     when (commandULA = "110") else
				S_menor_T  when (commandULA = "111") else
				A;      -- outra opcao: outp = A

		outp <= outpp;

		flag_zero <= '1' when unsigned(outpp) = 0 else '0';


end architecture;