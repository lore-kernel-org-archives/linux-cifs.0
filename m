From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] [CIFS] Allow user names longer than 32 bytes
Date: Fri, 25 Feb 2011 12:24:17 -0600
Message-ID: <AANLkTimMxszw620jHORHYQ_jj-fhQiXUe=AiAFRAtMLU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit 355e57ca063338eb00ea067a7570bb5f136cc513
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Fri Feb 25 01:11:56 2011 -0600

    [CIFS] Allow user names longer than 32 bytes

    We artificially limited the user name to 32 bytes, but modern servers handle
    larger.  Set the maximum length to a reasonable 256, and make the user name
    string dynamically allocated rather than a fixed size in session structure.
    Also clean up old checkpatch warning.

    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 4dfba82..33d2213 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -113,7 +113,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 		   MAX_MECH_STR_LEN +
 		   UID_KEY_LEN + (sizeof(uid_t) * 2) +
 		   CREDUID_KEY_LEN + (sizeof(uid_t) * 2) +
-		   USER_KEY_LEN + strlen(sesInfo->userName) +
+		   USER_KEY_LEN + strlen(sesInfo->user_name) +
 		   PID_KEY_LEN + (sizeof(pid_t) * 2) + 1;

 	spnego_key = ERR_PTR(-ENOMEM);
@@ -153,7 +153,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 	sprintf(dp, ";creduid=0x%x", sesInfo->cred_uid);

 	dp = description + strlen(description);
-	sprintf(dp, ";user=%s", sesInfo->userName);
+	sprintf(dp, ";user=%s", sesInfo->user_name);

 	dp = description + strlen(description);
 	sprintf(dp, ";pid=0x%x", current->pid);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index a51585f..e307a28 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -469,15 +469,15 @@ static int calc_ntlmv2_hash(struct cifsSesInfo
*ses, char *ntlmv2_hash,
 		return rc;
 	}

-	/* convert ses->userName to unicode and uppercase */
-	len = strlen(ses->userName);
+	/* convert ses->user_name to unicode and uppercase */
+	len = strlen(ses->user_name);
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
 		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
 		rc = -ENOMEM;
 		goto calc_exit_2;
 	}
-	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
+	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
 	UniStrupr(user);

 	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 191ef2f..827f9c8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -412,8 +412,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)

 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
 		seq_printf(s, ",multiuser");
-	else if (tcon->ses->userName)
-		seq_printf(s, ",username=%s", tcon->ses->userName);
+	else if (tcon->ses->user_name)
+		seq_printf(s, ",username=%s", tcon->ses->user_name);

 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=%s", tcon->ses->domainName);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a17a86c..293b636 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -38,9 +38,8 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE  64	/* used to be 20, this should still be enough */
-#define MAX_USERNAME_SIZE 32	/* 32 is to allow for 15 char names + null
-				   termination then *2 for unicode versions */
-#define MAX_PASSWORD_SIZE 512  /* max for windows seems to be 256 wide chars */
+#define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
+#define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */

 #define CIFS_MIN_RCV_POOL 4

@@ -285,7 +284,7 @@ struct cifsSesInfo {
 	int capabilities;
 	char serverName[SERVER_NAME_LEN_WITH_NULL * 2];	/* BB make bigger for
 				TCP names - will ipv6 and sctp addresses fit? */
-	char userName[MAX_USERNAME_SIZE + 1];
+	char *user_name;
 	char *domainName;
 	char *password;
 	struct session_key auth_key;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fe0fc61..6354ed5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -882,7 +882,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 				/* null user, ie anonymous, authentication */
 				vol->nullauth = 1;
 			}
-			if (strnlen(value, 200) < 200) {
+			if (strnlen(value, MAX_USERNAME_SIZE) <
+						MAX_USERNAME_SIZE) {
 				vol->username = value;
 			} else {
 				printk(KERN_WARNING "CIFS: username too long\n");
@@ -1825,7 +1826,9 @@ cifs_find_smb_ses(struct TCP_Server_Info
*server, struct smb_vol *vol)
 			break;
 		default:
 			/* anything else takes username/password */
-			if (strncmp(ses->userName, vol->username,
+			if (ses->user_name == NULL)
+				continue;
+			if (strncmp(ses->user_name, vol->username,
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
@@ -1923,9 +1926,11 @@ cifs_get_smb_ses(struct TCP_Server_Info
*server, struct smb_vol *volume_info)
 	else
 		sprintf(ses->serverName, "%pI4", &addr->sin_addr);

-	if (volume_info->username)
-		strncpy(ses->userName, volume_info->username,
-			MAX_USERNAME_SIZE);
+	if (volume_info->username) {
+		ses->user_name = kstrdup(volume_info->username, GFP_KERNEL);
+		if (!ses->user_name)
+			goto get_ses_fail;
+	}

 	/* volume_info->password freed at unmount */
 	if (volume_info->password) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b90a4d3..e9e6f29 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -100,6 +100,7 @@ sesInfoFree(struct cifsSesInfo *buf_to_free)
 		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
 		kfree(buf_to_free->password);
 	}
+	kfree(buf_to_free->user_name);
 	kfree(buf_to_free->domainName);
 	kfree(buf_to_free);
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index c13e1e4..145e1c3 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -219,12 +219,12 @@ static void unicode_ssetup_strings(char
**pbcc_area, struct cifsSesInfo *ses,
 		bcc_ptr++;
 	} */
 	/* copy user */
-	if (ses->userName == NULL) {
+	if (ses->user_name == NULL) {
 		/* null user mount */
 		*bcc_ptr = 0;
 		*(bcc_ptr+1) = 0;
 	} else {
-		bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, ses->userName,
+		bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, ses->user_name,
 					  MAX_USERNAME_SIZE, nls_cp);
 	}
 	bcc_ptr += 2 * bytes_ret;
@@ -244,12 +244,11 @@ static void ascii_ssetup_strings(char
**pbcc_area, struct cifsSesInfo *ses,
 	/* copy user */
 	/* BB what about null user mounts - check that we do this BB */
 	/* copy user */
-	if (ses->userName == NULL) {
-		/* BB what about null user mounts - check that we do this BB */
-	} else {
-		strncpy(bcc_ptr, ses->userName, MAX_USERNAME_SIZE);
-	}
-	bcc_ptr += strnlen(ses->userName, MAX_USERNAME_SIZE);
+	if (ses->user_name != NULL)
+		strncpy(bcc_ptr, ses->user_name, MAX_USERNAME_SIZE);
+	/* else null user mount */
+
+	bcc_ptr += strnlen(ses->user_name, MAX_USERNAME_SIZE);
 	*bcc_ptr = 0;
 	bcc_ptr++; /* account for null termination */

@@ -523,14 +522,14 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		tmp += len;
 	}

-	if (ses->userName == NULL) {
+	if (ses->user_name == NULL) {
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->UserName.Length = 0;
 		sec_blob->UserName.MaximumLength = 0;
 		tmp += 2;
 	} else {
 		int len;
-		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
+		len = cifs_strtoUCS((__le16 *)tmp, ses->user_name,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);

-- 
Thanks,

Steve
