Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A210A3A
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nvvc/o5e"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50e72e3d435so4371663e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703849158; x=1704453958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGauJLu8Kk5d9GlJNfGNiZFBcnW+nUPspvry1T6v1yY=;
        b=Nvvc/o5e2nH6pEKNY6ifw1WDHaYXxY5a41FTSJQiY2EkJ+69v09soBM63XD315fuU9
         JdQp4HUqkZj8H8OKufitVWPwUoQcdYLsGRTmqPa2St21lCrOJEkgJsX/58HlMV0R79Bf
         wp4S5x5m+2TK40XcAEs5j/M8lPUjnZKExvk17CgQM62XVQSo9DpsZsAsJo72oVvML9QR
         5y8op1QxcHK79uJ6SffeDAymW9yvsWzCyDoz0fe9NTMINWNGhRfxCPascnIn4dw7B+DL
         O6/K6ur3wiKF8jsuHv9AtnL8sNhgJe0wVSiHRhbRxf0duB/r/Szlwm2FE5dGnjhOmDF/
         GrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703849158; x=1704453958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGauJLu8Kk5d9GlJNfGNiZFBcnW+nUPspvry1T6v1yY=;
        b=CkUa0eFz/NMwZ9aIvHXf4MTU6c8SumDG00ENBItfCYxPr0D6lPgs09q7OrvD2kmcyL
         2fnfeLLdiiX6MrEojY7nJIrita+bie9xN0p1s39WJmCqCdKSSBddGKXeT8bvE67VIam/
         4IwKt3nSkVQzDPvfGnmQ+i07Jz7VdgQe+coaqUdMFx3KdlFCNPJB/lYhrhFxdAF8vFFf
         QKQKUclccTNxAuKm++aasSzThqF4kjcqCl9sr0YtPr+o7Hz3nIRv1I/6EoI1Vkqrr4Sn
         fw8mRswOf4c88Y593BwiRiPdPjHqNRb2Yym4PBsmlDzWXwjxwW1aKx3wxrkkcc3ka6+I
         49qw==
X-Gm-Message-State: AOJu0YxDRcAUjf6Tt7KihlazMtTfpPz7tZSk648MibTgh2gZjGBYV/it
	pZmnMBr/el9aN9bTNon1xpuOxHYJyj+cKjuue5Q=
X-Google-Smtp-Source: AGHT+IHXF1aKUQ8Zc80QzrwDM/zC8gcF9hjVVOs4PbXUnuL2uIjpysyBt2zjDhDHHQ6Vfw5npaBu++PZOWudSd+T9Bc=
X-Received: by 2002:a05:6512:3d88:b0:50e:4bf6:bb6a with SMTP id
 k8-20020a0565123d8800b0050e4bf6bb6amr3460119lfv.161.1703849157908; Fri, 29
 Dec 2023 03:25:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com>
In-Reply-To: <20231229111618.38887-1-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 29 Dec 2023 16:55:46 +0530
Message-ID: <CANT5p=rX81OL+cU+EVSRcv+xF_cHQQ+Oz6JkMQoTDzH6YVBWqA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: cifs_chan_is_iface_active should be called with
 chan_lock held
To: smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> cifs_chan_is_iface_active checks the channels of a session to see
> if the associated iface is active. This should always happen
> with chan_lock held. However, these two callers of this function
> were missing this locking.
>
> This change makes sure the function calls are protected with
> proper locking.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 7 +++++--
>  fs/smb/client/smb2ops.c | 7 ++++++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 8b7cffba1ad5..3052a208c6ca 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -232,10 +232,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Se=
rver_Info *server,
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_s=
es_list) {
>                 /* check if iface is still active */
> -               if (!cifs_chan_is_iface_active(ses, server))
> +               spin_lock(&ses->chan_lock);
> +               if (!cifs_chan_is_iface_active(ses, server)) {
> +                       spin_unlock(&ses->chan_lock);
>                         cifs_chan_update_iface(ses, server);
> +                       spin_lock(&ses->chan_lock);
> +               }
>
> -               spin_lock(&ses->chan_lock);
>                 if (!mark_smb_session && cifs_chan_needs_reconnect(ses, s=
erver)) {
>                         spin_unlock(&ses->chan_lock);
>                         continue;
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 441d144bd712..104c58df0368 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -784,9 +784,14 @@ SMB3_request_interfaces(const unsigned int xid, stru=
ct cifs_tcon *tcon, bool in_
>                 goto out;
>
>         /* check if iface is still active */
> +       spin_lock(&ses->chan_lock);
>         pserver =3D ses->chans[0].server;
> -       if (pserver && !cifs_chan_is_iface_active(ses, pserver))
> +       if (pserver && !cifs_chan_is_iface_active(ses, pserver)) {
> +               spin_unlock(&ses->chan_lock);
>                 cifs_chan_update_iface(ses, pserver);
> +               spin_lock(&ses->chan_lock);
> +       }
> +       spin_unlock(&ses->chan_lock);
>
>  out:
>         kfree(out_buf);
> --
> 2.34.1
>

This one fixes two changes. Not sure if it's valid to have two Fixes tag.
Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary=
")
Fixes: fa1d0508bdd4 ("cifs: account for primary channel in the interface li=
st")

Should also CC stable.

--=20
Regards,
Shyam
