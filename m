Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BA02D2488
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 12:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770034780; cv=none; b=mkv6KpPlckgCF85QFksYk8MiyJajKmsxNbTyYaPqsjhlKwtz7zdcFSQzYlEikjemgc+YcckBRoh2AIzaF3RzdqOSQ+pnTtDxTC6mIlwKQgnnMHeK4sIjv6xfdRQHo0xrKOCg0J9HvaRO3Yy/SUlE8MNXzTlumfI+FDMLQaDx7+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770034780; c=relaxed/simple;
	bh=Ql/vIBgH6hdKbJr63AlkJ6k7vQw5WXH5XmC2yX7CTLw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MRvk4OuafjPtdHx+XralGNrz9Bpv4ddKtUeexlcs5jTsMFXi9ULec+akPkOWCik9WZEJthl+9R5/QpJjCCSi5GsvsrhcyWkLr6m0z9DKSh/XY1yWFn7oOLsoLLGevIyztamHM8Dbn2dgVXl1PxSen4cuhuUNwyy111NW6tsb3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=azsu6xOP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="azsu6xOP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7wZt4/Ai8P37YICe+qjKpgPRKmTVgnGNoAIuREn/HJA=; b=azsu6xOPGeo3gRzO8cYuIcwx93
	qhgj11dyJqFLKd70crr4OCDW4QQ8VRXIOAEcJAEBHwwf73L+3164eKVL0pLBsOiQySrRYW1QkGH1j
	b2PVnJcjP74Di8fBkIBxKJEZuQntHQNUq/SwFzI1h4XDlZGDhyyC7jVSKhRKMFNLwefWYzu5RKuEd
	+aXojWj5DayhHEfupbQip5TH6gXp1HDkZSA4IKJoF7/GQ2GjHQFQ/30H12UqPpBgXDYdZMgeP7Emy
	eOn4JWhrYI0Or38pxVoriUpnA/fUts/CL9USZniroi43Ouqab9f62nYFCr8pPKzfLK3aJFUwzum9I
	RLfekFNw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vmsu0-00000001UV1-2Wqj;
	Mon, 02 Feb 2026 09:19:36 -0300
Message-ID: <937b1d368866b9327410af890756ff08@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: chenxiaosong.chenxiaosong@linux.dev, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, nspmangalore@gmail.com, henrique.carvalho@suse.com,
 meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, pali@kernel.org
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/client: fix memory leak in smb2_open_file()
In-Reply-To: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
Date: Mon, 02 Feb 2026 09:19:36 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

chenxiaosong.chenxiaosong@linux.dev writes:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. On server, set the permissions of the shared directory to read-only
>   2. mount -t cifs //${server_ip}/export /mnt
>   4. dd if=/dev/zero of=/mnt/file bs=512 count=1000 oflag=direct
>   5. umount /mnt
>   6. sleep 1
>   7. modprobe -r cifs
>
> The error message is as follows:
>
>   =============================================================================
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shutdown()
>   -----------------------------------------------------------------------------
>
>   Object 0x00000000d47521be @offset=14336
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: modprobe/1577
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x94/0x190
>    cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>    cleanup_module+0x4e/0x540 [cifs]
>    __se_sys_delete_module+0x278/0x400
>    __x64_sys_delete_module+0x5f/0x70
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x89/0x350
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when called from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#0: modprobe/1577
>
> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES")
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2file.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
