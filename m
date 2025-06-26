Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B22433D1
	for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 03:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750908655; cv=none; b=CoAO85Ip1as94jC91z0jpHCzkEO64pYpm6Rl9Z8+m9hAYi6PtNUewE1grzFTHATRcuCTWb3gfuLAIU5P+LgAhH8WjsMQ/fGUQr3Bfnu9JlxbJW/HPL7HubY2blvOdYktOl1CTWDjsvipt3KRlOFm7BhBz9mZKrX4DD04BjCyDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750908655; c=relaxed/simple;
	bh=RtG3iI7KcE0pYW3/wWoZ5Kup4mad7Ue9DF2yadOC3Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G9VFAu0LkZYTNXAEWESEQ2Ww/742W77ddSRfUwFRLI0V+p00FGke6BekLLU5wef6UiSsbrx1AaG62N2Uxs5fnaSPOO2MY9uPyO1Apf6Ey3kMv261aqHYro5zWqg01ozjmOXgwKJHM0/zc/UB2hQVyd/OoM+klTUFvQZRmwezkQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKVhsA16; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKVhsA16"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fadb9a0325so5818886d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 20:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750908653; x=1751513453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agq3iv8j7emG1SYp0WD9aGvyKItinPuaagLqVp8Lflw=;
        b=LKVhsA16Ct6xdZ5OPcc/x+b06AH6xSWA3DQ3pYJiPN0tOkXI/gr9Jmdz7aWjprCx6z
         MGVfgLGSWM7askARDb6VSkR5d73AOCtm/DzF55+gmGbwW+yeapFzsPM59/spe8j8IPDa
         hBycdcjpIvz77q6BdGFXQBvor2QADzCiSjNAYcqEgMMl+auEgwf2tJIYbcxWelVJU3LW
         EvvyzKDGPEm8yRHfQetTcs9+QPVZXU2rydy0/altaSAqRDt2yEObnPeNShUuJgL3pbO4
         UVSqgw/pIsPW5oYwOLRU9oJmFT81r/Itkei+8NN9HTs+Omb7jiMBSFOgaRRm0g7BkRtE
         bwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750908653; x=1751513453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=agq3iv8j7emG1SYp0WD9aGvyKItinPuaagLqVp8Lflw=;
        b=w5muwL5/HLg/Y1+alPwDDv+U/VrDzxiJQFphfLXczqrv5HjuyMLMNXgycCXcep1faQ
         pmglDtJA6P6L27woBgRxI/QAgoqN4jgHxwF37yoRKBGKo/JZ9C3Vc1FsHhVCpgy9s61o
         LUdXJ4qA0xxTamQ7bKgEOpkLyt4ECp4wzD2RimUKxQ71bOp76rtBWKpbYoLZt4ygTyzc
         mLjlkkN9sJlqVrLNb1t1V7AfOvRUk42jrvnBwqz0SET5x5lAP1JFm93j3sFQf8HgpQ0d
         SgnMw/elaBs57UwWR74W8ysyuL+i0qk4MoBFKK1m+8qLsZi9Gj3jfsv2h0/Emm+ZEqk5
         +FEg==
X-Gm-Message-State: AOJu0Yw4hdv7jrEjxPzDJz5/c13m4UaJq/DhPupKx8j40T2cHyaNsZyJ
	JzNU0kK2cahngrJrUU6SU+nCdb/OM2bq/cW3Sto0pY+ofXVBChQXS04P0s+N9CpCDggndavHLg0
	GsgAbArub5wtsEAzDyyYJrgmFs85/zBs=
X-Gm-Gg: ASbGncsL9ZHz9j7FPCIAMeybi8C4GQpz7/e7VZ85ahis78t2QbQmqpA4VFBbHEs206j
	f17TehP0tr79KHz3Lz5ZVraVo7xPTK87dHp0b9V4fNN4n77iHJ7DtNw2MP19sk77ff/NP9wbtNE
	98VDiXxABDQ0dExTVeN5vnKt30ML8lpw0ObTWhbwlu0DaJufqE/ml7FIpZZXv7j8Yv2nESb7sER
	YKAj9L0zyIhPw+G
X-Google-Smtp-Source: AGHT+IE1Xqtkew9Grgup0KF9YT6PIGqtfC/OwGMxvwquPEwPgMje5DIOu1RswMtZwfPWPKWYct4/1dwBZZNXRCgyS0g=
X-Received: by 2002:a05:6214:2aa8:b0:6e4:4274:aaf8 with SMTP id
 6a1803df08f44-6fd5ef76261mr83196026d6.17.1750908653027; Wed, 25 Jun 2025
 20:30:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvHYB91=HU2NMUbinpXTWzKq82RXhRMiAPwSa-u5c6x7g@mail.gmail.com>
 <CAH2r5ms2xfU0dSrkLbVUKsN5mH1r0re=6134oH4eETtqYOLaUg@mail.gmail.com>
In-Reply-To: <CAH2r5ms2xfU0dSrkLbVUKsN5mH1r0re=6134oH4eETtqYOLaUg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 22:30:41 -0500
X-Gm-Features: Ac12FXy7AR5fqsS2qylCs4dxU8f1eePpovshBGMHYhi_GnwTuKTeF9lUKcU7_v4
Message-ID: <CAH2r5msEafHhEvmKKAp0Rn2OZjRtgEgeqL_P3F9oL8cBK0tj+g@mail.gmail.com>
Subject: Re: build warning with [PATCH] smb: client: set missing retry flag in
 cifs_readv callback
To: Paulo Alcantara <pc@manguebit.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Actuall warning goes away when I remove this patch:

3556a6e915cf (HEAD -> for-next) smb: client: fix potential deadlock
when reconnecting channels

On Wed, Jun 25, 2025 at 10:05=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> I also get the same warning building with David Howell's netfs-fixes bran=
ch:
>
> connect.c:144:1: warning: context imbalance in
> 'cifs_signal_cifsd_for_reconnect' - wrong count at exit
>
> dc9b2fe5f874 (HEAD -> netfs-fixes, origin/netfs-fixes) netfs: Update
> tracepoints in a number of ways
> 4d2f067052f8 netfs: Renumber the NETFS_RREQ_* flags to make traces
> easier to read
> 9ee1c1860c95 smb: client: fix potential deadlock when reconnecting channe=
ls
> ecd66e4e1009 cifs: Fix reading into an ITER_FOLIOQ from the smbdirect cod=
e
> 7aea400b3ab2 cifs: Fix the smbd_reponse slab to allow usercopy
> db6c446f962b smb: client: let smbd_post_send_iter() respect the peers
> max_send_size and transmit all data
> e7878f222221 smb: client: fix warning when reconnecting channel
> 9006c79c12bd smb: client: fix regression with native SMB symlinks
> ac6518c40791 smb: client: set missing retry flag in cifs_writev_callback(=
)
> 79548ed9b3b5 smb: client: set missing retry flag in cifs_readv_callback()
> 020ea6c76c4e smb: client: set missing retry flag in smb2_writev_callback(=
)
> 5a2221d576f1 netfs: Fix ref leak on inserted extra subreq in write retry
> b2e88c77791d netfs: Fix looping in wait functions
> 5a5ec8260ee9 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
> flag wangling
> 4a5175d393e3 netfs: Put double put of request
> 76a8fb1fdfd4 netfs: Fix hang due to missing case in final DIO read
> result collection
> 86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3
>
> On Wed, Jun 25, 2025 at 10:02=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> >
> > I get the following build warning with the patch:
> >
> > connect.c:144:1: warning: context imbalance in
> > 'cifs_signal_cifsd_for_reconnect' - wrong count at exit
> >
> >
> > commit 8596d54298d3170badcfda1175499ad3af240d09 (HEAD -> for-next,
> > tmp-fn-6-25-25)
> > Author: Paulo Alcantara <pc@manguebit.org>
> > Date:   Wed Jun 18 15:22:27 2025 -0300
> >
> >     smb: client: set missing retry flag in cifs_readv_callback()
> >
> >     Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq nee=
ds
> >     to be retried.
> >
> >     Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
> >     Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> >     Signed-off-by: David Howells <dhowells@redhat.com>
> >     Cc: Steve French <sfrench@samba.org>
> >     Cc: linux-cifs@vger.kernel.org
> >     Cc: netfs@lists.linux.dev
> >     Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> > It is built on:
> >
> > 50fa8c47b1e4 (HEAD -> for-next) smb: client: set missing retry flag in
> > smb2_writev_callback()
> > 37743a9b6195 netfs: Fix ref leak on inserted extra subreq in write retr=
y
> > 3a335ade2c4e netfs: Fix looping in wait functions
> > 827cb4d8a936 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
> > flag wangling
> > cf9167613953 netfs: Put double put of request
> > 0f05eeb631a6 netfs: Fix hang due to missing case in final DIO read
> > result collection
> > 3556a6e915cf smb: client: fix potential deadlock when reconnecting chan=
nels
> > e97f9540ce00 smb: client: remove \t from TP_printk statements
> > 1944f6ab4967 smb: client: let smbd_post_send_iter() respect the peers
> > max_send_size and transmit all data
> > ff8abbd248c1 smb: client: fix regression with native SMB symlinks
> > 86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
