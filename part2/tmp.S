.section .data
# There are two global variables:
#  1. array: Store the input numbers.
#  2. size: the number of the list
# You can modify the following two lines to test your program,
# but DO NOT change the line number
array: .dword 15, 20, 6, 35, 70, 7, 14, 36, 1, 21, 13, 3, 24, 5, 22, 2, 4, 10, 8, 12
size: .dword 20

# Variables for print function
# DO NOT modify these
dummy_msg: .ascii "   "
newline_msg: .ascii "\n"
ascii_msg: .ascii "Test"
magic_mem: .space 64

.section .text
.global main
main:

  # save return pointer
  addi sp, sp, -8
  sd ra, 0(sp)

  la a0, array      # assign array address to a0
  ld a2, size       # assign array size to a2

  li a3, 0          # low
  addi a2, a2, -1   # high

  jal partition     # jump to function
  
  jal print         # show results

  li a0, 0

  ld ra, 0(sp)
  addi sp, sp, 8

  ret               # return (jump to the address stored in register ra)

.global partition
partition:
  # a1: saves return value i
  #########################
  addi sp, sp, -56
  sd s7, 48(sp)
  sd s6, 40(sp)
  sd s5, 32(sp)
  sd s4, 24(sp)
  sd s3, 16(sp)
  sd s2, 8(sp)
  sd ra, 0(sp)
  
  # t0: pivot address, a4: pivot value 
  slli t0, a2, 3
  add t0, a0, t0
  ld a4, 0(t0)
  
  # t2: i = low
  add t2, a3, zero
  # t3: j = low	
  add t3, a3, zero
  
  partition_for:
    
    bge t3, a2, partition_for_exit
    slli s2, t3, 3	
    add s2, a0, s2	# s2: address of arr[j]
    ld s3, 0(s2)	# s3: value of arr[j]
    
    bge s3, a4, partition_skip	# if arr[j] >= pivot
    slli s4, t2, 3
    add s4, a0, s4	# s4: address of arr[i]
    ld s5, 0(s4)	# s5: vlaue of arr[i] 
    
    #swap
    sd s3, 0(s4)
    sd s5, 0(s2)
    addi t2, t2, 1	# i += 1
    
    partition_skip:
    	addi t3, t3, 1	# j += 1
    beq zero, zero, partition_for
    
    partition_for_exit:
    	slli s6, a2, 3
    	add s6, a0, s6		# s6: address of high
    	ld s7, 0(s6)		# s7: value of high
    	
    	slli s4, t2, 3		# t2 is renewed, so s4(address of arr[i])
      	add s4, a0, s4		# should also be renewed
    	ld t4, 0(s4)		# t4: value of arr[i]
    	
    	#swap
    	sd s7, 0(s4)
    	sd t4, 0(s6)	
    	add a1, t2, zero	# return a1 = t2(i)
    	
  ld s7, 48(sp)  	
  ld s6, 40(sp)  	
  ld s5, 32(sp)
  ld s4, 24(sp)
  ld s3, 16(sp)
  ld s2, 8(sp)
  ld ra, 0(sp)
  addi sp, sp, 56
  
  ret
  #########################

####################################
# Helper function to print results #
#     DO NOT modify this!!!!!!     #
####################################
.global print
print:

  addi sp, sp, -72
  sd s7, 64(sp)
  sd s6, 56(sp)
  sd s5, 48(sp)
  sd s4, 40(sp)
  sd s3, 32(sp)
  sd s2, 24(sp)
  sd s1, 16(sp)
  sd s0, 8(sp)
  sd ra, 0(sp)

  la s0, array
  ld s1, size

  li s2, 0

print_loop:
  slli s3, s2, 3
  add s3, s0, s3
  ld s4, 0(s3)

  li s3, 10
  div s5, s4, s3
  rem s4, s4, s3

  beq s5, zero, less_than_10

  addi s5, s5, 48
  la s7, ascii_msg 
  sw s5, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait1:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait1

  sw zero, 0(s6)

less_than_10:

  addi s4, s4, 48
  la s7, ascii_msg 
  sw s4, 0(s7)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, ascii_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait2:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait2

  sw zero, 0(s6)

  la s7, magic_mem
  li s6, 64
  sw s6, 0(s7)
  li s6, 1
  sw s6, 8(s7)
  la s6, newline_msg
  sw s6, 16(s7)
  li s6, 1
  sw s6, 24(s7)
  la s6, tohost
  sw s7, 0(s6)

wait3:
  la s6, fromhost
  ld s7, 0(s6)
  beq s7, zero, wait3

  sw zero, 0(s6)

  addi s2, s2, 1
  bne s2, s1, print_loop

  ld ra, 0(sp)
  ld s0, 8(sp)
  ld s1, 16(sp)
  ld s2, 24(sp)
  ld s3, 32(sp)
  ld s4, 40(sp)
  ld s5, 48(sp)
  ld s6, 56(sp)
  ld s7, 64(sp)
  addi sp, sp, 72

  ret
