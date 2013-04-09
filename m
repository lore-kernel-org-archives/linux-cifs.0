From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v5 7/7] locks: Disable LOCK_MAND support for MS_SHARELOCK mounts
Date: Tue,  9 Apr 2013 16:40:27 +0400
Message-ID: <1365511227-17626-8-git-send-email-piastry@etersoft.ru>
References: <1365511227-17626-1-git-send-email-piastry@etersoft.ru>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365511227-17626-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/locks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 1402a43..a67857c 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1719,6 +1719,12 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 	if (!f.file)
 		goto out;
 
+	/* Disable LOCK_MAND support for FS mounted with MS_SHARELOCK */
+	if (IS_SHARELOCK(f.file->f_path.dentry->d_inode)) {
+		error = -EPERM;
+		goto out;
+	}
+
 	can_sleep = !(cmd & LOCK_NB);
 	cmd &= ~LOCK_NB;
 	unlock = (cmd == LOCK_UN);
-- 
1.8.1.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
