From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] cifs: clean up id_mode_to_cifs_acl
Date: Tue, 16 Oct 2012 07:26:43 -0400
Message-ID: <1350386806-18356-2-git-send-email-jlayton@redhat.com>
References: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350386806-18356-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a label we can goto on error, and get rid of some excess indentation.
Also move to kernel-style comments.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 53 +++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 0955d23..d0b2bfb 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1307,42 +1307,39 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 
 	/* Get the security descriptor */
 	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
-
-	/* Add three ACEs for owner, group, everyone getting rid of
-	   other ACEs as chmod disables ACEs and set the security descriptor */
-
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
 		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
-	} else {
-		/* allocate memory for the smb header,
-		   set security descriptor request security descriptor
-		   parameters, and secuirty descriptor itself */
-
-		secdesclen = secdesclen < DEFSECDESCLEN ?
-					DEFSECDESCLEN : secdesclen;
-		pnntsd = kmalloc(secdesclen, GFP_KERNEL);
-		if (!pnntsd) {
-			cERROR(1, "Unable to allocate security descriptor");
-			kfree(pntsd);
-			return -ENOMEM;
-		}
+		goto out;
+	}
 
-		rc = build_sec_desc(pntsd, pnntsd, secdesclen, nmode, uid, gid,
-					&aclflag);
+	/*
+	 * Add three ACEs for owner, group, everyone getting rid of other ACEs
+	 * as chmod disables ACEs and set the security descriptor allocate
+	 * memory for the smb header, set security descriptor request security
+	 * descriptor parameters, and secuirty descriptor itself
+	 */
+	secdesclen = max_t(u32, secdesclen, DEFSECDESCLEN);
+	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
+	if (!pnntsd) {
+		cERROR(1, "Unable to allocate security descriptor");
+		kfree(pntsd);
+		return -ENOMEM;
+	}
 
-		cFYI(DBG2, "build_sec_desc rc: %d", rc);
+	rc = build_sec_desc(pntsd, pnntsd, secdesclen, nmode, uid, gid,
+				&aclflag);
 
-		if (!rc) {
-			/* Set the security descriptor */
-			rc = set_cifs_acl(pnntsd, secdesclen, inode,
-						path, aclflag);
-			cFYI(DBG2, "set_cifs_acl rc: %d", rc);
-		}
+	cFYI(DBG2, "build_sec_desc rc: %d", rc);
 
-		kfree(pnntsd);
-		kfree(pntsd);
+	if (!rc) {
+		/* Set the security descriptor */
+		rc = set_cifs_acl(pnntsd, secdesclen, inode, path, aclflag);
+		cFYI(DBG2, "set_cifs_acl rc: %d", rc);
 	}
 
+	kfree(pnntsd);
+	kfree(pntsd);
+out:
 	return rc;
 }
-- 
1.7.11.7
