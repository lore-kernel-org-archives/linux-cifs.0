From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] cifs: clean up cifs_find_smb_ses
Date: Sun, 20 Jun 2010 17:10:49 -0400
Message-ID: <1277068251-16344-5-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Do a better job of matching sessions by authtype. Matching by username
for a Kerberos session is incorrect, and anonymous sessions need
special handling.

Also, in the case where we do match by username, we also need to match
by password. That ensures that someone else doesn't "borrow" an existing
session without needing to know the password.

Finally, passwords can be longer than 16 bytes. Bump MAX_PASSWORD_SIZE
to 128 to match the size that the userspace mount helper allows.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/connect.c  |   26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1cb7c32..b24dc98 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -34,7 +34,7 @@
 #define MAX_SHARE_SIZE  64	/* used to be 20, this should still be enough */
 #define MAX_USERNAME_SIZE 32	/* 32 is to allow for 15 char names + null
 				   termination then *2 for unicode versions */
-#define MAX_PASSWORD_SIZE 16
+#define MAX_PASSWORD_SIZE 128
 
 #define CIFS_MIN_RCV_POOL 4
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6440b79..58e0217 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1639,17 +1639,27 @@ out_err:
 }
 
 static struct cifsSesInfo *
-cifs_find_smb_ses(struct TCP_Server_Info *server, char *username)
+cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
-	struct list_head *tmp;
 	struct cifsSesInfo *ses;
 
 	write_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
-		if (strncmp(ses->userName, username, MAX_USERNAME_SIZE))
-			continue;
-
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		switch (server->secType) {
+		case Kerberos:
+			if (vol->linux_uid != ses->linux_uid)
+				continue;
+			break;
+		default:
+			/* anything else takes username/password */
+			if (strncmp(ses->userName, vol->username,
+				    MAX_USERNAME_SIZE))
+				continue;
+			if (strlen(vol->username) != 0 &&
+			    strncmp(ses->password, vol->password,
+				    MAX_PASSWORD_SIZE))
+				continue;
+		}
 		++ses->ses_count;
 		write_unlock(&cifs_tcp_ses_lock);
 		return ses;
@@ -1691,7 +1701,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 
 	xid = GetXid();
 
-	ses = cifs_find_smb_ses(server, volume_info->username);
+	ses = cifs_find_smb_ses(server, volume_info);
 	if (ses) {
 		cFYI(1, "Existing smb sess found (status=%d)", ses->status);
 
-- 
1.6.6.1
