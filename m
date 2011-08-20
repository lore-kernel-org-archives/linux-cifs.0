From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: get rid of unused xid in cifs_get_root
Date: Fri, 19 Aug 2011 21:19:49 -0400
Message-ID: <1313803189-32063-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f93eb94..eac8e087 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -530,7 +530,6 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *full_path = NULL;
 	char *s, *p;
 	char sep;
-	int xid;
 
 	full_path = cifs_build_path_to_root(vol, cifs_sb,
 					    cifs_sb_master_tcon(cifs_sb));
@@ -539,7 +538,6 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 
 	cFYI(1, "Get root dentry for %s", full_path);
 
-	xid = GetXid();
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
 	p = s = full_path;
@@ -568,7 +566,6 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 			dentry = ERR_PTR(-ENOENT);
 		}
 	} while (!IS_ERR(dentry));
-	_FreeXid(xid);
 	kfree(full_path);
 	return dentry;
 }
-- 
1.7.6
