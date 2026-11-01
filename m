Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498541;
	b=31z9LiJlfd54v/b/u3FyVvdV5J7D2/mYcRxdbqjCZN7TYNH1uvt/2Fn3+klOvfsz1viw
	 gSw5Wep9Y6czcaJsadXN0rq+Ha91CrOV4b6O/HoYaspcRejT5Ld+Om3tTgpdMQiMUTLSw
	 M84GcaHGhWs+iJCVuWh4YGPMOZyex5uatrtJteyhL/CF+2i6iVqy5rUzw3/noLLG0zFGu
	 xn9K+l6hTQnUtiZgUJ5W1t3Ru3e8LUOT8RPZyZ//94Y73fGfT78ORM4GnbzjbLow6INTv
	 OQfi5qfczMUJT+R2r349G/7L5w9Z26QGJ20KhyymyVoXT4cm0CUPqrcBhFrhWGj5iUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498541;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3b1VjNbfffoLcu1vrfLBvJ6zv61wyRoYnEPPvNT5AxE=;
	b=KXp0Aeo35pbV8r/b90J/I+xAltdUdxLtO1trqwtsFMj42U0Ozem5A7IbKIpd+hhTGv2j
	 azwIw6jW0Vm7hSq3zGFmSpzdJNVOFHAqeGVSC67zyL1hMq3NjfX5DVw1nos3jwxQBrZxF
	 Tvj9hgmCBh8ukjdN8JjbC5wYSlekGZqp+kb317B1qsoU6vzGjjJOrqmhfZQ0d60Kf4axs
	 OwkT3M+cWN0HnmiqRax+PCHUV4ALV4gCFpZ+MiVzxbJNNUtn1mD5O8vnjw4l3fpOS8gKT
	 H/A7RqJVeCi5bMAgQQ6Xo3kJR49BvrtLmb6ZtGIrzFMuW8syDuf0zyDRSvoPPmBdA8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIgS+2bm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC3B606A325
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIgS+2bm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BEA1F00A17
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 02:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793498541;
	bh=3b1VjNbfffoLcu1vrfLBvJ6zv61wyRoYnEPPvNT5AxE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QIgS+2bmZiqCkqf7ILRaDcpd9+Hb3kaMvLR4kYt/l1SYw6zIwRa2QYsQNjq4ajGrF
	 8I2ih9I1xvgEicfziTe514s75n+jdzwLVaOZN9nGa9b7molikJ0WWdx78rugFms6Jx
	 kEqZjmS5FquFnsl6ymUbROfNwoWBLOCbbCPDceAg/T3K6SqDjsKU0uFU9hoBc3XHki
	 XjSAK1ediW+wzKZgIbMicKxcGbEhosgt3nnEK2jdmUkLfqYRbS559e2+ii2YOOcDHB
	 mx9ct+i06Lt5jvKX8TqUDqS9IOVs3pvOunnMlwImI+ZBoPKpuUcoxXIip3xaRdKl5F
	 SWyG7Gha4eBeg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso329832466b.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Oct 2026 19:02:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8wRqR2hiq36yuOEsok0ZEEcpBxIh8AFHllwOzNlw6ISP8ZEMO8/qhsJfo1gCB/Y7052fL4h22axWo@vger.kernel.org
X-Gm-Message-State: AFq9FYJrnYsgDWt2MJcsJnhDamXkICymrziFJfKbmYYT1YAXEkliEwbl
	ef7Bwe0p3Q/z1Y409osO1kanRfyUROcORlQm3y0YdnwTMpSZf8rXwHjDSQTMF7uFmiqQQlgAhj/
	MzGHb3Yl682ZfyOJh93uolwO4R/7wvRw=
X-Received: by 2002:a17:907:6e8a:b0:c3f:d912:ff8e with SMTP id
 a640c23a62f3a-c4ca7a15d8bmr490497966b.16.1793498539744; Sat, 31 Oct 2026
 19:02:19 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030213827.2216453-1-andrey.misyrov@gmail.com>
In-Reply-To: <20261030213827.2216453-1-andrey.misyrov@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 1 Nov 2026 11:02:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8+wMSXCJrZqCGewTxQ1k-RmRPfbsMm-iGvS3nQUq4Lag@mail.gmail.com>
X-Gm-Features: AclHuK94v_vMoId5LA5KD-e2xjl6J8_imqW0IJFJlWUrLqYwJv_4HzPVr4Pvkn8
Message-ID: <CAKYAXd8+wMSXCJrZqCGewTxQ1k-RmRPfbsMm-iGvS3nQUq4Lag@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix OOB write when compounding SMB2_IOCTL
 with encryption
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Steve French <stfrench@microsoft.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 6:38=E2=80=AFAM Andrey Misiurov
<andrey.misyrov@gmail.com> wrote:
>
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
>   [Left Redzone overwritten] 0xffff8a59c7790500-0xffff8a59c779053f First =
byte 0x61 instead of 0xbb
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
>
> Fixes: 90f7c100d2dd ("smb: client: fix compound alignment with encryption=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
