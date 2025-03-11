Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A152F25F985
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719069; cv=none; b=UKcje+IArN2uSLbodiOTFFeeAks24i5LgoF++FKOliKoHdHShLsZXZ8SPDlPTzrNiMFFijqwV/g0A249OBV+ywIuPsftKpXKctUf9pIc6KoGVKUIeOMuclmz+toRzU6DL3A2BUtBIArSwVRW1X57AvmDKFiUeXcBlvG4pyYl2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719069; c=relaxed/simple;
	bh=gU3OIZg6UIGxss/koBDwOrLG7qsPc1G6lbBnTH1bOYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YM0VuVQeOk4Ean3ylK5Bq7hBHLdUgF6mHq0+akRLm0P84YPJ6dfQkgKJ3D1rgXcPHgOen99CSClzqfYCJZ28DZWGj3LMD4o0OolhCVmciH4VgzUxx+Q7VBxu/6R2yZGhhVDZwVv7LKDtrkBrXyWn6zRaON6FE5dLbz6UgqnJ364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=giVKZRlj; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="giVKZRlj"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5495078cd59so6590584e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 11:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741719066; x=1742323866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ym7rbWc78y3RvP2De7B2SqWUYYM/5WV41KF2WOupKm8=;
        b=giVKZRljO9k5HxQsFPOIGClRfhVV77hFzzVHq5SaV8Eav1aZYO4cQT/b+jLZCOGOLK
         zSQP2sxGQx7jvKhnNacfTXGPVKoRDx8Jf61tJXYAAGKB/lbqT7I/g+iQ/TOtncicKDMg
         SE6kCr1XwDcn/4oFjytTQhYm2tCCPm8KDlzeCs/qW4x2FdiVc+jyBHHsYHAWCD55wAqV
         cnjUOfnfe/yh6MUkwQzCVrC0WbOrsBEtb5PNY4f8PtG649DZyA5J6tmC5Svrfdw+dGN/
         UVR0LMJ2ASLBOqylJtK8GL5FY+4ya6jhtCZlPwCEFS1P9CZvDpXQyY8rvynEiBWbPKrg
         YVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741719066; x=1742323866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ym7rbWc78y3RvP2De7B2SqWUYYM/5WV41KF2WOupKm8=;
        b=H8WSz3P58lqCDulaFYRIRRmh/YTfEMs1dTke/8ZFCe+sY2MSE7fYk1a664dHLhNk9f
         nSWMHLvABxImllU1CxKihTG6sEmYgbrvXzaBiwfegb/4vtcgKg+ziqvV0VmALl4bETOd
         6kmolwTHNd6aPDaFqd+JMFBKpOHlcb30duYyIaaRYthMJL1tQSrxPe2HKZFnE6uE4aMp
         e5p0mc2ZoU86jlnRI63MkgZ6pmV7g4D/SaRP+NiFiu9DALM826L1AUeFSYyGkPa//2Ul
         7o1k2bQwrAK6uuHa2WnzcX7rD0J99d4am+pqVc2sQ8hR62ETDlevVCz6la51w6lT2FCh
         pldw==
X-Forwarded-Encrypted: i=1; AJvYcCXmE8M6dQ8RpHrE40anQElLaBglGbLL+uvkapeCyJ8eidnEHlLmTQuFJhGIk5bgAvgvjPjPgfwzukdm@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6jARB/M5LDnPlYkwhz+Gs4oMC+EoKjzFEMFGV/3rYVKkVbwv9
	EzCy2P0745QZAhevbm+29rMbhO6kan2GrY1Dle4unOPwefKumLigFjKr0L788cRw+jRzA9pY5gM
	FIj/OYV+BwqjbeL7Mvq4KzQ9IAV8=
X-Gm-Gg: ASbGncuvqEVr1csFyVXxZnEaIxBfA/sa5BrSLHyXnvfwW0vltr7jLhcg7EtnUKFrdpl
	Pv/Q6MVC9cTqu+2nFV7XHr+HyieEcOodRgRWeQqO/gISzE3KW5+U2XK1+Mew8QXfKI4v8KuPA4u
	6UgjupyBqmaArTo5QuvTmUA/r+NnOspERSTNeBKgjcw3b2ltZ5FspqLx6MNAP+
X-Google-Smtp-Source: AGHT+IEVmnJRF1SdVfXEXiCDAyiTJytDXhhcCgQvIfAoCun76IUxRqwgogAlp+wId+VLN9rQgy3Hx0o26oTaIcrLasM=
X-Received: by 2002:a05:6512:2827:b0:548:e44d:f3ee with SMTP id
 2adb3069b0e04-549abaac646mr1641000e87.10.1741719065275; Tue, 11 Mar 2025
 11:51:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311182359.3012730-1-henrique.carvalho@suse.com>
In-Reply-To: <20250311182359.3012730-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 11 Mar 2025 13:50:54 -0500
X-Gm-Features: AQ5f1JqksLWPztxbBFCbxVeR0Q1yU85mWKnb2iK6kxBJQezXrnq7BkM03T7ifzc
Message-ID: <CAH2r5ms9pbyqxsXGixFyG9p8r6evu5iThr1wmv0sq8d66wQD9Q@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: Fix match_session bug preventing session reuse
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated cifs-2.6.git for-next with this newer version of the patch

On Tue, Mar 11, 2025 at 1:25=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Fix a bug in match_session() that can causes the session to not be
> reused in some cases.
>
> Reproduction steps:
>
> mount.cifs //server/share /mnt/a -o credentials=3Dcreds
> mount.cifs //server/share /mnt/b -o credentials=3Dcreds,sec=3Dntlmssp
> cat /proc/fs/cifs/DebugData | grep SessionId | wc -l
>
> mount.cifs //server/share /mnt/b -o credentials=3Dcreds,sec=3Dntlmssp
> mount.cifs //server/share /mnt/a -o credentials=3Dcreds
> cat /proc/fs/cifs/DebugData | grep SessionId | wc -l
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V1 -> V2: fix git message, fix krb5 case pointed by Enzo, add IAKerb to
> switch
>
>  fs/smb/client/connect.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index f917de020dd5..73f93a35eedd 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1825,9 +1825,8 @@ static int match_session(struct cifs_ses *ses,
>                          struct smb3_fs_context *ctx,
>                          bool match_super)
>  {
> -       if (ctx->sectype !=3D Unspecified &&
> -           ctx->sectype !=3D ses->sectype)
> -               return 0;
> +       struct TCP_Server_Info *server =3D ses->server;
> +       enum securityEnum ctx_sec, ses_sec;
>
>         if (!match_super && ctx->dfs_root_ses !=3D ses->dfs_root_ses)
>                 return 0;
> @@ -1839,11 +1838,20 @@ static int match_session(struct cifs_ses *ses,
>         if (ses->chan_max < ctx->max_channels)
>                 return 0;
>
> -       switch (ses->sectype) {
> +       ctx_sec =3D server->ops->select_sectype(server, ctx->sectype);
> +       ses_sec =3D server->ops->select_sectype(server, ses->sectype);
> +
> +       if (ctx_sec !=3D ses_sec)
> +               return 0;
> +
> +       switch (ctx_sec) {
> +       case IAKerb:
>         case Kerberos:
>                 if (!uid_eq(ctx->cred_uid, ses->cred_uid))
>                         return 0;
>                 break;
> +       case NTLMv2:
> +       case RawNTLMSSP:
>         default:
>                 /* NULL username means anonymous session */
>                 if (ses->user_name =3D=3D NULL) {
> --
> 2.47.0
>
>


--=20
Thanks,

Steve
