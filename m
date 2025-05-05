Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95B427A443;
	Mon,  5 May 2025 22:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483276; cv=none; b=DWr+cuHASgP3W2pBWB4cb9pJ5bSvhEGqNu8ZIssaYx0baP1+igKxCRGLEDgdMkbRMLhHsF6FyuIYVJgPsZGe4s46j5Q8FNGeD6STMZUM0/VzypQDY9hLqn1GMx1n3KguO/AJIvDEsUi8HXcexvcubdwx1F1FfCuI5cUYo9huWzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483276; c=relaxed/simple;
	bh=m986+EsFPL1adcbsekZrnClXMAX0B0nD1Y8HmfjbcgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BoKIJSZBclHVuDm3ulzLfKZgRwjzs0dIYsmX4YQcbNLmwQhZH/fIor7PmAnF2lW8htMBFDFHu1DmcuxOXhsGT0k2PQcIxzym7ddzKzgiTvFKbWfsSW6FPYXPqyd0k48wGPV+UwmWukDUY020pLj2NP4foBu/sqbazKEcRktfieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dH15QH12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dH15QH12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D740C4CEEF;
	Mon,  5 May 2025 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483275;
	bh=m986+EsFPL1adcbsekZrnClXMAX0B0nD1Y8HmfjbcgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH15QH12cmYdg1FZEpld3WFEkeDBNImI9cnvWmI6O+xKJm7jOp6n+TRGW0AAwc6pV
	 QwjR3/l5jg3yPTtOSnBl3lqihWsLs1L6qXhb+SwaLuhowC8nQJ8/mvr0pWNBPXaMMA
	 DLnwwzr0Y6WUI/8WAUIOUhbEUsyJwSWYc8Qz2AvgleX+BdZ8nezZP0vRJttfLJdZyR
	 iXu6noTdX5vsAGd8kCO7FYevJ5KgnLxI0XwFm4i9V5eo7Y5z6w/FL7iikEKHlr1/Nb
	 VcoVUDDRzuh+1CH/CnnkXL4FwU+TsynWygHnfhUVIdLvcnTa2Gpx50Z6xlHOphYL+Z
	 WXn3tvgS6yaBQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Wang Zhaolong <wangzhaolong1@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 008/642] smb: client: Store original IO parameters and prevent zero IO sizes
Date: Mon,  5 May 2025 18:03:44 -0400
Message-Id: <20250505221419.2672473-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Wang Zhaolong <wangzhaolong1@huawei.com>

[ Upstream commit 287906b20035a04a234d1a3c64f760a5678387be ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c |  2 ++
 fs/smb/client/fs_context.h |  3 +++
 fs/smb/client/smb1ops.c    |  6 +++---
 fs/smb/client/smb2ops.c    | 27 +++++++++++++++++++--------
 fs/smb/common/smb2pdu.h    |  3 +++
 5 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e38521a713a6b..00af8dd5aa689 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1327,6 +1327,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_rsize:
 		ctx->rsize = result.uint_32;
 		ctx->got_rsize = true;
+		ctx->vol_rsize = ctx->rsize;
 		break;
 	case Opt_wsize:
 		ctx->wsize = result.uint_32;
@@ -1342,6 +1343,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 					 ctx->wsize, PAGE_SIZE);
 			}
 		}
+		ctx->vol_wsize = ctx->wsize;
 		break;
 	case Opt_acregmax:
 		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 881bfc08667e7..7516ccdc69c71 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -279,6 +279,9 @@ struct smb3_fs_context {
 	bool use_client_guid:1;
 	/* reuse existing guid for multichannel */
 	u8 client_guid[SMB2_CLIENT_GUID_SIZE];
+	/* User-specified original r/wsize value */
+	unsigned int vol_rsize;
+	unsigned int vol_wsize;
 	unsigned int bsize;
 	unsigned int rasize;
 	unsigned int rsize;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e28cdaca47e12..73a689b4ccdff 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -437,8 +437,8 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	unsigned int wsize;
 
 	/* start with specified wsize, or default */
-	if (ctx->wsize)
-		wsize = ctx->wsize;
+	if (ctx->got_wsize)
+		wsize = ctx->vol_wsize;
 	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
 		wsize = CIFS_DEFAULT_IOSIZE;
 	else
@@ -490,7 +490,7 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	else
 		defsize = server->maxBuf - sizeof(READ_RSP);
 
-	rsize = ctx->rsize ? ctx->rsize : defsize;
+	rsize = ctx->got_rsize ? ctx->vol_rsize : defsize;
 
 	/*
 	 * no CAP_LARGE_READ_X? Then MS-CIFS states that we must limit this to
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6f89e087629fe..6795970d4de6e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -467,6 +467,17 @@ smb2_negotiate(const unsigned int xid,
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
@@ -474,12 +485,12 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
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
@@ -489,7 +500,7 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	unsigned int wsize;
 
 	/* start with specified wsize, or default */
-	wsize = ctx->wsize ? ctx->wsize : SMB3_DEFAULT_IOSIZE;
+	wsize = ctx->got_wsize ? ctx->vol_wsize : SMB3_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
@@ -511,7 +522,7 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
-	return wsize;
+	return prevent_zero_iosize(wsize, "w");
 }
 
 static unsigned int
@@ -521,13 +532,13 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
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
@@ -537,7 +548,7 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	unsigned int rsize;
 
 	/* start with specified rsize, or default */
-	rsize = ctx->rsize ? ctx->rsize : SMB3_DEFAULT_IOSIZE;
+	rsize = ctx->got_rsize ? ctx->vol_rsize : SMB3_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
@@ -560,7 +571,7 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
 
-	return rsize;
+	return prevent_zero_iosize(rsize, "r");
 }
 
 /*
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 12f0013334057..f79a5165a7cc6 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -95,6 +95,9 @@
  */
 #define SMB3_DEFAULT_IOSIZE (4 * 1024 * 1024)
 
+/* According to MS-SMB2 specification The minimum recommended value is 65536.*/
+#define CIFS_MIN_DEFAULT_IOSIZE (65536)
+
 /*
  * SMB2 Header Definition
  *
-- 
2.39.5

