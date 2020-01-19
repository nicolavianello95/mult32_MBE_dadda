library ieee;
use ieee.std_logic_1164.all;

package pack_mult32_MBE_dadda is
	
	constant N: integer := 32;
	
	type std_logic_vector_intrange is array (integer range <>) of std_logic;	--standard logic vector with either positive or negative integer range
	
	type partial_product_type is record
		value	: std_logic_vector(N downto 0);		--value of the partial product in ones' complement
		sign	: std_logic;						--0=pos 1=neg
	end record partial_product_type;
	
	type partial_products_type is array (integer range <>) of partial_product_type;
	
	function get_MBE_partial_product(
		multiplicand: std_logic_vector(N-1 downto 0);
		multiplier: std_logic_vector_intrange(N+1 downto -1);
		i: integer)
	return partial_product_type;
	
	type stage_type is array (integer range <>) of std_logic_vector(2*N downto 0);
	
	function HA_sum(
		A: std_logic;
		B: std_logic)
	return std_logic;
	
	function HA_cout(
		A: std_logic;
		B: std_logic)
	return std_logic;
	
	function FA_sum(
		A: std_logic;
		B: std_logic;
		C_in: std_logic)
	return std_logic;
	
	function FA_cout(
		A: std_logic;
		B: std_logic;
		C_in: std_logic)
	return std_logic;
	
end package pack_mult32_MBE_dadda;

package body pack_mult32_MBE_dadda is

	function get_MBE_partial_product (
		multiplicand: std_logic_vector(N-1 downto 0);
		multiplier: std_logic_vector_intrange(N+1 downto -1);
		i: integer)
		return partial_product_type is
		variable temp_partial_product: partial_product_type;
		constant zeros: std_logic_vector(N downto 0):=(others=>'0');
		constant ones: std_logic_vector(N downto 0):=(others=>'1');
		variable multiplicand_by_one: std_logic_vector(N downto 0);
		variable multiplicand_by_two: std_logic_vector(N downto 0);
		variable multiplicand_by_one_neg: std_logic_vector(N downto 0);
		variable multiplicand_by_two_neg: std_logic_vector(N downto 0);
	begin
		multiplicand_by_one(N-1 downto 0):=multiplicand;
		multiplicand_by_one(N):='0';
		multiplicand_by_two(0):='0';
		multiplicand_by_two(N downto 1):=multiplicand;
		multiplicand_by_one_neg:= not multiplicand_by_one;
		multiplicand_by_two_neg:= not multiplicand_by_two;
		if multiplier(i+1 downto i-1)="000" then
			temp_partial_product.value:=zeros;
			temp_partial_product.sign:='0';
		elsif multiplier(i+1 downto i-1)="001" or multiplier(i+1 downto i-1)="010" then
			temp_partial_product.value:=multiplicand_by_one;
			temp_partial_product.sign:='0';
		elsif multiplier(i+1 downto i-1)="011" then
			temp_partial_product.value:=multiplicand_by_two;
			temp_partial_product.sign:='0';
		elsif multiplier(i+1 downto i-1)="100" then
			temp_partial_product.value:=multiplicand_by_two_neg;
			temp_partial_product.sign:='1';
		elsif multiplier(i+1 downto i-1)="101" or multiplier(i+1 downto i-1)="110" then
			temp_partial_product.value:=multiplicand_by_one_neg;
			temp_partial_product.sign:='1';
		elsif multiplier(i+1 downto i-1)="111" then
			temp_partial_product.value:=ones;
			temp_partial_product.sign:='1';
		end if;	
		return temp_partial_product;
	end function get_MBE_partial_product;
	
	function HA_sum(
		A: std_logic;
		B: std_logic)
		return std_logic is
	begin
		return A xor B;
	end function HA_sum;

	function HA_cout(
		A: std_logic;
		B: std_logic)
		return std_logic is
	begin
		return A and B;
	end function HA_cout;
	
	function FA_sum(
		A: std_logic;
		B: std_logic;
		C_in: std_logic)
		return std_logic is
	begin
		return A xor B xor C_in;
	end function FA_sum;

	function FA_cout(
		A: std_logic;
		B: std_logic;
		C_in: std_logic)
		return std_logic is
	begin
		return (A and B) or (A and C_in) or (B and C_in);
	end function FA_cout;
	
end package body pack_mult32_MBE_dadda;