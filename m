Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC443CBE75
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371684; cv=none; b=Zu9c6s2VdwMMCPhsdsx273QDPdZFNCL/FfxIbqTB+7rE8pV5zUMk5+Xie52VPd+SoVilBb8ebRq4Dbq0O+ZdrRjNQ3mcaYRMg78oC8gXGMgBKpLFxXQ2CyqSiXuzuVHTl9BLQHupcbErO9TOiBKfFFLuSb1dQapa84TdGyl931k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371684; c=relaxed/simple;
	bh=HPZNgfPv4NOwHRE+ejIrpad+UOQEhVdWYqPyCS8N2Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkXW300FOTQhQIn6toxRyqyaxc3EV7okOcN40xKcxq9riGZPgFfZTuo3k0SwEBJBGCrGcoaSHWyTVkNgw970lSjPKc9LMOOoaxw0YqDMq8KUhRMVTr6800HigFcD9PJDnqnbaBs/EdrSdGxO+CJ9Kcp1MjkdQn0864NCmVDdTEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YmotkIYw; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YmotkIYw"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c736261ee8dso2857356a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371682; x=1779976482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMMzrE02cBSizde/b8sQjJmuGF0rKjzqTNZ362Dbx5c=;
        b=YmotkIYwjpU4FuqUOxWXwhq+YcJWyR0VOYWEWWsEZDyGi23pSnj5Xx8DkzH8DVSTIw
         KL+qfTBRkOV/a5K6n+hYv+3zBMN299Mw7sYIJ7saYR7lQwCYLVA+nr3PfYthf7R6/Jap
         gvs1Sts9COjoDF10YgxhluOpQbt4RVIKAYGK8Z2ZbW+InOKkIKCOfLSbQAFUOIsaanIB
         0CDNIq9B+mBwoGe29y2oHp1cVvsbMouj7LfQbXkpe7l+QxRxwTIPFBtI1yJr7xfJUcgo
         eLMPB3XDpKVhWQbQ+OWTnHFCnxvqZWlxxB2qE7lSnWjdbKSnsD6+M1d5cuiP/4vtDr9H
         xr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371682; x=1779976482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rMMzrE02cBSizde/b8sQjJmuGF0rKjzqTNZ362Dbx5c=;
        b=fpUGqtvy0ns+/TFG8UoxmlVL3pzQriRI2AAuK/QyULgaX2Z4UrT7dsvBoJJmJU7gYN
         Q8k2HzxZsVSZOS0CoObM5p8Lp1qDFMj8y4ChdxGy23PcbdgNfybpCRg+zxX92x00Ww7X
         GASqjBvl+9+3AaHUVuvAPyJaT1GHjq8psVQB1umn2CI2eS04GEP0GRoj0EDILs1Zk+bf
         w5grssDN9JxqB4e9IDInzIEqncb7iGdcaPPeOML2Md9QKM4LBNcpyYtb+BfwVxP1F697
         CZ6amuMbE7RWUHpzEe8lP0YrJIKluS80VOWvkFcS+I5ekulY/JNFOQBpvkVAoXesM8p3
         ACTQ==
X-Gm-Message-State: AOJu0Yz8iRqxJccGZ5CqNLeOrtojL/Q19ptHy6o3FO600QhMZw+skphw
	bFStOU/TBcRl41OvERiyeS79lR8wq3uwVLhzKQfEa2q5lyeU7AHWdlRH
X-Gm-Gg: Acq92OEyUjhq/VmE60FCkmXq0RO+G/TOwvhDynF4kFhkdGL94yyGOjJxyvKRj+4Ap4/
	RAMEbaabeVIYPq4s2h5cMH6EH56CaaUIGKYSJWxpMt2qTuRYvCNAUonAFs6nrqs8izxdxVvpziN
	SElRFoRyLeciGkkQV5YABvEMjj+WSuN1o1jgHyWNDWmy/4aygJ7Q9FXXkIMjy97EK1FAnLt/lfP
	RREeqQipgYK70Eytcm48JhTSBZnYsoXjebkET/5Ay5gdAMrlS1cmY2M69xtdIc7rNS07NCLTYnP
	O1mbT4CmqGrLELF9JwoM+eVzym+rPYlBu12850rLfOhx5sX7HDcCXXv5SQDIAt8YerOjPNmolnu
	5xoj71EOE69Lp34/stcr1xTVarPBYaeScz6YJ541FdmvF87UNy06abeQFbQHioPb7MrNdJaAS5n
	6VkCHvIvsoiJRyZe+5dq2caOQOj3PHmfwj5pohS+Muvk7tuPHC4R2Vf/8AhUn+HBMGUB/Yjy6hO
	bRjST4IYzpz9CBm60yU5KTM8xhAA3vFkg==
X-Received: by 2002:a05:6a20:9195:b0:3aa:f9cb:d438 with SMTP id adf61e73a8af0-3b3085d23e3mr3772719637.21.1779371682199;
        Thu, 21 May 2026 06:54:42 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:41 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 1/9] smb: client: sync runtime state into ctx on reconfigure
Date: Thu, 21 May 2026 13:54:07 +0000
Message-ID: <5eeeecdba9a2ab93074b5fbac505b83f35aac18f.1779371115.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
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
---
 fs/smb/client/cifs_swn.h   |  14 ++++-
 fs/smb/client/fs_context.c | 117 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/smb1ops.c    |   7 ++-
 fs/smb/client/smb2pdu.c    |  11 +++-
 4 files changed, 143 insertions(+), 6 deletions(-)

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
index 2f86158f85d7..b93d6ef13463 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -717,13 +717,13 @@ static int smb3_handle_conflicting_options(struct fs_context *fc)
 				ctx->multichannel = true;
 			else
 				ctx->multichannel = false;
-		} else {
+		} else if (fc->purpose != FS_CONTEXT_FOR_RECONFIGURE) {
 			ctx->multichannel = false;
 			ctx->max_channels = 1;
 		}
+		/* For reconfigure with neither specified, keep inherited values */
 	}
 
-	//resetting default values as remount doesn't initialize fs_context again
 	ctx->multichannel_specified = false;
 	ctx->max_channels_specified = false;
 
@@ -921,6 +921,85 @@ static void smb3_fs_context_free(struct fs_context *fc)
 	smb3_cleanup_fs_context(ctx);
 }
 
+/*
+ * Sync cifs_sb->ctx with the runtime state visible through /proc/mounts.
+ * cifs_show_options() reads many fields from tcon/server/ses rather than
+ * from ctx.  On remount, libmount reads /proc/mounts and feeds those
+ * values back as mount options.  To avoid false mismatches between the
+ * old ctx and the newly parsed options, we must ensure ctx reflects
+ * the current runtime state before it is duplicated into the new
+ * remount context.
+ *
+ * Note: sb->s_umount is not yet held when VFS calls init_fs_context()
+ * for reconfigure, so in theory concurrent I/O paths could read
+ * cifs_sb->ctx fields (e.g. cifs_symlink_type()) while we write them.
+ * This is safe because all fields written here are word-sized
+ * (bool/int/pointer), so stores are architecturally atomic.  The same
+ * unsynchronized-read pattern already exists in cifs_show_options().
+ */
+static void smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
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
+	if (domain && !ctx->domainname)
+		ctx->domainname = kstrdup(domain, GFP_KERNEL);
+	if (unicode >= 0)
+		ctx->unicode = unicode;
+}
+
 /*
  * Compare the old and new proposed context during reconfigure
  * and check if the changes are compatible.
@@ -1958,6 +2037,40 @@ int smb3_init_fs_context(struct fs_context *fc)
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
+		smb3_sync_ctx_from_runtime(cifs_sb);
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
index e198e3dda917..a91539d7f0ba 100644
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
index 995fcdd30681..9e07c1a99981 100644
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
@@ -2228,8 +2234,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
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

