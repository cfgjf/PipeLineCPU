.data 
arr: .space 4004
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"

.text
la $a0, input_file
li $a1, 0
li $a2, 0
li $v0, 13
syscall
move $a0, $v0
la $a1, arr
li $a2, 4004
li $v0, 14
syscall
li $v0, 16
syscall
la $s4, arr # s4为数组首地址


lw $a0, 0($s4) # a0为排序个数 ##
addi $s0, $zero, 0 # s0为比较次数
addi $a1, $s4, 4 # a1为当前排序元素的地址, 从第二个开始 ##
sll $a0, $a0, 2
add $a0, $a0, $s4 ## 额外添加
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
    beq $t2, $s4, insert # 此时待排序元素为最小 ##
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
    sw $s0, 0($s4) ##


