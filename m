From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 22/32] CIFS: Add SMB2 support for is_path_accessible
Date: Fri, 13 Jul 2012 11:53:35 +0400
Message-ID: <1342166025-29377-23-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

that needs for a successful mount through SMB2 protocol.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   61 +++++++++++++++++
 fs/cifs/cifs_unicode.h |    5 ++
 fs/cifs/smb2misc.c     |   25 +++++++
 fs/cifs/smb2ops.c      |   25 +++++++
 fs/cifs/smb2pdu.c      |  132 ++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h      |  167 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h    |    8 ++
 7 files changed, 423 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 97c1d42..7dab9c0 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -330,3 +330,64 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 ctoUTF16_out:
 	return i;
 }
+
+#ifdef CONFIG_CIFS_SMB2
+/*
+ * cifs_local_to_utf16_bytes - how long will a string be after conversion?
+ * @from - pointer to input string
+ * @maxbytes - don't go past this many bytes of input string
+ * @codepage - source codepage
+ *
+ * Walk a string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any null
+ * termination required. Don't walk past maxbytes in the source buffer.
+ */
+
+static int
+cifs_local_to_utf16_bytes(const char *from, int len,
+			  const struct nls_table *codepage)
+{
+	int charlen;
+	int i;
+	wchar_t wchar_to;
+
+	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
+		charlen = codepage->char2uni(from, len, &wchar_to);
+		/* Failed conversion defaults to a question mark */
+		if (charlen < 1)
+			charlen = 1;
+	}
+	return 2 * i; /* UTF16 characters are two bytes */
+}
+
+/*
+ * cifs_strndup_to_utf16 - copy a string to wire format from the local codepage
+ * @src - source string
+ * @maxlen - don't walk past this many bytes in the source string
+ * @utf16_len - the length of the allocated string in bytes (including null)
+ * @cp - source codepage
+ * @remap - map special chars
+ *
+ * Take a string convert it from the local codepage to UTF16 and
+ * put it in a new buffer. Returns a pointer to the new string or NULL on
+ * error.
+ */
+__le16 *
+cifs_strndup_to_utf16(const char *src, const int maxlen, int *utf16_len,
+		      const struct nls_table *cp, int remap)
+{
+	int len;
+	__le16 *dst;
+
+	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
+	len += 2; /* NULL */
+	dst = kmalloc(len, GFP_KERNEL);
+	if (!dst) {
+		*utf16_len = 0;
+		return NULL;
+	}
+	cifsConvertToUTF16(dst, src, strlen(src), cp, remap);
+	*utf16_len = len;
+	return dst;
+}
+#endif /* CONFIG_CIFS_SMB2 */
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index a44c6eb..4fb0974 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -84,6 +84,11 @@ char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const struct nls_table *codepage);
 extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
 			      const struct nls_table *cp, int mapChars);
+#ifdef CONFIG_CIFS_SMB2
+extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
+				     int *utf16_len, const struct nls_table *cp,
+				     int remap);
+#endif /* CONFIG_CIFS_SMB2 */
 #endif
 
 /*
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 10729a7..eb73a13 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -230,6 +230,11 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 		    ((struct smb2_sess_setup_rsp *)hdr)->SecurityBufferLength);
 		break;
 	case SMB2_CREATE:
+		*off = le32_to_cpu(
+		    ((struct smb2_create_rsp *)hdr)->CreateContextsOffset);
+		*len = le32_to_cpu(
+		    ((struct smb2_create_rsp *)hdr)->CreateContextsLength);
+		break;
 	case SMB2_READ:
 	case SMB2_QUERY_INFO:
 	case SMB2_QUERY_DIRECTORY:
@@ -315,3 +320,23 @@ calc_size_exit:
 	cFYI(1, "SMB2 len %d", len);
 	return len;
 }
+
+/* Note: caller must free return buffer */
+__le16 *
+cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
+{
+	int len;
+	const char *start_of_path;
+	__le16 *to;
+
+	/* Windows doesn't allow paths beginning with \ */
+	if (from[0] == '\\')
+		start_of_path = from + 1;
+	else
+		start_of_path = from;
+	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len,
+				   cifs_sb->local_nls,
+				   cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+	return to;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0e33ca3..1266137 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -157,6 +157,30 @@ smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
+static int
+smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
+			struct cifs_sb_info *cifs_sb, const char *full_path)
+{
+	int rc;
+	__u64 persistent_fid, volatile_fid;
+	__le16 *utf16_path;
+
+	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
+		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0);
+	if (rc) {
+		kfree(utf16_path);
+		return rc;
+	}
+
+	rc = SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	kfree(utf16_path);
+	return rc;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -174,6 +198,7 @@ struct smb_version_operations smb21_operations = {
 	.logoff = SMB2_logoff,
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
+	.is_path_accessible = smb2_is_path_accessible,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 48c04b2..ef0769c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -829,3 +829,135 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 
 	return rc;
 }
+
+int
+SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
+	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
+	  __u32 create_disposition, __u32 file_attributes, __u32 create_options)
+{
+	struct smb2_create_req *req;
+	struct smb2_create_rsp *rsp;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[2];
+	int resp_buftype;
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
+	rc = small_smb2_init(SMB2_CREATE, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	if (enable_oplocks)
+		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
+	else
+		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
+	req->ImpersonationLevel = IL_IMPERSONATION;
+	req->DesiredAccess = cpu_to_le32(desired_access);
+	/* File attributes ignored on open (used in create though) */
+	req->FileAttributes = cpu_to_le32(file_attributes);
+	req->ShareAccess = FILE_SHARE_ALL_LE;
+	req->CreateDisposition = cpu_to_le32(create_disposition);
+	req->CreateOptions = cpu_to_le32(create_options);
+	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
+	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req)
+			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+
+	/* MUST set path len (NameLength) to 0 opening root of share */
+	if (uni_path_len >= 4) {
+		req->NameLength = cpu_to_le16(uni_path_len - 2);
+		/* -1 since last byte is buf[0] which is sent below (path) */
+		iov[0].iov_len--;
+		iov[1].iov_len = uni_path_len;
+		iov[1].iov_base = path;
+		/*
+		 * -1 since last byte is buf[0] which was counted in
+		 * smb2_buf_len.
+		 */
+		inc_rfc1001_len(req, uni_path_len - 1);
+	} else {
+		num_iovecs = 1;
+		req->NameLength = 0;
+	}
+
+	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
+	rsp = (struct smb2_create_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
+		goto creat_exit;
+	}
+
+	if (rsp == NULL) {
+		rc = -EIO;
+		goto creat_exit;
+	}
+	*persistent_fid = rsp->PersistentFileId;
+	*volatile_fid = rsp->VolatileFileId;
+creat_exit:
+	free_rsp_buf(resp_buftype, rsp);
+	return rc;
+}
+
+int
+SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
+	   u64 persistent_fid, u64 volatile_fid)
+{
+	struct smb2_close_req *req;
+	struct smb2_close_rsp *rsp;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[1];
+	int resp_buftype;
+	int rc = 0;
+
+	cFYI(1, "Close");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
+	rsp = (struct smb2_close_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		if (tcon)
+			cifs_stats_fail_inc(tcon, SMB2_CLOSE_HE);
+		goto close_exit;
+	}
+
+	if (rsp == NULL) {
+		rc = -EIO;
+		goto close_exit;
+	}
+
+	/* BB FIXME - decode close response, update inode for caching */
+
+close_exit:
+	free_rsp_buf(resp_buftype, rsp);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index aa77bf3..5cd358e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -281,4 +281,171 @@ struct smb2_tree_disconnect_rsp {
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
index bc72993..85aa8d5 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -36,6 +36,8 @@ extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length);
 extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
 extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
+extern __le16 *cifs_convert_path_to_utf16(const char *from,
+					  struct cifs_sb_info *cifs_sb);
 
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
@@ -54,5 +56,11 @@ extern int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses,
 		     const char *tree, struct cifs_tcon *tcon,
 		     const struct nls_table *);
 extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
+extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
+		     __le16 *path, u64 *persistent_fid, u64 *volatile_fid,
+		     __u32 desired_access, __u32 create_disposition,
+		     __u32 file_attributes, __u32 create_options);
+extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
+		      u64 persistent_file_id, u64 volatile_file_id);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
