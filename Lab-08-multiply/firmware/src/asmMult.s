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
    
    /* Load 0 in R10 and 1 in R11 */
    LDR R10,=0
    LDR R11,=1
    
    /* Load the location of a_Multiplicand in R2
     * and b_Multiplier in R3 */
    LDR R2,=a_Multiplicand
    LDR R3,=b_Multiplier
    
    /* Store the input Multiplicand into a_Multiplicand
     * and the input Multiplier into b_Multiplier */
    STR R0,[R2]
    STR R1,[R3]
    
    /* load the location for the sign and absolue values 
     * for a and b in registers R2-R5 */
    LDR R2,=a_Sign
    LDR R3,=b_Sign
    LDR R4,=a_Abs
    LDR R5,=b_Abs
    
    /* store 0 in all the above values */
    STR R10,[R2]
    STR R10,[R3]
    STR R10,[R4]
    STR R10,[R5]
    
    /* load the location for prod_Is_Neg in R9 */
    LDR R9,=prod_Is_Neg
    /* load location for rng_Error in R12 */
    LDR R12,=rng_Error
    
    /* store 0 in both of the above */
    STR R10,[R9]
    STR R10,[R12]
    
    /* check if R0 and/or R1 is an invalid signed 16 bit number
     * if so set rng_Error to to 1 and R0 to 0
     * and exit code 
     */
    /* load all 1s into R6 for compairson purposes */
    LDR R6,=0xFFFFFFFF
    /* ORN the input multiplicand w/ all 0s */
    ORN R7,R0,R10
    /* ORN the input muliplier w/ all 0s  */
    ORN R8,R1,R10
    /* check for an error and branch if we don't */
    CMP R7,R6
    BEQ no_error
    /* check for an error and branch if we don't */
    CMP R8,R6
    BEQ no_error
    
    /* if we don't branch to no error
     * then we set rng_Error to 1
     * R0 to 0
     * and exit the code */
    STR R11,[R12]
    MOV R0,R10
    B done
    
no_error:
    /* load up our non-sign-bit values w/ 1 */
    LDR R12,=0x00007FFF
    
    /* set a_Sign to sign bit for a */
    AND R7,R0,R12
    CMP R6,R7
    STREQ R11,[R2]
    
    /* set b_Sign to sign bit for b */
    AND R8,R1,R12
    CMP R6,R8
    STREQ R11,[R3]
    
    /* if one but not both of the sign bit are 1 
     * set prod_Is_Neg to 1 */
    LDR R7,[R2]
    LDR R8,[R3]
    CMP R7,R8
    STRNE R11,[R9]
    /* skip down to check if we need to find a_Abs */
    B check_for_abs_a
    
find_abs_a:
    ORN R4,R10,R7
    SUB R7,R4,1
    /* once we find a_Abs go down to check for b */
    B check_for_abs_b
    
find_abs_b:
    ORN R4,R10,R8
    SUB R8,R4,1
    /* once we find b_Abs go down to get ready to multiply */
    B get_ready_to_multiply
    
check_for_abs_a:
    CMP R7,R11
    /* if we need to find a_Abs go up there */
    BEQ find_abs_a
    
check_for_abs_b:
    CMP R8,R11
    /* if we need to find b_Abs go up there */
    BEQ find_abs_b
    
get_ready_to_multiply:
    /* copy the ABS of R7 and R8 into their locations */
    STR R7,[R4]
    STR R8,[R5]
    MOV R12,R10
    
multiply:
    /* use shift-and-add to multiply them together.
     * multiplicand is R7
     * multiplier is R8
     * product is R12
     */
    /* check if mutliplyer = 0 and if so return product */
    CMP R8,R10
    BEQ return_product
    
    /* check if multiplier LSB = 1 */
    AND R6,R8,R11
    CMP R6,R11
    /* and if yes then product = product + mutiplicand */
    ADDEQ R12,R12,R7
    
    /* multipler shift right by 1 */
    LSR R8,1
    /* multiplicand shift left by 1 */
    LSL R7,1
    /* back to the top */
    B multiply

return_product:
    /* store initial result (which will always be positive)
     * in init_Product
     */
    LDR R2,=init_Product
    STR R12,[R2]
    
    /* if prod_Is_Neg, 2s-complement it */
    LDR R6,[R9]
    CMP R6,R11
    BNE final
    
    MVN R4,R12
    ADD R12,R4,R11
    
final:
    /* store final result to final_Product */
    LDR R3,=final_Product
    STR R12,[R3]
    
    /* copy result to R0 */
    MOV R0,R12
    
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
           




