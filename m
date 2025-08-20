Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69033376A1
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 16:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707861; cv=none; b=bre2EH6WCk/q3WrUqhxBfZ7WDzQZkgTx4EDsWYWSJBfPXPDr7Xoel/Fu+iSkpF1uBZM1kMxU9YJNLZXBWqqLhqgv927P94h78PB1Vz4lVrG4zQofBGu+wyCX6IIW5FIDx7SsWZqLcjqYJY5HdSYvAxW6DTgNxQjvygsIgPtMI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707861; c=relaxed/simple;
	bh=IulLseYpKuPvcIkGOc9Cuef/Z6oETRtun7+R2otwoZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6FTsYhu9nGxlK07C6ew2o6xXaahhuNxFGZ7/R20sgODaYFzJDGv9A3EwYq9GeI3D4irUnMrACti7cQcRB0XQhci+1dJzDD6ugGypcmL4DiJD4ccdTZiiuZNEnjacfRfwRAFMmoEBhZkeHLVIGTZr+5McLgrnntPsomHsCDPopQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lF0t93pK; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lF0t93pK"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70a88de7d4fso1234546d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 09:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755707857; x=1756312657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xB8/9prRi/NjQvfgwk6aFvwh9EbrMGAeRlO4VkoyIQ=;
        b=lF0t93pKm5WuS70ONbUhw84arWOXPriH0Z5UfWkGNB4a7u1XD47Sla0SJVgENJ0lSX
         3mjywHWjtjSjh2Hm5r7MzSenNGnPfbEbXO3KPOHgtddG8To6OF8KisHa24ZfInp9f3lx
         z9XKzYaDSFG2tN2HffvvG5QcTjGDM4kJ3YLFtpeRyjIEGSHRouNL+JOz6KvM4XiMfZfI
         BilrVwUEr7djGZPmpnf5i6JX/JgHaB/76wY0PmFDFH21Fz1i1F+DRVkZH2jAYrnReQ1B
         Ob3YcwinKC8MQQtnibbqKGFG1f74EzokomEWVcoBeE0hpqsJzi7VICuQOEc1I1JOLoMP
         69PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707857; x=1756312657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xB8/9prRi/NjQvfgwk6aFvwh9EbrMGAeRlO4VkoyIQ=;
        b=Ay0addf5Z87NhClQfZwqXcsFg6ZuxRx5PenIJWMhxhJk+ljunM/ucJngEc7a5qJDvO
         KquPr1tDTJTM6XCeZUGXgegao1jcchQYpWFXtTpcQR8UQVp/SLhBrXp66h1zKxz48lTI
         50+T+T0IVs5+bevlbVz5jFBLOuaDuP/QJOBGVDZpOhu0sU48kGx6jcfodKG4Ip/IoMvC
         Jhq7l3u9yofiuTq3vflpjWL/7evBQfmHt9VtdYI0NgJ1Rvk671+gD+7OPB+5grdMsFlp
         5hXgC7l/D5cDWKub2dqL4nb3UZDhu3Yw6MYIQLippEPIwQEyAlABAAmqEVoW+kzjGdAM
         DkVQ==
X-Gm-Message-State: AOJu0Yzu4usoJjpfFwCCylmMaTTv5Wj/b3jj0WjYRMejA9c/tgM+iof4
	BwPnu/JNQegHWw43DWiDdxR+eE70TIBhZBvB39plknSbabn7R8cQgAyIcRr/mObOdWLi2OCqxRk
	gwCRomM18cwDm6+7xIdpViplNQ4KmXZs=
X-Gm-Gg: ASbGncuzjYHUuVoXBwHXdAcvDW7YPdupTF2sL2D8yW8hhrQ49lE8V9m1qwpev0EcezV
	cYEyOD2QU+msbTvY4HYmp/DRej35Wo6hdM0tty06aYMgc95WYbj4hHNhEzuFDAHC6gMcgO5e2uk
	dBFY3+/mbMMnRED2uvFgj+RydZy7Nn/T4j5MfSljzcbo2PFFQi2iupXBzXZKQPaf0LsAKZ91H9O
	u2I8L42mfNPOL6vMOzJ1HwVBlvHB/xWyp+YT8xK
X-Google-Smtp-Source: AGHT+IF22rXo/VOZG4n4XbydiEP2feTGA726tgMApvCAvoq3ne2pfhxTlegYXNGDqSixYKAgxFYhyO1JOSX1N3QfWhs=
X-Received: by 2002:a05:6214:4108:b0:707:6364:792f with SMTP id
 6a1803df08f44-70d76f5c55dmr34872126d6.11.1755707856414; Wed, 20 Aug 2025
 09:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
In-Reply-To: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Aug 2025 11:37:25 -0500
X-Gm-Features: Ac12FXxrRiSxXnKiv--tq6ykyTczUt5aVU3R3vX92-NEkrXOP5ty3q_A0qmElQ0
Message-ID: <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1
 posix extensions
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Samba allows this with POSIX extensions negotiated (creating file with
: in the name) but I am wondering if a better way to solve this (to
avoid any confusion with alternate data streams) is to change the
client to use SFM_COLON (ie the remap in Unicode where colon is
remapped to 0xF022 instead of 0x003A)

On Wed, Aug 20, 2025 at 9:35=E2=80=AFAM Philipp Kerling <pkerling@casix.org=
> wrote:
>
> If the client sends SMB2_CREATE_POSIX_CONTEXT to ksmbd, allow the filenam=
e to contain
> a colon (':'). This requires disabling the support for Alternate Data Str=
eams (ADS),
> which are denoted by a colon-separated suffix to the filename on Windows.=
 This should
> not be an issue, since this concept is not known to POSIX anyway and the =
client has
> to explicitly request a POSIX context to get this behavior.
>
> Link: https://lore.kernel.org/all/f9401718e2be2ab22058b45a6817db912784ef6=
1.camel@rx2.rx-server.de/
> Signed-off-by: Philipp Kerling <pkerling@casix.org>
> ---
>  fs/smb/server/smb2pdu.c   | 25 ++++++++++++++-----------
>  fs/smb/server/vfs_cache.h |  2 ++
>  2 files changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 0d92ce49aed7..a565fc36cee6 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2951,18 +2951,19 @@ int smb2_open(struct ksmbd_work *work)
>                 }
>
>                 ksmbd_debug(SMB, "converted name =3D %s\n", name);
> -               if (strchr(name, ':')) {
> -                       if (!test_share_config_flag(work->tcon->share_con=
f,
> -                                                   KSMBD_SHARE_FLAG_STRE=
AMS)) {
> -                               rc =3D -EBADF;
> -                               goto err_out2;
> -                       }
> -                       rc =3D parse_stream_name(name, &stream_name, &s_t=
ype);
> -                       if (rc < 0)
> -                               goto err_out2;
> -               }
>
>                 if (posix_ctxt =3D=3D false) {
> +                       if (strchr(name, ':')) {
> +                               if (!test_share_config_flag(work->tcon->s=
hare_conf,
> +                                                       KSMBD_SHARE_FLAG_=
STREAMS)) {
> +                                       rc =3D -EBADF;
> +                                       goto err_out2;
> +                               }
> +                               rc =3D parse_stream_name(name, &stream_na=
me, &s_type);
> +                               if (rc < 0)
> +                                       goto err_out2;
> +                       }
> +
>                         rc =3D ksmbd_validate_filename(name);
>                         if (rc < 0)
>                                 goto err_out2;
> @@ -3443,6 +3444,8 @@ int smb2_open(struct ksmbd_work *work)
>         fp->attrib_only =3D !(req->DesiredAccess & ~(FILE_READ_ATTRIBUTES=
_LE |
>                         FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE));
>
> +       fp->is_posix_ctxt =3D posix_ctxt;
> +
>         /* fp should be searchable through ksmbd_inode.m_fp_list
>          * after daccess, saccess, attrib_only, and stream are
>          * initialized.
> @@ -5988,7 +5991,7 @@ static int smb2_rename(struct ksmbd_work *work,
>         if (IS_ERR(new_name))
>                 return PTR_ERR(new_name);
>
> -       if (strchr(new_name, ':')) {
> +       if (fp->is_posix_ctxt =3D=3D false && strchr(new_name, ':')) {
>                 int s_type;
>                 char *xattr_stream_name, *stream_name =3D NULL;
>                 size_t xattr_stream_size;
> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> index 0708155b5caf..78b506c5ef03 100644
> --- a/fs/smb/server/vfs_cache.h
> +++ b/fs/smb/server/vfs_cache.h
> @@ -112,6 +112,8 @@ struct ksmbd_file {
>         bool                            is_durable;
>         bool                            is_persistent;
>         bool                            is_resilient;
> +
> +       bool                            is_posix_ctxt;
>  };
>
>  static inline void set_ctx_actor(struct dir_context *ctx,
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
