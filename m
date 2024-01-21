Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E98F10942
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 04:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705809790; cv=none; b=BBF3zbowDqdzSFXlavFU9b+baH/tRt6kmqvqZvfiZFZmF4I45K3Goc8qRbtk8Z48Sb2XUWqdVRI4If69hRAWhR7AYtTsdSFIRyiK5//1eEokbQhNhp+HHThX48m2AvvkzA4O6x1lZiQtUdLGSaIOXEK4mtlpa5b17x66Zzg+4+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705809790; c=relaxed/simple;
	bh=lJzxKIsLXw5855Bffhxk5nol63vcMTWkAXn+bLgOE8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8I9pt62LtDpJyIPPatCTuh4NERcp2wRW4q23qyu7OMPqazfCZGV/s7jKv/f/AmyyOIQZL1wbBF04eG8mbDX6Q0D6KGej6y6Xh66ruvCHzxcrPKL1pM0y077UmWNnvbzvIUKsOsDQ9sca5rxnYNd8/HVGfLfr2x8qZIJG9murco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUPVBXlZ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUPVBXlZ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3392b045e0aso659267f8f.2
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 20:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705809787; x=1706414587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JIAYBFj4Pj6dmEkXcmVQnSEJ95g8R9ebuHW2sleLkw=;
        b=nUPVBXlZsuBAbfSKORjDvqdvktF7MyyqUxgerMTBYxKz8s29oz7x3tTIL8RemO+rZ5
         zP4x/gMJB8EejPPcgXI9yToFkvCNLpg5mEcMLKy9HH87MBxjK/9JGVvTSzZ2h1RzEC71
         ANeP6iI6YLqI5KRQhKsRRpwsBod/erEYpy7yobJMsb/dbKAyPOieUNEokGY9JNZ+FXoJ
         5p+9SX2pJAi88w3ROz4Nog4/5xpj5SufQAs47ubRSWWAbicsLiG6BqaPV9IubgPJ6Ndi
         soyxvS7B+spe39NiXWMb9fIhTLsC9XaHVXA2csBaeGf70+xB3NlcSvJl2Jyb3sC03eB2
         8R7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705809787; x=1706414587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JIAYBFj4Pj6dmEkXcmVQnSEJ95g8R9ebuHW2sleLkw=;
        b=AWWJA3yDQWfTNVAQCMtpmLF6FxWJc1QHuEqEtO0HoQP7iR0Kwvu/FsaiVIvrCxE7lz
         i6B4vqphBwM60RU8bALUnnGwLgzGj1kizEvLe3Y942+xeXOyvJ0ouRjX/CtlJvgXxmc8
         gcsQN4l8b56dqjlMfQfAbhkKq/qj3TRbXq7oAJVQ3RDZkJVGUxINNvacDLD/dSegPfuv
         SyW+6XantSOche+smqgSibxBsERhGRECqK92KD8cQTIJKxL1VUHXVfzCigbrWMmaYJD6
         RrxUNW0ek7NA/u8heqy2/lKvS2u/fCuabrqhSEe9aqfeLB2atLZiEub3l8ZBMkyGXxLP
         oYqA==
X-Gm-Message-State: AOJu0YyC5TrxmWZ4P8fyuTQs1XDU6MX4dUUjsq3m5oAxt0MLf45VFf+u
	PRTwSqCLHD6fzKSst502f2/Ocp4/ErrP9yR0pepcmXAZcwexqm2hb0jhoRk6O/tgO/nORXOIbV3
	ozyLq7TtxdSQ33alQZa7JgnbBY7JOEmdSf0E=
X-Google-Smtp-Source: AGHT+IFYLv6WMSNb8QP2Lys0o2ArxoxhiBrwjDnMqD+hLbqlPWEb6LKuTBfRkNhk7RQYkImtJcpYiLFwAG/IkbxzBzM=
X-Received: by 2002:adf:a2d5:0:b0:337:c91d:e80b with SMTP id
 t21-20020adfa2d5000000b00337c91de80bmr1064953wra.13.1705809787114; Sat, 20
 Jan 2024 20:03:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com> <20240121033248.125282-7-sprasad@microsoft.com>
In-Reply-To: <20240121033248.125282-7-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Jan 2024 22:02:56 -0600
Message-ID: <CAH2r5mvYbCA-HDWag+x5LcZ0W6j3PQPQjWUPESgR-eb3WKvnjg@mail.gmail.com>
Subject: Re: [PATCH 7/7] cifs: set replay flag for retries of write command
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending review and testing
(after correcting the duplicate label problem with patch 1)

On Sat, Jan 20, 2024 at 9:33=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Similar to the rest of the commands, this is a change
> to add replay flags on retry. This one does not add a
> back-off, considering that we may want to flush a write
> ASAP to the server. Considering that this will be a
> flush of cached pages, the retrans value is also not
> honoured.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 1 +
>  fs/smb/client/file.c     | 1 +
>  fs/smb/client/smb2pdu.c  | 4 +++-
>  3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index b5abe4d6f478..acda357e1dfd 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1506,6 +1506,7 @@ struct cifs_writedata {
>         struct smbd_mr                  *mr;
>  #endif
>         struct cifs_credits             credits;
> +       bool                            replay;
>  };
>
>  /*
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 1b4262aff8fa..49d262d1df5f 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3300,6 +3300,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, str=
uct list_head *wdata_list,
>                         if (wdata->cfile->invalidHandle)
>                                 rc =3D -EAGAIN;
>                         else {
> +                               wdata->replay =3D true;
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>                                 if (wdata->mr) {
>                                         wdata->mr->need_invalidate =3D tr=
ue;
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 0291482a3f51..a8ac9240a854 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4770,7 +4770,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
>         struct cifs_io_parms *io_parms =3D NULL;
>         int credit_request;
>
> -       if (!wdata->server)
> +       if (!wdata->server || wdata->replay)
>                 server =3D wdata->server =3D cifs_pick_channel(tcon->ses)=
;
>
>         /*
> @@ -4855,6 +4855,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
>         rqst.rq_nvec =3D 1;
>         rqst.rq_iter =3D wdata->iter;
>         rqst.rq_iter_size =3D iov_iter_count(&rqst.rq_iter);
> +       if (wdata->replay)
> +               smb2_set_replay(server, &rqst);
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>         if (wdata->mr)
>                 iov[0].iov_len +=3D sizeof(struct smbd_buffer_descriptor_=
v1);
> --
> 2.34.1
>


--=20
Thanks,

Steve
