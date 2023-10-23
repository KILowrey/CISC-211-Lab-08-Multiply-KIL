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
    
    /* REGISTER TRACKER FOR PROGRAMMER
     * R0 - recive multiplicand & output end value
     * R1 - recive multilier
     * R2 - 
     * R3 - 
     * R4 - 
     * R5 - 
     * R6 - absolute value A
     * R7 - absolute value B
     * R8 - WIP product
     * R9 - prod_Is_Neg & 
     * R10 - stores 0
     * R11 - stores 1
     * R12 - location for rng_Error & 
     */
    
    /* store 0 in R10 and 1 in R11 */
    LDR R10,=0
    LDR R11,=1
    
    /* comment */
    LDR R2,=a_Multiplicand
    LDR R3,=b_Multiplicand
    
    /* commonet */
    STR R0,[R2]
    STR R1,[R3]
    
    /* set all our other values to 0 */
    LDR R2,=a_Sign
    LDR R3,=b_Sign
    LDR R4,=a_Abs
    LDR R5,=b_Abs
    
    STR R10,[R2]
    STR R10,[R3]
    STR R10,[R4]
    STR R10,[R5]
    
    LDR R9,=prod_Is_Neg
    LDR R12,=rng_Error
    
    STR R10,[R9]
    STR R10,[R12]
    
    /* check if R0 and/or R1 is an invalid signed 16 bit number */
    /* TODO
     * if so set rng_Error to to 1 and R0 to 0
     * and exit code 
     */
    
    /* set a_Sign to sign bit for a */
    
    /* set b_Sign to sign bit for b */
    
    /* if one but not both of the sign bit are 1 
     * set prod_Is_Neg to 1 */
    
    /* if a_Sign is 1, find absolute value of A */
    
    /* if b_sign is 1, find absolute value of B */
    
    /* use shift-and-add to multiply them together.
     * (use flow chart for class)
     */
    
    /* store initial result (which will always be positive)
     * in init_Product
     */
    
    /* if prod_Is_Neg, 2s-complement it */
    
    /* store final result to final_Product */
    
    /* copy result to R0 */
    
    
    
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
           




