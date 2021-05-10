 library IEEE;
 use IEEE.STD_LOGIC_1164.all;

 entity Mux4_1 is
    generic(n : natural);
    port ( A : in std_logic_vector (n-1 downto 0);
           B : in std_logic_vector (n-1 downto 0);
           C : in std_logic_vector (n-1 downto 0);
           D : in std_logic_vector (n-1 downto 0);
           Sel : in std_logic_vector(1 downto 0);
           S : out std_logic_vector (n-1 downto 0));
 end Mux4_1;

 architecture Mux of Mux4_1 is

 begin
      S <=  A when Sel = "00" else
            B when Sel = "01" else
            C when Sel = "10" else
            D;
 end Mux;
