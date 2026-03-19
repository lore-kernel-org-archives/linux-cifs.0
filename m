Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8922DBF78
	for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773931940; cv=none; b=CUnGsNovPNdS1fA85q7r8FiREUHSICiVtMO/wJG5RvNjvWoPQaB1AYqOhL9J3wbtlp0DAOfqqchAujcIWOlJIniXHGb1i88aJp+7qLynWOm+8zlE1atfKarMMOh96CAOwI2mKgUOg6jSAVLBFuUxKhEdVCoXe/oO3i9430TMgl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773931940; c=relaxed/simple;
	bh=RJ41S1snfyuQgrhKqvYt8cog5cMZwGsaPY/mqZngtdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tcS57gzUJzmR5kDOZKQOBaUe/5e5kRrUVa0iJq37VzPseXKjqB7cnOxNvIrnn7ufeYtLMUFjffAR4V+B7caThggVAtTIF9oIIsPxNmw7G9kPh2rAZ0sq4PWXYkvx1Bf0mqzipADHWsEeQY+XJ+VPCh/op5DR4/j8+gzj4LegOL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=H8lAPBa/; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="H8lAPBa/"
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D672C3FBBA
	for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1773931935;
	bh=3KJpXt63kzGfwrgcWC7T+DbVFRnuXxbhtvmi/paNSmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=H8lAPBa/KiOwSu3XcH8nn/VGkXNKyuigAlruAiVv510EbnE3+uR0GeMaHUPsbOcCn
	 DQ4tlyfb4VzvwkDoCucYmFVDhrebywz3EDGc/7KoZZLKZUyQ0/6QILXbspwyLJrOr7
	 B6omuVJpQZ5yU7QxSitmVwY9yxK1G7bJSCeJ3Uj4qFOhb4jerSNTa3oT4gzY2GPhkU
	 aryXuttHsYPIYrpRL2ysSvImXeyDFYG4G6A2AKWSH1ZuWbZ7EGh0zFvyvnM67i1pG4
	 ZeSxN7FxS1ZTUZVpE7pfTlEe3jy6kNFfYUkcA+jwmPHbz0mmTJMYcPGHgPQpiJDDo9
	 EbF8alIRxxQE0+7s3nweN9CjO5x/H433a/jl2A9XTr7hiUH0Toj+ZDNhbAvR5BD42n
	 rTr3PeH33XBAPdaoG1nGxx/r78Bpyyv7PmlReD4pWhiaCtaMaFNLV3Y1eQclwkrdDp
	 pJLzhB4ZLrBfdL0sAymGQ1gKWf+QINzCPhug8T740AzeA431bIaDFTR+HEK1rEp5e9
	 ekAlTQEf61ggKJBrltsCAs1PIfl9KYEOkZbMY27+G9bfBWEZqFw4yNhDkspj9gZNkZ
	 IhDe6HXbgXoaTu/Vq1RtSMmCBm0zqbT4PXhSCtdqj1Mnb0/n5eGw/kFXGrgfP0XRp5
	 lLt1ii1jJndMUGNAkwCfDhxs=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4852cf0318dso9574795e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 07:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773931935; x=1774536735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KJpXt63kzGfwrgcWC7T+DbVFRnuXxbhtvmi/paNSmc=;
        b=POWKCxk/NIRHPcwySz4q9QemP8RLtyvigqI++t5b8pORpC8m14q3IQjZsLU1lx5Q9N
         JcJncLWg7RT+hQpHT5VvEvEkAmd1j341d/FHBY8VGTckhCAudem9d+Mo7iZN3Q/C/6/U
         rOtBTmqdYIlT9MB5VYqD+lnpVsiz19Mwwe0TwQ9s51aVrxwCULk6Byp4NuiCDSdZIqe5
         j/U955QguOHRnybswWBlFK9otvmMvjp5vs0LK0ZSBmVXHucuD4hHMmBYWJ/QUnPSf64B
         MVOhnvxf79r6ZbvAzuF6/uWZtD49C/BDP6QWflJlmsLlWWdt3jC0ZLkOcvYvtGiXTmil
         K2eQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9gsrUPK3fAvhzxoROIvnGdRY4atZf+ByuC3DkJne9M//Gl+Znn4OFlBouzghMWVMASl5LW+OTFm7s@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3do1M8uydbOxgv0mWn98yM7jHLYv6tm2fSpGtu9cERa4bC71t
	uMqx/Zy2FjAlx9ghRFTIMW85+jcfiSGf8nmNTE0mVaAVH7nrgnnz9os4gJerS8q0m86UgyJDT/N
	yH4cnfaBZ5ngyw0AphdEo495CDzYMwvNUVyCeGF6G89OlpdjL7B/RVnkrXmT2lEdeJ8cJdP64On
	mzTJ8=
X-Gm-Gg: ATEYQzyebnvKQjitCbfJstbKi85RTVGb+QeZf7Vwoh8kGeDwwTDYoykewMtP9kNKSXV
	9tFQLvCezbcyEjK7Mli+ecW2yD9my1W3sfUP+DlGVlUvtjsE1/sDmCLrJMs2hWQC0NjjAoz4Dyx
	28JNQmgRmnXolPccmVfNOLscunoviwJXlmxwynHtUWtQ69W0/BkdM08EV3nUlWSbbqipKsrKrPu
	TKrYvxuICeJdCR0oZGeoJAaniZOdke3IMRGuU5zwAi3A9XCVa+MgcpbrgdwRwroZdovlPtPCV5y
	IUEwe0YqrPZ/3UWQRe6TkyTcAtHveL4cBrh7oYlCVrXwNQeZrITVmvxsWlINwlEuxeCZ56WCBfm
	lzt+rpmA6lD6B94zbOR3xotAek8NWPsABQCSGdHPt6X7pqbp/W8VM
X-Received: by 2002:a05:600c:3551:b0:485:9a50:3369 with SMTP id 5b1f17b1804b1-486f456fe98mr130513895e9.29.1773931935237;
        Thu, 19 Mar 2026 07:52:15 -0700 (PDT)
X-Received: by 2002:a05:600c:3551:b0:485:9a50:3369 with SMTP id 5b1f17b1804b1-486f456fe98mr130513445e9.29.1773931934756;
        Thu, 19 Mar 2026 07:52:14 -0700 (PDT)
Received: from XPS-17-9720.han-hoki.ts.net ([213.204.117.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8c4aa85sm56566895e9.12.2026.03.19.07.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 07:52:14 -0700 (PDT)
From: Ghadi Elie Rahme <ghadi.rahme@canonical.com>
To: stable@vger.kernel.org
Cc: Ghadi Elie Rahme <ghadi.rahme@canonical.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@cjr.nz>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on session connection failure
Date: Thu, 19 Mar 2026 16:49:29 +0200
Message-ID: <20260319144929.455978-1-ghadi.rahme@canonical.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Upstream commit 6916881f443f67f6893b504fa2171468c8aed915 ]

It is possible for find_ipc_from_server_path to run while the tcon is NULL,
resulting in a NULL pointer dereference crash when calling strcasecmp().
This happens when the ipc connection fails freeing the tcon and setting it
to NULL while the dfs cache worker thread was already executing.
This issue was fixed upstream indirectly by a rewrite that removed this
function. Although with this fix the issue can still occur, the window of
the race is now much narrower.
A fix that would completely fix it using mutexes was tested and
worked fine. However the regression potential would be much higher and so
would be the deviation from upstream.
This is a good balance of safety while minimizing upstream deviation.

Stack trace:

 BUG: kernel NULL pointer dereference, address: 0000000000000050
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 1013dc64067 P4D 10125f65067 PUD 10125f64067 PMD 0
 Oops: 0000 [#1] SMP NOPTI
 CPU: 80 PID: 3913754 Comm: kworker/u256:1 Kdump: loaded Not tainted 5.15.0-143-generic #153-Ubuntu
 Hardware name: Dell Inc. PowerEdge R760/09XV41, BIOS 2.3.5 09/10/2024
 Workqueue: cifs-dfscache refresh_cache_worker [cifs]
 RIP: 0010:strcasecmp+0x19/0x50
 Code: 01 84 c9 75 f1 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 f9 31 ff 41 0f b6 04 39 0f b6 c8 89 c2 83 c2 20 f6 81 e0 39 89 85  01 <0f> b6 0c 3e 0f b6 d2 0f 45 c2 89 ca 44 0f b6 c1 83 c2 20 41 f6 80
 RSP: 0018:ff4043e68aadb900 EFLAGS: 00010246
 RAX: 000000000000005c RBX: ff4043e68aadbc68 RCX: 000000000000005c
 RDX: 000000000000007c RSI: 0000000000000050 RDI: 0000000000000000
 RBP: ff4043e68aadb990 R08: 0000000000000064 R09: ff4043e68aadb91f
 R10: 0000000000000012 R11: 0000000000000000 R12: ff210c171f193c00
 R13: 0000000000000009 R14: 0000000000000008 R15: ff210d1d3f19a7c0
 FS:  0000000000000000(0000) GS:ff210d127fc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000050 CR3: 0000011f2cc38005 CR4: 0000000000771ee0
 PKRU: 55555554
 Call Trace:
 <TASK>
 ? find_ipc_from_server_path+0xd9/0x110 [cifs]
 refresh_cache+0xf1/0x470 [cifs]
 ? in4_pton+0x7a/0x160
 ? kfree+0x1f7/0x250
 ? target_share_equal+0x198/0x210 [cifs]
 ? __refresh_tcon.isra.0+0x242/0x670 [cifs]
 ? kfree+0x1f7/0x250
 ? __refresh_tcon.isra.0+0x242/0x670 [cifs]
 ? cifs_put_tcon.part.0+0x39/0x220 [cifs]
 ? cifs_put_tcon+0x1c/0x30 [cifs]
 ? refresh_mounts+0x147/0x210 [cifs]
 refresh_cache_worker+0x1ac/0x300 [cifs]
 ? lock_timer_base+0x3b/0xd0
 process_one_work+0x228/0x3d0
 worker_thread+0x53/0x420
 ? process_one_work+0x3d0/0x3d0
 kthread+0x127/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: c870a8e70e68 ("cifs: handle different charsets in dfs cache")
Cc: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@cjr.nz>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Aurelien Aptel <aaptel@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Ghadi Elie Rahme <ghadi.rahme@canonical.com>
---
Changes in v2:
- Added maintainers to CC.

v2: https://lore.kernel.org/stable/20260303173139.517020-1-ghadi.rahme@canonical.com/T/#u

 fs/smb/client/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 3bc1d3494be3..af2177b96f2f 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -98,7 +98,7 @@ static struct cifs_ses *find_ipc_from_server_path(struct cifs_ses **ses, const c

 	get_ipc_unc(path, unc, sizeof(unc));
 	for (; *ses; ses++) {
-		if (!strcasecmp(unc, (*ses)->tcon_ipc->tree_name))
+		if ((*ses)->tcon_ipc && !strcasecmp(unc, (*ses)->tcon_ipc->tree_name))
 			return *ses;
 	}
 	return ERR_PTR(-ENOENT);
--
2.51.0

