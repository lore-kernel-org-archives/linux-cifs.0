Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3B078F2F
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 00:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779149702; cv=none; b=uUm012nBc8zHDc9teIK45enMTbSk5HY7GY+dshNIebDESiyzS47ncVLpiO3rfHUgmGRv/ih31GW2nhTOJtSo7wExsvTBGtC5M64kFrjSQ/elVWsNhitMy24q0xCHE1boCT0Ib8lx/1jG7yuLghzx2lPdW8+qHi6gjBh07i+X5v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779149702; c=relaxed/simple;
	bh=ZMK4DlE764HUTwljvIQjc1JUP7MK5O4d+nCBgxJTpho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SYxb/+SkL3asp12YoLkEFwhKYZpoE5XQoXWo4jsyjZQbURBHqYyU9a+Ci4pQJw7Ixhdq1bFyCuh5wzcuTeuy81sdmT7mt/IfXmXrf0WYEbczrpPvTG80mGJ1bbGX1cQKC7OtCZoRgz3qrbANJ17swlFOlnQj/cuQKGnK6TSlupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOUk37FZ; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOUk37FZ"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2f68f3b075fso11165469eec.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 17:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779149700; x=1779754500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IlZT9gBNzodZazz1VSlaC5AD/Rv2R/7GZsEcbHJOb2E=;
        b=cOUk37FZJ6MBq4PX/9+hH+Pt1RLJNhWIPS1Nz8TJptP79OS/1tiLxKGlBObq2Y9Qtr
         lvLjW9hLIMPdbCwQFfAk0ACRwLN2NPPncePIhvBVGHZhiR/oztq+shsHOYGrSHa4U3qX
         XmAXrWd7ljUS2F44j4FohmDeLZJqdReEFK79OB1gN0T8xsWIHAFH/mZjqVdUVuypFv5M
         yYd1uvjyDEmYVFxiFZfjDi3T+uuFzoYFFzYig3lPcDaf1K1UK4YlLypK6X/47RiQSEgh
         RkohKBtX/IAQqb09JSE2fw50As8m9ODLFbF21VzIB13A0PcoLik852oWd4ntC0ztzQ/b
         s5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779149700; x=1779754500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlZT9gBNzodZazz1VSlaC5AD/Rv2R/7GZsEcbHJOb2E=;
        b=FAWbqJTFbUcgvbFAW3OVTNTSbiAMHYGZMgy/tDy0bLPkbDr8jGtS/das8Gw7u5vFDX
         cC5uUyozS3Xpo5HtIL9HyRKahFa/Vb723NgSvUBC0/VWUcBRoFdnxpykA2ObeGrDxlwU
         6s2p2tMsJ56SGywZmB0qvAaWWfDpKkscAADk6XtTbnYThb+E4Rg5nuWno4M0J8dmnz1X
         6leUCSTmlAmX8X4KfNM9je1dF/FiQnJLk+0Q0zes7902gie/bdd23Hd8lNcHCS1RBSLo
         xiSw4kkyhr9i6t0G5WRqiSiSHUUKS5o9Zi2dNCIzZHcwr0dL7JVoM6gEnUSXf3vUOgey
         K+ig==
X-Forwarded-Encrypted: i=1; AFNElJ+sPNvXC2qaX2Rqny6J6sGGdnKZ5CzZTgjJCFUVE1D9+BQCnwbSjUxApZgbitjacXo0/Id98rzEr+EM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6K2PzH+q10wrG2+UFyPXLfqS5ewdy+PngEfUk/KW/A59rVKno
	dn+rguZ7jgiWMtxTp+0E5v1cS6vfioxQKBTh1L0JX9w/g3fjTMJ1Is33
X-Gm-Gg: Acq92OEC69SBg1mfd6xBVI8fnJ0z51cYtKzdvZ/QB7I1SjQBI+VCWwWaPdw1K35Pn/b
	BkTB3lcIzRtTMinKekSVHhnm06XGoulKYMhIrCMTq/7xMdY+cKOthWGxVZJf8hkI69fHbVneJJZ
	jQOFW+aK3zrT0IVXAxzusfyFxpFKbwGOlRBJIxyEVsjGq4fTALUMK7QO5qWaZXZy9HNCPC8C0Ev
	y9BAO1XfeLeSXlNI0D+7NfquRopFyc4cpQkH11egS6uaR77ouB+vu1CYzOvwC+stpjbFkQRiStT
	0vCTeqUNdwU6VFrIp2EuBE0ZSSqspmLkWoGbdXRnr6LE/Q44swbw3YoSNnxtrVjQc3jzWNXVqHX
	wTk72XujlB9IVzP5CjobLusW/CeLbyfSJLSxIpj2/JQrMIlaAFjkiP4B/EdGsGhpbBbwqZfaXVa
	Gk9JKxAt4tM7M807s9YW4nLGxa+dVbitRwgP56Fr/rq0I8YlhEH9Y0pIjwprgAKZfxbco9GMmZW
	pf53MqtSifvMLhe8eKf
X-Received: by 2002:a05:7300:be17:b0:2d9:6373:ad1d with SMTP id 5a478bee46e88-30398625eb1mr7308991eec.20.1779149700199;
        Mon, 18 May 2026 17:15:00 -0700 (PDT)
Received: from FredPC.wirelessinternet (mobile-166-176-184-21.mycingular.net. [166.176.184.21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978b1a79sm14940844eec.28.2026.05.18.17.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 17:14:59 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: fix memory corruption in smb3_reconfigure()
Date: Mon, 18 May 2026 17:12:41 -0700
Message-ID: <20260519001241.553855-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

smb3_reconfigure() modifies the active volume context directly.
If smb3_fs_context_dup() fails to allocate space when copying strings
of a new context into the volume context, it clears the volume context.

Add staging logic (tmp_ctx) to ensure that either the volume context
stays the same on errors or is updated with the new state, and is
never cleared.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/fs_context.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb03..3a6f207a5 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1082,6 +1082,7 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	struct smb3_fs_context *tmp_ctx; /* used for copy of ctx to cifs_sb->ctx */
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
@@ -1205,13 +1206,19 @@ static int smb3_reconfigure(struct fs_context *fc)
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
 
-	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
-	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
-	smb3_update_mnt_flags(cifs_sb);
+	tmp_ctx = kzalloc_obj(*tmp_ctx, GFP_KERNEL);
+	if (!tmp_ctx)
+		return -ENOMEM;
+	rc = smb3_fs_context_dup(tmp_ctx, ctx);
+	if (!rc) {
+		smb3_cleanup_fs_context_contents(cifs_sb->ctx);
+		memcpy(cifs_sb->ctx, tmp_ctx, sizeof(*tmp_ctx));
+		smb3_update_mnt_flags(cifs_sb);
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	}
+	kfree(tmp_ctx);
 
 	return rc;
 }
-- 
2.53.0

