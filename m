Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FA63AD528
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777383503; cv=none; b=mRdHYStNj0e2JVpyi/kLztuz3/7F/H2rZg4kZn9Rj/YtPjY8LeqswCLK/7clwfLzmYnoctAeSA4FGc5tiVsAj4bnPc0Uvk1xKjvaur6a0CLhVX9LSE2mR0q2Zs99n6VGT4vYK3JOROcZtppPYV1/9Wg31s/V2tDzPEal7bmnKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777383503; c=relaxed/simple;
	bh=TaYnuhceaMT+9DlGYrSPenFM1/y6sDvtTbUGtDSD1MA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O7SDl0XvB5QhcMdBB6fF5y8Pb5/K+18zHHPAd0A6sGvJOjx+ttwKX6AVst2Fl9vR9A6D/Tsy27QHYAV9bwv6jXlG/tAQo5nqSIJXpPhrs7STgNdOLCiKwPXEJsW5sqPokzsJ/U6x1BZp2Rp9+15uyQeN6Vrex7GhUrsNzbOs6Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MxF5qKv7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MxF5qKv7"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b467d03d57so8686795ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 06:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777383501; x=1777988301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r/eI/PGX1PR1IZjElSQCjfqxsz2vIUbsSINVfSZOJOY=;
        b=MxF5qKv7gjHHLncao1PE6mF+tRas02C2kzxh+xNfI0Pt4+S328GAvZLNyZIwpax7sB
         wsXJmrIlRSwwpkv2sT4mT16OevuFZI4ee/8dk8R8kfTC/oBtujDsy16cfz1HhrDb46Vj
         5kruq2djR0LHACoqjNetvDi9dtf/wExuI9X5DS9xxRqy7A8oy7NnvAbRRyGsd28MPQa6
         fkYleNX24Efp9uBqrpdAoaLrnOv41EKl1XZemai2IWFwqaQD2uTOsVRVXa54nJkgqQO9
         fXaTzvQ9TXLeFnoxjInyl2UnoCMe3/KPuIQxyPxmCwy1iIvyW9whzw07I0nLhI4BT94D
         BQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777383501; x=1777988301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/eI/PGX1PR1IZjElSQCjfqxsz2vIUbsSINVfSZOJOY=;
        b=IoSNM2fQBPCl95SN50Hyz2jEsUJaeQKlYS+jXO+ubK786Mh587R1a9EuSv3EK6lQgW
         MJnJWDmoPb4jgLhBYvdhwe5IkUbzxkZVf0KR48JLsUSSrXEVIb5Rl0dkfBCGoT5LS6LV
         ezZQUFz1RVlLJ99LFkNUlPnnGBMgbvewne+8z48/dv358+OEiDjI8n/6iypVuWGuGicq
         QBAMI+CS/8n+XDEqMKcQHsMmZMGO2POShaZYDu1xChWY2BbSLa4bUpBemmkpyQjECrc3
         53g30f8igHPDEI6PcseGQyBt62bAuo5LNcK6gFfmRR7Hn89cM4hrjLPmAqT64kC4HqcY
         1AGw==
X-Forwarded-Encrypted: i=1; AFNElJ/bRGrREnNnmU8anZLs3iQHWdowrqspg2vPiqxZgA2lEy//pXLej/ti0bT/h2qqrk/mGoyTOagE0RBV@vger.kernel.org
X-Gm-Message-State: AOJu0YxxfnVZLzqqvhG5mxgA5kimbpwBL3hTvzjdFpJ2UfGTbyGYGH6B
	kgtUFDUJ5kxWNgGUMTK8zcya8//92eb2YlK2Jj8mckARoAz6dJLS3Oci+UgYWtSh
X-Gm-Gg: AeBDietkOk0oJfDH6HddzHhawKdac3SaJqXTs3r9sswtUatmk8jk2bbICrXVdukyQsJ
	ilVVS4LPGsi2bp9iO+Ewfoe6P70aXnNI+YzSlamgwSIN/Z1H/PiqVTmxwvKax4scJ2VoDJbF/sg
	80WL7Rj4Wr/gDjsFpUJalqc220/aT5eB8aJK6lSkNnM2+PZC7abEGkpX38IMzV2b1EtaG3g2K68
	CQqoqNHxLSonR0y2i0OdmQr4hLGIkNNAfug2SFDsBDW+2nqnD2bjiuM7DAstQhNLygVY4NXCM7n
	beM5p7moAUdiHrqcYbfnapcb7K4r2ujP5u3rn98PWajreyo8NcNnGiLo0UK+zsOSStbN3h/2wA2
	objojflq8cjI4Xz+VCGRcodVTBq3rO+MmeP3nBVc6AlP70BRMVFGQKFUmNWD1G4pcreIsYvG2aN
	upEQ2T9sv7M5vBL8edqnKpQCHRuXo=
X-Received: by 2002:a17:903:37c4:b0:2b2:4f56:d571 with SMTP id d9443c01a7336-2b97a9271bbmr18507755ad.4.1777383501282;
        Tue, 28 Apr 2026 06:38:21 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac8cf1dsm28160775ad.68.2026.04.28.06.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 06:38:20 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Bahubali B Gumaji <bahubali.bg@samsung.com>,
	Sang-Soo Lee <constant.lee@samsung.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] ksmbd: stop transports before procfs cleanup during shutdown
Date: Tue, 28 Apr 2026 22:38:16 +0900
Message-ID: <20260428133816.922544-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_server_shutdown() removes the whole /proc/fs/ksmbd subtree via
ksmbd_proc_cleanup() before ksmbd_conn_transport_destroy() runs.  The
transport teardown later calls delete_proc_clients(), which removes the
cached proc_clients entry under that subtree.

Since proc_remove(ksmbd_proc_fs) already removes the subtree, that later
proc_remove(proc_clients) can operate on a freed proc_dir_entry and trip
KASAN during rmmod:

  BUG: KASAN: slab-use-after-free in proc_remove
  proc_remove
  ksmbd_conn_transport_destroy
  ksmbd_server_exit

Keep the control sysfs class unregistered before tearing down transports
so kill_server cannot race a module-exit cleanup, but stop the transports
before removing the root procfs subtree.  That lets client and session
proc entries be removed while their parent is still alive, then
ksmbd_proc_cleanup() can remove the remaining root entries.

KASAN testing confirms the ordering issue: the pre-fix module
reproduces the proc_remove slab-use-after-free during rmmod, while the
patched module passes the same rmmod scenario.  Active pending-IO
testing also passes; the observed workqueue hog warning is present on
the pre-fix baseline as well and is not introduced by this shutdown
ordering change.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/server.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5d799b2d4c62..188a6a72f7fa 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -535,11 +535,11 @@ static int ksmbd_server_shutdown(void)
 {
 	WRITE_ONCE(server_conf.state, SERVER_STATE_SHUTTING_DOWN);
 
-	ksmbd_proc_cleanup();
 	class_unregister(&ksmbd_control_class);
+	ksmbd_conn_transport_destroy();
+	ksmbd_proc_cleanup();
 	ksmbd_workqueue_destroy();
 	ksmbd_ipc_release();
-	ksmbd_conn_transport_destroy();
 	ksmbd_crypto_destroy();
 	ksmbd_free_global_file_table();
 	destroy_lease_table(NULL);
-- 
2.43.0
