From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 12/16] CIFS: Add tree connect/disconnect capability for SMB2
Date: Mon, 26 Mar 2012 13:21:39 +0400
Message-ID: <1332753703-4315-13-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   59 ++++++++++++++++++++
 fs/cifs/cifs_unicode.h |    5 ++-
 fs/cifs/cifsglob.h     |   11 ++++-
 fs/cifs/connect.c      |   18 +++++-
 fs/cifs/smb2pdu.c      |  142 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.h      |   57 +++++++++++++++++++
 fs/cifs/smb2proto.h    |    4 ++
 7 files changed, 289 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fbb9da9..5fb7372 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -331,3 +331,62 @@ ctoUTF16_out:
 	return i;
 }
 
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
+ * @codepage - source codepage
+ *
+ * Take a string convert it from the local codepage to UTF16 and
+ * put it in a new buffer. Returns a pointer to the new string or NULL on
+ * error.
+ */
+__le16 *
+cifs_strndup_to_utf16(const char *src, const int maxlen, int *utf16_len,
+		      const struct nls_table *codepage)
+{
+	int len;
+	__le16 *dst;
+
+	len = cifs_local_to_utf16_bytes(src, maxlen, codepage);
+	len += 2; /* NULL */
+	dst = kmalloc(len, GFP_KERNEL);
+	if (!dst) {
+		*utf16_len = 0;
+		return NULL;
+	}
+	cifs_strtoUTF16(dst, src, maxlen, codepage);
+	*utf16_len = len;
+	return dst;
+}
+#endif /* CONFIG_CIFS_SMB2 */
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index a513a54..4e8f09c 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -82,9 +82,12 @@ int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_table *);
 char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const bool is_unicode,
 			      const struct nls_table *codepage);
+#ifdef CONFIG_CIFS_SMB2
+extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
+				     int *ucs_len, const struct nls_table *cp);
+#endif /* CONFIG_CIFS_SMB2 */
 extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
 			      const struct nls_table *cp, int mapChars);
-
 #endif
 
 /*
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 63eb795..0b680f6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -474,7 +474,7 @@ struct cifs_tcon {
 	char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in ASCII */
 	char *nativeFileSystem;
 	char *password;		/* for share-level security */
-	__u16 tid;		/* The 2 byte tree id */
+	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
@@ -522,6 +522,7 @@ struct cifs_tcon {
 	FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated */
 	FILE_SYSTEM_UNIX_INFO fsUnixInfo;
 	bool ipc:1;		/* set if connection to IPC$ eg for RPC/PIPES */
+	bool print:1;		/* set if connection to printer share */
 	bool retry:1;
 	bool nocase:1;
 	bool seal:1;      /* transport encryption for this mounted share */
@@ -530,6 +531,14 @@ struct cifs_tcon {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool bad_network_name:1;
+#ifdef CONFIG_CIFS_SMB2
+	__u32 capabilities;
+	__u32 share_flags;
+	__u32 maximal_access;
+	__u32 vol_serial_number;
+	__le64 vol_create_time;
+#endif /* CONFIG_CIFS_SMB2 */
 #ifdef CONFIG_CIFS_FSCACHE
 	u64 resource_id;		/* server resource id */
 	struct fscache_cookie *fscache;	/* cookie for share */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 46c203f..e067af3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2719,7 +2719,12 @@ cifs_put_tcon(struct cifs_tcon *tcon)
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
@@ -2730,7 +2735,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 static struct cifs_tcon *
 cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 {
-	int rc, xid;
+	int rc = 0, xid;
 	struct cifs_tcon *tcon;
 
 	tcon = cifs_find_tcon(ses, volume_info->UNC);
@@ -2770,7 +2775,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
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
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 28fbadc..71bf301 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -166,8 +166,8 @@ smb2_hdr_assemble(struct smb2_hdr *buffer, __le16 smb2_cmd /* command */ ,
 set_tcon_flags:
 	/* BB check following DFS flags BB */
 	/* BB do we have to add check for SHI1005_FLAGS_DFS_ROOT too? */
-	/* if (tcon->share_flags & SHI1005_FLAGS_DFS)
-		buffer->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+	if (tcon->share_flags & SHI1005_FLAGS_DFS)
+		buffer->Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 	/* BB how does SMB2 do case sensitive? */
 	/* if (tcon->nocase)
 		buffer->Flags |= SMBFLG_CASELESS; */
@@ -608,3 +608,141 @@ SMB2_logoff(const int xid, struct cifs_ses *ses)
 	 */
 	return rc;
 }
+
+static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
+{
+	/* cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[code]); */
+}
+
+int
+SMB2_tcon(unsigned int xid, struct cifs_ses *ses,
+	  const char *tree, struct cifs_tcon *tcon,
+	  const struct nls_table *cp)
+{
+	struct smb2_tree_connect_req *pSMB2;
+	struct smb2_tree_connect_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int resp_buftype;
+	int unc_path_len;
+	struct TCP_Server_Info *server;
+	__le16 *unc_path = NULL;
+
+	cFYI(1, "TCON");
+
+	if ((ses->server) && tree)
+		server = ses->server;
+	else
+		return -EIO;
+
+	if (tcon && tcon->bad_network_name)
+		return -ENOENT;
+
+	unc_path = cifs_strndup_to_utf16(tree, MAX_NAME /* BB find better */,
+					 &unc_path_len, cp);
+	if (unc_path == NULL)
+		return -ENOMEM;
+
+	if (unc_path_len < 2) {
+		kfree(unc_path);
+		return -EINVAL;
+	}
+
+	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &pSMB2);
+	if (rc) {
+		kfree(unc_path);
+		return rc;
+	}
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+					+ 4 /* rfc1001 len */ - 1 /* pad */;
+
+	/* Testing shows that buffer offset must be at location of Buffer[0] */
+	pSMB2->PathOffset = cpu_to_le16(sizeof(struct smb2_tree_connect_req)
+			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+	pSMB2->PathLength = cpu_to_le16(unc_path_len - 2);
+	iov[1].iov_base = unc_path;
+	iov[1].iov_len = unc_path_len;
+
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+			    - 1 /* pad */ + unc_path_len);
+
+	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0);
+	pSMB2r = (struct smb2_tree_connect_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2TREE_CONNECT);
+		tcon->need_reconnect = true;
+		goto tcon_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto tcon_exit;
+	}
+
+	if (pSMB2r->ShareType & SMB2_SHARE_TYPE_DISK)
+		cFYI(1, "connection to disk share");
+	else if (pSMB2r->ShareType & SMB2_SHARE_TYPE_PIPE) {
+		tcon->ipc = true;
+		cFYI(1, "connection to pipe share");
+	} else if (pSMB2r->ShareType & SMB2_SHARE_TYPE_PRINT) {
+		tcon->print = true;
+		cFYI(1, "connection to printer");
+	} else {
+		cERROR(1, "unknown share type %d", pSMB2r->ShareType);
+		rc = -EOPNOTSUPP;
+		goto tcon_exit;
+	}
+
+	tcon->share_flags = le32_to_cpu(pSMB2r->ShareFlags);
+	tcon->tidStatus = CifsGood;
+	tcon->need_reconnect = false;
+	tcon->tid = pSMB2r->hdr.TreeId;
+	if ((pSMB2r->Capabilities & SMB2_SHARE_CAP_DFS) &&
+	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
+		cERROR(1, "DFS capability contradicts DFS flag");
+
+	tcon->maximal_access = le32_to_cpu(pSMB2r->MaximalAccess);
+
+	strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
+tcon_exit:
+	if (pSMB2r->hdr.Status == cpu_to_le32(STATUS_BAD_NETWORK_NAME)) {
+		cERROR(1, "BAD_NETWORK_NAME: %s", tree);
+		tcon->bad_network_name = true;
+	}
+	free_rsp_buf(resp_buftype, pSMB2r);
+	kfree(unc_path);
+
+	return rc;
+}
+
+int SMB2_tdis(const int xid, struct cifs_tcon *tcon)
+{
+	struct smb2_tree_disconnect_req *pSMB2; /* response is trivial */
+	int rc = 0;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+
+	cFYI(1, "Tree Disconnect");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
+		return 0;
+
+	rc = small_smb2_init(SMB2_TREE_DISCONNECT, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	rc = SendReceiveNoRsp(xid, ses, (char *)&pSMB2->hdr, 0);
+	if (rc)
+		cifs_stats_fail_inc(tcon, SMB2TREE_DISCONNECT);
+
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 3886266..b7d07ff 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -218,4 +218,61 @@ struct smb2_logoff_rsp {
 	__le16 Reserved;
 } __packed;
 
+struct smb2_tree_connect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 9 */
+	__le16 Reserved;
+	__le16 PathOffset;
+	__le16 PathLength;
+	__u8   Buffer[1];	/* variable length */
+} __packed;
+
+struct smb2_tree_connect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 16 */
+	__u8   ShareType;  /* see below */
+	__u8   Reserved;
+	__le32 ShareFlags; /* see below */
+	__le32 Capabilities; /* see below */
+	__le32 MaximalAccess;
+} __packed;
+
+/* Possible ShareType values */
+#define SMB2_SHARE_TYPE_DISK	0x01
+#define SMB2_SHARE_TYPE_PIPE	0x02
+#define	SMB2_SHARE_TYPE_PRINT	0x03
+
+/*
+ * Possible ShareFlags - exactly one and only one of the first 4 caching flags
+ * must be set (any of the remaining, SHI1005, flags may be set individually
+ * or in combination.
+ */
+#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
+#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
+#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
+#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
+#define SHI1005_FLAGS_DFS				0x00000001
+#define SHI1005_FLAGS_DFS_ROOT				0x00000002
+#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
+#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
+#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
+#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
+#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
+#define SHI1005_FLAGS_ENABLE_HASH			0x00002000
+
+/* Possible share capabilities */
+#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008)
+
+struct smb2_tree_disconnect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+struct smb2_tree_disconnect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ec12d6e..bb57de3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -51,5 +51,9 @@ extern int SMB2_negotiate(unsigned int xid, struct cifs_ses *ses);
 extern int SMB2_sess_setup(unsigned int xid, struct cifs_ses *ses,
 			   const struct nls_table *nls_cp);
 extern int SMB2_logoff(const int xid, struct cifs_ses *ses);
+extern int SMB2_tcon(unsigned int xid, struct cifs_ses *ses,
+		    const char *tree, struct cifs_tcon *tcon,
+		    const struct nls_table *);
+extern int SMB2_tdis(const int xid, struct cifs_tcon *tcon);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
