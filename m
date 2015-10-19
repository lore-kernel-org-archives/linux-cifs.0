From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: Allow using O_DIRECT with cache=loose
Date: Mon, 19 Oct 2015 14:22:48 +0100
Message-ID: <1445260968-1826-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently O_DIRECT is supported with cache=none and cache=strict, but
not cache=loose. Add support for using O_DIRECT when mounted with
cache=loose.

Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e739950..f5701aa 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -748,6 +748,9 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
+	if (iocb->ki_filp->f_flags & O_DIRECT)
+		return cifs_user_readv(iocb, iter);
+
 	rc = cifs_revalidate_mapping(inode);
 	if (rc)
 		return rc;
@@ -762,6 +765,18 @@ static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t written;
 	int rc;
 
+	if (iocb->ki_filp->f_flags & O_DIRECT) {
+		written = cifs_user_writev(iocb, from);
+		if (written > 0 && CIFS_CACHE_READ(cinode)) {
+			cifs_zap_mapping(inode);
+			cifs_dbg(FYI,
+				 "Set no oplock for inode=%p after a write operation\n",
+				 inode);
+			cinode->oplock = 0;
+		}
+		return written;
+	}
+
 	written = cifs_get_writer(cinode);
 	if (written)
 		return written;
-- 
2.4.3
