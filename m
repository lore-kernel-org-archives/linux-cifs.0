Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF83D561
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762613215; cv=none; b=SAACRsYa0k2XhRPS2xDyH1DdKkhryYRyrvGC3PVA4xwboDcwj7nCTnULza2HXUj4cKhpz3ID0WpLEuaRGa4pMwgx+GlT4CPqBXK7DYJIcPcguuVldDBN7RKEI613cQm//3wIycvYIRN3KXZY7AF/XnrBIhW28mJuFabXjpEf3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762613215; c=relaxed/simple;
	bh=e2abTaKak9F+D5hLa1oLX38oqMySV0hVV+m1Bs6VuBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nqdH3goWu9AyBcS7SgSbI1N8v85E6YePzwV8fLbUB1rUAAQSp/kWNF1asiRN+kfCvm/I7s08orAt0t3YELDxrDg0c8pAbQgbk3eA6JzbeBsATDrHIycVsFWEOglRp4TNwmo+mdzgjBTqbRvoHHvKaLyldX+LY4YhoAoIw/IJLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMWuNTvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMWuNTvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D79C19421
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762613215;
	bh=e2abTaKak9F+D5hLa1oLX38oqMySV0hVV+m1Bs6VuBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rMWuNTvhEcCPzmWAzLiwjaQWpXx6EGxLV5cbQcNn7jer8YfLPPw0ERXYt9S3o+gfd
	 Vs9vuvFsoM0aUYRiSufefzVD2MqSY2axfpRNTpZDDM2tfc3v6ZKy8kigvANeZe0tkx
	 noSUxu4nEpUDSNq5BFjK0Uht4DMBfbm3ADS0apoJay6YXyoNTRGR8rRS5AP7YT3/vF
	 UPwVzT3xXqg6TAdTl3RQJazhR8NIGhP8h0KGLIbMT8VeuFkT7n3bREqN7LaJrfFUDE
	 +sug5kOafit4xSsBCjm/d/3wB8h5RzlkD0OdOW4ms595h7XO1YBtEVteOlzrcERV36
	 lbhCsDhtwySoQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b72db05e50fso209254466b.0
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 06:46:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXJEeqF7MwkKxahCZ7Q8+PH7q5v+VEmQSEfG03B4a6YR5qfkXF+VcpeaBbKs0o7ltMZ5m+XoAq7D6pv@vger.kernel.org
X-Gm-Message-State: AOJu0YxSOSLXYSTmwRBjSkcTOuDbfuPRW4SmK6ECMDQJ4krnbC0csJmf
	uzol1vTFYTqP93j3ruOTGeCvkxHsZzy1soDEL8/9HgzxccLmRaxw/6iomkSaUT6JBOl9Pnx+U2U
	o9Ew2NMPJLmbG8G2cNg9w27Yegxs7yAM=
X-Google-Smtp-Source: AGHT+IH0dFf89SxucnZydwoYn4g7JrmAqU6/5oiBizREO74gTJC6q1vpLcwG8D+usHbmPALvTnbCFvvmDk7Ofs1/8As=
X-Received: by 2002:a17:907:3f07:b0:b46:8bad:6972 with SMTP id
 a640c23a62f3a-b72e04e3526mr293962166b.38.1762613213586; Sat, 08 Nov 2025
 06:46:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025110803-retrace-unnatural-127f@gregkh> <20251108123609.382365-1-pioooooooooip@gmail.com>
In-Reply-To: <20251108123609.382365-1-pioooooooooip@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 8 Nov 2025 23:46:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
X-Gm-Features: AWmQ_bnmtDghD3kQ5OPzrzlSyqe9j2p8NZ_MyeNDM_lVWl-_pIMCdtirQviKJII
Message-ID: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: vfs: fix truncate lock-range check for shrink/grow
 and avoid size==0 underflow
To: Qianchang Zhao <pioooooooooip@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhitong Liu <liuzhitong1993@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 9:36=E2=80=AFPM Qianchang Zhao <pioooooooooip@gmail.=
com> wrote:
>
> ksmbd_vfs_truncate() uses check_lock_range() with arguments that are
> incorrect for shrink, and can underflow when size=3D=3D0:
>
> - For shrink, the code passed [inode->i_size, size-1], which is reversed.
> - When size=3D=3D0, "size-1" underflows to -1, so the range becomes
>   [old_size, -1], effectively skipping the intended [0, old_size-1].
>
> Fix by:
> - Rejecting negative size with -EINVAL.
> - For shrink (size < old): check [size, old-1].
> - For grow   (size > old): check [old, size-1].
> - Skip lock check when size =3D=3D old.
> - Keep the return value on conflict as -EAGAIN (no noisy pr_err()).
>
> This avoids the size=3D=3D0 underflow and uses the correct range order,
> preserving byte-range lock semantics.
>
> Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
> ---
>  fs/smb/server/vfs.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 891ed2dc2..e7843ec9b 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -825,17 +825,27 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
>         if (!work->tcon->posix_extensions) {
>                 struct inode *inode =3D file_inode(filp);
>
> -               if (size < inode->i_size) {
> -                       err =3D check_lock_range(filp, size,
> -                                              inode->i_size - 1, WRITE);
> -               } else {
> -                       err =3D check_lock_range(filp, inode->i_size,
> -                                              size - 1, WRITE);
> +               loff_t old =3D i_size_read(inode);
> +               loff_t start =3D 0, end =3D -1;
> +               bool need_check =3D false;
> +
> +               if (size < 0)
> +                       return -EINVAL;
There is no case where size variable is negative.

> +
> +               if (size < old) {
> +                       start =3D size;
> +                       end   =3D old - 1;
> +                       need_check =3D true;
> +               } else if (size > old) {
> +                       start =3D old;
> +                       end   =3D size - 1;
> +                       need_check =3D true;
>                 }
>
> -               if (err) {
> -                       pr_err("failed due to lock\n");
> -                       return -EAGAIN;
> +               if (need_check) {
> +                       err =3D check_lock_range(filp, start, end, WRITE)=
;
> +                       if (err)
> +                               return -EAGAIN;
>                 }
>         }
Can't you just change it like this?

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..f96f27c60301 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -828,7 +828,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
                if (size < inode->i_size) {
                        err =3D check_lock_range(filp, size,
                                               inode->i_size - 1, WRITE);
-               } else {
+               } else if (size > inode->i_size) {
                        err =3D check_lock_range(filp, inode->i_size,
                                               size - 1, WRITE);
                }

Thanks.
> --
> 2.34.1
>
