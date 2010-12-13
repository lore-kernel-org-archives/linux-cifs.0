From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] CIFS: Implement cifs_file_strict_mmap
Date: Mon, 13 Dec 2010 18:00:52 +0300
Message-ID: <1292252455-4025-4-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Invalidate inode if we don't have at least Level II oplock.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 938f26a..dd1e59a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1829,8 +1829,16 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 
 int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	int rc = 0;
-	/* BB */
+	int rc, xid;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	xid = GetXid();
+
+	if (!CIFS_I(inode)->clientCanCacheRead)
+		cifs_invalidate_mapping(inode);
+
+	rc = generic_file_mmap(file, vma);
+	FreeXid(xid);
 	return rc;
 }
 
@@ -1839,12 +1847,14 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	int rc, xid;
 
 	xid = GetXid();
+
 	rc = cifs_revalidate_file(file);
 	if (rc) {
 		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
 		FreeXid(xid);
 		return rc;
 	}
+
 	rc = generic_file_mmap(file, vma);
 	FreeXid(xid);
 	return rc;
-- 
1.7.3.2
