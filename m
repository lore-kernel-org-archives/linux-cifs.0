Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E1A3C73E5
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161499; cv=none; b=Tf++2nV3pzKaZJQoz3a8acYe6evVDeaG+7WHUwNfC6fkkFJfQtmbhUyNgPjfi31dxWmiGvMybr+7bOUjaMKg94/pSFVAuO870Hfl0m/N+RfWPk4vrZL4qxzG4kXgzAxd61sEJde/lfajvTtzVkDCgWcoTtaqbCte8uLpD+VFIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161499; c=relaxed/simple;
	bh=TzRfb8WohHechkim8jiUApyp4Jrd88OVkcA6LEUB/Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYagdNs16DIOfX+1dcqmSfRaLOSP+mLp6TbYALJYP//1qsgHMTA66dhNWXxf+sW0yOtUAjj1582OnUq9zr7g6EC6JP7iI10qxISq25SEGNmR1gey9bcpg8SJr7pn9826hDbYX2e8gcgaZMR9XBqw7cyE9NPBNIPEm4oQ8HuGtGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZI7ALS9c; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZI7ALS9c"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-364eef1891dso632429a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161497; x=1778766297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNOWW83EwgZbUEuIj2igXZFSfemGYF9D6yJkx6D5/ns=;
        b=ZI7ALS9cCKAX8YdC9AFkd06a1/Ello0kam49bztRJQA7XJL/f0ZfdbR3O374Z/8uhG
         orOhW9tCHiWCdGvLVwYGfIqKYVZP4k4F0LIIFiRJN4fC2ZqeQVM/fUh6zdhcgxwebxMh
         wmxgZXZwsugI3F/WxYfy9IPxO5kdRa0hZAYEN38+WZxF35fIAwrtM74HfIojyKk0Teib
         OfhOp1NIcBVtAW5xXfCVfLcU09lmP3xyWFDWZewmR6LgI2Bf7U3sjLM5Zz+BgSQRFoLW
         L5QdPGupjfaHQcAflQ3T2+LVGVqPuOD03J9XnUfHaW4F9cCiv5FswkQvfaMqW8mzc2xU
         NmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161497; x=1778766297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uNOWW83EwgZbUEuIj2igXZFSfemGYF9D6yJkx6D5/ns=;
        b=fNfQ6nT9PBUkCwcdk3daPtaqcFUh2ad2N2mve4+5eoSE3rL2hTsgRRBmg/oXqcxDHC
         MMPqhqEw01bMtpswGPKcnZ6cJ5nq+18V5J8U8I/6pqYKmcxUfJW4LlrKt0wBgKzz3F1T
         YF7NezaZKEJ4b17cwh7mqerEUOHcOVENau3f67czmDlE5phhjgCCwwKRsDZ2m/o3OZBw
         xf2QDfHMekJmFRFftiMGwat8P4IpLfeIkGkhvm5FCpZ6ueYZX5BCK6yBmeWkGrS9nmFR
         5qCkilQbhOprLxwDGLUqPq90S/D/aEQaeWaW0KlaQCC6C8Ykbpfz+PtYXyhiztjhByP5
         8YHQ==
X-Gm-Message-State: AOJu0Yx638vlsKqfsIFO/b5Y/wViNsoiSxegn6GvOHXLDvK8hIDG50/3
	uTBaZ7EarEpsNq7xeMaQKxiI5sOsUbgrBl+eW58Je5S31wASN7BOyHb/T09ViA==
X-Gm-Gg: AeBDieu7kk+Zs1SBsQkov1kibNdGm39as9UZEdNwIQbGUTJEPkjjiNL7jqe0PWpI1/5
	G9XUjntpV2YwN/W6VG2T/sKuXXMzQYf+xQExiNZxxrQZdq6HJSEYqliCryDUspCApD9h4db4wD8
	y27PalAPzPzBQRS5TH/1q0lG62ydTBrq/a2P6NGF9B/XUtHknxxy1pcINJZhJydxYJk+8E8cO6Z
	NGBIeENbCxfxWi5B8CE8HZLG6S4yxLl8geYG3Mg195f2r1AUnWfMI6Dk/JN2v8lRgMbEDyfX96B
	1tuFdy0PKk9cUsmIGroc6gB4fghpq95nef6+o1b1RSIGZA9KdnEFalKxWykgwkD25qe0V1519fT
	+jgSt0sEpT/ESJs0W2S+oaVn2QzUwmLTHmYVJf06urOKndF13e3DrVufE1O0zSovV0ftkomtYtJ
	mCdyOm8P7slFhPZ2YqBEgez+uHg4Aq0O5oKKzyglBtKU/vNFeapfInziCrvRTu0NBZ1FCsSty8r
	gIiKGNwzCLs0o39R5O2+sQcwrJUstAkPA==
X-Received: by 2002:a17:90b:3804:b0:35f:bfdd:f5a1 with SMTP id 98e67ed59e1d1-365abe7fdddmr7582587a91.13.1778161496970;
        Thu, 07 May 2026 06:44:56 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:44:56 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 1/8] smb: client: block non-reconfigurable option changes on remount
Date: Thu,  7 May 2026 13:44:41 +0000
Message-ID: <20260507134448.168602-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Several mount options (seal, sign, vers, ip, rdma, nosharesock,
persistent/resilient handles, etc.) require tearing down the
connection to take effect, but smb3_verify_reconfigure_ctx()
does not reject them.  A remount that changes any of these silently
ignores the new value, confusing users.

Adding simple != checks to smb3_verify_reconfigure_ctx() does not
work with the current code because smb3_init_fs_context() always
creates a fresh context with init defaults on remount.  Since
cifs_show_options() reads many fields from tcon/server/ses rather
than from ctx, the init defaults differ from the runtime state
and every != check would spuriously fire.

Fix this by detecting FS_CONTEXT_FOR_RECONFIGURE in
smb3_init_fs_context() and duplicating the existing cifs_sb->ctx
instead of building one from scratch.  Before duplicating, sync
ctx with runtime state via new helper smb3_sync_ctx_from_tcon()
so the baseline matches what cifs_show_options() displays.  With
this in place, add comprehensive checks in
smb3_verify_reconfigure_ctx() to reject non-reconfigurable option
changes with clear error messages.

Also preserve inherited multichannel/max_channels values in
smb3_handle_conflicting_options() during reconfigure when neither
option is explicitly specified.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 254 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 252 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b63ec7ab6e51..d90430e7a648 100644
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
+static void smb3_sync_ctx_from_tcon(struct cifs_sb_info *cifs_sb)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses = tcon->ses;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+	const char *domain;
+	int unicode;
+
+	/*
+	 * Server fields: ops/vals can change during reconnect
+	 * (renegotiation may upgrade the dialect).  nosharesock can
+	 * transition false->true if the server sets
+	 * SMB2_SHAREFLAG_ISOLATED_TRANSPORT during tree connect.
+	 * Read all under srv_lock to get a consistent snapshot.
+	 */
+	spin_lock(&server->srv_lock);
+	ctx->ops = server->ops;
+	ctx->vals = server->vals;
+	ctx->nosharesock = server->nosharesock;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * Tcon fields: posix_extensions, unix_ext, use_persistent and
+	 * use_resilient are set during tree connect and do not change
+	 * after that, but read under tc_lock for consistency with the
+	 * convention that tc_lock protects tcon state.
+	 */
+	spin_lock(&tcon->tc_lock);
+	if (tcon->posix_extensions) {
+		ctx->linux_ext = 1;
+		ctx->no_linux_ext = 0;
+	} else if (tcon->unix_ext) {
+		ctx->linux_ext = 1;
+		ctx->no_linux_ext = 0;
+	} else {
+		ctx->linux_ext = 0;
+		ctx->no_linux_ext = 1;
+	}
+	if (tcon->use_persistent) {
+		ctx->persistent = true;
+		ctx->nopersistent = false;
+	}
+	ctx->resilient = tcon->use_resilient;
+	spin_unlock(&tcon->tc_lock);
+
+	/*
+	 * Session fields: domainName and unicode are effectively
+	 * write-once (set during session setup, never freed/replaced
+	 * while the session exists).  Snapshot them under ses_lock
+	 * and kstrdup the domain outside the lock.
+	 */
+	spin_lock(&ses->ses_lock);
+	domain = ses->domainName;
+	unicode = ses->unicode;
+	spin_unlock(&ses->ses_lock);
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
@@ -990,6 +1069,143 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change nbsessinit during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->compress != old_ctx->compress) {
+		cifs_errorf(fc, "can not change compress during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noblocksnd != old_ctx->noblocksnd) {
+		cifs_errorf(fc, "can not change noblocksend during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noautotune != old_ctx->noautotune) {
+		cifs_errorf(fc, "can not change noautotune during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_sparse != old_ctx->no_sparse) {
+		cifs_errorf(fc, "can not change nosparse during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nodelete != old_ctx->nodelete) {
+		cifs_errorf(fc, "can not change nodelete during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cruid_specified &&
+	    !uid_eq(new_ctx->cred_uid, old_ctx->cred_uid)) {
+		cifs_errorf(fc, "can not change cruid during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->port != old_ctx->port) {
+		cifs_errorf(fc, "can not change port during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->min_offload != old_ctx->min_offload) {
+		cifs_errorf(fc, "can not change min_enc_offload during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->snapshot_time != old_ctx->snapshot_time) {
+		cifs_errorf(fc, "can not change snapshot during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->max_credits != old_ctx->max_credits) {
+		cifs_errorf(fc, "can not change max_credits during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->handle_timeout != old_ctx->handle_timeout) {
+		cifs_errorf(fc, "can not change handletimeout during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_ip &&
+	    !cifs_match_ipaddr((struct sockaddr *)&new_ctx->dstaddr,
+			       (struct sockaddr *)&old_ctx->dstaddr)) {
+		cifs_errorf(fc, "can not change ip during remount\n");
+		return -EINVAL;
+	}
+	if (((struct sockaddr *)&new_ctx->srcaddr)->sa_family != AF_UNSPEC &&
+	    memcmp(&new_ctx->srcaddr, &old_ctx->srcaddr, sizeof(new_ctx->srcaddr))) {
+		cifs_errorf(fc, "can not change srcaddr during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change netbiosname during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change servern during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_version &&
+	    (new_ctx->ops != old_ctx->ops || new_ctx->vals != old_ctx->vals)) {
+		cifs_errorf(fc, "can not change vers during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->witness != old_ctx->witness) {
+		cifs_errorf(fc, "can not change witness during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rootfs != old_ctx->rootfs) {
+		cifs_errorf(fc, "can not change rootfs during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->linux_ext != old_ctx->linux_ext ||
+	    new_ctx->no_linux_ext != old_ctx->no_linux_ext) {
+		cifs_errorf(fc, "can not change unix during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nocase != old_ctx->nocase) {
+		cifs_errorf(fc, "can not change nocase during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->intr != old_ctx->intr) {
+		cifs_errorf(fc, "can not change intr during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_psx_acl != old_ctx->no_psx_acl) {
+		cifs_errorf(fc, "can not change acl during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->local_lease != old_ctx->local_lease) {
+		cifs_errorf(fc, "can not change locallease during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sign != old_ctx->sign) {
+		cifs_errorf(fc, "can not change sign during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->ignore_signature != old_ctx->ignore_signature) {
+		cifs_errorf(fc, "can not change ignore_signature during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->seal != old_ctx->seal) {
+		cifs_errorf(fc, "can not change seal during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nosharesock != old_ctx->nosharesock) {
+		cifs_errorf(fc, "can not change nosharesock during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->persistent != old_ctx->persistent ||
+	    new_ctx->nopersistent != old_ctx->nopersistent) {
+		cifs_errorf(fc, "can not change persistenthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->resilient != old_ctx->resilient) {
+		cifs_errorf(fc, "can not change resilienthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sockopt_tcp_nodelay != old_ctx->sockopt_tcp_nodelay) {
+		cifs_errorf(fc, "can not change tcpnodelay during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->domainauto != old_ctx->domainauto) {
+		cifs_errorf(fc, "can not change domainauto during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rdma != old_ctx->rdma) {
+		cifs_errorf(fc, "can not change rdma during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1903,6 +2119,40 @@ int smb3_init_fs_context(struct fs_context *fc)
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
+		smb3_sync_ctx_from_tcon(cifs_sb);
+
+		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
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
-- 
2.43.0

