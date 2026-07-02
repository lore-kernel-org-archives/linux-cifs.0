Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA03C1F54
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992161; cv=none; b=a8uoromt5Qvg2mULrT8VezJ8eTThO/oKcKjswCcpxYL5y+QCboRXeYbOyG6Jy2nn3XoivcDnpFrGuHEHewZHjyjHXijF2tKzOz1v9mOnYupv/oJVLg5sY66Lv8Xyo0XAMnH6HDWbeqwn+usTnCDI1j0EcqU9TaXgpgbTgDu3qmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992161; c=relaxed/simple;
	bh=toEDa8c8Bw1Ro5e+rhuh7ud8Sa//Wl/ICccogwCsZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcit3DPRLAyxC/pvOf/3CAv5ppbU6xrGPT/kodtIHIvLXzDkDdNsItTbkg8n13wt3gsWJiBVm8z0AGoehsUegUiU63ll3kEnMVwnptFY16dxgD+L0JdMgKUM81LbVSCqqsQWTF1NHbQYMJzCCVh7hFVdQvEa/pjR+XQu4s59lXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KpCE7cgj; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpCE7cgj"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-380d9481551so758708a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992156; x=1783596956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNRVcjrSmFHfVTPq3R+9IcQ/n8NpuhmUFL1A95VvlLE=;
        b=KpCE7cgjOD5eTmcjHfkMQWz0p0c/jqVBptmI7bGdbXsfEkIzRNMEVABnEd+T9Ny3fW
         9L6Uz6HeIXpwlO85pT2qKKtj1cICw5jdik/V+e7ozLFIJbob71/vQKxlk78IfPBV3gG3
         EiGRzvB6HVz4f8+O2I+uSdSwhyzAErThZ8jPkzTb/G7Ht7V0TinFTZjPWkO6/JwpkTtT
         isgqpTyiDOFAPF/+VsZxwzfQ2sP/M586xVFvnf4za8tlor/QFjiAAiMIDwWIYtFHbgJy
         rHTP98K4IKMSYERVFzwEhVN566M/iMsUf54cFsfJVQn9jp/ttYEmD4j0QdkctqIeGkT+
         leBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992156; x=1783596956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNRVcjrSmFHfVTPq3R+9IcQ/n8NpuhmUFL1A95VvlLE=;
        b=rnr6fgaWyxW9viTqKpy8B+dhGdE5zWtXGfMc4oDNuXTq1fvQvh2tatkWVeunahlUDs
         5PU0TVFeqNG+uOS8/rzWmN/VAlLciEhg6/PFSKOu2C4K1z4IeJUWtLUPoZ0LWSJvFMTY
         1ympcAn7CNuviEnJkEnX8oejrs18vBI0HRs+JzJQ3REZdCWfY8i79Ue9OBYpnpDiT2cK
         AASghC2a+2ZOJwBOslyhSACt8vx2x5KQh2CyXC2sRCCWjbnofu5okvcNcTMMPNHoX01J
         S8BxA6oP0v0N9yOQhzz7w0kBgMyzeC3HvJ6pzF/Ujz6zetk6wn67GLVPMhu7zbPFLjWZ
         7WEQ==
X-Gm-Message-State: AOJu0Yyj8ygZ/i5StFMK918JlWhffCxsZ0TlJZCQ8eVHDWgkBzwDHILN
	2sbwPLyln7YqBAebuX94cwWDRBJbjZ/hFh0+TatLWstlTctm1E+kmcY0/PGuug==
X-Gm-Gg: AfdE7cmkqvY9RuAaYTTEqCkv5ewmh5RanPPwtHrrwF1kP2u+qAxwMAqEJfRr1frAbse
	hoeJ+ZGugY09PL9t+cp00M9JISdBNwm1RcSNJkK33u6vLpTuTn7LZ3Ts7aPkLrm/9j8iF34Ixw5
	vWwPboU+L1Ai2ONjy0G/nrofjpBgtS7JURmqjNGdyHe8eandrWJefmdUDjc6SaqsGmuefnAjRZX
	dqptCR/nzNcIQoAYrPE7u+j9qH+FqyED4abGsvTHe9xrYkbkps+LTkiXNaRqCA8pqtOdyhJGwrE
	co8rQOZg+sgybl4l49aUUgll5/sHK7/lLIJCZB0mteEA8Q3mt/x410YkFrUzA57MOBo/7DqM/DN
	/Y1JQMwxjzvqphYLYXjragkbFIbpPcSJUZEh3fGmRMzWVZlu+utOd0CJfgKmtik0RW5TIUJSZ3g
	Uc7XTmvowc4NLBTLg9329eLjnPRNkqTpTbfX+CQFHpOd1+KoNZ/TXMCxY/DSaYL4NpmrPlk+S97
	aNBIsO2uNJR
X-Received: by 2002:a17:90b:1647:b0:37f:d70a:9605 with SMTP id 98e67ed59e1d1-380ba868155mr5287679a91.9.1782992156270;
        Thu, 02 Jul 2026 04:35:56 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:55 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 5/9] smb: client: apply rasize on remount
Date: Thu,  2 Jul 2026 11:35:31 +0000
Message-ID: <20260702113535.4044308-6-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
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

