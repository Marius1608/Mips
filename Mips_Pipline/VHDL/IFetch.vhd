library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port ( 
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump_Address : in STD_LOGIC_VECTOR(31 downto 0);
           Branch_Address : in STD_LOGIC_VECTOR(31 downto 0);
           PC_4 : out STD_LOGIC_VECTOR(31 downto 0);
           Instruction : out STD_LOGIC_VECTOR(31 downto 0)
           );
end IFetch;

architecture Behavioral of IFetch is

component ROM is
    Port ( 
           Address : in STD_LOGIC_VECTOR (5 downto 0);
           Data_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal Sum: STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal OutMux1: STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal OutMux2: STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal PC: STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');

begin

 Sum <= PC + 1;                                       
 PC_4 <= Sum;                                         
 OutMux1 <= Sum when PCSrc = '0' else Branch_Address; 
 OutMux2 <= OutMux1 when Jump = '0' else Jump_Address;
 
 c1: ROM port map(PC(5 downto 0), Instruction);
  
  process(clk, Reset) 
    begin
        if reset = '1' then 
            PC <= (others=>'0');
        elsif rising_edge (clk) then 
            PC <= OutMux2;
        end if;
    end process;

end Behavioral;