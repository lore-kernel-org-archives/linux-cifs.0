Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2389514D29B;
	Thu, 13 Nov 2025 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040844; cv=none; b=cQsQpoT7pp9y/mGt2jNJKdah4/BxrzzDto/KkPyNrwTXKRFS+xn3OaB3C2A1xlgUJJx9ORIBR2GfHkALx/+xnwdnRSRN12jldXS+kYXvVupnka7PcNqGNUTjrzcJdvuVLcdmvlz7B7sWI8+nLo1g1w6Pt7HEMUTm42GPsy9n3j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040844; c=relaxed/simple;
	bh=ikLyEdaCUo9WLG8K1FTgAiYPHueysGRCYA6PFeW/WEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIv3x11Wtc63O+fDRlf4o37FmtnDfO3zhYYJgbOg138AFlfZhfcjvwoRZKsJVSwnqQRwPCxW530mbO0Xl0dl7bUVWgXDGBRc4kba3a6Tyy+cF28JWfy4ehvCmqsxWL5hMSJcwx8+zs1ib7qR2rrrgDXGFiAXrtm6ImCyMr5UDZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uiFK6daT; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uiFK6daT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763040840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hs1JLI/35Ghz3IgAayGVgAQ3vDq1x2PIxTegjsU4v2E=;
	b=uiFK6daT4/a4zANfY/kbLkOaQ+1cn3jz2bx47VZjVEx+vbGiNKqrjtEDBZwZwysBNzqTXR
	+DOwT5Jx5MLA5PN8zvDb4Ibb21B2NanAuHeSMuM/xlf3ShfFBPHf4byZNIOvd6/FWNiGTl
	2Pn3VcgiiILDZ6yedDj92QypLwkMP5I=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v7 1/2] smb: move CREATE_DURABLE_RECONN to common/smb2pdu.h
Date: Thu, 13 Nov 2025 21:32:51 +0800
Message-ID: <20251113133252.145867-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The fields in struct create_durable_reconn_req and struct create_durable
are exactly the same, so remove create_durable_reconn_req from server,
and use typedef to define both CREATE_DURABLE_REQ and CREATE_DURABLE_RECONN
for a single struct.

Rename the following places:

  - struct create_durable -> CREATE_DURABLE_REQ
  - struct create_durable_reconn_req -> CREATE_DURABLE_RECONN

The documentation references are:

  - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
  - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
  - SMB2_FILEID in MS-SMB2 2.2.14.1

Descriptions of the struct fields:

  - __u8  Reserved[16]: DurableRequest field of SMB2_CREATE_DURABLE_HANDLE_REQUEST.
                        A 16-byte field that MUST be reserved.
  - __u64 PersistentFileId: Persistent field of 2.2.14.1 SMB2_FILEID
  - __u64 VolatileFileId: Volatile field of 2.2.14.1 SMB2_FILEID
  - struct Fid: Data field of SMB2_CREATE_DURABLE_HANDLE_RECONNECT.
                An SMB2_FILEID structure, as specified in section 2.2.14.1.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 23 +++++++++++------------
 fs/smb/common/smb2pdu.h |  4 ++--
 fs/smb/server/smb2pdu.c |  6 +++---
 fs/smb/server/smb2pdu.h | 12 ------------
 4 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 62ced22fc5a6..30c391424022 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2229,21 +2229,20 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
-
-static struct create_durable *
+static CREATE_DURABLE_REQ *
 create_durable_buf(void)
 {
-	struct create_durable *buf;
+	CREATE_DURABLE_REQ *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(CREATE_DURABLE_REQ), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable, Data));
+					(CREATE_DURABLE_REQ, Data));
 	buf->ccontext.DataLength = cpu_to_le32(16);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable, Name));
+				(CREATE_DURABLE_REQ, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DHnQ" */
 	buf->Name[0] = 'D';
@@ -2253,20 +2252,20 @@ create_durable_buf(void)
 	return buf;
 }
 
-static struct create_durable *
+static CREATE_DURABLE_REQ *
 create_reconnect_durable_buf(struct cifs_fid *fid)
 {
-	struct create_durable *buf;
+	CREATE_DURABLE_REQ *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(CREATE_DURABLE_REQ), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable, Data));
+					(CREATE_DURABLE_REQ, Data));
 	buf->ccontext.DataLength = cpu_to_le32(16);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable, Name));
+				(CREATE_DURABLE_REQ, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	buf->Data.Fid.PersistentFileId = fid->persistent_fid;
 	buf->Data.Fid.VolatileFileId = fid->volatile_fid;
@@ -2552,7 +2551,7 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 		iov[num].iov_base = create_durable_buf();
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_durable);
+	iov[num].iov_len = sizeof(CREATE_DURABLE_REQ);
 	*num_iovec = num + 1;
 	return 0;
 }
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 824d27297bec..d0777fbfd503 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1265,7 +1265,7 @@ struct create_posix {
 } __packed;
 
 /* See MS-SMB2 2.2.13.2.3 and MS-SMB2 2.2.13.2.4 */
-struct create_durable {
+typedef struct {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	union {
@@ -1275,7 +1275,7 @@ struct create_durable {
 			__u64 VolatileFileId;
 		} Fid;
 	} Data;
-} __packed;
+} __packed CREATE_DURABLE_REQ, CREATE_DURABLE_RECONN;
 
 /* See MS-SMB2 2.2.13.2.5 */
 struct create_mxac_req {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 95186fa96080..e7edb52e6e40 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2766,7 +2766,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		}
 		case DURABLE_RECONN:
 		{
-			struct create_durable_reconn_req *recon;
+			CREATE_DURABLE_RECONN *recon;
 
 			if (dh_info->type == DURABLE_RECONN_V2 ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2776,12 +2776,12 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_reconn_req)) {
+			    sizeof(CREATE_DURABLE_RECONN)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon = (struct create_durable_reconn_req *)context;
+			recon = (CREATE_DURABLE_RECONN *)context;
 			persistent_id = recon->Data.Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index b94de41049f4..66cdc8e4a648 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -68,18 +68,6 @@ struct preauth_integrity_info {
 
 #define DURABLE_HANDLE_MAX_TIMEOUT	300000
 
-struct create_durable_reconn_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	union {
-		__u8  Reserved[16];
-		struct {
-			__u64 PersistentFileId;
-			__u64 VolatileFileId;
-		} Fid;
-	} Data;
-} __packed;
-
 struct create_alloc_size_req {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
-- 
2.43.0

