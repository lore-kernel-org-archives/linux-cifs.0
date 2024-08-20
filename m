Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9B6191466;
	Tue, 20 Aug 2024 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724163083; cv=none; b=orFwQs3Ge2uS1H5hXaEBNqYiROVNJc25V3gZpU3H0nGAcNltEpbpC3ysvvn+HxF+q63V7cH+wlvXDUhzUS2l18O0oK0XFTrKGbJPbCDLivGzxGF3Xii96w4Oq+J5LgGcGXh/ZkBFQr1vuSsz6Z87Mp0tnEC6kPE6I5vNCNBCc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724163083; c=relaxed/simple;
	bh=8OkZMbgAfYmBiLgYTNFbbx9yN9I/qSTEXDUtFQcnoyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l0lx8b5NwcjhcgqNY288rq2ju20otrWK6rrlZEzyCtzmlrjlv/jXbIw5uwlYd3GHYPU1rtT6CSbRmh2kMIYhi259ZUMRSTiwF09YeD5CEJxRjtQBUs7IKm7tuc8lTiJIm4YNpOLiDgyEV1tBf3VXgmErfstYWORLvWm9UHF6ZV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpShLRmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpShLRmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4CCC4AF11;
	Tue, 20 Aug 2024 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724163083;
	bh=8OkZMbgAfYmBiLgYTNFbbx9yN9I/qSTEXDUtFQcnoyc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HpShLRmo6ZrWwJCuer7G9i+Kb1JBsoPu+MT/pBaIVhDzCxqZC/wZLWbBlJGQbdByp
	 2Q6vZcGq/4fE8HXfdFZAoM39aEMDG6Nyb/ULnSyhERkBxJCda0c+asF7RbT3+NIX4v
	 mQfYY3bqvzYM3HEQDoPGw4kz1PJvSeWWX9H7Y9O8sKHTTVfGi6I09SRsOJCF/GoXiW
	 MSUJ9PFSc+b3MI1EniVu7bBLKetO/up4TuboF2FwiXv76PudEoB7xHwYCSL86gCjNR
	 VQGQd1o9DSZthJ2xhhlHGKg5BnuhRbZrXzRn74P4caIRzfWc6n1Hhskea74hDxFs4t
	 mJguG6a6LPEqw==
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3db23a6085aso2729838b6e.1;
        Tue, 20 Aug 2024 07:11:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU2YvyO3DHtdn45++XOYoMmfZL1LN3dnIQsX33Uw85ipsVkfvrVGD4bBByUf0Mc0213ou+VWctJ0CTt@vger.kernel.org, AJvYcCVsHpOEI1Gl3UMau0UNCTNDMmzbhzmzy5z/ee+YC28/wkX3TuvVQDKzV8lxvjPnzOumpOvIms5kSrXnlf0YOxMR@vger.kernel.org, AJvYcCX6aINL6RNfICFbkQQGLPSjBbjrer5RSiuqaZqDUEtbt59ymfOFkfqGBYIat2VBeyFxrekli41BCwstEUPn@vger.kernel.org
X-Gm-Message-State: AOJu0YyMe1PQUJ1+wiSn1jAJuyVw4lrHDue2muULFA4skkaio8C4WpDj
	3G1ZO6WtUorjlo3EiEHk/kqkYq3xoFR9d9ZV72x6DBZuH4e7bfoVxMUYlgyn9EvCO+r6kSJ72WK
	yWevjPD7yzKZMwTzp+DVPRdXIfik=
X-Google-Smtp-Source: AGHT+IFQA2AFHP13j3/kgl6lDFmtIGjoFh/C9xrHhF/pXGnO99oKXl3yC62tJgZSS457QRNLlWlt2lTRKkHtP6+s4mU=
X-Received: by 2002:a05:6808:152b:b0:3db:1e15:302f with SMTP id
 5614622812f47-3ddbb9721a1mr1290999b6e.15.1724163082465; Tue, 20 Aug 2024
 07:11:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240818162136.268325-2-thorsten.blum@toblux.com>
In-Reply-To: <20240818162136.268325-2-thorsten.blum@toblux.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Aug 2024 23:11:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pm01ietA1+Z4J8tDcLM6fUkAwQ69j9XZs9uhrBbdDQQ@mail.gmail.com>
Message-ID: <CAKYAXd-pm01ietA1+Z4J8tDcLM6fUkAwQ69j9XZs9uhrBbdDQQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Replace one-element arrays with flexible-array members
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 1:22=E2=80=AFAM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Replace the deprecated one-element arrays with flexible-array members
> in the structs copychunk_ioctl_req and smb2_ea_info_req.
>
> There are no binary differences after this conversion.
>
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  fs/smb/server/smb2pdu.c | 4 ++--
>  fs/smb/server/smb2pdu.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 2df1354288e6..83667cb78fa6 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -4580,7 +4580,7 @@ static int smb2_get_ea(struct ksmbd_work *work, str=
uct ksmbd_file *fp,
>         /* single EA entry is requested with given user.* name */
>         if (req->InputBufferLength) {
>                 if (le32_to_cpu(req->InputBufferLength) <
> -                   sizeof(struct smb2_ea_info_req))
> +                   sizeof(struct smb2_ea_info_req) + 1)
We can use <=3D instead of +1.
>                         return -EINVAL;
>
>                 ea_req =3D (struct smb2_ea_info_req *)((char *)req +
> @@ -8083,7 +8083,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>                         goto out;
>                 }
>
> -               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req) + 1) =
{
Ditto.
>                         ret =3D -EINVAL;
>                         goto out;
>                 }
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index 3be7d5ae65a8..73aff20e22d0 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -194,7 +194,7 @@ struct copychunk_ioctl_req {
>         __le64 ResumeKey[3];
>         __le32 ChunkCount;
>         __le32 Reserved;
> -       __u8 Chunks[1]; /* array of srv_copychunk */
> +       __u8 Chunks[]; /* array of srv_copychunk */
>  } __packed;
>
>  struct srv_copychunk {
> @@ -370,7 +370,7 @@ struct smb2_file_attr_tag_info {
>  struct smb2_ea_info_req {
>         __le32 NextEntryOffset;
>         __u8   EaNameLength;
> -       char name[1];
> +       char name[];
>  } __packed; /* level 15 Query */
>
>  struct smb2_ea_info {
> --
> 2.46.0
>
