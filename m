Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510542FFDF9
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577764; cv=none; b=kg75RL+nLbbAxOEyQDwl7tM2xzwtNFjkT/exQN1GI2DwPjSLC+NX0kLpOdvBa7RKlbTHBruo8m/vXawghykazIIdxe6tbH964dO5bBRmsClHPg/FR6MlBE9k2NkGZTk4+D4i8JDGVlUEwhfkAAe3A0MUpKkgRizGWJ3NTIphsyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577764; c=relaxed/simple;
	bh=Co1vS8tNrr5HaSEYi9OaAhVeIoOqjYvxyFmJ9AtcnRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CtftYcVk9SqTTm1481HEhqPGgdRi7cNiYM1wYNd/ICva+Dib7kDuVxbmypGwpu5Yg6txsYOGEwkhKNu5t50g5v475gNTkJ1i6wwAgN04WSN2ZvMQ46F+sjc8BguJPPkRwZeYdD4iDuwAetkX/UJOmvBfI8vbbcSo2OpyJOtUt5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XFtk/1/F; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XFtk/1/F"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so11507535e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 07:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768577761; x=1769182561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7XfABeYBe/39iJGNxrPtgOF7IGByOeXP+Cm2JjeSwHA=;
        b=XFtk/1/FQRum81fH3We1cw8ZaSwqhv+tsXldBm9WYJftoP3A4SSxwc2vD79ejhYiBC
         qllPQ9FoRt+bJRowBY+V4aK4+tKwHvXH4xm4KE+hPVYHYzAPKMH3wPLoYrQcLrimItdZ
         JNRMIwQR19uL7gL+4iVPTacGKqELJgTe8RN6gwaoVrzJToD+lwT69nYaORYFMeLee5+E
         EpGRSsmsUkJBTs4R2NmyM17Jnm5Ktl2nomwwob+vGlydPprYa/MiJ+lHtuzp4s0Cmu+Q
         LpEUWBQfL8JyT391kIYmfQV5NYX/Tu7K3+oH0ig4o1DFCbzD5NlWuh7mAReO+wJtW6B8
         kdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768577761; x=1769182561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XfABeYBe/39iJGNxrPtgOF7IGByOeXP+Cm2JjeSwHA=;
        b=ZfUGW8yEL2ZLifoRgBm9MGUWy7+qo5cESd0TlgXy8xv4TKVrnlOyLT1clU6xA3grUt
         x594C4yUoEnCgql81MMhoczPhuGhj2DyqCrYU1XnYDsoraugiFtdvQgz7fEmDK+LEM9/
         K/lM8Bnrd7ZHt9OIajeQSeYUdujKkQkO4rgX3ucg01l7eUrU/QQa9KMVPmqWGEGUR3Dr
         H4IaDkZTcMQpgtafP+6rR1EcHAYXbn6PanWeUhAgzQ/PQOUgHr10u4bEMEygws3OuSi0
         tCkO4RMGp2cpx7+TfPC+PcVm9cJvTLOo3xJNpezsN9kr+xz5Vik0dUPP4JzbTi2g1I+E
         tzRw==
X-Forwarded-Encrypted: i=1; AJvYcCUzgQxs4IJCqv9aI0sCAnOwYweIqr/iH694aHR2LwbNy1KWElfnLsXlHNtT1hVFIEWaHFmI0FYRIJuY@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz55yWwPY4mDk3JuXQ5bBkSGmqWhOfE+pn/mrPKCKKB9v2cWxM
	Z4qdgbyEX/zH7R4Io42SOmFq9yijVbin0uvBVsSHS0Xz6ih5RQRUykcmR6t0nkMFdEg=
X-Gm-Gg: AY/fxX6jdlMdn07htb5yx4C7ZNbYRW+l1SV/p1DKhx3d11CBT+aKvVY5uu42Jhf1Rsc
	gnNFnaD56su79/J+PlZhQG+lPRjTja41LzS8r/4o1uXz8JWtrNR7aZ/m3vT8WtE6kzc9JD0tWYG
	Ci0lOntAO+haIacsPD6bkwBftQSA3gBO8jHWBk9k8/OS87kfZpGJPA558ZzIaeSbZdApRcLtqKm
	eqfzCWWallQpKn5KkWTbvFk+mG8FRpG4W7JiatbQggnuJGVLbnJfeTsBDaR9zkQryM9/50Rz29Z
	eLZaAKQVgjiz5NLiVn1U5RiQpf+IJs9x5deL9yVie9ZThmFd1eFwDOrk5qy3lbswgoxrTb4DKLl
	bIqUkM4OKuh1AsBeF4ATN/rQZO75dCWZbtb7+tRSOy2HaWR1ftwdlFUAek5L8/4WQTY3uBByWmn
	8uiJN6kh/XmlMXYh4=
X-Received: by 2002:a05:600c:4513:b0:477:9cdb:e337 with SMTP id 5b1f17b1804b1-4801e2fc2e3mr49676745e9.7.1768577760517;
        Fri, 16 Jan 2026 07:36:00 -0800 (PST)
Received: from precision ([2804:25ac:41d:5900:a837:5945:9a39:70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af22aaasm2300910c88.17.2026.01.16.07.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 07:36:00 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: introduce multichannel async work during mount
Date: Fri, 16 Jan 2026 12:35:48 -0300
Message-ID: <20260116153548.223614-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mounts can experience large delays when servers advertise interfaces
that are unreachable from the client.

Decouple channel addition from the synchronous mount path by introducing
struct mchan_mount and running channel setup as background work. This
prevents mount stalls caused by slow or unreachable interfaces.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsglob.h |  7 ++++
 fs/smb/client/connect.c  | 75 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7d815dd96ad1..ed2f0a13655a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1803,6 +1803,13 @@ struct cifs_mount_ctx {
 	struct cifs_tcon *tcon;
 };
 
+struct mchan_mount {
+	struct kref refcount;
+	struct work_struct work;
+
+	struct cifs_ses *ses;
+};
+
 static inline void __free_dfs_info_param(struct dfs_info3_param *param)
 {
 	kfree(param->path_name);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 778664206722..56c5df9df943 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
 
+static struct mchan_mount *mchan_mount_alloc(struct smb3_fs_context *ctx);
+static void mchan_mount_release(struct kref *refcount);
+static void mchan_mount_work_fn(struct work_struct *work);
+
 /*
  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
  * get their ip addresses changed at some point.
@@ -3898,15 +3902,78 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
+static struct mchan_mount *
+mchan_mount_alloc(struct smb3_fs_context *ctx)
+{
+	int rc;
+	struct TCP_Server_Info *server;
+	struct mchan_mount *mchan_mount;
+
+	mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
+	if (!mchan_mount)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
+	kref_init(&mchan_mount->refcount);
+
+	server = cifs_get_tcp_session(ctx, NULL);
+	if (IS_ERR(server)) {
+		rc = PTR_ERR(server);
+		goto error;
+	}
+
+	mchan_mount->ses = cifs_get_smb_ses(server, ctx);
+	if (IS_ERR(mchan_mount->ses)) {
+		cifs_put_tcp_session(server, false);
+		rc = PTR_ERR(mchan_mount->ses);
+		goto error;
+	}
+
+	return mchan_mount;
+
+error:
+	kfree(mchan_mount);
+
+	return ERR_PTR(rc);
+}
+
+static void
+mchan_mount_release(struct kref *refcount)
+{
+	struct mchan_mount *mchan_mount = container_of(refcount, struct mchan_mount, refcount);
+
+	cifs_put_smb_ses(mchan_mount->ses);
+	kfree(mchan_mount);
+}
+
+static void
+mchan_mount_work_fn(struct work_struct *work)
+{
+	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, work);
+
+	smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->server, false, false);
+	kref_put(&mchan_mount->refcount, mchan_mount_release);
+}
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
+	struct mchan_mount *mchan_mount = NULL;
 	int rc;
 
 	rc = dfs_mount_share(&mnt_ctx);
 	if (rc)
 		goto error;
+
+	if (ctx->multichannel) {
+		mchan_mount = mchan_mount_alloc(ctx);
+		if (IS_ERR(mchan_mount)) {
+			rc = PTR_ERR(mchan_mount);
+			goto error;
+		}
+	}
+
 	if (!ctx->dfs_conn)
 		goto out;
 
@@ -3925,17 +3992,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	ctx->prepath = NULL;
 
 out:
-	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
-				  false /* from_reconnect */,
-				  false /* disable_mchan */);
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
 
+	if (ctx->multichannel)
+		queue_work(cifsiod_wq, &mchan_mount->work);
+
 	free_xid(mnt_ctx.xid);
 	return rc;
 
 error:
+	if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
+		kref_put(&mchan_mount->refcount, mchan_mount_release);
 	cifs_mount_put_conns(&mnt_ctx);
 	return rc;
 }
-- 
2.50.1

