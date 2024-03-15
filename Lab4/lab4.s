.globl binary_search
binary_search:
  // ADD YOUR SOLUTION HERE 

  // lets start with the "variable declarations"
  mov r3,#0 // r3 = 0 
  sub r4,r2,#1 // r4 = r2 - 1 
  mov r5,r4,lsr#1 // r5 = r4 >> 2 (r5 = r4 / 2) 
  mov r6,#-1 // r6 = -1
  mov r7,#1 // r7 = 1

  // commence the while loop
loop:
  cmp r6,#-1 // check if keyIndex == -1
  bne done // go to done if keyIndex != -1

  cmp r3,r4 // checks if startIndex > endIndex 
  bgt done // go to done if startIndex > endIndex, break while loop

  ldr r8,[r0,r5,lsl#2] // temp1 = numbers[middleIndex]

  cmp r8,r1 // check if numbers[middleIndex] == key
  moveq r6,r5  // keyIndex = middleIndex;

  cmp r8,r1 // check if numbers[middleIndex] > key
  subgt r4,r5,#1 // endIndex = middleIndex-1; 

  cmp r8,r1 // check if numbers[middleIndex] < key
  addlt r3,r5,#1 // startIndex = middleIndex+1;

  rsb r8,r7,#0 // numbers[middleIndex] = -NumIters => 0 - NumIters

  sub r9,r4,r3 // temp2 = (endIndex - startIndex)
  add r5,r3,r9,lsr#1 // middleIndex = startIndex + temp2/2;

  add r7,r7,#1 // NumIters ++;

  b loop // go back to the start of loop
  
done:
  mov r0,r6 // return value of keyIndex in R0
  mov pc,lr // returns us to main

/*

DEFINED BY main.s:
*numbers = R0
key = R1
length = R2

DECLARED IN lab4.s:
startIndex = R3
endIndex = R4
middleIndex = R5
keyIndex = R6
NumIters = R7

MIDDLE VALUES USED IN lab4.s
temp1 = numbers[middleIndex] = R8
temp2 = (endIndex - startIndex) = R9

int binary_search(int *numbers, int key, int length)
{
 int startIndex = 0;
 int endIndex = length - 1;
 int middleIndex = endIndex/2;
 int keyIndex = -1;
 int NumIters = 1;

 while (keyIndex == -1) 
 {
    if (startIndex > endIndex)
      break;

    else if (numbers[middleIndex] == key)
      keyIndex = middleIndex;

    else if (numbers[middleIndex] > key) 
    {
      endIndex = middleIndex-1;
    } 

    else 
    {
      startIndex = middleIndex+1;
    }

    numbers[ middleIndex ] = -NumIters;
    middleIndex = startIndex + (endIndex - startIndex)/2;
    NumIters ++;
  }

 return keyIndex;
 }

 */
