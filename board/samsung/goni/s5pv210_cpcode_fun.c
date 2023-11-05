#include<s5pv210_cpcode.h>

typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned long ulong;
register volatile u32 uart_param asm ("r1");
extern void uart_print_val(void);

typedef u32(*copy_sd_mmc_to_mem)
(u32 channel, u32 start_block, u16 block_size, u32 *trg, u32 init);

void movi_bl2_copy(void)
{
	ulong ch;
	ch = *(volatile u32 *)(0xD0037488);
	copy_sd_mmc_to_mem copy_bl2 =
	    (copy_sd_mmc_to_mem) (*(u32 *) (0xD0037F98));

    uart_param = 0x4f4f4f45; // E
    uart_print_val();

	#if defined(CONFIG_SECURE_BOOT)
	ulong rv;
	#endif

	u32 ret;
	if (ch == 0xEB000000) {
        uart_param = 0x4f4f4f31; // 1
        uart_print_val();
		ret = copy_bl2(0, MOVI_BL2_POS, MOVI_BL2_BLKCNT,
			CONFIG_TEXT_BASE, 0);
	}
	else if (ch == 0xEB200000) {
        uart_param = 0x4f4f4f32; // 2
        uart_print_val();
		ret = copy_bl2(2, MOVI_BL2_POS, MOVI_BL2_BLKCNT,
			CONFIG_TEXT_BASE, 0);
	}
	else
		return;
    uart_param = 0x4f4f4f47; // G
    uart_print_val();

	if (ret == 0) {
        uart_param = 0x4f4f4f48; // H
        uart_print_val();
		while (1)
			;
   }
	else {
        uart_param = 0x4f4f4f49; // I
        uart_print_val();
		return;
   }
}

void copy_from_nand(void)
{
}
void onenand_bl2_copy(void)
{
}
void read_hword(void)
{
}


