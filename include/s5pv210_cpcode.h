#ifndef __s5pv210_cpcode_h
#define __s5pv210_cpdode_h

#define INF_REG_BASE			0xE010F000
#define INF_REG3_OFFSET			0x0c

#define BOOT_ONENAND		0x1
#define BOOT_NAND		0x2
#define BOOT_MMCSD		0x3
#define BOOT_NOR		0x4
#define BOOT_SEC_DEV		0x5

#define MOVI_BL2_POS 49
#define MOVI_BL2_BLKCNT (512 * 1024 / 512)  // 512KB
#define CFG_PHY_UBOOT_BASE 0x30000000


#endif
