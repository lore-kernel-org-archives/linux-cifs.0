From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Do not attemp to do cifs operations reading symlinks
 with SMB2
Date: Thu, 11 Jul 2013 19:23:56 -0500
Message-ID: <CAH2r5mvUvjhvfkXkEaGBa8S0vm8PyxA2cdertiOitQY7VnBnWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[Moves cifs specific symlink processing to cifs specific worker
function in fs/cifs/link.c]

When use of symlinks is enabled (mounting with mfsymlinks option) to
non-Samba servers, we always tried to use cifs, even when we
were mounted with SMB2 or SMB3, which causes the server to drop the
network connection.

This patch separates out the protocol specific operations for cifs from
the code which recognizes symlinks, and fixes the problem where
with SMB2 mounts we attempt cifs operations to open and read
symlinks.  The next patch will add support for SMB2 for opening
and reading symlinks.  Additional followon patches will address
the similar problem creating symlinks.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  3 ++
 fs/cifs/cifsproto.h |  4 ++-
 fs/cifs/link.c      | 84 +++++++++++++++++++++++++++++++++--------------------
 fs/cifs/smb1ops.c   |  1 +
 4 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1fdc370..33f17ed 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -369,6 +369,9 @@ struct smb_version_operations {
 	void (*generate_signingkey)(struct TCP_Server_Info *server);
 	int (*calc_signature)(struct smb_rqst *rqst,
 				   struct TCP_Server_Info *server);
+	int (*query_mf_symlink)(const unsigned char *path, char *pbuf,
+			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
+			unsigned int xid);
 };

 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f7e584d..b29a012 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -497,5 +497,7 @@ void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
 						work_func_t complete);
 void cifs_writedata_release(struct kref *refcount);
-
+int open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
+			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
+			unsigned int xid);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index b83c3f5..562044f 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -305,67 +305,89 @@ CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr)
 }

 int
-CIFSCheckMFSymlink(struct cifs_fattr *fattr,
-		   const unsigned char *path,
-		   struct cifs_sb_info *cifs_sb, unsigned int xid)
+open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
+			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
+			unsigned int xid)
 {
 	int rc;
 	int oplock = 0;
 	__u16 netfid = 0;
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *ptcon;
 	struct cifs_io_parms io_parms;
-	u8 *buf;
-	char *pbuf;
-	unsigned int bytes_read = 0;
 	int buf_type = CIFS_NO_BUFFER;
-	unsigned int link_len = 0;
 	FILE_ALL_INFO file_info;

-	if (!CIFSCouldBeMFSymlink(fattr))
-		/* it's not a symlink */
-		return 0;
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	ptcon = tlink_tcon(tlink);

-	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
+	rc = CIFSSMBOpen(xid, ptcon, path, FILE_OPEN, GENERIC_READ,
 			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
 			 cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc != 0)
-		goto out;
+	if (rc != 0) {
+		cifs_put_tlink(tlink);
+		return rc;
+	}

 	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
-		CIFSSMBClose(xid, pTcon, netfid);
+		CIFSSMBClose(xid, ptcon, netfid);
+		cifs_put_tlink(tlink);
 		/* it's not a symlink */
-		goto out;
+		return rc;
 	}

-	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
-	if (!buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	pbuf = buf;
 	io_parms.netfid = netfid;
 	io_parms.pid = current->tgid;
-	io_parms.tcon = pTcon;
+	io_parms.tcon = ptcon;
 	io_parms.offset = 0;
 	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;

-	rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf, &buf_type);
-	CIFSSMBClose(xid, pTcon, netfid);
-	if (rc != 0) {
-		kfree(buf);
+	rc = CIFSSMBRead(xid, &io_parms, pbytes_read, &pbuf, &buf_type);
+	CIFSSMBClose(xid, ptcon, netfid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
+
+
+int
+CIFSCheckMFSymlink(struct cifs_fattr *fattr,
+		   const unsigned char *path,
+		   struct cifs_sb_info *cifs_sb, unsigned int xid)
+{
+	int rc = 0;
+	u8 *buf = NULL;
+	unsigned int link_len = 0;
+	unsigned int bytes_read = 0;
+	struct cifs_tcon *ptcon;
+
+	if (!CIFSCouldBeMFSymlink(fattr))
+		/* it's not a symlink */
+		return 0;
+
+	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
 		goto out;
 	}

+	ptcon = tlink_tcon(cifs_sb_tlink(cifs_sb));
+	if ((ptcon->ses) && (ptcon->ses->server->ops->query_mf_symlink))
+		rc = ptcon->ses->server->ops->query_mf_symlink(path, buf,
+						 &bytes_read, cifs_sb, xid);
+	else
+		goto out;
+
+	if (rc != 0)
+		goto out;
+
+	if (bytes_read == 0) /* not a symlink */
+		goto out;
+
 	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, NULL);
-	kfree(buf);
 	if (rc == -EINVAL) {
 		/* it's not a symlink */
 		rc = 0;
@@ -381,7 +403,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 	fattr->cf_mode |= S_IFLNK | S_IRWXU | S_IRWXG | S_IRWXO;
 	fattr->cf_dtype = DT_LNK;
 out:
-	cifs_put_tlink(tlink);
+	kfree(buf);
 	return rc;
 }

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6457690..6094397 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -944,6 +944,7 @@ struct smb_version_operations smb1_operations = {
 	.mand_lock = cifs_mand_lock,
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
+	.query_mf_symlink = open_query_close_cifs_symlink,
 };

 struct smb_version_values smb1_values = {
-- 
1.7.11.7


-- 
Thanks,

Steve
