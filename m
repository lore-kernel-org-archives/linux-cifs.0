From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] cifs: display cache= option in /proc/mounts
Date: Fri, 27 Apr 2012 06:56:18 -0400
Message-ID: <1335524179-1671-4-git-send-email-jlayton@redhat.com>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335524179-1671-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and deprecate the display of strictcache, forcedirectio, and fsc
as separate options.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..646699e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -329,6 +329,21 @@ cifs_show_security(struct seq_file *s, struct TCP_Server_Info *server)
 		seq_printf(s, "i");
 }
 
+static void
+cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
+{
+	seq_printf(s, ",cache=");
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+		seq_printf(s, "fsc");
+	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		seq_printf(s, "strict");
+	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
+		seq_printf(s, "none");
+	else
+		seq_printf(s, "loose");
+}
+
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -343,6 +358,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
 	cifs_show_security(s, tcon->ses->server);
+	cifs_show_cache_flavor(s, cifs_sb);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
 
@@ -408,8 +424,6 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",rwpidforward");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
 		seq_printf(s, ",forcemand");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
-		seq_printf(s, ",directio");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 		seq_printf(s, ",nouser_xattr");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
@@ -426,14 +440,10 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",acl");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
 		seq_printf(s, ",mfsymlinks");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
-		seq_printf(s, ",fsc");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
 		seq_printf(s, ",nostrictsync");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
 		seq_printf(s, ",noperm");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
-		seq_printf(s, ",strictcache");
 
 	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
-- 
1.7.7.6
