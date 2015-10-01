From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] [SMB3] Enable checking for continuous availability and persistent handle support
Date: Thu,  1 Oct 2015 11:11:58 -0500
Message-ID: <1443715918-27384-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Updated version of patch to correct debug line and reset use_persistent
every time we reconnect the share.

Validate "persistenthandles" and "nopersistenthandles" mount options against
the support the server claims in negotiate and tree connect SMB3 responses.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/connect.c  | 30 ++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c  |  6 +++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 221ccfa..51353bb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -901,6 +901,7 @@ struct cifs_tcon {
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool broken_sparse_sup; /* if server or share does not support sparse */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool use_persistent:1; /* use persistent instead of durable handles */
 #ifdef CONFIG_CIFS_SMB2
 	bool print:1;		/* set if connection to printer share */
 	bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a16f2f0..f3512d4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2673,6 +2673,30 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		cifs_dbg(FYI, "DFS disabled (%d)\n", tcon->Flags);
 	}
 	tcon->seal = volume_info->seal;
+	tcon->use_persistent = false;
+	/* check if SMB2 or later, CIFS does not support persistent handles */
+	if (volume_info->persistent) {
+		if (ses->server->vals->protocol_id == 0) {
+			cifs_dbg(VFS,
+			     "SMB3 or later required for persistent handles\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+		} else if (ses->server->capabilities &
+			   SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
+			tcon->use_persistent = true;
+		else /* persistent handles requested but not supported */ {
+			cifs_dbg(VFS,
+				"Persistent handles not supported on share\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+		}
+	} else if ((tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
+	     && (ses->server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
+	     && (volume_info->nopersistent == false)) {
+		cifs_dbg(FYI, "enabling persistent handles\n");
+		tcon->use_persistent = true;
+	}
+
 	/*
 	 * We can have only one retry value for a connection to a share so for
 	 * resources mounted more than once to the same server share the last
@@ -3521,6 +3545,12 @@ try_mount_again:
 		goto mount_fail_check;
 	}
 
+	if ((volume_info->persistent == true) && ((ses->server->capabilities &
+		SMB2_GLOBAL_CAP_PERSISTENT_HANDLES) == 0)) {
+		cifs_dbg(VFS, "persistent handles not supported by server\n");
+		rc = -EOPNOTSUPP;
+		goto mount_fail_check;
+	}
 	/* search for existing tcon to this server share */
 	tcon = cifs_get_tcon(ses, volume_info);
 	if (IS_ERR(tcon)) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d41fb56..ddc7cef 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1845,7 +1845,7 @@ struct smb_version_values smb21_values = {
 struct smb_version_values smb30_values = {
 	.version_string = SMB30_VERSION_STRING,
 	.protocol_id = SMB30_PROT_ID,
-	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_ENCRYPTION,
+	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_ENCRYPTION | SMB2_GLOBAL_CAP_PERSISTENT_HANDLES,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
@@ -1865,7 +1865,7 @@ struct smb_version_values smb30_values = {
 struct smb_version_values smb302_values = {
 	.version_string = SMB302_VERSION_STRING,
 	.protocol_id = SMB302_PROT_ID,
-	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_PERSISTENT_HANDLES,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
@@ -1886,7 +1886,7 @@ struct smb_version_values smb302_values = {
 struct smb_version_values smb311_values = {
 	.version_string = SMB311_VERSION_STRING,
 	.protocol_id = SMB311_PROT_ID,
-	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING | SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_PERSISTENT_HANDLES,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
-- 
1.9.1
