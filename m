Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3130103F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 23:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762556853; cv=none; b=jkQ9qQSk3P3gvIPwdrj/xUIHHemH3dzhpF1rqeYoiLpqATFNPE33dHa8rrAQ6rLc2VShRrpUXChbNpVzSypRSjp2xPI6g4wYGepZwvUkJ1tbTjpyoqxDCAKD2LkW7JDzMsy+3v6wnHfUVpmV+uO+8aCZA0zde+sJxJb1nCp/Y40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762556853; c=relaxed/simple;
	bh=qW4W6cA0owJCFwbp6YNpBCC2XHiH39M+fTk7ojXrDCo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=autk+Tzt30m3ma0/Qe/9kJqw5T1cEJv2acZ6ANgn/9L0HwiAKa72z3GM6SSjWUeUJW09Mtt99+YmWcz+D7zEi8YoWJ1fYZwkLMqrI1SYCM/NlRLz6kinsCh9AGzeM3Alz430uR2uRMQSdsUgr9NwVpLI3ldy+ijcYbR0VIFMDSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YyEJAh37; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YyEJAh37"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88040cfadbfso7977296d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 15:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762556850; x=1763161650; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0T1xBMVbMQYQHCdHkuRAqGIgurAU4TjTILHapuv9Fxw=;
        b=YyEJAh37+pOqhVCzIx+NP3lJAvWwO3aiJHD0NShmvsh2SWcGJg5XxbRe8flDucX+6x
         rKUwl9oFBATWjGrnEKWINxGL4ffO4zVNtMhUkHAmQEKWEMoxdaHalfpEk+sV3zUMkDtt
         7LpwClqjEVnsoCVd6bdIopSwWo/hgl6sXeEULHbSJ5r0cRCOMdNSl+axwKVbcaBJMvDj
         ocrGhdnsmye2knWTo0aRBeyrFoprG+/1/PmXTkdobv/O/VFG+VNdXWWP8gtBKgXzBTvT
         pJh+AvLrJwyrc//marKIjFyWaKDlQDaUObrEAKBUEJYcoTtrubRlCs3iLJqCDUYkQGMF
         CoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762556850; x=1763161650;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0T1xBMVbMQYQHCdHkuRAqGIgurAU4TjTILHapuv9Fxw=;
        b=JHuQMfgTGQ9ATvlySS8EesxYuCf+dciKyhfHZTB6rbVsePhkk1CUFISC7zbaZ7pNv4
         0MV4w9X04CqxdywZKlAWHkZ2bAIcvlOLptLnVfFmldDEjxlBdYP2BnvmyE4DAuzjYjJc
         CbuoADBUjL4RPHygNzo8wmOZioU5BWeFnvlA4IJAPR0+/50Tp8RLq1+JXbBbG+hX2+Nb
         CT6HAvpw2/QQ2LucQiKktJPb6E39LLDca7xui4tJuwFxudzOcoU5kId+GABHTBqvf/uo
         WuVujaTmtGbwans4CaNy8Mt7hFG1ykB3fz9JQn5ofIe7LUKc7wuIPfaHVE5IzY75HHkI
         Ja6Q==
X-Gm-Message-State: AOJu0Yz7mvA0/iXPk8TWdsNKksUeSEPS2Zlbf9gjrF4rn8kB2jqJJQLz
	Kgn8qbJevLijuA7WwKwrvNevkKx6Mz7JZeXm+Q2krTgh3tAEyvsx0LJRTHd9tHXo80m/wp0EYm9
	NuLrj+kywsUYH8imPDdTbjBzQYoux7xt6L74WV9U=
X-Gm-Gg: ASbGncviY4Pj/qI912X8ndTUd3TVla0BArhfL0qRCV828Hb5mbi5k8CKzLNx16quabZ
	anEo736H3SmK54ubNmJGSVl2KDoXEm4dhEXREwo+OfTBXdWAVeZW9DJLUi1y27Tht7b1pFXUkhF
	rDNKxe/UHlPz4/+CiJwHquhS5zwm7Vam329g9ry6+XVH6cVeefUbUbA1MR4Nodo0S8opM+9TVYg
	JQjqfduJDN4VzWjD320U4UydysXoFlrQUpDSuiDC9JEs+hR2Td3R0FMyFPPKvXMM8BXUwGKww0B
	AXOFxKR2xenxZnMux+55l8bHYwwI4nsb40RfAZnWujvWmxosE8rnztaXnnuO3f1v9B+s8GSZoQb
	T8ZQzMnZS1vgHGdx39oxKrVcERskSz5CmB+NkcAcbAXGT4vnKlSr5kdD6vMPASryRWQLBhtlv36
	LgsXkvsw==
X-Google-Smtp-Source: AGHT+IGOLfAfRsUHcd1Msc0svw2onbQGzlijsVJGAhAfVSOJmcdGW1uSmgz02mAtL1+OtCo2627+NZHzH/oRmdghdTA=
X-Received: by 2002:a05:6214:212f:b0:880:3eb3:3b0a with SMTP id
 6a1803df08f44-8822f4d3dacmr42420846d6.4.1762556850270; Fri, 07 Nov 2025
 15:07:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 7 Nov 2025 17:07:19 -0600
X-Gm-Features: AWmQ_bm04_u2v4ue835sql5fjIpB9wIYHMjxSoH7iDJ9P7JjYK_EwvrJHrKdu_U
Message-ID: <CAH2r5mtnf1eBTXnDQBiQYKrwEwUzxcxC5Nfv1NbiCdudQMaUZA@mail.gmail.com>
Subject: New netfs crash in last month or so
To: CIFS <linux-cifs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Have been seeing this netfs crash over the last month or so
(presumably a recent regression) for example running generix/215.
Ideas welcome

[Fri Nov 7 10:03:14 2025] run fstests generic/215 at 2025-11-07 10:03:15
==================================================================
[Fri Nov 7 10:03:15 2025] BUG: KASAN: slab-use-after-free in
netfs_limit_iter+0x50f/0x770 [netfs]
[Fri Nov 7 10:03:15 2025] Read of size 1 at addr ff1100011b65d910 by
task kworker/u36:2/69285
[Fri Nov 7 10:03:15 2025] CPU: 3 UID: 0 PID: 69285 Comm: kworker/u36:2
Tainted: G E 6.18.0-rc4 #1 PREEMPT(voluntary)
[Fri Nov 7 10:03:15 2025] Tainted: [E]=UNSIGNED_MODULE
[Fri Nov 7 10:03:15 2025] Hardware name: Red Hat KVM, BIOS
1.16.3-4.el9 04/01/2014
[Fri Nov 7 10:03:15 2025] Workqueue: events_unbound
netfs_write_collection_worker [netfs]
[Fri Nov 7 10:03:15 2025] Call Trace:
[Fri Nov 7 10:03:15 2025] <TASK>
[Fri Nov 7 10:03:15 2025] dump_stack_lvl+0x79/0xb0
[Fri Nov 7 10:03:15 2025] print_report+0xcb/0x610
[Fri Nov 7 10:03:15 2025] ? __virt_addr_valid+0x19a/0x300
[Fri Nov 7 10:03:15 2025] ? netfs_limit_iter+0x50f/0x770 [netfs]
[Fri Nov 7 10:03:15 2025] ? netfs_limit_iter+0x50f/0x770 [netfs]
[Fri Nov 7 10:03:15 2025] kasan_report+0xca/0x100
[Fri Nov 7 10:03:15 2025] ? netfs_limit_iter+0x50f/0x770 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_limit_iter+0x50f/0x770 [netfs]
[Fri Nov 7 10:03:15 2025] ? __pfx_netfs_limit_iter+0x10/0x10 [netfs]
[Fri Nov 7 10:03:15 2025] ? cifs_prepare_write+0x28e/0x490 [cifs]
[Fri Nov 7 10:03:15 2025] netfs_retry_writes+0x94d/0xcf0 [netfs]
[Fri Nov 7 10:03:15 2025] ? __pfx_netfs_retry_writes+0x10/0x10 [netfs]
[Fri Nov 7 10:03:15 2025] ? folio_end_writeback+0x9b/0xf0
[Fri Nov 7 10:03:15 2025] ? netfs_folio_written_back+0x1af/0x3e0 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_write_collection+0x936/0x1bb0 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_write_collection_worker+0x13d/0x2b0 [netfs]
[Fri Nov 7 10:03:15 2025] process_one_work+0x4bf/0xb40
[Fri Nov 7 10:03:15 2025] ? __pfx_process_one_work+0x10/0x10
[Fri Nov 7 10:03:15 2025] ? assign_work+0xd6/0x110
[Fri Nov 7 10:03:15 2025] worker_thread+0x2c9/0x550
[Fri Nov 7 10:03:15 2025] ? __pfx_worker_thread+0x10/0x10
[Fri Nov 7 10:03:15 2025] kthread+0x216/0x3e0
[Fri Nov 7 10:03:15 2025] ? __pfx_kthread+0x10/0x10
[Fri Nov 7 10:03:15 2025] ? __pfx_kthread+0x10/0x10
[Fri Nov 7 10:03:15 2025] ? lock_release+0xc4/0x270
[Fri Nov 7 10:03:15 2025] ? rcu_is_watching+0x20/0x50
[Fri Nov 7 10:03:15 2025] ? __pfx_kthread+0x10/0x10
[Fri Nov 7 10:03:15 2025] ret_from_fork+0x2a8/0x350
[Fri Nov 7 10:03:15 2025] ? __pfx_kthread+0x10/0x10
[Fri Nov 7 10:03:15 2025] ret_from_fork_asm+0x1a/0x30
[Fri Nov 7 10:03:15 2025] </TASK>
[Fri Nov 7 10:03:15 2025] Allocated by task 74971:
[Fri Nov 7 10:03:15 2025] kasan_save_stack+0x24/0x50
[Fri Nov 7 10:03:15 2025] kasan_save_track+0x14/0x30
[Fri Nov 7 10:03:15 2025] __kasan_kmalloc+0x7f/0x90
[Fri Nov 7 10:03:15 2025] netfs_folioq_alloc+0x56/0x1b0 [netfs]
[Fri Nov 7 10:03:15 2025] rolling_buffer_init+0x23/0x70 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_create_write_req+0x85/0x360 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_writepages+0x110/0x520 [netfs]
[Fri Nov 7 10:03:15 2025] do_writepages+0x123/0x260
[Fri Nov 7 10:03:15 2025] filemap_fdatawrite_wbc+0x74/0x90
[Fri Nov 7 10:03:15 2025] __filemap_fdatawrite_range+0x9a/0xc0
[Fri Nov 7 10:03:15 2025] filemap_write_and_wait_range+0x56/0xc0
[Fri Nov 7 10:03:15 2025] cifs_flush+0x10c/0x1f0 [cifs]
[Fri Nov 7 10:03:15 2025] filp_flush+0x97/0xd0
[Fri Nov 7 10:03:15 2025] __x64_sys_close+0x4a/0x90
[Fri Nov 7 10:03:15 2025] do_syscall_64+0x75/0x9c0
[Fri Nov 7 10:03:15 2025] entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Fri Nov 7 10:03:15 2025] Freed by task 69285:
[Fri Nov 7 10:03:15 2025] kasan_save_stack+0x24/0x50
[Fri Nov 7 10:03:15 2025] kasan_save_track+0x14/0x30
[Fri Nov 7 10:03:15 2025] __kasan_save_free_info+0x3b/0x60
[Fri Nov 7 10:03:15 2025] __kasan_slab_free+0x43/0x70
[Fri Nov 7 10:03:15 2025] kfree+0x11a/0x630
[Fri Nov 7 10:03:15 2025] rolling_buffer_delete_spent+0x80/0xa0 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_write_collection+0x119c/0x1bb0 [netfs]
[Fri Nov 7 10:03:15 2025] netfs_write_collection_worker+0x13d/0x2b0 [netfs]
[Fri Nov 7 10:03:15 2025] process_one_work+0x4bf/0xb40
[Fri Nov 7 10:03:15 2025] worker_thread+0x2c9/0x550
[Fri Nov 7 10:03:15 2025] kthread+0x216/0x3e0
[Fri Nov 7 10:03:15 2025] ret_from_fork+0x2a8/0x350
[Fri Nov 7 10:03:15 2025] ret_from_fork_asm+0x1a/0x30
[Fri Nov 7 10:03:15 2025] The buggy address belongs to the object at
ff1100011b65d800
which belongs to the cache kmalloc-512 of size 512
[Fri Nov 7 10:03:15 2025] The buggy address is located 272 bytes inside of
freed 512-byte region [ff1100011b65d800, ff1100011b65da00)
[Fri Nov 7 10:03:15 2025] The buggy address belongs to the physical page:
[Fri Nov 7 10:03:15 2025] page: refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x11b658
[Fri Nov 7 10:03:15 2025] head: order:3 mapcount:0 entire_mapcount:0
nr_pages_mapped:0 pincount:0
[Fri Nov 7 10:03:15 2025] anon flags:
0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
[Fri Nov 7 10:03:15 2025] page_type: f5(slab)
[Fri Nov 7 10:03:15 2025] raw: 0017ffffc0000040 ff11000100038c80
0000000000000000 dead000000000001
[Fri Nov 7 10:03:15 2025] raw: 0000000000000000 0000000000200020
00000000f5000000 0000000000000000
[Fri Nov 7 10:03:15 2025] head: 0017ffffc0000040 ff11000100038c80
0000000000000000 dead000000000001
[Fri Nov 7 10:03:15 2025] head: 0000000000000000 0000000000200020
00000000f5000000 0000000000000000
[Fri Nov 7 10:03:15 2025] head: 0017ffffc0000003 ffd40000046d9601
00000000ffffffff 00000000ffffffff
[Fri Nov 7 10:03:15 2025] head: ffffffffffffffff 0000000000000000
00000000ffffffff 0000000000000008
[Fri Nov 7 10:03:15 2025] page dumped because: kasan: bad access detected
[Fri Nov 7 10:03:15 2025] Memory state around the buggy address:
[Fri Nov 7 10:03:15 2025] ff1100011b65d800: fa fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[Fri Nov 7 10:03:15 2025] ff1100011b65d880: fb fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[Fri Nov 7 10:03:15 2025] >ff1100011b65d900: fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb fb
[Fri Nov 7 10:03:15 2025] ^
[Fri Nov 7 10:03:15 2025] ff1100011b65d980: fb fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[Fri Nov 7 10:03:15 2025] ff1100011b65da00: fc fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc
[Fri Nov 7 10:03:15 2025]
==================================================================
[Fri Nov 7 10:03:15 2025] Disabling lock debugging due to kernel taint

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/8/builds/152/steps/78/logs/stdio

-- 
Thanks,

Steve
