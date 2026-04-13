Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98980366055
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 07:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776065583; cv=none; b=cduBsCzTuXtdR2lm+HN3TrlgTVmGmgfqQ1sErsa19OebiNlDzTVOE4+G8H4bUQK/8WAgSpsDzXoAm5ehJ70LiHndjylfPke/ClJFtMoUqgfmkclwvguh/uokWh8XZjbVyEvtjsCzBQEwdc6qLGGyZr+lxCZYuRkX4D8DtsQ6/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776065583; c=relaxed/simple;
	bh=5u5oO5x5eQXQPz95LeajmtdsIvQ7E0hEk1x3S14JhFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myiTQe+JxwNSl617tuOZQE0CDqOpS1HH6TPhYnB+cbkRnJQr1+lOYbfw60MY0CvP241MIzH36ebeCYfeX14j1lNJDUidtQopua2ltQxiN7McoQg9Yqo59tx5+4Sja4daIZ+6eIcWfdAegAmyOkfXo9TAAp+wjAkXGFunfH4xw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nD1KVMAM; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nD1KVMAM"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35fb166b0c6so371566a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 00:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776065581; x=1776670381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAaS5mGQcqDvRd5s0eMR/lLLm+jSTLXs9jR7H0Wl3Lc=;
        b=nD1KVMAMLXkfUS1j8QJuzmjrtI99P5ioVSV3VdTJwgzDt6fbeg7eprEr4vBJjvVo1I
         rD1+6r5NPAqHl4qLGzkYlXTOTegQ4xJioTeuVjt9DAm1eU6VxVykikQiL8pc4M77VN2V
         +MbTSOMYSKlyT7WeZKyFoyHAEpSnU8OTfvPRqABAisx1fKIfjiK9w/m61zLX8s4dF+35
         VL/RmwOJwZP5u9q3jPXArJGLKE8od7mgvHLlLZeKaEktqc/QPNr8BECGjimZ//5vBiHl
         3RmOuDo1H/QUVvHT3Ltu7yZZ3N5jvs2NbwDBhhQ7xCoaFUTanZZ7eI0D6wAvc7bhBTMb
         GeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776065581; x=1776670381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nAaS5mGQcqDvRd5s0eMR/lLLm+jSTLXs9jR7H0Wl3Lc=;
        b=IeYfxl3trpHLkUZXEJj5U0P7BHM+N/8PsNWyL/f+Dob2UZQ8rRlWO8r0C3VP94IRL1
         PDXLaDqqTGZdwwrfscThF/YYd3I2tvLyCFzibXghOd078H6Q48C2rXFL/c1YWiwYu4Bh
         UAR01dMfKk9N2Aid4QQhWLqYAffFDLDzrtiOZVF3/qLw9lcEduczuH+JXtBM0jN/DQZI
         BE3+lr/Gw597ff+6Ai5sCNY5z5ud9zds06dyV3qQXd72qRmDd2QEJ2bKorhwgorh/gC2
         CwNU9elUDZE5JTiVLuyABR3PkrSABHExsBq8BD0SuRid7rk5zI233WjtAzsv6X3zzlCw
         jpVQ==
X-Gm-Message-State: AOJu0YyBRzZEWYa4SZMPxIVxlAxmjm8QdAPfT/v2/EeQyNtPkk0+ynM6
	s53/X7eV4gZUGEqOtdYqRDx5gbqX0JgUcE2Q4WjWLED3TiXJbycXzr4V
X-Gm-Gg: AeBDievp//nkmCtyzfgaq3tmlaFM5TiVz3BrCaICjzZyHnahP4DQ86xSz77Q80psIc4
	1haKtjUJXz5DTlWWUDMgn90CZlETnf0lkNbTKDMcNRsNWROnlU6TyOr88QVouPa0SAAeYxSdehT
	8WzVmiDTzpjsrisAvODDecFmQjgcfeQrp5hU8qUuo9GbWw2LIeTz2h+XX23ejQL/KlNPDHdLTHf
	Ui9ooDOOIEGUHryhzpi8g52b8vQRCzc8IXi4rXDCAnlkAwFw5ISnpSOWxdHXKOgumMY5IG3uA2/
	E7HtasHOG3rWowd4jNjBAI6ST2ek5gl2EtrbaqzDJ8f1X4Ftxk2JhNtE3sfvqhWrqLG0cmFG/XW
	KBRK5S3xuyQkQO7pbhPIk3lkODjJ0hBMCp3kvgw4p+VRYG2vfUBp0RUCYrNqNyFnE6EVNbDa/3z
	8EqfBJxqeQbONksEw5/LZkac/aipyZFfCS8OG3i885ch5ABCS9ax5oLnVhSmjIHVstI98c+EVS/
	xlTas+b/RGhN0i3R8Q9GKM=
X-Received: by 2002:a17:90b:3cc5:b0:359:8957:7285 with SMTP id 98e67ed59e1d1-35e42fe6aefmr9302981a91.3.1776065580819;
        Mon, 13 Apr 2026 00:33:00 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e412233ddsm11283333a91.5.2026.04.13.00.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:33:00 -0700 (PDT)
From: Rajasi Mandal <rajasimandalos@gmail.com>
To: stfrench@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v2 1/9] smb: client: block non-reconfigurable option changes on remount
Date: Mon, 13 Apr 2026 07:32:49 +0000
Message-ID: <20260413073249.2897840-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Options like seal, sign, vers, ip, rdma and others require tearing
down the connection to take effect, so they cannot be changed on
remount.  Previously they were silently accepted and ignored.

Add checks in smb3_verify_reconfigure_ctx() to reject changes to
these options on remount.  Options shown in /proc/mounts use a bare
!= comparison since libmount feeds them back automatically.  Options
not shown in /proc/mounts use an 'if (new && new != old)' guard so
their init default does not cause a false mismatch.

Introduce smb3_preserve_non_reconfig_opts() to copy hidden option
values from the old context into the new one before
smb3_fs_context_dup() overwrites them with init defaults.  Without
this, a bare remount silently corrupts the stored mount context by
replacing live values with zero/init defaults for every option not
shown in /proc/mounts.

Introduce smb3_sync_ctx_from_negotiated() to sync the stored mount
context with runtime state (persistenthandles, unix, nosharesock,
resilienthandles, domainname, ops/vals) before the verify step, since
cifs_show_options() reads these from tcon/server and they can diverge
from ctx when the server auto-enables a feature or negotiates a
different dialect than what was parsed (e.g. default -> SMB 3.1.1).
Without this sync, the fed-back /proc/mounts values mismatch the
stale ctx and the verify step incorrectly rejects a bare remount.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 235 +++++++++++++++++++++++++++++++++++++
 1 file changed, 235 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3f0faae99ed5..a0217b5641a2 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1021,10 +1021,241 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change nbsessinit during remount\n");
 		return -EINVAL;
 	}
+	/* init default: compress = false */
+	if (new_ctx->compress &&
+	    new_ctx->compress != old_ctx->compress) {
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
+	/* init default: port = 0 */
+	if (new_ctx->port &&
+	    new_ctx->port != old_ctx->port) {
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
+	/* source_rfc1001_name: both init from same nodename, safe to compare */
+	if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change netbiosname during remount\n");
+		return -EINVAL;
+	}
+	/* init default: target_rfc1001_name[0] = 0 */
+	if (new_ctx->target_rfc1001_name[0] &&
+	    memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name,
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
+	/* init default: rootfs = false */
+	if (new_ctx->rootfs &&
+	    new_ctx->rootfs != old_ctx->rootfs) {
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
+	/* init default: intr = false */
+	if (new_ctx->intr &&
+	    new_ctx->intr != old_ctx->intr) {
+		cifs_errorf(fc, "can not change intr during remount\n");
+		return -EINVAL;
+	}
+	/* init default: no_psx_acl = 0 */
+	if (new_ctx->no_psx_acl &&
+	    new_ctx->no_psx_acl != old_ctx->no_psx_acl) {
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
+	/*
+	 * persistent is shown in /proc/mounts (bare !=).
+	 * nopersistent is NOT shown, so guard with init default check.
+	 */
+	if (new_ctx->persistent != old_ctx->persistent ||
+	    (new_ctx->nopersistent &&
+	     new_ctx->nopersistent != old_ctx->nopersistent)) {
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
+	/* init default: domainauto = false */
+	if (new_ctx->domainauto &&
+	    new_ctx->domainauto != old_ctx->domainauto) {
+		cifs_errorf(fc, "can not change domainauto during remount\n");
+		return -EINVAL;
+	}
+	/* init default: rdma = false */
+	if (new_ctx->rdma &&
+	    new_ctx->rdma != old_ctx->rdma) {
+		cifs_errorf(fc, "can not change rdma during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
+/*
+ * Sync cifs_sb->ctx with negotiated runtime values for fields that
+ * cifs_show_options() reads from tcon/server rather than from ctx.
+ * The mount.cifs helper reads /proc/mounts and feeds these values back
+ * on remount, so ctx must match the runtime state to avoid false
+ * rejection by smb3_verify_reconfigure_ctx().
+ */
+static void smb3_sync_ctx_from_negotiated(struct cifs_sb_info *cifs_sb)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	/* /proc/mounts shows persistenthandles from tcon->use_persistent */
+	if (tcon->use_persistent && !ctx->persistent) {
+		ctx->persistent = true;
+		ctx->nopersistent = false;
+	}
+	/* /proc/mounts shows resilienthandles from tcon->use_resilient */
+	ctx->resilient = tcon->use_resilient;
+	/* /proc/mounts shows nounix/unix/posix from tcon */
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
+	/* /proc/mounts shows nosharesock from server->nosharesock */
+	if (server->nosharesock)
+		ctx->nosharesock = true;
+	/*
+	 * /proc/mounts shows vers= from server->vals->version_string,
+	 * which reflects the negotiated dialect. When mounted without
+	 * an explicit vers=, ctx stores smbdefault ops/vals while the
+	 * server may have negotiated e.g. SMB 3.1.1. Sync so the
+	 * verify check does not reject the fed-back vers= on remount.
+	 */
+	ctx->ops = server->ops;
+	ctx->vals = server->vals;
+}
+
+/*
+ * Carry forward non-reconfigurable mount options that are NOT
+ * displayed by cifs_show_options() into the new remount context
+ * before smb3_fs_context_dup() overwrites cifs_sb->ctx.
+ *
+ * Options that cifs_show_options() outputs are automatically
+ * re-fed by libmount (which reads /proc/mounts) on remount,
+ * so they do not need to be preserved here.
+ *
+ * Without this, a bare remount would silently reset these hidden
+ * fields to their init defaults.
+ */
+static void smb3_preserve_non_reconfig_opts(struct smb3_fs_context *new_ctx,
+					    struct smb3_fs_context *old_ctx)
+{
+	new_ctx->compress = old_ctx->compress;
+	new_ctx->port = old_ctx->port;
+	new_ctx->rootfs = old_ctx->rootfs;
+	new_ctx->intr = old_ctx->intr;
+	new_ctx->no_psx_acl = old_ctx->no_psx_acl;
+	new_ctx->domainauto = old_ctx->domainauto;
+	new_ctx->rdma = old_ctx->rdma;
+	new_ctx->nopersistent = old_ctx->nopersistent;
+	memcpy(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name,
+	       RFC1001_NAME_LEN_WITH_NULL);
+}
+
 #define STEAL_STRING(cifs_sb, ctx, field)				\
 do {									\
 	kfree(ctx->field);						\
@@ -1093,6 +1324,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (ses->expired_pwd)
 		need_recon = true;
 
+	smb3_sync_ctx_from_negotiated(cifs_sb);
+
 	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_recon);
 	if (rc)
 		return rc;
@@ -1205,6 +1438,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
 
+	smb3_preserve_non_reconfig_opts(ctx, cifs_sb->ctx);
+
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
 	smb3_update_mnt_flags(cifs_sb);
-- 
2.43.0

