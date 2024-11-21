library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ROM is
    Port ( Address : in STD_LOGIC_VECTOR (5 downto 0);
           Data_out : out STD_LOGIC_VECTOR (31 downto 0));
end ROM;

architecture Behavioral of ROM is

type memory is array (0 to 31) of std_logic_vector (31 downto 0);
signal ROM: memory := ( 
                        B"000000_11110_11110_11110_00000_100110", --0   03DEF026     xor $r30, $r30, $r30      Initializeaza registrul $r30 (pointer la adresa de memorie pentru rezultate) cu 0
                        B"000000_00011_00011_00011_00000_100110", --1   00631826     xor $r3, $r3, $r3         Initializeaza registrul auxiliar $r3 cu 0
                        B"000000_01010_01010_01010_00000_100110", --2   014A5026     xor $r10, $r10, $r10      Initializeaza registrul $r10 (pointer la adresa sirului) cu 0
                        B"000000_00000_00000_00000_00000_100110", --3   00000026     xor $r0, $r0, $r0         Initializeaza registrul $r0 (suma) cu 0
                        
                        B"001000_00011_00011_1111111111111111", --4     2063FFFF   addi $r3, $r3, 0xFFFF     $r3 = 0xFFFF (valoarea maxima a unui cuv�nt pe 16 biti)
                        B"001000_11110_11110_0000000000000100", --5     23DE0004   addi $r30,$r30,4          Incrementeaza pointerul la adresa de memorie pentru rezultate  
                        B"100011_01010_00001_0000000000000000", --6     8D410000   lw $r1, 0($r10)           Incarca valoarea de la adresa 0 (Inceputul sirului) �n registrul $r1  
                       
                        B"001000_00000_00000_0000000000001000", --7     20000008   addi $r0, $r0, 8          Initializeaza un pointer la adresa de memorie pentru rezultate cu valoarea 8  
                        B"11111111111111111111111111111111",    --8     FFFFFFFF
                        
                        B"001000_00001_01011_0000000000111000", --9     202B0038   addi $r11, $r1, 56        $r11 = adresa sfarsitului sirului 
                        B"11111111111111111111111111111111",    --10    FFFFFFFF
                        B"11111111111111111111111111111111",    --11    FFFFFFFF
                        
                        B"000100_00001_01011_0000000000001101", --12    102B000D    beq $r1, $r11, offset 13   Continua bucla daca nu a ajuns la sfarsitul sirului
                        B"11111111111111111111111111111111",    --13    FFFFFFFF
                        B"11111111111111111111111111111111",    --14    FFFFFFFF
                        B"11111111111111111111111111111111",    --15    FFFFFFFF
                        
                        B"100011_00001_00010_0000000000000000", --16    8C220000    lw $r2, 0($r1)            Citeste valoarea curenta din sir la adresa indicata de $r1  
                        B"11111111111111111111111111111111",    --17    FFFFFFFF
                        B"11111111111111111111111111111111",    --18    FFFFFFFF
                        
                        B"000000_00010_00011_00010_00000_100100", --19    00431024    and $r2, $r2, $r3         Pastreaza doar primii 16 biti mai putin semnificativi
                        B"11111111111111111111111111111111",      --20    FFFFFFFF
                        B"11111111111111111111111111111111",      --21    FFFFFFFF
                        
                        B"000000_00000_00010_00000_00000_100000", --22    00020020    add $r0, $r0, $r2         Adauga valoarea la suma total�
                        B"001000_00001_00001_0000000000000100",   --23    20210004    addi $r1, $r1, 4          Incrementeaza pointerul la adresa urmatoare din sir
                        
                        B"000010_00000000000000000000001100", --24    0800000C       j offset 12	              Continuare bucla
                        B"11111111111111111111111111111111",  --25    FFFFFFFF
                       
                        B"101011_11110_00000_0000000000000000", --26  AFC00000      sw $r0, offset($r30)      Scrie suma �n memorie la adresa calculat�
                        B"11111111111111111111111111111111",    --27  FFFFFFFF
                       
                        others => x"FFFFFFFF");

begin
    Data_out <= ROM(conv_integer (Address));
end Behavioral;