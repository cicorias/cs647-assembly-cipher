.cpu cortex-a53
.data
output1: .asciz "Original text : %s\n"
output2: .asciz "Text after Caesar Cypher encryption : %s\n"
output3: .asciz "Text After decrypting the above encrypted value : %s\n"
s: .asciz "Hello, My name is Dina."
encodedText: .space 50
decodedText: .space 50
.text
.global main
main:
push {lr} @ save lr on stack
@ ENCRYPTING THE STRING AND STORING THE ENCRYPTED VALUE IN 'encoded text'
@ to encode we can pass the string and the shift value to the
@ encode function
ldr r0, =s
ldr r1, =encodedText
mov r2, #5
bl encode @ encode(s, encodedText, 5);
@ DECRYPTING THE 'encoded text' AND STORING THE ENCRYPTED VALUE IN
@ 'decodedText'
@ to decode a encoded string we can pass the string to the
@ encoded function
@ and apply the given shift in the opposite direction
@ i.e. if we passed 5 to encode, we will pass (26-5)= 21
ldr r0, =encodedText
ldr r1, =decodedText
mov r2, #21
bl encode @ encode(encodedText, decodedText, (26 - 5));
@ output
ldr r0, =output1
ldr r1, =s
bl printf @ printf("Original text : %s\n", s);
ldr r0, =output2
ldr r1, =encodedText
bl printf @ printf("Text after Caesar Cypher encryption : %s\n", encodedText);
ldr r0, =output3
ldr r1, =decodedText
bl printf @ printf("Text After decrypting the above encrypted value : %s\n", decodedText);
mov r0, #0 @ return 0;
pop {lr} @ restore lr from stack
mov pc, lr @ return to caller
@ this function will add the cipher value to convert the text we pass to it
@ text is a char array, s is the cipher value
@ this function will wrap around the alphabets. It means
@ if we add 4 to 'z', the result will be 'd'
@ void encode(char text[], char result[], int s)
encode:
push {r4-r8, lr} @ save registers and link register on stack
mov r4, r0 @ save string pointer in r4
push {r1,r2} @ save r0 and r1 before making call
bl strlen @ calculate strlen(text);
mov r8, r0 @ save len in r8
pop {r1, r2}
@ stepping through each character of the input text
@ and encoding only the alphabets.
@ It will not encode the spaces, symbols, etc in the text.
mov r5, #0 @ i = 0
for1: @ for (i = 0; i < l; i++) {
cmp r5, r8
bge endfor1
@ for upper case alphabets
 ldrb r6, [r4, r5] @ load text[i] in r1
cmp r6, #'A' @ if (text[i] >= 'A' && text[i] <= 'Z') {
blt else1
cmp r6, #'Z'
bgt else1
@ result[i] = (char)((int)(text[i] + s - 65) % 26 + 65);
add r6, r6, r2
sub r6, r6, #65
mov r7, #26
udiv r0, r6, r7 @ divide by 26
mul r0, r0, r7 @ calculate remainder
sub r0, r6, r0
add r0, r0, #65
strb r0, [r1, r5] @ save in result[i]
b fornext @ }
@ for lower case alphabets
else1:
cmp r6, #'a' @ else if (text[i] >= 'a' && text[i] <= 'z') {
blt else2
cmp r6, #'z'
bgt else2
@ result[i] = (char)((int)(text[i] + s - 97) % 26 + 97);
add r6, r6, r2
sub r6, r6, #97
mov r7, #26
udiv r0, r6, r7 @ divide by 26
mul r0, r0, r7 @ calculate remainder
sub r0, r6, r0
add r0, r0, #97
strb r0, [r1, r5] @ save in result[i]
b fornext @ }
@ copying the non-alphabets without changing
else2: @else {
strb r6, [r1, r5] @ result[i] = text[i];
@}
fornext:
add r5, r5, #1 @ increment i
b for1 @ repeat loop
endfor1: @ }
@ adding the NULL character at the end of the result string
@ to mark its end
mov r0, #0
strb r0, [r1, r5] @ result[i] = '\0';
pop {r4-r8, lr} @ restore registers and lr
mov pc, lr @ return to caller
