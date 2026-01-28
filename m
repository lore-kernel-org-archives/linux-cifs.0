Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80EF2EB87F
	for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 11:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769600801; cv=pass; b=LRKP1CxmrBKgbDGwnjQlcwlRRZ0zcpg9t9BjrtPJJsPNHrVsdPCcFdj9CIYRCFViBQXFgwVl0k2GSmNKFkkdNnW7TjizGjkzkQFLR/MXM0YiUXA4NujiYz9ZE2b4q3CshC0L0yQYc3aS//xXTAeygGVivxavL4okkYYE9XbFrxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769600801; c=relaxed/simple;
	bh=gkniRxAH/kVIbfYLQFZ8b7HWN1osd5tzp4jo9xBrwDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKeamdAvtCtCO1atFQuNv9S732L+z7fT/wlnsPxnvqiLrTlzYC6v5ULW4a5dQEvGxpX0Jr9/NaAiexJqX7Z0Oa0Dko5suiTQCIUIasGS9X892zEkP5FLddP336aJI2uSX2dIVKXeqTYy05jzmMU/7aDyaGg6TvJU0CHMz1P/b7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bI9W1HSg; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bI9W1HSg"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-658072a4e56so13026958a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 03:46:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769600798; cv=none;
        d=google.com; s=arc-20240605;
        b=cLrzgEkYfNc25C0JJafTRB/foLTpuEnHm6YZc9yIkgd685Bd/66ENcawURoyi70jWU
         g8qOkyFlynMrFEeYU+eBUROCLeGwdPl3YD0Vp5JOJ0ek6LZs2pBWsHpaahT9oAQfxLem
         kpqVFd+jrwRRP9RUlmMaVmPy8uhCSGwGX/BEQMdgiJRHpjERgsM9sdG6q4zYu2cMPvRD
         gnfi6aEW+AkXGY1ewcC24Rp1EOgzNDWFliq+K9M450E57Xg31jnE7jU+qN1N0bonNTBO
         pW/6bVPv9JW1L8xxD58trwWjUUpOJhK8GBwU59yUfFlQdvlllEHfNf61k+x3jj7pPS7U
         fzYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3yF3NMoCzCngWqVZDLZFlKCZvpQRN9oVej7BpWRpbWE=;
        fh=AGsgtC2MLrLj7ngz35iMyUaq1469d4wfFOg7l4Y+qoQ=;
        b=ew5qcjpxJcCSZpRxPUV4xFQ9F1FVvgCx5hmbS9fIgWx80fd9UFbV9VUinYF6y0O4Yh
         4BSS0RoCynpJnTffEEVZfi7QgnfwArAL5O8ihOG9lnM4uIBtXM5g+vK/FgPNm+ZwDysT
         wx4mjc4JpH7iXkBH0FKRvWCTz0ZzA4ZKj3/xHNldwH6zDdi1EtpcskFECQpx85ydC06x
         fsLcMeBKDKi0nuxAjrjq1TzGzQk5z3enc/sGybE/0y8dq5RajBTXGSYf77Xq15/uySYQ
         OWtl3SE5mNikk6eJzldXtqDyk4ZBnyYfb5MsnW8syOTSZSVRakquqTCytH5UWLGB6D2S
         WLfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769600798; x=1770205598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yF3NMoCzCngWqVZDLZFlKCZvpQRN9oVej7BpWRpbWE=;
        b=bI9W1HSgx74k99C5yuWgFpoY+7VuKl1WQf3SVRFA49TJz+IDNdmuxMY/ZBG+e1hwFB
         4FDMO/6U4hMNaUad28WN1IFjUsBKJ9uD/1r1xEjXpYnepOBqmhIv7vvpS8FesX4sbxvr
         jXqLEBiklKm8p+QQyBX1wPZKj75JNRaWS37VI0w6teT//J8SsMWnirbAe6b2jE4VqPqo
         0I0ZmvYneXBrwQssiEheBByy/dixAjyRHtTMsn5p9qIft6ZUVsGkA+Nz0EL5F6DXBKSx
         v6khM3T0AyhA5a+m8k3DtcxhwYgnxyweIqYutUHgB+n+4BiFtXB4ZJzTL34hgp3CLmI3
         bMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769600798; x=1770205598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3yF3NMoCzCngWqVZDLZFlKCZvpQRN9oVej7BpWRpbWE=;
        b=pTKYeqj8i7dBy0129ZjQLYpH/kAveK6T+eChv4XoWdlfOBDLUWY0VsiZV1Q9Dqx52y
         vUsNnxrZAXlKuo2LaukC2c5mzTdlBynCFjpjCKo8QEh3c9hoWrF7V1Ztf/glWoTV2dou
         7OSt403xC7t+1KN6Xyw6ca2iVe7NOTzzbowLTkMy/yZdi3n4uxbvRBcWvRv+k85ixnTN
         H8TtVGTIaxmk9WgmLdUN3TUv4KqozCBW7AwM/nA5nmBl7h37zbVQDcQt+BKY0s0r3jkQ
         30xmGeRGazoFIVTQGf8ukXOuSMtNgl+p50br5ZN+6Ezj8y84k/9yxdJBzQn/hj6AY1Mn
         tw1w==
X-Forwarded-Encrypted: i=1; AJvYcCX1qm/UIU3iMABCT7VSP1QnkkYHNkwQNc2M5uRC85yyYg0jDTqbfdM44Vp0m42mc7XZFjOMQf/jIoXs@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ66BV2Sy+9ZZjORPA3GgWNXfhdYLReRY12TgABJqZqFK70zq0
	5ueu1c1fPZlUzq5LfzaV8yK3lbTXMfG9ShfmGpftECmPLpXqK2pl6m6N06qOXwps8es3k+JIeqX
	5i4WZt/ZtwXDcF1PA9TBiP4hrIN+wGv0=
X-Gm-Gg: AZuq6aKABAPcxp602GAZ6u5Qh81m9YMHhjJiUhuX9udTinkpEaPoZGjf7JtrQPWSqva
	JMGG6TsE6te07jqoL2fyqnRU5vYqa7qstTyzANZTUlVCtRtsIPMhb5RlH+BKUxCxxyhJ2XDpJKX
	XD5bPjRxsl2kimIyc+K5nVQXybfJYkrEVzjdSUbPuX4jg8ZcHfo+XTZ/o7yzINSavZJd4yQIJRQ
	b0cIVgn17AmaVhtWswupLoIHcKwGDySDqIIpPOXN9CZy5bXyHi9Xg3ogRWk4wFtxcHdbg==
X-Received: by 2002:a17:906:208f:b0:b88:4b1f:5aff with SMTP id
 a640c23a62f3a-b8dab4411a9mr257006066b.44.1769600797603; Wed, 28 Jan 2026
 03:46:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119175445.800228-1-henrique.carvalho@suse.com>
 <CANT5p=qBM7qWVDFimQ9xzNegWEysDaV3BcNsKESGsrSnwSS8ag@mail.gmail.com>
 <yigr6qjcd2i6dtbivgi2as6joezfzhystbjtc6wtybhqvupy5b@uuw32dyhtwaj> <l63id7fg3pbp5qq7mvy2carztxacutezgwtv2faiclvtjdkdov@z3mjk6hktdu7>
In-Reply-To: <l63id7fg3pbp5qq7mvy2carztxacutezgwtv2faiclvtjdkdov@z3mjk6hktdu7>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 28 Jan 2026 17:16:26 +0530
X-Gm-Features: AZwV_Qi5-BibgVc2mZirVcXAK_V5xhoreJsqOrbK5I2VBL_YB74JsrB1Ce0wqRM
Message-ID: <CANT5p=rY5x8oLQmJAk+qQWQgYuT7L4rdBLAMvPWqq9PKnYmXgw@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: prevent races in ->query_interfaces()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Henrique,

Apologies. I wanted to take a relook into this patch later and got
busy with other stuff.

On Tue, Jan 27, 2026 at 7:07=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi Shyam,
>
> On Tue, Jan 20, 2026 at 09:54:08AM -0300, Henrique Carvalho wrote:
> > On Tue, Jan 20, 2026 at 12:22:31PM +0530, Shyam Prasad N wrote:
> > > On Mon, Jan 19, 2026 at 11:25=E2=80=AFPM Henrique Carvalho
> > > <henrique.carvalho@suse.com> wrote:
> > > >
> > > > It was possible for two query interface works to be concurrently tr=
ying
> > > > to update the interfaces.
> > > >
> > > > Prevent this by checking and updating iface_last_update under
> > > > iface_lock.
> > > >
> > > > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > > > ---
> > > >  fs/smb/client/smb2ops.c | 19 ++++++++-----------
> > > >  1 file changed, 8 insertions(+), 11 deletions(-)
> > > >
> > > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > > index c1aaf77e187b..edfd6a4e87e8 100644
> > > > --- a/fs/smb/client/smb2ops.c
> > > > +++ b/fs/smb/client/smb2ops.c
> > > > @@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interfa=
ce_info_ioctl_rsp *buf,
> > > >         p =3D buf;
> > > >
> > > >         spin_lock(&ses->iface_lock);
> > > > -       /* do not query too frequently, this time with lock held */
> > > > -       if (ses->iface_last_update &&
> > > > -           time_before(jiffies, ses->iface_last_update +
> > > > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > > > -               spin_unlock(&ses->iface_lock);
> > > > -               return 0;
> > > > -       }
> > >
> > > I originally had this second check so that I could test it under
> > > iface_lock here. i.e. we do one check without the lock (in
> > > SMB3_request_interfaces) and another one here with the lock held.
> > >
> >
> > The idea is that we would use this check to exit the function earlier
> > with another thread since we would know that either the
> > ifaces were recently updated or they would still be updated.
> >
> > Updating iface_last_update before the ioctl establishes a single-flight
> > guarantee for the polling interval.
> >
> > Otherwise, we could have many tcon works queued and many ioctls execute=
d
> > concurrently.

Fair point. I now understand your intent.

> >
> > > >
> > > >         /*
> > > >          * Go through iface_list and mark them as inactive
> > > > @@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interfac=
e_info_ioctl_rsp *buf,
> > > >                                  "Empty network interface list retu=
rned by server %s\n",
> > > >                                  ses->server->hostname);
> > > >                 rc =3D -EOPNOTSUPP;
> > > > -               ses->iface_last_update =3D jiffies;
> > > >                 goto out;
> > > >         }
> > > >
> > > > @@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interfac=
e_info_ioctl_rsp *buf,
> > > >              + sizeof(p->Next) && p->Next))
> > > >                 cifs_dbg(VFS, "%s: incomplete interface info\n", __=
func__);
> > > >
> > > > -       ses->iface_last_update =3D jiffies;
> > > > -
> > >
> > > You are right to point that these updates do not happen with
> > > iface_lock held. I'd lean towards fixing this after the "out" label
> > > below (where the lock is actually held).
> > >
> >
> > So the reasoning for updating the iface_last_update above in
> > SMB3_request_interfaces is to allow another thread to exit earlier.
> >
> > Fixing this after the out label would still allow multiple threads to
> > issue ioctls concurrently.
> >
> > > >  out:
> > > >         /*
> > > >          * Go through the list again and put the inactive entries
> > > > @@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xi=
d, struct cifs_tcon *tcon, bool in_
> > > >         struct TCP_Server_Info *pserver;
> > > >
> > > >         /* do not query too frequently */
> > > > +       spin_lock(&ses->iface_lock);
> > > >         if (ses->iface_last_update &&
> > > >             time_before(jiffies, ses->iface_last_update +
> > > > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ)))
> > > > +                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > > > +               spin_unlock(&ses->iface_lock);
> > > >                 return 0;
> > > > +       }
> > > > +
> > > > +       ses->iface_last_update =3D jiffies;
> > > > +
> > > > +       spin_unlock(&ses->iface_lock);
> > >
> > > The ioctl is still not done by this time. So there's a possibility of
> > > ioctl failing, yet we update iface_last_update.
> > >
> >
> > Yes, you're right.
> >
> > This a matter of policy, should we fail in any ioctl failure or should
> > we allow some failures to not suffer time backoff?
> >
> > If the latter is the case we could do:
> >
> > + } else if (rc !=3D 0) { /* rc !=3D -EOPNOTSUPP */
> > +     spin_lock(&ses->iface_lock);
> > +     ses->iface_last_update =3D 0;
> > +     spin_unlock(&ses->iface_lock);
> > +     goto out;
> > + }
> >
> > This allows for the next thread to access the SMB3_request_interfaces
> > and retry.

This is a good idea. With this, the racing processes do not all query
server interfaces. At the same time, if ioctl call errors out, we can
have the next process pick up from there.

> >
> >
>
> Do you have any comments about this? Should I send a v2 with this last
> suggestion on resetting the iface_last_update?
>
> --
> Henrique
> SUSE Labs



--=20
Regards,
Shyam
