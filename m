Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCEE22370C
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 23:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746054957; cv=none; b=XkUs0FZ1o4Kab9xj7pr10a36V/13GPscTqC7/rBjwKUpknuf6Xa6ihKG35K1+JM28DuJO2jig/2CRxz+lxEFt8WzuV5JfFB+3fcqRKM5brcY1J/7K07MprCDfPUJQAC3D0JY5iPG3/MSarXEuvdzeqUYYp+0w/QLJSjtixRmtDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746054957; c=relaxed/simple;
	bh=sqsGVjFjp7y07fhcpub72MezjsGpmYCTeyNyAo2t6wM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E9spi7b0PNim16XHYvbpsd/Wyhg7k7TekwIHQHMM70gaLsqTmdkjZGEvUtf23yBHBRJ4mOblaShdXKmpx15Tou33gx8noPlHkuyuQvKE7/mF4zags37D5xFtH8Snt80C7mNKzXNQswAlZNqtnlpp36/DA58/SOKClyQzqciks08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=LAJ6tMRc; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="LAJ6tMRc"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1746054952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N76+wv9MAwnRQeQ/rcA4zrcbX03G2cbvh1JYOSlUL6c=;
	b=LAJ6tMRciMp/f3H9bNPnSqSTS2xm9l7rhIwfgi900NVWH/bdl9XDoPlGJ/q4N7EqFTMWht
	Kn7svRswRZdHhIAYzaq5Nrvm24a1Nsfa4E9KOYubBnfnKLpp6L6/gQzrs3aPsi00ogigiT
	0bcGp71cnQjspKD0h/P+SRuEm9TW8f19eWOZnSQ/csm9GPr3ulTJe9GjuoroPYO1lVNpHB
	07bfFlEO7PUm+IdcSfcb5vUwNd98i33dlcM+eJ9khcQjrvR1aU4Q8UlJFIdHoX0GTrJeBv
	4aaH1fyMvTWTTFAtYCd1xOlZjP+FMJgeWGf7/RYlRATxPC0fa4H/07PJ373oRA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>
Subject: [PATCH v2] smb: client: ensure aligned IO sizes
Date: Wed, 30 Apr 2025 20:15:48 -0300
Message-ID: <20250430231548.1836976-1-pc@manguebit.com>
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
 fs/smb/client/connect.c    | 23 +------------------
 fs/smb/client/file.c       |  6 ++---
 fs/smb/client/fs_context.c | 25 +++++---------------
 fs/smb/client/fs_context.h | 47 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb1ops.c    |  8 +++----
 fs/smb/client/smb2pdu.c    |  8 ++-----
 6 files changed, 62 insertions(+), 55 deletions(-)

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
index 2980941b9667..a634a34d4086 100644
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
+	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
+	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
 
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
@@ -1312,7 +1310,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 				__func__);
 			goto cifs_parse_mount_err;
 		}
-		ctx->bsize = result.uint_32;
+		ctx->bsize = CIFS_ALIGN_BSIZE(fc, result.uint_32);
 		ctx->got_bsize = true;
 		break;
 	case Opt_rasize:
@@ -1336,24 +1334,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->rasize = result.uint_32;
 		break;
 	case Opt_rsize:
-		ctx->rsize = result.uint_32;
+		ctx->rsize = CIFS_ALIGN_RSIZE(fc, result.uint_32);
 		ctx->got_rsize = true;
 		ctx->vol_rsize = ctx->rsize;
 		break;
 	case Opt_wsize:
-		ctx->wsize = result.uint_32;
+		ctx->wsize = CIFS_ALIGN_WSIZE(fc, result.uint_32);
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
index d1d29249bcdb..9e83302ce4b8 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -20,6 +20,21 @@
 		cifs_dbg(VFS, fmt, ## __VA_ARGS__);	\
 	} while (0)
 
+static inline size_t cifs_io_align(struct fs_context *fc,
+				   const char *name, size_t size)
+{
+	if (!size || !IS_ALIGNED(size, PAGE_SIZE)) {
+		cifs_errorf(fc, "unaligned %s, making it a multiple of %lu bytes\n",
+			    name, PAGE_SIZE);
+		size = umax(round_down(size, PAGE_SIZE), PAGE_SIZE);
+	}
+	return size;
+}
+
+#define CIFS_ALIGN_WSIZE(_fc, _size) cifs_io_align(_fc, "wsize", _size)
+#define CIFS_ALIGN_RSIZE(_fc, _size) cifs_io_align(_fc, "rsize", _size)
+#define CIFS_ALIGN_BSIZE(_fc, _size) cifs_io_align(_fc, "bsize", _size)
+
 enum smb_version {
 	Smb_1 = 1,
 	Smb_20,
@@ -361,4 +376,36 @@ static inline void cifs_mount_unlock(void)
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

