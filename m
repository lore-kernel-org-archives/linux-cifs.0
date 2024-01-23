Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D61FC8
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 04:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705984760; cv=none; b=SXADhm6+Csh+OGuGfm85MO+ywqpODMPvPZw6JREoQf73xWZpGiaMBR7nnD9c+4wAHzpjf4vVde1G5Ow7ApsIGvmJ7L2zd+DGrK+vS8aH2I5L+3t3L6gGlFG5Cf/p1h5MMoaN8OlxkhO4Y9rSxZ7th79f7ZIDszLiEV6dyzkn22M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705984760; c=relaxed/simple;
	bh=LfchNDxZqE2zzDYgNnaL/i+sY6XDaTxQL6UyaPiMzCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hCoDX6ZbGA55Ahna74ZnjOS50SOqX6LbhI0XdcOLN94MAry3SU8OkoGOv+r4RcoNefF8ftwuRma6j01+KM/AcfFJVupK75R+NYuL3we/esCZoQoqfb+G+HJ32RMsL2ebBBL1o2+ioNZjiyXELm3bZJ0h/86/135A/fe+O34qU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLClyIjl; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLClyIjl"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50e7e55c0f6so4359142e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 20:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705984757; x=1706589557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgFMB+Fl/yQd1An5JZ5ltxKrtrLEdjWDDdss81Dhky0=;
        b=KLClyIjlB+1R8q1Ht4DOCZQaDNmuK0rcEqD4z3XIgH4rVi+IuEv98foe+sNY/h/+pz
         pcTVMItfileqkWN6EiCFJIa+f7D6FyOaPT2vXjqFLNDg+8hI/yMS6qFcPkYHmBe3S4Xk
         rghF7BUbiz2XqC2F1YhFEtz/oVbebywa109xRhq7zFofufwmtfUaRkbtJ1Gd/ExItomX
         K3gX9JzFL7z1sRimDq718YU2jdkL1gVA7878KseLt64U44jXXXzE0rjX2Fc7caayHM4h
         LkEWUE5+fqklkEs31mKtcApSpUAiLpM9IkCpHBdhltNiV8nBXmJVrFaWRacK/wfMSx+Z
         /8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705984757; x=1706589557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgFMB+Fl/yQd1An5JZ5ltxKrtrLEdjWDDdss81Dhky0=;
        b=Dm4E70BRCJ0vaVqhzzqhM3URFcH6+ojNg25uqWXA6WHeUV3v1AHtflpH7onjLgPLFM
         vdWHshHVQABBypgo+rkx3hfmQbj+n6x/tmlacKT+Es47SHGK8cF0Dg/YWcUCWnyE5bJr
         cYTj0CcCaSkqTBHAeIW4rIGdptE0ldmjxfNT4ABLZ3QIAwVhuFrrM2PWa1klg8Pfg/8d
         MYWA9sFKf6sArR/fKJfrCmhV0UVTKtsrFX8GOx+TaUtjwRVt+iJZBX4p2adRJea57AY+
         YQP915Lm3VjJIHv+mk7MdQIeLbCoVMDbAHaxtfZ3slLMae1IZGKRN3dP4RixkFGysiTt
         6D2w==
X-Gm-Message-State: AOJu0YxXdfxpbbmBad5z/WR5F97uyeMOM6Qla5qeXBM/SUrFSRyPM5Vo
	E9K2fuSlCjLKsoB+Iiw4GFyZdOsy2od8Nt3apBxkLZEiDCWhu0F+OHgfWTJHXfAQ/V1KASNblTa
	HDmkzcIab7TSCX8Feai0ZasBmMS4=
X-Google-Smtp-Source: AGHT+IGyIXRQFmIkTdFcN2b0EhRb/ndKKj9o3H2wm4TfsheeacqJqH61IxUbE68eGZ38WCT2JZnKqFecXbARw9YesX0=
X-Received: by 2002:a19:2d1c:0:b0:50e:3c2a:837a with SMTP id
 k28-20020a192d1c000000b0050e3c2a837amr1081211lfj.204.1705984756704; Mon, 22
 Jan 2024 20:39:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com> <CAH2r5mtA2v85xZL3Q+xM3==JDBCjZmyWGhfPZijosQbA3wJavw@mail.gmail.com>
In-Reply-To: <CAH2r5mtA2v85xZL3Q+xM3==JDBCjZmyWGhfPZijosQbA3wJavw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Jan 2024 10:09:05 +0530
Message-ID: <CANT5p=r2GJ4vAYcc9EknGGzMYq87xzZXXXq-n2r5f79P274p0g@mail.gmail.com>
Subject: Re: [PATCH 1/7] cifs: handle servers that still advertise
 multichannel after disabling
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 21, 2024 at 9:32=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Has a duplicate label warning that I corrected by removing the
> following part of patch 1
>
> @@ -441,6 +439,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>         }
>  skip_add_channels:
>
> +skip_add_channels:
>         if (smb2_command !=3D SMB2_INTERNAL_CMD)
>                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
>
> On Sat, Jan 20, 2024 at 9:33=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Some servers like Azure SMB servers always advertise multichannel
> > capability in server capabilities list. Such servers return error
> > STATUS_NOT_IMPLEMENTED for ioctl calls to query server interfaces,
> > and expect clients to consider that as a sign that they do not support
> > multichannel.
> >
> > We already handled this at mount time. Soon after the tree connect,
> > we query server interfaces. And when server returned STATUS_NOT_IMPLEME=
NTED,
> > we kept interface list as empty. When cifs_try_adding_channels gets
> > called, it would not find any interfaces, so will not add channels.
> >
> > For the case where an active multichannel mount exists, and multichanne=
l
> > is disabled by such a server, this change will now allow the client
> > to disable secondary channels on the mount. It will check the return
> > status of query server interfaces call soon after a tree reconnect.
> > If the return status is EOPNOTSUPP, then instead of the check to add
> > more channels, we'll disable the secondary channels instead.
> >
> > For better code reuse, this change also moves the common code for
> > disabling multichannel to a helper function.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2pdu.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 288199f0b987..5126f5f97969 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -167,7 +167,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >
> >         if (SERVER_IS_CHAN(server)) {
> >                 cifs_dbg(VFS,
> > -                       "server %s does not support multichannel anymor=
e. Skip secondary channel\n",
> > +                        "server %s does not support multichannel anymo=
re. Skip secondary channel\n",
> >                          ses->server->hostname);
> >
> >                 spin_lock(&ses->chan_lock);
> > @@ -195,15 +195,13 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >                 pserver =3D server->primary_server;
> >                 cifs_signal_cifsd_for_reconnect(pserver, false);
> >  skip_terminate:
> > -               mutex_unlock(&ses->session_mutex);
> >                 return -EHOSTDOWN;
> >         }
> >
> >         cifs_server_dbg(VFS,
> > -               "server does not support multichannel anymore. Disable =
all other channels\n");
> > +                       "server does not support multichannel anymore. =
Disable all other channels\n");
> >         cifs_disable_secondary_channels(ses);
> >
> > -
> >         return 0;
> >  }
> >
> > @@ -441,6 +439,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >         }
> >  skip_add_channels:
> >
> > +skip_add_channels:
> >         if (smb2_command !=3D SMB2_INTERNAL_CMD)
> >                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
> >
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve

Please ignore this one. I'll send an updated patch.

--=20
Regards,
Shyam
