library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
    Port ( 
           Clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0);
           WriteAdrres: in STD_LOGIC_VECTOR(4 downto 0);
           RTarget : out STD_LOGIC_VECTOR (4 downto 0);
           RDest : out STD_LOGIC_VECTOR (4 downto 0));
           
end ID;

architecture Behavioral of ID is


component reg_file is 
port ( 
       Clk : in std_logic; 
       Ra1 : in std_logic_vector(4 downto 0); 
       Ra2 : in std_logic_vector(4 downto 0); 
       Wa : in std_logic_vector(4 downto 0); 
       Wd : in std_logic_vector(31 downto 0); 
       Regwr : in std_logic; 
       Rd1 : out std_logic_vector(31 downto 0); 
       Rd2 : out std_logic_vector(31 downto 0)); 
end component;

begin
    
    RTarget <= Instr(20 downto 16);
    RDest <= Instr(15 downto 11);
    Ext_Imm(15 downto 0) <= Instr(15 downto 0);  
    Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0'); 
    func <= Instr(5 downto 0);
    sa <= Instr(10 downto 6);
  
    c1: reg_file port map(Clk, Instr(25 downto 21), Instr(20 downto 16), WriteAdrres, WD, RegWrite, RD1, RD2);
  
end Behavioral;