Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08AD3BA251
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 09:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728794; cv=none; b=BeEMUjL3Kjdg/d7cS99M14VAALwniWWXcqTXQSx5TIKvPVYTbQG3L+dn+2lCfzljp8upOUQ3T8SndDQPcnk17MOMTbelcEjObovBU1hV1Rl2CcOCwdZXBxvpKoYMCPVIg8Vx2d0dkMJp3RtsdvX+5i9i7MHuXm+reiPA4N9nbWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728794; c=relaxed/simple;
	bh=rkm0/pi9YghhxDH0ulln+DH0cJ9iPyFICvyPWtK1vMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JuSGnfHVContiU2C33IfsQFj7dtwci1knqKPCz8/1H1Jr+pYfZ8yRw2IkafcsmpLuME3njJES/MQBjLJeK7vOhNr/0lSLQG8JVRKhHphim7K5POSFQJMjmgz3gBXXDjAGzGDn/dRIcvnd4TWU8s5LpvxgHoukhGJzKXK4aV5dOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LOSQAhaw; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOSQAhaw"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82cf636dac8so385028b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 02:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728788; x=1776333588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t3d1+K0IsnZoRFwAfRvvY9wcvriTXGWHVjUeeK00nBA=;
        b=LOSQAhawJkNeXATpTPD9df3RoBRCixzfCvGCzfpxy2XHn2lJ4sGKVEaJaBbrNyzPlU
         DGLwDwo+HswDUXGVb+RRdImKDdTaUb63omNZQues4a9gxqqYO/bqO4ixFn2NzANz+wTv
         Vjax8QCaJda7vfPa909L5u/PI6H6XRbyOqyS6EpdfLGu5R2vLpPwxwzi/h4W2CHlu8jp
         xwEuHTwutU2dryngRZi7c9jFemq7xOAKIHvz3/5wuZfq59HZk7U6XNIX4LBPpnuiLyno
         gkhaX9CtwbfrN/sUcLE2WujrOAbq7oa3SWLlmT37pce3Qi7Iygnh5RpkPYeDwTfx+FyK
         ayXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728788; x=1776333588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3d1+K0IsnZoRFwAfRvvY9wcvriTXGWHVjUeeK00nBA=;
        b=MncE7l0/rBM9zFwNKk0r3DEUTbOc4/T8vAPDK82b4CKXv+lve3J4KyFnYDTF82qMlJ
         AnvmuLx/rPe85tExqUxV5UVTwqe5k6Itei7iqsah2ZndcR51BusrOjDaBS+ULnTff2LP
         2feMKMnMf9c27o4wT7IW8qxzaNDw3JeuwTSLS1FVhF6xMHL3RdADK3I2JLsOZ0llqMJH
         uRr2ZNgmZ7OlkskQ4DzmDXazQ9AH4T+HGQwmLIT7kU2XTt3TmLsCEkJrBrr4YNxc9Xjp
         ljaQu4i9nus3MuVgr6Kd046nKd7Gh3bRWREYcihL89wFpe9lmmGxsL5ydvflwjl0BFkj
         aVOw==
X-Forwarded-Encrypted: i=1; AJvYcCWniEve/rw5RiPqiTC2N4ZxFOtud0Z7cxMituQZWCAWfWw1QFJ1hEh8yBOpYTJnke0ha8Cus1UQxEtT@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwxz7WT5TkIWUAMXFqdg0996oGW5nX8A0M27T93BLyQ97i1mDe
	ToL1bHAUdVOhYO1qDIv8XmwyRl03KdPHttnF7dwxKaSKA8CkBc970Jc21NaltA==
X-Gm-Gg: AeBDievBS8s/IipIPiBbWeW+/XMDKhHrArMOON8Ix9nhaDF2Vvxcq6YXM46M4zDylGw
	pWs9ko+VjV/U6Mv3/wumnvQSNDSPzfZhNW222vcC8R5QVlloIa4mp2MThkNCCGCZ3lvQmbYsTMi
	ZU/xymZxshHZXWf4OoUAFRQjbZoThhHC/m6xY4B6BHZWscLP/HXM9/JYRnaME5njAiIHGjnn7E9
	mmv7D5z5kekRvsvexg6ej01OpFBa8xDbgF9SwlwWhvBki9IdtbW342vxlcxoPhsVNxGk5RgW/7N
	VxmvRNeRQU+seVMwry6mkbcR+rBYWAz17ti1OBjeiIT1hIW0dALLaww2rE4VKYMVFFrJVIq+HAy
	YuQMRYkEOVYGSPHXLUHOXxioe77r84TywnwuXV/TwBFKfQqcqE9I+FGH0O7A6mdqr7hvrFlpov6
	zKWGJD8LdfLH0DqqBPTUBe3randXXoRv562G+AGIcreasECStQfnrOWk8/Pti8oSTgk8q1d5RLV
	VKWIaETMmxrM54g/tRyDWU=
X-Received: by 2002:a05:6a00:987:b0:82c:db50:ef77 with SMTP id d2e1a72fcca58-82dd8b0388emr3210268b3a.49.1775728788079;
        Thu, 09 Apr 2026 02:59:48 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.02.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:59:47 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 1/9] smb: client: block non-reconfigurable option changes on remount
Date: Thu,  9 Apr 2026 09:59:18 +0000
Message-ID: <20260409095926.905020-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 fs/smb/client/fs_context.c | 232 +++++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3f0faae99ed5..0f6c1eb8e274 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1021,10 +1021,238 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
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
+	} else if (!tcon->unix_ext) {
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
@@ -1093,6 +1321,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (ses->expired_pwd)
 		need_recon = true;
 
+	smb3_sync_ctx_from_negotiated(cifs_sb);
+
 	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_recon);
 	if (rc)
 		return rc;
@@ -1205,6 +1435,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
 
+	smb3_preserve_non_reconfig_opts(ctx, cifs_sb->ctx);
+
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
 	smb3_update_mnt_flags(cifs_sb);
-- 
2.43.0

