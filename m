Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB1F38E5FE
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 00:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787099979; cv=none; b=YLfDaTIsJLrvhCDg9fG/o0LCBWud6A5SYtFuyRiRtR5aE2oyjMUa8gx8EVLgT7JV6TUulwveUB9/fj3NA/vx6Z+kjLJLkaf+zi7xaRSCcz8ZJN4uibRURXQg18HWclqs1zLvz9nVWKloZ6pLY+AQKB0McU3x+f2Dfan//pX0SDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787099979; c=relaxed/simple;
	bh=tSxR5kHRd8n8XSY7BZKKx/QVlOWWrv8xOCxQUHDSa3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q0JuUOo6TVs/Z3lr0EVqjEewuAw5uegiYbo27RyXClSdc9L6YJ5JOeLBqgoUrjR6shZi6cVM3FkPLFWSErTDKpn1hhceHpaffMMa6w316CijOF+y4u6Wlx6vc2y/LezPSUquLqR5aYDu44n63m7oumLMOqtTG1cnTt9E9txd164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfcBuR5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfcBuR5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6E71F00A3D
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 00:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787099975;
	bh=Puu9lK7xaqmySHa1E2CG6QwbIFGSaM87GP+rVqy5zRQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cfcBuR5otDF7sHHK/hnF2tsr1qzbBYFaSnKfAVF59fUckCVIdeCspFuEZu7IwgpBM
	 IHNSG+me1oUr6OrbNQwHMTSWIffA8/TmYlcEVugPMx8gqwzzh6mO78zKOVU0IO+g4x
	 AWC0UpsCmaQ4iLuvNkU2o51EjxV8JKj2OoMTkpcnp5fHo42pxIzR2xBAMl+m8cHVxc
	 Y4MUGEuVxvEpYQJAZw5lI7HN9QzM2y+Z+TOzAdQnEanNujajTvCBRx9yHo/qDG+GXQ
	 bCzRiE40iIVodplN89cvJ0NUleqQaotIXdcF27hap+1kpj6fGN1A6om93zn4u0thF9
	 AZbU2BcQFShPA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so863133a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 17:39:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpidk9RX0zVk6Kn8c2tQdvWgOF951kbBXN8zlMQOuwA+JjmVzANdcVBZkrj3KapV8nhM1pzNwL2CRB3@vger.kernel.org
X-Gm-Message-State: AOJu0YyW5t1Ow1iSfeGDceTN4MkpdE/ImcGGUAnJ7beeXSEP1dnPV9x4
	lXpGhD2Mbk2A3T8uYCq2EtpRB5UcktxCssteYrCTXObC1Lzg+4sbqnvpLG/zDcz/ECASS6AhM5p
	aDNoVU9a+ZmAQO2vrOEnwBTH3B+T4YPc=
X-Received: by 2002:a17:907:7b96:b0:c19:45df:1856 with SMTP id
 a640c23a62f3a-c242e249bc0mr28803466b.17.1787099973913; Tue, 18 Aug 2026
 17:39:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818032335.10643-1-2122295973@qq.com> <tencent_D1F4F4FAB2A78B707B1EE2B1A718A4BE2F07@qq.com>
In-Reply-To: <tencent_D1F4F4FAB2A78B707B1EE2B1A718A4BE2F07@qq.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 19 Aug 2026 09:39:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_6NEWvKAT-j5=3MFh=eT9AuL6vL-Q6HUf2ZMjEjk11OQ@mail.gmail.com>
X-Gm-Features: AcwNN1WIY0tSdl8ZR8OOIFg4dr8kJX_J6VCKgV2boz4qLYKxTKeSC100awMRaZc
Message-ID: <CAKYAXd_6NEWvKAT-j5=3MFh=eT9AuL6vL-Q6HUf2ZMjEjk11OQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] ksmbd: add KUnit test for the DACL walk boundary
To: Hang Nan <2122295973@qq.com>
Cc: smfrench@gmail.com, tom@talpey.com, senozhatsky@chromium.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
> index 08d8b7a965a6..463fa19819b2 100644
> --- a/fs/smb/server/Kconfig
> +++ b/fs/smb/server/Kconfig
> @@ -72,3 +72,18 @@ config SMB_SERVER_KERBEROS5
>         bool "Support for Kerberos 5"
>         depends on SMB_SERVER
>         default y
> +
> +config SMB_SERVER_KUNIT_TESTS
> +       tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
> +       depends on SMB_SERVER && SMB_KUNIT_TESTS && TMPFS_XATTR
> +       default SMB_KUNIT_TESTS
> +
> +       help
> +         KUnit tests for ksmbd server helpers such as the DACL access
> +         check in smb_check_perm_dacl().  The tests use crafted security
> +         descriptors stored in tmpfs NTACL xattrs to exercise the real
> +         permission-checking path.  This option is only useful for kernel
> +         developers; enable it together with CONFIG_SMB_KUNIT_TESTS.
The help text is currently tied to this particular test and its tmpfs
NTACL implementation. Since SMB_SERVER_KUNIT_TESTS may cover more
server tests in the future, please keep the description more generic.
Also, SMB_KUNIT_TESTS is already listed in the dependency, so it does
not need to be mentioned separately in the help text.
> +
> +         For more information on KUnit and unit tests in the kernel,
> +         please read Documentation/dev-tools/kunit/index.rst.
> diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
> index a3e9306055e8..62228679fc9a 100644
> --- a/fs/smb/server/Makefile
> +++ b/fs/smb/server/Makefile
> @@ -19,3 +19,4 @@ $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c
>
>  ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
>  ksmbd-$(CONFIG_PROC_FS) += proc.o
> +obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += smbacl_test.o
> diff --git a/fs/smb/server/smbacl_test.c b/fs/smb/server/smbacl_test.c
Also, could the test be moved under fs/smb/server/tests/, for example:

        fs/smb/server/tests/smbacl_kunit.c

with a tests/Kconfig and tests/Makefile. This follows the usual KUnit
layout and will make it easier to add more server-side tests later.
These are not functional issues, but it seems worthwhile to get the
layout right while adding the first test.
Thanks!
