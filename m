From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] cifs: replace /proc/fs/cifs/Experimental with a module parm
Date: Wed,  8 Dec 2010 10:03:45 -0500
Message-ID: <1291820625-20907-5-git-send-email-jlayton@redhat.com>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291820625-20907-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This flag currently only affects whether we allow "zero-copy" writes
with signing enabled. Typically we map pages in the pagecache directly
into the write request. If signing is enabled however and the contents
of the page change after the signature is calculated but before the
write is sent then the signature will be wrong. Servers typically
respond to this by closing down the socket.

Still, this can provide a performance benefit so the "Experimental" flag
was overloaded to allow this. That's really not a good place for this
option however since it's not clear what that flag does.

Move that flag instead to a new module parameter that better describes
its purpose. That's also better since it can be set at module insertion
time by configuring modprobe.d.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/README       |   16 ----------------
 fs/cifs/cifs_debug.c |   43 -------------------------------------------
 fs/cifs/cifsfs.c     |    6 ++++--
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/file.c       |    4 ++--
 5 files changed, 7 insertions(+), 64 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index 60a8ba5..309525a 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -680,22 +680,6 @@ LinuxExtensionsEnabled	If set to one then the client will attempt to
 			support and want to map the uid and gid fields 
 			to values supplied at mount (rather than the 
 			actual values, then set this to zero. (default 1)
-Experimental            When set to 1 used to enable certain experimental
-			features (currently enables multipage writes
-			when signing is enabled, the multipage write
-			performance enhancement was disabled when
-			signing turned on in case buffer was modified
-			just before it was sent, also this flag will
-			be used to use the new experimental directory change 
-			notification code).  When set to 2 enables
-			an additional experimental feature, "raw ntlmssp"
-			session establishment support (which allows
-			specifying "sec=ntlmssp" on mount). The Linux cifs
-			module will use ntlmv2 authentication encapsulated
-			in "raw ntlmssp" (not using SPNEGO) when
-			"sec=ntlmssp" is specified on mount.
-			This support also requires building cifs with
-			the CONFIG_CIFS_EXPERIMENTAL configuration flag.
 
 These experimental features and tracing can be enabled by changing flags in 
 /proc/fs/cifs (after the cifs module has been installed or built into the 
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 103ab8b..37f7534 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -425,7 +425,6 @@ static const struct file_operations cifs_lookup_cache_proc_fops;
 static const struct file_operations traceSMB_proc_fops;
 static const struct file_operations cifs_multiuser_mount_proc_fops;
 static const struct file_operations cifs_security_flags_proc_fops;
-static const struct file_operations cifs_experimental_proc_fops;
 static const struct file_operations cifs_linux_ext_proc_fops;
 
 void
@@ -443,8 +442,6 @@ cifs_proc_init(void)
 	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
 	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
 	proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_oplock_proc_fops);
-	proc_create("Experimental", 0, proc_fs_cifs,
-		    &cifs_experimental_proc_fops);
 	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
 		    &cifs_linux_ext_proc_fops);
 	proc_create("MultiuserMount", 0, proc_fs_cifs,
@@ -471,7 +468,6 @@ cifs_proc_clean(void)
 	remove_proc_entry("OplockEnabled", proc_fs_cifs);
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
-	remove_proc_entry("Experimental", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
 	remove_proc_entry("fs/cifs", NULL);
 }
@@ -552,45 +548,6 @@ static const struct file_operations cifs_oplock_proc_fops = {
 	.write		= cifs_oplock_proc_write,
 };
 
-static int cifs_experimental_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%d\n", experimEnabled);
-	return 0;
-}
-
-static int cifs_experimental_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cifs_experimental_proc_show, NULL);
-}
-
-static ssize_t cifs_experimental_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
-{
-	char c;
-	int rc;
-
-	rc = get_user(c, buffer);
-	if (rc)
-		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		experimEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		experimEnabled = 1;
-	else if (c == '2')
-		experimEnabled = 2;
-
-	return count;
-}
-
-static const struct file_operations cifs_experimental_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= cifs_experimental_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_experimental_proc_write,
-};
-
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%d\n", linuxExtEnabled);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 48582b7..1f5fec1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -53,7 +53,6 @@ int cifsFYI = 0;
 int cifsERROR = 1;
 int traceSMB = 0;
 unsigned int oplockEnabled = 1;
-unsigned int experimEnabled = 0;
 unsigned int linuxExtEnabled = 1;
 unsigned int lookupCacheEnabled = 1;
 unsigned int multiuser_mount = 0;
@@ -77,7 +76,10 @@ unsigned int cifs_max_pending = CIFS_MAX_REQ;
 module_param(cifs_max_pending, int, 0);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 50 Range: 2 to 256");
-
+bool sign_zero_copy = false;
+module_param(sign_zero_copy, bool, 0644);
+MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages on write with signing "
+				 "enabled. Default: N");
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 37fb246..cf0dfda 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -777,7 +777,6 @@ GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
 				have the uid/password or Kerberos credential
 				or equivalent for current user */
 GLOBAL_EXTERN unsigned int oplockEnabled;
-GLOBAL_EXTERN unsigned int experimEnabled;
 GLOBAL_EXTERN unsigned int lookupCacheEnabled;
 GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
@@ -787,6 +786,7 @@ GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
+GLOBAL_EXTERN bool sign_zero_copy; /* don't copy written pages with signing */
 
 void cifs_oplock_break(struct work_struct *work);
 void cifs_oplock_break_get(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5a28660..fe16f6d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1054,7 +1054,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 				if (rc != 0)
 					break;
 			}
-			if (experimEnabled || (pTcon->ses->server &&
+			if (sign_zero_copy || (pTcon->ses->server &&
 				((pTcon->ses->server->secMode &
 				(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 				== 0))) {
@@ -1319,7 +1319,7 @@ static int cifs_writepages(struct address_space *mapping,
 	}
 
 	tcon = tlink_tcon(open_file->tlink);
-	if (!experimEnabled && tcon->ses->server->secMode &
+	if (!sign_zero_copy && tcon->ses->server->secMode &
 			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		cifsFileInfo_put(open_file);
 		kfree(iov);
-- 
1.7.3.2
