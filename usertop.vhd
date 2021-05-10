library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity usertop is
	generic (n : natural := 4);
	port(	SW    : in std_logic_vector(17 downto 0);
		  	LEDR : out std_logic_vector(17 downto 0)
				);
end usertop;

architecture behavior of usertop is

  component Mux4_1 is
    generic ( n : natural := 4 );
    port (
      A : in std_logic_vector(n-1 downto 0);
      B : in std_logic_vector(n-1 downto 0);
      C : in std_logic_vector(n-1 downto 0);
      D : in std_logic_vector(n-1 downto 0);
      Sel : in std_logic_vector(1 downto 0);
      S : out std_logic_vector(n-1 downto 0)
    );
  end component;

  component arith_15_C2 is
    generic(n : natural := 4);
    port(
      entry_C2 : in std_logic_vector(n-1 downto 0);
      result_C2 : out std_logic_vector(n-1 downto 0)
    );
  end component;

  component arith_15_C3 is
    generic(n : natural := 4);
    port(
      entry_C3 : in std_logic_vector(n-1 downto 0);
      result_C3 : out std_logic_vector(n-1 downto 0)
    );
  end component;

  component arith_15_C4 is
    generic(n : natural := 4);
    port(
      entry_C4 : in std_logic_vector(n-1 downto 0);
      result_C4 : out std_logic_vector(n-1 downto 0)
    );
  end component;

  -- moduli 17, moduli 15, moduli 256
  -- 5 bits, 4 bits, 8 bits
  -- 16 -> 12 , 11 -> 8 , 7 -> 0
  component traditionalSystem_RNStoBin is
    generic (n : natural := 4);
  	port(
  		RNS_2_BIN_in  : in STD_LOGIC_VECTOR(16 downto 0);
  		RNS_2_BIN_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component traditionalSystem_BinToRNS is
    generic (n : natural := 4);
  	port(
      BIN_2_RNS_in      : in std_logic_vector(15 downto 0);
  		BIN_2_RNS_out_15  : out std_logic_vector(3 downto 0);
  		BIN_2_RNS_out_17  : out std_logic_vector(4 downto 0);
  		BIN_2_RNS_out_256 : out std_logic_vector(7 downto 0)
  	);
  end component;

  signal mux_select : std_logic_vector(1 downto 0);
  signal top_entry, top_result : std_logic_vector(4*n-1 downto 0);
  signal top_mod_256 : std_logic_vector(2*n-1 downto 0);
  signal top_mod_15 : std_logic_vector(n-1 downto 0);
  --signal top_mod_15_C1, top_mod_15_C2, top_mod_15_C3, top_mod_15_C4 : std_logic_vector(n-1 downto 0);
  signal top_mod_17 : std_logic_vector(n downto 0);
  signal mux_C1, mux_C2, mux_C3, mux_C4 : std_logic_vector(n-1 downto 0);
  signal top_rns_bin : std_logic_vector(4*n downto 0);

  begin

    top_entry <= SW(15 downto 0);
    mux_select <= SW(17 downto 16);

    U0: traditionalSystem_BinToRNS
      generic map(n => 4)
      port map(
        top_entry, top_mod_15, top_mod_17, top_mod_256
      );

    mux_C1 <= top_mod_15(2 downto 0) & top_mod_15(3);

    U1: arith_15_C2
      port map( top_mod_15, mux_C2 );

    U2: arith_15_C3
      port map( top_mod_15, mux_C3 );

    U3: arith_15_C4
      port map( top_mod_15, mux_C4 );

    U4: Mux4_1
      generic map(n => n)
      port map(
        mux_C1, mux_C2, mux_C3, mux_C4, mux_select, top_rns_bin(11 downto 8)
      );

    top_rns_bin(16 downto 12) <= top_mod_17;
    top_rns_bin(7 downto 0) <= top_mod_256;

    U5: traditionalSystem_RNStoBin
      generic map(n => n)
      port map(
        top_rns_bin, top_result
      );

    LEDR(15 downto 0) <= top_result;
    LEDR(17 downto 16) <= mux_select;

end behavior;
