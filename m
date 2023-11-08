Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9747C31A98
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="cZ5Amlf2"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2761BEF
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 08:35:08 -0800 (PST)
Message-ID: <a5bb61ab36adbee983a4b1106ee63ec7.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699461306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNmDgB6jqSUeiPWuOktht1983RM7uo6H3JERLw8vdbs=;
	b=cZ5Amlf2GvDzd3NQR11rrreJTQJXD9O/b/TFBLfMDwxMUbgxfA0mRR/QVHZ5xY/ki217Qc
	kNdgyNnb2CY94PuSBCRBYQFTS6rapPWYCgVKIgOexLsfj+bDBxfK3G+r8zlx3SzfBfWiNQ
	qsvnXnnaEcK9tXe0bD4zWjI7/qzESx1RynIFtEMv56t41rR5uGOwY/Ot9e12OhtYmlHTfr
	Tj9xBL66u1F4qP5ZkuARTP2E52BO/aeMhpjYeE2yFvAqV3S6kMvXrM7vtU7gdZMRMuc25Z
	7cHqVA0FR+3t6jEmZDW+3o//p5Y3E2KxdaPsynleZ26ETkmC/PlcIRgXj6Y8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699461306; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNmDgB6jqSUeiPWuOktht1983RM7uo6H3JERLw8vdbs=;
	b=bHGZ2RjxZq3pD97aLeuI8vZoP+Xou/WZthsxdb4cQRqZYZNWqAg+70cNXRhMI3uSqqiA9P
	VMxc4qK6sLysr3eCc7wQVnPZ+YHbfryi8MsZId8mSNvK+IecwvJq+ZAHjuBTcMdx2OnuLQ
	YaOwFgQhH721HjtHLWyK92D53/g48MiLcRtQrwd6J80aEXBSjOBvZOt57FWdXYt28qTyWD
	O+0tLvACQoIy8bvX32B4etin27421S5KA1BmeAVysmqmLIZ08EIOXcRnAWnNeEmaAk1YJG
	luANOMqUL0leUZ6k0e3wpeDoQTimuGU/zFyQJWhfKe1jRLjRemsg+LgDFs1hgg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699461306; a=rsa-sha256;
	cv=none;
	b=lMGOR5bv3CMGZtXzAL/PLetGRjzeDUuXqlnSicQUu9MphBn3six9x2FW+anl/QjDZaAgDA
	gPc3MFOa54nw+hEZnXGS7b23/D3QXYDrKc+ReTjAJcXt1g9UOXM8KKbqdMZCArSQIZ2y2h
	PiFDYzllQBehZRoiGnnIDlJUwmvX5erMYO0cl4NduPnRJ1HhTBU4t7xzYiAH59orWDnPXR
	ninypOWi+hInk/Q+6ggHAIxG68d2r7fjVNSBnQfQn7xBukyuq79URuufDnWHXu8FKucse7
	M4VbiJ1nYDiZCqfUJX6/R3nPQQdRPbMeVwKxY8Ih9UgJZ4S4uvbiRG4NHuv+/w==
From: Paulo Alcantara <pc@manguebit.com>
To: nspmangalore@gmail.com, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting
 multichannel
In-Reply-To: <20231030110020.45627-12-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-12-sprasad@microsoft.com>
Date: Wed, 08 Nov 2023 13:35:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> When a server stops supporting multichannel, we will
> keep attempting reconnects to the secondary channels today.
> Avoid this by freeing extra channels when negotiate
> returns no multichannel support.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h  |  1 +
>  fs/smb/client/cifsproto.h |  2 ++
>  fs/smb/client/connect.c   | 10 ++++++
>  fs/smb/client/sess.c      | 64 ++++++++++++++++++++++++++++++-----
>  fs/smb/client/smb2pdu.c   | 70 ++++++++++++++++++++++++++++++++++++++-
>  fs/smb/client/transport.c |  2 +-
>  6 files changed, 139 insertions(+), 10 deletions(-)

Several reconnect tests are triggering this when running against
for-next branch

[  360.487827] dftest>> [*] mount opts: vers=3.1.1,echo_interval=10,nohandlecache,noserverino
[  361.570676] dftest>> [*] mount opts: vers=3.1.1,echo_interval=10,nohandlecache,noserverino
[  361.572133] dftest>> [*] TEST: mount //gandalf.test/dfstest3 , cd /mnt/dfs/link , ls ., expect:["target\d_file" "tsub"]
[  361.572133]       disconnect /mnt/dfs/link , ls#1 . (fail here is ok),  ls#2 (fail here NOT ok)
[  361.613964] CIFS: Attempting to mount //gandalf.test/dfstest3
[  361.637663] virtio_net virtio1 enp1s0: entered promiscuous mode
[  362.262990] CIFS: Attempting to mount //gandalf.test/dfstest3/link
[  362.483166] ls (978) used greatest stack depth: 21904 bytes left
[  398.362399] CIFS: VFS: \\w22-root2.gandalf.test has not responded in 30 seconds. Reconnecting...
[  398.364632] BUG: sleeping function called from invalid context at kernel/workqueue.c:3344
[  398.366399] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 981, name: cifsd
[  398.367318] preempt_count: 1, expected: 0
[  398.367826] RCU nest depth: 0, expected: 0
[  398.368414] 1 lock held by cifsd/981:
[  398.368905]  #0: ffffffffc028fb58 (&cifs_tcp_ses_lock){+.+.}-{2:2}, at: cifs_mark_tcp_ses_conns_for_reconnect+0x5f/0x3b0 [cifs]
[  398.371053] CPU: 3 PID: 981 Comm: cifsd Not tainted 6.6.0 #1
[  398.371720] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[  398.373072] Call Trace:
[  398.373404]  <TASK>
[  398.373700]  dump_stack_lvl+0x64/0x80
[  398.374188]  __might_resched+0x23c/0x360
[  398.374708]  ? __pfx___might_resched+0x10/0x10
[  398.375188]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.375688]  ? __might_sleep+0x2b/0xb0
[  398.376086]  ? __flush_work+0xc5/0x640
[  398.376539]  __flush_work+0xfd/0x640
[  398.377019]  ? __flush_work+0xc5/0x640
[  398.377524]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.378155]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.378798]  ? __pfx___flush_work+0x10/0x10
[  398.379408]  ? hlock_class+0x32/0xc0
[  398.379840]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.380355]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.380959]  ? mark_held_locks+0x5d/0x90
[  398.381537]  __cancel_work_timer+0x210/0x2c0
[  398.382117]  ? __pfx___cancel_work_timer+0x10/0x10
[  398.382757]  ? do_raw_spin_trylock+0xd1/0x120
[  398.383363]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.383921]  ? do_raw_spin_unlock+0x9b/0x100
[  398.384382]  cifs_mark_tcp_ses_conns_for_reconnect+0x227/0x3b0 [cifs]
[  398.385834]  reconnect_dfs_server+0x162/0x6b0 [cifs]
[  398.387107]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.387715]  ? __mutex_unlock_slowpath+0x11e/0x400
[  398.388219]  ? __pfx___mutex_lock+0x10/0x10
[  398.388736]  ? __pfx_reconnect_dfs_server+0x10/0x10 [cifs]
[  398.390057]  ? __pfx____ratelimit+0x10/0x10
[  398.390637]  cifs_readv_from_socket+0x335/0x490 [cifs]
[  398.391898]  ? __pfx_cifs_readv_from_socket+0x10/0x10 [cifs]
[  398.393084]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.393730]  cifs_read_from_socket+0xb5/0x100 [cifs]
[  398.394985]  ? __pfx_cifs_read_from_socket+0x10/0x10 [cifs]
[  398.396176]  ? __pfx_mempool_alloc+0x10/0x10
[  398.396734]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.397386]  ? cifs_small_buf_get+0x53/0x70 [cifs]
[  398.398619]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.399245]  ? allocate_buffers+0xa7/0x1d0 [cifs]
[  398.400294]  cifs_demultiplex_thread+0x274/0x1270 [cifs]
[  398.401346]  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
[  398.402680]  ? __pfx_lock_release+0x10/0x10
[  398.403053]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.403464]  ? mark_held_locks+0x1a/0x90
[  398.403813]  ? lockdep_hardirqs_on_prepare+0x136/0x210
[  398.404250]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.404663]  ? srso_alias_return_thunk+0x5/0xfbef5
[  398.405079]  ? __kthread_parkme+0xce/0xf0
[  398.405433]  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
[  398.406293]  kthread+0x18d/0x1d0
[  398.406582]  ? kthread+0xdb/0x1d0
[  398.406885]  ? __pfx_kthread+0x10/0x10
[  398.407237]  ret_from_fork+0x34/0x60
[  398.407551]  ? __pfx_kthread+0x10/0x10
[  398.407881]  ret_from_fork_asm+0x1b/0x30
[  398.408258]  </TASK>
