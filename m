Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4E3D75B8
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589265; cv=none; b=bYLCWXURX/sQcVxjUaMKuVidaIyd1jj8OVD0wxIY3v7/axe9FsnV/JNSbXQ2p5+hnP2Ei8N0eToOexLcSjI378hr6DZR/sATkSwWO+YPpYIgAk8Iz5deMmUsapFx9bOnfIp2NdgqzjDs4r0lsm/hPG7JuPt77eD8VOejX48VhaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589265; c=relaxed/simple;
	bh=toEDa8c8Bw1Ro5e+rhuh7ud8Sa//Wl/ICccogwCsZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nADbSyEnpAZa8rHPSI2neoJgMOwBnLbxo+PsSnZtfW3jGppTS20gJ1/fL2HEfO5PHYNOdTfP5lAJGG8os8nDyrh02qkl8Jj8uek4JvoHSgA0tTOOp0FijF7jfAtlXGgGCuyzEteZ8I/33A3/UBVGNmMYLg4Y5t6Tr3qlMVPlOU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPT07+Ru; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPT07+Ru"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2bf30d530bdso41065235ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589263; x=1782194063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNRVcjrSmFHfVTPq3R+9IcQ/n8NpuhmUFL1A95VvlLE=;
        b=nPT07+Ru1Z+PiUdKmCq2D0AR9BJOKjYNYtNI4zaczg59BnuqG0BOKetgLXhkioFSUC
         QdVf59MABYowUIxG0yhmJRIBLyTbOJM3mIHWkRTy6E9CabiB38NPTUpESGQP+GXsMhhv
         JYnwz+Pg1o8ImSPi8qhIgnOV+kfVYHfMM5WcAHryEXx4PVMNtZuwU6n/zqhPLGnixuMg
         CNr8cnvbZ3Wi1CcmChMeTrxjfYkMFt9DgNBYw2ODzq6n5hXd5vq8U5U5RIapPq2BiY+i
         MiZ0drqrmYrd9w1H7ciXOIdWELXL4qJi2IYQdY7TVZnON5afY/v8B3vjRaNEvOJHQoyI
         3a2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589263; x=1782194063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNRVcjrSmFHfVTPq3R+9IcQ/n8NpuhmUFL1A95VvlLE=;
        b=Z0z8VgURQggap+ujJb7rXOMuxPSFjp8r6STLls1dAcrgzpaE+MOywqgkdUksbTMIW/
         rLL2XstITPk1KCcTctwflV6atvr3VLbJo0/Kbiaxe6NtG0ltRP8mvyCpUF9aTOzgsIom
         F6C5dPjLnWnoubI/vwqEVbQqvRPG2cyokIGgm0nzOYJDKlZ0D8BGCTHAZPi37po5bVfs
         Swb3QiE8OfHuFWa4z4Rw6U4aSMxs5lNu4Svqskki5bROWkhg1vLfsgTSF9NqrUJJcVb3
         JBb8fObBOVWfimTJkIgIel2/XbYPQaxGb3vcw1A9yzCl36p2wA8uRrgsNwYKSgqVeEyO
         IvgQ==
X-Gm-Message-State: AOJu0YzVHkvY4qdNXol5k4FBMDo+hh789BLrZXSw6M87Kc8Jy0Z6XkZi
	tFUrFv3ULKezsXg+OkKtNu2uIs+Njy9Pe5jJw4RakQiVWh1bUSQXIKtH
X-Gm-Gg: Acq92OFJHXKMN2/oOv9mK6jAfuyPXjL8nkhE/Am4OFZHBYdeRirik39Lv3VwFM5wRum
	nYi1ce/z0gLjQ0z/Cpo+e0zHnnihRI8CKEXfsRWPE8M/L5reZkCsUsKND8nKGZF1P25M66SjDL3
	6B5cOpvBk71I9Y1Tvxnw3qUcnjsAI7S+m9cGbVonJQC8Y0ZbhwJwFWwpUzkwY1Qkb88QxiZABG+
	AMtT++0TOTnSTsROXVKhVezTPHav2RsZB6oXBd04mNC3EACNk9A7stVMEIhgvGfKo2i+/YjKEGg
	TiXYEK/0YLx/I8+xNRqyHUeBExDqDsTfV7gJgLKzalTyddl7ilffi6IDE+8Vt/+ZlEe3D+p73j1
	/8VVrAA56VUx07IF4T1fXEHeq2dhFWGbwUNb0Kp+Sy0a1592XrerVR3kVaeKamYryNseghzV92z
	V1H+hBqeDKoGvxSJVSjLKRUnnJ3WpLpTLKsPSIkPBZQVFKWwthLGeOvaEchZl79m12E0qnln7kE
	/iJQNdJ+QE4EgRDQ5xAF1k=
X-Received: by 2002:a17:902:ce82:b0:2bf:379b:53d2 with SMTP id d9443c01a7336-2c6641bb17amr147686655ad.15.1781589263441;
        Mon, 15 Jun 2026 22:54:23 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:23 -0700 (PDT)
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
Subject: [PATCH v4 5/7] smb: client: apply rasize on remount
Date: Tue, 16 Jun 2026 05:53:55 +0000
Message-ID: <20260616055357.3798387-6-rajasimandalos@gmail.com>
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

rasize is accepted during remount parsing but sb->s_bdi->ra_pages is
only set in cifs_read_super() at mount time. A remount with a new
rasize value silently has no effect on the readahead window.

Update ra_pages in smb3_reconfigure() after the context has been
duplicated, using the same logic as cifs_read_super(): if rasize is
set, use it directly; otherwise fall back to 2 * rsize.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 659fb0adb528..0a72e1089ff7 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1313,7 +1313,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
-	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
+	unsigned int rsize = ctx->rsize, wsize = ctx->wsize, rasize = ctx->rasize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	bool need_mchan_update;
@@ -1379,9 +1379,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
 	}
 
-	/* if rsize or wsize not passed in on remount, use previous values */
+	/* if rsize, wsize, or rasize not passed in on remount, use previous values */
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+	ctx->rasize = rasize ? rasize : cifs_sb->ctx->rasize;
 
 	new_ctx = kzalloc_obj(*new_ctx);
 	if (!new_ctx) {
@@ -1470,6 +1471,12 @@ static int smb3_reconfigure(struct fs_context *fc)
 	smb3_cleanup_fs_context(old_ctx);
 	old_ctx = NULL;
 	smb3_update_mnt_flags(cifs_sb);
+
+	if (cifs_sb->ctx->rasize)
+		root->d_sb->s_bdi->ra_pages = cifs_sb->ctx->rasize / PAGE_SIZE;
+	else
+		root->d_sb->s_bdi->ra_pages = 2 * (cifs_sb->ctx->rsize / PAGE_SIZE);
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
-- 
2.43.0

