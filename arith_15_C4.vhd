library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity arith_15_C4 is
  generic(n : natural := 4);
  port(
    entry_C4 : in std_logic_vector(n-1 downto 0);
    result_C4 : out std_logic_vector(n-1 downto 0)
  );
end arith_15_C4;

architecture behavior of arith_15_C4 is

  component CPA_mod15 is
    generic(n : natural := 4);
    port(
      s1 : in std_logic_vector(n-1 downto 0);
      c1 : in std_logic_vector(n-1 downto 0);
      f : out std_logic_vector(n-1 downto 0)
    );
  end component;

  component fulladder is
    port(
      A : in std_logic;
      B : in std_logic;
      Cin : in std_logic;
      S : out std_logic;
      Cout : out std_logic
    );
  end component;

  signal carry0_C4, carry1_C4, carry2_C4, carry3_C4 : std_logic;
  signal sum0_C4, sum1_C4, sum2_C4, sum3_C4 : std_logic;
  signal cpa_in_1_C4, cpa_in_2_C4 : std_logic_vector(n-1 downto 0);

  begin

    U0: fulladder port map(entry_C4(0), entry_C4(3), entry_C4(2), carry0_C4, sum0_C4 );
    U1: fulladder port map(entry_C4(1), entry_C4(0), entry_C4(3), carry1_C4, sum1_C4 );
    U2: fulladder port map(entry_C4(2), entry_C4(1), entry_C4(0), carry2_C4, sum2_C4 );
    U3: fulladder port map(entry_C4(3), entry_C4(2), entry_C4(1), carry3_C4, sum3_C4 );

    cpa_in_1_C4 <= sum3_C4 & sum2_C4 & sum1_C4 & sum0_C4;
    cpa_in_2_C4 <= carry3_C4 & carry2_C4 & carry1_C4 & carry0_C4 ;

    U4: CPA_mod15 generic map(n => n)
                  port map(cpa_in_1_C4, cpa_in_2_C4, result_C4);
end behavior;
