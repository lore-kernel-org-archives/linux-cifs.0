Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38CD477E5D
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924437; cv=pass; b=YqVa3ZH66CeY0NPAoIyQQaDs9QeMeXxqu/ubGRo+Ysjg/jOidyp4OxcZRzEJ5ro7Ndhdf2Tn4UeejeGLZd4ZMC9a9KvJsZm4/MTPdifdU08zBQa3LMlHBJkoZZrELXON5AtGtxWB1CHiZT+ux4sA+L6K6fEED9B/UipbZaJ8mFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924437; c=relaxed/simple;
	bh=6WGjy/MDqAPwoUHtLdbrKYEHGiyvyJlKOG3epR239kI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hMcTEuP8d82f8/LjrHdKjmnE0ywwtN6dnb3ngLlGhqYxpiHd6JjLhp2tRfiyJbWQwlHqqEXJifc4D1yqMLCQVDendm8YyCVQZl08VzA03iAYAKSIW+0Mia0FnbbXWI6slO1hQxmhQQ6gaPOrOnmsIm5xf15C0IZgFllb6ANgV0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4feXn3K; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4feXn3K"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b86f69bbe60so864953066b.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 07:53:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768924433; cv=none;
        d=google.com; s=arc-20240605;
        b=AGHO2vSN9Z+VINOOgJQVWMnBaw0vAZGJECrnGAevL7P5nNh6E40YRicAlulLqglGNm
         hC9zekV8yIglXWU8FmlVi+xzd+MGPzeKb0UdKJVXhfDlF+sOZc7pKCfkzDGkZGrjtJhG
         FU5So2KKlWJH9FppKrT5EQ4m+GcPTzo124wB2iFcB2nMtBkNF13PuHcMsN65MsEjX+ia
         Y2cqAsG2QV/DXaYljC1myqiSMLJSXur/M4ZhOb+KL9Z+WjSn2OV/7Wc8i1stLhNHbfga
         qdFZKegHm6j4kyJNHewi8WvkCyl+VEIFDT0MtpJ0Nn+YE0+u9NBsX+Y2bpWvxW212Vkw
         OS+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W6HCb/o0H/gI7OzTdZtLzpDb9mEo4Ku2JR+Fd/tOEsU=;
        fh=ZRg3by0+DuXE5UFowmZ+gYBElUse2HJLilGpb1ckRxQ=;
        b=YI3hpxo6bEOPr/WbvZ+EJ5npORY8pp/rhRJxzPB0/2K2tY4VQxH6+ncy0HO3dKCTf6
         zZ9YgRHozhJbFaXyPqXwDaelwG8CioQDzEsioaleenxrEf412TBwzrnPOAGuWbgN5b7Y
         +EcphmBDTppCfF2TMls8/GaBY20Z5tkVaLXTlcCpJtbKOS1HotffUCPn0gCcNBh8eSxp
         U+3hxmJqiKYP/XpxDjRCu+hgkNRqPndDRkoTiVM9BlnowU8ojkroOJSYTylgZEdHGYgX
         C9/MF2SiR4xg12DqXsR91sK/2/kvEePnLEPI9JTsdxQE5gGEEun09CoutrwKv2cI45B4
         DCVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768924433; x=1769529233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6HCb/o0H/gI7OzTdZtLzpDb9mEo4Ku2JR+Fd/tOEsU=;
        b=b4feXn3KTT3UEFlGY2uvGewl/3HGxrWLkf2LuK/dGgm4lhaMBATbiuKcHiUljgtY37
         TQZWwuUbWblZqTfg7FwA5NDroUN+MYWJiESCz7zalV/A0l6MeJolDnnE/GBvMiiNcFaf
         jarynsxfbtMESmfeqQ6KhDYDr4qUvrj66X6xVFr7toUocuVhdjAt0Yba0qQZk8BaAd4R
         RJVfz3XOZ8cWIctlKRdVEd3pudLwFA02IvynrwKj+qI7QmX/eyOOfll43odtVgbAwZN5
         r+ebJIj3PZrS/FuY1eu1vwnZ2t4wvxWjX2D/j5SxQfw4+uo+3dlHiT+18Hw6nCqHhw6Z
         nYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768924433; x=1769529233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W6HCb/o0H/gI7OzTdZtLzpDb9mEo4Ku2JR+Fd/tOEsU=;
        b=rYMVd0ruJTCldgaqsnRGcEDWoGyqyVZwtnEsoJBYihF4dxZlkA/d0IIqeoStsRtyDf
         CzPJbpkF2XzXBad8+MYTGBcM2GQ9Kthj4HDX10uv5uTPmmQK6PxjR0giJQPmugHS1R3a
         yu/VS9GUyQC62mEwno1xoXn6WzNiNt+C27g+Z0xtoB29HHeBKlBzb6lWCNVSNwG9LJ4w
         j/k61ZeavFvtFJX1ALNZxWWzTCam6vjbmRbUCserAp36/tFmALloATjxnMnhtASnaagP
         e8zEth2KnoTQ5SwFpWbC0Ou9etP89K97ePziSkfzxo1N7m2eiZx9Wn0Ey2jgFcCGPlZY
         bdoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5cP2pkm384mbkNPnhQUK7FIcQAnXpbYMTDX/p7o4/Lq2IOZMcXsYxc4eVoMLnVSVgLZeFZAWnbqsy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywna/rLmXZDuvdsWeEdavvSnnRkZeo+LE/5VY/qyv9a+66eIqI4
	BGVBvK6XE5FfxmKUoh5Gg6H3hQpm8/eFj9ZZ0rSLb6Y9q2B5Vm+p4IMhUoZ8pbdzm/lJg6bv0Za
	KSJQ8o/AGMbJiEnD6vFMi4xHfI54XlTo=
X-Gm-Gg: AZuq6aI3B6OWzUgHJJ9fN/R9lYT14b29TQpRyyr7XxN/kOPWvjzzreD+iMiYKxakteY
	olcHYzMtxkNADUFasmCapD98OsUtMHJKovnlj96IodVnzhUNs88HpKHYX4EGnaUSYmAkidKhMTW
	uDonNJPUDK/1k/BNZEfCGTpzV7WrIDmue+S+noLN6EWT7a3cnHATO9hTWKRr6ODqjd3YkjmEH0p
	iCL8Yt6jE9aXZ28N84Qc2HpRMnvNJvgZjhwnm1+SOYN90/YbErcJaeCLLsv6bVHblyYQw==
X-Received: by 2002:a17:907:7285:b0:b87:892:f440 with SMTP id
 a640c23a62f3a-b8796afd621mr1300588166b.38.1768924432729; Tue, 20 Jan 2026
 07:53:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
 <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
 <CANT5p=oLDiauPjeOV-4FNxB-oiu+_p5r=AbrK7V--kOZBcAncA@mail.gmail.com> <eqzvsoomaa7wtsv5zwnelaziv3dlb7oxggc4cw2gn4nj4mwosv@h27txgrld4et>
In-Reply-To: <eqzvsoomaa7wtsv5zwnelaziv3dlb7oxggc4cw2gn4nj4mwosv@h27txgrld4et>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 20 Jan 2026 21:23:40 +0530
X-Gm-Features: AZwV_QgCRcPpZua2iaFuOR2uCmQ9Bsjv5X5BXSG8K6ypCm1rHz69gAkwmetS1AA
Message-ID: <CANT5p=pFdcROqgAdjYJGBB1XV4uFseomOF9sdvZtOJhUGz4Vxg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 7:43=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi Shyam,
>
> On Tue, Jan 20, 2026 at 09:01:00AM +0530, Shyam Prasad N wrote:
> >
> > Hi Henrique,
> >
> > I reviewed this once more. Now that the adding channel logic is async
> > I'm concerned that there maybe a possible race with adding a channel
> > to ses->chans array before it is fully ready.
> > Earlier this would not be a problem since channel additions were
> > synchronous. Now that it is async, we want to make sure that the
> > channel is fully set up before it is added to this array.
> > We do not want cifs_pick_channel to pick a channel that is still not
> > fully initialized. Can you please look into this aspect?
> >
>
> I think we are safe here.
>
> In cifs_pick_channel, we iterate over the channel indexes, from 0 to
> ses->chan_count - 1 and we pick only the good channels, meaning channels
> not set to terminate or !CIFS_CHAN_NEEDS_RECONNECT -- all this guarded
> by chan_lock:
>
>         spin_lock(&ses->chan_lock);
>         start =3D atomic_inc_return(&ses->chan_seq);
>         for (i =3D 0; i < ses->chan_count; i++) {
>                 cur =3D (start + i) % ses->chan_count;
>                 server =3D ses->chans[cur].server;
>                 if (!server || server->terminate)
>                         continue;
>
>                 if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
>                         continue;
>
> So in order to reach a channel we have to increment ses->chan_count and
> set the chan as not needing reconnect.
>
> Channel addition is done by cifs_ses_add_channel inside
> cifs_try_adding_channels. Inside cifs_ses_add_channel, ses->chan_count
> is incremented in the following code
>
>         spin_lock(&ses->chan_lock);
>         chan =3D &ses->chans[ses->chan_count];
>         chan->server =3D chan_server;
>         if (IS_ERR(chan->server)) {
>                 rc =3D PTR_ERR(chan->server);
>                 chan->server =3D NULL;
>                 spin_unlock(&ses->chan_lock);
>                 goto out;
>         }
>         chan->iface =3D iface;
>         ses->chan_count++;
>         atomic_set(&ses->chan_seq, 0);
>
>         /* Mark this channel as needing connect/setup */
>         cifs_chan_set_need_reconnect(ses, chan->server);
>
>         spin_unlock(&ses->chan_lock);
>
> Notice the channel is marked as needing connect/setup and that is only
> unset inside cifs_setup_session when the setup is successful.
>
>         } else {
>                 spin_lock(&ses->ses_lock);
>                 if (ses->ses_status =3D=3D SES_IN_SETUP)
>                         ses->ses_status =3D SES_GOOD;
>                 spin_lock(&ses->chan_lock);
>                 cifs_chan_clear_in_reconnect(ses, server);
>                 cifs_chan_clear_need_reconnect(ses, server);
>                 spin_unlock(&ses->chan_lock);
>                 spin_unlock(&ses->ses_lock);
>         }
>

Sounds good. I didn't have a failing case here. Just wanted to make
sure that we've accounted for this scenario.
You can add my RB to this patch.

> Now, I've noticed more than one issue in cifs_pick_channel...
>
> First, we seem to allow channels in reconnect to be picked, which is
> wrong. Second, we don't check if start is actually a good channel when
> we round robin. Do you agree?

in_reconnect isn't relevant anymore. I was using it to make sure
multiple session setups aren't taking place in parallel. But later
realized that we have cannot avoid session_mutex for this.

>
> But these *are not* related to this patch and should be addressed in a
> different patch. If you agree I will create a fix for it.



--=20
Regards,
Shyam
