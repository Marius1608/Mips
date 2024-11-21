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
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0);
           RegDst : in STD_LOGIC;
           RTarget : in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           RDest : in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           RWrite_Address : out STD_LOGIC_VECTOR (4 downto 0) := (others => '0'));
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
signal Reset_IF : STD_LOGIC :='0';
signal Jump_IF : STD_LOGIC :='0';
signal PCSrc_IF : STD_LOGIC :='0';
signal Jump_Address_IF : STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
signal Branch_Address_IF : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal PC_4_IF : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction_IF : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--ID
signal RegWrite_ID : STD_LOGIC :='0';
signal Instruction_ID : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RegDst_ID : STD_LOGIC :='0';
signal WD_ID : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal ExtOp_ID : STD_LOGIC :='0';
signal RD1_ID : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal RD2_ID : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal Ext_Imm_ID : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal func_ID : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
signal sa_ID : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
signal WriteAddress_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal RTarget_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal RDest_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

--UC
signal Instruction_UC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RegDst_UC : STD_LOGIC := '0';
signal ExtOp_UC : STD_LOGIC := '0';
signal ALUSrc_UC : STD_LOGIC := '0';
signal Branch_UC : STD_LOGIC := '0';
signal BranchGTZ_UC : STD_LOGIC := '0';
signal ALUOp_UC : STD_LOGIC_VECTOR (5 downto 0) := (others=>'0');
signal Jump_UC : STD_LOGIC := '0';
signal MemWrite_UC : STD_LOGIC := '0';
signal MemtoReg_UC : STD_LOGIC := '0';
signal RegWrite_UC : STD_LOGIC := '0';


--EX
signal RD1_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ALUSrc_EX : STD_LOGIC := '0';
signal RD2_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Ext_Imm_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal sa_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal func_EX : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal ALUOp_EX : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal PC_4_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal GTZ_EX : STD_LOGIC := '0';
signal Zero_EX : STD_LOGIC := '0';
signal ALURes_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Branch_Address_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

signal RegDst_EX : STD_LOGIC := '0';
signal RTarget_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal RDest_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal RWrite_Address_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

--MEM
signal MemWrite_MEM : STD_LOGIC := '0';
signal ALUResIn_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal RD2_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal MemData_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ALUResOut_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

signal IF_ID : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal ID_EX : STD_LOGIC_VECTOR (162 downto 0) := (others => '0');
signal EX_MEM : STD_LOGIC_VECTOR (108 downto 0) := (others => '0');
signal MEM_WB : STD_LOGIC_VECTOR (71 downto 0) := (others => '0');

signal WD : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


begin
   
    Reset_IF<=btn(1);
  
    c1: MPG port map(Enable, btn(0), clk);
    c2: IFetch port map(Enable, Reset_IF,Jump_IF ,PCSrc_IF ,Jump_Address_IF, Branch_Address_IF, PC_4_IF, Instruction_IF);
    c3: SEGMENTE port map(clk, Digits, an, cat);
    c4: ID port map(Enable, RegWrite_ID, Instruction_ID(25 downto 0), WD_ID, ExtOp_ID, RD1_ID, RD2_ID, Ext_Imm_ID, func_ID, sa_ID,WriteAddress_ID,RTarget_ID,RDest_ID);
  
    led(0) <= RegDst_UC;
    led(1) <= ExtOp_UC;
    led(2) <= ALUSrc_UC;
    led(3) <= Branch_UC;
    led(4) <= BranchGTZ_UC;
    led(6) <= Jump_UC;
    led(12 downto 7) <= ALUOp_UC;
    led(13) <= MemWrite_UC;
    led(14) <= MemtoReg_UC;
    led(15) <= RegWrite_UC;
    
    c5: UC port map(Instruction_UC(31 downto 26), RegDst_UC, ExtOp_UC, ALUSrc_UC, Branch_UC, BranchGTZ_UC, Jump_UC, MemWrite_UC, MemtoReg_UC, RegWrite_UC,ALUOp_UC);  
    c6: EX port map(RD1_EX, ALUSrc_EX, RD2_EX, Ext_Imm_EX,sa_EX,func_EX,ALUOp_EX,PC_4_EX,GTZ_EX,Zero_EX,ALURes_EX,Branch_Address_EX,RegDst_EX,RTarget_EX,RDest_EX,RWrite_Address_EX);
    c7: MEM port map(MemWrite_MEM,ALUResIn_MEM,RD2_MEM,clk,Enable,MemData_MEM,ALUResOut_MEM,sw(15 downto 10), sw(0));
    
    WD <= MEM_WB(65 downto 34) when MEM_WB(0) = '0' else MEM_WB(33 downto 2);   
    
     process(Enable)
     begin
        if rising_edge(Enable) then 
       
            IF_ID(31 downto 0) <= PC_4_IF;
            IF_ID(63 downto 32) <= Instruction_IF;
            
       
            ID_EX(0) <= MemtoReg_UC;
            ID_EX(1) <= RegWrite_UC;
            ID_EX(2) <= MemWrite_UC;
            ID_EX(3) <= Branch_UC;
            ID_EX(4) <= BranchGTZ_UC;
            ID_EX(10 downto 5) <= ALUOp_UC;
            ID_EX(11) <= ALUSrc_UC;
            ID_EX(12) <= RegDst_UC;
            ID_EX(44 downto 13) <= IF_ID(31 downto 0);
            ID_EX(76 downto 45) <= RD1_ID;
            ID_EX(108 downto 77) <= RD2_ID;
            ID_EX(113 downto 109) <= sa_ID;
            ID_EX(145 downto 114) <= Ext_Imm_ID;
            ID_EX(151 downto 146) <= func_ID;
            ID_EX(156 downto 152) <= RTarget_ID;
            ID_EX(161 downto 157) <= RDest_ID;
            
       
            EX_MEM(4 downto 0) <= ID_EX(4 downto 0);
            EX_MEM(36 downto 5) <= Branch_Address_EX;
            EX_MEM(37) <= Zero_EX;
            EX_MEM(38) <= GTZ_EX;
            EX_MEM(70 downto 39) <= ALURes_EX;
            EX_MEM(102 downto 71) <= ID_EX(109 downto 78);
            EX_MEM(107 downto 103) <= RWrite_Address_EX;
        
  
            MEM_WB(1 downto 0) <= EX_MEM(1 downto 0);
            MEM_WB(33 downto 2) <= MemData_MEM;
            MEM_WB(65 downto 34) <= ALUResOut_MEM;
            MEM_WB(70 downto 66) <= EX_MEM(107 downto 103);
            
        end if;
     end process;
    
     process (sw(7 downto 5),clk)
        begin
        case sw(7 downto 5) is
            when "000" => digits <= IF_ID(63 downto 32); 
            when "001" => digits <= PC_4_IF; 
            when "010" => digits <= ID_EX(76 downto 45); 
            when "011" => digits <= ID_EX(108 downto 77); 
            when "100" => digits <= ID_EX(145 downto 114); 
            when "101" => digits <= ALURes_EX; 
            when "110" => digits <= MemData_MEM; 
            when "111" => digits <= WD_ID;
            when others => digits <= x"FFFFFFFF";
        end case;
     end process;
   
   
        Jump_Address_IF <= IF_ID(31 downto 26) & IF_ID(57 downto 32);
        Branch_Address_IF <= EX_MEM(36 downto 5);
        Jump_IF <= Jump_UC;
        PCSrc_IF <= (EX_MEM(3) and EX_MEM(37)) or (EX_MEM(4) and EX_MEM(38));
   

        Instruction_UC <= IF_ID(63 downto 32);
        
        
        Instruction_ID <= IF_ID(63 downto 32);
        RegWrite_ID <= MEM_WB(1);
        ExtOp_ID <= ExtOp_UC;
        WriteAddress_ID <= MEM_WB(70 downto 66);
        WD_ID <= WD;
        
   
        RD1_EX <= ID_EX(76 downto 45);
        ALUSrc_EX <= ID_EX(12);
        RD2_EX <= ID_EX(108 downto 77);
        Ext_Imm_EX <= ID_EX(145 downto 114);
        sa_EX <= ID_EX(114 downto 110);
        func_EX <= ID_EX(151 downto 146);
        ALUOp_EX <= ID_EX(10 downto 5);
        PC_4_EX <= ID_EX(44 downto 13);
        RegDst_EX <= ID_EX(12);
        RTarget_EX <= ID_EX(156 downto 152);
        RDest_EX <= ID_EX(161 downto 157);
 
 
        MemWrite_MEM <= EX_MEM(2);
        ALUResIn_MEM <= EX_MEM(70 downto 39);
        RD2_MEM <= EX_MEM(102 downto 71);
    
    
  
end Behavioral;