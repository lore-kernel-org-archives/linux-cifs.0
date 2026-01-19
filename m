Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B0638BF8D
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841053; cv=none; b=B5SAoXArBUfxs7eJ7d3FA0uh1BaagM2Mpkz+i5RyjIHe69bgWJ0vG1mxfmf/98vmlVlWMM2dFftK4eb69K+1hCBMRl4kxcqCt9cQx1j1qZqOnPt4fvXa/6+0zfu1EEwQLSyR87edncgxjR/NbzfC8Mn+MSxPxFyxLAsRg5rRDzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841053; c=relaxed/simple;
	bh=svT1/kO9Fm5LsQQ+8iGaf2OpTuO3oOkak0aa4SyIkHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AoimbagxPz4zDIebnQQy7TFN+7eTm1UNtqbea67UnXQHSaVFSLVxO+PBApZundcL2UcbLcEFMVnNeXHsJojuEV9vyiNmbkBtIk1uddhcOG1+Wf+et9jsge8/Ya5q6Fv2Cht2ZXymBq2XG2NJc0xsuM1zyF4tshVRQSElxX2v51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T6GdVkkS; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T6GdVkkS"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4801c1ad878so33473535e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 08:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768841031; x=1769445831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MgLzccUWq4iGBHcGxE8g+OXGVNhTfRDHPShYoi/owx8=;
        b=T6GdVkkSTFKjLYKA+FDler/x0SM5G4h2OXRRHftKizuu67DfzxW/+FoILEHwDAb/Mx
         j3xOdAeUma/+8jaH6hEUfUewiPlAhbb0kTpephokBXhmSKmJD1vg7ah1+sxq0Kck7N4U
         iOqbh/zxXux4Z7ujW8wzTMuMb+/xQONXrCviuGz2v3pH+N2+r7XN8z7VSjb6d0Od94ru
         Brxuw34uxrS45XGXZ8pGnU8qPZB6HwcfY2pZtGHJpo15Jgrw42RSkyOVAmzTHec3kGW7
         PU8W47o2gC327TgcVO+HCSqqapTVcqMaaVBEuac4zqMveWrP9cgykmf75+8LZ9tLlitr
         5e1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841031; x=1769445831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgLzccUWq4iGBHcGxE8g+OXGVNhTfRDHPShYoi/owx8=;
        b=EJVU208z7zusJTZru066gs13HvpCONnPFhINy3Vo2ucqVlYBNxu4JmMxvrxF25TFbT
         Kkot23gpG7IU39iMBARqmdfPiA5VdD9plTJB/bSfw7SSZ3AEQsbLExn1VevT9smvkytF
         Ej7imdu+M7IOj91wkWDtfo723BYEaLANig5WfVDoHPZZUP0W3hkgw0DD+en2DvA2RCy6
         oKvA3x5UAlarfPKCph/VdxsH/LWZyE7L/+VdYuVp6qR74kFYlo/d5OpglqPmWdlAyOKT
         8/jYFUoT6v60jghyLJvVJLZoryGjhyLsngYJ/PMFfK1a5UdLtQCVrMxd0lhViepwnDE3
         E4Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXnFQEldMwuUjldUzd32npW9uyaFvR7VZz/fJq1Iz6BQVZm5EuBl7uShlap8rUbCKs1giJGuxMFvK6W@vger.kernel.org
X-Gm-Message-State: AOJu0YzY9baKA67hCAZheacNC3Ug4Gc/YoV4ptpIlppcFl5eSv/TFgmD
	Vvthi6Os/a1A9tgPa6zXehQD5f1eeVXCjY0aJsjf28xmuESK0CCJPGrWeF8kR5Rm/cQ=
X-Gm-Gg: AY/fxX6NuwTi+NSVETk/nC2xxkYnHOFz3RLiAEFPAnKHoxpLsTFIj/SRkRjcRdsbHSl
	3N8fiRY8DZV1G/GFfTOBqu4KAveuGUJyY1QwJOVrjMsPykCl4r/dSgUERHv/FroJZgdG2oaEN95
	pc8K/Q01LyCQpe8gOvP4+OxfSR1nTm12ZuKCuxp6yWPNM2pV8e+WUtgpLhdUTT/LwvFtOqfohUM
	YFxDQeq+JhUNXZSTZSmFI79ZKqkfyHenQFiLJ8nXf4rJF9ib9nMj883pl59E5r2IBHpE4OiKCKB
	rx2H7SIjP7JbM4BBUwGi/ektGqhH1ItbPjyxRe9dzxCXJJ5cwPyKf5d9ug8eETpuyVUC3U0GyfY
	Ctld1OR1FLGFLSvl7T/bjraSmo0g2yWnN/4JYsTkpOxtxhoFbv0zOdvWCuO9GQtix78HOr7sadL
	w+mHGpJDGo87sRAlC0
X-Received: by 2002:a05:600c:4f54:b0:46e:761b:e7ff with SMTP id 5b1f17b1804b1-4801e34821cmr129307645e9.28.1768841030730;
        Mon, 19 Jan 2026 08:43:50 -0800 (PST)
Received: from precision ([177.115.55.201])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6bd8e7cd9sm12539518eec.16.2026.01.19.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:43:50 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH v3 1/2] smb: client: introduce multichannel async work during mount
Date: Mon, 19 Jan 2026 13:42:12 -0300
Message-ID: <20260119164213.539322-1-henrique.carvalho@suse.com>
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

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V2 -> V3: restored comments present in smb3_update_ses_channels() and
added Shyam's RB
V1 -> V2: remove vestigial fields from mchan_mount and replaced
get_smb_session function for smb_ses_inc_refcount

 fs/smb/client/cifsglob.h |  5 ++++
 fs/smb/client/connect.c  | 61 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 3 deletions(-)

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
index ce620503e9f7..1b984669de29 100644
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
@@ -3899,15 +3903,64 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
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
+	smb3_update_ses_channels(mchan_mount->ses,
+				 mchan_mount->ses->server,
+				 false /* from_reconnect */,
+				 false /* disable_mchan */);
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
 
@@ -3926,17 +3979,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
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

