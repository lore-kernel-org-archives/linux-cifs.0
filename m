Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3758927815D
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 22:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768601254; cv=none; b=U2rVt2Bv894sOEpuAislLR4ch8IuN+A/cVHbuOxRkv/hYVShL/tw1SD1CbaAkV+P3uZZY6tbFNzAxBYO0xIH39lPO7DXaaOLvEQ6nUm9C1+pC2CHqCgEDiZuLr0JG+jkxADwLxdCHpw/tIFewuIA6ukShOuQ1YN5JSXIlLAhYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768601254; c=relaxed/simple;
	bh=DWaMf+T5InxN34CFjrl8otU0Yo99VPclb+byAx+3VM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7MY65O9bmpRslbT3ZEwv565O/fUGmWvnT/DUtYhrrpK02R81oCbXrRltBV2N4LlFQnsGkJJmKbZVLozgrqWp4pCwj7ba5Rp+VHHtXxrwrepJiqtPjWAku1dxM9tbJhx6lhyznADYSQ2/bYcfgPLFN6N1lOGcKSMQU/9+SH1y0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HTh3F5bp; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HTh3F5bp"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-480142406b3so12272775e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 14:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768601252; x=1769206052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fDYbXJQD+tYNvzeoPxNhmRha+V1fiasvcc9nyZnmRE=;
        b=HTh3F5bpxpdqKz1sOhgTmkfNZJEpOIuockaj3kgyBIIm6tJf0VQZtJQvRvtCOPykf3
         6Z28rdmG2OWTvae//JvID4BXOvG7MClBoXmQH2I5oOSIhDf9y9/1LjdInb/QxqYx1lzD
         KSdf0u14AXafgTNQQYjVFzsBHzYC/rk29wzVj82GrWTY3PyxCnkR4OP1deBb/qyYGK2E
         6g84CA30iQ3qe8f6DpWx+K6/T6zddo8z6qemkq6Q5AC7odqGngO65LXW70WdVffvLYkK
         jz+IKcdWDaPi8joXbQwnZY+AG7fpjtesAM3jOJvAxNJ136S9XLN7fZP43PYfn37Lqu1y
         EJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768601252; x=1769206052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+fDYbXJQD+tYNvzeoPxNhmRha+V1fiasvcc9nyZnmRE=;
        b=b8AaH4yQk0UlYq9urWSmzz6ZSKAvLoogPoRZN6CQlw2pJEcVvZba8kjBvG1eJssrkF
         vcbrbRenHiHlTRAlU2dyntzmPQr7sf08YiTRDHwTJfOGz/hZTP8rPvOTVO2ba6Y7z/RM
         4nmrBCOXU+VMpbZfYTyS4oaBsOwv5N2PMILzciu+93y72SWsSFedYRWhSX+QiElS08T5
         TV+2YWTnJCErzxYoFaly3ByrBRlzy6xFiozsBl6dQnMUVk7w5xap+om2NL4mQvS1dgpR
         E0dvW/bRD/mkKG2CAMWvL/s4kWlpP2v5eyfYkpIrcjEKPFqhkYrvewvT3sCAtheLY92o
         cscQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQE3gbu9GBun47q3GWOiTJPxIwBnQOAKFeANmKfqV5/dkFwT6S0ahhxEJ6t2Wj3xIaAKh2li4e3e6O@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0k3lXAyQZR3qOTa1VCjCM5FqNk37xgnMRnIUmkko2T9vkoA0H
	/Rs0EHkNexvplQJkXfsmuI190wUPJIpYhZa2EHV//on4DwGpjMhYNF1kh3OgkmFlUDE=
X-Gm-Gg: AY/fxX4HnWPm+7/+5aV/449agoYBW+lA7JgH52aXwVmSdRjzgzkhL/GJo/0F1CkGkka
	NmSCaVwx7lu+PXoY5S73c6g9ewVC/CUGPTCPpGKNvCLt6QBGkn9mH9lZQUGuib020sUbjpd36pL
	H18DlaiR2QjOemEJ1PYu+EbOSsam2IaR/wxblxkvre0x2SbYqpXZNUGwGYj2kcdR+k7c65neBFM
	JKc1qR+1pUlbHEZRqgbnYezbmV3Wld2tASM/4aoSZzK/gfBjF/gkz7L2RKD01c4VoJxXglbTFR/
	5eJN1AvL1w9kCbOQT0LNgdbGZrKZcy4RH7ibLAEcH8wCTje+Qlp2ME92WkUaprPX4ioamM+qeO8
	lgbfUApxUVf92v5nABbPjac4by04R7p+Af4qwZdwgCXpkV83Ak034F5LgeOOUkWdnTWJnN7njq1
	mT0Jw3wnTQAxC3fxTSkG0Kxqj/KMaJiMSdsHD5a6gOwhJOZr4=
X-Received: by 2002:a05:600c:4e4e:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-4801e30b74emr53833415e9.10.1768601251551;
        Fri, 16 Jan 2026 14:07:31 -0800 (PST)
Received: from precision.tendawifi.com ([138.121.131.195])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b3679980sm3737890eec.31.2026.01.16.14.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:07:31 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 2/2] smb: client: add multichannel async work for !CONFIG_CIFS_DFS_UPCALL
Date: Fri, 16 Jan 2026 19:06:41 -0300
Message-ID: <20260116220641.322213-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260116220641.322213-1-henrique.carvalho@suse.com>
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multichannel support is independent of DFS configuration. Extend the
async multichannel setup to non-DFS cifs.ko.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/connect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d6c93980d1b6..c635b503af52 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3997,6 +3997,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
+	struct mchan_mount *mchan_mount = NULL;
 
 	rc = cifs_mount_get_session(&mnt_ctx);
 	if (rc)
@@ -4024,14 +4025,27 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	if (rc)
 		goto error;
 
+	if (ctx->multichannel) {
+		mchan_mount = mchan_mount_alloc(mnt_ctx.ses);
+		if (IS_ERR(mchan_mount)) {
+			rc = PTR_ERR(mchan_mount);
+			goto error;
+		}
+	}
+
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

