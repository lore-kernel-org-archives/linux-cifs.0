Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951989;
	b=r1qMnhtCbfIr3M6H8rrrVfzbqh406BBjx++sm35PNttXRbQvFTnfS8+87KIaBjhMNEck
	 /E/p98g+8+ngrhr0rCOPlOicKgkfQXOTyJqlZtVPpvv/zLuwb4isODn0yNO50vYhxh+VZ
	 IVkoWMPdQfGPqGpqJZcajEhbepe+iX23wFgmMfHEpl2N8DotJx3K0QrkFSfoufTu5hswa
	 PP6eEIUVkLZg3HcK/tQWK3oG1rUT77GacKTIUDU1jL+wwEor/3wQgVHPOX8AHYF25RJ5f
	 GH0R303iGEVR4FEswfYGxuylTIOXtnYy7PSWan8Gd/KVBHFZWehQxEyJN61933l378w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951989;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=Q8Zv98+e2jVnePseL4zWaBAWv9xCK5pVS+y7OI2/PEg=;
	b=iYFTIvx5yKgh9+0rOuREnvhfmva0up+PUb8ccXtOhXDtYP0rqOll1G6KVKQxR9Iw/ZZ7
	 1lBj9FGeP4rXmYSRoZc7RDmzgLM9dO71QIryccx30UXDlVVi+x/r2/i8iqzDtg+PpZc3M
	 L2QpXg92/Joo5lKtsRtUjG6VdBs5ndZGXKAWR8qynWGkxfVszj54jXv4MEjKDDK8ZoXSl
	 r8c4f/PIJSvLKq6BPaU1cLcfa8arMY/Ch5ld6bEav8ZGeclwgHbVENjpZpuzR7ShpbmX0
	 8iF1Q6uOSNaemzg8WUOYm6rk0PgETlFt1Z4w5+16FLxSH5oEcRqdfN4SlsQBCt/nHgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tr+5s3m3;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C344C606A31A;
	Sun, 25 Oct 2026 18:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C344C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tr+5s3m3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q8Zv98+e2jVnePseL4zWaBAWv9xCK5pVS+y7OI2/PEg=; b=tr+5s3m3IR5sjFTWo3ROtOjdBl
	RQi5TeRZ9XeRs3MRYdTmnpni9um1PZdOqR/joRv6YMdFgCvlCrBQ+VZ7+yZtSZcDFCxgwM//0NKja
	+kAA5sso5at7GqzdqvLxlWTOlm0jLQNK5z8wF6w3jzT4h87XQXm2mCoqvt62DQPc82lussvGpVPnP
	eTAJ5yngfwSm4vkCzOgUzsfhyBsrCKimhZZ6yWhdbfVajh3CaIuwxTgmMcjAMqDB/nJB8EMW/a5y+
	1xZV9wdThLrouo2tHuRodGV3ONqiPowguND32xz8H0Nnmui/APJqXO/44s60je2h8s55Olx3UVO2S
	JG04jwyw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xL2iP-000000000Fd-03iE;
	Sun, 25 Oct 2026 15:13:06 -0300
Message-ID: <384d3d0e29fe24571b92099ddfc05944@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH] smb: client: fix early procfs exposure race
In-Reply-To: <20261022215506.31619-1-fredric.cover.lkernel@gmail.com>
References: <20261022215506.31619-1-fredric.cover.lkernel@gmail.com>
Date: Sun, 25 Oct 2026 15:13:05 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> Currently, init_cifs() calls cifs_proc_init() near the beginning of
> the function, before INIT_LIST_HEAD, leading to a momentarily
> uninitialized, but exposed, procfs. If a userspace process reads this
> empty procfs, iterating over a zeroed list_head leads to a NULL
> pointer dereference and a kernel oops/panic.
>
> For example, if a delay is added between cifs_proc_init() and
> INIT_LIST_HEAD, and a userspace process is polling
> /proc/fs/cifs/DebugData, the following oops occurs:
>
> BUG: kernel NULL pointer dereference, address: 0000000000000608
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] SMP PTI
> CPU: 0 UID: 0 PID: 3477 Comm: cat Not tainted 7.3.0-02212-g4df4d2a577db-dirty #6 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2025.11-3ubuntu7.3 09/23/2026
> RIP: 0010:cifs_debug_data_proc_show+0x103/0xd80 [cifs]
> Code: 00 31 d2 eb 25 48 89 df 48 c7 c6 4b d4 67 c0 e8 a3 12 f5 cb 48 8b 54 24 28 48 8b 6d 00 48 81 fd 28 3b 60 c0 0f 84 34 0c 00 00 <48> 83 bd 08 06 00 00 00 75 e5 ff c2 48 8b
> 4d 38 48 89 df 48 c7 c6
> RSP: 0018:ffffb603c03c7c38 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff950240d3f2a0 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffffc0672ab7 RDI: ffffffffc0603ad8
> RBP: 0000000000000000 R08: 737265767265530a R09: 203a737265767265
> R10: 6552205346562065 R11: 203a737473657571 R12: 0000000000000000
> R13: ffffb603c03c7d68 R14: ffff950240d3f2a0 R15: 0000000000000001
> FS:  00007fdae19d9b00(0000) GS:ffff95032d4bb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000608 CR3: 000000010638e001 CR4: 0000000000370ef0
> Call Trace:
> <TASK>
>  ? seq_read_iter+0x86/0x400
>  ? seq_read_iter+0x86/0x400
>  seq_read_iter+0x183/0x400
>  proc_reg_read_iter+0x62/0x90
>  copy_splice_read+0x215/0x310
>  splice_file_to_pipe+0xec/0x1c0
>  do_splice+0x4b8/0x780
>  __se_sys_splice+0x18f/0x250
>  do_syscall_64+0x109/0x330
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> </TASK>
>
> Fix this by moving cifs_proc_init() down in init_cifs(), ensuring it runs
> only after all internal lists, locks, counters, and workqueues are fully
> ready, but before registering the filesystem. Update the error cleanup
> ladder and exit_cifs() to maintain proper LIFO order.
> ...

Applied.
