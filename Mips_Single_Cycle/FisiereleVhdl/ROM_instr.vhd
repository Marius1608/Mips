library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ROM is
    Port ( Address : in STD_LOGIC_VECTOR (5 downto 0);
           Data_out : out STD_LOGIC_VECTOR (31 downto 0));
end ROM;

architecture Behavioral of ROM is

type memory is array (0 to 31) of std_logic_vector (31 downto 0);
signal ROM: memory := ( B"000000_01010_01010_01010_00000_100110", --0  14A5026   xor $r10, $r10, $r10      Initializeaza registrul $r10 (pointer la adresa sirului) cu 0
                        B"000000_00000_00000_00000_00000_100110", --1  26        xor $r0, $r0, $r0         Initializeaza registrul $r0 (suma) cu 0
                        B"000000_11110_11110_11110_00000_100110", --2  3DEF026   xor $r30, $r30, $r30      Initializeaza registrul $r30 (pointer la adresa de memorie pentru rezultate) cu 0
                        B"000000_00011_00011_00011_00000_100110", --3  631826    xor $r3, $r3, $r3         Initializeaza registrul auxiliar $r3 cu 0
                        
                        B"001000_00011_00011_1111111111111111", --4  2063FFFF   addi $r3, $r3, 0xFFFF     $r3 = 0xFFFF (valoarea maxima a unui cuvânt pe 16 biti)
                        B"001000_11110_11110_0000000000000100", --5  23DE0004   addi $r30,$r30,4          Incrementeaza pointerul la adresa de memorie pentru rezultate  
                        B"100011_01010_00001_0000000000000000", --6  8D410000   lw $r1, 0($r10)           Incarca valoarea de la adresa 0 (Inceputul sirului) în registrul $r1  
                        B"001000_00000_00000_0000000000001000", --7  20000008   addi $r0, $r0, 8          Initializeaza un pointer la adresa de memorie pentru rezultate cu valoarea 8  
                        B"001000_00001_01011_0000000000111000", --8  202B0038   addi $r11, $r1, 56        $r11 = adresa sfarsitului sirului 
                        
                        B"000100_00001_01011_0000000000000101", --9     102B0005    beq $r1, $r11, offset 5   Continua bucla daca nu a ajuns la sfarsitul sirului
                        B"100011_00001_00010_0000000000000000", --10    8C220000    lw $r2, 0($r1)            Citeste valoarea curenta din sir la adresa indicata de $r1  
                        B"000000_00010_00011_00010_00000_100100", --11  00431024    and $r2, $r2, $r3         Pastreaza doar primii 16 biti mai putin semnificativi
                        B"000000_00000_00010_00000_00000_100000", --12  00020020    add $r0, $r0, $r2         Adauga valoarea la suma totalã
                        B"001000_00001_00001_0000000000000100", --13    20210004    addi $r1, $r1, 4          Incrementeaza pointerul la adresa urmatoare din sir
                        
                        B"000010_00000000000000000000001001", --14    08000009       j offset 9	              Continuare bucla
                        B"101011_11110_00000_0000000000000000", --15  AFC00000      sw $r0, offset($r30)      Scrie suma în memorie la adresa calculatã
                        others => x"FFFFFFFF");

begin
    Data_out <= ROM(conv_integer (Address));
end Behavioral;