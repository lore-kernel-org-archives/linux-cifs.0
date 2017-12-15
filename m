From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] cifs: Fix missing put_xid in cifs_file_strict_mmap
Date: Fri, 15 Dec 2017 12:48:32 -0800
Message-ID: <20171215204832.12764-1-willy@infradead.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

If cifs_zap_mapping() returned an error, we would return without putting
the xid that we got earlier.  Restructure cifs_file_strict_mmap() and
cifs_file_mmap() to be more similar to each other and have a single
point of return that always puts the xid.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index df9f682708c6..3a85df2a9baf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3471,20 +3471,18 @@ static const struct vm_operations_struct cifs_file_vm_ops = {
 
 int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	int rc, xid;
+	int xid, rc = 0;
 	struct inode *inode = file_inode(file);
 
 	xid = get_xid();
 
-	if (!CIFS_CACHE_READ(CIFS_I(inode))) {
+	if (!CIFS_CACHE_READ(CIFS_I(inode)))
 		rc = cifs_zap_mapping(inode);
-		if (rc)
-			return rc;
-	}
-
-	rc = generic_file_mmap(file, vma);
-	if (rc == 0)
+	if (!rc)
+		rc = generic_file_mmap(file, vma);
+	if (!rc)
 		vma->vm_ops = &cifs_file_vm_ops;
+
 	free_xid(xid);
 	return rc;
 }
@@ -3494,16 +3492,16 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	int rc, xid;
 
 	xid = get_xid();
+
 	rc = cifs_revalidate_file(file);
-	if (rc) {
+	if (rc)
 		cifs_dbg(FYI, "Validation prior to mmap failed, error=%d\n",
 			 rc);
-		free_xid(xid);
-		return rc;
-	}
-	rc = generic_file_mmap(file, vma);
-	if (rc == 0)
+	if (!rc)
+		rc = generic_file_mmap(file, vma);
+	if (!rc)
 		vma->vm_ops = &cifs_file_vm_ops;
+
 	free_xid(xid);
 	return rc;
 }
-- 
2.15.1
