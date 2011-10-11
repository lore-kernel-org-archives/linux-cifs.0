From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 15:06:43 +0530
Message-ID: <4E940E2B.4050705@suse.de>
Reply-To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thus spake Jeff Layton:

"Making that a module parm would allow you to set that parameter at boot
time without needing to add special startup scripts. IMO, all of the
procfile "switches" under /proc/fs/cifs should be module parms
instead."

This seems reasonable so this patch makes OplockEnabled a module
parameter and rename it to enable_oplocks to comply with the coding
conventions. This patch removes the proc file handling pertaining to
/proc/fs/cifs/OplockEnabled which would no longer be required if this
patch gets accepted.

This patch doesn't alter the default behavior (Oplocks enabled by
default). To disable oplocks when loading the module, use
 
   modprobe cifs enable_oplocks=0

Note:
(a) I'm little worried about eliminating an already known interace to
    enable/disable Oplocks. An update to README file mentioning this info
    is planned. Do we need to warn users before pulling it off? Any
    suggestions on how we could do this?
(b) Most of the /proc/fs/cifs switches could be converted to a module
    param for e.g. LookupCacheEnabled, LinuxExtensionsEnabled,
    MultiuserMount etc. I'll post further patches once this gets
    accepted.

Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   40 ----------------------------------------
 fs/cifs/cifsfs.c     |    4 +++-
 fs/cifs/cifsglob.h   |    4 +++-
 fs/cifs/dir.c        |    2 +-
 fs/cifs/file.c       |    4 ++--
 5 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 2fe3cf1..393b37b 100644
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
@@ -509,43 +506,6 @@ static const struct file_operations cifsFYI_proc_fops = {
 	.write		= cifsFYI_proc_write,
 };
 
-static int cifs_oplock_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%d\n", oplockEnabled);
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
-	rc = get_user(c, buffer);
-	if (rc)
-		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		oplockEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		oplockEnabled = 1;
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
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3e29899..37c2fbb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -52,7 +52,6 @@
 int cifsFYI = 0;
 int cifsERROR = 1;
 int traceSMB = 0;
-unsigned int oplockEnabled = 1;
 unsigned int linuxExtEnabled = 1;
 unsigned int lookupCacheEnabled = 1;
 unsigned int multiuser_mount = 0;
@@ -81,6 +80,9 @@ module_param(echo_retries, ushort, 0644);
 MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
 			       "reconnecting server. Default: 5. 0 means "
 			       "never reconnect.");
+unsigned int enable_oplocks = 1;
+module_param(enable_oplocks, bool, 0644);
+MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default: 1.");
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6255fa8..9c33727 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -922,7 +922,6 @@ GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
 				to be established on existing mount if we
 				have the uid/password or Kerberos credential
 				or equivalent for current user */
-GLOBAL_EXTERN unsigned int oplockEnabled;
 GLOBAL_EXTERN unsigned int lookupCacheEnabled;
 GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
@@ -936,6 +935,9 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 /* reconnect after this many failed echo attempts */
 GLOBAL_EXTERN unsigned short echo_retries;
 
+/* enable or disable oplocks */
+GLOBAL_EXTERN unsigned int enable_oplocks;
+
 GLOBAL_EXTERN struct rb_root uidtree;
 GLOBAL_EXTERN struct rb_root gidtree;
 GLOBAL_EXTERN spinlock_t siduidlock;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 81914df..4d83659 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -165,7 +165,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	}
 	tcon = tlink_tcon(tlink);
 
-	if (oplockEnabled)
+	if (enable_oplocks)
 		oplock = REQ_OPLOCK;
 
 	if (nd && (nd->flags & LOOKUP_OPEN))
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bb71471..41149a0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -369,7 +369,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
 		 inode, file->f_flags, full_path);
 
-	if (oplockEnabled)
+	if (enable_oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
@@ -493,7 +493,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
 		 inode, pCifsFile->f_flags, full_path);
 
-	if (oplockEnabled)
+	if (enable_oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
