Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B1341068;
	Thu, 10 Sep 2026 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049684; cv=none; b=SKteSJm8eIKDi56L2Zt1HpSfnYav4mDIWSohUgTvhNhbeoSyZ4NCbywuhKM1jwMfcLlkXQvTiMmtXgrOA9nqKrjUINjuM0pzou7LCisEpSjrf21QqcCjMAR4qL/ovwDHghmtPT1vxCFZEM5X9uSCQ+CZgy/YRhygPtsf5HZBjXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049684; c=relaxed/simple;
	bh=8odRz4n4VgiTQHHIx1K/AVnMHcqYY/ae1HoVUyy6QtE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=TSm4Ixr6mZYXuf/Wv71m71kxnc1k166oVDsACTL3V7Q1F67LIUJnVMkOisv/JM8+VJ+Jl4T/Fzl2LPh96J839X2ABT0CvHdgpQfySRqss2Kjoe65KuwVUZbz9dVsAXXQg31Geah9onvZShpgLq8UU9g2iZGl4GrtQqHfk9HCiRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=uocRacO0; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="uocRacO0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kIWQyuPhziZdEFcftncrQD98qtLPLGba+f0do/MFyWs=; b=uocRacO0iWyxvaK29kJuo5wY/m
	TS4UfNzz3GLMhHT6g1CwNTg0wc09b1oGEOC0hY7BO+E5WB+/moQ94vTCT0FkbHqwrtpJ8uJvoyWEh
	2U/4Bnx8cR9m3JuYnAM12eoeq3XuppNNbyIdw9kx6b0DLsqI7ArpKyQEqdcBR0PCA2YZP4ilulWWF
	r7NcmIHKnPJ6ifCoKD5fOFIrnUwBIUFWvLesPiXQFEAKUcajAEREaBLcSP+ysr8aZkoA+zWglj5gN
	aWobd5ZG3Zcrd2GqJx9+CLMEvcIQs1WB/1qpEsUOQ3bCUlpWuKlYTDio189BSZmZSfYgnVGtYIhof
	BJTcQdrA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4fXv-0000000182C-0cFq;
	Thu, 10 Sep 2026 11:14:35 -0300
Message-ID: <d99c2b25ef6a34a2a9301e19f5f8fe0d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>, Pali Rohar <pali@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix one-byte OOB read in
 smb2_parse_native_symlink()
In-Reply-To: <20260909230748.1226168-1-pc@manguebit.org>
References: <20260909230748.1226168-1-pc@manguebit.org>
Date: Thu, 10 Sep 2026 11:14:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> When parsing a share-root relative native symlink, memcpy copies
> smb_target+1 (skipping the leading separator) but uses
> strlen(smb_target)+1 as the length, reading one byte past the
> allocated buffer.
>
> This fixes the following KASAN splat when accessing an SMB symlink
> with a target of '\a\b':
>
>   BUG: KASAN: slab-out-of-bounds in smb2_parse_native_symlink+0x4f5/0xca0
>   Read of size 5 at addr ffff88800878fe21 by task netfsfuzz-execu/1
>   CPU: 1 UID: 0 PID: 1 Comm: netfsfuzz-execu Tainted: G N
>   7.2.0-11943-g2709dd5ae32f-dirty #1 PREEMPT(lazy)
>   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
>   1996)
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x7b/0xa0
>    print_report+0xd0/0x630
>    kasan_report+0xe5/0x120
>    kasan_check_range+0x105/0x1b0
>    __asan_memcpy+0x23/0x60
>    smb2_parse_native_symlink+0x4f5/0xca0
>    parse_reparse_point+0x68a/0x1530
>    reparse_info_to_fattr+0x752/0xa20
>    cifs_get_fattr+0x873/0x15b0
>    cifs_get_inode_info+0xc0/0x310
>    cifs_lookup+0x308/0xa70
>    __lookup_slow+0x122/0x2b0
>    lookup_slow+0x50/0x70
>    path_lookupat+0x525/0xaf0
>    filename_lookup+0x1f2/0x550
>    vfs_statx+0xd1/0x1a0
>    vfs_fstatat+0x65/0xc0
>    __do_sys_newfstatat+0x9a/0x120
>    do_syscall_64+0xdd/0x4a0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ...

Applied.
