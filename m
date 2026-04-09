Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B323BED7F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728816; cv=none; b=DwpK2+pBxk5rdgUdRFW2rngYzxR0urWYRChJpXuaazAK0ql7yn6T458pw9eEE3YNHojnAOjrilLSPyELpKxb0fGmj82LmMQSV07kmweq0May579LMsQcfBhomFL8FgIJEJr5jYI//eRQ4y34olDt9OZO5IQVVvGpCLMUMAsPBSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728816; c=relaxed/simple;
	bh=jLDGH2xbdkICao3AAOemRCpEXMamhhYa4U4t1QlA53w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eif+XH645wF7IMEAJx2Z7iUCsp3tQ4T1aqF+d+G/dw6d+XonEJlNkzpFNzbjHxJnw2CvurRVyQaRZafoVLLXRfN/dFE/VtIa0uKvq5vMwzxaGWyu+zpbl5xrNi1gVEp6vbSnMNstnEstKmAcuaBDd6s8aviRhLQWfpvrkE6bOqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpWw4ljk; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpWw4ljk"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82cd98be655so516801b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728812; x=1776333612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOqI9jBMlEFSepIEKpFv4Fn8Y0sEbCOesb+bDrPgbcc=;
        b=kpWw4ljkw0sLT63co6djpUBucoczAv7eDyfFhsFjRqZFtvQ07Q0TK+r/5HKR1Y7Qgv
         9g9CiZEqp5wtvDUcohlwBmM4T1iSgi1AmfYRxWzbiTeUdpK3kRnswSgYCu0MPCsv0Daj
         UFxfQEG7MhWFD8URb6QjL/h5UwTfYdLiXEJHG7xGFLWruMgmVAQPCmPDOiVBDPkAVHFF
         srXijc80EC6qB247d/QPOO3/9VRhkuk3AlpepBGKFTtcbclzIR3wP/Gf2FxTh5FYzGTu
         FzfhvcbC1Xc8aPytUGG4U3+uQXhNrxOU+nHKPSHWWxgpgL11RGz8t/w5WgJpMVoBad5D
         RzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728812; x=1776333612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cOqI9jBMlEFSepIEKpFv4Fn8Y0sEbCOesb+bDrPgbcc=;
        b=inshoA0kUDyWgfT5x416DOstePfU3LfaBolGO6tLQJfSygfAaJDtMmXav19knVYowY
         3AxTnzg+81Vt1z6vJ26qqOrxMZ1kjCpnyA/UBTECshcHEwefXs5vzMunDxHNsUUtdqyj
         lUNyxm7WwUuR6GCfoAVkrMTDkucueRh0MLHrALKpNtP6vsGedShhziQX0Oiq6/tUHSUs
         3iBF04h5VzE+smzOf4ZJPt+bUe49jqKCuj4prJfKrYvr0/noO02kUNaLZT7KLLkSDd44
         rXQWD6KbOBrzIEyUY5MsM2hH8xU7V+PmuZitFIV9zhkQA1+tW8rEcoSDopAewgpJG60P
         e8rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlIJbPOoYBlDHH3hMrIzr+2d4QpZ7DXVQoP1eLQ3Foi0jR6+5azAkuBUQqDPIft38s2LS4Ia/gvG1O@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt9ZbCuKzqF1m8BvQLn0f+/WMz+Il4cPAORI6jQKLkuTDf0RxT
	sRZaZUxBzmvbo9faFZ3PvzxykuCyCW6TKSUda5+cqcll9z/cG2PPUHrV
X-Gm-Gg: AeBDievudyaHZyVg3Ki3kfECBh4P/1GUuC9pcMsKULLdfFjVDN/Skk64E/ilt4XnM+z
	y0Oe2CTCCfOCFqG1EiZRhNKq8R9A10ikCyXIMA6UNwk3RyGWGkJ9Ty+wp4IWpb2b9P3nibjA1D7
	xyzo2yxEe1d/IDtWCE1zNWOt0bMBNaRokOw0mxqPCOLitU0aXw/6fVA+gHmJ9GM5cXGxfBrCPJZ
	IDWVogJFOOafkjIf/NRiRjLepinfP2YVBpxwuomjM5oX+WiisEwy8qxo9FQQATUds0H7HNJp+6L
	MxuVmH2wZgxbmcmYbXPvbb8K1yiPsgqfknBfbGyT+UdsuX5TgcgcOaqTuhRXkKlgouHA1mb/oJU
	ZjdT64lLIUEqUNVfXN+nnaIyXs5TKrDX+ytPGrPJSkdLgD2sajA2RzxMrMeJ8t9wB4OjC6prFY7
	iMKfBSEHu4PKfdU2RNVWrnzHLppCH5xZMISTHJUG/kIhv58XGj778gLVS6ZcJpQV9YgdoCDLsv8
	vGqsPZO8hl6l2F6g+K5e+A=
X-Received: by 2002:a05:6a00:13a3:b0:824:adf4:5a2f with SMTP id d2e1a72fcca58-82d0dbb96fdmr24441118b3a.43.1775728812252;
        Thu, 09 Apr 2026 03:00:12 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.03.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:00:11 -0700 (PDT)
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
Subject: [PATCH 7/9] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu,  9 Apr 2026 09:59:24 +0000
Message-ID: <20260409095926.905020-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
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
---
 fs/smb/client/fs_context.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index ce4842e778c4..2be72733ef2e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1180,6 +1180,14 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
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

