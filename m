From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] CIFS: Request SMB2.1 leases
Date: Tue,  4 Sep 2012 20:24:04 +0400
Message-ID: <1346775847-7894-2-git-send-email-pshilovsky@etersoft.ru>
References: <1346775847-7894-1-git-send-email-pshilovsky@etersoft.ru>
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346775847-7894-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

if server supports them and we need oplocks.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c   |   28 ++++++++---
 fs/cifs/cifsglob.h |   10 ++++
 fs/cifs/dir.c      |   13 ++++-
 fs/cifs/file.c     |   21 ++++++--
 fs/cifs/smb2file.c |    9 +++-
 fs/cifs/smb2ops.c  |   21 ++++++++
 fs/cifs/smb2pdu.c  |  138 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h  |   43 +++++++++++++++-
 8 files changed, 256 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4cd68c7..28ac048 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -36,6 +36,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/namei.h>
+#include <linux/random.h>
 #include <net/ipv6.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -88,6 +89,10 @@ extern mempool_t *cifs_mid_poolp;
 
 struct workqueue_struct	*cifsiod_wq;
 
+#ifdef CONFIG_CIFS_SMB2
+__u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
+#endif
+
 static int
 cifs_read_super(struct super_block *sb)
 {
@@ -218,9 +223,10 @@ cifs_alloc_inode(struct super_block *sb)
 		return NULL;
 	cifs_inode->cifsAttrs = 0x20;	/* default */
 	cifs_inode->time = 0;
-	/* Until the file is open and we have gotten oplock
-	info back from the server, can not assume caching of
-	file data or metadata */
+	/*
+	 * Until the file is open and we have gotten oplock info back from the
+	 * server, can not assume caching of file data or metadata.
+	 */
 	cifs_set_oplock_level(cifs_inode, 0);
 	cifs_inode->delete_pending = false;
 	cifs_inode->invalid_mapping = false;
@@ -228,10 +234,14 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->server_eof = 0;
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
-
-	/* Can not set i_flags here - they get immediately overwritten
-	   to zero by the VFS */
-/*	cifs_inode->vfs_inode.i_flags = S_NOATIME | S_NOCMTIME;*/
+#ifdef CONFIG_CIFS_SMB2
+	get_random_bytes(cifs_inode->lease_key, SMB2_LEASE_KEY_SIZE);
+#endif
+	/*
+	 * Can not set i_flags here - they get immediately overwritten to zero
+	 * by the VFS.
+	 */
+	/* cifs_inode->vfs_inode.i_flags = S_NOATIME | S_NOCMTIME; */
 	INIT_LIST_HEAD(&cifs_inode->openFileList);
 	INIT_LIST_HEAD(&cifs_inode->llist);
 	return &cifs_inode->vfs_inode;
@@ -1107,6 +1117,10 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
+#ifdef CONFIG_CIFS_SMB2
+	get_random_bytes(cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+#endif
+
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
 		cFYI(1, "cifs_max_pending set to min of 2");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e2492e1..b6ec142 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -361,6 +361,12 @@ struct smb_version_operations {
 				 const unsigned int);
 	/* push brlocks from the cache to the server */
 	int (*push_mand_locks)(struct cifsFileInfo *);
+	/* get lease key of the inode */
+	void (*get_lease_key)(struct inode *, struct cifs_fid *fid);
+	/* set lease key of the inode */
+	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
+	/* generate new lease key */
+	void (*new_lease_key)(struct cifs_fid *fid);
 };
 
 struct smb_version_values {
@@ -895,6 +901,7 @@ struct cifs_fid {
 #ifdef CONFIG_CIFS_SMB2
 	__u64 persistent_fid;	/* persist file id for smb2 */
 	__u64 volatile_fid;	/* volatile file id for smb2 */
+	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
 #endif
 };
 
@@ -1012,6 +1019,9 @@ struct cifsInodeInfo {
 	u64  server_eof;		/* current file size on server -- protected by i_lock */
 	u64  uniqueid;			/* server inode number */
 	u64  createtime;		/* creation time on server */
+#ifdef CONFIG_CIFS_SMB2
+	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for this inode */
+#endif
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie *fscache;
 #endif
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index b99a167..4f2147c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -340,6 +340,8 @@ cifs_create_get_file_info:
 		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
 					 xid, &fid->netfid);
 		if (newinode) {
+			if (server->ops->set_lease_key)
+				server->ops->set_lease_key(newinode, fid);
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 				newinode->i_mode = mode;
 			if ((*oplock & CIFS_CREATE_ACTION) &&
@@ -418,6 +420,9 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
+	if (server->ops->new_lease_key)
+		server->ops->new_lease_key(&fid);
+
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
 			    &oplock, &fid, opened);
 
@@ -473,10 +478,14 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	if (IS_ERR(tlink))
 		goto out_free_xid;
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &created);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
+
+	if (server->ops->new_lease_key)
+		server->ops->new_lease_key(&fid);
+
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fid, &created);
 	if (!rc && server->ops->close)
 		server->ops->close(xid, tcon, &fid);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c1df70a..f15c30c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -177,8 +177,9 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	int disposition;
 	int create_options = CREATE_NOT_DIR;
 	FILE_ALL_INFO *buf;
+	struct TCP_Server_Info *server = tcon->ses->server;
 
-	if (!tcon->ses->server->ops->open)
+	if (!server->ops->open)
 		return -ENOSYS;
 
 	desired_access = cifs_convert_flags(f_flags);
@@ -218,9 +219,9 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	rc = tcon->ses->server->ops->open(xid, tcon, full_path, disposition,
-					  desired_access, create_options, fid,
-					  oplock, buf, cifs_sb);
+	rc = server->ops->open(xid, tcon, full_path, disposition,
+			       desired_access, create_options, fid, oplock, buf,
+			       cifs_sb);
 
 	if (rc)
 		goto out;
@@ -372,6 +373,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	unsigned int xid;
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
+	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	struct cifsFileInfo *cfile = NULL;
@@ -388,6 +390,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		return PTR_ERR(tlink);
 	}
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	full_path = build_path_from_dentry(file->f_path.dentry);
 	if (full_path == NULL) {
@@ -432,6 +435,9 @@ int cifs_open(struct inode *inode, struct file *file)
 	}
 
 	if (!posix_open_ok) {
+		if (server->ops->get_lease_key)
+			server->ops->get_lease_key(inode, &fid);
+
 		rc = cifs_nt_open(full_path, inode, cifs_sb, tcon,
 				  file->f_flags, &oplock, &fid, xid);
 		if (rc)
@@ -440,8 +446,8 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	cfile = cifs_new_fileinfo(&fid, file, tlink, oplock);
 	if (cfile == NULL) {
-		if (tcon->ses->server->ops->close)
-			tcon->ses->server->ops->close(xid, tcon, &fid);
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -567,6 +573,9 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
+	if (server->ops->get_lease_key)
+		server->ops->get_lease_key(inode, &fid);
+
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
 	 * CIFSSMBOpen and then calling get_inode_info with returned buf since
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 0ddd617..78fb205 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -63,6 +63,7 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	int rc;
 	__le16 *smb2_path;
 	struct smb2_file_all_info *smb2_data = NULL;
+	__u8 smb2_oplock[17];
 
 	smb2_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (smb2_path == NULL) {
@@ -78,11 +79,14 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	}
 
 	desired_access |= FILE_READ_ATTRIBUTES;
-	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	*smb2_oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+
+	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
+		memcpy(smb2_oplock + 1, fid->lease_key, SMB2_LEASE_KEY_SIZE);
 
 	rc = SMB2_open(xid, tcon, smb2_path, &fid->persistent_fid,
 		       &fid->volatile_fid, desired_access, disposition,
-		       0, 0, (__u8 *)oplock, smb2_data);
+		       0, 0, smb2_oplock, smb2_data);
 	if (rc)
 		goto out;
 
@@ -99,6 +103,7 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		move_smb2_info_to_cifs(buf, smb2_data);
 	}
 
+	*oplock = *smb2_oplock;
 out:
 	kfree(smb2_data);
 	kfree(smb2_path);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0808b23..360d907 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -555,6 +555,24 @@ smb2_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
 			 current->tgid, length, offset, type, wait);
 }
 
+static void
+smb2_get_lease_key(struct inode *inode, struct cifs_fid *fid)
+{
+	memcpy(fid->lease_key, CIFS_I(inode)->lease_key, SMB2_LEASE_KEY_SIZE);
+}
+
+static void
+smb2_set_lease_key(struct inode *inode, struct cifs_fid *fid)
+{
+	memcpy(CIFS_I(inode)->lease_key, fid->lease_key, SMB2_LEASE_KEY_SIZE);
+}
+
+static void
+smb2_new_lease_key(struct cifs_fid *fid)
+{
+	get_random_bytes(fid->lease_key, SMB2_LEASE_KEY_SIZE);
+}
+
 struct smb_version_operations smb21_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -616,6 +634,9 @@ struct smb_version_operations smb21_operations = {
 	.mand_lock = smb2_mand_lock,
 	.mand_unlock_range = smb2_unlock_range,
 	.push_mand_locks = smb2_push_mandatory_locks,
+	.get_lease_key = smb2_get_lease_key,
+	.set_lease_key = smb2_set_lease_key,
+	.new_lease_key = smb2_new_lease_key,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d3e1cfc..89d2824 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -304,7 +304,7 @@ free_rsp_buf(int resp_buftype, void *rsp)
 		cifs_buf_release(rsp);
 }
 
-#define SMB2_NUM_PROT 1
+#define SMB2_NUM_PROT 2
 
 #define SMB2_PROT   0
 #define SMB21_PROT  1
@@ -393,6 +393,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	req->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
 
+	memcpy(req->ClientGUID, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
@@ -868,6 +870,83 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
+static struct create_lease *
+create_lease_buf(u8 *lease_key, u8 oplock)
+{
+	struct create_lease *buf;
+
+	buf = kmalloc(sizeof(struct create_lease), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	memset(buf, 0, sizeof(struct create_lease));
+
+	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
+	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		buf->lcontext.LeaseState = SMB2_LEASE_WRITE_CACHING |
+					   SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_II)
+		buf->lcontext.LeaseState = SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
+		buf->lcontext.LeaseState = SMB2_LEASE_HANDLE_CACHING |
+					   SMB2_LEASE_READ_CACHING |
+					   SMB2_LEASE_WRITE_CACHING;
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof
+					(struct create_lease, lcontext));
+	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context));
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof
+				(struct create_lease, Name));
+	buf->ccontext.NameLength = cpu_to_le16(4);
+	buf->Name[0] = 'R';
+	buf->Name[1] = 'q';
+	buf->Name[2] = 'L';
+	buf->Name[3] = 's';
+	return buf;
+}
+
+static __u8
+parse_lease_state(struct smb2_create_rsp *rsp)
+{
+	char *data_offset;
+	struct create_lease *lc;
+	__u8 oplock = 0;
+	bool found = false;
+
+	data_offset = (char *)rsp;
+	data_offset += 4 + le32_to_cpu(rsp->CreateContextsOffset);
+	lc = (struct create_lease *)data_offset;
+	do {
+		char *name = le16_to_cpu(lc->ccontext.NameOffset) + (char *)lc;
+		if (le16_to_cpu(lc->ccontext.NameLength) != 4 ||
+		    strncmp(name, "RqLs", 4)) {
+			lc = (struct create_lease *)((char *)lc
+					+ le32_to_cpu(lc->ccontext.Next));
+			continue;
+		}
+		if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
+			return SMB2_OPLOCK_LEVEL_NOCHANGE;
+		found = true;
+		break;
+	} while (le32_to_cpu(lc->ccontext.Next) != 0);
+
+	if (!found)
+		return oplock;
+
+	if (le32_to_cpu(lc->lcontext.LeaseState) & SMB2_LEASE_WRITE_CACHING) {
+		if (le32_to_cpu(lc->lcontext.LeaseState) &
+						SMB2_LEASE_HANDLE_CACHING)
+			oplock = SMB2_OPLOCK_LEVEL_BATCH;
+		else
+			oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (le32_to_cpu(lc->lcontext.LeaseState) &
+						SMB2_LEASE_READ_CACHING)
+		oplock = SMB2_OPLOCK_LEVEL_II;
+
+	return oplock;
+}
+
 int
 SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
@@ -878,9 +957,11 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	struct smb2_create_rsp *rsp;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[2];
+	struct kvec iov[3];
 	int resp_buftype;
 	int uni_path_len;
+	__le16 *copy_path = NULL;
+	int copy_size;
 	int rc = 0;
 	int num_iovecs = 2;
 
@@ -895,10 +976,6 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	if (server->oplocks)
-		req->RequestedOplockLevel = *oplock;
-	else
-		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	req->ImpersonationLevel = IL_IMPERSONATION;
 	req->DesiredAccess = cpu_to_le32(desired_access);
 	/* File attributes ignored on open (used in create though) */
@@ -908,7 +985,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	req->CreateOptions = cpu_to_le32(create_options);
 	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
 	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req)
-			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+			- 8 /* pad */ - 4 /* do not count rfc1001 len field */);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
@@ -919,6 +996,20 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		req->NameLength = cpu_to_le16(uni_path_len - 2);
 		/* -1 since last byte is buf[0] which is sent below (path) */
 		iov[0].iov_len--;
+		if (uni_path_len % 8 != 0) {
+			copy_size = uni_path_len / 8 * 8;
+			if (copy_size < uni_path_len)
+				copy_size += 8;
+
+			copy_path = kzalloc(copy_size, GFP_KERNEL);
+			if (!copy_path)
+				return -ENOMEM;
+			memcpy((char *)copy_path, (const char *)path,
+				uni_path_len);
+			uni_path_len = copy_size;
+			path = copy_path;
+		}
+
 		iov[1].iov_len = uni_path_len;
 		iov[1].iov_base = path;
 		/*
@@ -927,10 +1018,37 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		 */
 		inc_rfc1001_len(req, uni_path_len - 1);
 	} else {
+		iov[0].iov_len += 7;
+		req->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
+				req->hdr.smb2_buf_length) + 8 - 1);
 		num_iovecs = 1;
 		req->NameLength = 0;
 	}
 
+	if (!server->oplocks)
+		*oplock = SMB2_OPLOCK_LEVEL_NONE;
+
+	if (!(tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
+	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
+		req->RequestedOplockLevel = *oplock;
+	else {
+		iov[num_iovecs].iov_base = create_lease_buf(oplock+1, *oplock);
+		if (iov[num_iovecs].iov_base == NULL) {
+			cifs_small_buf_release(req);
+			kfree(copy_path);
+			return -ENOMEM;
+		}
+		iov[num_iovecs].iov_len = sizeof(struct create_lease);
+		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
+		req->CreateContextsOffset = cpu_to_le32(
+			sizeof(struct smb2_create_req) - 4 - 8 +
+			iov[num_iovecs-1].iov_len);
+		req->CreateContextsLength = cpu_to_le32(
+			sizeof(struct create_lease));
+		inc_rfc1001_len(&req->hdr, sizeof(struct create_lease));
+		num_iovecs++;
+	}
+
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
 	rsp = (struct smb2_create_rsp *)iov[0].iov_base;
 
@@ -955,8 +1073,12 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		buf->DeletePending = 0;
 	}
 
-	*oplock = rsp->OplockLevel;
+	if (rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
+		*oplock = parse_lease_state(rsp);
+	else
+		*oplock = rsp->OplockLevel;
 creat_exit:
+	kfree(copy_path);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 889ee5e..e818a5c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -150,6 +150,10 @@ struct smb2_err_rsp {
 	__u8   ErrorData[1];  /* variable length */
 } __packed;
 
+#define SMB2_CLIENT_GUID_SIZE 16
+
+extern __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
+
 struct smb2_negotiate_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 36 */
@@ -157,7 +161,7 @@ struct smb2_negotiate_req {
 	__le16 SecurityMode;
 	__le16 Reserved;	/* MBZ */
 	__le32 Capabilities;
-	__u8   ClientGUID[16];	/* MBZ */
+	__u8   ClientGUID[SMB2_CLIENT_GUID_SIZE];
 	__le64 ClientStartTime;	/* MBZ */
 	__le16 Dialects[2]; /* variable length */
 } __packed;
@@ -307,6 +311,8 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_OPLOCK_LEVEL_EXCLUSIVE	0x08
 #define SMB2_OPLOCK_LEVEL_BATCH		0x09
 #define SMB2_OPLOCK_LEVEL_LEASE		0xFF
+/* Non-spec internal type */
+#define SMB2_OPLOCK_LEVEL_NOCHANGE	0x99
 
 /* Desired Access Flags */
 #define FILE_READ_DATA_LE		cpu_to_le32(0x00000001)
@@ -404,7 +410,7 @@ struct smb2_create_req {
 	__le16 NameLength;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8   Buffer[1];
+	__u8   Buffer[8];
 } __packed;
 
 struct smb2_create_rsp {
@@ -428,6 +434,39 @@ struct smb2_create_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+struct create_context {
+	__le32 Next;
+	__le16 NameOffset;
+	__le16 NameLength;
+	__le16 Reserved;
+	__le16 DataOffset;
+	__le32 DataLength;
+	__u8 Buffer[0];
+} __packed;
+
+#define SMB2_LEASE_NONE			__constant_cpu_to_le32(0x00)
+#define SMB2_LEASE_READ_CACHING		__constant_cpu_to_le32(0x01)
+#define SMB2_LEASE_HANDLE_CACHING	__constant_cpu_to_le32(0x02)
+#define SMB2_LEASE_WRITE_CACHING	__constant_cpu_to_le32(0x04)
+
+#define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS __constant_cpu_to_le32(0x02)
+
+#define SMB2_LEASE_KEY_SIZE 16
+
+struct lease_context {
+	__le64 LeaseKeyLow;
+	__le64 LeaseKeyHigh;
+	__le32 LeaseState;
+	__le32 LeaseFlags;
+	__le64 LeaseDuration;
+} __packed;
+
+struct create_lease {
+	struct create_context ccontext;
+	__u8   Name[8];
+	struct lease_context lcontext;
+} __packed;
+
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct smb2_close_req {
-- 
1.7.1
