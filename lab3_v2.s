#                         ICS 51, Lab #3
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
#      Remember to fill in your name, student ID in the designated fields.
#
#
#      contact sajjadt@uci.edu
###############################################################
#                           Data Section
.data

#
# Fill in your name, student ID in the designated sections.
#
student_name: .asciiz "Omar Saleh"
student_id: .asciiz "000000"

new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz "Program input: " 
po_str: .asciiz "Program output:  "
eo_str: .asciiz "Expected output: "
t1_str: .asciiz "Testing change case: \n"
t2_str: .asciiz "Testing factorial: \n"
t3_str: .asciiz "Testing GCD: \n"
t4_str: .asciiz "Testing Catalan numbers: \n" 

change_case_input: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"
change_case_output: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"
change_case_expected_output: .asciiz "CashRulesEveryTHINGAroundMe"

num_numeric_tests:          .word 8

numerical_inputs:           .word 0, 1, 2, 3, 4 , 5 , 6  , 7
factorial_expected_outputs: .word 1, 2, 6, 24 , 120, 720, 5040
catalan_expected_ouptuts:   .word 1, 1, 2, 5, 14, 42, 132, 429

gcd_inputs:                 .word 1, 12, 4, 79322, 1378, 75, 28300, 74000
gcd_expected_outputs:       .word     1, 4,     2,     2, 1,     25,  100


###############################################################
#                           Text Section
.text
# Utility function to print integer arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################


###############################################################
#                       PART 1 (Change Case)
#a0: input array
#a1: output array
###############################################################
change_case:
############################## Part 1: your code begins here ###
add  $s1, $zero, $zero
add  $s2, $zero, $zero
add  $s3, $zero, $zero
add  $s4, $zero, $zero
addi $s1, $zero, 65 
addi $s2, $zero, 90 
addi $s3, $zero, 97 
addi $s4, $zero, 122 
add  $t0, $zero, $zero
add  $t1, $zero, $zero
add $t0, $a0, $zero
add $t1, $a1, $zero

loop:
        lbu $s5, 0($t0)
        beq $s5, $zero, lastChar
        bge $s5, $s3, testupper
        bge $s5, $s1, testlower
        b No_Change
        b done


lastChar:
            sb $zero, 0($t1)
            b done


testupper:
            bgt $s5, $s4, No_Change
            addi $s5, $s5, -32
            sb $s5, 0($t1)
            b incr


testlower:
            bgt $s5, $s2, No_Change
            addiu $s5, $s5, 32
            sb $s5, 0($t1)
            b incr


incr:
        addiu $t1, $t1, 1
        No_Change:
        addiu $t0, $t0, 1
        b loop


done:
############################## Part 1: your code ends here ###
jr $ra
###############################################################

###############################################################
#                           PART 2 (Factorial)
#a0: input number
###############################################################
factorial:
############################### Part 2: your code begins here ##
subu $sp, $sp, 32 
sw $fp, 16($sp)
sw $ra, 20($sp)
addiu $fp, $sp, 28
sw $a0, 0($fp)
lw $v0, 0($fp)
blt $zero, $v0, loop1 
addiu $v0, $zero, 1
b restore

loop1:
        lw $v1, 0($fp) 
        addi $v0, $v1, -1 
        add $a0, $zero, $v0
        jal factorial 
        lw $v1, 0($fp) 
        multu $v0, $v1 
        mflo $v0
        b restore

restore:
        lw $fp, 16($sp) 
        lw $ra, 20($sp) 
        addiu $sp, $sp, 32 
############################### Part 2: your code ends here  ##
jr $ra
###############################################################

###############################################################
#                           PART 3 (GCD)
#a0: input number
#a1: input number
###############################################################
gcd:
############################### Part 3: your code begins here ##
add   $t5, $zero, $zero
subu $sp, $sp, 32 
sw $fp, 16($sp) 
sw $ra, 20($sp)
addiu $fp, $sp, 28 
sw $a1, -4($fp)
sw $a0, 0($fp)
lw $v1, -4($fp) 

bne $zero, $v1, jump 
lw $v0, 0($fp) 
b else

jump:
        add $t5, $zero, $a0
        lw $a0, -4($fp)
        divu $t5, $a0
        mfhi $a1
        jal gcd

else:
        lw $fp, 16($sp)
        lw $ra, 20($sp) 
        addiu $sp, $sp, 32
############################### Part 3: your code ends here  ##
jr $ra
###############################################################

###############################################################
#                           PART 4 (Catalan Numbers)
#a0: input number
###############################################################
catalan:
############################### Part 4: your code begins here ##
add   $t1, $zero, $zero
add   $t2, $zero, $zero

bne   $a0, $zero, branch
li    $v0,  1
jr    $ra
branch:	 
         sw    $fp, -4($sp)
		 subu  $fp, $sp, 4
		 sw    $ra, -4($fp)
		 sw    $a0, -8($fp)
		 subu  $sp, $fp, 8
		 subu $a0, $a0, 1
		 jal   catalan
    	 addiu  $sp, $fp, 4
		 lw    $a0, -8($fp)
		 lw    $ra, -4($fp)
		 lw    $fp, 0($fp)
		 sll   $t1, $a0, 2
		 subu  $t1, $t1, 2
		 mul   $t1, $t1, $v0
		 addiu $t2, $a0, 1
		 divu  $t1, $t2
		 mflo  $v0
############################### Part 4: your code ends here  ##
jr $ra
###############################################################


###############################################################
#                          Main Function
main:

.text

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
syscall
###############################################################
# Test Change case function

li $v0, 4
la $a0, t1_str
syscall
# call the function
la $a0, change_case_input
la $a1, change_case_output
li $a2, 2
jal change_case
# print results
la $a0, i_str
syscall
la $a0, change_case_input
syscall
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, change_case_expected_output
syscall
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, change_case_output
syscall
la $a0, new_line
syscall
syscall
###############################################################
# Test Factorial function
li $v0, 4
la $a0, t2_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
add $s1, $s1, -1
la $s2, numerical_inputs
add $s2, $s2, 4 # skip 0
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
add $s1, $s1, -1
la $s2, factorial_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, numerical_inputs
addi $s2, $s2, 4
test_factorial:
bge $s0, $s1, end_test_factorial
# call the function
lw $a0, 0($s2)
jal factorial
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_factorial


end_test_factorial:
la $a0, new_line
syscall
syscall
###############################################################
# Test GCD function
li $v0, 4
la $a0, t3_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, gcd_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
addi $s1, $s1, -1 # tests are in pairs
la $s2, gcd_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, gcd_inputs

test_gcd:
bge $s0, $s1, end_test_gcd
# call the function
lw $a0, 0($s2)
lw $a1, 4($s2)
jal gcd
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_gcd


end_test_gcd:
la $a0, new_line
syscall
syscall

###############################################################
# Test Catalan numbers function
li $v0, 4
la $a0, t4_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, numerical_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, catalan_expected_ouptuts
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, numerical_inputs

test_catalan:
bge $s0, $s1, end_test_catalan
# call the function
lw $a0, 0($s2)
jal catalan
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_catalan


end_test_catalan:
la $a0, new_line
syscall
syscall
_end:
# end program
li $v0, 10
syscall
