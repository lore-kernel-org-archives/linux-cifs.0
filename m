Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDD71FDE31
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 06:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776493645; cv=none; b=kcWvMUUV9ggvgzDvRpqV275Api+GRDNlVkJcelCwrzbOyBXTPBwhtEmdRYTxbo7SnAPTvZ6QNUWQtGnrG+08pHCCdFz1J9ipguf/CbS87tEUWuc/a8iVME/98C28RiAeoW7dzvGRb639N3+x4A2jjYc0Ar2DXFXNGivIszgTXoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776493645; c=relaxed/simple;
	bh=5TM9w5ZWH4mYmyD0uBCL9WRquWjldbq36QbHPeMcFyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIDjChQytalE7wA1Zf+Fb58EdciG8ns1W1yiUuOVzq9gn7k2sa5+ixAclXFOXRnjYC5Db+GHlnbtnvbFNqcW7ZqAWbOyYxvNWG6I6c0YeijQc6H3YmsKQrRVpOFu097zwzRJqqQj4J4NAGnf0tRW/KTc2rZrvNzrjBtqYDVlFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utPl4PdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utPl4PdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4924BC2BCB9
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 06:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776493645;
	bh=5TM9w5ZWH4mYmyD0uBCL9WRquWjldbq36QbHPeMcFyI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=utPl4PdPPXAbRHhiZgQ+1s6dAjpaRUjdqkzdbu2nyNaWMvrjchONZfbYq4/K8HgjG
	 sWxF2Mx+clYEKv6vBEXt+LEr9SXwLUAyK9ylVu2cPCM1V924Q4OD4u2sSjc2A4U8IZ
	 SI8+75/4saRjO3eJI9KGO3MyvjGB+Vxct7Zj1JOXl8lCcWob5kCmfh0NXH4k27DfCv
	 aCq1O1hUuvDGaFHOuuTjaRUnnX6U2PRyN57cmCnA6yobr+ET9TRv3k/xSDZMiirW2g
	 a2peTGr7iF5afRSMEPmOqlnu/BBNQbLEHLxEihPf2CNgNbYX2RHrBX88MUHLXlalkW
	 m52QLpAUVtfHw==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6714f678bdaso2368834a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 23:27:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Kfp6H0EHuAujx7B0OPDBDTGZ3+dNPkgWdS0kldBdmOMlsuhHqBc36lZgBLM8vFYSyJMgr0+3PPZ1M@vger.kernel.org
X-Gm-Message-State: AOJu0YyILvoDnfJoBikmfrMKQhBows/QFspzbEp3rbIahkx9J2w6fG2A
	JSG05v1lD1n3RO15tQYTQqpD85sEmlC2BmNGyrjlsVawdYbuZt8BxjGRMbypkPHW4PDA5a+SWeP
	uoB5cMTZ8pv9PyZSa4vGLuHbeFpQMrfQ=
X-Received: by 2002:aa7:d388:0:b0:670:7c64:c24d with SMTP id
 4fb4d7f45d1cf-672bfd86d7bmr1860043a12.6.1776493643764; Fri, 17 Apr 2026
 23:27:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417192036.268452-1-tristan@talencesecurity.com> <20260417193317.315698-1-tristan@talencesecurity.com>
In-Reply-To: <20260417193317.315698-1-tristan@talencesecurity.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Apr 2026 15:27:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-v03Tq_qjnDz-e3N8_S+rwxxnp5nucTriQ0DQLXHbRtg@mail.gmail.com>
X-Gm-Features: AQROBzAYErow6xVrOZcyiMd-RnTYn03NP56HDBzGDq16YhGLX9m2x2YPRuGaUZQ
Message-ID: <CAKYAXd-v03Tq_qjnDz-e3N8_S+rwxxnp5nucTriQ0DQLXHbRtg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
To: Tristan Madani <tristmd@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org, 
	Tristan Madani <tristan@talencesecurity.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 4:33=E2=80=AFAM Tristan Madani <tristmd@gmail.com> =
wrote:
>
> smb2_get_ea() applies 4-byte alignment padding via memset() after
> writing each EA entry. The bounds check on buf_free_len is performed
> before the value memcpy, but the alignment memset fires unconditionally
> afterward with no check on remaining space.
>
> When the EA value exactly fills the remaining buffer (buf_free_len =3D=3D=
 0
> after value subtraction), the alignment memset writes 1-3 NUL bytes
> past the buf_free_len boundary. In compound requests where the response
> buffer is shared across commands, the first command (e.g., READ) can
> consume most of the buffer, leaving a tight remainder for the QUERY_INFO
> EA response. The alignment memset then overwrites past the physical
> kvmalloc allocation into adjacent kernel heap memory.
>
> Add a bounds check before the alignment memset to ensure buf_free_len
> can accommodate the padding bytes.
>
> This is the same bug pattern fixed by commit beef2634f81f ("ksmbd: fix
> potencial OOB in get_file_all_info() for compound requests") and
> commit fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound
> requests"), both of which added bounds checks before unconditional
> writes in QUERY_INFO response handlers.
>
> Cc: stable@vger.kernel.org
> Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Applied it to #ksmbd-for-next-next.
Thanks!
