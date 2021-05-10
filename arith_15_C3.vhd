library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity arith_15_C3 is
  generic(n : natural := 4);
  port(
    entry_C3 : in std_logic_vector(n-1 downto 0);
    result_C3 : out std_logic_vector(n-1 downto 0)
  );
end arith_15_C3;

architecture behavior of arith_15_C3 is

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

  signal carry0_C3, carry1_C3, carry2_C3, carry3_C3 : std_logic;
  signal sum0_C3, sum1_C3, sum2_C3, sum3_C3 : std_logic;
  signal cpa_in_1_C3, cpa_in_2_C3 : std_logic_vector(n-1 downto 0);

  begin

    U0: fulladder port map(entry_C3(0), entry_C3(3), entry_C3(1), carry0_C3, sum0_C3 );
    U1: fulladder port map(entry_C3(1), entry_C3(0), entry_C3(2), carry1_C3, sum1_C3 );
    U2: fulladder port map(entry_C3(2), entry_C3(1), entry_C3(3), carry2_C3, sum2_C3 );
    U3: fulladder port map(entry_C3(3), entry_C3(2), entry_C3(0), carry3_C3, sum3_C3 );

    cpa_in_1_C3 <= sum3_C3 & sum2_C3 & sum1_C3 & sum0_C3;
    cpa_in_2_C3 <= carry3_C3 & carry2_C3 & carry1_C3 & carry0_C3 ;

    U4: CPA_mod15 generic map(n => n)
                  port map(cpa_in_1_C3, cpa_in_2_C3, result_C3);
end behavior;
