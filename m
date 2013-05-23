From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: stop printing the unc= option in /proc/mounts
Date: Wed, 22 May 2013 20:57:08 -0400
Message-ID: <1369270628-16631-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we no longer recognize that option, stop printing it out. The
devicename is now the canonical source for this info.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 72e4efe..3752b9f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -372,9 +372,6 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	cifs_show_security(s, tcon->ses->server);
 	cifs_show_cache_flavor(s, cifs_sb);
 
-	seq_printf(s, ",unc=");
-	seq_escape(s, tcon->treeName, " \t\n\\");
-
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
 		seq_printf(s, ",multiuser");
 	else if (tcon->ses->user_name)
-- 
1.8.1.4
