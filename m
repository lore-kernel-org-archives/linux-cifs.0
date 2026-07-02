Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E69E429827
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992158; cv=none; b=A97oTOfXjqxckLBtq59wQD410WQPIW01xggrdLHOXZH37LKdokiHCTc6r7LMRJ+kd8MGlrPGj+1dsghQKncZzwDT2NPmIoi//CSnOhDfZSlqgFBQJR5W4I/FmIgxkDoyjePjs73EVVgtRx3VgM6+XJ8ZprJsSaZamzv2//q/WqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992158; c=relaxed/simple;
	bh=IvzA7kh711izTL2GyBOl5deKmkUzRl1IU54KrOLo+s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YphyduhJCFs00oLZ8i13mwhB88L1jLXBijCMiNteabQYbE4gSExYYPqUCYN9Yh/Tk9W25noLx/kfPHflkQU7JzGW3tlMm17LRH0YWLGRCHKf+jr1i8EfMWtJ+dosBgU7KyLzdrKCJkoNUPtkPseqUBoTjy8A6sIcn55wn5imG2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WiU0y7T2; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiU0y7T2"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37df416c44bso1248415a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992153; x=1783596953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mg2O/dIQDn/kX5YFlk+hhfKLK1iyxlyLd9ZcuNQZiGg=;
        b=WiU0y7T2+61vXdSODtxPVckArhJrep/3sMZza+J+uBZQNJvpBqfzUSkEPVDzEtfyLN
         qn5Kml3n2AWsfI5IXwI06H4I36HJLbMdusrKlILwYT1dXIQ5dJ86uyaKxTl0qa3UKXQ8
         mSpMB7+UBEXzSmx7QbqHRleBssiLAUCEkuHq62wFuDppiOko3CJYvaBj8IDMbumj2Vgb
         ytQZv6elK5sLApD7e38fF9G5XNtWvEI+32BCXMYo2v91IWChREU319X6PUp9ztg4MPFa
         /DofqMKSsSGbwbTHiyaBnfpVG6WhrWgMiaSMWZJ/UM/pSQDm2LVoM6yc+4qgUWJa4SOm
         FzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992153; x=1783596953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mg2O/dIQDn/kX5YFlk+hhfKLK1iyxlyLd9ZcuNQZiGg=;
        b=byBBKrEprfm3yH7qQzEPw1gA2ANO3KThi29Se6bMRM4IZnIwOLUlurAB8ES1ZpxqqE
         nWQtPw/aX5LmKOtwKkdTy2b86WpSFqvADXP5k7cbV3aJyscWul+L1D7XSybb/dvfCSkY
         BRUSK8XzKaYW47wv1AsTMH87HQMk2YDMHEXVf7mpL0mUNkP3+CDqUVExcvrG0ajQAiBz
         BSjM0q3IIM8hYDK3tvU2fv+n/spLA2J6I7OROYx0QF+UF/KRFgsF4TDh+nw31hjgcmkR
         Ts1Peptc0MikKPEESPJukm8c/Xo8WW9dfy1GWfyyrwvSMTt9Y+YYsSOa/Lm/9srLD3ak
         dHgQ==
X-Gm-Message-State: AOJu0Yy/hOKZVB+saqCI1l9c9ppgmrJkygUJWDzWtJLG8duanrtlzqHd
	R3uWhHpNQTBgb2J9IR+p4ptdmqxB4j/2tScPkynGxl639DbhVr4fKsf+WHn42g==
X-Gm-Gg: AfdE7clhB0B5MnQFV37JeHLtZ3XMjCtrXg/oxXlcD4ZfgIGLUNClqwzpQhSFGK+wWCb
	u8ieN1EFLltX4FzmAiP/1yjibekNABszhp1YRzmYX0g8f13GP51ZCLyEO0By/3Mnl999FPKPs31
	mXmTWnCWvdmQgU+rkvqHq90aL448gRcqzvl1PaPGBLmBFsJvEdqLxLNx3+ubWQtH87pj/5GA8MW
	N/v9BGgIBIp+tm5OoPiEjZQnFDdzpQFO7PX5tT43zddm1G6YiuZ1ZrJ6S7+/tjEFyCMRSoZ5X2e
	9CC62S7voSFUhLa3r6Cnl2I7nqfalAztiCB9QKrshwCURXiy6Yfh1ky9dMsXA+j6LiceE/QQYm8
	KyGdr0uzA7R4BcU3sKFMF/8OY1yCS0FxHJtyPTbs5EOiKQnSM1LW0wefE9+XFnfMuwW+5A+ir3p
	3r1/pDJGdUJB/iHE0iTTNAP3cP6jqZQ1mYNPd3/qY/v93fjFwQhHVcGOSvFLzjSz+sY62QqI6SX
	rFUQp1E4ybp
X-Received: by 2002:a17:90b:2243:b0:368:83e6:ca95 with SMTP id 98e67ed59e1d1-380ba75e5ebmr4885765a91.0.1782992153073;
        Thu, 02 Jul 2026 04:35:53 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:52 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 4/9] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu,  2 Jul 2026 11:35:30 +0000
Message-ID: <20260702113535.4044308-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

cache=ro and cache=singleclient are mount-time environment declarations
where the admin promises that the share is read-only or exclusively
accessed.  The client bypasses server-based coherency (oplocks/leases)
and caches aggressively based on this promise.

These modes were intentionally excluded from smb3_update_mnt_flags()
when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
flags into a separate function") — only cache=strict, cache=none and
cache=loose were made reconfigurable.  However, remount currently
silently accepts cache=ro and cache=singleclient without actually
applying them, which is confusing.

Add explicit checks in smb3_verify_reconfigure_ctx() to reject
attempts to change these options during remount with a clear error
message.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bfbea0648f6a..659fb0adb528 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1211,6 +1211,15 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
+	/* init default: cache_ro = false, cache_rw = false (i.e. cache=strict) */
+	if (new_ctx->cache_ro != old_ctx->cache_ro) {
+		cifs_errorf(fc, "can not change cache=ro during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cache_rw != old_ctx->cache_rw) {
+		cifs_errorf(fc, "can not change cache=singleclient during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

