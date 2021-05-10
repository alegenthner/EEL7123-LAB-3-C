library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity traditionalSystem_BinToRNS is
	generic (n : natural := 4);
	port(	BIN_2_RNS_in    : in std_logic_vector(15 downto 0);
		  	BIN_2_RNS_out_15 : out std_logic_vector(3 downto 0);
				BIN_2_RNS_out_17 : out std_logic_vector(4 downto 0);
				BIN_2_RNS_out_256 : out std_logic_vector(7 downto 0)
				);
end traditionalSystem_BinToRNS;

architecture Structural of traditionalSystem_BinToRNS is

  component CSA_EAC is
         generic (n : natural := 4);
  	 port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      S : out STD_LOGIC_VECTOR((n-1) downto 0);
	      C : out STD_LOGIC_VECTOR((n-1) downto 0));
  end component;

  component CPA_mod15 is
    generic(n : natural :=4);
     port(
       s1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       c1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       f : out STD_LOGIC_VECTOR(n-1 downto 0)
         );
  end component;

  component CSA_IEAC is
         generic (n : natural := 4);
  	 port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      S : out STD_LOGIC_VECTOR((n-1) downto 0);
	      C : out STD_LOGIC_VECTOR((n-1) downto 0));
  end component;

  component CPA_mod17 is
    generic(n : natural :=5);
     port(
       s1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       c1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       f : out STD_LOGIC_VECTOR(n-1 downto 0)
         );
  end component;

signal zeros : std_logic_vector(n-1 downto 0);
signal sum0_2n_m1 , carry0_2n_m1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_m1 , carry1_2n_m1 : std_logic_vector(n-1 downto 0);

signal sum0_2n_p1 , carry0_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_p1 , carry1_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum2_2n_p1 , carry2_2n_p1 : std_logic_vector(n-1 downto 0);

signal sum3_2n_p1 , carry3_2n_p1 : std_logic_vector(n downto 0);

signal notBIN_2_RNS_in : std_logic_vector(4*n-1 downto 0);

begin
	-- enter your statements here --
zeros <= (others =>'0');
notBIN_2_RNS_in <= not(BIN_2_RNS_in); -- Para obter os negativos das entradas


-- Conversão Modulo 256
BIN_2_RNS_out_256 <= BIN_2_RNS_in(2*n-1 downto 0);

-- Conversão Modulo 15
comp0_2n_m1: CSA_EAC generic map	(  n => n)
	             port map ( I0 => BIN_2_RNS_in(n-1 downto 0), I1 => BIN_2_RNS_in(2*n-1 downto n), I2 => BIN_2_RNS_in(3*n-1 downto 2*n), S =>sum0_2n_m1 , C =>carry0_2n_m1);
comp1_2n_m1: CSA_EAC generic map	(  n => n)
	             port map (I0 => sum0_2n_m1, I1 => carry0_2n_m1, I2 => BIN_2_RNS_in(4*n-1 downto 3*n), S => sum1_2n_m1, C => carry1_2n_m1); -- A fazer pel@ alun@
add_2n_m1: CPA_mod15 generic map	(  n => n)
                     port map(s1 => sum1_2n_m1, c1 => carry1_2n_m1, f => BIN_2_RNS_out_15); -- A fazer pel@ alun@

-- Conversão Modulo 17
comp0_2n_p1: CSA_IEAC generic map	(  n => n)
	              port map (I0 => BIN_2_RNS_in(n-1 downto 0), I1 => notBIN_2_RNS_in(2*n-1 downto n), I2 => BIN_2_RNS_in(3*n-1 downto 2*n), S =>sum0_2n_p1 , C =>carry0_2n_p1); -- A fazer pel@ alun@
comp1_2n_p1: CSA_IEAC generic map	(  n => n)
	              port map (I0 => sum0_2n_p1, I1 => carry0_2n_p1, I2 => notBIN_2_RNS_in(4*n-1 downto 3*n), S =>sum1_2n_p1 , C =>carry1_2n_p1); -- A fazer pel@ alun@
comp2_2n_p1: CSA_IEAC generic map	(  n => n)
	              port map (I0 => "0001" , I1 => sum1_2n_p1, I2 => carry1_2n_p1, S =>sum2_2n_p1 , C =>carry2_2n_p1); -- A fazer pel@ alun@

sum3_2n_p1 <= '0' & sum2_2n_p1;
carry3_2n_p1 <= '0' & carry2_2n_p1;

add_2n_p1: CPA_mod17 generic map	(  n => n+1)
                      port map(s1=> sum3_2n_p1, c1 => carry3_2n_p1, f  => BIN_2_RNS_out_17);

end Structural;
