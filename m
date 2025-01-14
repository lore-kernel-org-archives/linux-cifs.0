Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44150145A07
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736869952; cv=none; b=DGTf33UpRHQjD21M82IElsrTuze8woDGKNFMsOD8KazI28ctghuWOn5rKpxYs71tmPxbjuthfyrmj1hfnpzE3AyHlZPJy1AjTIbnW2JY0mpuB26sSR95nXZFE8sw4rWjwJbA/z0m9BdCHYn1p1kpw6sDXZ2TVdWObaj31DVNCjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736869952; c=relaxed/simple;
	bh=6G2gKBheSdl4Ym4Ji3sytMwLGTl9xFnhGtLgCAlWXAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gj2nQRkQvEKKiYnNlrJ6o635NL1ZX671s59N3HbM52o77ON5l8pT5bESfLLYVOYOGO1q/vX8kw8hW6FpCJSMVPi8hB1cLyzQud9KWm3/AWgrZ/dTxIep/f/LgjQqjFUy/B3tsjCt6IPwh0TzAwMEVLsIoYHXCn+nMvKrd78mk1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I3HNl3fQ; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3HNl3fQ"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54263b52b5aso5746713e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 07:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736869948; x=1737474748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/IyC9lquH90c4uVUVAWyQRf1/IYWxQssdBfH8JHNPs=;
        b=I3HNl3fQolTNRwDcQE3cAnt4wRucONuFUWV5hsyp0TH1Qry/52b3ugiE86ese3881x
         5sbEfxTvO88MwBDGUDBDMogpRm5QjpIgm61dAWlIasYMqbdrJhGsKe1cWPcI6afPgZqf
         kwRuQpjTAo3Pzao7kccc/v7n5ydFtSHonxFs1ZpNa0+ePVjeLW31NUoVpqUpxPkY3NVC
         1F3ln8xC1Z9b1wV9HaJLfVkvwqVMUJfp4ybQB56mF+86FPOnAnG2BnsW5EZkHAxccsoH
         rcGCJL3hSaQtO+rI5m1ONsIqlr6zFWzcMe95AAE89Bbask3Gu0HqpTkZzHsT5vf14oNe
         kr1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736869948; x=1737474748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/IyC9lquH90c4uVUVAWyQRf1/IYWxQssdBfH8JHNPs=;
        b=EIsYvCU0/6zmcb6UY3CFu7gc4ddu/jN7EA7yv5P/9jtFB+KRcPbpODbr9Am6XFdQIL
         iehn3SrzUpVe1ALJ2XBw/BhCk0/f0OloI5KGeyBKaTdsOf04rm9tTr+/mrVDc2IflkeU
         kdfSldp5HoFSUa122FyYvZQbDVCEBobs57wNFYuoXof2tqdgYxEhEUucdSm3zMRO47zP
         OSiXHHzUlg5noKElQOfLoSDJS/+di9pYX1EE7FpJDL2nTvE6ZNBfAW9xCN7Y8eAo1eXt
         xawncwPjUXOEeZy/mRApsh/SvxM4VijxHJdXw6IexNSDwC9XeAp5V6mo2KxUiMrWytLe
         UUtA==
X-Gm-Message-State: AOJu0YzDDWyIAw7np3WoR0+a85mByaguHTW/bN50Umt+OhUbE8CwAIX9
	hXPtPy3zjhvQtB0mdFm0hRSZB4GAOSJZNioUc6SnsCUEeCZhzwxkNTlPnor/GjVrRrCPb90YHod
	vpOOwVw+7RNSMTBEVxSZouF89ugOpKw==
X-Gm-Gg: ASbGncsUTYdTqaYZiZ39howkFqtWVZ2fH14Wr3JJ4k4xr1ZHKQo0zWntTHLWX8iAOsq
	sWJCOo7gCZiiZPxlOF0mr9ZrCVheREEpx4jeiSyEEQWVvARLXaWBK+q/kbZNUf9eFxhnGuRKV
X-Google-Smtp-Source: AGHT+IEl3zPgTNvPGcgUz7NxPHbU863fOGSpyan4Gj+L7ikVmgJSuf+WmtPzKauv7pSymbA1FCEdgTNeJbNeKpg3kf8=
X-Received: by 2002:a05:6512:3d16:b0:53e:3a9d:e4a with SMTP id
 2adb3069b0e04-542845af718mr7815558e87.10.1736869947767; Tue, 14 Jan 2025
 07:52:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114154848.43584-1-pc@manguebit.com>
In-Reply-To: <20250114154848.43584-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Jan 2025 09:52:16 -0600
X-Gm-Features: AbW1kvbACg5Bq7BYBri76MmA_8Or9D3SWtCpKLa1JfMXca_bFap_Fy3UMl9oVSo
Message-ID: <CAH2r5mt_zvYcbKcYZe=P5dPzrMoXLkjwk20TOtqxSedu6aCXwQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix double free of TCP_Server_Info::hostname
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Jay Shin <jaeshin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending review and testing

On Tue, Jan 14, 2025 at 9:48=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> When shutting down the server in cifs_put_tcp_session(), cifsd thread
> might be reconnecting to multiple DFS targets before it realizes it
> should exit the loop, so we can't free @server->hostname as long as
> cifsd tread is done.  Otherwise the following can happen:
>
>   RIP: 0010:__slab_free+0x223/0x3c0
>   Code: 5e 41 5f c3 cc cc cc cc 4c 89 de 4c 89 cf 44 89 44 24 08 4c 89
>   1c 24 e8 fb cf 8e 00 44 8b 44 24 08 4c 8b 1c 24 e9 5f fe ff ff <0f>
>   0b 41 f7 45 08 00 0d 21 00 0f 85 2d ff ff ff e9 1f ff ff ff 80
>   RSP: 0018:ffffb26180dbfd08 EFLAGS: 00010246
>   RAX: ffff8ea34728e510 RBX: ffff8ea34728e500 RCX: 0000000000800068
>   RDX: 0000000000800068 RSI: 0000000000000000 RDI: ffff8ea340042400
>   RBP: ffffe112041ca380 R08: 0000000000000001 R09: 0000000000000000
>   R10: 6170732e31303000 R11: 70726f632e786563 R12: ffff8ea34728e500
>   R13: ffff8ea340042400 R14: ffff8ea34728e500 R15: 0000000000800068
>   FS: 0000000000000000(0000) GS:ffff8ea66fd80000(0000)
>   000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007ffc25376080 CR3: 000000012a2ba001 CR4:
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    ? show_trace_log_lvl+0x1c4/0x2df
>    ? show_trace_log_lvl+0x1c4/0x2df
>    ? __reconnect_target_unlocked+0x3e/0x160 [cifs]
>    ? __die_body.cold+0x8/0xd
>    ? die+0x2b/0x50
>    ? do_trap+0xce/0x120
>    ? __slab_free+0x223/0x3c0
>    ? do_error_trap+0x65/0x80
>    ? __slab_free+0x223/0x3c0
>    ? exc_invalid_op+0x4e/0x70
>    ? __slab_free+0x223/0x3c0
>    ? asm_exc_invalid_op+0x16/0x20
>    ? __slab_free+0x223/0x3c0
>    ? extract_hostname+0x5c/0xa0 [cifs]
>    ? extract_hostname+0x5c/0xa0 [cifs]
>    ? __kmalloc+0x4b/0x140
>    __reconnect_target_unlocked+0x3e/0x160 [cifs]
>    reconnect_dfs_server+0x145/0x430 [cifs]
>    cifs_handle_standard+0x1ad/0x1d0 [cifs]
>    cifs_demultiplex_thread+0x592/0x730 [cifs]
>    ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
>    kthread+0xdd/0x100
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork+0x29/0x50
>    </TASK>
>
> Fixes: 7be3248f3139 ("cifs: To match file servers, make sure the server h=
ostname matches")
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/connect.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ddcc9e514a0e..eaa6be4456d0 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1044,6 +1044,7 @@ clean_demultiplex_info(struct TCP_Server_Info *serv=
er)
>         /* Release netns reference for this server. */
>         put_net(cifs_net_ns(server));
>         kfree(server->leaf_fullpath);
> +       kfree(server->hostname);
>         kfree(server);
>
>         length =3D atomic_dec_return(&tcpSesAllocCount);
> @@ -1670,8 +1671,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server=
, int from_reconnect)
>         kfree_sensitive(server->session_key.response);
>         server->session_key.response =3D NULL;
>         server->session_key.len =3D 0;
> -       kfree(server->hostname);
> -       server->hostname =3D NULL;
>
>         task =3D xchg(&server->tsk, NULL);
>         if (task)
> --
> 2.47.1
>


--=20
Thanks,

Steve
