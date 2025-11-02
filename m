Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5488F2676F4
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068755; cv=none; b=WvWpzfrz9/axTFHLF5w3BA6n6ZVCdYfWTdrThQk+HX3Tdo0g1JPmeReXRV1ELuEQtdxGzTpe5cG3EkFZ6Gn7SyCdPBOXWrUhHYm/cZVnKKMTQlrxWcpBXNeOM7CfL0R6zm06UAdNCd2UWnBx8WLrGVC2sZPQHfF3DGBl5eZXgZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068755; c=relaxed/simple;
	bh=0/6q2C6ehyRwr9T4Tp/tUTqnjpKl+as+r0wsXQQYwUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8fFl0FDP2nlxd0s9ADGJzKycJ3qiYx39ZqlK1ALywUN8CMLV0USaAme/T5QNW99DBoWv/Pt6lKqUwh6jbvy70kR+4Ez26NFT0likdp2e9Ey4W5GPpOiXWYPS8bPLI/TP79cGnw3fkAkQS8eohHTdkbaVfTAXweTPJQto4BBSSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ia633YEm; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ia633YEm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yjl/bhHhHfCb9ypAHpnQxPBT5SeWGv+8sMRDL0lfiTc=;
	b=Ia633YEmt+KUaAd51bbFVQ6a1+gZUT+0SkhK6rXRPnSyWexf3JVxsq0GgLARqwJd4fssTk
	dzqz8wYtHw68H9tSbjux3aBREJ0/gBb5vu2Y4sOcqNH7sdy7XoIr/KZSt3+Yz/kzMpR8kw
	HnjuNktcYHbR+ObY/+t/IcWGgCkINIE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 06/14] smb/server: remove create_durable_reconn_req
Date: Sun,  2 Nov 2025 15:30:51 +0800
Message-ID: <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
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
are exactly the same.

The documentation references are:

  - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
  - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
  - SMB2_FILEID in MS-SMB2 2.2.14.1

We can give these two structs a uniform name: create_durable.

Descriptions of the struct fields:

  - __u8  Reserved[16]: DurableRequest field of SMB2_CREATE_DURABLE_HANDLE_REQUEST.
                        A 16-byte field that MUST be reserved.
  - __u64 PersistentFileId: Persistent field of 2.2.14.1 SMB2_FILEID
  - __u64 VolatileFileId: Volatile field of 2.2.14.1 SMB2_FILEID
  - struct Fid: Data field of SMB2_CREATE_DURABLE_HANDLE_RECONNECT.
                An SMB2_FILEID structure, as specified in section 2.2.14.1.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c |  6 +++---
 fs/smb/server/smb2pdu.h | 12 ------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c972b2dd62cd..b95ca0de60c3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2766,7 +2766,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		}
 		case DURABLE_RECONN:
 		{
-			struct create_durable_reconn_req *recon;
+			struct create_durable *recon;
 
 			if (dh_info->type == DURABLE_RECONN_V2 ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2776,12 +2776,12 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_reconn_req)) {
+			    sizeof(struct create_durable)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon = (struct create_durable_reconn_req *)context;
+			recon = (struct create_durable *)context;
 			persistent_id = recon->Data.Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 46e14bd4f2da..7758aa01034d 100644
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

