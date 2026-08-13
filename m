Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883D33F8A3
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607137; cv=none; b=P+KkxS2t61yJTsSDrNC+XDahjg9S7v7BzriHMLsuuHJlQGy/tgQp5uxdqXbgFzWmDyzEPZWjej7RbcrTKvZ2caXe2RJ/10DbHQyrFyPZbKU0F8cHysEOInehpjNEqjfweJaO3QlzohmDIuhhPUQNikwbIYhHnQ3wwEVo6QU9m/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607137; c=relaxed/simple;
	bh=Hnp+T11gJY5ma+YNKeUNMwdwu4AEnC3k1frmi/rGiPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9ojDq8ecZ4d49ZJ+VMT5aCKLzF3Yn7fku5nATavf2EK1OcQ8noCJdN3Yltt97j0cqCBKNbWm0P4FpLt8LDd4ZxZgbSqCtRwEux+rkVVY3ObTAQ26+1EctRM/1WPp4jiN4+6pmsdTdf/IpkeOscCjf1tt6dlYWNsAzhZ8RDEWOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAJMPycF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAJMPycF"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d02b4c3601so16784985ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607135; x=1787211935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MCQGX3q+fBuep0wznBAbtaLCOm6n8IuGlBYIqkhTzTw=;
        b=GAJMPycF6S/MFThob2X212OMNxdi6xUWei1XkPPmSNSYvQq6DfkDmoX32inU3L8LZx
         a7BkU3i8FMHmlzwZfSTixXgaswlts4R3oHuF48f2Uc9lYRZrc95AB2hHoggeuLazZRHi
         +0JHEHk5CzI+21IWoRk9K855il8rjoxH8BG3ODxIRsvpPKR0aU4+aRZ5NzMsudrNHB0m
         3ANCB9Plt4/nyVabtbObWqbUsRtIxyUdJlosVbewOigBpVo7cF4vFYH1glrD4hXTFeS/
         3zCSb1d7Cf1BBOqlmTrmai8XstYj7bXdpQdpcexWbzuEuf1lrvm3vktk+tKkiS1CVTe5
         CjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607135; x=1787211935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MCQGX3q+fBuep0wznBAbtaLCOm6n8IuGlBYIqkhTzTw=;
        b=fgQGg6jrUuGt+tuUA3b/mold+2xZ+ceEdWdR4lAlaxG2cK4HFjIJdZikh7wssC0BFk
         Bg/8vki3EoEPf2tgeiroUXrj/6Zcjt+SY3JB0YD7u+Avpak2AIhP6SXrz0ooatUwTKDR
         9fLZYCCVsr0PDUsaFr7oHqg+LrfM5nBxRDXtHVO/iVtMMJd0x4lfFprphiG297GiIbN5
         +ZxzCD7mizmd0PCAtU625Q1G3GRiMLDUIgMnqSfyuPiDXDS+/V+28oWdcoGVGa8AFFQ+
         ctAhFycae6LEi3xPU37G0EYa/vSHhdYAK8XEEQwGCPu6XMgVrxIFD6WHp8lO1d2Xi3JP
         Bu5g==
X-Forwarded-Encrypted: i=1; AHgh+RrWzV6uKSIpHU2CYBeXfPwACsQoS6SfrZxGuXYADxPaG4y95HyeuW9AVP6Qjrb/6CsedDe3JRMKuPx4@vger.kernel.org
X-Gm-Message-State: AOJu0YzMJ5FsfcunaMP/g+T3HsPxIv0BLXyZB5KDbNxzqZTHpiIxufM6
	kLpjbz9whCRgB+rdLUrKOhDJIKuHHXFl3Av0wLanBun3vINH48UbHgdR/4F66w==
X-Gm-Gg: AR+sD12nEFZeMRZKI8EO0LlyzMzcvrtetyfrsb3CE1YuYobuKRVX/F4OE5GOHH/lnO9
	GWtZs0LetSS+YXvBv+nx2L5ohkOa7pEqVqk80Q4fnKv8ePBu6HZu+bRxtqc39KqthceW6iLMlqi
	OC18rIipYIb/ndNpd5dEMvC+YqMc8LjBtPwc/OSJJI/1wPdEDfVSIY47gy/eIk5DJEfLEpwYMXE
	n9BzTwQYEBLMFYDwhKPP6V3PnzFbJ2RKeZ/dju1S1CKUJqSMBvgMRHrzn9EwGVQNcKquDDYYCe0
	XyHXnbGQ5UW+KKoe10LyxV7QKe6M5Y4t5Nck5ZUbFlEAFy0KGD4flpj7Gh12zPvcHHCe5KVlfkC
	ljxz9uG4Mg5BbPFsVsDb3xQMRz0F6PwYeyMxKPGiC0jseuv7jC3l7E6j4cY3ZB5scu8W/cFiDUv
	hjqHkXQtvn26hs3hGA2NzMWfc9CbNfQfMnOK0o/rsE3q9Ni+mczMp10qgblEi8NFYgH5bcfVQqa
	ccIsVtR6Kl3V/ZdvmXV31jsle7Q6uGLtHZ36gbCY5W5FCct7ZggGdkXC+frZ/uCIsTwxbX75PFH
	dXmrtKq00t9M4aUGbRMWtMql+gE=
X-Received: by 2002:a05:6a20:3d19:b0:3b4:870e:6f44 with SMTP id adf61e73a8af0-3cc55323ffcmr4791108637.35.1786607135284;
        Thu, 13 Aug 2026 00:45:35 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:34 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 5/7] smb: client: apply rasize on remount
Date: Thu, 13 Aug 2026 07:45:15 +0000
Message-ID: <20260813074517.607275-6-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
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

