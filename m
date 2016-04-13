From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/8] cifs: Fix removexattr for os2.* xattrs
Date: Thu, 14 Apr 2016 00:27:41 +0200
Message-ID: <1460586466-5518-4-git-send-email-agruenba@redhat.com>
References: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460586466-5518-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
References: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If cifs_removexattr finds a "user." or "os2." xattr name prefix, it
skips 5 bytes, one byte too many for "os2.".

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/xattr.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 6e73ba9..721c6db 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -61,15 +61,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 	}
 	if (ea_name == NULL) {
 		cifs_dbg(FYI, "Null xattr names not supported\n");
-	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
-		&& (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
-		cifs_dbg(FYI,
-			 "illegal xattr request %s (only user namespace supported)\n",
-			 ea_name);
-		/* BB what if no namespace prefix? */
-		/* Should we just pass them to server, except for
-		system and perhaps security prefixes? */
-	} else {
+	} else if (!strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto remove_ea_exit;
 
@@ -78,6 +70,22 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
 				full_path, ea_name, NULL, (__u16)0,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
+	} else if (!strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+			goto remove_ea_exit;
+
+		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
+		if (pTcon->ses->server->ops->set_EA)
+			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
+				full_path, ea_name, NULL, (__u16)0,
+				cifs_sb->local_nls, cifs_remap(cifs_sb));
+	} else {
+		cifs_dbg(FYI,
+			 "illegal xattr request %s (only user namespace supported)\n",
+			 ea_name);
+		/* BB what if no namespace prefix? */
+		/* Should we just pass them to server, except for
+		system and perhaps security prefixes? */
 	}
 remove_ea_exit:
 	kfree(full_path);
-- 
2.4.11
