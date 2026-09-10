Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41B12E542C;
	Thu, 10 Sep 2026 00:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000065; cv=none; b=BYXJIo9eDyhYnVUK3FM1p0+bU3lSb7aa7Hi1j4jp2sEHJ9amorT4J8pIvhi08HLP6hPPlY1raOHhlglSqMqOTlh78op4immrbgY7Kb7r2HbNJ3WmQ3s1oxajtMPlt9ktyoo12EglNXii+bojsfVhr8Jlh7BnaTI+UxKNOeipI4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000065; c=relaxed/simple;
	bh=OpKqLNXILagugRrNiq5mfkEsfrXy6fePF3NRZa4/N6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jO1ebhPPr4FlUDvVVQ2tIpTkAd2ufWF1vjUKkz//6zXx3dn8nfQmA2xbpQOhcQCGHPS00O39dN1qfQvVxDcmCdCwiI4z47NkaeoCH6rTxuPJdM4q4fjbeUBmJaALMO/T1SoJn8i0+V1zgJsmPKlLy42miAw8fZgRNX0BNbxlo+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afaZ0yVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afaZ0yVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2381C1F00893;
	Thu, 10 Sep 2026 00:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000063;
	bh=M2UQADrpWgS/LsKvlQGrI7ck+NQANOw5VotsO9/eoIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afaZ0yVpbJTc2d16cO/D4f+Bhr7pjoFo1WSRDrizBGawBUFOd2VmJpx1Q0YFd6fCD
	 lyhmPiS0hSSSJZn85Yv9o9KA+Pe4zLLneoFPlPkoMBfDkXPSE+otTcQ8pc7WBSElmI
	 F4XH7GnGRFUpMHjrkqXaqRdIHz5hCikdrdpAVSOS9xkTzLZtUwITRAYeUi7a0UlwBj
	 JPL4m4tmyjunYzJrYG/S6LC4AAkBH9SLnf5AT9aKwEmssxa3tHHY66JzGDCgHwJCb8
	 ww2xMW7X6UZspyDCpolxhClYWPdvnf693oAfkF98n3tZTeNaFMtvvGfREYvGVIaw9h
	 jwzZt7sqOoLZQ==
Received: by pali.im (Postfix)
	id 823E35DE; Thu, 10 Sep 2026 02:27:44 +0200 (CEST)
Date: Thu, 10 Sep 2026 02:27:44 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix one-byte OOB read in
 smb2_parse_native_symlink()
Message-ID: <20260910002744.eyjntn4rmcxnksey@pali>
References: <20260909230748.1226168-1-pc@manguebit.org>
 <CAKYAXd9iAwV732fGUOEBt7Ys8tF7vFrXoVrcEScjKP1FNTNcdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd9iAwV732fGUOEBt7Ys8tF7vFrXoVrcEScjKP1FNTNcdA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Thursday 10 September 2026 09:03:32 Namjae Jeon wrote:
> On Thu, Sep 10, 2026 at 8:07 AM Paulo Alcantara <pc@manguebit.org> wrote:
> >
> > When parsing a share-root relative native symlink, memcpy copies
> > smb_target+1 (skipping the leading separator) but uses
> > strlen(smb_target)+1 as the length, reading one byte past the
> > allocated buffer.
> >
> > This fixes the following KASAN splat when accessing an SMB symlink
> > with a target of '\a\b':
> >
> >   BUG: KASAN: slab-out-of-bounds in smb2_parse_native_symlink+0x4f5/0xca0
> >   Read of size 5 at addr ffff88800878fe21 by task netfsfuzz-execu/1
> >   CPU: 1 UID: 0 PID: 1 Comm: netfsfuzz-execu Tainted: G N
> >   7.2.0-11943-g2709dd5ae32f-dirty #1 PREEMPT(lazy)
> >   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
> >   1996)
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x7b/0xa0
> >    print_report+0xd0/0x630
> >    kasan_report+0xe5/0x120
> >    kasan_check_range+0x105/0x1b0
> >    __asan_memcpy+0x23/0x60
> >    smb2_parse_native_symlink+0x4f5/0xca0
> >    parse_reparse_point+0x68a/0x1530
> >    reparse_info_to_fattr+0x752/0xa20
> >    cifs_get_fattr+0x873/0x15b0
> >    cifs_get_inode_info+0xc0/0x310
> >    cifs_lookup+0x308/0xa70
> >    __lookup_slow+0x122/0x2b0
> >    lookup_slow+0x50/0x70
> >    path_lookupat+0x525/0xaf0
> >    filename_lookup+0x1f2/0x550
> >    vfs_statx+0xd1/0x1a0
> >    vfs_fstatat+0x65/0xc0
> >    __do_sys_newfstatat+0x9a/0x120
> >    do_syscall_64+0xdd/0x4a0
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Reported-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
> > Fixes: 723f4ef90452 ("cifs: Fix parsing native symlinks relative to the export")
> > Suggested-by: Pali Rohar <pali@kernel.org>
> > Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> > Cc: Namjae Jeon <linkinjeon@kernel.org>
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Shyam Prasad N <sprasad@microsoft.com>
> > Cc: Tom Talpey <tom@talpey.com>
> > Cc: Bharath SM <bharathsm@microsoft.com>
> > Cc: stable@vger.kernel.org
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> Thanks!

Thank you for preparing the change!

Reviewed-by: Pali Rohár <pali@kernel.org>
