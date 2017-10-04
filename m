From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Fake rwx permissions if we can not read the CIFS ACL
Date: Wed,  4 Oct 2017 15:59:53 +1100
Message-ID: <20171004045953.28134-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the cifsacl mount option is used and we try to list a directory that
contains entries where we do not have READ_CONTROL access we will see errors
such as "ls: cannot access '...': Permission denied"
and the directory listing will show files with funny attributes like
"-?????????? ? ?    ?    ?            ? foo002.txt"

This patch fixes this by checking the error from reading the security
descriptor and if it failed with EACCES we fake the attributes as
all 0.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b98436f5c7c7..11d0d135a9b7 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1155,7 +1155,15 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
-		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
+		if (rc == -EACCES) {
+			/* If we do not have permission to read the ACL
+			   just clear all rwx permissions */
+			cifs_dbg(NOISY, "%s: EACCES reading ACL\n", __func__);
+			fattr->cf_mode &= ~(S_IRWXUGO);
+			rc = 0;
+		} else
+			cifs_dbg(VFS, "%s: error %d getting sec desc\n",
+				 __func__, rc);
 	} else {
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
 		kfree(pntsd);
-- 
2.13.3
