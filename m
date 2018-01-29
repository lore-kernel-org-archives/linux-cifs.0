From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] CIFS: zero sensitive data when freeing
Date: Sun, 28 Jan 2018 20:37:51 -0500 (EST)
Message-ID: <1615635177.2575940.1517189871581.JavaMail.zimbra@redhat.com>
References: <20180125145939.1021-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125145939.1021-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

----- Original Message -----
From: "Aurelien Aptel" <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Aurelien Aptel" <aaptel-IBi9RG/b67k@public.gmane.org>
Sent: Friday, 26 January, 2018 1:59:39 AM
Subject: [PATCH 1/1] CIFS: zero sensitive data when freeing

also replaces memset()+kfree() by kzfree().

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  3 +--
 fs/cifs/connect.c     |  6 +++---
 fs/cifs/misc.c        | 14 ++++----------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 68abbb0db608..f2b0a7f124da 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -325,9 +325,8 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 {
 	int i;
 	int rc;
-	char password_with_pad[CIFS_ENCPWD_SIZE];
+	char password_with_pad[CIFS_ENCPWD_SIZE] = {0};
 
-	memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
 	if (password)
 		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8b5e401f547a..ee2ab86bff5b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1720,7 +1720,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			tmp_end++;
 			if (!(tmp_end < end && tmp_end[1] == delim)) {
 				/* No it is not. Set the password to NULL */
-				kfree(vol->password);
+				kzfree(vol->password);
 				vol->password = NULL;
 				break;
 			}
@@ -1758,7 +1758,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 					options = end;
 			}
 
-			kfree(vol->password);
+			kzfree(vol->password);
 			/* Now build new password string */
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
@@ -4356,7 +4356,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
 out:
 	kfree(vol_info->username);
-	kfree(vol_info->password);
+	kzfree(vol_info->password);
 	kfree(vol_info);
 
 	return tcon;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index eea93ac15ef0..a0dbced4a45c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -98,14 +98,11 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free->user_name);
 	kfree(buf_to_free->domainName);
-	kfree(buf_to_free->auth_key.response);
-	kfree(buf_to_free);
+	kzfree(buf_to_free->auth_key.response);
+	kzfree(buf_to_free);
 }
 
 struct cifs_tcon *
@@ -136,10 +133,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
 	}
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free);
 }
 
-- 
2.12.3

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
