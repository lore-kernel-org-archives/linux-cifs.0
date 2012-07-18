From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 42/45] CIFS: Move oplock break to ops struct
Date: Wed, 18 Jul 2012 19:48:58 +0400
Message-ID: <1342626541-29872-43-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    4 ++++
 fs/cifs/file.c     |    7 +++----
 fs/cifs/smb1ops.c  |   10 ++++++++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 133cd0c..a8f424f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -178,6 +178,7 @@ struct cifs_readdata;
 struct cifs_writedata;
 struct cifs_io_parms;
 struct cifs_search_info;
+struct cifsInodeInfo;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -329,6 +330,9 @@ struct smb_version_operations {
 	/* calculate a size of SMB message */
 	unsigned int (*calc_smb_size)(void *);
 	bool (*is_status_pending)(char *, struct TCP_Server_Info *, int);
+	/* send oplock break response */
+	int (*oplock_response)(struct cifs_tcon *, struct cifs_fid *,
+			       struct cifsInodeInfo *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index da9dc50..40230a7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3395,6 +3395,7 @@ void cifs_oplock_break(struct work_struct *work)
 						  oplock_break);
 	struct inode *inode = cfile->dentry->d_inode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 
 	if (inode && S_ISREG(inode->i_mode)) {
@@ -3422,10 +3423,8 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->fid.netfid,
-				 current->tgid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false,
-				 cinode->clientCanCacheRead ? 1 : 0);
+		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
+							     cinode);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
 }
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 068d609..f55b2e3 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -863,6 +863,15 @@ cifs_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 	return CIFSFindClose(xid, tcon, fid->netfid);
 }
 
+static int
+cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
+		     struct cifsInodeInfo *cinode)
+{
+	return CIFSSMBLock(0, tcon, fid->netfid, current->tgid, 0, 0, 0, 0,
+			   LOCKING_ANDX_OPLOCK_RELEASE, false,
+			   cinode->clientCanCacheRead ? 1 : 0);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -922,6 +931,7 @@ struct smb_version_operations smb1_operations = {
 	.query_dir_next = cifs_query_dir_next,
 	.close_dir = cifs_close_dir,
 	.calc_smb_size = smbCalcSize,
+	.oplock_response = cifs_oplock_response,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
