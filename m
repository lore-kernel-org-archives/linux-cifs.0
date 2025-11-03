Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6CB26F445
	for <linux-cifs@vger.kernel.org>; Mon,  3 Nov 2025 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762176270; cv=none; b=LuL8dWq2IT3kaNCB48b1grsBang7VynGPPfT24ZRWfbMkc0WqBI/+Fhlhb5pSiFun7iPy+6+qCa1Qw5UhC7n4p8lqHepuuIMljav95AWIOITomaD6BtvycdgMrcI1VlV8O/YgAgY7Lsnfkwb3rYCUEslCVdkGqay6Ru2VwEhwk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762176270; c=relaxed/simple;
	bh=O+dRAgI4LPfuYan1hqt3Wh5X/J4xUpMgYGmJUgN4GBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/LyZnT7Seh2XPIiWV+0gbCMVmZxIZpMJqrDVEcnlh/x50AfbLhoaH87dqEHhMQe0Fd6Dndzke9baIhcL5FB6l+ExllHDm6Zpe76GK34Z62FJbdSksRfuf5gZ7s85ezw31Wu/HXy2TU8QTiERlVfdV2NNqI7KLhsfY039ISDvcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T8KZqbv6; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8KZqbv6"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7155207964so121197466b.2
        for <linux-cifs@vger.kernel.org>; Mon, 03 Nov 2025 05:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762176265; x=1762781065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0S6+1dUVKvqII667r+XW9/GENl1vb5Sqoomw0mlu3RI=;
        b=T8KZqbv6kO/2xrWzX5n2788COipO+Tnz7F384SIxaywjLymb/lsfPxOUz0GOomqB4m
         tSNiR+3flO68a9EtT4yaCs81ULEj8LfOSo8v3ZU97wAF7FdFSJhOJv2ZeicIbfs6vvRl
         1gGjjqDGtjMsAY2i9JFTxfgqyW942vF6Q2vzk65RMl3u/HohDHs+eH1IoKambzK6Rwo0
         /2xTzljrwr5o3ouIWwJ8c92Yk6WGQLDij67OP/z+7tBvBMrLdiEPRX4izLkduDzW/+qd
         HoG9zb4rHzUKP+pIRspQJTBFjtz/T4jk9Y2st713BaUCRGI8wudxyrwpsYCmR3hy/3EE
         pTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762176265; x=1762781065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0S6+1dUVKvqII667r+XW9/GENl1vb5Sqoomw0mlu3RI=;
        b=YIFdFLA/jKETdbyvE4xqD9z+VS0vVSs1Ea2QKNI8OaVi9LHORiLesUmZE1SfJ/grP9
         1qUtwF0H61ZfJ8s4fCapPawbG98OLzNUldXP/2ZGsOnhiPJbLAPNCnUXltzmtM/PoWUn
         gmoPAp/zFsrxUf/NymXS2WmrMEysctZ/AJgYn6rjOUG/h4w32cwn7amZ6y+/7FQ4EXLa
         Y6AlOTtx/VWiF8zjBSNTnkdpPMzcVJWXyTA+y1WGfJWr92ZSaYV/ZG8kV14YCNEf258o
         dLx6I+CFssNnxSOB1EiuOR1X8qPXvOO1LmFHB2ARfrocMJVe0tw9rCwjCY0eFQftjI+G
         cJEw==
X-Forwarded-Encrypted: i=1; AJvYcCUmIkY9Zeaf6VlpSSO+IHL8XLsiMqpucE9M0/ZjxaCMGAhpdcB5CpUWhaRPcUWqXCFnGvve79nOLNhU@vger.kernel.org
X-Gm-Message-State: AOJu0YwonYgTOln+Y37yvCu9uXsajenzvDmro7EVOH6OSD/5qnwLbyhg
	3NpXs2UG+wO1DSH/3KHii7Px3lzzwMUfpRvP/2uplgBtalGO0wbyXl9RyiG+4AC3T90+owlkVuv
	wbOYYSNNSwt5ZOTRAanmRi5TpowYa5to=
X-Gm-Gg: ASbGncvln0AK8pSSA/YEgEB1osFPxGFhrVbfXQQ3MsrCd8bnLQwZkWV5bHZmT0PeuIt
	tomEHjC2LBKjhY3RRyWLNX0z/gi4MkGy1bnl49k0HskhRqHWQsFhQG9871WEYTM318yOpZjtfKK
	IAWLPRgMexeO8FiBuuHQktIf56yQCew2EbK0kahby6Vs5VMfmtGifJExBHy9rPduf3v5tOKnacZ
	T4l+h0N/u846uDWJ0c14TZtTCXBBAehTpfRaTaVMG17xOuo+fyuxkgYQLhoJ+ReD3scuPxJmijA
	V2YPz6G93rAUCfoi6KQEMDEvowb0CQ==
X-Google-Smtp-Source: AGHT+IELl7DuDv5uo3bD6NZ9q582bvS2bDMma/TtRpWZCxPhIVAv9e4H0npG+fdCye/re4SlhiT2Qy0S3M2gjGw90Ag=
X-Received: by 2002:a17:907:ea7:b0:b6d:2d0b:1ec2 with SMTP id
 a640c23a62f3a-b70708315e8mr1272156366b.54.1762176265161; Mon, 03 Nov 2025
 05:24:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org> <20251103-work-creds-guards-simple-v1-4-a3e156839e7f@kernel.org>
In-Reply-To: <20251103-work-creds-guards-simple-v1-4-a3e156839e7f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Nov 2025 14:24:13 +0100
X-Gm-Features: AWmQ_blW2akq-ipD0fIUUOxTn8zmugUgDmTC0C57BdhrsmFigJmfJvym14MPro0
Message-ID: <CAOQ4uxhW2FiVe6XjQDT_aXhzJDyT5yuna9CVaWOLyzU1J99hFg@mail.gmail.com>
Subject: Re: [PATCH 04/16] backing-file: use credential guards for writes
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-aio@kvack.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 12:30=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Use credential guards for scoped credential override with automatic
> restoration on scope exit.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/backing-file.c | 74 +++++++++++++++++++++++++++++--------------------=
------
>  1 file changed, 39 insertions(+), 35 deletions(-)
>
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 4cb7276e7ead..9bea737d5bef 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -210,11 +210,47 @@ ssize_t backing_file_read_iter(struct file *file, s=
truct iov_iter *iter,
>  }
>  EXPORT_SYMBOL_GPL(backing_file_read_iter);
>
> +static int do_backing_file_write_iter(struct file *file, struct iov_iter=
 *iter,
> +                                     struct kiocb *iocb, int flags,
> +                                     void (*end_write)(struct kiocb *, s=
size_t))
> +{
> +       struct backing_aio *aio;
> +       int ret;
> +
> +       if (is_sync_kiocb(iocb)) {
> +               rwf_t rwf =3D iocb_to_rw_flags(flags);
> +
> +               ret =3D vfs_iter_write(file, iter, &iocb->ki_pos, rwf);
> +               if (end_write)
> +                       end_write(iocb, ret);
> +               return ret;
> +       }
> +
> +       ret =3D backing_aio_init_wq(iocb);
> +       if (ret)
> +               return ret;
> +
> +       aio =3D kmem_cache_zalloc(backing_aio_cachep, GFP_KERNEL);
> +       if (!aio)
> +               return -ENOMEM;
> +
> +       aio->orig_iocb =3D iocb;
> +       aio->end_write =3D end_write;
> +       kiocb_clone(&aio->iocb, iocb, get_file(file));
> +       aio->iocb.ki_flags =3D flags;
> +       aio->iocb.ki_complete =3D backing_aio_queue_completion;
> +       refcount_set(&aio->ref, 2);
> +       ret =3D vfs_iocb_iter_write(file, &aio->iocb, iter);
> +       backing_aio_put(aio);
> +       if (ret !=3D -EIOCBQUEUED)
> +               backing_aio_cleanup(aio, ret);
> +       return ret;
> +}
> +
>  ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter=
,
>                                 struct kiocb *iocb, int flags,
>                                 struct backing_file_ctx *ctx)
>  {
> -       const struct cred *old_cred;
>         ssize_t ret;
>
>         if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)))
> @@ -237,40 +273,8 @@ ssize_t backing_file_write_iter(struct file *file, s=
truct iov_iter *iter,
>          */
>         flags &=3D ~IOCB_DIO_CALLER_COMP;
>
> -       old_cred =3D override_creds(ctx->cred);
> -       if (is_sync_kiocb(iocb)) {
> -               rwf_t rwf =3D iocb_to_rw_flags(flags);
> -
> -               ret =3D vfs_iter_write(file, iter, &iocb->ki_pos, rwf);
> -               if (ctx->end_write)
> -                       ctx->end_write(iocb, ret);
> -       } else {
> -               struct backing_aio *aio;
> -
> -               ret =3D backing_aio_init_wq(iocb);
> -               if (ret)
> -                       goto out;
> -
> -               ret =3D -ENOMEM;
> -               aio =3D kmem_cache_zalloc(backing_aio_cachep, GFP_KERNEL)=
;
> -               if (!aio)
> -                       goto out;
> -
> -               aio->orig_iocb =3D iocb;
> -               aio->end_write =3D ctx->end_write;
> -               kiocb_clone(&aio->iocb, iocb, get_file(file));
> -               aio->iocb.ki_flags =3D flags;
> -               aio->iocb.ki_complete =3D backing_aio_queue_completion;
> -               refcount_set(&aio->ref, 2);
> -               ret =3D vfs_iocb_iter_write(file, &aio->iocb, iter);
> -               backing_aio_put(aio);
> -               if (ret !=3D -EIOCBQUEUED)
> -                       backing_aio_cleanup(aio, ret);
> -       }
> -out:
> -       revert_creds(old_cred);
> -
> -       return ret;
> +       with_creds(ctx->cred);
> +       return do_backing_file_write_iter(file, iter, iocb, flags, ctx->e=
nd_write);
>  }

Pointing out the obvious that do_backing_file_write_iter() feels
unnecessary here.

But I am fine with keeping it for symmetry with
do_backing_file_read_iter() and in case we will want to call the sync
end_write() callback outside of creds override context as we do in the
read case.

Thanks,
Amir.
