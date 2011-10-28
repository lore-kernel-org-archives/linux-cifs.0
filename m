From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 16/53] CIFS: Get mount/umount work with SMB2 protocol
Date: Fri, 28 Oct 2011 23:54:27 +0400
Message-ID: <1319831704-3572-17-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

Process SMB2 session setup, tree connect, getting inode info,
tree disconnect and logoff messages.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
---
 fs/cifs/connect.c  |  107 ++++++++++++++++++++++++++++++++----------
 fs/cifs/inode.c    |  132 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2sess.c |    2 +
 3 files changed, 194 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccb7ea7..0187f11 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -99,6 +99,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
+#ifdef CONFIG_CIFS_SMB2
+	server->max_read = 0;
+#endif
 
 	cFYI(1, "Reconnecting tcp session");
 
@@ -313,7 +316,13 @@ cifs_echo_request(struct work_struct *work)
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-	rc = CIFSSMBEcho(server);
+	if (server->is_smb2 == false)
+		rc = CIFSSMBEcho(server);
+#ifdef CONFIG_CIFS_SMB2
+	else /*temporarilly disable echo requests for smb2
+		rc = SMB2_echo(server); */
+		rc = 0;
+#endif
 	if (rc)
 		cFYI(1, "Unable to send echo request to server: %s",
 			server->hostname);
@@ -2151,7 +2160,12 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 	if (ses->status == CifsGood) {
 		xid = GetXid();
-		CIFSSMBLogoff(xid, ses);
+#ifdef CONFIG_CIFS_SMB2
+		if (ses->server->is_smb2)
+			SMB2_logoff(xid, ses);
+		else
+#endif
+			CIFSSMBLogoff(xid, ses);
 		_FreeXid(xid);
 	}
 	sesInfoFree(ses);
@@ -2312,7 +2326,12 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	xid = GetXid();
-	CIFSSMBTDis(xid, tcon);
+#ifdef CONFIG_CIFS_SMB2
+	if (ses->server->is_smb2)
+		SMB2_tdis(xid, tcon);
+	else
+#endif
+		CIFSSMBTDis(xid, tcon);
 	_FreeXid(xid);
 
 	cifs_fscache_release_super_cookie(tcon);
@@ -2323,7 +2342,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 static struct cifs_tcon *
 cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 {
-	int rc, xid;
+	int rc = 0, xid;
 	struct cifs_tcon *tcon;
 
 	tcon = cifs_find_tcon(ses, volume_info->UNC);
@@ -2363,7 +2382,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	 * this TCon call and Unix SetFS as
 	 * we do on SessSetup and reconnect? */
 	xid = GetXid();
-	rc = CIFSTCon(xid, ses, volume_info->UNC, tcon, volume_info->local_nls);
+#ifdef CONFIG_CIFS_SMB2
+	if (ses->server->is_smb2)
+		rc = SMB2_tcon(xid, ses, volume_info->UNC, tcon,
+			       volume_info->local_nls);
+	else
+#endif
+		rc = CIFSTCon(xid, ses, volume_info->UNC, tcon,
+			      volume_info->local_nls);
 	FreeXid(xid);
 	cFYI(1, "CIFS Tcon rc = %d", rc);
 	if (rc)
@@ -2518,6 +2544,12 @@ get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
 	char *temp_unc;
 	int rc = 0;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (pSesInfo->server->is_smb2) {
+		/* add missing smb2 dfs code here */
+		return -EREMOTE;
+	}
+#endif
 	*pnum_referrals = 0;
 	*preferrals = NULL;
 
@@ -3116,22 +3148,38 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
 {
 	int rc;
-	FILE_ALL_INFO *pfile_info;
-
-	pfile_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (pfile_info == NULL)
-		return -ENOMEM;
 
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, pfile_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2) {
+		__u64 persistent_fid, volatile_fid;
+		rc = SMB2_open(xid, tcon, (__le16 *)full_path, &persistent_fid,
+			       &volatile_fid, FILE_READ_ATTRIBUTES, FILE_OPEN,
+			       0, 0);
+		if (rc)
+			return rc;
+		/* rc = SMB2_query_info() */
+		rc = SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	} else {
+#endif
+		FILE_ALL_INFO *pfile_info = kmalloc(sizeof(FILE_ALL_INFO),
+						     GFP_KERNEL);
+		if (pfile_info == NULL)
+			return -ENOMEM;
 
-	if (rc == -EOPNOTSUPP || rc == -EINVAL)
-		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
-	kfree(pfile_info);
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, pfile_info,
+				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+		if (rc == -EOPNOTSUPP || rc == -EINVAL)
+			rc = SMBQueryInformation(xid, tcon, full_path,
+					pfile_info, cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+		kfree(pfile_info);
+#ifdef CONFIG_CIFS_SMB2
+	}
+#endif
 	return rc;
 }
 
@@ -3397,10 +3445,18 @@ try_mount_again:
 		tcon->unix_ext = 0; /* server does not support them */
 
 	/* do not care if following two calls succeed - informational */
-	if (!tcon->ipc) {
-		CIFSSMBQFSDeviceInfo(xid, tcon);
-		CIFSSMBQFSAttributeInfo(xid, tcon);
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2) {
+		/* add missing calls here */
+	} else {
+#endif
+		if (!tcon->ipc) {
+			CIFSSMBQFSDeviceInfo(xid, tcon);
+			CIFSSMBQFSAttributeInfo(xid, tcon);
+		}
+#ifdef CONFIG_CIFS_SMB2
 	}
+#endif
 
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
 	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
@@ -3718,6 +3774,7 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (ses->server->is_smb2) {
 		/* we have one credit to start with */
 		atomic_set(&server->credits, 1);
+		server->current_smb2_mid = 0;
 		rc = SMB2_negotiate(xid, ses);
 		/* BB we probably don't need to retry with modern servers */
 		if (rc == -EAGAIN)
@@ -3766,12 +3823,12 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
-	if (ses->server->is_smb2 == false)
-		rc = CIFS_SessSetup(xid, ses, nls_info);
 #ifdef CONFIG_CIFS_SMB2
-	else
+	if (ses->server->is_smb2)
 		rc = SMB2_sess_setup(xid, ses, nls_info);
+	else
 #endif
+		rc = CIFS_SessSetup(xid, ses, nls_info);
 	if (rc) {
 		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2c50bd2..4d03038 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -29,8 +29,11 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
 #include "fscache.h"
-
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 static void cifs_set_ops(struct inode *inode)
 {
@@ -595,9 +598,68 @@ cgfi_exit:
 	return rc;
 }
 
-int cifs_get_inode_info(struct inode **pinode,
-	const unsigned char *full_path, FILE_ALL_INFO *pfindData,
-	struct super_block *sb, int xid, const __u16 *pfid)
+#ifdef CONFIG_CIFS_SMB2
+static void
+move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src)
+{
+	memcpy(dst, src,
+	       (unsigned int)(&src->CurrentByteOffset) - (unsigned int)src);
+	dst->CurrentByteOffset = src->CurrentByteOffset;
+	dst->Mode = src->Mode;
+	dst->AlignmentRequirement = src->AlignmentRequirement;
+	dst->IndexNumber1 = 0; /* we don't use it */
+}
+
+static int
+smb2_qinfo_helper(int xid, struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
+		  const unsigned char *full_path, FILE_ALL_INFO *pfindData)
+{
+	const unsigned char *start_full_path = full_path;
+	__u64 persistent_fid, volatile_fid;
+	FILE_ALL_INFO_SMB2 *data = NULL;
+	__le16 *path = NULL;
+	int usc_len, rc;
+
+	data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2, GFP_KERNEL);
+	if (data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (strlen(full_path) && full_path[0] == '\\')
+		start_full_path += 1;
+
+	path = smb2_strndup_to_ucs(start_full_path,
+				   PATH_MAX, &usc_len,
+				   cifs_sb->local_nls);
+	if (path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = SMB2_open(xid, tcon, path, &persistent_fid, &volatile_fid,
+		       FILE_READ_ATTRIBUTES_LE, FILE_OPEN_LE, 0, 0);
+	if (!rc) {
+		rc = SMB2_query_info(xid, tcon, persistent_fid,
+				     volatile_fid, data);
+		SMB2_close(xid, tcon, persistent_fid,
+			   volatile_fid);
+	}
+
+	if (rc)
+		goto out;
+
+	move_smb2_info_to_cifs(pfindData, data);
+out:
+	kfree(data);
+	kfree(path);
+	return rc;
+}
+#endif
+
+int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
+			FILE_ALL_INFO *pfindData, struct super_block *sb,
+			int xid, const __u16 *pfid)
 {
 	int rc = 0, tmprc;
 	struct cifs_tcon *pTcon;
@@ -630,21 +692,36 @@ int cifs_get_inode_info(struct inode **pinode,
 		}
 		pfindData = (FILE_ALL_INFO *)buf;
 
-		/* could do find first instead but this returns more info */
-		rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
-			      0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-		/* BB optimize code so we do not make the above call
-		when server claims no NT SMB support and the above call
-		failed at least once - set flag in tcon or mount */
-		if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
-			rc = SMBQueryInformation(xid, pTcon, full_path,
-					pfindData, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					  CIFS_MOUNT_MAP_SPECIAL_CHR);
-			adjustTZ = true;
+		if (pTcon->ses->server->is_smb2 == false) {
+			/*
+			 * Could do find first instead but this returns more
+			 * info.
+			 */
+			rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
+					      0 /* not legacy */,
+					      cifs_sb->local_nls,
+					      cifs_sb->mnt_cifs_flags &
+					      CIFS_MOUNT_MAP_SPECIAL_CHR);
+			/*
+			 * BB optimize code so we do not make the above call
+			 * when server claims no NT SMB support and the above
+			 * call failed at least once - set flag in tcon or
+			 * mount.
+			 */
+			if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
+				rc = SMBQueryInformation(xid, pTcon, full_path,
+						pfindData, cifs_sb->local_nls,
+						cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+				adjustTZ = true;
+			}
+#ifdef CONFIG_CIFS_SMB2
+		} else
+			rc = smb2_qinfo_helper(xid, cifs_sb, pTcon, full_path,
+					       pfindData);
+#else
 		}
+#endif
 	}
 
 	if (!rc) {
@@ -675,7 +752,8 @@ int cifs_get_inode_info(struct inode **pinode,
 	 * guaranteed unique?
 	 */
 	if (*pinode == NULL) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    pTcon->ses->server->is_smb2 == false) {
 			int rc1 = 0;
 
 			rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
@@ -754,12 +832,22 @@ char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	/* if no prefix path, simply set path to the root of share to "" */
 	if (pplen == 0) {
-		full_path = kmalloc(1, GFP_KERNEL);
-		if (full_path)
-			full_path[0] = 0;
+		int len = 1;
+#ifdef CONFIG_CIFS_SMB2
+		if (vol->use_smb2)
+			len = 2;
+#endif
+		full_path = kzalloc(len, GFP_KERNEL);
 		return full_path;
 	}
 
+#ifdef CONFIG_CIFS_SMB2
+	if (vol->use_smb2) {
+		cERROR(1, "prefixpath is not supported for smb2 now");
+		return NULL;
+	}
+#endif
+
 	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
diff --git a/fs/cifs/smb2sess.c b/fs/cifs/smb2sess.c
index 440fe0b..5e51eb4 100644
--- a/fs/cifs/smb2sess.c
+++ b/fs/cifs/smb2sess.c
@@ -39,10 +39,12 @@ int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
 	 */
 	if (server->max_read == 0) /* no need to send on reconnect */ {
 		atomic_set(&server->credits, 1);
+		server->current_smb2_mid = 0;
 		rc = SMB2_negotiate(xid, psesinfo);
 		if (rc == -EAGAIN) {
 			/* retry only once on 1st time connection */
 			atomic_set(&server->credits, 1);
+			server->current_smb2_mid = 0;
 			rc = SMB2_negotiate(xid, psesinfo);
 			if (rc == -EAGAIN)
 				rc = -EHOSTDOWN;
-- 
1.7.1

