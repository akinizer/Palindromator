.data 
inp: .space 50
inpVar: .space 50
checkPal: .asciiz " palindrome\n\n"
checkNotPal: .asciiz " not palindrome\n\n"
repMess: .asciiz "Another shot? (y/n): "
repInp: .space 4
endMess: .asciiz "End of program"
sPrompt: .asciiz "\nEnter string: "

.text
main:
    la $a0, sPrompt #ask 
    li $v0, 4
    syscall
    la $a0, inp #store inp
    li $a1, 50
    li $v0, 8
    syscall #get inp

loopper: #repeater
    la $t1, inpVar
    loop:
        lb $t7, ($a0)
        beq $t7, 10, checkPali  
        bgt $t7, 47, tmp1
        j no2inp
        tmp1: blt $t7, 58, add2inpVar
        bgt $t7, 64, tmp2
        j no2inp
        tmp2: blt $t7, 91, add2inpVar 
        bgt $t7, 96, tmp3
        j no2inp
        tmp3: blt $t7, 123, add2inpVar
        j no2inp
    add2inpVar: #inp var stored
        bgt $t7, 96, capper
        j notCap
        capper: addi $t7, $t7, -32 #upper/lowercase check
        notCap:
        sb $t7, ($t1)
        addi $a0, $a0, 1 #mem incr
        addi $t1, $t1, 1
        j loop
    no2inp: #new string uncheck
        addi $a0, $a0, 1 #icnr inp
        j loop
    endd:
        #end

checkPali:
    la $t4, inpVar
    # backcheck
    sb $zero, ($a0)
    addi $t1, $t1, -1   #decr $t1, incr $t4
    loop3:         

        lb $t3, ($t4)
        lb $t2, ($t1)  
        beq $t3, $t2, next  
        j checkNotPalVar  #uneq
        next: jal tmpLocation  #check last
              addi $t4, $t4, 1 #incr t4
              addi $t1, $t1, -1 #decr t1 
              j loop3   #next loop
        j checkNotPalVar

    tmpLocation:
        #curr addr vars
        beq $t4, $t1, checkPalX
        addi $t1, $t1, -1
        beq $t4, $t1, checkPalX   #check more char available
        addi $t1, $t1, 1
        jr $ra         

    checkPalX:
        la $a0, inp
        li $v0, 4   #pal
        syscall
        la $a0, checkPal
        syscall
        j goAgainVar

    checkNotPalVar:
        la $a0, inp #notpal
        li $v0, 4
        syscall
        la $a0, checkNotPal
        syscall
        j goAgainVar 

    goAgainVar:
        ##la $a0, repMess
        syscall
        li $a1, 4
        li $v0, 8
        la $a0, repInp    #rep ask. 
        syscall
        lb $t0, ($a0)
        beq $t0, 121, goAgainVar
        j exit

exit:
    la $a0, endMess
    li $v0, 4   #print exit . 
    syscall
    li $v0, 10
    syscall

##goAgain:
##    la $a0, inp
##    li $t9, 100
##    loopReset:
##        beqz $t9, main  #jump start 
##        addi $t9, $t9, -1
##        sb $zero, ($a0)
##        addi $a0, $a0, 1
##        j loopReset
