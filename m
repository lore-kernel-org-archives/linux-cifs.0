Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794074659;
	b=I5VPI7OVgbuFUDwtxtOyRgWSjO7Y68bGLcCNKCAwCYEPZhlNfwNxUDpxC1iL1ZbwWtzc
	 fD8mmZ9PgH9xIrD6LOCUzi+tZkvXKfgHtILnGs513BRvlR0U+le9GH+6uA1ASqfH0rh2/
	 fv2DQYNDqnYwCl9kj6JcyMGO+2m/svM1jAVl4nNw50PnTq6Ub0Lsp0MRV2L7FxlxlEIdf
	 4/wwrT8oM3TNaGvtEu0Ma/y4t9EC9197tY32JWL2CNe4tfpdD/sVzoNg+xN3szEE0eQOQ
	 Q4CsTcjMohg9cT4Hi7CjaapBmlsUiuZtEuqkXFdBdCLceS7uNY4rxOVN+uS/nExkQpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794074659;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=hdsVF3wRllbgTsrjk576K0X32tICTvbqh3EyFm4AKF0=;
	b=Jxw4xcPu15UPHuAkvTL479VvNK6vZAsS7ab5OIgq3T3q1giHa80RmCD2eGJvjlIL/ZjG
	 gKGrVdViEQOXNo7fQjqzM3fRK6ORAzgUY0s3nKC5UL337b1IGr2YRYHXq5wTZnVS0eXRo
	 uKuhGHwLMigMSnypao7T/UmM7xi02gmp2Lxlpkt5R8m5OAWeR+qfs7e2/j7ASkNXC/Leq
	 0KysJsPCYzp7EneAsb/g6XHvg61x/tihAHIQn3K+O7UBYZ/GggYDx268JGgwQFxtPLF+z
	 q8hd/9392ObMYAvs6Sb8d+F6MaUluh2LAfcZR/0fFVelORB9DneDWazApOv4nzMCdkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=mDO8nJcM;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43562606A326;
	Sat,  7 Nov 2026 18:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43562606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=mDO8nJcM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hdsVF3wRllbgTsrjk576K0X32tICTvbqh3EyFm4AKF0=; b=mDO8nJcMrYS89GOecvJEVnXtPB
	QwORuhAVl/cACZuSARDqXrzTKV2KK3tCZ9zEuizaEYAoAZPdiJ2hWjS0KdL9Wp1H8JBvqUhQaxg4V
	os+bq5iPHvCtB3QNFhAoM1hJc17haYDZrYGcuNL0FFcTfbvrqFxPnMmgLX9ixKD6FDrGpPBQ5P+6/
	G9+uJXWIZVZ9Phl1hMpyBoP0q+pJnaL3b7BtejfCa1v+l4HGxS0gnFD+nO/msqOkcz2dyIaRvVgy/
	Nn8IK9GRZNBt+UKA7vcn/ZL1fHeLaTkqf8JeM/dz3iocn/OD6ydkzJG99OOi1+PkMSQvc65N1bHfs
	V3O8aqKQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPkm0-000000017yM-04WV;
	Sat, 07 Nov 2026 15:04:17 -0300
Message-ID: <14e62e2c2cf3e910a5d86fdd465d9e4f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Andrey Misiurov <andrey.misyrov@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>, Henrique Carvalho
 <henrique.carvalho@suse.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrey Misiurov <andrey.misyrov@gmail.com>
Subject: Re: [PATCH] smb: client: fix OOB write when compounding SMB2_IOCTL
 with encryption
In-Reply-To: <20261030213827.2216453-1-andrey.misyrov@gmail.com>
References: <20261030213827.2216453-1-andrey.misyrov@gmail.com>
Date: Sat, 07 Nov 2026 15:04:16 -0300
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

Andrey Misiurov <andrey.misyrov@gmail.com> writes:

> On an encrypted ("seal") mount, SMB2_ioctl_init() keeps the IOCTL input
> in a separate iov (iov[1]); iov[0] is a 448-byte buffer from
> cifs_small_buf_get().  When such an IOCTL is not the last request of a
> compound, smb2_set_next_command() pads it for alignment by copying the
> whole request into iov[0].  A large enough input overflows that 448-byte
> buffer and corrupts the slab; the copy also sets rq_nvec to 1, so the
> input buffer is leaked too.
>
> An unprivileged user can trigger it by creating a symlink with a long
> target on such a mount: the native symlink is sent as
> FSCTL_SET_REPARSE_POINT + QUERY_INFO + CLOSE in one compound, so the
> IOCTL is not the last request.
>
> With slub_debug red zones on the cifs_small_rq cache, the overflow is
> caught on the next allocation from that cache in the same compound (the
> 0x61 bytes are the 'a' characters of the symlink target):
>
>   BUG cifs_small_rq (Not tainted): Object corrupt
>   [Left Redzone overwritten] 0xffff8a59c7790500-0xffff8a59c779053f First byte 0x61 instead of 0xbb
>   Call Trace:
>    check_object+0x1a8/0x350
>    alloc_debug_processing+0xab/0x110
>    ___slab_alloc+0x7e/0x2f0
>    kmem_cache_alloc_noprof+0x28d/0x4b0
>    mempool_alloc_slab+0x16/0x30
>    cifs_small_buf_get+0x1a/0x30 [cifs]
>    SMB2_close_init+0x8a/0x100 [cifs]
>    smb2_compound_op+0x2571/0x2b50 [cifs]
>    smb2_create_reparse_inode+0x27e/0x490 [cifs]
>    mknod_nfs+0x1ce/0x2e0 [cifs]
>    create_reparse_symlink+0x119/0x180 [cifs]
>    cifs_symlink+0x19f/0x8e0 [cifs]
>    vfs_symlink+0xa3/0x1b0
>    __x64_sys_symlink+0x41/0x70
>
> Pad the input to a multiple of 8 bytes when encryption is required.  The
> request is then already aligned and smb2_set_next_command() no longer
> copies it; InputCount still carries the real length.
> ...

Applied.
