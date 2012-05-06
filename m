From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove legacy MultiuserMount option
Date: Sun,  6 May 2012 07:52:02 -0400
Message-ID: <1336305122-26699-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've now warned about this for two releases. Remove it for 3.5.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   49 -------------------------------------------------
 fs/cifs/cifsfs.c     |    1 -
 fs/cifs/cifsglob.h   |    7 +------
 fs/cifs/misc.c       |   47 -----------------------------------------------
 4 files changed, 1 insertions(+), 103 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 2704646..ebae66b 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -420,7 +420,6 @@ static struct proc_dir_entry *proc_fs_cifs;
 static const struct file_operations cifsFYI_proc_fops;
 static const struct file_operations cifs_lookup_cache_proc_fops;
 static const struct file_operations traceSMB_proc_fops;
-static const struct file_operations cifs_multiuser_mount_proc_fops;
 static const struct file_operations cifs_security_flags_proc_fops;
 static const struct file_operations cifs_linux_ext_proc_fops;
 
@@ -440,8 +439,6 @@ cifs_proc_init(void)
 	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
 	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
 		    &cifs_linux_ext_proc_fops);
-	proc_create("MultiuserMount", 0, proc_fs_cifs,
-		    &cifs_multiuser_mount_proc_fops);
 	proc_create("SecurityFlags", 0, proc_fs_cifs,
 		    &cifs_security_flags_proc_fops);
 	proc_create("LookupCacheEnabled", 0, proc_fs_cifs,
@@ -617,52 +614,6 @@ static const struct file_operations traceSMB_proc_fops = {
 	.write		= traceSMB_proc_write,
 };
 
-static int cifs_multiuser_mount_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%d\n", multiuser_mount);
-	return 0;
-}
-
-static int cifs_multiuser_mount_proc_open(struct inode *inode, struct file *fh)
-{
-	return single_open(fh, cifs_multiuser_mount_proc_show, NULL);
-}
-
-static ssize_t cifs_multiuser_mount_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
-{
-	char c;
-	int rc;
-	static bool warned;
-
-	rc = get_user(c, buffer);
-	if (rc)
-		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		multiuser_mount = 0;
-	else if (c == '1' || c == 'y' || c == 'Y') {
-		multiuser_mount = 1;
-		if (!warned) {
-			warned = true;
-			printk(KERN_WARNING "CIFS VFS: The legacy multiuser "
-				"mount code is scheduled to be deprecated in "
-				"3.5. Please switch to using the multiuser "
-				"mount option.");
-		}
-	}
-
-	return count;
-}
-
-static const struct file_operations cifs_multiuser_mount_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= cifs_multiuser_mount_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_multiuser_mount_proc_write,
-};
-
 static int cifs_security_flags_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "0x%x\n", global_secflags);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ca6a379..858a355 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -56,7 +56,6 @@ int traceSMB = 0;
 bool enable_oplocks = true;
 unsigned int linuxExtEnabled = 1;
 unsigned int lookupCacheEnabled = 1;
-unsigned int multiuser_mount = 0;
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4ff6313..a867d99 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1042,12 +1042,7 @@ GLOBAL_EXTERN atomic_t smBufAllocCount;
 GLOBAL_EXTERN atomic_t midCount;
 
 /* Misc globals */
-GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
-				to be established on existing mount if we
-				have the uid/password or Kerberos credential
-				or equivalent for current user */
-/* enable or disable oplocks */
-GLOBAL_EXTERN bool enable_oplocks;
+GLOBAL_EXTERN bool enable_oplocks; /* enable or disable oplocks */
 GLOBAL_EXTERN unsigned int lookupCacheEnabled;
 GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c29d1aa..d2bb1e7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -306,8 +306,6 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		const struct cifs_tcon *treeCon, int word_count
 		/* length of fixed section (word count) in two byte units  */)
 {
-	struct list_head *temp_item;
-	struct cifs_ses *ses;
 	char *temp = (char *) buffer;
 
 	memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_SIZE */
@@ -337,51 +335,6 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 			/* Uid is not converted */
 			buffer->Uid = treeCon->ses->Suid;
 			buffer->Mid = GetNextMid(treeCon->ses->server);
-			if (multiuser_mount != 0) {
-		/* For the multiuser case, there are few obvious technically  */
-		/* possible mechanisms to match the local linux user (uid)    */
-		/* to a valid remote smb user (smb_uid):		      */
-		/* 	1) Query Winbind (or other local pam/nss daemon       */
-		/* 	  for userid/password/logon_domain or credential      */
-		/*      2) Query Winbind for uid to sid to username mapping   */
-		/* 	   and see if we have a matching password for existing*/
-		/*         session for that user perhas getting password by   */
-		/*         adding a new pam_cifs module that stores passwords */
-		/*         so that the cifs vfs can get at that for all logged*/
-		/*	   on users					      */
-		/*	3) (Which is the mechanism we have chosen)	      */
-		/*	   Search through sessions to the same server for a   */
-		/*	   a match on the uid that was passed in on mount     */
-		/*         with the current processes uid (or euid?) and use  */
-		/* 	   that smb uid.   If no existing smb session for     */
-		/* 	   that uid found, use the default smb session ie     */
-		/*         the smb session for the volume mounted which is    */
-		/* 	   the same as would be used if the multiuser mount   */
-		/* 	   flag were disabled.  */
-
-		/*  BB Add support for establishing new tCon and SMB Session  */
-		/*      with userid/password pairs found on the smb session   */
-		/*	for other target tcp/ip addresses 		BB    */
-				if (current_fsuid() != treeCon->ses->linux_uid) {
-					cFYI(1, "Multiuser mode and UID "
-						 "did not match tcon uid");
-					spin_lock(&cifs_tcp_ses_lock);
-					list_for_each(temp_item, &treeCon->ses->server->smb_ses_list) {
-						ses = list_entry(temp_item, struct cifs_ses, smb_ses_list);
-						if (ses->linux_uid == current_fsuid()) {
-							if (ses->server == treeCon->ses->server) {
-								cFYI(1, "found matching uid substitute right smb_uid");
-								buffer->Uid = ses->Suid;
-								break;
-							} else {
-				/* BB eventually call cifs_setup_session here */
-								cFYI(1, "local UID found but no smb sess with this server exists");
-							}
-						}
-					}
-					spin_unlock(&cifs_tcp_ses_lock);
-				}
-			}
 		}
 		if (treeCon->Flags & SMB_SHARE_IS_IN_DFS)
 			buffer->Flags2 |= SMBFLG2_DFS;
-- 
1.7.7.6
