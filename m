Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B780786353
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939920; cv=none; b=RV0GmAeVytSpGSwPQBy4NiBC8qC5HFjBuOsdmTNxRJQFN5CBoU1WjetFIuNeHZuyNpzi/3FGg1xMlF/2x44dCabwksjQcFgxc9YEGyOVQmG4yKBsbVMh2delqyMRsleDBvCDR5iv5nP6a9PGyCgN8ZR7bBUSxWdXz88b5VnN370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939920; c=relaxed/simple;
	bh=vrliqj2uN8XIq9SOvb3v3BNqPou80OApoJjqQEG2/r8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=reULWzTNToCC0aS2THppPgCi+Ac3Q66Y1KO8q3uBnPsaeBSiCWbrwuDW7l6qtkyfN94GBtqvwluWh0s9ctxTslHHO/72rF/lcxoyHlXP/hBANPHL8N1bxtHBZlPfyT1uD72BDL7UwK4ep7YHi2VUAUR6xZ15e1DRtVaNSfjTiHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fBsolWtF; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fBsolWtF"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745939911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QiVlUinJnWX9uiGyZ3vdcDxbuvprjYxciKjoRC+UQpw=;
	b=fBsolWtFWZlQTaYhZRI2BTb9+pFaoMyI6+bWPAMMrSMPRk8dRfu2XfPEVXXVuGOHNglMC3
	dDSyvXHLP4IMxBHXK+4JLbVFVwzs3uYK8F2i9SuaK0S3ay4YYjqNm873Gm9OcJZh0s5WVT
	t73fn6VpLpmabptne4z2SUPOdm4r+NDn2lK1feXutry9UKBG/V0w1ogMBLzfpa25U4Hu0y
	tweUz8wemmQAlMKtrUpC1nBP4X0Qf/hCWUoMJhywhvgZH2jcxQymwd5dARdTj7WVhb7bmY
	XU3ag+F9tDALfXYDUXCMgN6MD9ALGulqsjq3nPonAkKYHW9Rl/RLkb2deDUF1Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>
Subject: [PATCH] smb: client: ensure aligned IO sizes
Date: Tue, 29 Apr 2025 12:18:27 -0300
Message-ID: <20250429151827.1677612-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make all IO sizes multiple of PAGE_SIZE, either negotiated by the
server or passed through rsize, wsize and bsize mount options, to
prevent from breaking DIO reads and writes against servers that
enforce alignment as specified in MS-FSA 2.1.5.3 and 2.1.5.4.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h   |  2 ++
 fs/smb/client/connect.c    | 23 +----------------------
 fs/smb/client/file.c       |  6 ++----
 fs/smb/client/fs_context.c | 25 ++++++-------------------
 fs/smb/client/fs_context.h | 32 ++++++++++++++++++++++++++++++++
 fs/smb/client/smb1ops.c    |  8 ++++----
 fs/smb/client/smb2pdu.c    |  8 ++------
 7 files changed, 49 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3b32116b0b49..24c2cd9532a9 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1024,6 +1024,8 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
 #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
+#define CIFS_IO_ALIGN(v) umax(round_down((v), PAGE_SIZE), PAGE_SIZE)
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index df976ce6aed9..6bf04d9a5491 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3753,28 +3753,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 		}
 	}
 
-	/*
-	 * Clamp the rsize/wsize mount arguments if they are too big for the server
-	 * and set the rsize/wsize to the negotiated values if not passed in by
-	 * the user on mount
-	 */
-	if ((cifs_sb->ctx->wsize == 0) ||
-	    (cifs_sb->ctx->wsize > server->ops->negotiate_wsize(tcon, ctx))) {
-		cifs_sb->ctx->wsize =
-			round_down(server->ops->negotiate_wsize(tcon, ctx), PAGE_SIZE);
-		/*
-		 * in the very unlikely event that the server sent a max write size under PAGE_SIZE,
-		 * (which would get rounded down to 0) then reset wsize to absolute minimum eg 4096
-		 */
-		if (cifs_sb->ctx->wsize == 0) {
-			cifs_sb->ctx->wsize = PAGE_SIZE;
-			cifs_dbg(VFS, "wsize too small, reset to minimum ie PAGE_SIZE, usually 4096\n");
-		}
-	}
-	if ((cifs_sb->ctx->rsize == 0) ||
-	    (cifs_sb->ctx->rsize > server->ops->negotiate_rsize(tcon, ctx)))
-		cifs_sb->ctx->rsize = server->ops->negotiate_rsize(tcon, ctx);
-
+	cifs_negotiate_iosize(server, cifs_sb->ctx, tcon);
 	/*
 	 * The cookie is initialized from volume info returned above.
 	 * Inside cifs_fscache_get_super_cookie it checks
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9e8f404b9e56..851b74f557c1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -160,10 +160,8 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 	rdata->server = server;
 
-	if (cifs_sb->ctx->rsize == 0)
-		cifs_sb->ctx->rsize =
-			server->ops->negotiate_rsize(tlink_tcon(req->cfile->tlink),
-						     cifs_sb->ctx);
+	cifs_negotiate_rsize(server, cifs_sb->ctx,
+			     tlink_tcon(req->cfile->tlink));
 
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 					   &size, &rdata->credits);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2980941b9667..f8fef852a9fb 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1021,6 +1021,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	int rc;
@@ -1103,11 +1104,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, iocharset);
 
 	/* if rsize or wsize not passed in on remount, use previous values */
-	if (ctx->rsize == 0)
-		ctx->rsize = cifs_sb->ctx->rsize;
-	if (ctx->wsize == 0)
-		ctx->wsize = cifs_sb->ctx->wsize;
-
+	ctx->rsize = !rsize ? cifs_sb->ctx->rsize : CIFS_IO_ALIGN(rsize);
+	ctx->wsize = !wsize ? cifs_sb->ctx->wsize : CIFS_IO_ALIGN(wsize);
 
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
@@ -1312,7 +1310,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 				__func__);
 			goto cifs_parse_mount_err;
 		}
-		ctx->bsize = result.uint_32;
+		ctx->bsize = CIFS_IO_ALIGN(result.uint_32);
 		ctx->got_bsize = true;
 		break;
 	case Opt_rasize:
@@ -1336,24 +1334,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->rasize = result.uint_32;
 		break;
 	case Opt_rsize:
-		ctx->rsize = result.uint_32;
+		ctx->rsize = CIFS_IO_ALIGN(result.uint_32);
 		ctx->got_rsize = true;
 		ctx->vol_rsize = ctx->rsize;
 		break;
 	case Opt_wsize:
-		ctx->wsize = result.uint_32;
+		ctx->wsize = CIFS_IO_ALIGN(result.uint_32);
 		ctx->got_wsize = true;
-		if (ctx->wsize % PAGE_SIZE != 0) {
-			ctx->wsize = round_down(ctx->wsize, PAGE_SIZE);
-			if (ctx->wsize == 0) {
-				ctx->wsize = PAGE_SIZE;
-				cifs_dbg(VFS, "wsize too small, reset to minimum %ld\n", PAGE_SIZE);
-			} else {
-				cifs_dbg(VFS,
-					 "wsize rounded down to %d to multiple of PAGE_SIZE %ld\n",
-					 ctx->wsize, PAGE_SIZE);
-			}
-		}
 		ctx->vol_wsize = ctx->wsize;
 		break;
 	case Opt_acregmax:
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index d1d29249bcdb..6ae51e27b4ce 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -361,4 +361,36 @@ static inline void cifs_mount_unlock(void)
 	mutex_unlock(&cifs_mount_mutex);
 }
 
+static inline void cifs_negotiate_rsize(struct TCP_Server_Info *server,
+					struct smb3_fs_context *ctx,
+					struct cifs_tcon *tcon)
+{
+	unsigned int size;
+
+	size = umax(server->ops->negotiate_rsize(tcon, ctx), PAGE_SIZE);
+	if (ctx->rsize)
+		size = umax(umin(ctx->rsize, size), PAGE_SIZE);
+	ctx->rsize = round_down(size, PAGE_SIZE);
+}
+
+static inline void cifs_negotiate_wsize(struct TCP_Server_Info *server,
+					struct smb3_fs_context *ctx,
+					struct cifs_tcon *tcon)
+{
+	unsigned int size;
+
+	size = umax(server->ops->negotiate_wsize(tcon, ctx), PAGE_SIZE);
+	if (ctx->wsize)
+		size = umax(umin(ctx->wsize, size), PAGE_SIZE);
+	ctx->wsize = round_down(size, PAGE_SIZE);
+}
+
+static inline void cifs_negotiate_iosize(struct TCP_Server_Info *server,
+					 struct smb3_fs_context *ctx,
+					 struct cifs_tcon *tcon)
+{
+	cifs_negotiate_rsize(server, ctx, tcon);
+	cifs_negotiate_wsize(server, ctx, tcon);
+}
+
 #endif
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 0adeec652dc1..b5c9915a97c8 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -432,7 +432,7 @@ cifs_negotiate(const unsigned int xid,
 }
 
 static unsigned int
-cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
+smb1_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -467,7 +467,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 }
 
 static unsigned int
-cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
+smb1_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -1161,8 +1161,8 @@ struct smb_version_operations smb1_operations = {
 	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
 	.negotiate = cifs_negotiate,
-	.negotiate_wsize = cifs_negotiate_wsize,
-	.negotiate_rsize = cifs_negotiate_rsize,
+	.negotiate_wsize = smb1_negotiate_wsize,
+	.negotiate_rsize = smb1_negotiate_rsize,
 	.sess_setup = CIFS_SessSetup,
 	.logoff = CIFSSMBLogoff,
 	.tree_connect = CIFSTCon,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c4d52bebd37d..4590beb549e9 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4092,12 +4092,8 @@ static void cifs_renegotiate_iosize(struct TCP_Server_Info *server,
 		return;
 
 	spin_lock(&tcon->sb_list_lock);
-	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
-		cifs_sb->ctx->rsize =
-			server->ops->negotiate_rsize(tcon, cifs_sb->ctx);
-		cifs_sb->ctx->wsize =
-			server->ops->negotiate_wsize(tcon, cifs_sb->ctx);
-	}
+	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link)
+		cifs_negotiate_iosize(server, cifs_sb->ctx, tcon);
 	spin_unlock(&tcon->sb_list_lock);
 }
 
-- 
2.49.0

