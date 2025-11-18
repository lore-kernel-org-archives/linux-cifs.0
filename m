Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EC3559F3
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763478197; cv=none; b=uD4NKbIW00h/hYLL15cDiB/TAJbGyBTsjZLTCXy/Igk9de5vWOG4+cupCY6h9nGtbb5X5J82gJ5v6xXYx9VoyeYfmSQdVOakf3VCO2Ph4eSKHIEwm3PFwSTMUlOKmSn/yfFlXGdIwxBrFjKLwznLPCFYP0F53j1U43wmfwy95CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763478197; c=relaxed/simple;
	bh=ja/LkSN1dbpDQVhNZhk44Tv9iiJnHW6JXYkdYusMa/E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DN7fzIwrs7vc+v9UVToIWs+VbyUN+VXM0p6Gclf9bAgmw1zrqBIXN5k3Q6Jqk88OuSSo+JVAAvsqablk28m7RPI1AGz7NPKE4JYDAfIfTxBpbyKioNJRlH/eW158Gc3Ab0t9l/6b1/MJ7kqVVqA9eziPPjiK7AnGgTSfWfJdQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in; spf=none smtp.mailfrom=ee.vjti.ac.in; dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b=LK5IWqIP; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b="LK5IWqIP"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so6831560b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 07:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1763478194; x=1764082994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QQlkNWnVWNMGqknsz6LYkGe/xvDLcv9mS0GeDyFf+Uw=;
        b=LK5IWqIPyXbCgWb3/EpGxipq6TQvE74lwYszL5IIdAzOmnfpXLr2KcsNnC39B6SGXK
         hbXaJfpQ7IMvp3EBZ8qI4JWSTJBhrXiJ4B/x2oPYelgXomTIPXh47sVa8AV1GJB5f1nJ
         VAm1aUdqS44v02I4um4OaBPy74RugT21e+9nM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763478194; x=1764082994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQlkNWnVWNMGqknsz6LYkGe/xvDLcv9mS0GeDyFf+Uw=;
        b=r2S5zKdVSll5+G5nOnfnUnMKVwGGhWQdtGQ/Au5TwHdXKB9PEKY8FjSLbhA0atxVsU
         qKLIwWj5coame+tXUh7/9xTIP2ZXuW8xy64xspWUzQsffkEPxYa7FTMlHz192fU7WrPV
         sRgTg3JhC4Rn0G5Kpu47Hq59I8vT2EO9dcquC86ePR6PMqerJcAZEnBGniOIJ7DJ5lK3
         mvcNwrKGR0UuP8TwP4q3jq5Sze9a4W7aWPs+QuosCykm6gbocFMz3TBUz39hsDVkYZwm
         3DYgWHBLKJwl+VpMxqXO+Ad68jVA2u6QbSSudzjofsVBGPcvOuiGvXqqixMiC8QJVep4
         0nCA==
X-Forwarded-Encrypted: i=1; AJvYcCVG/Z2+MH8C60AYmp2WDCqMsOFwVcubEVRhSfvl8rpGWjJP+GHHmcL6T3DQWSb9dbn9918zbkQEPHVI@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5AnKr7L43L3QjL3FrxWJlPwKnZ539Czdhz5JQRybJGRDZc77q
	C4qmgXP/QolhgbvBuBLmvm1FvoFJaW97wahLGbWXXI2WgyPTD54YNAJVMm6xD+WJajw=
X-Gm-Gg: ASbGnctGhus7P7o+ZDAh63ThCbQbNkXpOsQjSxw08XcI9YH0/umSAXsuu8ium/I9a46
	P47tMDAyVquL9ammcdw7z7HZW5gYRupRtEU0McrfgbuxEKFeQJknAm4hHgPX1oxmetpAK9cwssU
	X8t0EW5REe+bK2aunSi8GDMSAeScYlhz6QzbbPVLOG8cInLbrZDxXyr2x/As94VBo0X4SXESrIu
	lvYT5i6ZGlmUpdnsy4b+W4iRrvDnDo6i15a0kHBpRj+V4Qv/UejNdXG8cVxDQbnXrpKgGxWs19d
	lqQlK4yh0MGBx4UoTsf3CSxHsh4LRnpyUvxSdzmNR5H8MMesn2/pneHhcKoeDTAjo6Nq0aQpfBM
	QvHdA+YT7TCzcSiw7KWOGvINpUvoOhtUOGhmqiyt8WZhQCjiNOZJLTg3huETOGRmKum53AFGkba
	n1N4E3esHDjgw5SPSy7fjNdbyeLkb+6puoqjia/tRznF+VU9seNngpW6lW
X-Google-Smtp-Source: AGHT+IHFIIwmUCgaGWygfpulmoTV8AMhwsMJO4oc5YwSM+A51tW7KkpVK+NA+2DZsJUMTDiHbm2Feg==
X-Received: by 2002:a05:6a20:7352:b0:253:1e04:4e8 with SMTP id adf61e73a8af0-35ba209f362mr17860446637.56.1763478193712;
        Tue, 18 Nov 2025 07:03:13 -0800 (PST)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2405:201:31:d016:3cef:9de1:d6ad:21b8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36db21e8esm15297990a12.5.2025.11.18.07.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 07:03:13 -0800 (PST)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Subject: [PATCH] cifs: fix memory leak in smb3_fs_context_parse_param error path
Date: Tue, 18 Nov 2025 20:32:57 +0530
Message-Id: <20251118150257.35455-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

Add proper cleanup of ctx->source and fc->source to the
cifs_parse_mount_err error handler. This ensures that memory allocated
for the source strings is correctly freed on all error paths, matching
the cleanup already performed in the success path by
smb3_cleanup_fs_context_contents().
Pointers are also set to NULL after freeing to prevent potential
double-free issues.

This change fixes a memory leak originally detected by syzbot. The
leak occurred when processing Opt_source mount options if an error
happened after ctx->source and fc->source were successfully
allocated but before the function completed.

The specific leak sequence was:
1. ctx->source = smb3_fs_context_fullpath(ctx, '/') allocates memory
2. fc->source = kstrdup(ctx->source, GFP_KERNEL) allocates more memory
3. A subsequent error jumps to cifs_parse_mount_err
4. The old error handler freed passwords but not the source strings,
causing the memory to leak.

This issue was not addressed by commit e8c73eb7db0a ("cifs: client:
fix memory leak in smb3_fs_context_parse_param"), which only fixed
leaks from repeated fsconfig() calls but not this error path.

Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
 fs/smb/client/fs_context.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0f894d09157b..975f1fa153fd 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	ctx->password = NULL;
 	kfree_sensitive(ctx->password2);
 	ctx->password2 = NULL;
+	kfree(ctx->source);
+	ctx->source = NULL;
+	if (fc) {
+		kfree(fc->source);
+		fc->source = NULL;
+	}
 	return -EINVAL;
 }
 
-- 
2.34.1

