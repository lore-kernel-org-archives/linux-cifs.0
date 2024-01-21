Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7580B10942
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705809744; cv=none; b=KQjvIWLGmOUWCUb1PcRhZQtHvr3Sv8bhE2rGW+5foyW/MMd+r65+/092pzMnMtHX7ebVeO5P66G9eFGew3oWDx1VEbLR51WZT6BF+kmXL4AP2VGoJT5rTRF8SLg2sTmofps1XGsjve1lszlsaiLrEaMN8+t2ITRJ+djIykqCEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705809744; c=relaxed/simple;
	bh=1QlyCmOMKCp0Qpr7B4XcgkKXlli0iUmZ3BsqTOGBJKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=joZAz7tSvClxlkK0/M39wdi45gvNUH2y5m+LrIVm9XWxuPMUwx3gDycQkSM8tTHzh1oGJA8bcvn4Q5NOP+Q5R0RPMpv44oSckIryTsRfw7FNa8A8k0BbpgKeHflIIMDuSJpVjrl6HtWkF7Es86y/muaepTvsH83Nf6Pl6ys94mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ibbe+3wk; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ibbe+3wk"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50eaa8b447bso2265777e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 20:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705809739; x=1706414539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdWPMRwyjoupAxeJlgXvtxYEdJrsKiqF1xDA2xizCo8=;
        b=Ibbe+3wkn9eJudD1qSZE4ZDs0UmEp+TfcMUq8nidp0rou8FQWQbh5heaKTPj3jEo/K
         IAIFK0oiNb8BAvugb81Hj9qtiOuri878IV4KOiUOdslkN/l8e9y3iGnxWzMy74QUMHGn
         LJLrgCXZXM47K53AL5oedNSh3qYIezQ9mtEwL5iNn68WQa6FphOPUzwpA0BfFdG+rqVP
         eKWVe53MafHKSWZqyxpLI5sUEWB2KS0xmwCi55lWUeqlaqAgKP5HJGVXJQv1ckO+mtIf
         +jfO/KNX7e5lLwr3iKMH11ozTouA1EMnNGCm+nZ2MqLkBv5WRkDDCjNvyLm4l6e0sUdp
         JlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705809739; x=1706414539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tdWPMRwyjoupAxeJlgXvtxYEdJrsKiqF1xDA2xizCo8=;
        b=gPayoEc0Q3xo4CrjMs9TE5YbmykVGycLhxmtn1S6rBBwHLBygVtdnrFC4kmdCy5kf4
         ibOd8N/TkdHory2Kd5B7/qT/d+71pPjSSEqu2xiP1XM2VEeqiojng0lOhn6iY+T3LpT3
         PEvC7IPZxCKKjK8+wmrdTHiWuHHE00OqtXSywWmTi5TlNZ776AyGDyhwxVftQXzU8YF9
         0j+yY/9EfHjI0tPlG2SB12LU6i4Q5dd3htigvwyrwKIBLIR/SyZ8dVRNLQ6lamNNvGmP
         lraIcIkVhyIfnTmD4ZAfpNClld46eqRrJhj/j4+k5FW7N+xpsrGv+ChvwMCLnVe8V8Cq
         VzkQ==
X-Gm-Message-State: AOJu0YwMhDp5Eo6hJbAQFh6d2lh3IPbr/SO28ih47LwfZUz3zHwsRoJ9
	lWiF3Nw7vCFhLv7f7tWUYfMYpt8aVpQAsEBNY3oqGVW/9TUgXdb1aMiacD4XPMcYNrOFeCockxY
	ZrgaLEU5I69XhGwJVchRN537vxgs=
X-Google-Smtp-Source: AGHT+IFjnCu9bd0+GtXZs1VqWb3Z6Ur2JAAS5tIPGmyVqKIQwEc1ZOKx93p8KAV5A9G9SJs3L6MhLC0DoFN4fMthJKQ=
X-Received: by 2002:a05:6512:110d:b0:50e:80d3:55f3 with SMTP id
 l13-20020a056512110d00b0050e80d355f3mr415415lfg.124.1705809739291; Sat, 20
 Jan 2024 20:02:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com>
In-Reply-To: <20240121033248.125282-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Jan 2024 22:02:07 -0600
Message-ID: <CAH2r5mtA2v85xZL3Q+xM3==JDBCjZmyWGhfPZijosQbA3wJavw@mail.gmail.com>
Subject: Re: [PATCH 1/7] cifs: handle servers that still advertise
 multichannel after disabling
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Has a duplicate label warning that I corrected by removing the
following part of patch 1

@@ -441,6 +439,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *t=
con,
        }
 skip_add_channels:

+skip_add_channels:
        if (smb2_command !=3D SMB2_INTERNAL_CMD)
                mod_delayed_work(cifsiod_wq, &server->reconnect, 0);

On Sat, Jan 20, 2024 at 9:33=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Some servers like Azure SMB servers always advertise multichannel
> capability in server capabilities list. Such servers return error
> STATUS_NOT_IMPLEMENTED for ioctl calls to query server interfaces,
> and expect clients to consider that as a sign that they do not support
> multichannel.
>
> We already handled this at mount time. Soon after the tree connect,
> we query server interfaces. And when server returned STATUS_NOT_IMPLEMENT=
ED,
> we kept interface list as empty. When cifs_try_adding_channels gets
> called, it would not find any interfaces, so will not add channels.
>
> For the case where an active multichannel mount exists, and multichannel
> is disabled by such a server, this change will now allow the client
> to disable secondary channels on the mount. It will check the return
> status of query server interfaces call soon after a tree reconnect.
> If the return status is EOPNOTSUPP, then instead of the check to add
> more channels, we'll disable the secondary channels instead.
>
> For better code reuse, this change also moves the common code for
> disabling multichannel to a helper function.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2pdu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 288199f0b987..5126f5f97969 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -167,7 +167,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>
>         if (SERVER_IS_CHAN(server)) {
>                 cifs_dbg(VFS,
> -                       "server %s does not support multichannel anymore.=
 Skip secondary channel\n",
> +                        "server %s does not support multichannel anymore=
. Skip secondary channel\n",
>                          ses->server->hostname);
>
>                 spin_lock(&ses->chan_lock);
> @@ -195,15 +195,13 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>                 pserver =3D server->primary_server;
>                 cifs_signal_cifsd_for_reconnect(pserver, false);
>  skip_terminate:
> -               mutex_unlock(&ses->session_mutex);
>                 return -EHOSTDOWN;
>         }
>
>         cifs_server_dbg(VFS,
> -               "server does not support multichannel anymore. Disable al=
l other channels\n");
> +                       "server does not support multichannel anymore. Di=
sable all other channels\n");
>         cifs_disable_secondary_channels(ses);
>
> -
>         return 0;
>  }
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
> --
> 2.34.1
>


--=20
Thanks,

Steve
