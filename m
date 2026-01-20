Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044113128CF
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924583; cv=pass; b=KJzpHPaMWYwGWsvoBaAQVssrjpB4FRkDHbw02wxJyyi92WBfjNlo4hwwxYDd5fioJejTZ8d8T4nQ7gV4GpldSRXNM4zgNJbTKhTtbxPTbnf8Ftv3dHMNYIUt6OrB3HiIW7wi24JfHY7hUrgp4PTm2X+v1Rx52bt8ZJLJdkXuwOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924583; c=relaxed/simple;
	bh=ALmIwnORbq3GBneDW+fUIgGzQovxhB32fOhJ3pB2I7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khcn5EpkXv5aOFZ/XYvZICBaf5dkDqaNZaVpIyWBIuOUE9fpQSar7kL6KCtapGbTzNKzFAg+FX4dtv5a+ApMhsF9qiUMw+pOInhmFeaKg/puOG7X0ILe9yNhtVgdbQC1tyIB2e6xfgSg4l/7J7nGmrg9hn6kKILMn5pzhtA1p8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=apM5Yk+g; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="apM5Yk+g"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso787167a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 07:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768924580; cv=none;
        d=google.com; s=arc-20240605;
        b=J2r6Nn0jczQpsKYTYWsC1bVEZwfaKHJQdjOxu8J1wJFWBNJG5bMUjrUmzGD9zJ3aVG
         cwCVVj3SMyOxwZM3fazwQ3QP0Y2KiUtCQfLZiZv3/E5UZC/AdeZLAPcoV2D9ymEj3zGP
         ZX6oxl3fpTfCp3Qe4x5ZYkqPvo6b5kZTpSQWARTB/zGvMxoX035dTQPvg5IwEdgPJOKK
         C8kIMTAuONiUFcqTTQ4Qthu76nx7lFZ0293knoAMnKCqNkOYyZfV5bOgkraft/S//gJN
         BMsK1DIHktcDs1/5JARtF9V3XrKwGkOLSLzDfmws2iSBTCBiNSlqtVEcRxGskILCGyT4
         FMng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X0HkSYDbmJXhssJWYz+AoJvC8B1Zb1YDWUxlC9VEBdk=;
        fh=e1CnMMfbZ3JtvYtiVboCgCs/WryU8+XNnk1z1c6de+8=;
        b=jb5aa45RiDwC+ZKWKQ0TYB2oox8hSRTY+oZqsmPmFfNxub6Pzr1qFYNf4VYrGgJ2i3
         PynZ+2zDfPGXOBj2DSXjx3DOA6Q+fXB3UB0nCsH6t/owl0s6NF+VTZ6tyFWfniID6g5N
         M0c+7nnQAtFKyzEU8UEUiuCuFOocDq4d6F4wiZ9oiVBGE6VT9fvUhh1eIbPvmxNPBi/d
         OPmY8nL2g+t7lNs1RERvjmj4XvXOAXsPzuN8GpABE6k4MJP0GO1botwvnskMX7LV/tZM
         TaAiY76QsGvkhPyelQuC9qOz6hoaWG80wcAmI2XsY/41Mj5VJIXPVKq8mcEfPPjrs9WW
         sDYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768924580; x=1769529380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0HkSYDbmJXhssJWYz+AoJvC8B1Zb1YDWUxlC9VEBdk=;
        b=apM5Yk+gs8ipfR3ot5Loll9BQh9+5Hfat51wcpKYrYJTRBxMqGZNFSdOjw85r8eUCA
         rJAwOIuwSgjCeYZFp1Oo8PkhpLydkoQ6UgkDZwFaSvgfLR55ewLo/eJ3DtN0e7LcZFwa
         O969gMfhwrfA+boqekZW5mpeTLIWEMo6U0j8AylaK6qYM5fuix5u93uxU4ZWHyiLYvXP
         4Xppss0BOyI476gAjVHexQa4/UO0sI4aXAsw6qFhAk1b9kd1XFPNKfKCQvaPHnmhOhYE
         pJRmsFYPaE+B6+SQX+xQUlFqBlzJUtzvDePdF/Dl/z/Ii7AcmfPj1zliectoYqZKi8/0
         ssYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768924580; x=1769529380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X0HkSYDbmJXhssJWYz+AoJvC8B1Zb1YDWUxlC9VEBdk=;
        b=j8C65RJkLKJAhOoh1H6d0bAgGG5xveyqTINSbr3+bPHoTmKe4gx9B9/GXGvsmNSxmD
         0hAwXD4heeImXAxZHPyWQVixBTPkx33A9IlINjynFRo8O/YdaX9nkMIgG+82SxnMNrox
         pr0wIUR2j9l6+YlqPQlI8BNKV8wdZBJgZi4YQPpxxdVx4XPbBN/GrCP7GKxCXgXlKvi+
         bF9u3QGceokE2HSNdYLICr0OAefBJwQ9uLlRbTKtEIiSPmQd8RA+JdY5lM6Wu2KVA0Py
         YxWRNq9EBPIdCw5xM9VyVm1N513SyDPWHnjyk4etl+t0GDh1isfhLpapPtk0jDcDNPdp
         HV2g==
X-Forwarded-Encrypted: i=1; AJvYcCVP4jHXDzZQFylwU1lluJmmsOTgHhSy+76PmS5NQ/VsXXtmk9W8dEy0460EgGjIDnmt3lDhCYnkXHAt@vger.kernel.org
X-Gm-Message-State: AOJu0YzrIZv3icVgnsMOicFk9rFmnmakeBZLTvhreoC2aoG4KvSe9lsa
	6pKWCQFrDkrXzzhOzwGj1fYeAd548RN5uVFCSm53/ZWObsucySarGOAdhPOqCAlPOEQWXKNvhEN
	uUam66KyhjlDmBOJq7q+294pAT29PEeU=
X-Gm-Gg: AZuq6aImBJjKu+lgYfJzMEqi58D0b9Sa+ZDNEyx0eHB9kcdbIXdufyG0mZNRWuk8vXx
	Xpdxw+WdHE37J9jZJ2fzl7R1nWm0ZjI/lNdaW3ckgGYO5qI6XuEBsgiBBfZYtXhF6amkaxIQL9u
	44PuqhxAKdQd+WpraMKKiPSWJbEW7ed9pPc7g3nbfltDlqT2pzBYO/TJ90M0PpTXpB2dnZeK5TI
	uAVyO51ng+mltFLQ/ukDXMkcPo1GWcx5qcaHVWB9DvoDEdPJShf46TG8DTxURLqeOAjAA==
X-Received: by 2002:a17:907:6d09:b0:b83:37eb:34f8 with SMTP id
 a640c23a62f3a-b879300b31cmr1191264566b.35.1768924579700; Tue, 20 Jan 2026
 07:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
 <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
 <CANT5p=oLDiauPjeOV-4FNxB-oiu+_p5r=AbrK7V--kOZBcAncA@mail.gmail.com>
 <eqzvsoomaa7wtsv5zwnelaziv3dlb7oxggc4cw2gn4nj4mwosv@h27txgrld4et> <CANT5p=pFdcROqgAdjYJGBB1XV4uFseomOF9sdvZtOJhUGz4Vxg@mail.gmail.com>
In-Reply-To: <CANT5p=pFdcROqgAdjYJGBB1XV4uFseomOF9sdvZtOJhUGz4Vxg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 20 Jan 2026 21:26:07 +0530
X-Gm-Features: AZwV_QhtSRp7eh7J_XHJNBa1iDA686shqnkpM2hvcGS7oN4t_r_VMA3DT-1HKU8
Message-ID: <CANT5p=poj=+Z=E-RdHfNwFUjFZrZE9RXGCug1ZOPQR6t2MruzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 9:23=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Jan 20, 2026 at 7:43=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > Hi Shyam,
> >
> > On Tue, Jan 20, 2026 at 09:01:00AM +0530, Shyam Prasad N wrote:
> > >
> > > Hi Henrique,
> > >
> > > I reviewed this once more. Now that the adding channel logic is async
> > > I'm concerned that there maybe a possible race with adding a channel
> > > to ses->chans array before it is fully ready.
> > > Earlier this would not be a problem since channel additions were
> > > synchronous. Now that it is async, we want to make sure that the
> > > channel is fully set up before it is added to this array.
> > > We do not want cifs_pick_channel to pick a channel that is still not
> > > fully initialized. Can you please look into this aspect?
> > >
> >
> > I think we are safe here.
> >
> > In cifs_pick_channel, we iterate over the channel indexes, from 0 to
> > ses->chan_count - 1 and we pick only the good channels, meaning channel=
s
> > not set to terminate or !CIFS_CHAN_NEEDS_RECONNECT -- all this guarded
> > by chan_lock:
> >
> >         spin_lock(&ses->chan_lock);
> >         start =3D atomic_inc_return(&ses->chan_seq);
> >         for (i =3D 0; i < ses->chan_count; i++) {
> >                 cur =3D (start + i) % ses->chan_count;
> >                 server =3D ses->chans[cur].server;
> >                 if (!server || server->terminate)
> >                         continue;
> >
> >                 if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
> >                         continue;
> >
> > So in order to reach a channel we have to increment ses->chan_count and
> > set the chan as not needing reconnect.
> >
> > Channel addition is done by cifs_ses_add_channel inside
> > cifs_try_adding_channels. Inside cifs_ses_add_channel, ses->chan_count
> > is incremented in the following code
> >
> >         spin_lock(&ses->chan_lock);
> >         chan =3D &ses->chans[ses->chan_count];
> >         chan->server =3D chan_server;
> >         if (IS_ERR(chan->server)) {
> >                 rc =3D PTR_ERR(chan->server);
> >                 chan->server =3D NULL;
> >                 spin_unlock(&ses->chan_lock);
> >                 goto out;
> >         }
> >         chan->iface =3D iface;
> >         ses->chan_count++;
> >         atomic_set(&ses->chan_seq, 0);
> >
> >         /* Mark this channel as needing connect/setup */
> >         cifs_chan_set_need_reconnect(ses, chan->server);
> >
> >         spin_unlock(&ses->chan_lock);
> >
> > Notice the channel is marked as needing connect/setup and that is only
> > unset inside cifs_setup_session when the setup is successful.
> >
> >         } else {
> >                 spin_lock(&ses->ses_lock);
> >                 if (ses->ses_status =3D=3D SES_IN_SETUP)
> >                         ses->ses_status =3D SES_GOOD;
> >                 spin_lock(&ses->chan_lock);
> >                 cifs_chan_clear_in_reconnect(ses, server);
> >                 cifs_chan_clear_need_reconnect(ses, server);
> >                 spin_unlock(&ses->chan_lock);
> >                 spin_unlock(&ses->ses_lock);
> >         }
> >
>
> Sounds good. I didn't have a failing case here. Just wanted to make
> sure that we've accounted for this scenario.
> You can add my RB to this patch.
>
> > Now, I've noticed more than one issue in cifs_pick_channel...
> >
> > First, we seem to allow channels in reconnect to be picked, which is
> > wrong. Second, we don't check if start is actually a good channel when
> > we round robin. Do you agree?
>
> in_reconnect isn't relevant anymore. I was using it to make sure
> multiple session setups aren't taking place in parallel. But later
> realized that we have cannot avoid session_mutex for this.

Just to be clear, when in_reconnect is set, need_reconnect is sure to
be set anyway. So cifs_pick_channel should skip such channels anyway
(after your fix got applied).
Please let me know if you find cases where this is not true.

>
> >
> > But these *are not* related to this patch and should be addressed in a
> > different patch. If you agree I will create a fix for it.
>
>
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam
