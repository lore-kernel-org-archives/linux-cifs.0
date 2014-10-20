From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] [CIFS] Update modinfo cifs version for cifs.ko
Date: Mon, 20 Oct 2014 15:09:03 -0500
Message-ID: <1413835743-13566-3-git-send-email-smfrench@gmail.com>
References: <1413835743-13566-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413835743-13566-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

update cifs version to 2.06

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 002e0c1..252f5c1 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -136,5 +136,5 @@ extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
 
-#define CIFS_VERSION   "2.05"
+#define CIFS_VERSION   "2.06"
 #endif				/* _CIFSFS_H */
-- 
1.9.1
