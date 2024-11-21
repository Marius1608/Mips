library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
 port ( 
        MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        Clk: in std_logic;
        EN: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        AluResOut: out std_logic_vector(31 downto 0);
        view: in STD_LOGIC_VECTOR (5 downto 0);
        test_en: in STD_LOGIC  
        );
end MEM;

architecture Behavioral of MEM is

type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal MEM : ram_type := (  0 => X"00000008", -- 8(adresa de unde incepe sirul de numere) 
                            1 => X"00000000", -- 0 
                            2 => X"00000000", -- 0 
                            3 => X"00000000", -- 0 
                            4 => X"00000000", -- 0  
                            5 => X"00000000", -- 0 
                            6 => X"00000000", -- 0  
                            7 => X"00000000", -- 0 
                            8 => X"00000004", -- 4 
                            9 => X"00000002", -- 2
                            10 => X"0000000A", -- 10
                            11 => X"00000023", -- 35
                            12 => X"00000012", -- 18
                            13 => X"00000005", -- 5 
                            14 => X"00000007", -- 7
                            15 => X"0000000F",  -- 15
                            others => X"00000000");
                            
signal Address: std_logic_vector(5 downto 0):=(others=>'0');
signal WriteData: std_logic_vector(31 downto 0):=(others=>'0');
signal ReadData: std_logic_vector(31 downto 0):=(others=>'0');


begin

WriteData<=RD2;
Address<="00" & ALUResIn(5 downto 2) when test_en = '0' else view; --(PC/4)

process(Clk)
begin
    if(rising_edge(Clk))then
        if EN='1' and MemWrite='1' then
            MEM(CONV_INTEGER(Address))<=WriteData;
         end if;
    end if;            
end process;

ReadData<=MEM(CONV_INTEGER(Address));
MemData<=ReadData;
AluResOut<=ALUResIn;

end Behavioral;
