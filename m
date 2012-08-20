From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 07/10] CIFS: Fix cache coherency for read oplock case
Date: Mon, 20 Aug 2012 22:42:57 +0400
Message-ID: <1345488180-5942-8-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

When we have a file opened with read oplock and we are writing a data
to this file, we need to store the data in the cache and then send to
the server to ensure that the next read operation will get a coherent
data.

Also mark it as CONFIG_CIFS_SMB2 because it's more suitable for SMB2
code but can fix some CIFS problems too (when server delays sending
an oplock break after a write request). We can drop this ifdefs
dependence in future.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 930a66a..af4a832 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2410,6 +2410,17 @@ ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 
 	if (CIFS_I(inode)->clientCanCacheAll)
 		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+#ifdef CONFIG_CIFS_SMB2
+	else if (CIFS_I(inode)->clientCanCacheRead) {
+		ssize_t written;
+		int rc;
+		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+		rc = filemap_fdatawrite(inode->i_mapping);
+		if (rc)
+			return (ssize_t)rc;
+		return written;
+	}
+#endif
 
 	/*
 	 * In strict cache mode we need to write the data to the server exactly
-- 
1.7.1
