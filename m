From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Decrease verbosity of ioctl call
Date: Tue, 22 Nov 2016 16:25:16 -0800
Message-ID: <1479860716-42124-1-git-send-email-pshilov@microsoft.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 9f51b81..0015287 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -189,7 +189,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	xid = get_xid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-	cifs_dbg(VFS, "cifs ioctl 0x%x\n", command);
+	cifs_dbg(FYI, "cifs ioctl 0x%x\n", command);
 	switch (command) {
 		case FS_IOC_GETFLAGS:
 			if (pSMBFile == NULL)
-- 
2.7.4
