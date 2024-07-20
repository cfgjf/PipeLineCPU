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

li $s6, 1 # s6 = 1
li $s5, -1 # s5 = -1
li $s7, 0 # s7 -> cpr
la $s1, arr
lw $s0, 0($s1) # s0 -> N
addi $s1, $s1, 4 # s1 -> arr[1]
addi $s4, $s1, -4 # s4 -> arr[0]
addi $s3, $s0, -1

li $s2, 0
for: addi $s2, $s2, 1
jal sort
bne $s2, $s3, for
sw $s7, 0($s4)
la $a0, output_file
li $a1, 1
li $a2, 0
li $v0, 13
syscall
move $a0, $v0
la $a1, arr
sll $a2, $s0, 2
addi $a2, $a2, 4
li $v0, 15
syscall
li $v0, 16
syscall
li $v0, 10
syscall

sort: addi $t0, $s2, -1
move $t1, $s2
sll $t1, $t1, 2
add $t1, $s1, $t1
lw $t1, 0($t1) # t1 -> cur
sll $t0, $t0, 2
add $t0, $s1, $t0
for1: addi $s7, $s7, 1
lw $t6, 0($t0)
slt $t2, $t6, $t1
beq $t2, $s6, insert0
beq $t0, $s1, insert1
addi $t0, $t0, -4
j for1

insert0: addi $t0, $t0, 4
insert1: sll $t2, $s2, 2
add $t2, $t2, $s1
addi $t3, $t2, -4
for2: beq $t2, $t0, end
lw $t4, 0($t3)
sw $t4, 0($t2)
addi $t2, $t2, -4
addi $t3, $t3, -4
j for2

end: sw $t1, 0($t0)
jr $ra
