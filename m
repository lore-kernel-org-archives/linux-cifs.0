Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794F19007D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663569; cv=none; b=b4JUj7I+fmTXVgP8XzTShoaGPikbWOgdLaBXzWxoOYv3c+1hQSzU6MqSYpggKHMOiaJlS827uu2JP1W659YjiHzFxA/s7LmlqlJca8HnbIiiq928To3RKPGXcFcREQmbNBYJ8bunkvJLCmv+hNPLbNbIocdWWaYJBAnF5dEV4Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663569; c=relaxed/simple;
	bh=1DJPvBfsUi4w2/R6eu367/IDzl7XogU5wIV019F5/DE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5kjg952DaxbqD0czUA7u5fGYVO9i5b08x7Gmpf6Gy+OvfLjZa7Ef/IVaJgbk/yDgdLPfUcxIU+8Y9HxFXbRdZb23DGWOBRESeYvbSzBy0nwOg6QFt3rs3jCf3NWlwYPumN7luTp6U48a4wJpsTngAKW6eHxPdaJeYUqnGUOiOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0HhDlQ0; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0HhDlQ0"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54996d30bfbso2923170e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 10 Mar 2025 20:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741663566; x=1742268366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUQbaRq+oo16WZ4tf4oKiKVIclztVGEnjMjqnXhAOiA=;
        b=A0HhDlQ0JpT4xsAQv743EwfaWUAX74uQR+VNODxehav0CuaSBoXShbO6Q67Pb1Xgb3
         nbAu2fWcf90qpDbe/i78lr2PLLudn7EYhkxOHH6VfOSpgpER/e9PSTNALNApeNnlS4rQ
         1LvhtdVInFmiSGh9CPjob2NQWHQB/4VFw+VOzS/0whpNzmeTlargMO20xg+UV1WUAtHx
         nWRCgCS59aV4VCYtp7rvg+qJOM98CXrMfm9nBE/zhtT8+qTZjO0gEULnBkY6CcjcoXwe
         2Ce9t6SA6O4t7YAAhHP5snR2gMVhaN5Y+ukuKvU/noCACNbuj1eBG8iv/479AUnwsUIW
         dWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741663566; x=1742268366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUQbaRq+oo16WZ4tf4oKiKVIclztVGEnjMjqnXhAOiA=;
        b=UCMJ8VLVm9PzbMQuMPaqkYMR3xUSTJsp+28tXbQ2FYOvenMqnt+43WexJVDNzkkkHC
         eb88tmmhuLQdW63Uai2m4vlVRezu94lV0z8NUgjiSZOgd4MD3U5P001xsxbRpIYVSt2q
         J8enWx3jDUgTeLLqHP7B3lM8/Dvm0N8yAfiN0quqvCzb1AAdlKc2qyEQvOGNjk78rr+Y
         pLfEsYO+HqU5C+IVcwuEJFUZpp88C+num710ehjKIx6DKatlovCTyQbVsOuNY7PnAyFd
         ZImxil7o7GLcvsBXjrO26SMV2Z3f0PYiGB6mySPKQNnPhnxm4gNpAKNGraL+vxvBzx3x
         06tw==
X-Gm-Message-State: AOJu0YxvE0F5tJ99KV+vyOHDmBcOD/Qm8okdmYKPwoXCzBNYzI6Kjjdo
	WwBxU8HP6PwkqqeVpMrR8gQYBYCWk2DZxl0E6j1uyqtMpdbKlVZ56JfXHW1+y2qcF/imW58/7KC
	yUYxS/FRgPyWYM23OJ43qhWcob37EVg==
X-Gm-Gg: ASbGncuiA462lomzmiw8Eno73+2Ak/jbL9m99uqW6aju8RYeEoVoA2j/x8+xRCSVjEO
	IbyOhJTrc3ev+1ZV5TAsHQQQLJwG9X3oGI01SCCN7Y+ejS+iThi4hg3OR8ydprrcCRyUTQqaeVU
	XDFg474eJ6Z64diES22PYvuQrKfKoikNRMx+SBnUxBMpasHKFxl/x98S40E6dH
X-Google-Smtp-Source: AGHT+IHBuDvItAIvfbBZUar/HUVuSu2bQ2JbGJKayjPjjjugOt/D6AyFoKjSWYmqx0I9e5SZW35fEPjS6NDdLdbLebw=
X-Received: by 2002:a05:6512:2394:b0:545:e19:ba1c with SMTP id
 2adb3069b0e04-54990e5d359mr5725599e87.19.1741663566093; Mon, 10 Mar 2025
 20:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214124306.498808-1-aman1cifs@gmail.com> <20250306174642.584848-2-aman1cifs@gmail.com>
In-Reply-To: <20250306174642.584848-2-aman1cifs@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Mar 2025 22:25:54 -0500
X-Gm-Features: AQ5f1JoDmbpq5xJLs5xZm8evD1ZtCI0P8BlbAumwo2U675c5eUA1zjarOY1MpgM
Message-ID: <CAH2r5mtrsqR+93ZvcWM3eyd2WrmY9DyRCUCWf=Sr97S3pus8SA@mail.gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Propagate min offload along with other
 parameters from primary to secondary channels.
To: aman1cifs@gmail.com
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, psachdeva@microsoft.com, Aman <aman1@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Was doing some testing with this and tried an experiment with
multichannel and "sign" mount parm - and it looks like even without
the fix, we do sign on all channels even though tcp_ses->sign was not
updated on the secondary channels.  Do you have a reproduction
scenario for the signing issue?

On Thu, Mar 6, 2025 at 11:47=E2=80=AFAM <aman1cifs@gmail.com> wrote:
>
> From: Aman <aman1@microsoft.com>
>
> In a multichannel setup, it was observed that a few fields were not being
> copied over to the secondary channels, which impacted performance in case=
s
> where these options were relevant but not properly synchronized. To addre=
ss
> this, this patch introduces copying the following parameters from the
> primary channel to the secondary channels:
>
> - min_offload
> - compression.requested
> - dfs_conn
> - ignore_signature
> - leaf_fullpath
> - noblockcnt
> - retrans
> - sign
>
> By copying these parameters, we ensure consistency across channels and
> prevent performance degradation due to missing or outdated settings.
>
> Signed-off-by: Aman <aman1@microsoft.com>
> ---
>  fs/smb/client/connect.c | 1 +
>  fs/smb/client/sess.c    | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index eaa6be445..eb82458eb 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1721,6 +1721,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>         /* Grab netns reference for this server. */
>         cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
>
> +       tcp_ses->sign =3D ctx->sign;
>         tcp_ses->conn_id =3D atomic_inc_return(&tcpSesNextId);
>         tcp_ses->noblockcnt =3D ctx->rootfs;
>         tcp_ses->noblocksnd =3D ctx->noblocksnd || ctx->rootfs;
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 91d4d409c..b4d76a37a 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -522,6 +522,13 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>         ctx->sockopt_tcp_nodelay =3D ses->server->tcp_nodelay;
>         ctx->echo_interval =3D ses->server->echo_interval / HZ;
>         ctx->max_credits =3D ses->server->max_credits;
> +       ctx->min_offload =3D ses->server->min_offload;
> +       ctx->compress =3D ses->server->compression.requested;
> +       ctx->dfs_conn =3D ses->server->dfs_conn;
> +       ctx->ignore_signature =3D ses->server->ignore_signature;
> +       ctx->leaf_fullpath =3D ses->server->leaf_fullpath;
> +       ctx->rootfs =3D ses->server->noblockcnt;
> +       ctx->retrans =3D ses->server->retrans;
>
>         /*
>          * This will be used for encoding/decoding user/domain/pw
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
