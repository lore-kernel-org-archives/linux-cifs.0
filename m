Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C06154730;
	Wed, 13 Mar 2024 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710348343; cv=none; b=kr2+/dE5lkUsxWPk2lIHEbZbwb3Fb6nWDYddBp7FJGhavEc2JwcXnJF3//mX4tX9zy0PorWCfpyh/MCfNorOfz30ofdivgUGjVHQloLtC8DP2Ku5l5NBAE0eAgWq0eyhe2Lnar94tUowRTRr8FXiOyDfGhjnEVZkbvKMXPAEICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710348343; c=relaxed/simple;
	bh=lJV3Ag4l0871XskzCAMQxgWmYLf9hCnD7es2PpeveBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bDff9a69V/2SjUN8GWKMvv8XrYOXS/62Hu2wVEzgsI035EQzyDwqxlfUZz30VOsuED1ec9QtyQap9mpRIbJ9gDslK0rvQZasb6RJdbLo+z75AGPvvzNR72KtuZDuLPAOg9GERjV7FgOgwA7a14qQuKA+Pbsq0UHetJuUHnEY9OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iEbDJQCK; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEbDJQCK"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d208be133bso13951fa.2;
        Wed, 13 Mar 2024 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710348339; x=1710953139; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7GOet5Kd1nu0tc9bo2crL4RoXzrPH8m4IUp71zdccw=;
        b=iEbDJQCKf2xwzXB5Xsz0hSDFpkCPRTINhmUq2V2wcovECltDlQmViA7lex9FX/+sj9
         eL8EFm03F9BGoQ52bis50c37MeWCid6S5BMdWD+Qp1a+h1Cq9uNyVtxbAaFLoOOVLbZ0
         Ge5UqOdBm8FCNdtRqaiavhWxrMzojZ0gg4o3vjLV/39gOXz+DY4KbkJIqBa/y3PnYoJc
         bGkn/tc7b3tctdTjbIJ7M2YlczlCbDHNBSkTUXVKBbUi9p/1NS+skDUhiniIW6pd/xNt
         qiIYVK7E36X8vDg4m1h+nsucIaZFe5m+EiKLkF9jvdIdxzWLiq0wIcFZPpBKHUTP16cY
         2hew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710348339; x=1710953139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7GOet5Kd1nu0tc9bo2crL4RoXzrPH8m4IUp71zdccw=;
        b=NOLccsuX3eSw6k15z7ZpVYaZAWsvw7Y5cQsqKjyqQBilpR2yyql6CIM787KMygIcob
         pG6X2J04DgZgITALtiVDG0rdA0EJd5k/1Q732P4sFt8ahbFxjBUOCZ1MkqyGrAZHOMFg
         vlmtW8GhGC9ttje6FlDdsjH6itIhKSyIfKpGNaH9/obtc+CLGs+UchZZhJEzaVsRwGrI
         9UrUiFYAFg/KiN0ZNFIYUVgH91bDtcDlmHasyZV2XiU6cpwvrgI+YaVT7u650NvhfDS6
         nQBKTSzVCC/XfV2BK7hnywVJ8K/vD58NWKnScHW9snc5a+B7jp1jFEe6fhkn1xn3qOds
         saiw==
X-Forwarded-Encrypted: i=1; AJvYcCUuBf3ZdsuLqkxIsScJaOHXCXbKfKGayDzxiiz21X5LQnjJ9p4Z45GTHkowXrHbwgFG4f/lGwPWbPjxwA6XQ4JfZ4R0Rkmy
X-Gm-Message-State: AOJu0YzPowt6INEQG+NMu3Z0BudP3UawWUq5HXP75dMBYmpPPm7krpd1
	BOYGjd8r6mJnoorX6xcQztOPzHh85A1nu0wjXOl1HTYeYM3baq+OKHZ17lVSAgxEtAcyO016oZy
	+gRg0M2w4RcLN4wL1XmrxHgmcILp09K26IgA=
X-Google-Smtp-Source: AGHT+IHU4XBhZgQiQiqqUa3OCc10X0BG91/+AcHfYkh38OmPaOtg/tEiB/1NdzGV4Ftf8MXlJ4mpt8/fIBpZdIFEgi4=
X-Received: by 2002:a05:6512:39c7:b0:513:c892:23db with SMTP id
 k7-20020a05651239c700b00513c89223dbmr2102619lfu.45.1710348339219; Wed, 13 Mar
 2024 09:45:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313104041.188204-1-sprasad@microsoft.com>
In-Reply-To: <20240313104041.188204-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Mar 2024 11:45:28 -0500
Message-ID: <CAH2r5mtDe_E9=mGx1mOjfEMfgdhV9W=TjijXOdqgTkasVE81=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: reduce warning log level for server not
 advertising interfaces
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>, Stable <stable@vger.kernel.org>, 
	=?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

what about simply a "warn_once" since it is useful for the user to
know that their server does not advertise interfaces so can affect
performance (multichannel) and perhaps some reconnect scenarios.

On Wed, Mar 13, 2024 at 5:40=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Several users have reported this log getting dumped too regularly to
> kernel log. The likely root cause has been identified, and it suggests
> that this situation is expected for some configurations
> (for example SMB2.1).
>
> Since the function returns appropriately even for such cases, it is
> fairly harmless to make this a debug log. When needed, the verbosity
> can be increased to capture this log.
>
> Cc: Stable <stable@vger.kernel.org>
> Reported-by: Jan =C4=8Cerm=C3=A1k <sairon@sairon.cz>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/sess.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 8f37373fd333..37cdf5b55108 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -230,7 +230,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>                 spin_lock(&ses->iface_lock);
>                 if (!ses->iface_count) {
>                         spin_unlock(&ses->iface_lock);
> -                       cifs_dbg(VFS, "server %s does not advertise inter=
faces\n",
> +                       cifs_dbg(FYI, "server %s does not advertise inter=
faces\n",
>                                       ses->server->hostname);
>                         break;
>                 }
> @@ -396,7 +396,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>         spin_lock(&ses->iface_lock);
>         if (!ses->iface_count) {
>                 spin_unlock(&ses->iface_lock);
> -               cifs_dbg(VFS, "server %s does not advertise interfaces\n"=
, ses->server->hostname);
> +               cifs_dbg(FYI, "server %s does not advertise interfaces\n"=
, ses->server->hostname);
>                 return;
>         }
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
