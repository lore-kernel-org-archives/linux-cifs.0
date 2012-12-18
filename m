From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't present the cifsFYI procfile when CONFIG_CIFS_DEBUG is disabled
Date: Tue, 18 Dec 2012 06:48:59 -0500
Message-ID: <1355831339-22043-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If all of the debug messages are compiled out, then this knob is no
longer connected to anything useful. There's no point in presenting
it at all in that case.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d9ea6ed..f5de4c9 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -371,7 +371,11 @@ static const struct file_operations cifs_stats_proc_fops = {
 #endif /* STATS */
 
 static struct proc_dir_entry *proc_fs_cifs;
+
+#ifdef CONFIG_CIFS_DEBUG
 static const struct file_operations cifsFYI_proc_fops;
+#endif /* CONFIG_CIFS_DEBUG */
+
 static const struct file_operations cifs_lookup_cache_proc_fops;
 static const struct file_operations traceSMB_proc_fops;
 static const struct file_operations cifs_security_flags_proc_fops;
@@ -389,7 +393,9 @@ cifs_proc_init(void)
 #ifdef CONFIG_CIFS_STATS
 	proc_create("Stats", 0, proc_fs_cifs, &cifs_stats_proc_fops);
 #endif /* STATS */
+#ifdef CONFIG_CIFS_DEBUG
 	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
+#endif /* CONFIG_CIFS_DEBUG */
 	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
 	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
 		    &cifs_linux_ext_proc_fops);
@@ -406,7 +412,9 @@ cifs_proc_clean(void)
 		return;
 
 	remove_proc_entry("DebugData", proc_fs_cifs);
+#ifdef CONFIG_CIFS_DEBUG
 	remove_proc_entry("cifsFYI", proc_fs_cifs);
+#endif /* CONFIG_CIFS_DEBUG */
 	remove_proc_entry("traceSMB", proc_fs_cifs);
 #ifdef CONFIG_CIFS_STATS
 	remove_proc_entry("Stats", proc_fs_cifs);
@@ -417,6 +425,7 @@ cifs_proc_clean(void)
 	remove_proc_entry("fs/cifs", NULL);
 }
 
+#ifdef CONFIG_CIFS_DEBUG
 static int cifsFYI_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%d\n", cifsFYI);
@@ -455,6 +464,7 @@ static const struct file_operations cifsFYI_proc_fops = {
 	.release	= single_release,
 	.write		= cifsFYI_proc_write,
 };
+#endif /* CONFIG_CIFS_DEBUG */
 
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
 {
-- 
1.7.11.7
