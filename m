From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove /proc/fs/cifs/OplockEnabled
Date: Thu, 22 Mar 2012 11:43:49 -0400
Message-ID: <1332431029-30335-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had a deprecation warning on this file for 2 releases now. Remove
it as promised for 3.4.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   43 -------------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 81be263..2704646 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -418,7 +418,6 @@ static const struct file_operations cifs_stats_proc_fops = {
 
 static struct proc_dir_entry *proc_fs_cifs;
 static const struct file_operations cifsFYI_proc_fops;
-static const struct file_operations cifs_oplock_proc_fops;
 static const struct file_operations cifs_lookup_cache_proc_fops;
 static const struct file_operations traceSMB_proc_fops;
 static const struct file_operations cifs_multiuser_mount_proc_fops;
@@ -439,7 +438,6 @@ cifs_proc_init(void)
 #endif /* STATS */
 	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
 	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
-	proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_oplock_proc_fops);
 	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
 		    &cifs_linux_ext_proc_fops);
 	proc_create("MultiuserMount", 0, proc_fs_cifs,
@@ -463,7 +461,6 @@ cifs_proc_clean(void)
 	remove_proc_entry("Stats", proc_fs_cifs);
 #endif
 	remove_proc_entry("MultiuserMount", proc_fs_cifs);
-	remove_proc_entry("OplockEnabled", proc_fs_cifs);
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
@@ -509,46 +506,6 @@ static const struct file_operations cifsFYI_proc_fops = {
 	.write		= cifsFYI_proc_write,
 };
 
-static int cifs_oplock_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%d\n", enable_oplocks);
-	return 0;
-}
-
-static int cifs_oplock_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cifs_oplock_proc_show, NULL);
-}
-
-static ssize_t cifs_oplock_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
-{
-	char c;
-	int rc;
-
-	printk(KERN_WARNING "CIFS: The /proc/fs/cifs/OplockEnabled interface "
-	       "will be removed in kernel version 3.4. Please migrate to "
-	       "using the 'enable_oplocks' module parameter in cifs.ko.\n");
-	rc = get_user(c, buffer);
-	if (rc)
-		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		enable_oplocks = false;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		enable_oplocks = true;
-
-	return count;
-}
-
-static const struct file_operations cifs_oplock_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= cifs_oplock_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_oplock_proc_write,
-};
-
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%d\n", linuxExtEnabled);
-- 
1.7.7.6
