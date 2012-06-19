From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 09/22] CIFS: Add tree connect/disconnect capability for SMB2
Date: Tue, 19 Jun 2012 16:39:58 +0400
Message-ID: <1340109611-7210-10-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |    1 -
 fs/cifs/cifs_unicode.h |    1 -
 fs/cifs/cifsglob.h     |   11 +++-
 fs/cifs/smb2ops.c      |    2 +
 fs/cifs/smb2pdu.c      |  161 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.h      |   57 +++++++++++++++++
 fs/cifs/smb2proto.h    |    4 +
 7 files changed, 232 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fbb9da9..97c1d42 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -330,4 +330,3 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 ctoUTF16_out:
 	return i;
 }
-
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index a513a54..a44c6eb 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -84,7 +84,6 @@ char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const struct nls_table *codepage);
 extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
 			      const struct nls_table *cp, int mapChars);
-
 #endif
 
 /*
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fb9c8ff..3215026 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -522,7 +522,7 @@ struct cifs_tcon {
 	char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in ASCII */
 	char *nativeFileSystem;
 	char *password;		/* for share-level security */
-	__u16 tid;		/* The 2 byte tree id */
+	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
@@ -578,6 +578,15 @@ struct cifs_tcon {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+#ifdef CONFIG_CIFS_SMB2
+	bool print:1;		/* set if connection to printer share */
+	bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
+	__u32 capabilities;
+	__u32 share_flags;
+	__u32 maximal_access;
+	__u32 vol_serial_number;
+	__le64 vol_create_time;
+#endif /* CONFIG_CIFS_SMB2 */
 #ifdef CONFIG_CIFS_FSCACHE
 	u64 resource_id;		/* server resource id */
 	struct fscache_cookie *fscache;	/* cookie for share */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b642184..a904b35 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -171,6 +171,8 @@ struct smb_version_operations smb21_operations = {
 	.negotiate = smb2_negotiate,
 	.sess_setup = SMB2_sess_setup,
 	.logoff = SMB2_logoff,
+	.tree_connect = SMB2_tcon,
+	.tree_disconnect = SMB2_tdis,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 74045b4..3d1d51d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -114,8 +114,8 @@ smb2_hdr_assemble(struct smb2_hdr *buffer, __le16 smb2_cmd /* command */ ,
 		buffer->SessionId = tcon->ses->Suid;
 	/* BB check following DFS flags BB */
 	/* BB do we have to add check for SHI1005_FLAGS_DFS_ROOT too? */
-	/* if (tcon->share_flags & SHI1005_FLAGS_DFS)
-		buffer->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+	if (tcon->share_flags & SHI1005_FLAGS_DFS)
+		buffer->Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 	/* BB how does SMB2 do case sensitive? */
 	/* if (tcon->nocase)
 		buffer->Flags |= SMBFLG_CASELESS; */
@@ -557,3 +557,160 @@ SMB2_logoff(const int xid, struct cifs_ses *ses)
 	 */
 	return rc;
 }
+
+static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
+{
+	/* cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[code]); */
+}
+
+#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
+
+int
+SMB2_tcon(const int xid, struct cifs_ses *ses, const char *tree,
+	  struct cifs_tcon *tcon, const struct nls_table *cp)
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
+	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
+	if (unc_path == NULL)
+		return -ENOMEM;
+
+	unc_path_len = cifs_strtoUTF16(unc_path, tree, strlen(tree), cp) + 1;
+	unc_path_len *= 2;
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
+	if (tcon == NULL) {
+		/* since no tcon, smb2_init can not do this, so do here */
+		pSMB2->hdr.SessionId = ses->Suid;
+		if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
+			pSMB2->hdr.Flags |= SMB2_FLAGS_SIGNED;
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
+		if (tcon) {
+			cifs_stats_fail_inc(tcon, SMB2TREE_CONNECT);
+			tcon->need_reconnect = true;
+		}
+		goto tcon_error_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto tcon_exit;
+	}
+
+	if (tcon == NULL) {
+		ses->ipc_tid = pSMB2r->hdr.TreeId;
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
+		goto tcon_error_exit;
+	}
+
+	tcon->share_flags = le32_to_cpu(pSMB2r->ShareFlags);
+	tcon->maximal_access = le32_to_cpu(pSMB2r->MaximalAccess);
+	tcon->tidStatus = CifsGood;
+	tcon->need_reconnect = false;
+	tcon->tid = pSMB2r->hdr.TreeId;
+	strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
+
+	if ((pSMB2r->Capabilities & SMB2_SHARE_CAP_DFS) &&
+	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
+		cERROR(1, "DFS capability contradicts DFS flag");
+
+tcon_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	kfree(unc_path);
+	return rc;
+
+tcon_error_exit:
+	if (pSMB2r->hdr.Status == cpu_to_le32(STATUS_BAD_NETWORK_NAME)) {
+		cERROR(1, "BAD_NETWORK_NAME: %s", tree);
+		tcon->bad_network_name = true;
+	}
+	goto tcon_exit;
+}
+
+int
+SMB2_tdis(const int xid, struct cifs_tcon *tcon)
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
index e63b529..007de36 100644
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
index f4375bf..0d51482 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -50,5 +50,9 @@ extern int SMB2_negotiate(const int xid, struct cifs_ses *ses);
 extern int SMB2_sess_setup(const int xid, struct cifs_ses *ses,
 			   const struct nls_table *nls_cp);
 extern int SMB2_logoff(const int xid, struct cifs_ses *ses);
+extern int SMB2_tcon(const int xid, struct cifs_ses *ses,
+		     const char *tree, struct cifs_tcon *tcon,
+		     const struct nls_table *);
+extern int SMB2_tdis(const int xid, struct cifs_tcon *tcon);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
