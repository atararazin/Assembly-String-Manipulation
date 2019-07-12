# Assembly-String-Manipulation

## What This Program Does
This project is my assembly project in the course Computer Structures. The program does some string manipulations. More details
to follow.
We create a structure that we called a "pstring". A pstring is a struct composed of an int and a string. The int is the size, followed by a string of that size. For example: "5hello", the 5 representing the size of the string "hello".

## How To Run It
First, this program will only run in Linux! 
Now that your on your Linux:
1. Optional: if you would like to compile it, there is a makefile for that. Simply type into the terminal "make" and it will 
produce the object files and an executable file called a.out. To run it go to step 2.

2. Type into the terminal `./a.out`

## How To Use This Program
First, we get the two pstrings. Then we have 5 options of string manipulations:
### Option 50: Pstrlen
Prints the two pstrings and their legnths.

### Option 51: ReplaceChar
Replaces a specific char in each pstring with a given char from user.
After inputting both pstrings, type another line of the following format :"%c %c\n" (char space char newline).
The first char is the one to be replaced, the second the one to replace with.

### Option 52: Pstrijcpy
After inputting both strings as usual, type another two lines, each with one number. The first number is the starting index and the second
is the ending index. We take the second pstring and copy from the starting index to the ending index and paste it into the first pstring.
So, if we have the two strings, `hello` and `world`, and we want to start from index 1 and end in index 4, the program will output the following: `horld` and in the following line `world`. For invalid input, it will output an error message.

### Option 53: SwapCase
As the name implies, this function swaps all capitals for lowercase and all lowercase for capitals. For example AtArA would become aTaRa.


### Option 54: Pstrijcmp
Just like in option 52, we get two integers in the same format, one line after another. Once again the first number is the starting index and the second number is the ending index. The program then compares the two pstrings at the indexes given. It returns 1 if the 
first pstring is lexographically (according to ASCII) bigger than the second. If the second is bigger, it returns -1. If they are equal,
it will return 0. 

For full examples for the whole program, head over to Ex3.pdf pages 7-8
