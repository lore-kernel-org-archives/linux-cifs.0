From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 44/53] CIFS: Request SMB2.1 leases
Date: Fri, 28 Oct 2011 23:54:55 +0400
Message-ID: <1319831704-3572-45-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

if server supports them and we need oplocks.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    5 ++-
 fs/cifs/cifsglob.h  |    3 +
 fs/cifs/smb2file.c  |    9 ++-
 fs/cifs/smb2inode.c |   12 +++--
 fs/cifs/smb2pdu.c   |  142 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h   |   31 +++++++++++-
 6 files changed, 185 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7991a53..3683384 100644
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
@@ -263,7 +264,9 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->server_eof = 0;
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
-
+#ifdef CONFIG_CIFS_SMB2
+	get_random_bytes(&cifs_inode->lease_key, 16);
+#endif
 	/* Can not set i_flags here - they get immediately overwritten
 	   to zero by the VFS */
 /*	cifs_inode->vfs_inode.i_flags = S_NOATIME | S_NOCMTIME;*/
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c05b4c0..3d950d9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -692,6 +692,9 @@ struct cifsInodeInfo {
 	struct fscache_cookie *fscache;
 #endif
 	struct inode vfs_inode;
+#ifdef CONFIG_CIFS_SMB2
+	__u8 lease_key[16];
+#endif
 };
 
 static inline struct cifsInodeInfo *
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 8b0080b..58f9edb 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -241,6 +241,9 @@ smb2_open_helper(struct file *file, struct inode *inode, const char *full_path,
 	}
 
 	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	if (tcon->ses->server->smb2_dialect_revision == cpu_to_le16(0x0210))
+		memcpy(oplock + 1, &CIFS_I(inode)->lease_key, 16);
+
 	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
 		       desired_access, create_disposition, 0, 0, oplock);
 	if (rc)
@@ -263,7 +266,7 @@ int smb2_open(struct inode *inode, struct file *file)
 {
 	int rc = -EACCES;
 	int xid;
-	__u8 oplock;
+	__u8 oplock[17];
 	struct cifs_sb_info *cifs_sb;
 	struct cifsFileInfo *cifs_file;
 	struct tcon_link *tlink;
@@ -294,7 +297,7 @@ int smb2_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	rc = smb2_open_helper(file, inode, full_path, &oplock, &persist_fid,
+	rc = smb2_open_helper(file, inode, full_path, oplock, &persist_fid,
 			      &volatile_fid, data, tcon, xid);
 	if (rc)
 		goto out;
@@ -306,7 +309,7 @@ int smb2_open(struct inode *inode, struct file *file)
 	}
 
 	cifs_file = smb2_new_fileinfo(persist_fid, volatile_fid, file, tlink,
-				      oplock);
+				      *oplock);
 	if (cifs_file == NULL) {
 		SMB2_close(xid, tcon, persist_fid, volatile_fid);
 		rc = -ENOMEM;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index aecf50f..012b335 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -631,6 +631,9 @@ smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
 	}
 
 	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	if (tcon->ses->server->smb2_dialect_revision == cpu_to_le16(0x0210))
+		get_random_bytes(oplock + 1, 16);
+
 	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
 		       desired_access, create_disposition, 0, create_options,
 		       oplock);
@@ -665,7 +668,7 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 {
 	int rc = -ENOENT;
 	int xid;
-	__u8 oplock = 0;
+	__u8 oplock[17];
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
@@ -701,7 +704,7 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 		goto smb2_create_out;
 	}
 
-	rc = smb2_create_helper(dir, direntry, mode, nd, &oplock, &persist_fid,
+	rc = smb2_create_helper(dir, direntry, mode, nd, oplock, &persist_fid,
 				&volatile_fid, xid, tcon, full_path, buf);
 	if (rc) {
 		cFYI(1, "smb2_create returned 0x%x", rc);
@@ -716,9 +719,10 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 	}
 
 	if (newinode) {
+		memcpy(CIFS_I(newinode)->lease_key, oplock + 1, 16);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 			newinode->i_mode = mode;
-		if ((oplock & CIFS_CREATE_ACTION) &&
+		if ((*oplock & CIFS_CREATE_ACTION) &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)) {
 			newinode->i_uid = current_fsuid();
 			if (dir->i_mode & S_ISGID)
@@ -742,7 +746,7 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 		}
 
 		file_info = smb2_new_fileinfo(persist_fid, volatile_fid,
-					      filp, tlink, oplock);
+					      filp, tlink, *oplock);
 		if (file_info == NULL) {
 			fput(filp);
 			SMB2_close(xid, tcon, persist_fid, volatile_fid);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bd69274..bcc3513 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -525,7 +525,7 @@ static void free_rsp_buf(int resp_buftype, void *pSMB2r)
 		cifs_buf_release(pSMB2r);
 }
 
-#define SMB2_NUM_PROT 1
+#define SMB2_NUM_PROT 2
 
 #define SMB2_PROT   0
 #define SMB21_PROT  1
@@ -610,6 +610,7 @@ SMB2_negotiate(unsigned int xid, struct cifs_ses *ses)
 	pSMB2->SecurityMode = cpu_to_le16(temp);
 
 	pSMB2->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+	pSMB2->ClientGUID[0] = pSMB2->ClientGUID[3] = pSMB2->ClientGUID[7] = 7;
 
 	iov[0].iov_base = (char *)pSMB2;
 	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
@@ -1044,6 +1045,87 @@ int SMB2_tdis(const int xid, struct cifs_tcon *tcon)
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
+	if (enable_oplocks) {
+		if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+			buf->lcontext.LeaseState = SMB2_LEASE_WRITE_CACHING |
+						   SMB2_LEASE_READ_CACHING;
+		else if (oplock == SMB2_OPLOCK_LEVEL_II)
+			buf->lcontext.LeaseState = SMB2_LEASE_READ_CACHING;
+		else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
+			buf->lcontext.LeaseState = SMB2_LEASE_HANDLE_CACHING |
+						   SMB2_LEASE_READ_CACHING |
+						   SMB2_LEASE_WRITE_CACHING;
+	}
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
+parse_lease_state(struct create_rsp *smb)
+{
+	char *data_offset;
+	struct create_lease *lc;
+	__u8 oplock = 0;
+	bool found = false;
+
+	data_offset = (char *)smb;
+	data_offset += 4 + le32_to_cpu(smb->CreateContextsOffset);
+	lc = (struct create_lease *)data_offset;
+	do {
+		char *name = le16_to_cpu(lc->ccontext.NameOffset) + (char *)lc;
+		if (le16_to_cpu(lc->ccontext.NameLength) != 4) {
+			lc = (struct create_lease *)((char *)lc
+					+ le32_to_cpu(lc->ccontext.Next));
+			continue;
+		}
+		if (strncmp(name, "RqLs", 4)) {
+			lc = (struct create_lease *)((char *)lc
+					+ le32_to_cpu(lc->ccontext.Next));
+			continue;
+		}
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
 int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	      u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
 	      __u32 create_disposition, __u32 file_attributes,
@@ -1053,10 +1135,12 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	struct create_rsp *pSMB2r;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[2];
+	struct kvec iov[3];
 	int resp_buftype;
 	int status;
 	int uni_path_len;
+	__le16 *copy_path = NULL;
+	int copy_size;
 	int rc = 0;
 	int num_iovecs = 2;
 
@@ -1071,10 +1155,6 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	if (enable_oplocks)
-		pSMB2->RequestedOplockLevel = *oplock;
-	else
-		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	pSMB2->ImpersonationLevel = IL_IMPERSONATION;
 	pSMB2->DesiredAccess = cpu_to_le32(desired_access);
 	/* File attributes ignored on open (used in create though) */
@@ -1084,7 +1164,7 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	pSMB2->CreateOptions = cpu_to_le32(create_options);
 	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
 	pSMB2->NameOffset = cpu_to_le16(sizeof(struct create_req)
-			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+			- 8 /* pad */ - 4 /* do not count rfc1001 len field */);
 
 	iov[0].iov_base = (char *)pSMB2;
 
@@ -1096,16 +1176,57 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 		pSMB2->NameLength = cpu_to_le16(uni_path_len - 2);
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
 	 /* -1 since last byte is buf[0] which was counted in smb2_buf_len */
 		pSMB2->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
 				pSMB2->hdr.smb2_buf_length) + uni_path_len - 1);
 	} else {
+		iov[0].iov_len += 7;
+		pSMB2->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
+				pSMB2->hdr.smb2_buf_length) + 8 - 1);
 		num_iovecs = 1;
 		pSMB2->NameLength = 0;
 	}
 
+	if (!enable_oplocks)
+		*oplock = SMB2_OPLOCK_LEVEL_NONE;
+
+	if (tcon->ses->server->smb2_dialect_revision == cpu_to_le16(0x0202) ||
+	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
+		pSMB2->RequestedOplockLevel = *oplock;
+	else {
+		iov[num_iovecs].iov_base = create_lease_buf(oplock+1, *oplock);
+		if (iov[num_iovecs].iov_base == NULL) {
+			cifs_small_buf_release(pSMB2);
+			kfree(copy_path);
+			return -ENOMEM;
+		}
+		iov[num_iovecs].iov_len = sizeof(struct create_lease);
+		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
+		pSMB2->CreateContextsOffset = cpu_to_le32(
+			sizeof(struct create_req) - 4 - 8 +
+			iov[num_iovecs-1].iov_len);
+		pSMB2->CreateContextsLength = cpu_to_le32(
+			sizeof(struct create_lease));
+		inc_rfc1001_len(&pSMB2->hdr, sizeof(struct create_lease));
+		num_iovecs++;
+	}
+
 /*	cERROR(1, "unipathlen 0x%x iov0len 0x%x iov1len 0x%x", uni_path_len,
 		iov[0].iov_len, iov[1].iov_len); */ /* BB REMOVEME BB */
 	rc = smb2_sendrcv2(xid, ses, iov, num_iovecs, &resp_buftype /* ret */,
@@ -1124,8 +1245,13 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	}
 	*persistent_fid = pSMB2r->PersistentFileId;
 	*volatile_fid = pSMB2r->VolatileFileId;
-	*oplock = pSMB2r->OplockLevel;
+
+	if (pSMB2r->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
+		*oplock = parse_lease_state(pSMB2r);
+	else
+		*oplock = pSMB2r->OplockLevel;
 creat_exit:
+	kfree(copy_path);
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a24dfdb..6b8fd2f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -438,7 +438,7 @@ struct create_req {
 	__le16 NameLength;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8    Buffer[1];
+	__u8    Buffer[8];
 }  __attribute__((packed));
 
 struct create_rsp {
@@ -462,6 +462,35 @@ struct create_rsp {
 	__u8   Buffer[1];
 }  __attribute__((packed));
 
+struct create_context {
+	__le32 Next;
+	__le16 NameOffset;
+	__le16 NameLength;
+	__le16 Reserved;
+	__le16 DataOffset;
+	__le32 DataLength;
+	__u8 Buffer[0];
+} __attribute__((packed));
+
+#define SMB2_LEASE_NONE			cpu_to_le32(0x00)
+#define SMB2_LEASE_READ_CACHING		cpu_to_le32(0x01)
+#define SMB2_LEASE_HANDLE_CACHING	cpu_to_le32(0x02)
+#define SMB2_LEASE_WRITE_CACHING	cpu_to_le32(0x04)
+
+struct lease_context {
+	__le64 LeaseKeyLow;
+	__le64 LeaseKeyHigh;
+	__le32 LeaseState;
+	__le32 LeaseFlags;
+	__le64 LeaseDuration;
+} __attribute__((packed));
+
+struct create_lease {
+	struct create_context ccontext;
+	u8 Name[8];
+	struct lease_context lcontext;
+} __attribute__((packed));
+
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct close_req {
-- 
1.7.1
