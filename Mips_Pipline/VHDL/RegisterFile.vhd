library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_file is
port ( 
       clk : in std_logic;
       ra1 : in std_logic_vector(4 downto 0);
       ra2 : in std_logic_vector(4 downto 0);
       wa : in std_logic_vector(4 downto 0);
       wd : in std_logic_vector(31 downto 0);
       regwr : in std_logic;
       rd1 : out std_logic_vector(31 downto 0);
       rd2 : out std_logic_vector(31 downto 0));
end reg_file;

architecture Behavioral of reg_file is
type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : reg_array:= (
                X"00000000",
                X"00000001",
                X"00000002",
                X"00000003",
                X"00000004",
                X"00000005",
                X"00000006",
                X"00000007",
                X"00000008",
                X"00000009",
                X"00000010",
                X"00000011",
                X"00000012",
                X"00000013",
                X"00000014",
                X"00000015",
                X"00000016",
                X"00000017",
                X"00000018",
                X"00000019",
                X"00000020",
                X"00000021",
                X"00000022",
                X"00000023",
                X"00000024",
                X"00000025",
                X"00000026",
                X"00000027",
                X"00000028",
                X"00000029",
                X"00000030",
                others => X"00000000");
    
    begin
    process(clk)
        begin
        if falling_edge(clk) then
         if regwr = '1' then
         reg_file(conv_integer(wa)) <= wd;
         end if;
        end if;
    end process;
    
    rd1 <= reg_file(conv_integer(ra1));
    rd2 <= reg_file(conv_integer(ra2));
    
end Behavioral;