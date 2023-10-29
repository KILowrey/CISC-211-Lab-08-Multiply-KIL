/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global a_Multiplicand,b_Multiplier,rng_Error,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,init_Product,final_Product
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type rng_Error,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type init_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
rng_Error:       .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
init_Product:    .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmMult.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 8 Multiply
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /**
     * REGISTER TRACKER FOR PROGRAMMER
     * R0 - input multiplicand
     * R1 - input multiplier
     * R2 - 
     * R3 - 
     * R4 - 
     * R5 - 
     * R6 - 
     * R7 - 
     * R8 - 
     * R9 - 
     * R10 - 
     * R11 - 
     * R12 - 
     */
    
    /* init all variables to 0 */
    
    /* copy r0 into memory location a_Multiplicand */
    
    /* copy r1 into b_Multiplier */
    
    LDR R2,=a_Multiplicand
    STR R0,[R2]
    LDR R3,=b_Multiplier
    STR R1,[R3]
    
    LDR R10,=0
    LDR R11,=1
    
    LDR R12,=rng_Error
    STR R10,[R12]
    
    LDR R2,=a_Sign
    LDR R3,=b_Sign
    STR R10,[R2]
    STR R10,[R3]
    
    LDR R4,=prod_Is_Neg
    STR R10,[R4]
    
    LDR R5,=a_Abs
    LDR R6,=b_Abs
    STR R10,[R5]
    STR R10,[R6]
    
    LDR R7,=init_Product
    LDR R8,=final_Product
    STR R10,[R7]
    STR R10,[R8]
    
    LDR R2,=2
    LDR R3,=0
    LDR R4,=0
    LDR R5,=0x00007FFF
    LDR R6,=0xFFFFFFFF
    
    ORR R7,R0,R5
    CMP R7,R5
    ADDNE R3,R3,1
    CMP R7,R6
    ADDNE R3,R3,1
    /*CMP R7,R0
    MOVEQ R3,R0*/
    
    ORR R8,R1,R5
    CMP R8,R5
    ADDNE R4,R4,1
    CMP R8,R6
    ADDNE R4,R4,1
    /*CMP R8,R0
    MOVEQ R4,R0*/
    
    CMP R3,R2
    BEQ error
    CMP R4,R2
    BEQ error
    
    /* store the sign bits into their respective *_Sign mem location.
     * make sure it's 0 for positive and 1 for negative */
    LDR R3,=a_Sign
    LDR R4,=b_Sign
    
    CMP R7,R6
    STREQ R11,[R3]
    
    CMP R8,R6
    STREQ R11,[R4]
    
    
    /* based on the sign bits, decide if fianl output will be + or -
     * if negative, set prod_Is_Neg to 1, otherwise make it 0
     */
    LDR R2,[R3]
    LDR R3,[R4]
    
    LDR R4,=prod_Is_Neg
    
    CMP R2,R3
    STRNE R11,[R4]
    
    CMP R0,R10
    STREQ R10,[R4]
    CMP R1,R10
    STREQ R10,[R4]
    
    B check_a
    
    /* find (if you need to) and store absoule values */
    
find_a:
    SUB R5,R7,R11
    MVN R7,R5
    /*SUB R7,R7,1*/
    
    B check_b
    
find_b:
    SUB R6,R8,R11
    MVN R8,R6
    /*SUB R8,R8,1*/
    
    B multiply
    
check_a:
    MOV R7,R0
    CMP R2,R11
    BEQ find_a
    
check_b:
    MOV R8,R1
    CMP R3,R11
    BEQ find_b
    
ready_to_multiply:
    LDR R5,=a_Abs
    LDR R6,=b_Abs
    
    STR R7,[R5]
    STR R8,[R6]
    
    LDR R12,=0
    
multiply:
    /* use shift and add */
    
    CMP R8,R10
    BEQ return_product
    
    AND R6,R8,R11
    CMP R6,R11
    ADDEQ R12,R12,R7
    
    LSR R8,1
    LSL R7,1
    B multiply
    
return_product:
    /* store inital result in init_Product. */
    LDR R2,=init_Product
    STR R12,[R2]
    
    /* if prod_Is_Neg = 1, negative it */
    LDR R3,=prod_Is_Neg
    LDR R4,[R3]
    CMP R4,R11
    BNE final
    
    //MVN R5,R12
    //ADD R12,R4,R11
    NEG R12,R12
    
final:
    /* store final product */
    LDR R3,=final_Product
    STR R12,[R3]
    
    /* copy final restu to r0 */
    MOV R0,R12
    
    B done
    
error:
    /* set memory location rng_Error to 1 */
    STR R11,[R12]
    /* set r0 to 0 */
    LDR R0,=0
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




