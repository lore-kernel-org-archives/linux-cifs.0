Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C23D312815
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 08:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773303360; cv=none; b=j5juReKKJxVSgGD4emBEyZHcj8CwBfEhEDKBqC0COq0hmD6S784d71Ov5dqz92d51cXVyBrUeFJuOYzqHVtdd+cFrS2ObFiuWl0QSopqOAIIHuIGbSrHixSMC7kjI5nDX7K9yRdQJnmn3XSM1pROR7qcOI3nMhogux2/gnzHQjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773303360; c=relaxed/simple;
	bh=vPRwXSgKToWe7ZbZWILha/1I9fOeSIL7brpvArUKWj8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Bqlcx0sLBtcSrDHnme0uajy4ydPI9dQ/2yu0RdHG0GWlFuv7gIwxClgbRk1LI+pmpdHq8HgTyjlb9cpyKsr6WtPFRlNOQ5IWJFGoCjHRuG4f8o8YhY2hssEjXQ0J0iLCe0MA5km3uAP51KUwfecLRcjAQ9xSFilVDh17KcTAdUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O73/aWrV; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O73/aWrV"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ab232cc803so3991935ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 01:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773303358; x=1773908158; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dP4aQ2sdTwJ0ubokowmZwHZnh1TBo4U9hgiIuxzoLTI=;
        b=O73/aWrVO25dCU2NOtif0PZi2qxvUgqzBgJCQm3k/izOZUajlDZDqw1lIEV4X1Y1ue
         rWn8J5kXQ/VViUhNKqCnTHVjtLYU1MXfm2VoE/BAX3GJ9stETbpxpw4HOcihzgYEnj7g
         eC97LeTJ+aUKM7pboIoshvwucA9N2MEFYfyRg0fQ0abvHgXAqtn1w9YNdqT/AsHOFh1l
         C5FUsS76fW1uXYpsVhYxGDfMlbgigaIU+L7jr7RawMLbVsSbD4IC9HU+/yDzNc9DyZzO
         gX2FWfP7rFWVj55ukfgvcCm9OTa8CF4JrkJ3s7MIOwgNBA3khOU2OBlmVdkO2osJwiBM
         Ftkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773303358; x=1773908158;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dP4aQ2sdTwJ0ubokowmZwHZnh1TBo4U9hgiIuxzoLTI=;
        b=KSK+uhp7cmqSJsFnWEn2/NZZYfVvmpfpzctarzVTFxSZuMMbkWOI5AnwEcbv/8zlPN
         jZImWHFTdjGyytGebp4lBO1+CS/43r2qv9te/sBv2oLOGoL4FXQPrS23s3+JheTEJLjD
         /N5pOrMSdFf3Wmpue41Psvzys6cpOdWCJRcOYOD566N6klMDI4nciXutKHWSc/eKtqvX
         TApUBk2mf+DgKmYDusbiYyGSjfrp96tzFurzZ+4ux+HmIbZIiIt98Iv6d3FNImeFOVH4
         8Z2amofYGLn+PZpyq0XPb3MkJmWhvX2cMgc7jWOoTBeiJRIyxdByBhIGK1/YPJMr5Aq2
         a47Q==
X-Gm-Message-State: AOJu0YxezOIFoX2Ug4gRgRQh8oEc/eXzaQLWLNI24ASpChA47pteFMQ6
	OW0WTJ4eNGg49SJOL3xMQScKbE1143we2TDgKLjN8fynfsj+JgvV+mqZ
X-Gm-Gg: ATEYQzzsjDnEGVXooxm9rlTT8jJqRV02qba/cJIy76sRb2f0+cNSbuS+lBTmapoOjxF
	SUrojwaLJCBxWUgRUGaV6i73+pViRhDK8y4dpJXK4CDE3sbX2zGOmZm366GZS82RievFhtfUtPc
	xRXvOBaQd61DVgBrGuUAzkn0yacHk5mXue736gNd+77/wwMt2n5anDobJur3t+KPic8+C+0xm26
	BKgPjXrWv4WLTXjUQe6iw3oqij9luKp7rPSU3lF7LXD8gmBrMqo/Vop6gYy8uWCbbtIBOQMCYdn
	vyOAJ/7a0FaoS4MXq4Shk42gY/p9phZ5Tkx8LKeBIghe7pgkYSlTNhFyx3KBikVe4Zu17WY76+5
	CZ2Uli1xLwd8FFypqO23q/QV6dxkSfab7uaMJwvO7LfPCn8nldvqPkUwilpnwIzIKFGMEooAKAa
	e7D/GZ944/Txer+cNgh5YqOZPr2uGa3irWBJX21uoPkA==
X-Received: by 2002:a17:903:1a30:b0:2a4:8cd:c3cf with SMTP id d9443c01a7336-2aeae91d939mr56976675ad.49.1773303358303;
        Thu, 12 Mar 2026 01:15:58 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aec09e123dsm12941775ad.46.2026.03.12.01.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 01:15:57 -0700 (PDT)
Date: Thu, 12 Mar 2026 17:15:51 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] ksmbd: fix use-after-free in durable v2 replay of active
 file handles
Message-ID: <abJ2NzsiCzxyySzS@v4bel>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

parse_durable_handle_context() unconditionally assigns dh_info->fp->conn
to the current connection when handling a DURABLE_REQ_V2 context with
SMB2_FLAGS_REPLAY_OPERATION. ksmbd_lookup_fd_cguid() does not filter by
fp->conn, so it returns file handles that are already actively connected.
The unconditional overwrite replaces fp->conn, and when the overwriting
connection is subsequently freed, __ksmbd_close_fd() dereferences the
stale fp->conn via spin_lock(&fp->conn->llist_lock), causing a
use-after-free.

KASAN report:

[    7.349357] ==================================================================
[    7.349607] BUG: KASAN: slab-use-after-free in _raw_spin_lock+0x75/0xe0
[    7.349811] Write of size 4 at addr ffff8881056ac18c by task kworker/1:2/108
[    7.350010]
[    7.350064] CPU: 1 UID: 0 PID: 108 Comm: kworker/1:2 Not tainted 7.0.0-rc3+ #58 PREEMPTLAZY
[    7.350068] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    7.350070] Workqueue: ksmbd-io handle_ksmbd_work
[    7.350083] Call Trace:
[    7.350087]  <TASK>
[    7.350087]  dump_stack_lvl+0x64/0x80
[    7.350094]  print_report+0xce/0x660
[    7.350100]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    7.350101]  ? __pfx___mod_timer+0x10/0x10
[    7.350106]  ? _raw_spin_lock+0x75/0xe0
[    7.350108]  kasan_report+0xce/0x100
[    7.350109]  ? _raw_spin_lock+0x75/0xe0
[    7.350114]  kasan_check_range+0x105/0x1b0
[    7.350116]  _raw_spin_lock+0x75/0xe0
[    7.350118]  ? __pfx__raw_spin_lock+0x10/0x10
[    7.350119]  ? __call_rcu_common.constprop.0+0x25e/0x780
[    7.350125]  ? close_id_del_oplock+0x2cc/0x4e0
[    7.350128]  __ksmbd_close_fd+0x27f/0xaf0
[    7.350131]  ksmbd_close_fd+0x135/0x1b0
[    7.350133]  smb2_close+0xb19/0x15b0
[    7.350142]  ? __pfx_smb2_close+0x10/0x10
[    7.350143]  ? xas_load+0x18/0x270
[    7.350146]  ? _raw_spin_lock+0x84/0xe0
[    7.350148]  ? __pfx__raw_spin_lock+0x10/0x10
[    7.350150]  ? _raw_spin_unlock+0xe/0x30
[    7.350151]  ? ksmbd_smb2_check_message+0xeb2/0x24c0
[    7.350153]  ? ksmbd_tree_conn_lookup+0xcd/0xf0
[    7.350154]  handle_ksmbd_work+0x40f/0x1080
[    7.350156]  process_one_work+0x5fa/0xef0
[    7.350162]  ? assign_work+0x122/0x3e0
[    7.350163]  worker_thread+0x54b/0xf70
[    7.350165]  ? __pfx_worker_thread+0x10/0x10
[    7.350166]  kthread+0x346/0x470
[    7.350170]  ? recalc_sigpending+0x19b/0x230
[    7.350176]  ? __pfx_kthread+0x10/0x10
[    7.350178]  ret_from_fork+0x4fb/0x6c0
[    7.350183]  ? __pfx_ret_from_fork+0x10/0x10
[    7.350185]  ? __switch_to+0x36c/0xbe0
[    7.350188]  ? __pfx_kthread+0x10/0x10
[    7.350190]  ret_from_fork_asm+0x1a/0x30
[    7.350197]  </TASK>
[    7.350197]
[    7.355160] Allocated by task 123:
[    7.355261]  kasan_save_stack+0x33/0x60
[    7.355373]  kasan_save_track+0x14/0x30
[    7.355484]  __kasan_kmalloc+0x8f/0xa0
[    7.355593]  ksmbd_conn_alloc+0x44/0x6d0
[    7.355711]  ksmbd_kthread_fn+0x243/0xd70
[    7.355839]  kthread+0x346/0x470
[    7.355942]  ret_from_fork+0x4fb/0x6c0
[    7.356051]  ret_from_fork_asm+0x1a/0x30
[    7.356164]
[    7.356214] Freed by task 134:
[    7.356305]  kasan_save_stack+0x33/0x60
[    7.356416]  kasan_save_track+0x14/0x30
[    7.356527]  kasan_save_free_info+0x3b/0x60
[    7.356646]  __kasan_slab_free+0x43/0x70
[    7.356761]  kfree+0x1ca/0x430
[    7.356862]  ksmbd_tcp_disconnect+0x59/0xe0
[    7.356993]  ksmbd_conn_handler_loop+0x77e/0xd40
[    7.357138]  kthread+0x346/0x470
[    7.357240]  ret_from_fork+0x4fb/0x6c0
[    7.357350]  ret_from_fork_asm+0x1a/0x30
[    7.357463]
[    7.357513] The buggy address belongs to the object at ffff8881056ac000
[    7.357513]  which belongs to the cache kmalloc-1k of size 1024
[    7.357857] The buggy address is located 396 bytes inside of
[    7.357857]  freed 1024-byte region [ffff8881056ac000, ffff8881056ac400)

Fix by removing the unconditional fp->conn assignment and rejecting the
replay when fp->conn is non-NULL. This is consistent with
ksmbd_lookup_durable_fd(), which also rejects file handles with a
non-NULL fp->conn. For disconnected file handles (fp->conn == NULL),
ksmbd_reopen_durable_fd() handles setting fp->conn.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 fs/smb/server/smb2pdu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9f7ff7491e9a..e2b280c9fdd7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2828,7 +2828,11 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 						goto out;
 					}
 
-					dh_info->fp->conn = conn;
+					if (dh_info->fp->conn) {
+						ksmbd_put_durable_fd(dh_info->fp);
+						err = -EBADF;
+						goto out;
+					}
 					dh_info->reconnected = true;
 					goto out;
 				}
-- 
2.43.0

