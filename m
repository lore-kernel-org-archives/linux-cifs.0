Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436D2F49F8
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 22:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768601245; cv=none; b=No0eEG4yf3xo+F5iOMXUCJOz5K3khMi9aqvSoZ5pEjmXB9qu03b5OINY4e5J3/yBRGtC/ZgNnNIK4Azuo5U2LAs83zeMUuVw4EkyBtGybbjDT5xi7+rcO0XEfrov98Mcwr3rWWhFUsgEW27snftjyI7+XCYGa9EfCsKujD1aJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768601245; c=relaxed/simple;
	bh=Kq8P0WX0ctY1DhgN4F3UvQ+3cexK4p97UmeNenMzZs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aVFmyFqSX4PPhCq4IBO9ZnnEpPcFoUFCjazN9/SgAuFlJzBpeGJDQH2wlk+waSxBlOUP5V+0wtgLpaQJsntcsJMRFFQh+NkdfxqtT+fVK9XYfl1dyHZTSHQ0a4wH8DYlRpkeazoz2ifpiJvqH+COWKmKJuqNcaYetE2GYiZEQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AbK1mAQ5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AbK1mAQ5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47ee974e230so22467415e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 14:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768601242; x=1769206042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6m0+JOPyOojbbK1y55z3kuOmh+4woC7skc4mTyiMmU=;
        b=AbK1mAQ53LKXoR7AxzGjZGSUGozJ9TOLSxIeTjz7cNPHv/Jm8uxjP4DXAgRgPsw0eW
         kLaHdx6rcplHKMlsBlrW+VipvCOv4oHpf2RaXnKbSjoWY0kvsEiCtaQ7w3CKJALM3yDP
         QWsNJCVKdcME5oD4HjZV/uKPYd1fSPxr8KpL2E7pScDmL/CQRxJKEuuJB7cBFfPscop6
         9xEe9BR6+kjgoj6YIBhZSp4j1yF07wcv5QLpZyJnrLsFhUSKbwKz2RdBlfKw/zV/TrTF
         2krQ7KtEgC24SENRIDiwQ2WPYY0KkSCOWKtTZqnI/lu41WZ+cMTvCnG7fLp/8zMG95Ui
         d2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768601242; x=1769206042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6m0+JOPyOojbbK1y55z3kuOmh+4woC7skc4mTyiMmU=;
        b=Sii5UyAWAdvxyC+V/rp/AiCp4z5vQEckFhttIW6gK+GY9VhFImDUVBZSp4eHLR0Yk3
         CtubOGuC3vzBbdgQoWLEzTpNlcUY28TudueNHLVSqNnD+UUBShFg7ClNJl3B3BA3n5oy
         H+3wy+G93tOCffDm0KK+YXNy8+bPCEhX4tszZ4DyKScY4q+q1GzMVcoPigj0E7HZIuso
         8aXnt7ffpgw7WgOFErEPvPEvhQkHU2ZXtyR3ipFHXS7sLFar1wGJHGbV7oaNPVgJNm/y
         KFOBab0yV2Ccql6Hl4/uP5NGlFxt5rxBXZaL/8mC/u2hqojeBxMUYb2MkGo+Htn/o/6A
         EUkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2FO2S/fZP5CPbsjCq5B1YDsQ77T72tiSnAvZoSiQSkiatD/Pde/HrCka0eHLiUSJEBJuhONMZc5O5@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4y1Umrz0mijykHujcVcVb0pZ5wbaATP0+lwavGwcTOQTMXjQf
	G769Yu5CZr9F/uQbQX48GsbwR3sH/4pRNqzFxVLPj+TN4rUj9cqLEwj5vKFrMx/W6n8=
X-Gm-Gg: AY/fxX6Vz4WfK6y/6XKH3xSyff9ZzgeTqwK4gGXh5nCV9PWT/omjImAsu0zb9qYNef0
	j/iBD1+64wLs54wfTSsWsvMFWIQQ9il7e7zXdTp8E6n0zkjtFnojtypedVNTQiMfSRbtaFMaKbK
	XdoNEQFr02ZR1jrVRycQkyu09/eovZKspsF4/v+dejHA550Xiu145MptEg+xYzmyMqwYXzts0tQ
	yq6mt8F+nzU5PZSdFctZrooIgqNU8LyK3tFQxyfWnVF4cURU4pPIF7zv/+4vmIX564WrvXnJuGP
	YJBeD9EuhR8e57uYOKATvcbfBYT24MdRGsHGJltC4jvhZUHueomxsaINEgoZZJrlDwo/l+93GHM
	LrUhHwDDmKQxXYTXXyLzdqgkLeDc7x9bTwg+7tvA7+ZSqhadYSD2LWvSK/K05SdvjU7aH4OmfTM
	SEDw+sMG3vg+zAcN2HW/GD1UczKyV/MwAT8U2z9xIw46UPm2I=
X-Received: by 2002:a05:600c:4e43:b0:471:700:f281 with SMTP id 5b1f17b1804b1-4801e34835amr52366485e9.25.1768601242280;
        Fri, 16 Jan 2026 14:07:22 -0800 (PST)
Received: from precision.tendawifi.com ([138.121.131.195])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b3679980sm3737890eec.31.2026.01.16.14.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:07:21 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/2] smb: client: introduce multichannel async work during mount
Date: Fri, 16 Jan 2026 19:06:40 -0300
Message-ID: <20260116220641.322213-1-henrique.carvalho@suse.com>
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

To fix this, decouple channel addition from the synchronous mount path
by introducing struct mchan_mount and running channel setup as
background work.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsglob.h |  5 ++++
 fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3eca5bfb7030..ebb106e927c4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1796,6 +1796,11 @@ struct cifs_mount_ctx {
 	struct cifs_tcon *tcon;
 };
 
+struct mchan_mount {
+	struct work_struct work;
+	struct cifs_ses *ses;
+};
+
 static inline void __free_dfs_info_param(struct dfs_info3_param *param)
 {
 	kfree(param->path_name);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ce620503e9f7..d6c93980d1b6 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
 
+static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
+static void mchan_mount_free(struct mchan_mount *mchan_mount);
+static void mchan_mount_work_fn(struct work_struct *work);
+
 /*
  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
  * get their ip addresses changed at some point.
@@ -3899,15 +3903,61 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
+static struct mchan_mount *
+mchan_mount_alloc(struct cifs_ses *ses)
+{
+	struct mchan_mount *mchan_mount;
+
+	mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
+	if (!mchan_mount)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
+
+	spin_lock(&cifs_tcp_ses_lock);
+	cifs_smb_ses_inc_refcount(ses);
+	spin_unlock(&cifs_tcp_ses_lock);
+	mchan_mount->ses = ses;
+
+	return mchan_mount;
+}
+
+static void
+mchan_mount_free(struct mchan_mount *mchan_mount)
+{
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
+
+	mchan_mount_free(mchan_mount);
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
+		mchan_mount = mchan_mount_alloc(mnt_ctx.ses);
+		if (IS_ERR(mchan_mount)) {
+			rc = PTR_ERR(mchan_mount);
+			goto error;
+		}
+	}
+
 	if (!ctx->dfs_conn)
 		goto out;
 
@@ -3926,17 +3976,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
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
+		mchan_mount_free(mchan_mount);
 	cifs_mount_put_conns(&mnt_ctx);
 	return rc;
 }
-- 
2.50.1

