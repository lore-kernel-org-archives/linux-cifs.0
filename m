Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6249B1DED56;
	Mon, 31 Mar 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743428365; cv=none; b=XuSoqQ9Ns3GcXOMzUZg7bDF8C7iJtopirAMgnu4Ak//FvVPe3Uj4oABJ44/168ITmp3omXQBEnZzvEctt7rYURhgFtYBP1pdx5fcS3VOme2RIVJfMhi4GMRa1VLiK5P/KZ/fg0geh6Se10NDwlIm2KJmqoXuQ3kuMHHbQkHNtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743428365; c=relaxed/simple;
	bh=NnIIxAPZjB45AedzB5iDuK2CXRyHaMj0kenjwfruh+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IrR44uBv3RLGf6zF+heIL2AWLE3fuYNiv2tUU3KrpgaLE4FlhjxWfbyI8El1wMMzKrwdd6VoqVLlYpObEx1/wE9pvwxHiSmbsUKQ0U5HdFBJJ3mURPec3J1TBQ5E9mOM3pb8WpIxD9zvwGK2985kgOJjjFq1ZdZL6N3PWKiahpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZRBtx5dVcz2TS53;
	Mon, 31 Mar 2025 21:34:33 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B7B96140156;
	Mon, 31 Mar 2025 21:39:19 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 31 Mar
 2025 21:39:18 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <linkinjeon@kernel.org>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH next 2/3] smb: client: Store original IO parameters and prevent zero IO sizes
Date: Mon, 31 Mar 2025 21:33:14 +0800
Message-ID: <20250331133315.117666-3-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250331133315.117666-1-wangzhaolong1@huawei.com>
References: <20250331133315.117666-1-wangzhaolong1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

During mount option processing and negotiation with the server, the
original user-specified rsize/wsize values were being modified directly.
This makes it impossible to recover these values after a connection
reset, leading to potential degraded performance after reconnection.

The other problem is that When negotiating read and write sizes, there are
cases where the negotiated values might calculate to zero, especially
during reconnection when server->max_read or server->max_write might be
reset. In general, these values come from the negotiation response.
According to MS-SMB2 specification, these values should be at least 65536
bytes.

This patch improves IO parameter handling:

1. Adds vol_rsize and vol_wsize fields to store the original user-specified
   values separately from the negotiated values
2. Uses got_rsize/got_wsize flags to determine if values were
   user-specified rather than checking for non-zero values, which is more
   reliable
3. Adds a prevent_zero_iosize() helper function to ensure IO sizes are
   never negotiated down to zero, which could happen in edge cases like
   when server->max_read/write is zero

The changes make the CIFS client more resilient to unusual server
responses and reconnection scenarios, preventing potential failures
when IO sizes are calculated to be zero.

Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/client/fs_context.c |  2 ++
 fs/smb/client/fs_context.h |  3 +++
 fs/smb/client/smb1ops.c    |  6 +++---
 fs/smb/client/smb2ops.c    | 27 +++++++++++++++++++--------
 fs/smb/common/smb2pdu.h    |  3 +++
 5 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 8c73d4d60d1a..611299bcf6a4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1325,10 +1325,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->rasize = result.uint_32;
 		break;
 	case Opt_rsize:
 		ctx->rsize = result.uint_32;
 		ctx->got_rsize = true;
+		ctx->vol_rsize = ctx->rsize;
 		break;
 	case Opt_wsize:
 		ctx->wsize = result.uint_32;
 		ctx->got_wsize = true;
 		if (ctx->wsize % PAGE_SIZE != 0) {
@@ -1340,10 +1341,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 				cifs_dbg(VFS,
 					 "wsize rounded down to %d to multiple of PAGE_SIZE %ld\n",
 					 ctx->wsize, PAGE_SIZE);
 			}
 		}
+		ctx->vol_wsize = ctx->wsize;
 		break;
 	case Opt_acregmax:
 		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acregmax too large\n");
 			goto cifs_parse_mount_err;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 881bfc08667e..7516ccdc69c7 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -277,10 +277,13 @@ struct smb3_fs_context {
 	bool rdma:1;
 	bool multichannel:1;
 	bool use_client_guid:1;
 	/* reuse existing guid for multichannel */
 	u8 client_guid[SMB2_CLIENT_GUID_SIZE];
+	/* User-specified original r/wsize value */
+	unsigned int vol_rsize;
+	unsigned int vol_wsize;
 	unsigned int bsize;
 	unsigned int rasize;
 	unsigned int rsize;
 	unsigned int wsize;
 	unsigned int min_offload;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d6e2fb669c40..398f1f4d5edb 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -442,12 +442,12 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int wsize;
 
 	/* start with specified wsize, or default */
-	if (ctx->wsize)
-		wsize = ctx->wsize;
+	if (ctx->got_wsize)
+		wsize = ctx->vol_wsize;
 	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
 		wsize = CIFS_DEFAULT_IOSIZE;
 	else
 		wsize = CIFS_DEFAULT_NON_POSIX_WSIZE;
 
@@ -495,11 +495,11 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	else if (server->capabilities & CAP_LARGE_READ_X)
 		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
 	else
 		defsize = server->maxBuf - sizeof(READ_RSP);
 
-	rsize = ctx->rsize ? ctx->rsize : defsize;
+	rsize = ctx->got_rsize ? ctx->vol_rsize : defsize;
 
 	/*
 	 * no CAP_LARGE_READ_X? Then MS-CIFS states that we must limit this to
 	 * the client's MaxBufferSize.
 	 */
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4dd11eafb69d..4cd1a1f896bb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -468,33 +468,44 @@ smb2_negotiate(const unsigned int xid,
 	if (rc == -EAGAIN)
 		rc = -EHOSTDOWN;
 	return rc;
 }
 
+static inline unsigned int
+prevent_zero_iosize(unsigned int size, const char *type)
+{
+	if (size == 0) {
+		cifs_dbg(VFS, "SMB: Zero %ssize calculated, using minimum value %u\n",
+			 type, CIFS_MIN_DEFAULT_IOSIZE);
+		return CIFS_MIN_DEFAULT_IOSIZE;
+	}
+	return size;
+}
+
 static unsigned int
 smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int wsize;
 
 	/* start with specified wsize, or default */
-	wsize = ctx->wsize ? ctx->wsize : CIFS_DEFAULT_IOSIZE;
+	wsize = ctx->got_wsize ? ctx->vol_wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
-	return wsize;
+	return prevent_zero_iosize(wsize, "w");
 }
 
 static unsigned int
 smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int wsize;
 
 	/* start with specified wsize, or default */
-	wsize = ctx->wsize ? ctx->wsize : SMB3_DEFAULT_IOSIZE;
+	wsize = ctx->got_wsize ? ctx->vol_wsize : SMB3_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
 			/*
@@ -512,37 +523,37 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	}
 #endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
-	return wsize;
+	return prevent_zero_iosize(wsize, "w");
 }
 
 static unsigned int
 smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int rsize;
 
 	/* start with specified rsize, or default */
-	rsize = ctx->rsize ? ctx->rsize : CIFS_DEFAULT_IOSIZE;
+	rsize = ctx->got_rsize ? ctx->vol_rsize : CIFS_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
 
-	return rsize;
+	return prevent_zero_iosize(rsize, "r");
 }
 
 static unsigned int
 smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int rsize;
 
 	/* start with specified rsize, or default */
-	rsize = ctx->rsize ? ctx->rsize : SMB3_DEFAULT_IOSIZE;
+	rsize = ctx->got_rsize ? ctx->vol_rsize : SMB3_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
 			/*
@@ -561,11 +572,11 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 #endif
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
 
-	return rsize;
+	return prevent_zero_iosize(rsize, "r");
 }
 
 /*
  * compare two interfaces a and b
  * return 0 if everything matches.
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c7a0efda4403..764dca80c15c 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -93,10 +93,13 @@
  * pages in a single call. With PAGE_SIZE == 4k, this means we can
  * fill a single wsize request with a single call.
  */
 #define SMB3_DEFAULT_IOSIZE (4 * 1024 * 1024)
 
+/* According to MS-SMB2 specification The minimum recommended value is 65536.*/
+#define CIFS_MIN_DEFAULT_IOSIZE (65536)
+
 /*
  * SMB2 Header Definition
  *
  * "MBZ" :  Must be Zero
  * "BB"  :  BugBug, Something to check/review/analyze later
-- 
2.39.2

