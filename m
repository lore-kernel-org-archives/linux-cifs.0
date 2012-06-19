From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 19/22] CIFS: Move echo code to osp struct
Date: Tue, 19 Jun 2012 16:40:08 +0400
Message-ID: <1340109611-7210-20-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    4 ++++
 fs/cifs/connect.c  |   10 ++++++----
 fs/cifs/smb1ops.c  |    1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d027dbf..860549a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -230,6 +230,10 @@ struct smb_version_operations {
 			    struct cifs_fattr *, FILE_ALL_INFO *);
 	char * (*build_path_to_root)(struct smb_vol *, struct cifs_sb_info *,
 				     struct cifs_tcon *);
+	/* check if we can send an echo or nor */
+	bool (*can_echo)(struct TCP_Server_Info *);
+	/* send echo request */
+	int (*echo)(struct TCP_Server_Info *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b7816fd..4c919bc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -405,15 +405,17 @@ cifs_echo_request(struct work_struct *work)
 					struct TCP_Server_Info, echo.work);
 
 	/*
-	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is
-	 * done, which is indicated by maxBuf != 0. Also, no need to ping if
-	 * we got a response recently
+	 * We cannot send an echo if it is disabled or until the
+	 * NEGOTIATE_PROTOCOL request is done, which is indicated by
+	 * server->ops->need_neg() == true. Also, no need to ping if
+	 * we got a response recently.
 	 */
 	if (!server->ops->need_neg || server->ops->need_neg(server) ||
+	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-	rc = CIFSSMBEcho(server);
+	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
 	if (rc)
 		cFYI(1, "Unable to send echo request to server: %s",
 			server->hostname);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f4764c0..0bbe785 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -561,6 +561,7 @@ struct smb_version_operations smb1_operations = {
 	.query_path_info = cifs_query_path_info,
 	.get_srv_inum = cifs_get_srv_inum,
 	.build_path_to_root = cifs_build_path_to_root,
+	.echo = CIFSSMBEcho,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
