library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
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
end UC;

architecture Behavioral of UC is
begin

process(Instr)
begin
    case Instr is
        --tip R
        when "000000" => RegDst <= '1';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
                         ALUOp <= "000000";
        --addi
        when "001000" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
                         ALUOp <= "100000";
        --ori                 
        when "001101" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
                         ALUOp <= "100001";
        --lw
        when "100011" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         Branch <= '0';
                         BranchGTZ <= '0'; 
                         Jump <= '0';  
                         MemWrite <= '0';
                         MemtoReg <= '1';
                         RegWrite <= '1';
                         ALUOp <= "100000";
        --sw
        when "101011" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '0'; 
                         MemWrite <= '1';
                         MemtoReg <= '0';
                         RegWrite <= '0';
                         ALUOp <= "100000";
        --beq
        when "000100" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         Branch <= '1';
                         BranchGTZ <= '0';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
                         ALUOp <= "100010";
       
        --bgez
        when "000001" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         Branch <= '0';
                         BranchGTZ <= '1';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
                         ALUOp <= "100010";
        --j
        when "000010" => RegDst <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '1';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
                         ALUOp <= "000000";
                         
         when others => RegDst <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         Branch <= '0';
                         BranchGTZ <= '0';
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
                         ALUOp <= "000000";
    end case;
end process;

end Behavioral;