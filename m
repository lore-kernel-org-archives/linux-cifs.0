From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 8/8] CIFS: Reconnect durable handles for SMB2
Date: Wed, 10 Jul 2013 14:00:00 +0400
Message-ID: <1373450401-4135-9-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On reconnects, we need to reopen file and then obtain all byte-range
locks held by the client. SMB2 protocol provides feature to make
this process atomic by reconnecting to the same file handle
with all it's byte-range locks. This patch adds this capability
for SMB2 shares.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/dir.c       |    1 +
 fs/cifs/file.c      |   15 +++++++++------
 fs/cifs/smb2file.c  |    3 ++-
 fs/cifs/smb2inode.c |    1 +
 fs/cifs/smb2ops.c   |    3 +++
 fs/cifs/smb2pdu.c   |   38 ++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.h   |    8 +++++++-
 8 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 107e657..1b1b144 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -915,6 +915,7 @@ struct cifs_open_parms {
 	int create_options;
 	const char *path;
 	struct cifs_fid *fid;
+	bool reconnect:1;
 };
 
 struct cifs_fid {
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 66435c9..585e01a 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -327,6 +327,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	oparms.disposition = disposition;
 	oparms.path = full_path;
 	oparms.fid = fid;
+	oparms.reconnect = false;
 
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 12a9754..2cd4a7c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -232,6 +232,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	oparms.disposition = disposition;
 	oparms.path = full_path;
 	oparms.fid = fid;
+	oparms.reconnect = false;
 
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 
@@ -594,7 +595,6 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	int desired_access;
 	int disposition = FILE_OPEN;
 	int create_options = CREATE_NOT_DIR;
-	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
 
 	xid = get_xid();
@@ -645,7 +645,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
 				     cifs_sb->mnt_file_mode /* ignored */,
-				     oflags, &oplock, &fid.netfid, xid);
+				     oflags, &oplock, &cfile->fid.netfid, xid);
 		if (rc == 0) {
 			cifs_dbg(FYI, "posix reopen succeeded\n");
 			goto reopen_success;
@@ -662,7 +662,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
 	if (server->ops->get_lease_key)
-		server->ops->get_lease_key(inode, &fid);
+		server->ops->get_lease_key(inode, &cfile->fid);
 
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
@@ -670,7 +670,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	oparms.create_options = create_options;
 	oparms.disposition = disposition;
 	oparms.path = full_path;
-	oparms.fid = &fid;
+	oparms.fid = &cfile->fid;
+	oparms.reconnect = true;
 
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
@@ -710,8 +711,9 @@ reopen_success:
 	 * to the server to get the new inode info.
 	 */
 
-	server->ops->set_fid(cfile, &fid, oplock);
-	cifs_relock_file(cfile);
+	server->ops->set_fid(cfile, &cfile->fid, oplock);
+	if (oparms.reconnect)
+		cifs_relock_file(cfile);
 
 reopen_error_exit:
 	kfree(full_path);
@@ -1507,6 +1509,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		if (!rc)
 			goto out;
 
+
 		/*
 		 * Windows 7 server can delay breaking lease from read to None
 		 * if we set a byte-range lock on a file - break it explicitly
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3989929..04a81a4 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -40,7 +40,8 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	oplock &= 0xFF;
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
-	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
+	    oplock == SMB2_OPLOCK_LEVEL_BATCH) {
 		cinode->clientCanCacheAll = true;
 		cinode->clientCanCacheRead = true;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9841df7..c6ec163 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -58,6 +58,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = create_disposition;
 	oparms.create_options = create_options;
 	oparms.fid = &fid;
+	oparms.reconnect = false;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	if (rc) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 86954b0..300ff85 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -227,6 +227,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = FILE_OPEN;
 	oparms.create_options = 0;
 	oparms.fid = &fid;
+	oparms.reconnect = false;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	if (rc) {
@@ -460,6 +461,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = FILE_OPEN;
 	oparms.create_options = 0;
 	oparms.fid = fid;
+	oparms.reconnect = false;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	kfree(utf16_path);
@@ -546,6 +548,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = FILE_OPEN;
 	oparms.create_options = 0;
 	oparms.fid = &fid;
+	oparms.reconnect = false;
 
 	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL);
 	if (rc)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9d7341d..c7ad06f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -857,7 +857,7 @@ create_durable_buf(void)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable, Reserved));
+					(struct create_durable, Data));
 	buf->ccontext.DataLength = cpu_to_le32(16);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct create_durable, Name));
@@ -869,6 +869,30 @@ create_durable_buf(void)
 	return buf;
 }
 
+static struct create_durable *
+create_reconnect_durable_buf(struct cifs_fid *fid)
+{
+	struct create_durable *buf;
+
+	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof
+					(struct create_durable, Data));
+	buf->ccontext.DataLength = cpu_to_le32(16);
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof
+				(struct create_durable, Name));
+	buf->ccontext.NameLength = cpu_to_le16(4);
+	buf->Data.Fid.PersistentFileId = fid->persistent_fid;
+	buf->Data.Fid.VolatileFileId = fid->volatile_fid;
+	buf->Name[0] = 'D';
+	buf->Name[1] = 'H';
+	buf->Name[2] = 'n';
+	buf->Name[3] = 'C';
+	return buf;
+}
+
 static __u8
 parse_lease_state(struct smb2_create_rsp *rsp)
 {
@@ -924,12 +948,18 @@ add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
 }
 
 static int
-add_durable_context(struct kvec *iov, unsigned int *num_iovec)
+add_durable_context(struct kvec *iov, unsigned int *num_iovec,
+		    struct cifs_open_parms *oparms)
 {
 	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
-	iov[num].iov_base = create_durable_buf();
+	if (oparms->reconnect) {
+		iov[num].iov_base = create_reconnect_durable_buf(oparms->fid);
+		/* indicate that we don't need to relock the file */
+		oparms->reconnect = false;
+	} else
+		iov[num].iov_base = create_durable_buf();
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable);
@@ -1037,7 +1067,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			    (struct create_context *)iov[num_iovecs-1].iov_base;
 			ccontext->Next = sizeof(struct create_lease);
 		}
-		rc = add_durable_context(iov, &num_iovecs);
+		rc = add_durable_context(iov, &num_iovecs, oparms);
 		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 3e30f0a..36b0d37 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -488,7 +488,13 @@ struct create_lease {
 struct create_durable {
 	struct create_context ccontext;
 	__u8   Name[8];
-	__u8   Reserved[16];
+	union {
+		__u8  Reserved[16];
+		struct {
+			__u64 PersistentFileId;
+			__u64 VolatileFileId;
+		} Fid;
+	} Data;
 } __packed;
 
 /* this goes in the ioctl buffer when doing a copychunk request */
-- 
1.7.10.4
