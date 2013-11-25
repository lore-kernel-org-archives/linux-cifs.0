From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] cifs: Rename and cleanup open_query_close_cifs_symlink()
Date: Mon, 25 Nov 2013 17:09:49 +0000
Message-ID: <1385399395-19217-3-git-send-email-sprabhu@redhat.com>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Rename open_query_close_cifs_symlink to cifs_query_mf_symlink() to make
the name more consistent with other protocol version specific functions.

We also pass tcon as an argument to the function. This is already
available in the calling functions and we can avoid having to make an
unnecessary lookup.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  5 +++--
 fs/cifs/cifsproto.h |  7 ++++---
 fs/cifs/link.c      | 37 ++++++++++++-------------------------
 fs/cifs/smb1ops.c   |  2 +-
 4 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d9ea7ad..e844515 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -370,8 +370,9 @@ struct smb_version_operations {
 	void (*new_lease_key)(struct cifs_fid *);
 	int (*generate_signingkey)(struct cifs_ses *);
 	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *);
-	int (*query_mf_symlink)(const unsigned char *, char *, unsigned int *,
-				struct cifs_sb_info *, unsigned int);
+	int (*query_mf_symlink)(unsigned int, struct cifs_tcon *,
+				struct cifs_sb_info *, const unsigned char *,
+				char *, unsigned int *);
 	/* if we can do cache read operations */
 	bool (*is_read_op)(__u32);
 	/* set oplock level for the inode */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2c29db6..10b9ab1 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -496,7 +496,8 @@ void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
 						work_func_t complete);
 void cifs_writedata_release(struct kref *refcount);
-int open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
-			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
-			unsigned int xid);
+int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+			  struct cifs_sb_info *cifs_sb,
+			  const unsigned char *path, char *pbuf,
+			  unsigned int *pbytes_read);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 92aee08..2a5837a 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -305,54 +305,41 @@ CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr)
 }
 
 int
-open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
-			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
-			unsigned int xid)
+cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
+		      struct cifs_sb_info *cifs_sb, const unsigned char *path,
+		      char *pbuf, unsigned int *pbytes_read)
 {
 	int rc;
 	int oplock = 0;
 	__u16 netfid = 0;
-	struct tcon_link *tlink;
-	struct cifs_tcon *ptcon;
 	struct cifs_io_parms io_parms;
 	int buf_type = CIFS_NO_BUFFER;
 	FILE_ALL_INFO file_info;
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-	ptcon = tlink_tcon(tlink);
-
-	rc = CIFSSMBOpen(xid, ptcon, path, FILE_OPEN, GENERIC_READ,
+	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, GENERIC_READ,
 			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
 			 cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc != 0) {
-		cifs_put_tlink(tlink);
+	if (rc)
 		return rc;
-	}
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
-		CIFSSMBClose(xid, ptcon, netfid);
-		cifs_put_tlink(tlink);
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE))
 		/* it's not a symlink */
-		return rc;
-	}
+		goto out;
 
 	io_parms.netfid = netfid;
 	io_parms.pid = current->tgid;
-	io_parms.tcon = ptcon;
+	io_parms.tcon = tcon;
 	io_parms.offset = 0;
 	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
 
 	rc = CIFSSMBRead(xid, &io_parms, pbytes_read, &pbuf, &buf_type);
-	CIFSSMBClose(xid, ptcon, netfid);
-	cifs_put_tlink(tlink);
+out:
+	CIFSSMBClose(xid, tcon, netfid);
 	return rc;
 }
 
-
 int
 CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
@@ -372,8 +359,8 @@ CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	if (tcon->ses->server->ops->query_mf_symlink)
-		rc = tcon->ses->server->ops->query_mf_symlink(path, buf,
-						&bytes_read, cifs_sb, xid);
+		rc = tcon->ses->server->ops->query_mf_symlink(xid, tcon,
+					      cifs_sb, path, buf, &bytes_read);
 	else
 		rc = -ENOSYS;
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5f5ba0d..099c276 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1009,7 +1009,7 @@ struct smb_version_operations smb1_operations = {
 	.mand_lock = cifs_mand_lock,
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
-	.query_mf_symlink = open_query_close_cifs_symlink,
+	.query_mf_symlink = cifs_query_mf_symlink,
 	.is_read_op = cifs_is_read_op,
 };
 
-- 
1.8.3.1
