Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FABF3D6CB2
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589249; cv=none; b=Ya4Ovzu3lNkAHyM6oCCeDNYmvGFDxG3i0NR38iSYuR7n4u02r/GvCaaGg6cuRKn8ooQi+h67Dkr8oUGfhiiA6CiheZ2bCbMO23hdbU6qLeT2cngxOl8mQ/dAsiuTU2pz35rfFB7DLNj1K4TktDrEViOXGY4rI1vBTizzH+Q7Dr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589249; c=relaxed/simple;
	bh=l7QZIOTNwrq3vH/zCBV2W7ozWeP6Z5nR0d4LN+vuDxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgyHcvHVp4Nh9MeJomhCoXGJBp6vMgunKtIvYH4sijGPelJm3Bkp+srJNOw2sMQ1gj75YK4keOgwejdNESW1uPoO/9s4SPlZ6Xy5JXa6K7o79/YzMgUYp2HQ6QUi1Y99mECQ3SEHPSr6JGZSZKBiRyMaJ6vpNTZlwp0A/VNc16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z37kafq/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z37kafq/"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c132ac5ec2so41276085ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589248; x=1782194048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJ9iCHB9sbvcmZy5nVVVV8AFM81EYbRzctkVxH4Ahuk=;
        b=Z37kafq/UvpmR5t/nkTnsWJ/6oKEJ8GgZVO/+jGVQ5yjm6QCp46DeyDMq9DHhXLmPa
         +vj+oHR1JrqK6fbri1JHQdY1YWZMOFjn5v/lvD3VuVDJS+XWIANlgqG7yW4vjyJORJJs
         RBrn4BI00XEGpE9fEBs+X8FeQUCICXgLhJ3kz1NTPyDQz6zGJ4VLPrlVHWoMN5JHmt+W
         VzyI01gaWuqPGpCPUqzOLwuK5nqjVhrTkH2GRvqbSypu2gqYN/fgQgLxn6ojsbeEeEtm
         pCrFjG3R+julAaprMGZTXY4DkpuCQSQj9LHEpAjif9ulHH3bJYx9zJdEdItxLrSFkGzz
         q1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589248; x=1782194048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KJ9iCHB9sbvcmZy5nVVVV8AFM81EYbRzctkVxH4Ahuk=;
        b=GCq8DYYvZ1nFBPbqUbOeqh8Aw5RIRDlaU/Q+1o2JV9Dp1oYSz7zOVTibgsM3lm4Uo3
         4reu48dvhZJDNBZ9eE0f4Kf+AVvyRibjl4kmstez1ftvnUWlVgJ3IaDdCpVHARtWmIjU
         b8LndLvVWMPuMNVqP7Cyaf0Kdztms4bOjnzRjI0v947HnJ688wkAGnJr+yHY/FcpuUCz
         SnxHonjU9uh4xMLiiQ0odDPg5860omMyiV23UOmUTZ3SyW0OZqU7oDjoR3Frwp+nxguB
         kKCaKVFFd5MmM6YfQRku8ZbJUy8oi+Ru+IIb+uRzjem50lYKaoWVqnd5QijbpsMp2ssg
         vL7g==
X-Gm-Message-State: AOJu0Yx/tpN9vLQHDfq1oBdIczKolg6wdH1XRKo0enIoPPL3ZWD1f4jF
	p2gcmlQXOwjLU2qNDgpf9XYcku/mm/5mI601F1QPMRXKg0cdctrRR6SkWP1Rrw==
X-Gm-Gg: Acq92OHFN9Ie0B2RNnzWhA+E7VgxZ6g9d8Nq3XkC501mgfaqVc7g8733q8maa9ndost
	c8nPaEbIPvf6mx/J/tFE8iIU4sq7Rrnd+4hEH7K3TGcOt/cgPni/t9Wd4uQ02gPFVFzDDXYyLuJ
	Cs2SA9ahC1qf8uObF83hW5wCUhECt37gf66s5Rq0s/fkkgeLRZsuyIzBGdU3cwK9zgy80RRwkSb
	ugMS5H2HyziD98YgQOcY8ruEc3DwQ/EbnhPOW4OaD/2Ef8uc+CrkUKpRZ9k4njBsVCJzE0cmUGy
	y8bKDOaXLHU6o4fH2QNDx16/mcx0EyCWpXTN+o70KJmf5TKp9jD1uKua9hW0yarhejrI5/HtVcu
	brBfnBeOB1bYu2RKQ2hu4Xd0lxUEP2/gdS+LNJ/YP3oirH89yzeErurET6ATmXEjhKzj9gwHezj
	OGd0lOBI11SYugXTghvFkkzVuQiaV72t41QpuEwojtEVNg63V5y5aKJM/YTLXr94S9W5QXXtuW8
	r87Vpo2er/DRi27XHQ35VQ=
X-Received: by 2002:a17:902:e790:b0:2c0:b4f5:41ea with SMTP id d9443c01a7336-2c66424305emr145869425ad.17.1781589247827;
        Mon, 15 Jun 2026 22:54:07 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:07 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v4 1/7] smb: client: sync runtime state into ctx on reconfigure
Date: Tue, 16 Jun 2026 05:53:51 +0000
Message-ID: <20260616055357.3798387-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

smb3_init_fs_context() builds a fresh context with init defaults on
every call, including reconfigure (remount).  Many fields displayed
by cifs_show_options() are sourced from tcon/server/ses rather than
from ctx, so the init defaults do not reflect the live mount and
cannot be used as a baseline for comparing new vs old options on
remount.

Detect FS_CONTEXT_FOR_RECONFIGURE in smb3_init_fs_context() and
duplicate the existing cifs_sb->ctx instead.  Before duplicating,
sync ctx with runtime state via a new helper
smb3_sync_ctx_from_runtime() so the baseline matches what
cifs_show_options() displays.  Add srv_lock / tc_lock around the
relevant runtime writers (SMB2_negotiate, SMB2_tcon,
reset_cifs_unix_caps, cifs_swn_set_server_dstaddr) so the helper
can read them without torn-read races.

Also preserve inherited multichannel/max_channels values in
smb3_handle_conflicting_options() during reconfigure when neither
option is explicitly specified, since the dup'd context already
carries them.

This is preparatory plumbing for a subsequent commit that compares
new_ctx against old_ctx in smb3_verify_reconfigure_ctx() to reject
non-reconfigurable option changes.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/cifs_swn.h   |  14 ++++-
 fs/smb/client/fs_context.c | 111 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb1ops.c    |   7 ++-
 fs/smb/client/smb2pdu.c    |  11 +++-
 4 files changed, 139 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
index 955d07b69450..caf0779d4d07 100644
--- a/fs/smb/client/cifs_swn.h
+++ b/fs/smb/client/cifs_swn.h
@@ -26,11 +26,21 @@ void cifs_swn_check(void);
 
 static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *server)
 {
+	bool ret = false;
+
+	/*
+	 * srv_lock serializes the 128-byte sockaddr_storage write against
+	 * concurrent readers (e.g. cifs_show_address(), reconn_set_ipaddr_
+	 * from_hostname() snapshot, smb3_sync_ctx_from_runtime()) and other
+	 * writers like cifs_chan_update_iface() which already use srv_lock.
+	 */
+	spin_lock(&server->srv_lock);
 	if (server->use_swn_dstaddr) {
 		server->dstaddr = server->swn_dstaddr;
-		return true;
+		ret = true;
 	}
-	return false;
+	spin_unlock(&server->srv_lock);
+	return ret;
 }
 
 static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info *server)
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 9addc74ce57e..576a78b6d0cb 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -926,6 +926,81 @@ static void smb3_fs_context_free(struct fs_context *fc)
 	smb3_cleanup_fs_context(ctx);
 }
 
+/*
+ * Sync cifs_sb->ctx with runtime state from tcon/server/ses so the
+ * baseline matches what cifs_show_options() displays.  Wide fields
+ * (dstaddr, ops/vals) are protected by the matching server/tcon lock;
+ * the remaining word-sized scalars rely on the same unsynchronized-read
+ * pattern already used by cifs_show_options().
+ */
+static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses = tcon->ses;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+	const char *domain;
+	int unicode;
+
+	/*
+	 * Server fields that can drift from ctx after mount:
+	 *  - ops/vals: dialect renegotiation during reconnect (paired,
+	 *    so read under srv_lock to match the writer in SMB2_negotiate)
+	 *  - dstaddr: SWN witness failover updates server->dstaddr; the
+	 *    128-byte sockaddr_storage is not atomic, so srv_lock is
+	 *    required against torn reads
+	 *  - nosharesock: can be flipped to true post-mount by SMB2_tcon
+	 *    on STATUS_BAD_NETWORK_NAME with ISOLATED_TRANSPORT, so read
+	 *    under srv_lock to pair with that writer
+	 */
+	spin_lock(&server->srv_lock);
+	ctx->ops = server->ops;
+	ctx->vals = server->vals;
+	ctx->dstaddr = server->dstaddr;
+	ctx->nosharesock = server->nosharesock;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_caps()
+	 * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to pair
+	 * with that writer. tcon->posix_extensions is only ever set at
+	 * mount-time pre-publish, but read it under the same lock so the
+	 * derived linux_ext/no_linux_ext pair is consistent.
+	 */
+	spin_lock(&tcon->tc_lock);
+	if (tcon->posix_extensions || tcon->unix_ext) {
+		ctx->linux_ext = 1;
+		ctx->no_linux_ext = 0;
+	} else {
+		ctx->linux_ext = 0;
+		ctx->no_linux_ext = 1;
+	}
+	spin_unlock(&tcon->tc_lock);
+	ctx->seal	  = tcon->seal;
+	ctx->persistent	  = tcon->use_persistent;
+	ctx->nopersistent = !tcon->use_persistent;
+	ctx->resilient	  = tcon->use_resilient;
+	ctx->witness	  = tcon->use_witness;
+
+	/*
+	 * Session fields: domainName and unicode are effectively
+	 * write-once (set during session setup, never freed/replaced
+	 * while the session exists), so plain reads are safe.
+	 */
+	domain = ses->domainName;
+	unicode = ses->unicode;
+
+	if (domain && !ctx->domainname) {
+		ctx->domainname = kstrdup(domain, GFP_KERNEL);
+		if (!ctx->domainname)
+			return -ENOMEM;
+	}
+	if (unicode >= 0)
+		ctx->unicode = unicode;
+
+	return 0;
+}
+
 /*
  * Compare the old and new proposed context during reconfigure
  * and check if the changes are compatible.
@@ -1961,6 +2036,42 @@ int smb3_init_fs_context(struct fs_context *fc)
 	char *nodename = utsname()->nodename;
 	int i;
 
+	/*
+	 * For reconfigure (remount), duplicate the existing mount context
+	 * instead of building one from scratch with init defaults.
+	 *
+	 * VFS sets fc->root before calling init_fs_context for reconfigure,
+	 * so we can access the existing superblock's context.  We first sync
+	 * cifs_sb->ctx with runtime state (tcon/server/ses) so that ctx
+	 * matches what cifs_show_options() displays.  Then we dup old_ctx
+	 * into new_ctx.  The parser will overwrite only the options
+	 * explicitly passed on remount, so any difference between new_ctx
+	 * and old_ctx in smb3_verify_reconfigure_ctx() represents a real,
+	 * intentional change by the user.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct cifs_sb_info *cifs_sb = CIFS_SB(fc->root->d_sb);
+		int rc;
+
+		rc = smb3_sync_ctx_from_runtime(cifs_sb);
+		if (rc)
+			return rc;
+
+		ctx = kzalloc_obj(struct smb3_fs_context);
+		if (!ctx)
+			return -ENOMEM;
+
+		rc = smb3_fs_context_dup(ctx, cifs_sb->ctx);
+		if (rc) {
+			kfree(ctx);
+			return rc;
+		}
+
+		fc->fs_private = ctx;
+		fc->ops = &smb3_fs_context_ops;
+		return 0;
+	}
+
 	ctx = kzalloc_obj(struct smb3_fs_context);
 	if (unlikely(!ctx))
 		return -ENOMEM;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d34b3d99f6ed..33c890e14988 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -36,11 +36,16 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (ctx && ctx->no_linux_ext) {
 		tcon->fsUnixInfo.Capability = 0;
+		spin_lock(&tcon->tc_lock);
 		tcon->unix_ext = 0; /* Unix Extensions disabled */
+		spin_unlock(&tcon->tc_lock);
 		cifs_dbg(FYI, "Linux protocol extensions disabled\n");
 		return;
-	} else if (ctx)
+	} else if (ctx) {
+		spin_lock(&tcon->tc_lock);
 		tcon->unix_ext = 1; /* Unix Extensions supported */
+		spin_unlock(&tcon->tc_lock);
+	}
 
 	if (!tcon->unix_ext) {
 		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4972cfe249f6..958ca0753774 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1189,8 +1189,10 @@ SMB2_negotiate(const unsigned int xid,
 			goto neg_exit;
 		case SMB311_PROT_ID:
 			/* ops set to 3.0 by default for default so update */
+			spin_lock(&server->srv_lock);
 			server->ops = &smb311_operations;
 			server->vals = &smb311_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		default:
 			break;
@@ -1205,12 +1207,16 @@ SMB2_negotiate(const unsigned int xid,
 			goto neg_exit;
 		case SMB21_PROT_ID:
 			/* ops set to 3.0 by default for default so update */
+			spin_lock(&server->srv_lock);
 			server->ops = &smb21_operations;
 			server->vals = &smb21_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		case SMB311_PROT_ID:
+			spin_lock(&server->srv_lock);
 			server->ops = &smb311_operations;
 			server->vals = &smb311_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		default:
 			break;
@@ -2226,8 +2232,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (server->ops->validate_negotiate)
 		rc = server->ops->validate_negotiate(xid, tcon);
 	if (rc == 0) /* See MS-SMB2 2.2.10 and 3.2.5.5 */
-		if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT)
+		if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT) {
+			spin_lock(&server->srv_lock);
 			server->nosharesock = true;
+			spin_unlock(&server->srv_lock);
+		}
 tcon_exit:
 
 	free_rsp_buf(resp_buftype, rsp);
-- 
2.43.0

