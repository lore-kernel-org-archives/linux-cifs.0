From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 13/50] CIFS: Add SMB2 support for is_path_accessible
Date: Fri, 20 Jan 2012 12:34:34 +0400
Message-ID: <1327048511-2342-13-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that needs for a successful mount through SMB2 protocol.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c   |   44 +++++++++----
 fs/cifs/smb2misc.c  |    5 ++
 fs/cifs/smb2pdu.c   |  138 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |  167 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    6 ++
 5 files changed, 346 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1152001..60c63b6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3147,22 +3147,38 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
 {
 	int rc;
-	FILE_ALL_INFO *pfile_info;
 
-	pfile_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (pfile_info == NULL)
-		return -ENOMEM;
-
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
 
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 70f5fbc..16272e5 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -233,6 +233,11 @@ char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 		  ((struct smb2_sess_setup_rsp *)pSMB2)->SecurityBufferLength);
 		break;
 	case SMB2_CREATE:
+		*poff = le32_to_cpu(
+		    ((struct smb2_create_rsp *)pSMB2)->CreateContextsOffset);
+		*plen = le32_to_cpu(
+		    ((struct smb2_create_rsp *)pSMB2)->CreateContextsLength);
+		break;
 	case SMB2_READ:
 	case SMB2_QUERY_INFO:
 	case SMB2_QUERY_DIRECTORY:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1c40896..1e2cd95 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -876,3 +876,141 @@ int SMB2_tdis(const int xid, struct cifs_tcon *tcon)
 
 	return rc;
 }
+
+int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
+	      u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
+	      __u32 create_disposition, __u32 file_attributes,
+	      __u32 create_options)
+{
+	struct smb2_create_req *pSMB2;
+	struct smb2_create_rsp *pSMB2r;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[2];
+	int resp_buftype;
+	int status;
+	int uni_path_len;
+	int rc = 0;
+	int num_iovecs = 2;
+
+	cFYI(1, "create/open");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_CREATE, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	if (enable_oplocks)
+		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
+	else
+		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
+	pSMB2->ImpersonationLevel = IL_IMPERSONATION;
+	pSMB2->DesiredAccess = cpu_to_le32(desired_access);
+	/* File attributes ignored on open (used in create though) */
+	pSMB2->FileAttributes = cpu_to_le32(file_attributes);
+	pSMB2->ShareAccess = FILE_SHARE_ALL_LE;
+	pSMB2->CreateDisposition = cpu_to_le32(create_disposition);
+	pSMB2->CreateOptions = cpu_to_le32(create_options);
+	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
+	pSMB2->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req)
+			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+
+	iov[0].iov_base = (char *)pSMB2;
+
+	/*  rfc1001 length field is 4 bytes so added below */
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
+
+	 /* MUST set path len (NameLength) to 0 opening root of share */
+	if (uni_path_len >= 4) {
+		pSMB2->NameLength = cpu_to_le16(uni_path_len - 2);
+		/* -1 since last byte is buf[0] which is sent below (path) */
+		iov[0].iov_len--;
+		iov[1].iov_len = uni_path_len;
+		iov[1].iov_base = path;
+	 /* -1 since last byte is buf[0] which was counted in smb2_buf_len */
+		pSMB2->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
+				pSMB2->hdr.smb2_buf_length) + uni_path_len - 1);
+	} else {
+		num_iovecs = 1;
+		pSMB2->NameLength = 0;
+	}
+
+/*	cERROR(1, "unipathlen 0x%x iov0len 0x%x iov1len 0x%x", uni_path_len,
+		iov[0].iov_len, iov[1].iov_len); */ /* BB REMOVEME BB */
+	rc = smb2_sendrcv2(xid, ses, iov, num_iovecs, &resp_buftype /* ret */,
+			   &status, CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "creat buftype %d rc %d status %d", resp_buftype, rc, status);
+	pSMB2r = (struct smb2_create_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2CREATE);
+		goto creat_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto creat_exit;
+	}
+	*persistent_fid = pSMB2r->PersistentFileId;
+	*volatile_fid = pSMB2r->VolatileFileId;
+creat_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
+
+int SMB2_close(const int xid, struct cifs_tcon *tcon,
+	       u64 persistent_file_id, u64 volatile_file_id)
+{
+	struct smb2_close_req *pSMB2;
+	struct smb2_close_rsp *pSMB2r;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[1];
+	int resp_buftype;
+	int status;
+	int rc = 0;
+
+	cFYI(1, "Close");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->PersistentFileId = persistent_file_id;
+	pSMB2->VolatileFileId = volatile_file_id;
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+					+ 4 /* rfc1001 len */;
+
+	rc = smb2_sendrcv2(xid, ses, iov, 1, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "CLOSE buftype %d rc %d status %d", resp_buftype, rc, status);
+	pSMB2r = (struct smb2_close_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		if (tcon)
+			cifs_stats_fail_inc(tcon, SMB2CLOSE);
+		goto close_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto close_exit;
+	}
+
+	/* BB FIXME - decode close response, update inode for caching */
+
+close_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 9316914..a3a08bb 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -274,4 +274,171 @@ struct smb2_tree_disconnect_rsp {
 	__le16 Reserved;
 } __packed;
 
+/* File Attrubutes */
+#define FILE_ATTRIBUTE_READONLY			0x00000001
+#define FILE_ATTRIBUTE_HIDDEN			0x00000002
+#define FILE_ATTRIBUTE_SYSTEM			0x00000004
+#define FILE_ATTRIBUTE_DIRECTORY		0x00000010
+#define FILE_ATTRIBUTE_ARCHIVE			0x00000020
+#define FILE_ATTRIBUTE_NORMAL			0x00000080
+#define FILE_ATTRIBUTE_TEMPORARY		0x00000100
+#define FILE_ATTRIBUTE_SPARSE_FILE		0x00000200
+#define FILE_ATTRIBUTE_REPARSE_POINT		0x00000400
+#define FILE_ATTRIBUTE_COMPRESSED		0x00000800
+#define FILE_ATTRIBUTE_OFFLINE			0x00001000
+#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	0x00002000
+#define FILE_ATTRIBUTE_ENCRYPTED		0x00004000
+
+/* Oplock levels */
+#define SMB2_OPLOCK_LEVEL_NONE		0x00
+#define SMB2_OPLOCK_LEVEL_II		0x01
+#define SMB2_OPLOCK_LEVEL_EXCLUSIVE	0x08
+#define SMB2_OPLOCK_LEVEL_BATCH		0x09
+#define SMB2_OPLOCK_LEVEL_LEASE		0xFF
+
+/* Desired Access Flags */
+#define FILE_READ_DATA_LE		cpu_to_le32(0x00000001)
+#define FILE_WRITE_DATA_LE		cpu_to_le32(0x00000002)
+#define FILE_APPEND_DATA_LE		cpu_to_le32(0x00000004)
+#define FILE_READ_EA_LE			cpu_to_le32(0x00000008)
+#define FILE_WRITE_EA_LE		cpu_to_le32(0x00000010)
+#define FILE_EXECUTE_LE			cpu_to_le32(0x00000020)
+#define FILE_READ_ATTRIBUTES_LE		cpu_to_le32(0x00000080)
+#define FILE_WRITE_ATTRIBUTES_LE	cpu_to_le32(0x00000100)
+#define FILE_DELETE_LE			cpu_to_le32(0x00010000)
+#define FILE_READ_CONTROL_LE		cpu_to_le32(0x00020000)
+#define FILE_WRITE_DAC_LE		cpu_to_le32(0x00040000)
+#define FILE_WRITE_OWNER_LE		cpu_to_le32(0x00080000)
+#define FILE_SYNCHRONIZE_LE		cpu_to_le32(0x00100000)
+#define FILE_ACCESS_SYSTEM_SECURITY_LE	cpu_to_le32(0x01000000)
+#define FILE_MAXIMAL_ACCESS_LE		cpu_to_le32(0x02000000)
+#define FILE_GENERIC_ALL_LE		cpu_to_le32(0x10000000)
+#define FILE_GENERIC_EXECUTE_LE		cpu_to_le32(0x20000000)
+#define FILE_GENERIC_WRITE_LE		cpu_to_le32(0x40000000)
+#define FILE_GENERIC_READ_LE		cpu_to_le32(0x80000000)
+
+/* ShareAccess Flags */
+#define FILE_SHARE_READ_LE		cpu_to_le32(0x00000001)
+#define FILE_SHARE_WRITE_LE		cpu_to_le32(0x00000002)
+#define FILE_SHARE_DELETE_LE		cpu_to_le32(0x00000004)
+#define FILE_SHARE_ALL_LE		cpu_to_le32(0x00000007)
+
+/* CreateDisposition Flags */
+#define FILE_SUPERSEDE_LE		cpu_to_le32(0x00000000)
+#define FILE_OPEN_LE			cpu_to_le32(0x00000001)
+#define FILE_CREATE_LE			cpu_to_le32(0x00000002)
+#define	FILE_OPEN_IF_LE			cpu_to_le32(0x00000003)
+#define FILE_OVERWRITE_LE		cpu_to_le32(0x00000004)
+#define FILE_OVERWRITE_IF_LE		cpu_to_le32(0x00000005)
+
+/* CreateOptions Flags */
+#define FILE_DIRECTORY_FILE_LE		cpu_to_le32(0x00000001)
+/* same as #define CREATE_NOT_FILE_LE	cpu_to_le32(0x00000001) */
+#define FILE_WRITE_THROUGH_LE		cpu_to_le32(0x00000002)
+#define FILE_SEQUENTIAL_ONLY_LE		cpu_to_le32(0x00000004)
+#define FILE_NO_INTERMEDIATE_BUFFERRING_LE cpu_to_le32(0x00000008)
+#define FILE_SYNCHRONOUS_IO_ALERT_LE	cpu_to_le32(0x00000010)
+#define FILE_SYNCHRONOUS_IO_NON_ALERT_LE	cpu_to_le32(0x00000020)
+#define FILE_NON_DIRECTORY_FILE_LE	cpu_to_le32(0x00000040)
+#define FILE_COMPLETE_IF_OPLOCKED_LE	cpu_to_le32(0x00000100)
+#define FILE_NO_EA_KNOWLEDGE_LE		cpu_to_le32(0x00000200)
+#define FILE_RANDOM_ACCESS_LE		cpu_to_le32(0x00000800)
+#define FILE_DELETE_ON_CLOSE_LE		cpu_to_le32(0x00001000)
+#define FILE_OPEN_BY_FILE_ID_LE		cpu_to_le32(0x00002000)
+#define FILE_OPEN_FOR_BACKUP_INTENT_LE	cpu_to_le32(0x00004000)
+#define FILE_NO_COMPRESSION_LE		cpu_to_le32(0x00008000)
+#define FILE_RESERVE_OPFILTER_LE	cpu_to_le32(0x00100000)
+#define FILE_OPEN_REPARSE_POINT_LE	cpu_to_le32(0x00200000)
+#define FILE_OPEN_NO_RECALL_LE		cpu_to_le32(0x00400000)
+#define FILE_OPEN_FOR_FREE_SPACE_QUERY_LE cpu_to_le32(0x00800000)
+
+#define FILE_READ_RIGHTS_LE (FILE_READ_DATA_LE | FILE_READ_EA_LE \
+			| FILE_READ_ATTRIBUTES_LE)
+#define FILE_WRITE_RIGHTS_LE (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE \
+			| FILE_WRITE_EA_LE | FILE_WRITE_ATTRIBUTES_LE)
+#define FILE_EXEC_RIGHTS_LE (FILE_EXECUTE_LE)
+
+/* Impersonation Levels */
+#define IL_ANONYMOUS		cpu_to_le32(0x00000000)
+#define IL_IDENTIFICATION	cpu_to_le32(0x00000001)
+#define IL_IMPERSONATION	cpu_to_le32(0x00000002)
+#define IL_DELEGATE		cpu_to_le32(0x00000003)
+
+/* Create Context Values */
+#define SMB2_CREATE_EA_BUFFER			"ExtA" /* extended attributes */
+#define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
+#define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
+#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
+#define SMB2_CREATE_ALLOCATION_SIZE		"AlSi"
+#define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
+#define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
+#define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"
+#define SMB2_CREATE_REQUEST_LEASE		"RqLs"
+
+struct smb2_create_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 57 */
+	__u8   SecurityFlags;
+	__u8   RequestedOplockLevel;
+	__le32 ImpersonationLevel;
+	__le64 SmbCreateFlags;
+	__le64 Reserved;
+	__le32 DesiredAccess;
+	__le32 FileAttributes;
+	__le32 ShareAccess;
+	__le32 CreateDisposition;
+	__le32 CreateOptions;
+	__le16 NameOffset;
+	__le16 NameLength;
+	__le32 CreateContextsOffset;
+	__le32 CreateContextsLength;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_create_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 89 */
+	__u8   OplockLevel;
+	__u8   Reserved;
+	__le32 CreateAction;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 AllocationSize;
+	__le64 EndofFile;
+	__le32 FileAttributes;
+	__le32 Reserved2;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le32 CreateContextsOffset;
+	__le32 CreateContextsLength;
+	__u8   Buffer[1];
+} __packed;
+
+/* Currently defined values for close flags */
+#define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
+struct smb2_close_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 24 */
+	__le16 Flags;
+	__le32 Reserved;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+} __packed;
+
+struct smb2_close_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* 60 */
+	__le16 Flags;
+	__le32 Reserved;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
+	__le64 EndOfFile;
+	__le32 Attributes;
+} __packed;
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 825c7d0..8393802 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -57,5 +57,11 @@ extern int SMB2_tcon(unsigned int xid, struct cifs_ses *ses,
 		    const char *tree, struct cifs_tcon *tcon,
 		    const struct nls_table *);
 extern int SMB2_tdis(const int xid, struct cifs_tcon *tcon);
+extern int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
+		      u64 *persistent_fid, u64 *volatile_fid,
+		      __u32 desired_access, __u32 create_disposition,
+		      __u32 file_attributes, __u32 create_options);
+extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
+		      u64 persistent_file_id, u64 volatile_file_id);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
