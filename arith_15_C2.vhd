library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity arith_15_C2 is
  generic(n : natural := 4);
  port(
    entry_C2 : in std_logic_vector(n-1 downto 0);
    result_C2 : out std_logic_vector(n-1 downto 0)
  );
end arith_15_C2;

architecture behavior of arith_15_C2 is

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

  signal carry0_C2, carry1_C2, carry2_C2, carry3_C2 : std_logic;
  signal sum0_C2, sum1_C2, sum2_C2, sum3_C2 : std_logic;
  signal cpa_in_1_C2, cpa_in_2_C2 : std_logic_vector(n-1 downto 0);

  begin

    U0: fulladder port map(entry_C2(0), entry_C2(2), entry_C2(1), carry0_C2, sum0_C2 );
    U1: fulladder port map(entry_C2(1), entry_C2(3), entry_C2(2), carry1_C2, sum1_C2 );
    U2: fulladder port map(entry_C2(2), entry_C2(0), entry_C2(3), carry2_C2, sum2_C2 );
    U3: fulladder port map(entry_C2(3), entry_C2(1), entry_C2(0), carry3_C2, sum3_C2 );

    cpa_in_1_C2 <= sum3_C2 & sum2_C2 & sum1_C2 & sum0_C2;
    cpa_in_2_C2 <= carry3_C2 & carry2_C2 & carry1_C2 & carry0_C2 ;

    U4: CPA_mod15 generic map(n => n)
                  port map(cpa_in_1_C2, cpa_in_2_C2, result_C2);
end behavior;
