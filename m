From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/19] cifs: remove rfc1002 header from smb2_create_req
Date: Thu,  2 Nov 2017 18:03:03 +1100
Message-ID: <20171102070312.18903-11-lsahlber@redhat.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 29 +++++++++++------------------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 305e4be511ba..1e012713d79b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1519,11 +1519,10 @@ add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
 	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) - 4 +
+				sizeof(struct smb2_create_req) +
 				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 		     server->vals->create_lease_size);
-	inc_rfc1001_len(&req->hdr, server->vals->create_lease_size);
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1603,10 +1602,9 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable_v2);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
-	inc_rfc1001_len(&req->hdr, sizeof(struct create_durable_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1627,12 +1625,10 @@ add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 			sizeof(struct create_durable_handle_reconnect_v2));
-	inc_rfc1001_len(&req->hdr,
-			sizeof(struct create_durable_handle_reconnect_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1663,10 +1659,9 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable));
-	inc_rfc1001_len(&req->hdr, sizeof(struct create_durable));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1737,6 +1732,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	__u32 file_attributes = 0;
 	char *dhc_buf = NULL, *lc_buf = NULL;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1745,7 +1741,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	else
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_CREATE, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_CREATE, tcon, (void **) &req, &total_len);
+
 	if (rc)
 		return rc;
 
@@ -1766,12 +1763,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
 	/* -1 since last byte is buf[0] which is sent below (path) */
-	iov[0].iov_len--;
+	iov[0].iov_len = total_len - 1;
 
-	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
+	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req));
 
 	/* [MS-SMB2] 2.2.13 NameOffset:
 	 * If SMB2_FLAGS_DFS_OPERATIONS is set in the Flags field of
@@ -1784,7 +1779,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, path);
@@ -1811,8 +1806,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	iov[1].iov_len = uni_path_len;
 	iov[1].iov_base = path;
-	/* -1 since last byte is buf[0] which was counted in smb2_buf_len */
-	inc_rfc1001_len(req, uni_path_len - 1);
 
 	if (!server->oplocks)
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
@@ -1850,7 +1843,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		dhc_buf = iov[n_iov-1].iov_base;
 	}
 
-	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 4f80b95d02ae..6e1874a81014 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -496,7 +496,7 @@ struct smb2_tree_disconnect_rsp {
 #define SVHDX_OPEN_DEVICE_CONTEXT	0x83CE6F1AD851E0986E34401CC9BCFCE9
 
 struct smb2_create_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u8   SecurityFlags;
 	__u8   RequestedOplockLevel;
-- 
2.13.3
