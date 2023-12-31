.. SPDX-License-Identifier: GPL-2.0+

Multiple images for SPL
=======================

(Bogus) example FIT image description file demonstrating the usage
of multiple images loaded by the SPL.
Several binaries will be loaded at their respective load addresses.

For booting U-Boot, "firmware" is searched first. If not found, "loadables"
is used to identify images to be loaded into memory. If falcon boot is
enabled, "kernel" is searched first. If not found, it falls back to the
same flow as booting U-Boot. Changing image type will result skipping
specific image.

Finally the one image specifying an entry point will be entered by the SPL.

::

    /dts-v1/;

    / {
        description = "multiple firmware blobs and U-Boot, loaded by SPL";
        #address-cells = <0x1>;

        images {

            uboot {
                description = "U-Boot (64-bit)";
                type = "standalone";
                arch = "arm64";
                compression = "none";
                load = <0x4a000000>;
            };

            atf {
                description = "ARM Trusted Firmware";
                type = "firmware";
                arch = "arm64";
                compression = "none";
                load = <0x18000>;
                entry = <0x18000>;
            };

            mgmt-firmware {
                description = "arisc management processor firmware";
                type = "firmware";
                arch = "or1k";
                compression = "none";
                load = <0x40000>;
            };

            fdt-1 {
                description = "Pine64+ DT";
                type = "flat_dt";
                compression = "none";
                load = <0x4fa00000>;
                arch = "arm64";
            };

            fdt-2 {
                description = "Pine64 DT";
                type = "flat_dt";
                compression = "none";
                load = <0x4fa00000>;
                arch = "arm64";
            };

            kernel {
                description = "4.7-rc5 kernel";
                type = "kernel";
                compression = "none";
                load = <0x40080000>;
                arch = "arm64";
            };

            initrd {
                description = "Debian installer initrd";
                type = "ramdisk";
                compression = "none";
                load = <0x4fe00000>;
                arch = "arm64";
            };
        };

        configurations {
            default = "config-1";

            config-1 {
                description = "sun50i-a64-pine64-plus";
                loadables = "uboot", "atf", "kernel", "initrd";
                fdt = "fdt-1";
            };

            config-2 {
                description = "sun50i-a64-pine64";
                loadables = "uboot", "atf", "mgmt-firmware";
                fdt = "fdt-2";
            };
        };
    };
