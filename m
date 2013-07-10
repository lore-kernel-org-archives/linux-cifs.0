From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/8] CIFS: Simplify SMB2_open code path
Date: Wed, 10 Jul 2013 13:59:55 +0400
Message-ID: <1373450401-4135-4-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by passing a filename to a separate iovec regardless of its length.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2pdu.c |   59 ++++++++++++++++++++++-------------------------------
 fs/cifs/smb2pdu.h |    2 +-
 2 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4c046a5..9a35dcd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -894,7 +894,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	__le16 *copy_path = NULL;
 	int copy_size;
 	int rc = 0;
-	int num_iovecs = 2;
+	unsigned int num_iovecs = 2;
 	__u32 file_attributes = 0;
 
 	cifs_dbg(FYI, "create/open\n");
@@ -919,47 +919,36 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	req->CreateDisposition = cpu_to_le32(create_disposition);
 	req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
 	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
-	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req)
-			- 8 /* pad */ - 4 /* do not count rfc1001 len field */);
+	/* do not count rfc1001 len field */
+	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
 	/* MUST set path len (NameLength) to 0 opening root of share */
-	if (uni_path_len >= 4) {
-		req->NameLength = cpu_to_le16(uni_path_len - 2);
-		/* -1 since last byte is buf[0] which is sent below (path) */
-		iov[0].iov_len--;
-		if (uni_path_len % 8 != 0) {
-			copy_size = uni_path_len / 8 * 8;
-			if (copy_size < uni_path_len)
-				copy_size += 8;
-
-			copy_path = kzalloc(copy_size, GFP_KERNEL);
-			if (!copy_path)
-				return -ENOMEM;
-			memcpy((char *)copy_path, (const char *)path,
-				uni_path_len);
-			uni_path_len = copy_size;
-			path = copy_path;
-		}
-
-		iov[1].iov_len = uni_path_len;
-		iov[1].iov_base = path;
-		/*
-		 * -1 since last byte is buf[0] which was counted in
-		 * smb2_buf_len.
-		 */
-		inc_rfc1001_len(req, uni_path_len - 1);
-	} else {
-		iov[0].iov_len += 7;
-		req->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
-				req->hdr.smb2_buf_length) + 8 - 1);
-		num_iovecs = 1;
-		req->NameLength = 0;
+	req->NameLength = cpu_to_le16(uni_path_len - 2);
+	/* -1 since last byte is buf[0] which is sent below (path) */
+	iov[0].iov_len--;
+	if (uni_path_len % 8 != 0) {
+		copy_size = uni_path_len / 8 * 8;
+		if (copy_size < uni_path_len)
+			copy_size += 8;
+
+		copy_path = kzalloc(copy_size, GFP_KERNEL);
+		if (!copy_path)
+			return -ENOMEM;
+		memcpy((char *)copy_path, (const char *)path,
+			uni_path_len);
+		uni_path_len = copy_size;
+		path = copy_path;
 	}
 
+	iov[1].iov_len = uni_path_len;
+	iov[1].iov_base = path;
+	/* -1 since last byte is buf[0] which was counted in smb2_buf_len */
+	inc_rfc1001_len(req, uni_path_len - 1);
+
 	if (!server->oplocks)
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
 
@@ -976,7 +965,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		iov[num_iovecs].iov_len = sizeof(struct create_lease);
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
 		req->CreateContextsOffset = cpu_to_le32(
-			sizeof(struct smb2_create_req) - 4 - 8 +
+			sizeof(struct smb2_create_req) - 4 +
 			iov[num_iovecs-1].iov_len);
 		req->CreateContextsLength = cpu_to_le32(
 			sizeof(struct create_lease));
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f31043b..8b1025f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -428,7 +428,7 @@ struct smb2_create_req {
 	__le16 NameLength;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8   Buffer[8];
+	__u8   Buffer[0];
 } __packed;
 
 struct smb2_create_rsp {
-- 
1.7.10.4
