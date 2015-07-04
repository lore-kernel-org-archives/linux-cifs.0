From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Update cifs version number
Date: Sat,  4 Jul 2015 18:57:21 -0500
Message-ID: <1436054241-28245-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Update modinfo cifs.ko version number to 2.07

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index a782b22..27aea11 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -136,5 +136,5 @@ extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
 
-#define CIFS_VERSION   "2.06"
+#define CIFS_VERSION   "2.07"
 #endif				/* _CIFSFS_H */
-- 
2.1.4
