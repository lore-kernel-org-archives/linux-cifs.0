Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250143B9D87
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 08:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773303431; cv=none; b=QxOXl8c+Q+pgechF+0nv9dp7lg640KhSLFmYgXJdgBcUpvqQF9B1cbBXgpyxCwUoGKWW+8BBSxmYm/utPKAKgSSk07YfTQ4CoCqkTD0a3mzKCj2G+QRL9ewzt9vPn9LYcBicyNM8LTGTH/KU3NHjauYArQqsuaqdsFc60pR0Sfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773303431; c=relaxed/simple;
	bh=WJplAi4KG9uYyqvFevlWmWtjWi7HCStBnNm9xcF/QOg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rla3EisGJ+Yuqs/fmdwQ9n6sqCXjH7r+s5qjPeJl+o8q3DE4buAT9rEyjmTtG52mtRSiGWpR2DNpxZTQiDQaXiESmH9KgShov4Y5/D8cHI5LdHHXpASA4dZZv+c20w0gSCvM8CYpKrhvheeuMcI0yDgP3lCge9QUBg5m/wHSyb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyGl2z0m; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyGl2z0m"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2addb31945aso5905835ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 01:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773303428; x=1773908228; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bfUpwZBglKlstFFE5lgPkjKLgF2ZrP6Pd01HjFxEQcI=;
        b=kyGl2z0mYXPcZNi/IhfHrQ2M6Zp+uZHgNWoC0AIwpzD2589Qs3oyqjUQv8mXIuPZYH
         uJQMLfr0/dXfypVAEox13SOp2GhVljF6+jvka+BxX+Q/SrjEJ/h9NHNY4Hzfs/58xQUz
         kU3NTj7n+DEsCetq521++qjFBFXFehtpNr525phIxM6E3kx+n+U7N10OBT6fAdabEsdk
         Ox0D4QvCXrfLDtM6vm6iVjsuTkdZ2Y1ft3jpYuxhRpiBl+1GyjiP4edv5Uey+RNUtfml
         TKItkGgOTc650cASOyOpBboxgYcUzpqAGAFNGyOzuYzyrEH6v1ivmaoqIZVlXJnEZHU6
         g75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773303428; x=1773908228;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfUpwZBglKlstFFE5lgPkjKLgF2ZrP6Pd01HjFxEQcI=;
        b=p6LlkDod4iZsz6TvtdSwZgABBIwFtC38AxAl6UawqSsBlWGGLDu6bpPr79Vc3u3qy1
         K7ugL9tx/ftepSrV2xDXocFcpoYe4ls6ua7qc66LFS7Iy2GOrCHz3WM0FK5xwCnRK45n
         6s0NQy8HNGUXeOAEoTIGCcCBtBs0T3IV1mgWI7AK0fqNPRzKO7bJGRuHs965mqF2Vtar
         O7exiQk+gjx8SZx968DL3fPwLO0SZK+6j5R5hJSIhA0GgxHtfT+B9yiIEe2vP+IC4x7f
         0yGCCkR2jKcZBxzKDcTpioHJbjZ2yhXzwXfx24YGFdolOEpYWFhjYUi3CCTtnK74f1fX
         GrOA==
X-Gm-Message-State: AOJu0YxqFhtPS76Fo2LEzMySXyL+KVxqcNZZs3uLufAIFPnP8nyPvu1b
	n5mX+nebstKmWuvhTFkU58gVmlWU1435kmaT5oXHLaK/3+87/+6kKj0Q
X-Gm-Gg: ATEYQzxrXWOxMNlOC+eSTzJXEEfvLnDuXLOVKAk8DpZHuWlMVPbC17huDA8Jmtc2JoA
	BJbl276jCVE35MZMpD5RZjhxhVUj4NSb+fgXnEUOzByOKU1Mnl+NLPR+Uf069BmEpFZtiW2g19m
	p+Yqfou+UoWesWTboBBldQGpJgjjKwPo0z8FCN5td/98TvObQX6dGIwfzNB5Hz3Xc+B4EijVx5E
	s+ZbKhhoNQkQDjNxiSoDqnm5EGSkXSgtdKzWySLetsDy2eesdo07h7Il0CiM16yQQGL606iSVHF
	xK9GO8XniVTVIV3DJbHCY5FZ1GIEYtiSdGYWDvsJ/DwU7C79Z2f9QK9RieVpoqx5KL0Xbpnr5Jo
	EtWBw2HuXLWh99rkQpBwyZihoBUnE4R6CEqRmtXB2jbSDo+8SHhIWnplcL+P4h9oy8cWUT/XarL
	va0O4G8yJzscmhy1WUYy9fR+kwN6+6bTHesrgMg5mOjg==
X-Received: by 2002:a17:903:240d:b0:2ae:588a:f3e5 with SMTP id d9443c01a7336-2aeae85b2d8mr57083565ad.30.1773303428383;
        Thu, 12 Mar 2026 01:17:08 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae246ff0sm70872715ad.27.2026.03.12.01.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 01:17:07 -0700 (PDT)
Date: Thu, 12 Mar 2026 17:17:02 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] ksmbd: fix use-after-free of share_conf in compound request
Message-ID: <abJ2fk0KaQNeHgmp@v4bel>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

smb2_get_ksmbd_tcon() reuses work->tcon in compound requests without
validating tcon->t_state. ksmbd_tree_conn_lookup() checks t_state ==
TREE_CONNECTED on the initial lookup path, but the compound reuse path
bypasses this check entirely.

If a prior command in the compound (SMB2_TREE_DISCONNECT) sets t_state
to TREE_DISCONNECTED and frees share_conf via ksmbd_share_config_put(),
subsequent commands dereference the freed share_conf through
work->tcon->share_conf.

KASAN report:

[    4.144653] ==================================================================
[    4.145059] BUG: KASAN: slab-use-after-free in smb2_write+0xc74/0xe70
[    4.145415] Read of size 4 at addr ffff88810430c194 by task kworker/1:1/44
[    4.145772]
[    4.145867] CPU: 1 UID: 0 PID: 44 Comm: kworker/1:1 Not tainted 7.0.0-rc3+ #60 PREEMPTLAZY
[    4.145871] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    4.145875] Workqueue: ksmbd-io handle_ksmbd_work
[    4.145888] Call Trace:
[    4.145892]  <TASK>
[    4.145894]  dump_stack_lvl+0x64/0x80
[    4.145910]  print_report+0xce/0x660
[    4.145919]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    4.145928]  ? smb2_write+0xc74/0xe70
[    4.145931]  kasan_report+0xce/0x100
[    4.145934]  ? smb2_write+0xc74/0xe70
[    4.145937]  smb2_write+0xc74/0xe70
[    4.145939]  ? __pfx_smb2_write+0x10/0x10
[    4.145942]  ? _raw_spin_unlock+0xe/0x30
[    4.145945]  ? ksmbd_smb2_check_message+0xeb2/0x24c0
[    4.145948]  ? smb2_tree_disconnect+0x31c/0x480
[    4.145951]  handle_ksmbd_work+0x40f/0x1080
[    4.145953]  process_one_work+0x5fa/0xef0
[    4.145962]  ? assign_work+0x122/0x3e0
[    4.145964]  worker_thread+0x54b/0xf70
[    4.145967]  ? __pfx_worker_thread+0x10/0x10
[    4.145970]  kthread+0x346/0x470
[    4.145976]  ? recalc_sigpending+0x19b/0x230
[    4.145980]  ? __pfx_kthread+0x10/0x10
[    4.145984]  ret_from_fork+0x4fb/0x6c0
[    4.145992]  ? __pfx_ret_from_fork+0x10/0x10
[    4.145995]  ? __switch_to+0x36c/0xbe0
[    4.145999]  ? __pfx_kthread+0x10/0x10
[    4.146003]  ret_from_fork_asm+0x1a/0x30
[    4.146013]  </TASK>
[    4.146014]
[    4.149858] Allocated by task 44:
[    4.149953]  kasan_save_stack+0x33/0x60
[    4.150061]  kasan_save_track+0x14/0x30
[    4.150169]  __kasan_kmalloc+0x8f/0xa0
[    4.150274]  ksmbd_share_config_get+0x1dd/0xdd0
[    4.150401]  ksmbd_tree_conn_connect+0x7e/0x600
[    4.150529]  smb2_tree_connect+0x2e6/0x1000
[    4.150645]  handle_ksmbd_work+0x40f/0x1080
[    4.150761]  process_one_work+0x5fa/0xef0
[    4.150873]  worker_thread+0x54b/0xf70
[    4.150978]  kthread+0x346/0x470
[    4.151071]  ret_from_fork+0x4fb/0x6c0
[    4.151176]  ret_from_fork_asm+0x1a/0x30
[    4.151286]
[    4.151332] Freed by task 44:
[    4.151418]  kasan_save_stack+0x33/0x60
[    4.151526]  kasan_save_track+0x14/0x30
[    4.151634]  kasan_save_free_info+0x3b/0x60
[    4.151751]  __kasan_slab_free+0x43/0x70
[    4.151861]  kfree+0x1ca/0x430
[    4.151952]  __ksmbd_tree_conn_disconnect+0xc8/0x190
[    4.152088]  smb2_tree_disconnect+0x1cd/0x480
[    4.152211]  handle_ksmbd_work+0x40f/0x1080
[    4.152326]  process_one_work+0x5fa/0xef0
[    4.152438]  worker_thread+0x54b/0xf70
[    4.152545]  kthread+0x346/0x470
[    4.152638]  ret_from_fork+0x4fb/0x6c0
[    4.152743]  ret_from_fork_asm+0x1a/0x30
[    4.152853]
[    4.152900] The buggy address belongs to the object at ffff88810430c180
[    4.152900]  which belongs to the cache kmalloc-96 of size 96
[    4.153226] The buggy address is located 20 bytes inside of
[    4.153226]  freed 96-byte region [ffff88810430c180, ffff88810430c1e0)
[    4.153549]
[    4.153596] The buggy address belongs to the physical page:
[    4.153750] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810430ce80 pfn:0x10430c
[    4.154000] flags: 0x100000000000200(workingset|node=0|zone=2)
[    4.154160] page_type: f5(slab)
[    4.154251] raw: 0100000000000200 ffff888100041280 ffff888100040110 ffff888100040110
[    4.154461] raw: ffff88810430ce80 0000000800200009 00000000f5000000 0000000000000000
[    4.154668] page dumped because: kasan: bad access detected
[    4.154820]
[    4.154866] Memory state around the buggy address:
[    4.155002]  ffff88810430c080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.155196]  ffff88810430c100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.155391] >ffff88810430c180: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[    4.155587]                          ^
[    4.155693]  ffff88810430c200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.155891]  ffff88810430c280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.156087] ==================================================================

Add the same t_state validation to the compound reuse path, consistent
with ksmbd_tree_conn_lookup().

Fixes: 5005bcb42191 ("ksmbd: validate session id and tree id in the compound request")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9f7ff7491e9a..bbd144558b7a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -126,6 +126,8 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 			pr_err("The first operation in the compound does not have tcon\n");
 			return -EINVAL;
 		}
+		if (work->tcon->t_state != TREE_CONNECTED)
+			return -ENOENT;
 		if (tree_id != UINT_MAX && work->tcon->id != tree_id) {
 			pr_err("tree id(%u) is different with id(%u) in first operation\n",
 					tree_id, work->tcon->id);
-- 
2.43.0

