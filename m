From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/4] cifs: display cache= option in /proc/mounts
Date: Wed, 16 May 2012 07:55:53 -0400
Message-ID: <1337169354-19045-4-git-send-email-jlayton@redhat.com>
References: <1337169354-19045-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337169354-19045-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and deprecate the display of strictcache and forcedirectio
as separate options.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c45f170..f718d57 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -328,6 +328,19 @@ cifs_show_security(struct seq_file *s, struct TCP_Server_Info *server)
 		seq_printf(s, "i");
 }
 
+static void
+cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
+{
+	seq_printf(s, ",cache=");
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
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
@@ -342,6 +355,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
 	cifs_show_security(s, tcon->ses->server);
+	cifs_show_cache_flavor(s, cifs_sb);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
 
@@ -407,8 +421,6 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",rwpidforward");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
 		seq_printf(s, ",forcemand");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
-		seq_printf(s, ",directio");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 		seq_printf(s, ",nouser_xattr");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
@@ -431,8 +443,6 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",nostrictsync");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
 		seq_printf(s, ",noperm");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
-		seq_printf(s, ",strictcache");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
 		seq_printf(s, ",backupuid=%u", cifs_sb->mnt_backupuid);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
-- 
1.7.7.6
