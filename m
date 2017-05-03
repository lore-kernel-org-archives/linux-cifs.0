From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix CIFS_IOC_GET_MNT_INFO oops
Date: Thu,  4 May 2017 00:41:13 +0200
Message-ID: <20170503224113.28791-1-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

An open directory may have a NULL private_data pointer prior to readdir.

Fixes: 0de1f4c6f6c0 ("Add way to query server fs info for smb3")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 4d598a71cf84..76fb0917dc8c 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -209,6 +209,8 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				rc = -EOPNOTSUPP;
 			break;
 		case CIFS_IOC_GET_MNT_INFO:
+			if (pSMBFile == NULL)
+				break;
 			tcon = tlink_tcon(pSMBFile->tlink);
 			rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
 			break;
-- 
2.12.0
