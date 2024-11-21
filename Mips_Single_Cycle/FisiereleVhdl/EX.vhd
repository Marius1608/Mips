library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.ALL;

entity EX is
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
end EX;

architecture Behavioral of EX is

signal OutMux : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal AluOpRez : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');

begin
    
    OutMux <= RD2 when ALUSrc = '0' else Ext_Imm;
    AluOpRez <= func when ALUOp = 0 else ALUOp;
    Branch_Address <= Ext_Imm + PC_4;
    
    process(RD1, OutMux, AluOpRez)
    variable AluOut: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    begin
        case AluOpRez is
            --add
            when "100000" => AluOut := RD1 + OutMux;
            --sub
            when "100010" => AluOut := RD1 - OutMux;
            --sll
            when "000000" => AluOut :=  to_stdlogicvector(to_bitvector(OutMux) sll conv_integer(sa)); 
            --srl
            when "000010" => AluOut :=  to_stdlogicvector(to_bitvector(OutMux) srl conv_integer(sa)); 
            --and
            when "100100" => AluOut := RD1 and OutMux;
            --or
            when "100101" => AluOut := RD1 or OutMux;
            --xor
            when "100110" => AluOut := RD1 xor OutMux;
            --slt
            when "101010" => if RD1 < OutMux then
                    AluOut := (others => '1');
                    AluOut := (others => '0');
                end if;
            when others => AluOut := (others=>'0');
        end case;
        
        if AluOut = 0 then
            Zero <= '1';
        else 
            Zero <= '0';
        end if;
        
        if signed(AluOut) > 0 then
            GTZ <= '1';
        else 
            GTZ <= '0';
        end if;
       
        ALURes <= AluOut;
    end process;
    
   
end Behavioral;