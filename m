Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594393B9DAD
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728809; cv=none; b=CllaizTaDeulmi6dsrr9XtTDKZW+Y3vW8GgvnLcEsaOHUCplsTqTt9LN2GIEWTyA69JDynVoUwbcarMvFs/ngNMIBaATaGhxk7UrmK3sBeWmB3WtD0xn80J1/mkmbWama/t2rNdiIBLE9UOdhyPLqWXEPJ5zYKvNnEq3qIyj7b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728809; c=relaxed/simple;
	bh=RVmOzj+VrRfnJZI8/LY4J0FhhyKspM50b7uZjuZlr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIZeK25zANwCGGXVFrPtZUFu+CJ/mB24rPAhxj+0i70WKU6J2cT4mNEa6JZRHobp8s4O73ccADlcc4bOM5KRjvCrSZ+YrwgUURBLXpNKc4H9uzOF+cEw9Qc77GeA/xJvzYZyH4zHH87PTipLwDwxNM/UdYSRRRIlRHUgVLkz/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rN3QFEG4; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rN3QFEG4"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82c70e4654eso356368b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728804; x=1776333604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUAeJTrTvdEpdggBCNQjpDx1YpSTeG9FOV5VC3SOnkY=;
        b=rN3QFEG4eYZh+zlk3/1x5iNESXaS+LlNzbdC3GjUyODqM+fqaF1liqMAagaUujxry/
         NaiYRlLAPQjLhnH9vkzRKqLfSmNCQ9WLYnec74PlSUG3vcMWHxhvA2jeF8ORKAObDRqS
         /lrvK8Wvqtdg5lqBexbJ9z0GOyOvGgf2+mwbjn08SZN1RJPEu5aIAAd6uamILByHGu+p
         ONtr9wqEJFfv/iiXCSGeck6oiEejPnLgz5GA2Qd6z7Im6EvnoY76FXn5+4uPx+0hY8T2
         JDQU25dn+W29kC5piZxmu7v7ZxhlSIdC5UAG1I/wzyTZrv1frGx5Owtpf0N/dn55DTN7
         5ABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728804; x=1776333604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lUAeJTrTvdEpdggBCNQjpDx1YpSTeG9FOV5VC3SOnkY=;
        b=ICg7Z6nfuxh/T3vcNP5JElq6BBqY0qW5ksRvlzRuGHPfKeIhjcMtMfjCuGoAUs1Fr2
         ZtbMXuB4ckk/U+lFK31cjnig9oAdt+So/5gfkxndBqKfI0H/XwSFAIkvW9fGUzih6oLd
         7LvX13/kbekNySdPuIWZsBg8j7ReUx5StjFMVXn9w78AJg0XxCjFClnSPfOlhzPo8Ova
         cJ0WyWcaE1GOWAGT+wiLauceyy89A8TU99IDRw50gJ4T08UjmWT0iko8xxxwBQqB5Wmn
         SfVO88WO5WH8y51natYAQOmNI8uA1qtL35f0O3uHX0xiuQT8tTaajX+99J7yd4pufWoK
         8dwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq+jNiLy6j+Jdk3VBjxPeT2p4ZY5IxqA19loejf26LyejarJwOnHX2S113tXJyr0xs5aXG1Wi/Q8a8@vger.kernel.org
X-Gm-Message-State: AOJu0YxHq7PKsqVZI+szGS5WbYI83q148wpxigrFpY6pGUCVtClTXcXv
	ZL+6IYNVrA9Jl+fWvLPA09o3madmkBeJBdm+iri4s8GOpx/bMtn2o+CU
X-Gm-Gg: AeBDieuiFJ3g7PxC7kAiamEDtAZI3PA6d/nurLJ6FpAYsNl7snQTMebnQe4Tgr80DOD
	DhnSD+O0uqpt4A83YYkjxWE8B4JCy4dxVcBTTtCZXitnQwWaaxgBOCPEbz9MkG9nzvKhOwbvGdX
	651LzPiX0yB796AA8UYxybW27Fmrh6kgi3Xj8t60sbSvDGxeEk6MiPbw28QjO2C4+hpnyZJpfrm
	ZexsAT93INdCZ1iLWRB0fsWKa/q7Nf/6bklBwZzt2qORVT/FsWmSdk9DYz+iJ77lrytG2IGHjJb
	llJJtCYFZXrdkXW1j/B6HnE9ypuwDhIeGuIqqYUO5xbohTHZYFn1qT/fWP+g0i0gMRlruSyTbD9
	jhqu6Ifx0tDffrNT6E4VdZF2OvHnuU6ciAaTpPSvx4EwkxjodoJMM4g8L/Fb97cgPkozYTnQ9tb
	B3jkKsTM1H5Rb1L4r7v7SBG3D83n+is5EUaI48a2QRkYho61JL+qVsUHFKgRUqMrSIsl9PQ8SEJ
	ta2sNdt0446wPR/IT0a1wI=
X-Received: by 2002:a05:6a00:f93:b0:82c:6f07:299f with SMTP id d2e1a72fcca58-82d0da834c7mr23176308b3a.14.1775728803985;
        Thu, 09 Apr 2026 03:00:03 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.03.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:00:03 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 5/9] smb: client: sync echo_interval on remount
Date: Thu,  9 Apr 2026 09:59:22 +0000
Message-ID: <20260409095926.905020-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Add echo_interval handling to smb3_sync_server_opts() so that
changing echo_interval via remount actually takes effect on the
running connection.

The server echo worker fires every server->echo_interval jiffies,
but that field was never updated from cifs_sb->ctx on remount.
Convert the user-supplied seconds value to jiffies and reschedule
the echo worker with mod_delayed_work() so the new interval is
picked up immediately.

The assignment is guarded (if ctx->echo_interval) so that an
explicit echo_interval=0 does not accidentally reset the interval.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 31b82f8f7ead..5f0637035172 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1338,9 +1338,9 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
- * at mount time.  These fields are consulted at runtime (retry logic)
- * so remount needs to update the live server struct in addition to
- * cifs_sb->ctx.
+ * at mount time.  These fields are consulted at runtime (echo work,
+ * retry logic) so remount needs to update the live server struct in
+ * addition to cifs_sb->ctx.
  */
 static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 {
@@ -1349,6 +1349,11 @@ static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 
 	if (ctx->retrans)
 		server->retrans = ctx->retrans;
+	if (ctx->echo_interval) {
+		server->echo_interval = ctx->echo_interval * HZ;
+		mod_delayed_work(cifsiod_wq, &server->echo,
+				 server->echo_interval);
+	}
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
-- 
2.43.0

