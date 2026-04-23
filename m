Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B7E1ACEDF
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 00:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776904156; cv=none; b=NWIVmF+h63m30XhT33aeQfo0D36d74lIWiFL/F+iDbP2BGNKir/zbLvzVCs3aykbzPmKjE3FiZWW/iHeP1AyL3Iee4Mnfmf0fsHpwrqcdJ0EMbobQb0VuqLMheypMwhS9yb6MmxcnNk6MqEUhwPnyAheO6mnlplErCuHMdg50WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776904156; c=relaxed/simple;
	bh=OKfR/w8sEXIXWNyijWFx/otknLfPN0BVon7J3GcY8Gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Si97WXCCXXBXY3yBQECVLPUnstxtflHdPr+/uK8C4ObosUscNIpfIXQUaOvoTiVQ01kq0aQH9hJ+W47YvnoP0nM7wSrqy3soAb1MNSbDTxF0RHn2OsHrTFXP/lV2JqVFf9gKSVj246A2LRs9FtWfYS/GtXVVJkZtWvpRQzWgWYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2upG81O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2upG81O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E012C2BCB6
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 00:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776904155;
	bh=OKfR/w8sEXIXWNyijWFx/otknLfPN0BVon7J3GcY8Gg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o2upG81OI2tUED9Oix6HEnkHEEf5gFj+1t8FR39a4LZBnL5/Ddy3P5fcnoFOsVyyS
	 wMmXw4Hq2D7X+GOjatf2h7TH7AkYRIgg9aIn6Q02lOvuGu1zNejLlwtno1r4nfCFx6
	 9jyFPiTVJKS2/YXFXJPxpq6ihCxyAUZ5YYeM0FmPMvJQtQxjEqrQx40w5W5aQMCIPu
	 0xiL+sAXvwi+KqtUq7/+YsbA6YkBEC1RxaCoZBlWtT/tbnSBrRCbbf1awqKdOD0Smd
	 TTPndecC9ovN4TjQbAHcdjbKpPnelKDDKdbWr0GkmkU+zeF0Jkgb9EvrMXO8YC6m3P
	 ZwetaCbHJ0i7w==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-674a44b84fcso7637376a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 17:29:15 -0700 (PDT)
X-Gm-Message-State: AOJu0YxG5xeTeiK3qZF1dlj7T8Q49jEJzOr91EDAjNAmB0ODU9w4mwlE
	Ug1Hka9A+cFAufzkChuN1loReIgcyPsShQzCOafe8GQBfYgbjzvc0yrIJ/xEiTaoURVO4+ss7Td
	JYbSNQWYJGKERhzgJ5khw6NjzXbCroFI=
X-Received: by 2002:a05:6402:3586:b0:676:6eaf:52be with SMTP id
 4fb4d7f45d1cf-6766eaf5d05mr5839938a12.13.1776904154214; Wed, 22 Apr 2026
 17:29:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422105010.2600337-2-mmakassikis@freebox.fr>
In-Reply-To: <20260422105010.2600337-2-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Apr 2026 09:29:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FRpqjTcxbBsLcZATT9GmGmVF-g8JkF_9dwretGA0rpA@mail.gmail.com>
X-Gm-Features: AQROBzAloIY78uD5qdQ5GpKGAG-IO6O2O1q34EszYl7bD-yggtw1OfAu-_Rko40
Message-ID: <CAKYAXd_FRpqjTcxbBsLcZATT9GmGmVF-g8JkF_9dwretGA0rpA@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: zero buffer before filling file entry
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 7:50=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> this ensures there is no stale data in padding area between entries
> when processing SMB2_QUERY_DIRECTORY request.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/smb2pdu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 07782f7205dc..b55bef96d94b 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3962,6 +3962,7 @@ static int smb2_populate_readdir_entry(struct ksmbd=
_conn *conn, int info_level,
>                 rc =3D -ENOSPC;
>                 goto free_conv_name;
>         }
> +       memset(d_info->wptr, 0, next_entry_offset);
The response buffer is allocated with kvzalloc(). Could it be a
duplicate initialization?
Thanks!
