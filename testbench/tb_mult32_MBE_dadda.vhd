library ieee;
use ieee.std_logic_1164.all;
use work.pack_mult32_MBE_dadda.all;

entity tb_mult32_MBE_dadda is
end entity tb_mult32_MBE_dadda;

architecture test of tb_mult32_MBE_dadda is

	component mult32_MBE_dadda is
		port(
			a, b: in std_logic_vector(N-1 downto 0);
			x: out std_logic_vector(2*N-1 downto 0)
		);
	end component mult32_MBE_dadda;

	signal a,b: std_logic_vector(N-1 downto 0);
	signal x: std_logic_vector(2*N-1 downto 0);

begin

	DUT: mult32_MBE_dadda port map(a,b,x);

	stim_proc: process
	begin
		a<="00000000000000000000000000000001";
		b<="00000000000000000000000000000000";
		wait for 10 ns;
		b<="00000000000000000000000000000001";
		wait for 10 ns;
		a<="11111111111111111111111111111111";
		b<="00000000000000000000000000000000";
		wait for 10 ns;		
		a<="00000000000000000000000000000001";
		b<="11111111111111111111111111111111";
		wait for 10 ns;		
		a<="11111111111111111111111111111111";
		b<="11111111111111111111111111111111";
		wait for 10 ns;		
		a<="10101010101010101010101010101010";
		b<="10101010101010101010101010101010";
		wait for 10 ns;		
		a<="10101010101010101010101010101010";
		b<="01010101010101010101010101010101";
		wait for 10 ns;		
		a<="10000000000000000000000000000000";
		b<="10000000000000000000000000000000";
		wait for 10 ns;		
		a<="00000000000000000000000000000001";
		b<="00000000000000000000000000000000";
		
		wait;
	end process stim_proc;

end architecture test;