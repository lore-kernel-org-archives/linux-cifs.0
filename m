From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] Add support for original fallocate
Date: Mon, 20 Oct 2014 15:10:46 -0500
Message-ID: <1413835849-13629-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In many cases the simple fallocate call is
a no op (since the file is already not sparse) or
can simply be converted from a sparse to a non-sparse
file if we are fallocating the whole file and keeping
the size.

Signed-off-by: Steven French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c5f521b..568f323 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1102,6 +1102,64 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
+			    loff_t off, loff_t len, bool keep_size)
+{
+	struct inode *inode;
+	struct cifsInodeInfo *cifsi;
+	struct cifsFileInfo *cfile = file->private_data;
+	long rc = -EOPNOTSUPP;
+	unsigned int xid;
+
+	xid = get_xid();
+
+	inode = cfile->dentry->d_inode;
+	cifsi = CIFS_I(inode);
+
+	/* if file not oplocked can't be sure whether asking to extend size */
+	if (!CIFS_CACHE_READ(cifsi))
+		if (keep_size == false)
+			return -EOPNOTSUPP;
+
+	/*
+	 * Files are non-sparse by default so falloc may be a no-op
+	 * Must check if file sparse. If not sparse, and not extending
+	 * then no need to do anything since file already allocated
+	 */
+	if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0) {
+		if (keep_size == true)
+			return 0;
+		/* check if extending file */
+		else if (i_size_read(inode) >= off + len)
+			/* not extending file and already not sparse */
+			return 0;
+		/* BB: in future add else clause to extend file */
+		else
+			return -EOPNOTSUPP;
+	}
+
+	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+		/*
+		 * Check if falloc starts within first few pages of file
+		 * and ends within a few pages of the end of file to
+		 * ensure that most of file is being forced to be
+		 * fallocated now. If so then setting whole file sparse
+		 * ie potentially making a few extra pages at the beginning
+		 * or end of the file non-sparse via set_sparse is harmless.
+		 */
+		if ((off > 8192) || (off + len + 8192 < i_size_read(inode)))
+			return -EOPNOTSUPP;
+
+		rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
+	}
+	/* BB: else ... in future add code to extend file and set sparse */
+
+
+	free_xid(xid);
+	return rc;
+}
+
+
 static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 			   loff_t off, loff_t len)
 {
@@ -1112,7 +1170,10 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 		if (mode & FALLOC_FL_KEEP_SIZE)
 			return smb3_zero_range(file, tcon, off, len, true);
 		return smb3_zero_range(file, tcon, off, len, false);
-	}
+	} else if (mode == FALLOC_FL_KEEP_SIZE)
+		return smb3_simple_falloc(file, tcon, off, len, true);
+	else if (mode == 0)
+		return smb3_simple_falloc(file, tcon, off, len, false);
 
 	return -EOPNOTSUPP;
 }
-- 
1.9.1
