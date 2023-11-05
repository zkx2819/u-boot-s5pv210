#include<s5pv210_cpcode.h>

.globl cpbl2_to_ddr
cpbl2_to_ddr:
	ldr	r0, =0xff000fff
	bic	r1, pc, r0		/* r0 <- current base addr of code */
	ldr	r2, =CONFIG_TEXT_BASE		/* r1 <- original base addr in ram */
	bic	r2, r2, r0		/* r0 <- current base addr of code */
	cmp     r1, r2                  /* compare r0, r1                  */
	beq     done_copy		/* r0 == r1 then skip flash copy   */

    push {sp, r1}
    push {sp, lr}
    ldr r1, =0x4f4f4f43
    bl uart_print_val @'C'
    pop {sp, lr}
    pop {sp, r1}

	/* If BL1 was copied from SD/MMC CH2 */
	ldr	r0, =0xD0037488
	ldr	r1, [r0]
	ldr	r2, =0xEB200000
	cmp	r1, r2
	beq     mmcsd_boot


	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp	r1, #BOOT_NAND		/* 0x0 => boot device is nand */
	beq	nand_boot
	cmp	r1, #BOOT_ONENAND	/* 0x1 => boot device is onenand */
	beq	onenand_boot
	cmp     r1, #BOOT_MMCSD
	beq     mmcsd_boot
	cmp     r1, #BOOT_NOR
	beq     nor_boot
	cmp     r1, #BOOT_SEC_DEV
	beq     mmcsd_boot

nand_boot:
	mov	r0, #0x1000
	bl	copy_from_nand
	b	after_copy

onenand_boot:
	bl	onenand_bl2_copy
	b	after_copy

mmcsd_boot:
#if DELETE
	ldr     sp, CONFIG_TEXT_BASE      
	sub     sp, sp, #12
	mov     fp, #0
#endif
    push {sp, r1}
    push {sp, lr}
    ldr r1, =0x4f4f4f41
    bl uart_print_val @'A'
    pop {sp, lr}
    pop {sp, r1}
	bl      movi_bl2_copy
	b       after_copy

nor_boot:
	bl      read_hword
	b       after_copy

after_copy:
    push {sp, r1}
    push {sp, lr}
    ldr r1, =0x4f4f4f42
    bl uart_print_val @'B'
    pop {sp, lr}
    pop {sp, r1}
    ldr r1, _bl2_main_ofs
    ldr r2, =CONFIG_TEXT_BASE
    sub r1, r2, r1
    mov pc, r1


done_copy:
    push {sp, r1}
    push {sp, lr}
    ldr r1, =0x4f4f4f44
    bl uart_print_val @'D'
    pop {sp, lr}
    pop {sp, r1}

    b _main_start

 .globl _bl2_main_ofs
 _bl2_main_ofs:
     .word _start - done_copy



