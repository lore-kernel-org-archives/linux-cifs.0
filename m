Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85728134CF
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763426317; cv=none; b=T31WdAB/ATqqoMh1saCAJT4jz0zX1NMhoxFXsU/sbQJPtxSMZVUumOJsRNpv7v3Y2vxQR0+xmooEjzwe0bTgr7JmsAnG8SGXRCmrIR4VHweI50S1pdU+HGzBsY3q0cNC3q7iYZtOEsFmwE0ulDYblqLQB2QZt/NuVIA6xpGnzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763426317; c=relaxed/simple;
	bh=NolSpxAFx7Iuz5gCYUMQIMohSXdycGVAKp4PbTIGcc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TcSnt3v0/s9vnezP3ew5P6grTQbZIBXZucwGwxhX4e5LDRncWeWsYhaDrZ0GK5unhM56Mws4g0+f9waAaooLSTstkqH52U69/jxvJhIgl+faHRJ+nI/a15sKdfhNr8vgzUl7LB4BcOipi862rbcaAntBXEyFnYl+qnuWl6mCQts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDf+4Nqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDf+4Nqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C46C2BCB0
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763426317;
	bh=NolSpxAFx7Iuz5gCYUMQIMohSXdycGVAKp4PbTIGcc4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CDf+4NqomrffDvPLiVJsDam/m07z3cULuu/i8K4yWHYMnxLU81yIn9FZX4x63kLnx
	 j/0iLMRTu8LF4lljwr+m8c+crCF/QO+5DwDFPmzS598tiEiVG3aoN7IaCTcrjTcpbM
	 ZdYOjYbImioGwCgRYEX6j1R7a+nR4rUgCipVMGLLSbKKQUi7uXzaoTg+th7Iee8Ujt
	 YXLO5qtDh5XUlhC/c9qNOLGxrdIKOa23YsATilY9KKV6vJv80CyGEWci/maviPC/nG
	 DhBD2G2aqQsOAuxlQxYoeMnpfCI9JLdE274Kdkc1zpR59FSoCb+gZs8Z9H8xhFzzJ8
	 D8iky/hbjMogw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-644f90587e5so1047701a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 16:38:36 -0800 (PST)
X-Gm-Message-State: AOJu0YyMyVaftzhFbIyIOSW3botnh79EivuT7xWIiyyBJ9PyrsQ/m0xk
	FRK9GBik/+m7HTuF6OSco0hVXNXyIWf/7omV8Q+g+phlxOTlsF49Xp17Q4cnEtRxGT505Q14Ooc
	iL8NRpvRheNKu72sLFVZhaq6yOhp7Nnw=
X-Google-Smtp-Source: AGHT+IFhYhdZfg+EyLBQWS9JaaUh5/lknYe6+2nwQ03IgZpJZiVq93TNcBtNcRUVL6juI4D3Oiah1Z78XOeQL2ivnig=
X-Received: by 2002:a05:6402:4603:b0:640:f974:7629 with SMTP id
 4fb4d7f45d1cf-64350e225e0mr13649663a12.15.1763426314754; Mon, 17 Nov 2025
 16:38:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117185041.1689521-1-aadityakansal390@gmail.com>
In-Reply-To: <20251117185041.1689521-1-aadityakansal390@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Nov 2025 09:38:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8PqH9KUTFwOL0v5k185u17dh8NB+kphjh15DU3BnNLmQ@mail.gmail.com>
X-Gm-Features: AWmQ_blIYobcgqg5mioS3yoq5jz5HqgaGVkw9YwJGA8YQwOx6YCXzBJZLbyURfQ
Message-ID: <CAKYAXd8PqH9KUTFwOL0v5k185u17dh8NB+kphjh15DU3BnNLmQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH
 in smb server
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 3:51=E2=80=AFAM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
> Add STATUS_INFO_LENGTH_MISMATCH mapping to EMSGSIZE.
> Currently, STATUS_INFO_LENGTH_MISMATCH has no mapping to any error code,
> making it difficult to distinguish between invalid parameters and length
> mismatch.
>
> Map STATUS_INFO_LENGTH_MISMATCH to EMSGSIZE while keeping the EINVAL for
> invalid parameters. Although the buf_len check only checks for buf_size
> being less than required, there was no error code for lower buf_size.
> Hence, EMSGSIZE is used.
>
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
Applied it to #ksmbd-for-next-next.
Please add cc linux-cifs mailing list next time.
Thanks!
> ---
>  fs/smb/server/smb2pdu.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index f901ae18e68a..d79a08378965 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -6396,7 +6396,6 @@ static int set_file_mode_info(struct ksmbd_file *fp=
,
>   * @share:     ksmbd_share_config pointer
>   *
>   * Return:     0 on success, otherwise error
> - * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISM=
ATCH
>   */
>  static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file=
 *fp,
>                               struct smb2_set_info_req *req,
> @@ -6409,14 +6408,14 @@ static int smb2_set_info_file(struct ksmbd_work *=
work, struct ksmbd_file *fp,
>         case FILE_BASIC_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_basic_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_file_basic_info(fp, (struct smb2_file_basic_in=
fo *)buffer, share);
>         }
>         case FILE_ALLOCATION_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_alloc_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_file_allocation_info(work, fp,
>                                                 (struct smb2_file_alloc_i=
nfo *)buffer);
> @@ -6424,7 +6423,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>         case FILE_END_OF_FILE_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_eof_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_end_of_file_info(work, fp,
>                                             (struct smb2_file_eof_info *)=
buffer);
> @@ -6432,7 +6431,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>         case FILE_RENAME_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_rename_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_rename_info(work, fp,
>                                        (struct smb2_file_rename_info *)bu=
ffer,
> @@ -6441,7 +6440,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>         case FILE_LINK_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_link_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return smb2_create_link(work, work->tcon->share_conf,
>                                         (struct smb2_file_link_info *)buf=
fer,
> @@ -6451,7 +6450,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>         case FILE_DISPOSITION_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_disposition_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_file_disposition_info(fp,
>                                                  (struct smb2_file_dispos=
ition_info *)buffer);
> @@ -6465,7 +6464,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>                 }
>
>                 if (buf_len < sizeof(struct smb2_ea_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return smb2_set_ea((struct smb2_ea_info *)buffer,
>                                    buf_len, &fp->filp->f_path, true);
> @@ -6473,14 +6472,14 @@ static int smb2_set_info_file(struct ksmbd_work *=
work, struct ksmbd_file *fp,
>         case FILE_POSITION_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_pos_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_file_position_info(fp, (struct smb2_file_pos_i=
nfo *)buffer);
>         }
>         case FILE_MODE_INFORMATION:
>         {
>                 if (buf_len < sizeof(struct smb2_file_mode_info))
> -                       return -EINVAL;
> +                       return -EMSGSIZE;
>
>                 return set_file_mode_info(fp, (struct smb2_file_mode_info=
 *)buffer);
>         }
> @@ -6587,6 +6586,8 @@ int smb2_set_info(struct ksmbd_work *work)
>                 rsp->hdr.Status =3D STATUS_ACCESS_DENIED;
>         else if (rc =3D=3D -EINVAL)
>                 rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +       else if (rc =3D=3D -EMSGSIZE)
> +               rsp->hdr.Status =3D STATUS_INFO_LENGTH_MISMATCH;
>         else if (rc =3D=3D -ESHARE)
>                 rsp->hdr.Status =3D STATUS_SHARING_VIOLATION;
>         else if (rc =3D=3D -ENOENT)
> --
> 2.51.1
>
