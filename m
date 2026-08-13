Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D007443AB3
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614191; cv=none; b=GfDA13E+Ny09OMmwEfgnvBD/FTBmGtbl+1rwKfHumcX5YcveNDsdDYS20CL2Zeals1izW80Z3cDlj5oitXF9sGAv+ojuCpSedqaiJqyODsh9FDmjiF5SPEHkbqfJEEmmtDPki5TJJ/y99dwls8HR5JrRpFUsbjmgJqy6ptK5gc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614191; c=relaxed/simple;
	bh=k8UVhkm86ljE4Me/QzLKYsuU06N8g9vgKj4OwZfq4XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3hyPTxzC+xGM5sgu8CCytzRbfe2BrWyfak649y/96WUbbHMMceyXOxPJmkABdClxBxh8/WOsg1uj9HBsop9mvBYBVp4InCvXvmuJcBCqz45vFWxaJ0+2oEglBn2uDalPccGCF+HN/Be209rfP/pvd66LFslu4jUp8RhumeKkks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvZl5nAS; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvZl5nAS"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c999f162c9aso1431323a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614189; x=1787218989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kI5CEQ83tKfejcaAIlWYv6Bailqi5XZqTpDVk2NjyKU=;
        b=hvZl5nASNbqiyEG9fbcql6JzTJVlqwDiurCRAwnfVFVYWwcNTsm2qw/UcBPGmUVls5
         NjcTvmUNxBVkNImwRwFBQWdiWaUDZnIAoLIi0pDaSkM5g9rjv3PZ9eHzaLGVZ7JxzUvZ
         rX4aBV3rFfbkfJrZ07anPXTnoTHwKVo9mLe5QXUKt6VAxXdW7iv2rVxwkhoNgxzqkZLU
         Hd2v30LA+zZWCcXS7eBexQj7v65owWbDuW8qrw6hZJq7Iyn1w1eq3lG32RkuUjiGoEz5
         6e7vC2j5AOAs3NODsXyzRJSn3GfhKF6ZLqxI/xTo1IOT4NRQqYatSix3RHQaRTUP96k0
         nn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614189; x=1787218989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kI5CEQ83tKfejcaAIlWYv6Bailqi5XZqTpDVk2NjyKU=;
        b=nUoE8X1ToyW0uWuiWbp+UBfw+zSnWv3r+o5Qgzlp6BitLq7/4YfhoxR0IUkE10C9Lu
         ppFMHGwPYBM7hZC+Bxsuygbt2cXkJJUAjUwUQMUAkb158qlgs4oay16BDc0up4Bg6l7N
         L0gWjMMwKniMZ2M1mcXrLUzs3QnX6EAo4FKeZtFXUYv/n+O7logwoxzK0d+cnnqaPxhf
         DeMSdOgvAquK0ZRiv34zu3N8w//Qn0h4Fdkbu2oWvKbskSgw4PcuyYhRg6F4tZtY9BZo
         Op56hMgU/qnTVUkaC2Idu/ekNyh/wdRT0JYeGTnBReLojVmkG2L7xm1HE4VPbRoIViuM
         bR0A==
X-Forwarded-Encrypted: i=1; AHgh+RqN4LFeB7yGEo091r92CvwgHPG1yfUhtwILK/NQG3u43w9W79JqwhZ5j3lcd79AxmzI67lWo7QAkBsS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3zqeiiioGE5PHc0x4c7EOqmv16Ku2NpM+tg9qS+m648xe5z2Y
	tcsNk2CvioE58iKaYBOAQBuU9fCpafism2Dhr2LwzsT6LoWXoSq8Kr8zpSGfqA==
X-Gm-Gg: AR+sD133OP4Sj+xt8WPyHTpL6eqffRlloyPFsXSK5hy2+FNyvm+J/8IH5ycw+uunuSa
	WsmTo9Et9FfgfS2Gh4/6TGksZf21N/aWHKa3w+17Aa2kyH/7bKMHeMYHzHyC5u4tNOsuBJ9hlZ6
	8ojNjj/yrVW9okCNilhKxiffyKfOpDG1ORsjmCZTaimP2uJc+3muZOlWTqQOhdOXKW/OQrJxxs2
	ecR3yvcSI2hQwJOT2EameTQAXffKYGXrNOOK4HlSSq+q2+Fz7s9IsfQ6eGRzE7MLs14YMbab01/
	VwDGRjVL6EfQpLRC0TOkiZ/HNCWtrcgV7j7yVUNflDFhc0OjjHq/Z+QPUWWrAeW+56HOR6L1cTc
	Tsx2axuUtH6rJayvv6tZC+BOOvF4p8WvlgQLX0NOTaIwyKTMjcqruz4upiczskRgMk87oa4Z1ag
	S29WhmVJwIylOPqOOHKJrXzPzO9qinIGv8V+xbXO7/hdZelOuavODIr86sXWE8vvULQUpEYjX2U
	fCrb9s//eA6BNhP6AltMipzwyIOH5JO6Ff7rEcunCQsSRt2TOQw4jO65cmTX6AeHoQHMIL2M3qN
	okC+uiZjOUFpE7Pg
X-Received: by 2002:a05:6a20:728c:b0:3c1:fbf:1e2e with SMTP id adf61e73a8af0-3cc550e3a2fmr5650390637.10.1786614189364;
        Thu, 13 Aug 2026 02:43:09 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:08 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 5/8] smb: client: apply rasize on remount
Date: Thu, 13 Aug 2026 09:42:48 +0000
Message-ID: <20260813094251.666373-6-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
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

Not addressed here (pre-existing, independent of the rasize change):
a bare remount realigns a sub-PAGE_SIZE server-negotiated rsize/wsize
up to PAGE_SIZE via CIFS_ALIGN_*; and smb3_reconfigure() briefly NULLs
cifs_sb->ctx->source through STEAL_STRING() before restoring it, so a
concurrent DFS reconnect reading cifs_sb->ctx->source locklessly could
observe NULL.  Both predate this series; the latter shares the
unserialized cifs_sb->ctx root cause described in patch 1.  Left for
separate changes.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4a319c113196..ee8e38c3b7f4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1368,7 +1368,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
-	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
+	unsigned int rsize = ctx->rsize, wsize = ctx->wsize, rasize = ctx->rasize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	bool need_mchan_update;
@@ -1462,9 +1462,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
 	}
 
-	/* if rsize or wsize not passed in on remount, use previous values */
+	/* if rsize, wsize, or rasize not passed in on remount, use previous values */
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+	ctx->rasize = rasize ? rasize : cifs_sb->ctx->rasize;
 
 	new_ctx = kzalloc_obj(*new_ctx);
 	if (!new_ctx) {
@@ -1553,6 +1554,12 @@ static int smb3_reconfigure(struct fs_context *fc)
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

