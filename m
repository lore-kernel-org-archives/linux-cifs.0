From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] smbfs: move to drivers/staging
Date: Mon, 4 Oct 2010 22:55:57 +0200
Message-ID: <201010042255.57843.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: gregkh-l3A5Bk7waGM@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

smbfs has been scheduled for removal in 2.6.27, so
maybe we can now move it to drivers/staging on the
way out.

smbfs still uses the big kernel lock and nobody
is going to fix that, so we should be getting
rid of it soon.

This removes the 32 bit compat mount and ioctl
handling code, which is implemented in common fs
code, and moves all smbfs related files into
drivers/staging/smbfs.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 Documentation/filesystems/00-INDEX                 |    2 -
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 {fs => drivers/staging}/smbfs/Kconfig              |    0
 {fs => drivers/staging}/smbfs/Makefile             |    0
 drivers/staging/smbfs/TODO                         |    8 +++++
 {fs => drivers/staging}/smbfs/cache.c              |    2 +-
 {fs => drivers/staging}/smbfs/dir.c                |    6 ++--
 {fs => drivers/staging}/smbfs/file.c               |    5 +--
 {fs => drivers/staging}/smbfs/getopt.c             |    0
 {fs => drivers/staging}/smbfs/getopt.h             |    0
 {fs => drivers/staging}/smbfs/inode.c              |    8 ++--
 {fs => drivers/staging}/smbfs/ioctl.c              |    5 +--
 {fs => drivers/staging}/smbfs/proc.c               |    7 ++--
 {fs => drivers/staging}/smbfs/proto.h              |    0
 {fs => drivers/staging}/smbfs/request.c            |    7 ++--
 {fs => drivers/staging}/smbfs/request.h            |    0
 {include/linux => drivers/staging/smbfs}/smb.h     |    0
 {fs => drivers/staging}/smbfs/smb_debug.h          |    0
 {include/linux => drivers/staging/smbfs}/smb_fs.h  |    8 ++--
 .../linux => drivers/staging/smbfs}/smb_fs_i.h     |    0
 .../linux => drivers/staging/smbfs}/smb_fs_sb.h    |    2 +-
 .../linux => drivers/staging/smbfs}/smb_mount.h    |    0
 .../staging/smbfs}/smbfs.txt                       |    0
 {fs => drivers/staging}/smbfs/smbiod.c             |    7 ++--
 {include/linux => drivers/staging/smbfs}/smbno.h   |    0
 {fs => drivers/staging}/smbfs/sock.c               |    7 ++--
 {fs => drivers/staging}/smbfs/symlink.c            |    5 +--
 fs/Kconfig                                         |    1 -
 fs/Makefile                                        |    1 -
 fs/compat.c                                        |   31 +-------------------
 fs/compat_ioctl.c                                  |   26 ----------------
 include/linux/Kbuild                               |    4 --
 34 files changed, 44 insertions(+), 103 deletions(-)
 rename {fs => drivers/staging}/smbfs/Kconfig (100%)
 rename {fs => drivers/staging}/smbfs/Makefile (100%)
 create mode 100644 drivers/staging/smbfs/TODO
 rename {fs => drivers/staging}/smbfs/cache.c (99%)
 rename {fs => drivers/staging}/smbfs/dir.c (99%)
 rename {fs => drivers/staging}/smbfs/file.c (99%)
 rename {fs => drivers/staging}/smbfs/getopt.c (100%)
 rename {fs => drivers/staging}/smbfs/getopt.h (100%)
 rename {fs => drivers/staging}/smbfs/inode.c (99%)
 rename {fs => drivers/staging}/smbfs/ioctl.c (96%)
 rename {fs => drivers/staging}/smbfs/proc.c (99%)
 rename {fs => drivers/staging}/smbfs/proto.h (100%)
 rename {fs => drivers/staging}/smbfs/request.c (99%)
 rename {fs => drivers/staging}/smbfs/request.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb.h (100%)
 rename {fs => drivers/staging}/smbfs/smb_debug.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs.h (97%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs_i.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs_sb.h (98%)
 rename {include/linux => drivers/staging/smbfs}/smb_mount.h (100%)
 rename {Documentation/filesystems => drivers/staging/smbfs}/smbfs.txt (100%)
 rename {fs => drivers/staging}/smbfs/smbiod.c (98%)
 rename {include/linux => drivers/staging/smbfs}/smbno.h (100%)
 rename {fs => drivers/staging}/smbfs/sock.c (99%)
 rename {fs => drivers/staging}/smbfs/symlink.c (96%)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 4303614..8c624a1 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -96,8 +96,6 @@ seq_file.txt
 	- how to use the seq_file API
 sharedsubtree.txt
 	- a description of shared subtrees for namespaces.
-smbfs.txt
-	- info on using filesystems with the SMB protocol (Win 3.11 and NT).
 spufs.txt
 	- info and mount options for the SPU filesystem used on Cell.
 sysfs-pci.txt
diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 33223ff..d15834a 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -259,7 +259,7 @@ Code  Seq#(hex)	Include File		Comments
 't'	00-7F	linux/if_ppp.h
 't'	80-8F	linux/isdn_ppp.h
 't'	90	linux/toshiba.h
-'u'	00-1F	linux/smb_fs.h
+'u'	00-1F	linux/smb_fs.h		gone
 'v'	all	linux/videodev.h	conflict!
 'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	00-1F	linux/fs.h		conflict!
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 0150353..4a91908 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -149,6 +149,8 @@ source "drivers/staging/msm/Kconfig"
 
 source "drivers/staging/lirc/Kconfig"
 
+source "drivers/staging/smbfs/Kconfig"
+
 source "drivers/staging/easycap/Kconfig"
 
 source "drivers/staging/solo6x10/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index de5c0e5..7cb02a8 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_IDE_PHISON)	+= phison/
 obj-$(CONFIG_LINE6_USB)		+= line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
+obj-$(CONFIG_SMB_FS)		+= smbfs/
 obj-$(CONFIG_USB_SERIAL_QUATECH_USB2)	+= quatech_usb2/
 obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
 obj-$(CONFIG_VT6655)		+= vt6655/
diff --git a/fs/smbfs/Kconfig b/drivers/staging/smbfs/Kconfig
similarity index 100%
rename from fs/smbfs/Kconfig
rename to drivers/staging/smbfs/Kconfig
diff --git a/fs/smbfs/Makefile b/drivers/staging/smbfs/Makefile
similarity index 100%
rename from fs/smbfs/Makefile
rename to drivers/staging/smbfs/Makefile
diff --git a/drivers/staging/smbfs/TODO b/drivers/staging/smbfs/TODO
new file mode 100644
index 0000000..24f4d29
--- /dev/null
+++ b/drivers/staging/smbfs/TODO
@@ -0,0 +1,8 @@
+smbfs is on its way out of the kernel, it has been replaced
+by cifs several years ago.
+
+The smbfs code uses the big kernel lock which
+is getting deprecated.
+
+Users that find smbfs to work but not cifs should contact
+the CIFS developers on linux-cifs-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
diff --git a/fs/smbfs/cache.c b/drivers/staging/smbfs/cache.c
similarity index 99%
rename from fs/smbfs/cache.c
rename to drivers/staging/smbfs/cache.c
index 8c177eb..dbb9865 100644
--- a/fs/smbfs/cache.c
+++ b/drivers/staging/smbfs/cache.c
@@ -13,12 +13,12 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/smb_fs.h>
 #include <linux/pagemap.h>
 #include <linux/net.h>
 
 #include <asm/page.h>
 
+#include "smb_fs.h"
 #include "smb_debug.h"
 #include "proto.h"
 
diff --git a/fs/smbfs/dir.c b/drivers/staging/smbfs/dir.c
similarity index 99%
rename from fs/smbfs/dir.c
rename to drivers/staging/smbfs/dir.c
index 00a70ca..936b3bb 100644
--- a/fs/smbfs/dir.c
+++ b/drivers/staging/smbfs/dir.c
@@ -15,9 +15,9 @@
 #include <linux/net.h>
 #include <linux/sched.h>
 
-#include <linux/smb_fs.h>
-#include <linux/smb_mount.h>
-#include <linux/smbno.h>
+#include "smb_fs.h"
+#include "smb_mount.h"
+#include "smbno.h"
 
 #include "smb_debug.h"
 #include "proto.h"
diff --git a/fs/smbfs/file.c b/drivers/staging/smbfs/file.c
similarity index 99%
rename from fs/smbfs/file.c
rename to drivers/staging/smbfs/file.c
index 8e187a0..5dcd19c 100644
--- a/fs/smbfs/file.c
+++ b/drivers/staging/smbfs/file.c
@@ -21,9 +21,8 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#include <linux/smbno.h>
-#include <linux/smb_fs.h>
-
+#include "smbno.h"
+#include "smb_fs.h"
 #include "smb_debug.h"
 #include "proto.h"
 
diff --git a/fs/smbfs/getopt.c b/drivers/staging/smbfs/getopt.c
similarity index 100%
rename from fs/smbfs/getopt.c
rename to drivers/staging/smbfs/getopt.c
diff --git a/fs/smbfs/getopt.h b/drivers/staging/smbfs/getopt.h
similarity index 100%
rename from fs/smbfs/getopt.h
rename to drivers/staging/smbfs/getopt.h
diff --git a/fs/smbfs/inode.c b/drivers/staging/smbfs/inode.c
similarity index 99%
rename from fs/smbfs/inode.c
rename to drivers/staging/smbfs/inode.c
index 450c919..9287599 100644
--- a/fs/smbfs/inode.c
+++ b/drivers/staging/smbfs/inode.c
@@ -26,13 +26,13 @@
 #include <linux/vfs.h>
 #include <linux/highuid.h>
 #include <linux/sched.h>
-#include <linux/smb_fs.h>
-#include <linux/smbno.h>
-#include <linux/smb_mount.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
+#include "smb_fs.h"
+#include "smbno.h"
+#include "smb_mount.h"
 #include "smb_debug.h"
 #include "getopt.h"
 #include "proto.h"
@@ -504,7 +504,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 	if (warn_count < 5) {
 		warn_count++;
 		printk(KERN_EMERG "smbfs is deprecated and will be removed"
-			" from the 2.6.27 kernel. Please migrate to cifs\n");
+			" from the 2.6.37 kernel. Please migrate to cifs\n");
 	}
 
 	if (!raw_data)
diff --git a/fs/smbfs/ioctl.c b/drivers/staging/smbfs/ioctl.c
similarity index 96%
rename from fs/smbfs/ioctl.c
rename to drivers/staging/smbfs/ioctl.c
index 0721531..2da1692 100644
--- a/fs/smbfs/ioctl.c
+++ b/drivers/staging/smbfs/ioctl.c
@@ -16,11 +16,10 @@
 #include <linux/smp_lock.h>
 #include <linux/net.h>
 
-#include <linux/smb_fs.h>
-#include <linux/smb_mount.h>
-
 #include <asm/uaccess.h>
 
+#include "smb_fs.h"
+#include "smb_mount.h"
 #include "proto.h"
 
 long
diff --git a/fs/smbfs/proc.c b/drivers/staging/smbfs/proc.c
similarity index 99%
rename from fs/smbfs/proc.c
rename to drivers/staging/smbfs/proc.c
index 71c29b6..2fb079c 100644
--- a/fs/smbfs/proc.c
+++ b/drivers/staging/smbfs/proc.c
@@ -20,15 +20,14 @@
 #include <linux/smp_lock.h>
 #include <linux/net.h>
 #include <linux/vfs.h>
-#include <linux/smb_fs.h>
-#include <linux/smbno.h>
-#include <linux/smb_mount.h>
-
 #include <net/sock.h>
 
 #include <asm/string.h>
 #include <asm/div64.h>
 
+#include "smb_fs.h"
+#include "smbno.h"
+#include "smb_mount.h"
 #include "smb_debug.h"
 #include "proto.h"
 #include "request.h"
diff --git a/fs/smbfs/proto.h b/drivers/staging/smbfs/proto.h
similarity index 100%
rename from fs/smbfs/proto.h
rename to drivers/staging/smbfs/proto.h
diff --git a/fs/smbfs/request.c b/drivers/staging/smbfs/request.c
similarity index 99%
rename from fs/smbfs/request.c
rename to drivers/staging/smbfs/request.c
index 45f4593..3e77168 100644
--- a/fs/smbfs/request.c
+++ b/drivers/staging/smbfs/request.c
@@ -13,10 +13,9 @@
 #include <linux/net.h>
 #include <linux/sched.h>
 
-#include <linux/smb_fs.h>
-#include <linux/smbno.h>
-#include <linux/smb_mount.h>
-
+#include "smb_fs.h"
+#include "smbno.h"
+#include "smb_mount.h"
 #include "smb_debug.h"
 #include "request.h"
 #include "proto.h"
diff --git a/fs/smbfs/request.h b/drivers/staging/smbfs/request.h
similarity index 100%
rename from fs/smbfs/request.h
rename to drivers/staging/smbfs/request.h
diff --git a/include/linux/smb.h b/drivers/staging/smbfs/smb.h
similarity index 100%
rename from include/linux/smb.h
rename to drivers/staging/smbfs/smb.h
diff --git a/fs/smbfs/smb_debug.h b/drivers/staging/smbfs/smb_debug.h
similarity index 100%
rename from fs/smbfs/smb_debug.h
rename to drivers/staging/smbfs/smb_debug.h
diff --git a/include/linux/smb_fs.h b/drivers/staging/smbfs/smb_fs.h
similarity index 97%
rename from include/linux/smb_fs.h
rename to drivers/staging/smbfs/smb_fs.h
index 923cd8a..20a05c1 100644
--- a/include/linux/smb_fs.h
+++ b/drivers/staging/smbfs/smb_fs.h
@@ -9,7 +9,7 @@
 #ifndef _LINUX_SMB_FS_H
 #define _LINUX_SMB_FS_H
 
-#include <linux/smb.h>
+#include "smb.h"
 
 /*
  * ioctl commands
@@ -22,13 +22,13 @@
 
 
 #ifdef __KERNEL__
-#include <linux/smb_fs_i.h>
-#include <linux/smb_fs_sb.h>
+#include "smb_fs_i.h"
+#include "smb_fs_sb.h"
+#include "smb_mount.h"
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
-#include <linux/smb_mount.h>
 #include <linux/jiffies.h>
 #include <asm/unaligned.h>
 
diff --git a/include/linux/smb_fs_i.h b/drivers/staging/smbfs/smb_fs_i.h
similarity index 100%
rename from include/linux/smb_fs_i.h
rename to drivers/staging/smbfs/smb_fs_i.h
diff --git a/include/linux/smb_fs_sb.h b/drivers/staging/smbfs/smb_fs_sb.h
similarity index 98%
rename from include/linux/smb_fs_sb.h
rename to drivers/staging/smbfs/smb_fs_sb.h
index bb947dd..ca058af 100644
--- a/include/linux/smb_fs_sb.h
+++ b/drivers/staging/smbfs/smb_fs_sb.h
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/backing-dev.h>
-#include <linux/smb.h>
+#include "smb.h"
 
 /*
  * Upper limit on the total number of active smb_request structs.
diff --git a/include/linux/smb_mount.h b/drivers/staging/smbfs/smb_mount.h
similarity index 100%
rename from include/linux/smb_mount.h
rename to drivers/staging/smbfs/smb_mount.h
diff --git a/Documentation/filesystems/smbfs.txt b/drivers/staging/smbfs/smbfs.txt
similarity index 100%
rename from Documentation/filesystems/smbfs.txt
rename to drivers/staging/smbfs/smbfs.txt
diff --git a/fs/smbfs/smbiod.c b/drivers/staging/smbfs/smbiod.c
similarity index 98%
rename from fs/smbfs/smbiod.c
rename to drivers/staging/smbfs/smbiod.c
index 0e39a92..ec99892 100644
--- a/fs/smbfs/smbiod.c
+++ b/drivers/staging/smbfs/smbiod.c
@@ -20,13 +20,12 @@
 #include <linux/kthread.h>
 #include <net/ip.h>
 
-#include <linux/smb_fs.h>
-#include <linux/smbno.h>
-#include <linux/smb_mount.h>
-
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
+#include "smb_fs.h"
+#include "smbno.h"
+#include "smb_mount.h"
 #include "smb_debug.h"
 #include "request.h"
 #include "proto.h"
diff --git a/include/linux/smbno.h b/drivers/staging/smbfs/smbno.h
similarity index 100%
rename from include/linux/smbno.h
rename to drivers/staging/smbfs/smbno.h
diff --git a/fs/smbfs/sock.c b/drivers/staging/smbfs/sock.c
similarity index 99%
rename from fs/smbfs/sock.c
rename to drivers/staging/smbfs/sock.c
index e37fe4d..9e26409 100644
--- a/fs/smbfs/sock.c
+++ b/drivers/staging/smbfs/sock.c
@@ -22,13 +22,12 @@
 #include <net/tcp_states.h>
 #include <net/ip.h>
 
-#include <linux/smb_fs.h>
-#include <linux/smb.h>
-#include <linux/smbno.h>
-
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 
+#include "smb_fs.h"
+#include "smb.h"
+#include "smbno.h"
 #include "smb_debug.h"
 #include "proto.h"
 #include "request.h"
diff --git a/fs/smbfs/symlink.c b/drivers/staging/smbfs/symlink.c
similarity index 96%
rename from fs/smbfs/symlink.c
rename to drivers/staging/smbfs/symlink.c
index 00b2909..632c4ac 100644
--- a/fs/smbfs/symlink.c
+++ b/drivers/staging/smbfs/symlink.c
@@ -19,9 +19,8 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#include <linux/smbno.h>
-#include <linux/smb_fs.h>
-
+#include "smbno.h"
+#include "smb_fs.h"
 #include "smb_debug.h"
 #include "proto.h"
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 30da8ee..25ce2dc 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -233,7 +233,6 @@ config NFS_COMMON
 	default y
 
 source "net/sunrpc/Kconfig"
-source "fs/smbfs/Kconfig"
 source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
 source "fs/ncpfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index e571fed..9284c74 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -91,7 +91,6 @@ obj-$(CONFIG_NFSD)		+= nfsd/
 obj-$(CONFIG_LOCKD)		+= lockd/
 obj-$(CONFIG_NLS)		+= nls/
 obj-$(CONFIG_SYSV_FS)		+= sysv/
-obj-$(CONFIG_SMB_FS)		+= smbfs/
 obj-$(CONFIG_CIFS)		+= cifs/
 obj-$(CONFIG_NCP_FS)		+= ncpfs/
 obj-$(CONFIG_HPFS_FS)		+= hpfs/
diff --git a/fs/compat.c b/fs/compat.c
index 718c706..b42f29a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -29,8 +29,6 @@
 #include <linux/vfs.h>
 #include <linux/ioctl.h>
 #include <linux/init.h>
-#include <linux/smb.h>
-#include <linux/smb_mount.h>
 #include <linux/ncp_mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/syscalls.h>
@@ -745,30 +743,6 @@ static void *do_ncp_super_data_conv(void *raw_data)
 	return raw_data;
 }
 
-struct compat_smb_mount_data {
-	compat_int_t version;
-	__compat_uid_t mounted_uid;
-	__compat_uid_t uid;
-	__compat_gid_t gid;
-	compat_mode_t file_mode;
-	compat_mode_t dir_mode;
-};
-
-static void *do_smb_super_data_conv(void *raw_data)
-{
-	struct smb_mount_data *s = raw_data;
-	struct compat_smb_mount_data *c_s = raw_data;
-
-	if (c_s->version != SMB_MOUNT_OLDVERSION)
-		goto out;
-	s->dir_mode = c_s->dir_mode;
-	s->file_mode = c_s->file_mode;
-	s->gid = c_s->gid;
-	s->uid = c_s->uid;
-	s->mounted_uid = c_s->mounted_uid;
- out:
-	return raw_data;
-}
 
 struct compat_nfs_string {
 	compat_uint_t len;
@@ -835,7 +809,6 @@ static int do_nfs4_super_data_conv(void *raw_data)
 	return 0;
 }
 
-#define SMBFS_NAME      "smbfs"
 #define NCPFS_NAME      "ncpfs"
 #define NFS4_NAME	"nfs4"
 
@@ -870,9 +843,7 @@ asmlinkage long compat_sys_mount(const char __user * dev_name,
 	retval = -EINVAL;
 
 	if (kernel_type && data_page) {
-		if (!strcmp(kernel_type, SMBFS_NAME)) {
-			do_smb_super_data_conv((void *)data_page);
-		} else if (!strcmp(kernel_type, NCPFS_NAME)) {
+		if (!strcmp(kernel_type, NCPFS_NAME)) {
 			do_ncp_super_data_conv((void *)data_page);
 		} else if (!strcmp(kernel_type, NFS4_NAME)) {
 			if (do_nfs4_super_data_conv((void *) data_page))
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 03e59aa..34cf03c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -46,7 +46,6 @@
 #include <linux/videodev.h>
 #include <linux/netdevice.h>
 #include <linux/raw.h>
-#include <linux/smb_fs.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/rtc.h>
@@ -558,25 +557,6 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
 
 #endif /* CONFIG_BLOCK */
 
-static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
-			compat_uid_t __user *argp)
-{
-	mm_segment_t old_fs = get_fs();
-	__kernel_uid_t kuid;
-	int err;
-
-	cmd = SMB_IOC_GETMOUNTUID;
-
-	set_fs(KERNEL_DS);
-	err = sys_ioctl(fd, cmd, (unsigned long)&kuid);
-	set_fs(old_fs);
-
-	if (err >= 0)
-		err = put_user(kuid, argp);
-
-	return err;
-}
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO		_IOW('U', 200, int)
 #define HCIUARTGETPROTO		_IOR('U', 201, int)
@@ -1265,8 +1245,6 @@ COMPATIBLE_IOCTL(OSS_GETVERSION)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
 COMPATIBLE_IOCTL(RAW_GETBIND)
-/* SMB ioctls which do not need any translations */
-COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
 /* Watchdog */
 COMPATIBLE_IOCTL(WDIOC_GETSUPPORT)
 COMPATIBLE_IOCTL(WDIOC_GETSTATUS)
@@ -1528,10 +1506,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case RAW_GETBIND:
 		return raw_ioctl(fd, cmd, argp);
 #endif
-	/* One SMB ioctl needs translations. */
-#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
-	case SMB_IOC_GETMOUNTUID_32:
-		return do_smb_getmountuid(fd, cmd, argp);
 	/* Serial */
 	case TIOCGSERIAL:
 	case TIOCSSERIAL:
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 626b629..98d520d 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -326,10 +326,6 @@ header-y += serio.h
 header-y += shm.h
 header-y += signal.h
 header-y += signalfd.h
-header-y += smb.h
-header-y += smb_fs.h
-header-y += smb_mount.h
-header-y += smbno.h
 header-y += snmp.h
 header-y += socket.h
 header-y += sockios.h
-- 
1.7.1
