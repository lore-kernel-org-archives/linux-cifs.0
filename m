Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DB43D9023
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589261; cv=none; b=TULT5wgLjfiZSVCkdDazmDReLdZpcxtiwTO3MNJbY1XiHFCV/Y3GENjCUawlH6fg1GpfH/zuwBvvZuw0sHeXKXsIwVCnHchiobyCZ5BrLLFRKy/Gj/2aQQN8gbPwLJjzRNunY2sYmzBmcy9HupAJBqPNuYxzIJU6jgnjMjcsvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589261; c=relaxed/simple;
	bh=IvzA7kh711izTL2GyBOl5deKmkUzRl1IU54KrOLo+s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqGZ2AoAHZ6FV7GMQ7V+weGJDiABDpKaeocfg9AXB6a5zB4+AdUqesPLc1GWhQLYb9j3nYPtgc5VroWoV+q+tl80VqoWUwbTVVp3MbD3qgqaPoHsAnFGRQ9Q6NRQjq+NlYbcaxCOPYZPUqT2l9eZPoNdJnYpOoFw6jgrTx0MWgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qeQY9Z88; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qeQY9Z88"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2bf125989f2so30006575ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589259; x=1782194059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mg2O/dIQDn/kX5YFlk+hhfKLK1iyxlyLd9ZcuNQZiGg=;
        b=qeQY9Z88Dqa7+Pyd910cr/i6KHTulBZ2X8fDQWUzhX69rePyNtzeRE4IX/QDesGaWm
         nvQ0cJH+8Dc/A0FY4mfH+S9Q7CrOKkmBR/eWSNdKzvqa52m6tZwgrF2xnenlhhPJzE3J
         JMnfp1HBFKJiIy1B0ZJCHJhQiWC+ceHMsYbu2e5n8Q/YrrDeIIRS41hHLbL+Fyf4H2qm
         O4diQhU/w0pZADB1kjShRthC5UjEZxIJF0Z9ZDWFzb6OL2wVRzcwSG7ApY6XhwzBMGKU
         AO3WnFmO4d+ouybWnMjoPmBKOLPqFfX4yHeyrlc+ZEjc2oQB4H5HUit98L9C+DiW/lFh
         2DNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589259; x=1782194059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mg2O/dIQDn/kX5YFlk+hhfKLK1iyxlyLd9ZcuNQZiGg=;
        b=orHcgpGIvO8AIYOp4D+btW7Q4vYKWFnl026avVYVWpyoggZd2F5RC8vdeorx1S+Avk
         5ufHkxzwC+yRumEiXas/esZXf64Qvrsf4NXUE3Kf2BY5sqqLYAxm9Ze+7qNEwGOvZDHf
         iWs1q4QrnH5ENMd/SpzN30rsJclaxZaDQ7TDZVH1Rq1DW3JLgdv77yXNMv9UVb9Wet2I
         tUGZ2fXE8MQF0BjN6cTXbLpV6z0AyMcDM039W/6v/urAIj12U2g3Yw/EM10cTY2YSrc9
         hpPqZJwX8MDIM41ic4l+hxdFaHNI9AkY8xWxyttE7SMaxmCd1xkgRLANqyRlAQEa/dd0
         snng==
X-Gm-Message-State: AOJu0YzEdPRZqdBaxVZ0J8Ofph8rSuRvezd3+XO/u3IrUiJLuGQ+F6Qe
	jky+kgrRa1VVCEndIXuQ9+DMPEBgsNY1xlIr/oItNdHqjmpXl1Ysgxss
X-Gm-Gg: Acq92OGxq+yyKKfEeU32e84EzHofB++YbGrCE1lyP4MHsDIsy0r7dVNe4qx5fojsRJH
	hm5AiXSL9Iyqqw5D9FpSomKZyf4Fa1PfK8tiScPwkvBvVLOhQ232VmXaZd7rkOwP9QbZlKWcpmQ
	U8yfQ6Dt1IJrPuTF6G8HasmkezJA8UJDd9Il4Z6RBPwxvt8SnJoN6PO7+Lt3DgQx2CeKY8F4FZp
	vWUVSlwTFXA+ndMGDGU9FDg5pCzlCeQiqCHxQf1N0LBGDkW62rfQF9W/SDeKgk/hys6LWeZgxVD
	T9oWqSQvRxHP+bVfR4skeki7uneKao6A0fj7xBmhpcae5YuZ/iHVB6hzJPTzm+5qkga0Dojqfe5
	sZjuNRq9/oTMH8ignI62p/MwOwXgcgz/9TnLM2pj036gc7xns+zBdQi3P8Q0EtqSuBxwSSQd6Zo
	3B/6KZZQzsuio1LCqZxCTiiXzv9wqzLsyEVe1YxVbeI67kFCoNDMk1/NoB/zQMXTiBBLFh9KST0
	yEi2g4cQ5ZwVNGvjEn58b8=
X-Received: by 2002:a17:903:244d:b0:2c0:ab82:6b9d with SMTP id d9443c01a7336-2c69a1a6ad0mr23872135ad.29.1781589259411;
        Mon, 15 Jun 2026 22:54:19 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:18 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v4 4/7] smb: client: block cache=ro and cache=singleclient on remount
Date: Tue, 16 Jun 2026 05:53:54 +0000
Message-ID: <20260616055357.3798387-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
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

