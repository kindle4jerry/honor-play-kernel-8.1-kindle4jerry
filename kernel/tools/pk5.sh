#!/bin/bash
./mkbootimg --kernel Image.gz --base 0x0 --cmdline "loglevel=4 initcall_debug=n page_tracker=on unmovable_isolate1=2:192M,3:224M,4:256M printktimer=0xfff0a000,0x534,0x538 androidboot.selinux=enforcing buildvariant=user" --tags_offset 0x07A00000 --kernel_offset 0x00080000 --ramdisk_offset 0x07C00000 --os_version 8.1.0 --os_patch_level 2018-05-05  --output kernel.img

# Image.gz是你编译出来的产物，丢到这里，然后后面的kernel.img是这里的打包产物。中间几个参数按照官方来没啥问题，注意中间时间os_patch_level需要参考你原来内核的系统的安卓安全补丁版本 例如，这个2018年5月的内核刷到2018年11月的安全补丁的机子上就无法开机 这两个pk文件本质区别就是时间可以自行调整
