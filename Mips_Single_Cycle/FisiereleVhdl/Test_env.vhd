library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( 
           Enable : out STD_LOGIC;
           Btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SEGMENTE is
    Port ( 
           clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component IFetch is
    Port ( 
           Clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump_Address : in STD_LOGIC_VECTOR(31 downto 0);
           Branch_Address : in STD_LOGIC_VECTOR(31 downto 0);
           PC_4 : out STD_LOGIC_VECTOR(31 downto 0);
           Instruction : out STD_LOGIC_VECTOR(31 downto 0)
           );
end component;

component ID is
    Port ( 
           clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
           RegDst : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component UC is
    Port ( 
           Instr : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           BranchGTZ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (5 downto 0)
           );
end component;

component EX is
    Port (  
           RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(5 downto 0);
           PC_4 : in STD_LOGIC_VECTOR (31 downto 0);
           GTZ : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MEM is
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
end component;

--MPG
signal Enable: std_logic := '0';

--SSD
signal Digits: std_logic_vector (31 downto 0) := (others => '0');

--IFECH
signal Pc: std_logic_vector (31 downto 0) := (others => '0');
signal Reset : STD_LOGIC :='0';
signal Jump : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC :='0';
signal Jump_Address : STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
signal Branch_Address : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal PC_4 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--ID
signal RegWrite : STD_LOGIC :='0';
signal RegDst : STD_LOGIC :='0';
signal WD : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal ExtOp : STD_LOGIC :='0';
signal RD1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal Ext_Imm : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal func : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
signal sa : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');

--UC
signal ALUSrc : STD_LOGIC := '0';
signal Branch : STD_LOGIC := '0';
signal BranchGTZ : STD_LOGIC := '0';
signal ALUOp : STD_LOGIC_VECTOR (5 downto 0) := (others=>'0');
signal MemWrite : STD_LOGIC := '0';
signal MemtoReg : STD_LOGIC := '0';


--EX
signal AluRes: std_logic_vector(31 downto 0):=(others=>'0');
signal Zero: std_logic:='0';
signal GTZ : STD_LOGIC := '0';

--MEM
signal AluResOut: std_logic_vector(31 downto 0):=(others=>'0');
signal MemData: std_logic_vector(31 downto 0):=(others=>'0');


begin
   
    Reset<=btn(1);
  
    c1: MPG port map(Enable, btn(0), clk);
    c2: IFetch port map(Enable, Reset,Jump ,PCSrc ,Jump_Address, Branch_Address, PC_4, Instruction);
    c3: SEGMENTE port map(clk, Digits, an, cat);
    c4: ID port map(Enable, RegWrite, Instruction(25 downto 0), RegDst, WD, ExtOp, RD1, RD2, Ext_Imm, func, sa);
  
    led(0) <= RegDst;
    led(1) <= ExtOp;
    led(2) <= ALUSrc;
    led(3) <= Branch;
    led(4) <= BranchGTZ;
    led(6) <= Jump;
    led(12 downto 7) <= ALUOp;
    led(13) <= MemWrite;
    led(14) <= MemtoReg;
    led(15) <= RegWrite;
    
    c5: UC port map(Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, BranchGTZ, Jump, MemWrite, MemtoReg, RegWrite,ALUOp);  
    c6: EX port map(RD1,ALUSrc,RD2,Ext_Imm,sa,func,ALUOp,PC_4,GTZ,Zero,AluRes,Branch_Address);
    c7: MEM port map(MemWrite,AluRes,RD2,clk,enable,MemData,AluResOut,sw(15 downto 10), sw(0));
    
       
    Jump_Address <= PC_4(31 downto 26) & Instruction(25 downto 0);
    WD<=AluResOut when MemtoReg='0' else MemData;
    PCSrc<=(BranchGTZ and GTZ)or(Zero and Branch);
    
    process (sw(7 downto 5),Instruction,PC_4,RD1,RD2,Ext_Imm,AluRes,MemData,WD)
    begin
    case sw(7 downto 5) is
      when "000" => digits <= Instruction;
      when "001" => digits <= PC_4;
      when "010" => digits <= RD1;
      when "011" => digits <= RD2;
      when "100" => digits <= Ext_Imm;
      when "101" => digits <= AluRes;
      when "110" => digits <=MemData;
      when "111" => digits <= WD;
      when others => digits <= x"FFFFFFFF";
     end case;
    end process;
				
end Behavioral;