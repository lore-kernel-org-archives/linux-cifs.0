From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 1/5] CIFS: Decrease verbosity of ioctl call
Date: Tue, 29 Nov 2016 16:56:52 -0800
Message-ID: <1480467416-13636-2-git-send-email-pshilov@microsoft.com>
References: <1480467416-13636-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480467416-13636-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.9+
Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
