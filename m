Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AA41D5146
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 00:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777509281; cv=pass; b=B5uGZDC0cT/OeHxAQQy09p9hcm8KDTaiOnkoD9Qbr692Y2s5xNbPRj0L4d+UFfrCDeYlhI0oM2cLVRHCeAweRbhRt3uPmfx34wyV9hNVRj9OYh7dg9J61DJPQdVypROgACkVNX5IfjgsizV5DjvNzI18rTwH3EUoTfFVxtla5yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777509281; c=relaxed/simple;
	bh=Mh/rnZ/ke92Ba2K8c5PilKMb99q5DoT+BCEeNdMCB/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=logfhR38YHuuOpyQmfoZj+d6wZHcUaKHM9gSmXEnPw1/oUgYcjXpjjc0totDklZzl73bJB4tE1iYYqZbTUKzmVxSkTK/Q64pMenlaN8a3/H5gMFZBFE50DU7Up764vo6dPNad3xUpCXMhrkjwulIGLAhEZ38zQ5AOQIFczPkVnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wz3mzEK2; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wz3mzEK2"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-606045ef716so223381137.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 17:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777509278; cv=none;
        d=google.com; s=arc-20240605;
        b=OpJjiQK6XePC3oDRQwHU3hlNA6r6whIyIMkS/aHO4rM3T+WI4Xzo4rVs1m1ohES+VJ
         Dhxh2v1BC1D7ypHDITaCtrwfEXSID1HmE82voc8QJSsfmj8KY7HGZ02KM0DThg1ROUmN
         13V98u7LmlAVEQrOWTOR+DIWlRqhqDdPKVBe+RTxQFXVLemo6Xt8MjYLLj7J1NTE9RHe
         nB+K4tLXVmx4TWfxHePjJN1lvihWV14sd2AEG+TGUCAwqj9cKOfwiVXzMA2mLNtrLP/G
         Aa7se32GPb+xVbYfPElrwwqVTAVGhGxXxCM/fFOc4wseHjSf/I+8Eg9bSNgCLl8gnRju
         38fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OaJsSOetmcKyBCScmtUBe7wIzrooFlCftN+Lz2qYgxo=;
        fh=zpd5Qxu4GMPm/L3Eyz4JXfv8OAh8BlL4LZo4f7ORJY0=;
        b=aAd2chddRoOcWM7oBOvmOIvq1oYue7Wg8PUQiqkEu46GfVyQB2crYoZfyQovdV6JfV
         U/6QZlj/bnOw1GRd+mRB0i2WsgSItcuBB5hLSuYkWIC6sJdturf3715d9UMA86EQZa6G
         ksBR9fodILe2aF2TGKaLQQEdA5lXOuNx08mJEBNLsPJBb10V9IuWhcNlyuQI7ba1km8b
         +tAF7cccXoHkzSexFS46VAZiSCfyGO973WuvE5dK7xPLgbZHZ4wbufYBuLgsilLqri72
         t+TsuKQGgp7B9cFEzsI/dOuaMpmiT1BTEkkvDscLF/x5OfxoBw+5L+WZgrCyKWzV79WS
         xJuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777509278; x=1778114078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OaJsSOetmcKyBCScmtUBe7wIzrooFlCftN+Lz2qYgxo=;
        b=Wz3mzEK2ioI1qA1TuaPhj3A+jSUv2JWHGOk6jq3kWmZP4OZbJmXDI8WEQDSf2RJhg0
         HVOdUKaOIn/M980D8yDscGzDpLVpZDhHZ7x+MRYUAmyzkTZCo4OF6EiJDZVv4jqVvSnb
         1op3mCYkNupuZ/uYZKdRT/1WUDAUyJDtyOjkuX1Pj3HPuu1u2En4WIt+XFshN8mqQEnH
         oYOrljfxrVfEzYNrdbJ5F2wqlgG2jvNTDjqzGyQ85GnuYtBFBoFZG3lgbO9h5+5N8jl/
         407NTgUP5xC9KUo5UGGkH+olBWTBh6gyqvevcPKL9iqM+xHUAaS1EJf1V0FgdYTqyW3v
         EKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777509278; x=1778114078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OaJsSOetmcKyBCScmtUBe7wIzrooFlCftN+Lz2qYgxo=;
        b=jcoc+IQ3FbLN0JM5D/fZrQc/spCk+dxhLBZ8JINAXL6ehAoe6jnHZOrm+XH8q9hBQd
         7pffRhsipSi1fzZ2CD/XiTPFHiB4cPcDvMnW1hwhIxgNgvmodISuhLp6/rsGYXbVTj26
         iW+b8EtR6LYPIcQNL4+AndrlDyNZk34J0UOZRdqIGxoUwZasCjVNSAuMBGx0kyxTCjNb
         8N4AONQI4Y7mtUzJcCOwse/dkN3iimpo5AKZ/ADkPeqtLl1a9zyTJtRPP18VGYBSZ5jE
         bODtWc0afamdjegvguA7ZzeYfVrk0dMX/dN6pzYzGBZ+lp4HJGseE+4bcZU1ZQP1XbAz
         uNHQ==
X-Gm-Message-State: AOJu0YyxaQNqiORcaFw0ejn+EiqrFtJn08dpes96IVvMwVw0s7yqgoqf
	Y5Pmwh/+GIfZB/67ywoTm6YRNp9gnH/GqWVowmXNK7tNyDVpD20Mkymd2S7dHTxRB7vRkHG+SjA
	X+D0sjy8WVXHjyblR8Cs8ERH45555vNc=
X-Gm-Gg: AeBDieuQAThRv1a0/LF8jVoYIYM+BaDClCZ3pKGpgSwSH7J1jdnCJ8Y8Ux+Ch6kRKdX
	6aXU2j1Ahaf2ShO/1T4nak4kCTp16WO0yAwJ7my0qDaw95eoLyjwUPdFhnfwGeUGMiYQr2Hmgru
	6gRb1wWXax0sqBkib2ZSsnO+1t+jtSPS95BlWc8VxiE7Wq5mfHi0jYf6mhHoyjbAa7ay1k30Edi
	/laFb+GmBu9E49xs2p3m8ePd/txhkXWRMggyvvbB2l5cdsVmeurO/gWGzMVMhSB6RDacUY/yAQ5
	o4SBJEHN3GQvEPHL1w==
X-Received: by 2002:a05:6102:d94:b0:5ff:c64d:2283 with SMTP id
 ada2fe7eead31-62ad56d048bmr416390137.30.1777509278038; Wed, 29 Apr 2026
 17:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428025110.38825-1-FredTheDude@proton.me>
In-Reply-To: <20260428025110.38825-1-FredTheDude@proton.me>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Wed, 29 Apr 2026 17:34:26 -0700
X-Gm-Features: AVHnY4IdVo_bnjOiG-Rpty6RcenM2uyoo2yYIBKVzYINOZwm3jqtbO72G2Ih7ms
Message-ID: <CAAk_H6EDmZAKZLbUWm9h1VVCvaY5RdyfepyUFOF8XwvEyvgSyg@mail.gmail.com>
Subject: Re: [PATCH RFC] smb: client: fix NULL pointer dereference in smb2_compound_op
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(Apologies for the duplicate; adding the list to the thread for the archive=
)

Please disregard this patch. It adds a redundant check; there is no
NULL pointer dereference, and rqst is correctly zero-initialized using
kzalloc_obj().
Sorry for the confusion.


On Mon, Apr 27, 2026 at 7:52=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> When a valid cfile is passed to smb2_compound_op, the code uses a
> goto to jump to the 'after_open' label. This bypasses the
> initialization of rqst[0] by SMB2_open_init().
>
> However, the 'finished' cleanup block unconditionally attempts to
> call SMB2_open_free() on rqst[0]. If SMB2_open_init() was skipped,
> rqst[0].rq_iov is NULL, leading to a NULL pointer dereference.
>
> Check for a valid rq_iov before attempting to free the request
> to prevent the crash in handle-reuse scenarios.
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
> I am new to writing code for the Linux kernel.
> Please be patient with me and feel free to point out any
> obvious mistakes I made.
> I tested this patch in a user-space skeleton clone using ASan.
> I only have access to a shallow clone and cannot find the
> original commit for the 'Fixes:' line.
> ---
>  fs/smb/client/smb2inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index c6dd282fc..aed96eeba 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -552,7 +552,13 @@ static int smb2_compound_op(const unsigned int xid, =
struct cifs_tcon *tcon,
>
>  finished:
>         num_rqst =3D 0;
> -       SMB2_open_free(&rqst[num_rqst++]);
> +       /*
> +        * If cfile was passed, the open was skipped; check rq_iov
> +        * to ensure we don't try to dereference a NULL pointer.
> +        */
> +       if (rqst[num_rqst].rq_iov)
> +               SMB2_open_free(&rqst[num_rqst]);
> +       num_rqst++;
>         if (rc =3D=3D -EREMCHG) {
>                 pr_warn_once("server share %s deleted\n", tcon->tree_name=
);
>                 tcon->need_reconnect =3D true;
> --
> 2.43.0
>
