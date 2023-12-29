Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9081B10A2E
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpihIjEo"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e7dd8bce8so3808670e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703849536; x=1704454336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5m26BXR4Vrb4wpre4nFZoOg48b5Xv6BM9mdrIu1xQIY=;
        b=UpihIjEo/hxe1xQ0fknpo0cwjUA8ei1zEVEjTnHSoMDkv3cEyw+ht7GEH1wGaqVYEg
         I6MdHJ2ZSXJMGgzLNKuwa8R0vKzG313ICHBFgqvYbyZgT9WW4dbxFaw/oWF9BxPNZsx4
         D4aDy/5WGqrHcFatwcAAaPjz2TMjGI/scqErSWGx/ATj+ZO+nxjgl1NNeCOH+XRTArdo
         1I0hPjwuGuIgwI1HWcIvoTghNYWzWMtBCiaXdcnMDDzrlZOTDYoQ5uvrSyNaZ4NOQ5eY
         7b/PbPxLcYWxC1Zq+dq59tu9NA2wYaKygfRXMnMlBvBytgnyyz//3u7nA8UXanZ6OZ3H
         ZH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703849536; x=1704454336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m26BXR4Vrb4wpre4nFZoOg48b5Xv6BM9mdrIu1xQIY=;
        b=EDhqY1yGHjFylfN5BmiJbG9794fiLskZWhTKQpwtt90caWvBa4Fa4O7kLtMrqW5a1g
         KPuDyJUGrICZ9IywslHvTosSt5jlricZEicgc6AXhl7kacqQiCSwT/26r+1xHFP27IHm
         W24pUfz3wnJ3J1SzhT+Gk2Cx+Cj4LxTbPzQ6wejoAs/23VZd6z0unS92AleAAA4oaThK
         UTUEpY2WqbgiDp6OluUQR8pBCXdhbBndG0yePxMbuQUa+gNZJwmfDLD4AW/rXVWlzDMH
         gv4IKa5t5aCfhsOKtjqA6imok5GZ3wylv+NikSU7fuEXSoGyAIDzwxh+9HIt2KfizA/o
         sWLg==
X-Gm-Message-State: AOJu0Yx1ohqIyIUU14z3EfpVHQ2N1Abqr9wz1nroSYkxQfDbsQiX4xWq
	uVxspdgXg10HJgVNWcm4igELYfhG9FbZDlJWZBBa0Txz
X-Google-Smtp-Source: AGHT+IHWNXbrB+HDR30nax4zj/gXy0MjyzXk/bY2V7OvqDFVuitsyxsdIIzIIVmM4t/6Uf9gEReKNbvU2yt+feBv43o=
X-Received: by 2002:a05:6512:2387:b0:50e:68d9:ff2e with SMTP id
 c7-20020a056512238700b0050e68d9ff2emr5797774lfv.13.1703849536454; Fri, 29 Dec
 2023 03:32:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229113007.39009-1-sprasad@microsoft.com>
In-Reply-To: <20231229113007.39009-1-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 29 Dec 2023 17:02:04 +0530
Message-ID: <CANT5p=qzHzi1RvB2NennAuL3ZQ8umKqBh28tQQp12nih7nPzqQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: after disabling multichannel, mark tcon for reconnect
To: smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 5:00=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Once the server disables multichannel for an active multichannel
> session, on the following reconnect, the client would reduce
> the number of channels to 1. However, it could be the case that
> the tree connect was active on one of these disabled channels.
> This results in an unrecoverable state.
>
> This change fixes that by making sure that whenever a channel
> is being terminated, the session and tcon are marked for
> reconnect too. This could mean a few redundant tree connect
> calls to the server, but considering that this is not a frequent
> event, we should be okay.
>
> Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichan=
nel")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 44bfdd88a906..8b7cffba1ad5 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -216,17 +216,21 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Se=
rver_Info *server,
>         /* If server is a channel, select the primary channel */
>         pserver =3D SERVER_IS_CHAN(server) ? server->primary_server : ser=
ver;
>
> +       /*
> +        * if the server has been marked for termination, there is a
> +        * chance that the remaining channels all need reconnect. To be
> +        * on the safer side, mark the session and trees for reconnect
> +        * for this scenario. This might cause a few redundant session
> +        * setup and tree connect requests, but it is better than not doi=
ng
> +        * a tree connect when needed, and all following requests failing
> +        */
> +       if (server->terminate) {
> +               mark_smb_session =3D true;
> +               server =3D pserver;
> +       }
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_s=
es_list) {
> -               /*
> -                * if channel has been marked for termination, nothing to=
 do
> -                * for the channel. in fact, we cannot find the channel f=
or the
> -                * server. So safe to exit here
> -                */
> -               if (server->terminate)
> -                       break;
> -
>                 /* check if iface is still active */
>                 if (!cifs_chan_is_iface_active(ses, server))
>                         cifs_chan_update_iface(ses, server);
> --
> 2.34.1
>

Sorry I missed sending out this patch before the other four.
This one needs to be applied first. Then the other four.

--=20
Regards,
Shyam
