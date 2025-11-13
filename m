Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FC52D839C
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 09:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763026040; cv=none; b=K275SZWGehuH2FPvN9Lr5C1lSNeK0uHXBK933lNRT6ZZyAAVB2P/4OrK+Ak366ZN7tAMui1+9fhcQquTujj5WLhZYvPa+jOPkSqukjJ9C8kRORf3CfLK6ubvikRE0PLVEBDHroKFgKt4cTTXkfJMltFLARJZtzqHlQc2czIr7CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763026040; c=relaxed/simple;
	bh=QDXRB2ff6+kUMzKvs1zlho1XpysqI6Bc9Yq5aocDng4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKMouuGPSgnvx2IpQakMjSdsvpKMVRmyfPYYPYMgeto5iQkgCdmxVHM0ZOyoRsdPcrjCRTeubK/4CLLmd3cmo3a0BGFjfD/IXM03cRAPurJd6JDeOLk1njGYTcRtx3vsKMClM6hY48gaNOdUgnfsDfOp5zRdyCM4mfuXdhsmA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=syNL3O+c; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="syNL3O+c"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763026034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeCGFU5DwaZxXclQMZVj6wcWtauhyxy0IKP+39RJOc0=;
	b=syNL3O+cRFOjJTasqG/S3soUBGfkF+aDReSA75To8nFmtVwte/6ua9yk385NpodeaH3hi5
	QMyIMYjqsmeagR/zCLUBiVp4j5a5DWJ4eUD5Gy43caoSJLmBlePD2ZnBntyVLxPhw3qmgb
	8cYxmUxw7Aybf17oxaxfncIGXU/QwFI=
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
Subject: [PATCH v6 1/2] smb: move CREATE_DURABLE_RECONN_REQ to common/smb2pdu.h
Date: Thu, 13 Nov 2025 17:26:01 +0800
Message-ID: <20251113092602.24733-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113092602.24733-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251113092602.24733-1-chenxiaosong.chenxiaosong@linux.dev>
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
and use typedef to define both CREATE_DURABLE and CREATE_DURABLE_RECONN_REQ
for a single struct.

Rename the following places:

  - struct create_durable -> CREATE_DURABLE
  - struct create_durable_reconn_req -> CREATE_DURABLE_RECONN_REQ

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
index 62ced22fc5a6..5cf724ccdc75 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2229,21 +2229,20 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
-
-static struct create_durable *
+static CREATE_DURABLE *
 create_durable_buf(void)
 {
-	struct create_durable *buf;
+	CREATE_DURABLE *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(CREATE_DURABLE), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable, Data));
+					(CREATE_DURABLE, Data));
 	buf->ccontext.DataLength = cpu_to_le32(16);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable, Name));
+				(CREATE_DURABLE, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DHnQ" */
 	buf->Name[0] = 'D';
@@ -2253,20 +2252,20 @@ create_durable_buf(void)
 	return buf;
 }
 
-static struct create_durable *
+static CREATE_DURABLE *
 create_reconnect_durable_buf(struct cifs_fid *fid)
 {
-	struct create_durable *buf;
+	CREATE_DURABLE *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(CREATE_DURABLE), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable, Data));
+					(CREATE_DURABLE, Data));
 	buf->ccontext.DataLength = cpu_to_le32(16);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable, Name));
+				(CREATE_DURABLE, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	buf->Data.Fid.PersistentFileId = fid->persistent_fid;
 	buf->Data.Fid.VolatileFileId = fid->volatile_fid;
@@ -2552,7 +2551,7 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 		iov[num].iov_base = create_durable_buf();
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_durable);
+	iov[num].iov_len = sizeof(CREATE_DURABLE);
 	*num_iovec = num + 1;
 	return 0;
 }
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 824d27297bec..592b22e3d0c7 100644
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
+} __packed CREATE_DURABLE, CREATE_DURABLE_RECONN_REQ;
 
 /* See MS-SMB2 2.2.13.2.5 */
 struct create_mxac_req {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 95186fa96080..780cdb7dc6cf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2766,7 +2766,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		}
 		case DURABLE_RECONN:
 		{
-			struct create_durable_reconn_req *recon;
+			CREATE_DURABLE_RECONN_REQ *recon;
 
 			if (dh_info->type == DURABLE_RECONN_V2 ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2776,12 +2776,12 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_reconn_req)) {
+			    sizeof(CREATE_DURABLE_RECONN_REQ)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon = (struct create_durable_reconn_req *)context;
+			recon = (CREATE_DURABLE_RECONN_REQ *)context;
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

