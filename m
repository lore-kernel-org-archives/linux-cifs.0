From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/19] cifs: add new fields to cifs_ses to track requested security flavor
Date: Thu, 23 May 2013 11:05:58 -0400
Message-ID: <1369321563-16893-15-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently we have the overrideSecFlg field, but it's quite cumbersome
to work with. Add some new fields that will eventually supercede it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   | 11 +++++++----
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/connect.c  |  5 +++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index bb27269..97601fa 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -312,11 +312,14 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 }
 
 static void
-cifs_show_security(struct seq_file *s, struct TCP_Server_Info *server)
+cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 {
+	if (ses->sectype == Unspecified)
+		return;
+
 	seq_printf(s, ",sec=");
 
-	switch (server->secType) {
+	switch (ses->sectype) {
 	case LANMAN:
 		seq_printf(s, "lanman");
 		break;
@@ -338,7 +341,7 @@ cifs_show_security(struct seq_file *s, struct TCP_Server_Info *server)
 		break;
 	}
 
-	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+	if (ses->sign)
 		seq_printf(s, "i");
 }
 
@@ -369,7 +372,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
 	seq_printf(s, ",vers=%s", tcon->ses->server->vals->version_string);
-	cifs_show_security(s, tcon->ses->server);
+	cifs_show_security(s, tcon->ses);
 	cifs_show_cache_flavor(s, cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9f88a35..a911a33 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -713,6 +713,8 @@ struct cifs_ses {
 	char *password;
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
+	enum securityEnum sectype; /* what security flavor was specified? */
+	bool sign;		/* is signing required? */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 #ifdef CONFIG_CIFS_SMB2
 	__u16 session_flags;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b71961..072598f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2513,6 +2513,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->linux_uid = volume_info->linux_uid;
 
 	ses->overrideSecFlg = volume_info->secFlg;
+	ses->sectype = volume_info->sectype;
+	ses->sign = volume_info->sign ? volume_info->sign :
+				(global_secflags & CIFSSEC_MUST_SIGN);
 
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses);
@@ -3931,6 +3934,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->nocase = master_tcon->nocase;
 	vol_info->local_lease = master_tcon->local_lease;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
+	vol_info->sectype = master_tcon->ses->sectype;
+	vol_info->sign = master_tcon->ses->sign;
 
 	rc = cifs_set_vol_auth(vol_info, master_tcon->ses);
 	if (rc) {
-- 
1.8.1.4
