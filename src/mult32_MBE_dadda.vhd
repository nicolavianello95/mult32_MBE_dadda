library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pack_mult32_MBE_dadda.all;

entity mult32_MBE_dadda is
	port(
		a, b: in std_logic_vector(N-1 downto 0);
		x: out std_logic_vector(2*N-1 downto 0)
	);
end entity mult32_MBE_dadda;

architecture behavioral of mult32_MBE_dadda is

	signal b_ext: std_logic_vector_intrange(N+1 downto -1);
	
	signal partial_products: partial_products_type(0 to N/2);
	
	signal x_tmp : std_logic_vector(2*N downto 0);
	
	signal stage6: stage_type(0 to 16);
	signal stage5: stage_type(0 to 12);
	signal stage4: stage_type(0 to 8);
	signal stage3: stage_type(0 to 5);
	signal stage2: stage_type(0 to 3);
	signal stage1: stage_type(0 to 2);
	signal stage0: stage_type(0 to 1);

begin

	-----------------------------------------------------MULTIPLIER BITS EXTENSION------------------------------------------------------

	b_ext(-1)<='0';								--connect bit -1 of B_ext to zero
	b_ext_generate: for i in 0 to N-1 generate	--connect all other bits to input B
		b_ext(i)<=B(i);
	end generate b_ext_generate;
	b_ext(N+1 downto N)<="00";					--connect bits 32 and 33 to zero

	------------------------------------------------------PARTIAL PRODUCTS GENERATION---------------------------------------------------

	partial_product_generate: for i in 0 to N/2 generate
		partial_products(i)<=get_MBE_partial_product(a, b_ext, i*2);
	end generate partial_product_generate;

	------------------------------------------------------FROM PARTIAL PRODUCTS TO PYRAMIDAL FORM-------------------------------------------
	--stage6 line0
	stage6(0)(32 downto 0)	<=partial_products(0).value;
	stage6(0)(33)			<=partial_products(0).sign;
	stage6(0)(34)			<=partial_products(0).sign;
	stage6(0)(35)			<=not partial_products(0).sign;
	stage6(0)(36)			<='1';
	stage6(0)(37)			<=not partial_products(2).sign;
	stage6(0)(38)			<='1';
	stage6(0)(39)			<=not partial_products(3).sign;
	stage6(0)(40)			<='1';
	stage6(0)(41)			<=not partial_products(4).sign;
	stage6(0)(42)			<='1';
	stage6(0)(43)			<=not partial_products(5).sign;
	stage6(0)(44)			<='1';
	stage6(0)(45)			<=not partial_products(6).sign;
	stage6(0)(46)			<='1';
	stage6(0)(47)			<=not partial_products(7).sign;
	stage6(0)(48)			<='1';
	stage6(0)(49)			<=not partial_products(8).sign;
	stage6(0)(50)			<='1';
	stage6(0)(51)			<=not partial_products(9).sign;
	stage6(0)(52)			<='1';
	stage6(0)(53)			<=not partial_products(10).sign;
	stage6(0)(54)			<='1';
	stage6(0)(55)			<=not partial_products(11).sign;
	stage6(0)(56)			<='1';
	stage6(0)(57)			<=not partial_products(12).sign;
	stage6(0)(58)			<='1';
	stage6(0)(59)			<=not partial_products(13).sign;
	stage6(0)(60)			<='1';
	stage6(0)(61)			<=not partial_products(14).sign;
	stage6(0)(62)			<='1';
	stage6(0)(63)			<=not partial_products(15).sign;
	--stage6 line1
	stage6(1)(0)			<=partial_products(0).sign;
	stage6(1)(34 downto 2)	<=partial_products(1).value;
	stage6(1)(35)			<=not partial_products(1).sign;
	stage6(1)(36)			<=partial_products(2).value(32);
	stage6(1)(38 downto 37)	<=partial_products(3).value(32 downto 31);
	stage6(1)(40 downto 39)	<=partial_products(4).value(32 downto 31);
	stage6(1)(42 downto 41)	<=partial_products(5).value(32 downto 31);
	stage6(1)(44 downto 43)	<=partial_products(6).value(32 downto 31);
	stage6(1)(46 downto 45)	<=partial_products(7).value(32 downto 31);
	stage6(1)(48 downto 47)	<=partial_products(8).value(32 downto 31);
	stage6(1)(50 downto 49)	<=partial_products(9).value(32 downto 31);
	stage6(1)(52 downto 51)	<=partial_products(10).value(32 downto 31);
	stage6(1)(54 downto 53)	<=partial_products(11).value(32 downto 31);
	stage6(1)(56 downto 55)	<=partial_products(12).value(32 downto 31);
	stage6(1)(58 downto 57)	<=partial_products(13).value(32 downto 31);
	stage6(1)(60 downto 59)	<=partial_products(14).value(32 downto 31);
	stage6(1)(62 downto 61)	<=partial_products(15).value(32 downto 31);
	stage6(1)(63)			<=partial_products(16).value(31);
	--stage6 line2
	stage6(2)(2)			<=partial_products(1).sign;
	stage6(2)(35 downto 4)	<=partial_products(2).value(31 downto 0);
	stage6(2)(36)			<=partial_products(3).value(30);
	stage6(2)(38 downto 37)	<=partial_products(4).value(30 downto 29);
	stage6(2)(40 downto 39)	<=partial_products(5).value(30 downto 29);
	stage6(2)(42 downto 41)	<=partial_products(6).value(30 downto 29);
	stage6(2)(44 downto 43)	<=partial_products(7).value(30 downto 29);
	stage6(2)(46 downto 45)	<=partial_products(8).value(30 downto 29);
	stage6(2)(48 downto 47)	<=partial_products(9).value(30 downto 29);
	stage6(2)(50 downto 49)	<=partial_products(10).value(30 downto 29);
	stage6(2)(52 downto 51)	<=partial_products(11).value(30 downto 29);
	stage6(2)(54 downto 53)	<=partial_products(12).value(30 downto 29);
	stage6(2)(56 downto 55)	<=partial_products(13).value(30 downto 29);
	stage6(2)(58 downto 57)	<=partial_products(14).value(30 downto 29);
	stage6(2)(60 downto 59)	<=partial_products(15).value(30 downto 29);
	stage6(2)(62 downto 61)	<=partial_products(16).value(30 downto 29);
	--stage6 line3
	stage6(3)(4)			<=partial_products(2).sign;
	stage6(3)(35 downto 6)	<=partial_products(3).value(29 downto 0);
	stage6(3)(36)			<=partial_products(4).value(28);
	stage6(3)(38 downto 37)	<=partial_products(5).value(28 downto 27);
	stage6(3)(40 downto 39)	<=partial_products(6).value(28 downto 27);
	stage6(3)(42 downto 41)	<=partial_products(7).value(28 downto 27);
	stage6(3)(44 downto 43)	<=partial_products(8).value(28 downto 27);
	stage6(3)(46 downto 45)	<=partial_products(9).value(28 downto 27);
	stage6(3)(48 downto 47)	<=partial_products(10).value(28 downto 27);
	stage6(3)(50 downto 49)	<=partial_products(11).value(28 downto 27);
	stage6(3)(52 downto 51)	<=partial_products(12).value(28 downto 27);
	stage6(3)(54 downto 53)	<=partial_products(13).value(28 downto 27);
	stage6(3)(56 downto 55)	<=partial_products(14).value(28 downto 27);
	stage6(3)(58 downto 57)	<=partial_products(15).value(28 downto 27);
	stage6(3)(60 downto 59)	<=partial_products(16).value(28 downto 27);
	--stage6 line4
	stage6(4)(6)			<=partial_products(3).sign;
	stage6(4)(35 downto 8)	<=partial_products(4).value(27 downto 0);
	stage6(4)(36)			<=partial_products(5).value(26);
	stage6(4)(38 downto 37)	<=partial_products(6).value(26 downto 25);
	stage6(4)(40 downto 39)	<=partial_products(7).value(26 downto 25);
	stage6(4)(42 downto 41)	<=partial_products(8).value(26 downto 25);
	stage6(4)(44 downto 43)	<=partial_products(9).value(26 downto 25);
	stage6(4)(46 downto 45)	<=partial_products(10).value(26 downto 25);
	stage6(4)(48 downto 47)	<=partial_products(11).value(26 downto 25);
	stage6(4)(50 downto 49)	<=partial_products(12).value(26 downto 25);
	stage6(4)(52 downto 51)	<=partial_products(13).value(26 downto 25);
	stage6(4)(54 downto 53)	<=partial_products(14).value(26 downto 25);
	stage6(4)(56 downto 55)	<=partial_products(15).value(26 downto 25);
	stage6(4)(58 downto 57)	<=partial_products(16).value(26 downto 25);
	--stage6 line5
	stage6(5)(8)			<=partial_products(4).sign;
	stage6(5)(35 downto 10)	<=partial_products(5).value(25 downto 0);
	stage6(5)(36)			<=partial_products(6).value(24);
	stage6(5)(38 downto 37)	<=partial_products(7).value(24 downto 23);
	stage6(5)(40 downto 39)	<=partial_products(8).value(24 downto 23);
	stage6(5)(42 downto 41)	<=partial_products(9).value(24 downto 23);
	stage6(5)(44 downto 43)	<=partial_products(10).value(24 downto 23);
	stage6(5)(46 downto 45)	<=partial_products(11).value(24 downto 23);
	stage6(5)(48 downto 47)	<=partial_products(12).value(24 downto 23);
	stage6(5)(50 downto 49)	<=partial_products(13).value(24 downto 23);
	stage6(5)(52 downto 51)	<=partial_products(14).value(24 downto 23);
	stage6(5)(54 downto 53)	<=partial_products(15).value(24 downto 23);
	stage6(5)(56 downto 55)	<=partial_products(16).value(24 downto 23);
	--stage6 line6
	stage6(6)(10)			<=partial_products(5).sign;
	stage6(6)(35 downto 12)	<=partial_products(6).value(23 downto 0);
	stage6(6)(36)			<=partial_products(7).value(22);
	stage6(6)(38 downto 37)	<=partial_products(8).value(22 downto 21);
	stage6(6)(40 downto 39)	<=partial_products(9).value(22 downto 21);
	stage6(6)(42 downto 41)	<=partial_products(10).value(22 downto 21);
	stage6(6)(44 downto 43)	<=partial_products(11).value(22 downto 21);
	stage6(6)(46 downto 45)	<=partial_products(12).value(22 downto 21);
	stage6(6)(48 downto 47)	<=partial_products(13).value(22 downto 21);
	stage6(6)(50 downto 49)	<=partial_products(14).value(22 downto 21);
	stage6(6)(52 downto 51)	<=partial_products(15).value(22 downto 21);
	stage6(6)(54 downto 53)	<=partial_products(16).value(22 downto 21);
	--stage6 line7
	stage6(7)(12)			<=partial_products(6).sign;
	stage6(7)(35 downto 14)	<=partial_products(7).value(21 downto 0);
	stage6(7)(36)			<=partial_products(8).value(20);
	stage6(7)(38 downto 37)	<=partial_products(9).value(20 downto 19);
	stage6(7)(40 downto 39)	<=partial_products(10).value(20 downto 19);
	stage6(7)(42 downto 41)	<=partial_products(11).value(20 downto 19);
	stage6(7)(44 downto 43)	<=partial_products(12).value(20 downto 19);
	stage6(7)(46 downto 45)	<=partial_products(13).value(20 downto 19);
	stage6(7)(48 downto 47)	<=partial_products(14).value(20 downto 19);
	stage6(7)(50 downto 49)	<=partial_products(15).value(20 downto 19);
	stage6(7)(52 downto 51)	<=partial_products(16).value(20 downto 19);
	--stage6 line8
	stage6(8)(14)			<=partial_products(7).sign;
	stage6(8)(35 downto 16)	<=partial_products(8).value(19 downto 0);
	stage6(8)(36)			<=partial_products(9).value(18);
	stage6(8)(38 downto 37)	<=partial_products(10).value(18 downto 17);
	stage6(8)(40 downto 39)	<=partial_products(11).value(18 downto 17);
	stage6(8)(42 downto 41)	<=partial_products(12).value(18 downto 17);
	stage6(8)(44 downto 43)	<=partial_products(13).value(18 downto 17);
	stage6(8)(46 downto 45)	<=partial_products(14).value(18 downto 17);
	stage6(8)(48 downto 47)	<=partial_products(15).value(18 downto 17);
	stage6(8)(50 downto 49)	<=partial_products(16).value(18 downto 17);
	--stage6 line9
	stage6(9)(16)			<=partial_products(8).sign;
	stage6(9)(35 downto 18)	<=partial_products(9).value(17 downto 0);
	stage6(9)(36)			<=partial_products(10).value(16);
	stage6(9)(38 downto 37)	<=partial_products(11).value(16 downto 15);
	stage6(9)(40 downto 39)	<=partial_products(12).value(16 downto 15);
	stage6(9)(42 downto 41)	<=partial_products(13).value(16 downto 15);
	stage6(9)(44 downto 43)	<=partial_products(14).value(16 downto 15);
	stage6(9)(46 downto 45)	<=partial_products(15).value(16 downto 15);
	stage6(9)(48 downto 47)	<=partial_products(16).value(16 downto 15);
	--stage6 line10
	stage6(10)(18)			<=partial_products(9).sign;
	stage6(10)(35 downto 20)<=partial_products(10).value(15 downto 0);
	stage6(10)(36)			<=partial_products(11).value(14);
	stage6(10)(38 downto 37)<=partial_products(12).value(14 downto 13);
	stage6(10)(40 downto 39)<=partial_products(13).value(14 downto 13);
	stage6(10)(42 downto 41)<=partial_products(14).value(14 downto 13);
	stage6(10)(44 downto 43)<=partial_products(15).value(14 downto 13);
	stage6(10)(46 downto 45)<=partial_products(16).value(14 downto 13);
	--stage6 line11
	stage6(11)(20)			<=partial_products(10).sign;
	stage6(11)(35 downto 22)<=partial_products(11).value(13 downto 0);
	stage6(11)(36)			<=partial_products(12).value(12);
	stage6(11)(38 downto 37)<=partial_products(13).value(12 downto 11);
	stage6(11)(40 downto 39)<=partial_products(14).value(12 downto 11);
	stage6(11)(42 downto 41)<=partial_products(15).value(12 downto 11);
	stage6(11)(44 downto 43)<=partial_products(16).value(12 downto 11);
	--stage6 line12
	stage6(12)(22)			<=partial_products(11).sign;
	stage6(12)(35 downto 24)<=partial_products(12).value(11 downto 0);
	stage6(12)(36)			<=partial_products(13).value(10);
	stage6(12)(38 downto 37)<=partial_products(14).value(10 downto 9);
	stage6(12)(40 downto 39)<=partial_products(15).value(10 downto 9);
	stage6(12)(42 downto 41)<=partial_products(16).value(10 downto 9);
	--stage6 line13
	stage6(13)(24)			<=partial_products(12).sign;
	stage6(13)(35 downto 26)<=partial_products(13).value(9 downto 0);
	stage6(13)(36)			<=partial_products(14).value(8);
	stage6(13)(38 downto 37)<=partial_products(15).value(8 downto 7);
	stage6(13)(40 downto 39)<=partial_products(16).value(8 downto 7);
	--stage6 line14
	stage6(14)(26)			<=partial_products(13).sign;
	stage6(14)(35 downto 28)<=partial_products(14).value(7 downto 0);
	stage6(14)(36)			<=partial_products(15).value(6);
	stage6(14)(38 downto 37)<=partial_products(16).value(6 downto 5);
	--stage6 line15
	stage6(15)(28)			<=partial_products(14).sign;
	stage6(15)(35 downto 30)<=partial_products(15).value(5 downto 0);
	stage6(15)(36)			<=partial_products(16).value(4);
	--stage6 line16
	stage6(16)(30)			<=partial_products(15).sign;
	stage6(16)(35 downto 32)<=partial_products(16).value(3 downto 0);
	
	-------------------------------------------FROM STAGE6 TO STAGE5----------------------------------------------------

	--FAs
	
	FA_6to5_generate0: for i in 26 to 41 generate
		stage5(0)(i)<=FA_sum(stage6(0)(i), stage6(1)(i), stage6(2)(i));
		stage5(1)(i+1)<=FA_cout(stage6(0)(i), stage6(1)(i), stage6(2)(i));
	end generate FA_6to5_generate0;
	
	FA_6to5_generate1: for i in 28 to 39 generate
		stage5(2)(i)<=FA_sum(stage6(3)(i), stage6(4)(i), stage6(5)(i));
		stage5(3)(i+1)<=FA_cout(stage6(3)(i), stage6(4)(i), stage6(5)(i));
	end generate FA_6to5_generate1;
	
	FA_6to5_generate2: for i in 30 to 37 generate
		stage5(4)(i)<=FA_sum(stage6(6)(i), stage6(7)(i), stage6(8)(i));
		stage5(5)(i+1)<=FA_cout(stage6(6)(i), stage6(7)(i), stage6(8)(i));
	end generate FA_6to5_generate2;
	
	FA_6to5_generate3: for i in 32 to 35 generate
		stage5(6)(i)<=FA_sum(stage6(9)(i), stage6(10)(i), stage6(11)(i));
		stage5(7)(i+1)<=FA_cout(stage6(9)(i), stage6(10)(i), stage6(11)(i));
	end generate FA_6to5_generate3;
	
	--HAs
	
	HA_6to5_generate0: for i in 24 to 25 generate
		stage5(0)(i)<=HA_sum(stage6(0)(i), stage6(1)(i));
		stage5(1)(i+1)<=HA_cout(stage6(0)(i), stage6(1)(i));
	end generate HA_6to5_generate0;
	
	HA_6to5_generate1: for i in 26 to 27 generate
		stage5(2)(i)<=HA_sum(stage6(3)(i), stage6(4)(i));
		stage5(3)(i+1)<=HA_cout(stage6(3)(i), stage6(4)(i));
	end generate HA_6to5_generate1;
	
	HA_6to5_generate2: for i in 28 to 29 generate
		stage5(4)(i)<=HA_sum(stage6(6)(i), stage6(7)(i));
		stage5(5)(i+1)<=HA_cout(stage6(6)(i), stage6(7)(i));
	end generate HA_6to5_generate2;
	
	HA_6to5_generate3: for i in 30 to 31 generate
		stage5(6)(i)<=HA_sum(stage6(9)(i), stage6(10)(i));
		stage5(7)(i+1)<=HA_cout(stage6(9)(i), stage6(10)(i));
	end generate HA_6to5_generate3;
	
	stage5(6)(36)<=HA_sum(stage6(9)(36), stage6(10)(36));
	stage5(6)(37)<=HA_cout(stage6(9)(36), stage6(10)(36));
	
	stage5(4)(38)<=HA_sum(stage6(6)(38), stage6(7)(38));
	stage5(4)(39)<=HA_cout(stage6(6)(38), stage6(7)(38));
	
	stage5(2)(40)<=HA_sum(stage6(3)(40), stage6(4)(40));
	stage5(2)(41)<=HA_cout(stage6(3)(40), stage6(4)(40));
	
	stage5(0)(42)<=HA_sum(stage6(0)(42), stage6(1)(42));
	stage5(0)(43)<=HA_cout(stage6(0)(42), stage6(1)(42));
	
	--direct connections
	
	connection_6to5_column0to23_generate_ext: for j in 0 to 23 generate
		connection_6to5_column0to23_generate_in: for i in 0 to 12 generate
			stage5(i)(j)<=stage6(i)(j);
		end generate connection_6to5_column0to23_generate_in;
	end generate connection_6to5_column0to23_generate_ext;

	connection_6to5_column24_generate: for i in 1 to 12 generate
		stage5(i)(24)<=stage6(i+1)(24);
	end generate connection_6to5_column24_generate;

	connection_6to5_column25_generate: for i in 2 to 12 generate
		stage5(i)(25)<=stage6(i)(25);
	end generate connection_6to5_column25_generate;

	connection_6to5_column26_generate: for i in 3 to 12 generate
		stage5(i)(26)<=stage6(i+2)(26);
	end generate connection_6to5_column26_generate;

	connection_6to5_column27_generate: for i in 4 to 12 generate
		stage5(i)(27)<=stage6(i+1)(27);
	end generate connection_6to5_column27_generate;

	connection_6to5_column28_generate: for i in 5 to 12 generate
		stage5(i)(28)<=stage6(i+3)(28);
	end generate connection_6to5_column28_generate;

	connection_6to5_column29_generate: for i in 6 to 12 generate
		stage5(i)(29)<=stage6(i+2)(29);
	end generate connection_6to5_column29_generate;

	connection_6to5_column30_generate: for i in 7 to 12 generate
		stage5(i)(30)<=stage6(i+4)(30);
	end generate connection_6to5_column30_generate;

	connection_6to5_column31_generate: for i in 8 to 12 generate --12
		stage5(i)(31)<=stage6(i+3)(31);
	end generate connection_6to5_column31_generate;
	
	connection_6to5_column32to35_generate_ext: for j in 32 to 35 generate
		connection_6to5_column32to35_generate_in: for i in 8 to 12 generate
			stage5(i)(j)<=stage6(i+4)(j);
		end generate connection_6to5_column32to35_generate_in;
	end generate connection_6to5_column32to35_generate_ext;

	connection_6to5_column36_generate: for i in 8 to 12 generate
		stage5(i)(36)<=stage6(i+3)(36);
	end generate connection_6to5_column36_generate;
	
	connection_6to5_column37_generate: for i in 7 to 12 generate
		stage5(i)(37)<=stage6(i+2)(37);
	end generate connection_6to5_column37_generate;
	
	connection_6to5_column38_generate: for i in 6 to 12 generate
		stage5(i)(38)<=stage6(i+2)(38);
	end generate connection_6to5_column38_generate;
	
	connection_6to5_column39_generate: for i in 5 to 12 generate
		stage5(i)(39)<=stage6(i+1)(39);
	end generate connection_6to5_column39_generate;
	
	connection_6to5_column40_generate: for i in 4 to 12 generate
		stage5(i)(40)<=stage6(i+1)(40);
	end generate connection_6to5_column40_generate;
	
	connection_6to5_column41_generate: for i in 3 to 12 generate
		stage5(i)(41)<=stage6(i)(41);
	end generate connection_6to5_column41_generate;
	
	connection_6to5_column42_generate: for i in 2 to 12 generate
		stage5(i)(42)<=stage6(i)(42);
	end generate connection_6to5_column42_generate;
	
	connection_6to5_column43_generate: for i in 1 to 12 generate
		stage5(i)(43)<=stage6(i-1)(43);
	end generate connection_6to5_column43_generate;
	
	connection_6to5_column44to63_generate_ext: for j in 44 to 63 generate
		connection_6to5_column44to63_generate_in: for i in 0 to 12 generate
			stage5(i)(j)<=stage6(i)(j);
		end generate connection_6to5_column44to63_generate_in;
	end generate connection_6to5_column44to63_generate_ext;
	
	-----------------------------------------------------FROM STAGE5 to STAGE4-----------------------------------------------------------------------
	
	--FAs
	
	FA_5to4_generate0: for i in 18 to 49 generate
		stage4(0)(i)<=FA_sum(stage5(0)(i), stage5(1)(i), stage5(2)(i));
		stage4(1)(i+1)<=FA_cout(stage5(0)(i), stage5(1)(i), stage5(2)(i));
	end generate FA_5to4_generate0;
	
	FA_5to4_generate1: for i in 20 to 47 generate
		stage4(2)(i)<=FA_sum(stage5(3)(i), stage5(4)(i), stage5(5)(i));
		stage4(3)(i+1)<=FA_cout(stage5(3)(i), stage5(4)(i), stage5(5)(i));
	end generate FA_5to4_generate1;
	
	FA_5to4_generate2: for i in 22 to 45 generate
		stage4(4)(i)<=FA_sum(stage5(6)(i), stage5(7)(i), stage5(8)(i));
		stage4(5)(i+1)<=FA_cout(stage5(6)(i), stage5(7)(i), stage5(8)(i));
	end generate FA_5to4_generate2;
	
	FA_5to4_generate3: for i in 24 to 43 generate
		stage4(6)(i)<=FA_sum(stage5(9)(i), stage5(10)(i), stage5(11)(i));
		stage4(7)(i+1)<=FA_cout(stage5(9)(i), stage5(10)(i), stage5(11)(i));
	end generate FA_5to4_generate3;
	
	--HAs
	
	HA_5to4_generate0: for i in 16 to 17 generate
		stage4(0)(i)<=HA_sum(stage5(0)(i), stage5(1)(i));
		stage4(1)(i+1)<=HA_cout(stage5(0)(i), stage5(1)(i));
	end generate HA_5to4_generate0;
	
	HA_5to4_generate1: for i in 18 to 19 generate
		stage4(2)(i)<=HA_sum(stage5(3)(i), stage5(4)(i));
		stage4(3)(i+1)<=HA_cout(stage5(3)(i), stage5(4)(i));
	end generate HA_5to4_generate1;
	
	HA_5to4_generate2: for i in 20 to 21 generate
		stage4(4)(i)<=HA_sum(stage5(6)(i), stage5(7)(i));
		stage4(5)(i+1)<=HA_cout(stage5(6)(i), stage5(7)(i));
	end generate HA_5to4_generate2;
	
	HA_5to4_generate3: for i in 22 to 23 generate
		stage4(6)(i)<=HA_sum(stage5(9)(i), stage5(10)(i));
		stage4(7)(i+1)<=HA_cout(stage5(9)(i), stage5(10)(i));
	end generate HA_5to4_generate3;
	
	stage4(6)(44)<=HA_sum(stage5(9)(44), stage5(10)(44));
	stage4(6)(45)<=HA_cout(stage5(9)(44), stage5(10)(44));
	
	stage4(4)(46)<=HA_sum(stage5(6)(46), stage5(7)(46));
	stage4(4)(47)<=HA_cout(stage5(6)(46), stage5(7)(46));
	
	stage4(2)(48)<=HA_sum(stage5(3)(48), stage5(4)(48));
	stage4(2)(49)<=HA_cout(stage5(3)(48), stage5(4)(48));
	
	stage4(0)(50)<=HA_sum(stage5(0)(50), stage5(1)(50));
	stage4(0)(51)<=HA_cout(stage5(0)(50), stage5(1)(50));
	
	--direct connections
	
	connection_5to4_column0to15_generate_ext: for j in 0 to 15 generate
		connection_5to4_column0to15_generate_in: for i in 0 to 8 generate
			stage4(i)(j)<=stage5(i)(j);
		end generate connection_5to4_column0to15_generate_in;
	end generate connection_5to4_column0to15_generate_ext;

	connection_5to4_column16_generate: for i in 1 to 8 generate
		stage4(i)(16)<=stage5(i+1)(16);
	end generate connection_5to4_column16_generate;

	connection_5to4_column17_generate: for i in 2 to 8 generate
		stage4(i)(17)<=stage5(i)(17);
	end generate connection_5to4_column17_generate;

	connection_5to4_column18_generate: for i in 3 to 8 generate
		stage4(i)(18)<=stage5(i+2)(18);
	end generate connection_5to4_column18_generate;

	connection_5to4_column19_generate: for i in 4 to 8 generate
		stage4(i)(19)<=stage5(i+1)(19);
	end generate connection_5to4_column19_generate;

	connection_5to4_column20_generate: for i in 5 to 8 generate
		stage4(i)(20)<=stage5(i+3)(20);
	end generate connection_5to4_column20_generate;

	connection_5to4_column21_generate: for i in 6 to 8 generate
		stage4(i)(21)<=stage5(i+2)(21);
	end generate connection_5to4_column21_generate;

	connection_5to4_column22_generate: for i in 7 to 8 generate
		stage4(i)(22)<=stage5(i+4)(22);
	end generate connection_5to4_column22_generate;
	
	stage4(8)(23)<=stage5(11)(23);

	connection_5to4_column24to43_generate: for j in 24 to 43 generate
		stage4(8)(j)<=stage5(12)(j);
	end generate connection_5to4_column24to43_generate;
	
	-- connection_5to4_column24to30_generate: for j in 24 to 30 generate
		-- stage4(8)(j)<=stage5(12)(j);
	-- end generate connection_5to4_column24to30_generate;
	-- stage4(8)(31)<=stage6(15)(31);
	-- connection_5to4_column32to43_generate: for j in 32 to 43 generate
		-- stage4(8)(j)<=stage5(12)(j);
	-- end generate connection_5to4_column32to43_generate;
	
	stage4(8)(44)<=stage5(11)(44);

	connection_5to4_column45_generate: for i in 7 to 8 generate
		stage4(i)(45)<=stage5(i+2)(45);
	end generate connection_5to4_column45_generate;

	connection_5to4_column46_generate: for i in 6 to 8 generate
		stage4(i)(46)<=stage5(i+2)(46);
	end generate connection_5to4_column46_generate;

	connection_5to4_column47_generate: for i in 5 to 8 generate
		stage4(i)(47)<=stage5(i+1)(47);
	end generate connection_5to4_column47_generate;

	connection_5to4_column48_generate: for i in 4 to 8 generate
		stage4(i)(48)<=stage5(i+1)(48);
	end generate connection_5to4_column48_generate;

	connection_5to4_column49_generate: for i in 3 to 8 generate
		stage4(i)(49)<=stage5(i)(49);
	end generate connection_5to4_column49_generate;

	connection_5to4_column50_generate: for i in 2 to 8 generate
		stage4(i)(50)<=stage5(i)(50);
	end generate connection_5to4_column50_generate;

	connection_5to4_column51_generate: for i in 1 to 8 generate
		stage4(i)(51)<=stage5(i-1)(51);
	end generate connection_5to4_column51_generate;
	
	connection_5to4_column52to63_generate_ext: for j in 52 to 63 generate
		connection_5to4_column52to63_generate_in: for i in 0 to 8 generate
			stage4(i)(j)<=stage5(i)(j);
		end generate connection_5to4_column52to63_generate_in;
	end generate connection_5to4_column52to63_generate_ext;
	
	--------------------------------------------------------FROM STAGE4 TO STAGE3----------------------------------------------------------------------------
	
	--FAs
	
	FA_4to3_generate0: for i in 12 to 55 generate
		stage3(0)(i)<=FA_sum(stage4(0)(i), stage4(1)(i), stage4(2)(i));
		stage3(1)(i+1)<=FA_cout(stage4(0)(i), stage4(1)(i), stage4(2)(i));
	end generate FA_4to3_generate0;
	
	FA_4to3_generate1: for i in 14 to 53 generate
		stage3(2)(i)<=FA_sum(stage4(3)(i), stage4(4)(i), stage4(5)(i));
		stage3(3)(i+1)<=FA_cout(stage4(3)(i), stage4(4)(i), stage4(5)(i));
	end generate FA_4to3_generate1;
	
	FA_4to3_generate2: for i in 16 to 51 generate
		stage3(4)(i)<=FA_sum(stage4(6)(i), stage4(7)(i), stage4(8)(i));
		stage3(5)(i+1)<=FA_cout(stage4(6)(i), stage4(7)(i), stage4(8)(i));
	end generate FA_4to3_generate2;
	
	--HAs
	
	HA_4to3_generate0: for i in 10 to 11 generate
		stage3(0)(i)<=HA_sum(stage4(0)(i), stage4(1)(i));
		stage3(1)(i+1)<=HA_cout(stage4(0)(i), stage4(1)(i));
	end generate HA_4to3_generate0;
	
	HA_4to3_generate1: for i in 12 to 13 generate
		stage3(2)(i)<=HA_sum(stage4(3)(i), stage4(4)(i));
		stage3(3)(i+1)<=HA_cout(stage4(3)(i), stage4(4)(i));
	end generate HA_4to3_generate1;
	
	HA_4to3_generate2: for i in 14 to 15 generate
		stage3(4)(i)<=HA_sum(stage4(6)(i), stage4(7)(i));
		stage3(5)(i+1)<=HA_cout(stage4(6)(i), stage4(7)(i));
	end generate HA_4to3_generate2;
	
	stage3(4)(52)<=HA_sum(stage4(6)(52), stage4(7)(52));
	stage3(4)(53)<=HA_cout(stage4(6)(52), stage4(7)(52));
	
	stage3(2)(54)<=HA_sum(stage4(3)(54), stage4(4)(54));
	stage3(2)(55)<=HA_cout(stage4(3)(54), stage4(4)(54));
	
	stage3(0)(56)<=HA_sum(stage4(0)(56), stage4(1)(56));
	stage3(0)(57)<=HA_cout(stage4(0)(56), stage4(1)(56));
	
	--direct connections
	
	connection_4to3_column0to9_generate_ext: for j in 0 to 9 generate
		connection_4to3_column0to9_generate_in: for i in 0 to 5 generate
			stage3(i)(j)<=stage4(i)(j);
		end generate connection_4to3_column0to9_generate_in;
	end generate connection_4to3_column0to9_generate_ext;

	connection_4to3_column10_generate: for i in 1 to 5 generate
		stage3(i)(10)<=stage4(i+1)(10);
	end generate connection_4to3_column10_generate;

	connection_4to3_column11_generate: for i in 2 to 5 generate
		stage3(i)(11)<=stage4(i)(11);
	end generate connection_4to3_column11_generate;

	connection_4to3_column12_generate: for i in 3 to 5 generate
		stage3(i)(12)<=stage4(i+2)(12);
	end generate connection_4to3_column12_generate;

	connection_4to3_column13_generate: for i in 4 to 5 generate
		stage3(i)(13)<=stage4(i+1)(13);
	end generate connection_4to3_column13_generate;
	
	stage3(5)(14)<=stage4(8)(14);
	
	stage3(5)(53)<=stage4(6)(53);

	connection_4to3_column54_generate: for i in 4 to 5 generate
		stage3(i)(54)<=stage4(i+1)(54);
	end generate connection_4to3_column54_generate;

	connection_4to3_column55_generate: for i in 3 to 5 generate
		stage3(i)(55)<=stage4(i)(55);
	end generate connection_4to3_column55_generate;

	connection_4to3_column56_generate: for i in 2 to 5 generate
		stage3(i)(56)<=stage4(i)(56);
	end generate connection_4to3_column56_generate;

	connection_4to3_column57_generate: for i in 1 to 5 generate
		stage3(i)(57)<=stage4(i-1)(57);
	end generate connection_4to3_column57_generate;
	
	connection_4to3_column58to63_generate_ext: for j in 58 to 63 generate
		connection_4to3_column58to63_generate_in: for i in 0 to 5 generate
			stage3(i)(j)<=stage4(i)(j);
		end generate connection_4to3_column58to63_generate_in;
	end generate connection_4to3_column58to63_generate_ext;
	
	---------------------------------------------------------FROM STAGE3 TO STAGE2--------------------------------------------------------------------------------
	
	--FAs
	
	FA_3to2_generate0: for i in 8 to 59 generate
		stage2(0)(i)<=FA_sum(stage3(0)(i), stage3(1)(i), stage3(2)(i));
		stage2(1)(i+1)<=FA_cout(stage3(0)(i), stage3(1)(i), stage3(2)(i));
	end generate FA_3to2_generate0;
	
	FA_3to2_generate1: for i in 10 to 57 generate
		stage2(2)(i)<=FA_sum(stage3(3)(i), stage3(4)(i), stage3(5)(i));
		stage2(3)(i+1)<=FA_cout(stage3(3)(i), stage3(4)(i), stage3(5)(i));
	end generate FA_3to2_generate1;
	
	--HAs
	
	HA_3to2_generate0: for i in 6 to 7 generate
		stage2(0)(i)<=HA_sum(stage3(0)(i), stage3(1)(i));
		stage2(1)(i+1)<=HA_cout(stage3(0)(i), stage3(1)(i));
	end generate HA_3to2_generate0;
	
	HA_3to2_generate1: for i in 8 to 9 generate
		stage2(2)(i)<=HA_sum(stage3(3)(i), stage3(4)(i));
		stage2(3)(i+1)<=HA_cout(stage3(3)(i), stage3(4)(i));
	end generate HA_3to2_generate1;
	
	stage2(2)(58)<=HA_sum(stage3(3)(58), stage3(4)(58));
	stage2(2)(59)<=HA_cout(stage3(3)(58), stage3(4)(58));
	
	stage2(0)(60)<=HA_sum(stage3(0)(60), stage3(1)(60));
	stage2(0)(61)<=HA_cout(stage3(0)(60), stage3(1)(60));
	
	--direct connections
	
	connection_3to2_column0to5_generate_ext: for j in 0 to 5 generate
		connection_3to2_column0to5_generate_in: for i in 0 to 3 generate
			stage2(i)(j)<=stage3(i)(j);
		end generate connection_3to2_column0to5_generate_in;
	end generate connection_3to2_column0to5_generate_ext;

	connection_3to2_column6_generate: for i in 1 to 3 generate
		stage2(i)(6)<=stage3(i+1)(6);
	end generate connection_3to2_column6_generate;

	connection_3to2_column7_generate: for i in 2 to 3 generate
		stage2(i)(7)<=stage3(i)(7);
	end generate connection_3to2_column7_generate;
	
	stage2(3)(8)<=stage3(5)(8);
	
	stage2(3)(59)<=stage3(3)(59);

	connection_3to2_column60_generate: for i in 2 to 3 generate
		stage2(i)(60)<=stage3(i)(60);
	end generate connection_3to2_column60_generate;

	connection_3to2_column61_generate: for i in 1 to 3 generate
		stage2(i)(61)<=stage3(i-1)(61);
	end generate connection_3to2_column61_generate;
	
	connection_3to2_column62to63_generate_ext: for j in 62 to 63 generate
		connection_3to2_column62to63_generate_in: for i in 0 to 3 generate
			stage2(i)(j)<=stage3(i)(j);
		end generate connection_3to2_column62to63_generate_in;
	end generate connection_3to2_column62to63_generate_ext;
	
	---------------------------------------------------------FROM STAGE2 TO STAGE1-------------------------------------------------------------------------
	
	--FAs
	
	FA_2to1_generate: for i in 6 to 61 generate
		stage1(0)(i)<=FA_sum(stage2(0)(i), stage2(1)(i), stage2(2)(i));
		stage1(1)(i+1)<=FA_cout(stage2(0)(i), stage2(1)(i), stage2(2)(i));
	end generate FA_2to1_generate;
	
	--HAs
	
	HA_2to1_generate: for i in 4 to 5 generate
		stage1(0)(i)<=HA_sum(stage2(0)(i), stage2(1)(i));
		stage1(1)(i+1)<=HA_cout(stage2(0)(i), stage2(1)(i));
	end generate HA_2to1_generate;
	
	stage1(0)(62)<=HA_sum(stage2(0)(62), stage2(1)(62));
	stage1(0)(63)<=HA_cout(stage2(0)(62), stage2(1)(62));
	
	--direct connections
	
	connection_2to1_column0to3_generate_ext: for j in 0 to 3 generate
		connection_2to1_column0to3_generate_in: for i in 0 to 2 generate
			stage1(i)(j)<=stage2(i)(j);
		end generate connection_2to1_column0to3_generate_in;
	end generate connection_2to1_column0to3_generate_ext;

	connection_2to1_column4_generate: for i in 1 to 2 generate
		stage1(i)(4)<=stage2(i+1)(4);
	end generate connection_2to1_column4_generate;
	
	stage1(2)(5)<=stage2(2)(5);
	
	connection_2to1_column6to61_generate_ext: for j in 6 to 61 generate
			stage1(2)(j)<=stage2(3)(j);
	end generate connection_2to1_column6to61_generate_ext;
	
	stage1(2)(62)<=stage2(2)(62);

	connection_2to1_column63_generate: for i in 1 to 2 generate
		stage1(i)(63)<=stage2(i-1)(63);
	end generate connection_2to1_column63_generate;
	
	------------------------------------------------------------FROM STAGE1 to STAGE0---------------------------------------------------------------
		
	--FAs
	
	FA_1to0_generate: for i in 4 to 63 generate
		stage0(0)(i)<=FA_sum(stage1(0)(i), stage1(1)(i), stage1(2)(i));
		stage0(1)(i+1)<=FA_cout(stage1(0)(i), stage1(1)(i), stage1(2)(i));
	end generate FA_1to0_generate;
	
	--HAs
	
	HA_1to0_generate: for i in 2 to 3 generate
		stage0(0)(i)<=HA_sum(stage1(0)(i), stage1(1)(i));
		stage0(1)(i+1)<=HA_cout(stage1(0)(i), stage1(1)(i));
	end generate HA_1to0_generate;
	
	--direct connections

	connection_1to0_column0_generate: for i in 0 to 1 generate
		stage0(i)(0)<=stage1(i)(0);
	end generate connection_1to0_column0_generate;
	
	stage0(0)(1)<=stage1(0)(1);
	stage0(1)(1)<='0';
	
	stage0(1)(2)<=stage1(2)(2);
	
	stage0(0)(64)<=stage0(0)(63);	--sign extension
	
	--------------------------------------------------------FROM STAGE0 TO FINAL SUM--------------------------------------------------------------------------------
	
	x_tmp <= std_logic_vector(unsigned(stage0(0))+unsigned(stage0(1)));
	x <= x_tmp(2*N-1 downto 0);
end architecture behavioral;