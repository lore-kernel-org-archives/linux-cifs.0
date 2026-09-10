Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF6EECB
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 00:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998630; cv=none; b=XTU5v+/WowuDW1tUixxYAHM6HQWJHFEC82lt6DzgfQE4OId3L5pFHTgMhbg3ZneCxleqjDZWeX2SznqSVzuNdWogKNlgwepfJz5qUcWi+x9nT/QrHFeqpvtRdUwnlBnqtjgaQJVeLKhfbLJ7rnAIRw57/IHibvVaWoLlZtj40Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998630; c=relaxed/simple;
	bh=wwbvYibn2RccE5Ilgg933DmJhdHLfcjxQUDmlgX/O1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frYI4Oob5IvHhvTFzsyjMC3yrYnEjkokTJvaPO+Gc8MEqDpkyqHOa2UNlM53FulKBrzqpIhFNO9fum7OHFjwcUSsslSy8/XnT2aj9kG/0bKf+UEvWYYKx5VudoUwhNGyxwyOjWy2OJBtO4ffTir5H8vzGuCUxBaNLvRCaZCWn/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrkNFq7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrkNFq7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EA11F00893
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 00:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788998628;
	bh=oie1+baSZzELU5TqCD5wNmjBfLHTRw8hbmkITrTpj8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XrkNFq7QXuSdEPh756szHFuGshyhiZ580YYhm6O2/QSSe8PdJFYLgaENuL/aXwCER
	 +ZbxsvIQuCcJbBWsJSIN84DL4DnlcCG9rwgLAsC7mIQo/fQzxn1geHc7TyA+nlwy9C
	 oz573pnWd2eTfBkAPFxGDboMpQrKKJFTjgJES2sCo4lle4r3m8RU1XC/P/8hudyy4y
	 chK/lkuwPzBQTv1YDl/Afc/LKHV1/oBLVkvHg9guqb/l3wMGP8FvTMuVdHp/uuq3gn
	 RAZXIshe65WJ0mHlSlHz9Y8hiFEOJgfkrBqssZp6+reOVC7KZbfW0pqJPn1rJ/CbJs
	 8U+DTqzxq4+hw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1fso255789466b.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2026 17:03:48 -0700 (PDT)
X-Gm-Message-State: AFuF++kOjmD2/JqJBDMD5Bxao5y1iZgTFO74NKE6p9SWGI/hMkDMtl59
	8oJxKiD1Lj0WUKOLw9AN3NbT+ENugbuZxlwq6EfDIyDOXUrCwvv2gJ5zO/bn1j4fbyIIr5WCpyV
	2gY15+G7VMLlgWRfINVK9MN66BrQVJ1E=
X-Received: by 2002:a17:907:3f0e:b0:c29:1133:e16c with SMTP id
 a640c23a62f3a-c292af1d823mr672277966b.9.1788998627519; Wed, 09 Sep 2026
 17:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909230748.1226168-1-pc@manguebit.org>
In-Reply-To: <20260909230748.1226168-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 10 Sep 2026 09:03:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9iAwV732fGUOEBt7Ys8tF7vFrXoVrcEScjKP1FNTNcdA@mail.gmail.com>
X-Gm-Features: AcwNN1WiTz85ZAx_qTKD9VsNWD_3r2GuwK2WQJIn5pawyGdHPqG0uVcHrzWY94M
Message-ID: <CAKYAXd9iAwV732fGUOEBt7Ys8tF7vFrXoVrcEScjKP1FNTNcdA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix one-byte OOB read in smb2_parse_native_symlink()
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>, 
	Pali Rohar <pali@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 8:07=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
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
>
> Reported-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
> Fixes: 723f4ef90452 ("cifs: Fix parsing native symlinks relative to the e=
xport")
> Suggested-by: Pali Rohar <pali@kernel.org>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
