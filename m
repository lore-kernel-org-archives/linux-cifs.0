Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D1134A0;
	Thu, 22 Aug 2024 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724287293; cv=none; b=GuqJeP2TwUPCoBJF+wioaPJEKhLt2vvLKNhuszT4zNJD7tRcfLVzz0JVUSP9h9TYHSr6bSjbsdqPQ5v0T0NKWzhvkVntppFRv0otMlf/2KVV3p4enoS7tUcvnLbhx9m0O2lLZ2R5zAiFdlyV17xSdAD9oDGh6tJrIl4WUz1PNZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724287293; c=relaxed/simple;
	bh=NEssf0xVc7ugi9uMlrCSuabJ7ZJLuNn69lL2053VhPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjTsFpg04ekNbfwA9OFN65xD5uthyTUn7Br3AyqrZOyea3PPwBRjPd7+DV/nd6o1psb1SEQdaPSA+Ftl2RkcaKc8ilK3XfkcQCH1dKS+2eoT9QEGD0/tG3p3aIMfEX6x906FLqf4Zmrmh7b3TQr+i9XY4xBx7inTIr69L2stm1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCXfzPf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCXfzPf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E93C4AF09;
	Thu, 22 Aug 2024 00:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724287292;
	bh=NEssf0xVc7ugi9uMlrCSuabJ7ZJLuNn69lL2053VhPo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OCXfzPf1xT7jC3YWS4EfIz5Mnm/NdjcH7ZtZ8b84uvqmw1hhylZvoZXI1SXnzWFtr
	 XWYteRcO/6cDfsq4SGVg8sbEuS8GPB8CmdIZuZWjBcqymfD/wcuEH/L5nURx9iMXlb
	 13h7Q5EZUw7t09fbfC8HzFhJltWXxWDcWj279ERVyXFMB/dKmLcqTbmoIBPmnmwdMY
	 pkR3BoAqGQZ5Lafyxv7II2pDESDmj9uO3kXCRd16bdJ0Sjl17MP8gIf+Wv3juzGM7f
	 Hiy78cGjozEtgXSzBNQbacAbFI4XKPaf8tdWE2kZNPbJ6Fl+yv3J841QpRYcsY5sfb
	 DKlWNJSeZub1g==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-273c8514254so165931fac.0;
        Wed, 21 Aug 2024 17:41:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUy0OsZVlObb5jo8+LmSdYRwNHpLNRLZ3faQzQtiq7CxectNAW3svufIy3LioReKbwNNvuhWafquKF+@vger.kernel.org, AJvYcCWMyzzrAXgoVhTTZQSkG0+P1eFFpj9SO+Gen1rh2GiZmYHwshNdFudvn6zzpg0itP0vmx7c/WY6RPeHhrir@vger.kernel.org
X-Gm-Message-State: AOJu0YxTQlOqCU/BL4RX8/lfDpBYP7cZfpkTtg+1ZZx4XlQaZAAttBjI
	ykrO7xXawO5ua+PRMmwnWblk+6sdO1MLVFrRZvnvvx4AKtZhEC1OTri+65k+qVZZD1rzaajZTon
	C0gtPp2XsrRb05KBAXGRaxTpH8qo=
X-Google-Smtp-Source: AGHT+IElt6sefHhqIxqFCoAxywErgtfOh5OvhtkKT1xldNaCmtIjA7e3BdbEdccx7xsHZn1JD0zM7TFQBxoxtObEoW8=
X-Received: by 2002:a05:6870:9708:b0:260:f058:48eb with SMTP id
 586e51a60fabf-2737ef041cemr4706474fac.20.1724287292078; Wed, 21 Aug 2024
 17:41:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 09:41:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_N2Hgba2EsDkem7mmGrWxxpXOtz4L_ReXwqUCG_BRU=w@mail.gmail.com>
Message-ID: <CAKYAXd_N2Hgba2EsDkem7mmGrWxxpXOtz4L_ReXwqUCG_BRU=w@mail.gmail.com>
Subject: Re: [PATCH 2/8] smb/server: fix potential null-ptr-deref of
 lease_ctx_info in smb2_open()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> null-ptr-deref will occur when (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEA=
SE)
> and parse_lease_state() return NULL.
>
> Fix this by returning error pointer on parse_lease_state() and checking
> error.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
We intended for it to return null. We shouldn't handle the error even
if it fails.
All places check if lc is null except the one.
We can fix it like the following one. please send this patch if you are oka=
y.

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b6c5a8ea3887..884e21992c92 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3404,7 +3404,7 @@ int smb2_open(struct ksmbd_work *work)
                        goto err_out1;
                }
        } else {
-               if (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEASE) {
+               if (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEASE && lc) {
                        if (S_ISDIR(file_inode(filp)->i_mode)) {
                                lc->req_state &=3D ~SMB2_LEASE_WRITE_CACHIN=
G_LE;
                                lc->is_dir =3D true;


> ---
>  fs/smb/server/oplock.c  | 11 +++++++----
>  fs/smb/server/smb2pdu.c | 17 ++++++++++++-----
>  2 files changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index a8f52c4ebbda..e8591686a037 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -1510,7 +1510,8 @@ void create_lease_buf(u8 *rbuf, struct lease *lease=
)
>   * parse_lease_state() - parse lease context containted in file open req=
uest
>   * @open_req:  buffer containing smb2 file open(create) request
>   *
> - * Return:  oplock state, -ENOENT if create lease context not found
> + * Return: allocated lease context object on success, otherwise error po=
inter.
> + *        -ENOENT pointer if create lease context not found.
>   */
>  struct lease_ctx_info *parse_lease_state(void *open_req)
>  {
> @@ -1519,12 +1520,14 @@ struct lease_ctx_info *parse_lease_state(void *op=
en_req)
>         struct lease_ctx_info *lreq;
>
>         cc =3D smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
> -       if (IS_ERR_OR_NULL(cc))
> -               return NULL;
> +       if (!cc)
> +               return ERR_PTR(-ENOENT);
> +       if (IS_ERR(cc))
> +               return ERR_CAST(cc);
>
>         lreq =3D kzalloc(sizeof(struct lease_ctx_info), GFP_KERNEL);
>         if (!lreq)
> -               return NULL;
> +               return ERR_PTR(-ENOMEM);
>
>         if (sizeof(struct lease_context_v2) =3D=3D le32_to_cpu(cc->DataLe=
ngth)) {
>                 struct create_lease_v2 *lc =3D (struct create_lease_v2 *)=
cc;
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index d8a827e0dced..119c1ba5f255 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2767,8 +2767,9 @@ static int parse_durable_handle_context(struct ksmb=
d_work *work,
>                                 }
>                         }
>
> -                       if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CA=
CHING_LE)) ||
> -                            req_op_level =3D=3D SMB2_OPLOCK_LEVEL_BATCH)=
) {
> +                       if ((!IS_ERR_OR_NULL(lc) > 0 &&
> +                            (lc->req_state & SMB2_LEASE_HANDLE_CACHING_L=
E)) ||
> +                           req_op_level =3D=3D SMB2_OPLOCK_LEVEL_BATCH) =
{
>                                 dh_info->CreateGuid =3D
>                                         durable_v2_blob->CreateGuid;
>                                 dh_info->persistent =3D
> @@ -2788,8 +2789,9 @@ static int parse_durable_handle_context(struct ksmb=
d_work *work,
>                                 goto out;
>                         }
>
> -                       if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CA=
CHING_LE)) ||
> -                            req_op_level =3D=3D SMB2_OPLOCK_LEVEL_BATCH)=
) {
> +                       if ((!IS_ERR_OR_NULL(lc) &&
> +                            (lc->req_state & SMB2_LEASE_HANDLE_CACHING_L=
E)) ||
> +                           req_op_level =3D=3D SMB2_OPLOCK_LEVEL_BATCH) =
{
>                                 ksmbd_debug(SMB, "Request for durable ope=
n\n");
>                                 dh_info->type =3D dh_idx;
>                         }
> @@ -2935,8 +2937,13 @@ int smb2_open(struct ksmbd_work *work)
>                         ksmbd_put_durable_fd(fp);
>                         goto reconnected_fp;
>                 }
> -       } else if (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> +       } else if (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEASE) {
>                 lc =3D parse_lease_state(req);
> +               if (IS_ERR(lc)) {
> +                       rc =3D PTR_ERR(lc);
> +                       goto err_out2;
> +               }
> +       }
>
>         if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGAT=
E)) {
>                 pr_err("Invalid impersonationlevel : 0x%x\n",
> --
> 2.34.1
>
