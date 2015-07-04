From: Steve French <smfrench@gmail.com>
Subject: [PATCH 1/2] Add way to query server fs info for smb3
Date: Sat,  4 Jul 2015 18:56:45 -0500
Message-ID: <1436054205-27501-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org,
	Steve French <steve.french@primarydata.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The server exports information about the share and underlying
device under an SMB3 export, including its attributes and
capabilities, which is stored by cifs.ko when first connecting
to the share.

Add ioctl to cifs.ko to allow user space smb3 helper utilities
(in cifs-utils) to display this (e.g. via smb3util).

This information is also useful for debugging and for
resolving configuration errors.

Signed-off-by: Steve French <steve.french@primarydata.com>
---
 fs/cifs/cifs_ioctl.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifspdu.h    | 14 ++++++++++++++
 fs/cifs/ioctl.c      | 48 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 98 insertions(+), 6 deletions(-)
 create mode 100644 fs/cifs/cifs_ioctl.h

diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
new file mode 100644
index 0000000..0065256
--- /dev/null
+++ b/fs/cifs/cifs_ioctl.h
@@ -0,0 +1,42 @@
+/*
+ *   fs/cifs/cifs_ioctl.h
+ *
+ *   Structure definitions for io control for cifs/smb3
+ *
+ *   Copyright (c) 2015 Steve French <steve.french@primarydata.com>
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ */
+
+struct smb_mnt_fs_info {
+	__u32	version; /* 0001 */
+	__u16	protocol_id;
+	__u16	tcon_flags;
+	__u32	vol_serial_number;
+	__u32	vol_create_time;
+	__u32	share_caps;
+	__u32	share_flags;
+	__u32	sector_flags;
+	__u32	optimal_sector_size;
+	__u32	max_bytes_chunk;
+	__u32	fs_attributes;
+	__u32	max_path_component;
+	__u32	device_type;
+	__u32	device_characteristics;
+	__u32	maximal_access;
+	__u64   cifs_posix_caps;
+} __packed;
+
+#define CIFS_IOCTL_MAGIC	0xCF
+#define CIFS_IOC_COPYCHUNK_FILE	_IOW(CIFS_IOCTL_MAGIC, 3, int)
+#define CIFS_IOC_SET_INTEGRITY  _IO(CIFS_IOCTL_MAGIC, 4)
+#define CIFS_IOC_GET_MNT_INFO _IOR(CIFS_IOCTL_MAGIC, 5, struct smb_mnt_fs_info)
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 47b030d..f5b8730 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2245,6 +2245,20 @@ typedef struct {
 #define FILE_DEVICE_VIRTUAL_DISK        0x00000024
 #define FILE_DEVICE_NETWORK_REDIRECTOR  0x00000028
 
+/* Device Characteristics */
+#define FILE_REMOVABLE_MEDIA			0x00000001
+#define FILE_READ_ONLY_DEVICE			0x00000002
+#define FILE_FLOPPY_DISKETTE			0x00000004
+#define FILE_WRITE_ONCE_MEDIA			0x00000008
+#define FILE_REMOTE_DEVICE			0x00000010
+#define FILE_DEVICE_IS_MOUNTED			0x00000020
+#define FILE_VIRTUAL_VOLUME			0x00000040
+#define FILE_DEVICE_SECURE_OPEN			0x00000100
+#define FILE_CHARACTERISTIC_TS_DEVICE		0x00001000
+#define FILE_CHARACTERISTIC_WEBDAV_DEVICE	0x00002000
+#define FILE_PORTABLE_DEVICE			0x00004000
+#define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
+
 typedef struct {
 	__le32 DeviceType;
 	__le32 DeviceCharacteristics;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 49b8b6e..c63f522 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -31,12 +31,9 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include "cifs_ioctl.h"
 #include <linux/btrfs.h>
 
-#define CIFS_IOCTL_MAGIC	0xCF
-#define CIFS_IOC_COPYCHUNK_FILE	_IOW(CIFS_IOCTL_MAGIC, 3, int)
-#define CIFS_IOC_SET_INTEGRITY  _IO(CIFS_IOCTL_MAGIC, 4)
-
 static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd, u64 off, u64 len, u64 destoff,
 			bool dup_extents)
@@ -135,6 +132,43 @@ out_drop_write:
 	return rc;
 }
 
+static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
+				void __user *arg)
+{
+	int rc = 0;
+	struct smb_mnt_fs_info *fsinf;
+
+	fsinf = kzalloc(sizeof(struct smb_mnt_fs_info), GFP_KERNEL);
+	if (fsinf == NULL)
+		return -ENOMEM;
+
+	fsinf->version = 1;
+	fsinf->protocol_id = tcon->ses->server->vals->protocol_id;
+	fsinf->device_characteristics =
+			le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics);
+	fsinf->device_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
+	fsinf->fs_attributes = le32_to_cpu(tcon->fsAttrInfo.Attributes);
+	fsinf->max_path_component =
+		le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength);
+#ifdef CONFIG_CIFS_SMB2
+	fsinf->vol_serial_number = tcon->vol_serial_number;
+	fsinf->vol_create_time = le64_to_cpu(tcon->vol_create_time);
+	fsinf->share_flags = tcon->share_flags;
+	fsinf->share_caps = le32_to_cpu(tcon->capabilities);
+	fsinf->sector_flags = tcon->ss_flags;
+	fsinf->optimal_sector_size = tcon->perf_sector_size;
+	fsinf->max_bytes_chunk = tcon->max_bytes_chunk;
+	fsinf->maximal_access = tcon->maximal_access;
+#endif /* SMB2 */
+	fsinf->cifs_posix_caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
+	if (copy_to_user(arg, fsinf, sizeof(struct smb_mnt_fs_info)))
+		rc = -EFAULT;
+
+	kfree(fsinf);
+	return rc;
+}
+
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
 	struct inode *inode = file_inode(filep);
@@ -148,8 +182,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "ioctl file %p  cmd %u  arg %lu\n", filep, command, arg);
-
 	cifs_sb = CIFS_SB(inode->i_sb);
 
 	switch (command) {
@@ -228,6 +260,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			else
 				rc = -EOPNOTSUPP;
 			break;
+		case CIFS_IOC_GET_MNT_INFO:
+			tcon = tlink_tcon(pSMBFile->tlink);
+			rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
+			break;
 		default:
 			cifs_dbg(FYI, "unsupported ioctl\n");
 			break;
-- 
2.1.4

