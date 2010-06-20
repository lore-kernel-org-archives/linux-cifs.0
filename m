From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] cifs: remove unused cifsUidInfo struct
Date: Sun, 20 Jun 2010 17:10:50 -0400
Message-ID: <1277068251-16344-6-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b24dc98..415703b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -192,28 +192,12 @@ struct TCP_Server_Info {
 };
 
 /*
- * The following is our shortcut to user information.  We surface the uid,
- * and name. We always get the password on the fly in case it
- * has changed. We also hang a list of sessions owned by this user off here.
- */
-struct cifsUidInfo {
-	struct list_head userList;
-	struct list_head sessionList; /* SMB sessions for this user */
-	uid_t linux_uid;
-	char user[MAX_USERNAME_SIZE + 1];	/* ascii name of user */
-	/* BB may need ptr or callback for PAM or WinBind info */
-};
-
-/*
  * Session structure.  One of these for each uid session with a particular host
  */
 struct cifsSesInfo {
 	struct list_head smb_ses_list;
 	struct list_head tcon_list;
 	struct mutex session_mutex;
-#if 0
-	struct cifsUidInfo *uidInfo;	/* pointer to user info */
-#endif
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
 	enum statusEnum status;
-- 
1.6.6.1
