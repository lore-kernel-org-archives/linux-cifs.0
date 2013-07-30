From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: display iocharset= option in /proc/mounts
Date: Tue, 30 Jul 2013 13:34:40 -0400
Message-ID: <1375205680-24417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...but only if it's not the default charset.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 85ea98d..d70e551f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -357,6 +357,18 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 		seq_printf(s, "loose");
 }
 
+static void
+cifs_show_nls(struct seq_file *s, struct nls_table *cur)
+{
+	struct nls_table *def;
+
+	/* Display iocharset= option if it's not default charset */
+	def = load_nls_default();
+	if (def != cur)
+		seq_printf(s, ",iocharset=%s", cur->charset);
+	unload_nls(def);
+}
+
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -418,6 +430,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",file_mode=0%ho,dir_mode=0%ho",
 					   cifs_sb->mnt_file_mode,
 					   cifs_sb->mnt_dir_mode);
+
+	cifs_show_nls(s, cifs_sb->local_nls);
+
 	if (tcon->seal)
 		seq_printf(s, ",seal");
 	if (tcon->nocase)
-- 
1.8.3.1
