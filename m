From: Achilles Gaikwad <achillesgaikwad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs/cifs/cifsacl.c Fixes typo in a comment
Date: Sun, 28 Jan 2018 13:39:48 +0530
Message-ID: <20180128080948.GA16698@fubar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Achilles Gaikwad <achillesgaikwad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b98436f5c7c7..13a8a77322c9 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1125,7 +1125,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	return rc;
 }
 
-/* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mode bits */
+/* Translate the CIFS ACL (similar to NTFS ACL) for a file into mode bits */
 int
 cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 		  struct inode *inode, const char *path,
-- 
2.14.3
