Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FD73E314D
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 14:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372424; cv=none; b=I2vqpEyhakv+TGPnFMBxXZ9Hm9aMRE9dJWMhHPY9DrfV33wPNyaSLrdVfHEOW4/Z4IotYnaCzXhGdj67NCd8gLKMIlsJTXqXWGulcpo7SfoPgVmXzJHFgp7taGV+I6xWTEUJGXw+PPOn0MzbyOtO20Qnk7ZP//lJUf2nD8+tnho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372424; c=relaxed/simple;
	bh=1T8l8REmilfpCPHOBhjUy6PoNfGlv7+n54N3fM8ecbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3l3I66ToBWbU8VDynd8f1HJ6mtdNjMokPfPuldOWhUQbsduB6L2SRSxp5iArgUTrQB2QGcjSvxvKOhficROmGXEwZw13xrctcPZhkXCFs78B10yAzL7vNtdBk9ucGI6mBbZq1P7TH8aN1o66yOrBiaykOtZksrOQF7xzM+RwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iplaEYue; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iplaEYue"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-83ef1d17904so6164487b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779372422; x=1779977222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8rn7+Tny7SXBXyjHw4bmnyLQ4nAf+a0iRkwkUyY9z4=;
        b=iplaEYue2QRXiWHOeCLjxMulL0AoefsZOORc01ljTRLUb3rUb1d3A6bKYJoNZ07t6W
         20II1RF29TOYEO+UpOBHE3wlzQfauRG4vwYiwhkUxTys4qtGuGzXGWV+TFD916nQr+ik
         8eHw8lQg9v11VnK9lT7YO+ZnynN5fw14qj+G+RpkBFLp/xWddzXTN4vQUcYynHTwMUKB
         McjhyiwRw1hPJQJ+/F8b/ZALc0YobI/IigB3w+98ymoJwBIiq5BsVu96FI1YwoUBWdEv
         aHgKD3LEEgmqqr+azvymxu6TNeigRUzzTrI1JmX0GUVLEKktdQu/L6cj6NSWDzGGQlle
         xKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372422; x=1779977222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i8rn7+Tny7SXBXyjHw4bmnyLQ4nAf+a0iRkwkUyY9z4=;
        b=iOGkB8aEmsALQ4UMuSBNVHji9+gZGtMWcuRCAE29IuGIclrFviIhg6njzD9poWK6Lq
         dvaOBtycqvEEiDUkLRFITaEfLI96NerEyR4Jtc+L608WukLJHcTSAlWpm5K/aPMrGCO2
         wZ57rXMa2nBEBm1ee+PEmgt4KP17Bugzj22uphGf613k3EHpYBDMxKuyHDTp/vTQuQzY
         QvrM9GdkK93kyhU7iL7xZsxxVTYw/hzLGuEd7wSj+f30DHnZn+yGraTHTmMU83damcG5
         k2dAgvemIvEUmRcA2Yqt5YDnZ1W3Pvsp40QzXmfS1zA+2xWZM7fiMUZWSzo2sO1lYEVM
         kgLQ==
X-Gm-Message-State: AOJu0Yw+6LB1E1d4SEbv/wjhTs0akJaDBsUK2jQY0U0YmH41+slXERj4
	DcOcXWGVe+2CGJxhjU+l7luef9MRUqWZwPJdwJ8/Khw/BCR9KARVtxjG
X-Gm-Gg: Acq92OHGm9u1A7TFVNzeHJiwbhEO1W12XW35N/UMmuKzeI+jgShL+5dVWcvhRx39iDF
	EgfxRWJx9iX6zgMO1FVscC/34wQLJKma5kzxec8Y2ApsWn5wZSrkzSf4sk/GqXqM0eplsji8tsd
	mk/PVjru8exIrsHV14V19UhKPf3OCHh4MvPn1727zN4g2+wsjjTbyxnC0i4EvCCCRZplPxFQmRl
	sdoHj7o4CjgvXeh1s7x71aOGjAFAR/XNM/llQokpR3Lcjxm7tOQQEpqQ3+dgfnLgglit8Wb4rbl
	DMKJbcu2df8kaEK/C7ivMHBn2JEmW4n9EV746PyF4I/Hja66dZHtv8UswtQ8YWRarhpSzmNVgXY
	Q2nh2610cYRwJJPdykSccW203kybjx88O2Us2exwV5kweqBTU2J0x/OfiDNBcNxs2XOswpeVOxc
	n5GwpTfO+WuE2LlrJ4S9QWLw4MsF85vGzgW1wURtfvw2wq1QA6tLppMD2o5zuwZZ18YSmjaP5BS
	lHEi0tI7WauxzyQCimbmYw=
X-Received: by 2002:a05:6a00:3c85:b0:839:f1c0:13ce with SMTP id d2e1a72fcca58-8414ae69ebfmr3361708b3a.40.1779372422159;
        Thu, 21 May 2026 07:07:02 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841549c46c9sm1719329b3a.10.2026.05.21.07.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:07:00 -0700 (PDT)
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
Subject: [PATCH v3 9/9] smb: client: apply rasize on remount
Date: Thu, 21 May 2026 14:06:44 +0000
Message-ID: <c9d3b7dfc9aab1db3376eae3cdd32f4da1457a91.1779372325.git.rajasimandal@microsoft.com>
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

rasize is accepted during remount parsing but sb->s_bdi->ra_pages is
only set in cifs_read_super() at mount time. A remount with a new
rasize value silently has no effect on the readahead window.

Update ra_pages in smb3_reconfigure() after the context has been
duplicated, using the same logic as cifs_read_super(): if rasize is
set, use it directly; otherwise fall back to 2 * rsize.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0ef8ccd53882..1b42af418f77 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1367,7 +1367,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
-	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
+	unsigned int rsize = ctx->rsize, wsize = ctx->wsize, rasize = ctx->rasize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	bool need_mchan_update;
@@ -1431,9 +1431,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
 	}
 
-	/* if rsize or wsize not passed in on remount, use previous values */
+	/* if rsize, wsize, or rasize not passed in on remount, use previous values */
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+	ctx->rasize = rasize ? rasize : cifs_sb->ctx->rasize;
 
 	new_ctx = kzalloc_obj(*new_ctx);
 	if (!new_ctx) {
@@ -1522,6 +1523,12 @@ static int smb3_reconfigure(struct fs_context *fc)
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

