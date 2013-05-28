From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/19] cifs: remove the cifs_ses->flags field
Date: Tue, 28 May 2013 08:11:46 -0400
Message-ID: <1369743120-18941-6-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This field is completely unused:

CIFS_SES_W9X is completely unused. CIFS_SES_LANMAN and CIFS_SES_OS2
are set but never checked. CIFS_SES_NT4 is checked, but never set.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h | 10 ----------
 fs/cifs/connect.c  |  1 -
 fs/cifs/sess.c     |  7 +------
 fs/cifs/smb1ops.c  | 18 ++++++------------
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 29dd111..be993ec 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -692,7 +692,6 @@ struct cifs_ses {
 	enum statusEnum status;
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	__u16 ipc_tid;		/* special tid for connection to IPC share */
-	__u16 flags;
 	__u16 vcnum;
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
@@ -715,15 +714,6 @@ struct cifs_ses {
 #endif /* CONFIG_CIFS_SMB2 */
 };
 
-/* no more than one of the following three session flags may be set */
-#define CIFS_SES_NT4 1
-#define CIFS_SES_OS2 2
-#define CIFS_SES_W9X 4
-/* following flag is set for old servers such as OS2 (and Win95?)
-   which do not negotiate NTLM or POSIX dialects, but instead
-   negotiate one of the older LANMAN dialects */
-#define CIFS_SES_LANMAN 8
-
 static inline bool
 cap_unix(struct cifs_ses *ses)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c3a405a..118cc9c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3834,7 +3834,6 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	int rc = -ENOSYS;
 	struct TCP_Server_Info *server = ses->server;
 
-	ses->flags = 0;
 	ses->capabilities = server->capabilities;
 	if (linuxExtEnabled == 0)
 		ses->capabilities &= (~server->vals->cap_unix);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e8c5dc9..0d0fe38 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -328,10 +328,8 @@ static void decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	ses->serverOS = kzalloc(len + 1, GFP_KERNEL);
 	if (ses->serverOS)
 		strncpy(ses->serverOS, bcc_ptr, len);
-	if (strncmp(ses->serverOS, "OS/2", 4) == 0) {
+	if (strncmp(ses->serverOS, "OS/2", 4) == 0)
 		cifs_dbg(FYI, "OS/2 server\n");
-			ses->flags |= CIFS_SES_OS2;
-	}
 
 	bcc_ptr += len + 1;
 	bleft -= len + 1;
@@ -642,8 +640,6 @@ ssetup_ntlmssp_authenticate:
 	}
 	bcc_ptr = str_area;
 
-	ses->flags &= ~CIFS_SES_LANMAN;
-
 	iov[1].iov_base = NULL;
 	iov[1].iov_len = 0;
 
@@ -667,7 +663,6 @@ ssetup_ntlmssp_authenticate:
 				 ses->server->sec_mode & SECMODE_PW_ENCRYPT ?
 					true : false, lnm_session_key);
 
-		ses->flags |= CIFS_SES_LANMAN;
 		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3efdb9d..7d1c78b 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -765,20 +765,14 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	}
 	tcon = tlink_tcon(tlink);
 
-	/*
-	 * NT4 apparently returns success on this call, but it doesn't really
-	 * work.
-	 */
-	if (!(tcon->ses->flags & CIFS_SES_NT4)) {
-		rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf,
-					cifs_sb->local_nls,
+	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (rc == 0) {
-			cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
-			goto out;
-		} else if (rc != -EOPNOTSUPP && rc != -EINVAL)
-			goto out;
+	if (rc == 0) {
+		cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
+		goto out;
+	} else if (rc != -EOPNOTSUPP && rc != -EINVAL) {
+		goto out;
 	}
 
 	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not supported by this server\n");
-- 
1.8.1.4
