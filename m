Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9385E13790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246044; cv=none; b=c+6qjttYhdQbkpxgk3XTRmZ76bvzv0Y8H4uG29NWtlcPZDDP0Zz3LrxFK0FnPHzmY3/iobK9zzA/QSk7KpAk2KGjX+QOf44wHd59w8Ov0+2/CnGKo0VqypA78OrbwVpxERxA5gO3wUHQB8x2fFASeN6533d9KfM0VYCngTVZfNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246044; c=relaxed/simple;
	bh=Cj1OhPdO+PGSVghe1wouNifkGrT4gS9kBGlLwdfuB5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAvsdo+C0b0yG/efWIlp1nJjJfkZfIw2NR0WW5tquqQWBLS+gHR+as1QKQ1qt5XSZDx1ILzs4C7IUDLV07W9CE5XQxCNYn3v8coi21id0ycH2TxZb0+tRwZsa0s84kzlUpYTKZA+/eYlj6XhmamD/URUlo9ETqtxno9wrc05r/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ffBwR5X5; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffBwR5X5"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6a0c7c4f55fso229433eaf.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246043; x=1782850843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqPdIdspB4otmLgidFn0yC9hZ1SNnZ/LMih37TpH62s=;
        b=ffBwR5X52/18Nue86jbNZyFRWEAHRnUm5CTPev57K0dKa4qjJMVnvPSXhFLmQbKsCE
         crYdG0HA8nACLfqKRcPFhpHlFvLZICr4evuKH/AtMbJNHlPUxTKqCZyV8TZVdp32C0Og
         Tn/yIwrdcrw5IfImb5Gw5Tk7Ki3YJnO64A4H8qGRAyzWmt4Oz6C1n6BGHLexF5mXKAiL
         Rh/uEXyAaUwhjPw8BjLL6hsHBEb9MUc27hr2LqhtlaANv4GYeYrchK8xVdqAAcPoN+qf
         dCaTAD2vcqRDivQWI4pWX5EB/vG3utIJ5yeZa4DktmkOXf7qHeqjqLZ8cEKX0nLMyRZQ
         FWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246043; x=1782850843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xqPdIdspB4otmLgidFn0yC9hZ1SNnZ/LMih37TpH62s=;
        b=k1zcx29nc4uVa9WunYlyzzpOEaPr4Jh8Phuzids4j3BRPpsBfVBk2c2f/hCMdPraCQ
         29zgNfuVLbGlPnWfEAqlRFfIc60wzV/t7i992Epvl1H4JN9sMPPsAZsO2G6hMdJ2NR8Y
         v3YY4SVDgE3GsrMduTI9tcHSC5Jj9Nox2PlMQapgejwclYZerFtror2OJd9KikDD+lAn
         6+K1tP3yJeE8dME4YoCT3Qy/JnsTc7C5msPN/LYB80funR8ORjf5Ccsq0V+ZlKP22DLS
         u3E+TxmQDH2uMb2l6VBjsr86KzotFAcH8TMSatxIYZuvkR0Ob4YCKQHOztY2/Lng6ic9
         K9YA==
X-Gm-Message-State: AOJu0Yz/mcK5s26ImqylaIFfiaxHlFOg125fI1kE+TD8XRUduhRf7Kne
	zqx3JDXmVkJYDMyZIoKwEr49IYqaDJIzJEs2qXFYys5mugYQkF/XmjpsQ0Uyo/I6
X-Gm-Gg: AfdE7clpuXFqoGS9r7fCYhIszVRehvFGFgFgyfiQT/eh+nrwKzS0XxfCROgcX8O25JL
	J8PfgF4vx1d7eQNCEXPamQ10t5gvSRkaU/NzmtiNbFNDkCL227T9h6B2EJITrCgjxVV+asAOtID
	fxYdetN4E/Mm81QzyXWgIRqcSL11N/8pidw0yKyLtQKW6SN4kuFfwKSOxQluw4fni6qFso7pQMy
	xuhLd3KUQP2IY+49WCZFRHIQXV1wY9QmRTcGVQd/Ghry6Sz/756QtqsWy83twSv6Xd7IVPOOufW
	+VLnMt/rNya4c974gLfzei/VNh/vjtHKgerJ5krSL1co0INTLwsS+c3vMEhwiv6GBserK6XQDe5
	5ZaFRsrnak6/uAIMEmO4G87aqbEYqtv9F/LxfvXAvZYpCLnUJRn8h5D3uAKRaCtEbSiFe/nRNkU
	kboek9AcqvTyhgzj0M+B/stZ8QFDQ6sJ2l+L14P64ox5od/wZHeVxYUHrMnTfK8Ph47XZyUKEc7
	eg2PXaMAvMbPwlrZIbTVRg67YmC89AbIqoqUD7CpnV1mRo91Sb+9CnuGoe9Ved6hstMj3UzZuJU
	IR20zaz+S2f8pGwmgX/ZKOwB4E4=
X-Received: by 2002:a05:6820:200a:b0:6a0:e523:99a6 with SMTP id 006d021491bc7-6a123177fcemr165509eaf.51.1782246042636;
        Tue, 23 Jun 2026 13:20:42 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:42 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 11/16] cifs: option to set unlimited number of cached dirs
Date: Tue, 23 Jun 2026 15:13:38 -0500
Message-ID: <20260623201344.2043841-11-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we can control the number of cached dirs on the system using
the mount option max_cached_dirs. The default value is 16.

This change allows setting this option to a special value of 0,
which means unlimited number of cached dirs. Shrinker can still
evict the cached dirs.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  5 +++--
 fs/smb/client/fs_context.c | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 921a6f2c3c51..ecdc6907cf6d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1255,9 +1255,10 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	if (lookup_only) {
 		return NULL;
 	}
-	if (cfids->num_entries >= max_cached_dirs) {
+
+	if (max_cached_dirs && cfids->num_entries >= max_cached_dirs)
 		return NULL;
-	}
+
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
 		return NULL;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 9bb41114237f..f2cc5530447a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1523,12 +1523,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->max_channels = result.uint_32;
 		break;
 	case Opt_max_cached_dirs:
-		if (result.uint_32 < 1) {
-			cifs_errorf(fc, "%s: Invalid max_cached_dirs, needs to be 1 or more\n",
-				    __func__);
-			goto cifs_parse_mount_err;
+		if (result.uint_32 > 0) {
+			ctx->max_cached_dirs = result.uint_32;
+		} else {
+			/* 0 means unlimited */
+			ctx->max_cached_dirs = 0;
 		}
-		ctx->max_cached_dirs = result.uint_32;
 		break;
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;
-- 
2.53.0

