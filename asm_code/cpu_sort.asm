lw $a0, 0($zero) # a0为排序个数
addi $s0, $zero, 0 # s0为比较次数
addi $a1, $zero, 4 # a1为当前排序元素的地址, 从第二个开始
sll $a0, $a0, 2
addi $a0, $a0, 4 # a0此时为最后一个元素地址 + 4
addi $v1, $zero, 1 # v1为1

for:
    addi $a1, $a1, 4
    beq $a1, $a0, sort_end
    j sort

sort:
    lw $t0, 0($a1) # t0为当前元素
    addi $t2, $a1, -4 # t2为比较元素地址
for1:
    lw $t1, 0($t2)
    addi $s0, $s0, 1 # 比较次数+1
    slt $t3, $t1, $t0
    beq $t3, $v1, insert
    beq $t2, $zero, insert # 此时待排序元素为最小
    addi $t2, $t2, -4
    j for1

insert:
    addi $t3, $a1, -4
    addi $t4, $a1, 0
    for2: 
        beq $t3, $t2, insert_end
        lw $t5, 0($t3)
        addi $t3, $t3, -4
        sw $t5, 0($t4)
        addi $t4, $t4, -4
        j for2
    insert_end:
        sw $t0, 0($t4)
        j for

sort_end:
    sw $s0, 0($zero)

    addi $a1, $a0, 0
    addi $a0, $zero, 0
    lui $s0, 16384
    addi $s0, $s0, 16
    addi $s1, $zero, 16384
    addi $s4, $zero, 128

    addi $a0, $a0, -4
for3:
    addi $a0, $a0, 4
    beq $a0, $a1, final

display:
    lw $t4, 0($a0)
    addi $s3, $zero, 0
    andi $t0, $t4, 15
    sll $t0, $t0, 2
    andi $t1, $t4, 240
    srl $t1, $t1, 2
    andi $t2, $t4, 3840
    srl $t2, $t2, 6
    andi $t3, $t4, 61440
    srl $t3, $t3, 10 

    add $t0, $t0, $a1
    lw $t0, 0($t0)
    add $t1, $t1, $a1
    lw $t1, 0($t1)
    add $t2, $t2, $a1
    lw $t2, 0($t2)
    add $t3, $t3, $a1
    lw $t3, 0($t3)

    addi $t0, $t0, 256
    addi $t1, $t1, 512
    addi $t2, $t2, 1024
    addi $t3, $t3, 2048


display_start:
    addi $s3, $s3, 1
    beq $s3, $s4, for3
    addi $s2, $zero, 0
    sw $t0, 0($s0)
digit0:
    addi $s2, $s2, 1
    beq $s2, $s1, digit0_out
    j digit0
digit0_out:
    addi $s2, $zero, 0
    sw $t1, 0($s0)
digit1:
    addi $s2, $s2, 1
    beq $s2, $s1, digit1_out
    j digit1
digit1_out:
    addi $s2, $zero, 0
    sw $t2, 0($s0)
digit2:
    addi $s2, $s2, 1
    beq $s2, $s1, digit2_out
    j digit2
digit2_out:
    addi $s2, $zero, 0
    sw $t3, 0($s0)
digit3:
    addi $s2, $s2, 1
    beq $s2, $s1, display_start
    j digit3


final:
    addi $t0, $zero, 0
    addi $t1, $zero, 1137
    sw $t1, 0($s0)
    final1:
        addi $t0, $t0, 1
        beq $t0, $s1, final1_out
        j final1
    final1_out:
        addi $t0, $zero, 0
        addi $t1, $zero, 518
        sw $t1, 0($s0)
    final2:
        addi $t0, $t0, 1
        beq $t0, $s1, final2_out
        j final2
    final2_out:
        addi $t0, $zero, 0
        addi $t1, $zero, 468
        sw $t1, 0($s0)
    final3:
    addi $t0, $t0, 1
    beq $t0, $s1, final
    j final3




