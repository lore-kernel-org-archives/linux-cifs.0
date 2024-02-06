Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DDA7F461
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 05:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707198729; cv=none; b=nMXT4oKBr8JQCAYyfhzUoO2XoV8F+TOh1rT7UZttidYFoiJBJWC6+kRBLD1N00SalbEroyRjUQ9zj3L8gSmBsS4qLfnguuoa0VmkZMEVFbVeXj5vT2rkY8kzBaA3C13pupzYiCcbz6lCAgadcTvb5yDAsVva/uN3LqdQYBEBEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707198729; c=relaxed/simple;
	bh=sOh0uvzGac2mHsKlCkuRq0Y8WrQKE0S+5kQwJt2vQOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kHObLkw7eiUrfre+53ZLr1BaIOig9dJMVjBl31s7cQ+9uDKbc1tfZ/fvxFwQo3ZcaAf8iuYLFmPBoDqosmBkfZzd0K5EKVVylnsmNWp7qa31NOg1d/hE2gdQSEbe22pfoUUn+i/A0HU0pXwKFSYiAUlTxQFCOrUowv2wL+/cpec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCP5+pDz; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCP5+pDz"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-51124d86022so8065483e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 21:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707198726; x=1707803526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JkSVpvlQDNTa6j+FxAmqfa2AdNntd6/Lt0B90GqE8o=;
        b=aCP5+pDzIB+NHUjqng80Ac3sWiqSKZjAyUpi4Bkgx+ib+KDytw9Nfe6qO+KkE8lGbK
         Si8c6BHEAcbOrU/AZ4JaC9lb8nkPre97Hp8K5ZPfyCvHUv/wN8CrvgcXOK6I8C63MELY
         N6JVqkSe4jNZrlyH1+pRj4xvHK6DHVfMqqis9IrvPGO43BxgFoJTppl0kdc78Z9prGgr
         ZF+gGLUXOQ47pmtNBD16rVTZPowY8Zd6yoqyQyFKCy/Tca96yM+x0QSqfUXeMxNt4YW1
         0/xQXe6XIDQXufUmyH+pGeZhmvFA88WhtjJl80B/SJxe7RwM+IaGbKJNp+B8ddKcviU7
         7YkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707198726; x=1707803526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JkSVpvlQDNTa6j+FxAmqfa2AdNntd6/Lt0B90GqE8o=;
        b=wGCaY8gpzljBpxbSGFDoABGjNncx6Xatd2d+QXmiBae6TsURJkmSykSfcV7ICWO9Wx
         BPETTFrtLiqDYhb8qRfnS0zcSZhfZvm2dOxmylxRcl+kIxvLBdoJWh9VFrBQfoLevSqJ
         rzRr+JCX74UXizqnxBF5NVFmkrO1sy4ICintXiBOUWRwSRVVlGwTJaEAkPlNc9T6JUGA
         XyozyNRm6U3MSv51tEjVvKwlrMjfLYkPyPS9WU4c+dRhFjJDWgLLCTycsmgjkFoTnsmo
         +lX7en2o/PI4pp885RwiBPwf8oy7o3TKKMz0mtS+f30xGpHk0cy1De/Y1ufyjsiEDIXn
         fHRA==
X-Gm-Message-State: AOJu0YywR1whtcTkK00yt6qP+P9+i6EqfCdwrS200dND7tlmLwSujngV
	RzEs82ssf701RndAQrFAIM/NJ36umVdn6W7BGnIBpvkepxsREpVvUogdL0aSjGZhHjoBw3ICrPi
	zzThnj1LVPZo1ASPkdIr6b1WiZUmAPRkK
X-Google-Smtp-Source: AGHT+IGrarGkNX59ED6B3riY5Ok9gAttEBuV3Oxhh+iD6Oa/ThBYKgc8c3aynjyw0J6HKzMBeoL4jbefGRJ0GzHm9Xk=
X-Received: by 2002:a19:910d:0:b0:511:6073:bf95 with SMTP id
 t13-20020a19910d000000b005116073bf95mr70361lfd.36.1707198725330; Mon, 05 Feb
 2024 21:52:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
 <CAH2r5mv6mvtSD3VpHKUtA_3zNDMGhFFkeLus1h5HpNZEJ2Q1pw@mail.gmail.com>
In-Reply-To: <CAH2r5mv6mvtSD3VpHKUtA_3zNDMGhFFkeLus1h5HpNZEJ2Q1pw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Feb 2024 23:51:54 -0600
Message-ID: <CAH2r5muy0UEnG1KmSgz1P_y9hP+-nj8wvZK5aGTGp6WW3F4mSA@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Digging deeper into this it looks like the problem is not the size
being bigger than 32K but picking a write size (wsize) that is not a
multiple of page size (4096).  I was able to reproduce this e.g. with
wsize=3D70000 but not with 69632 (ie a multiple of page size, 17*4096)

On Mon, Feb 5, 2024 at 10:05=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> In my additional experiments I could reproduce this but only with
> wsize < 32768 but it wasn't SMB1 specific - I could reproduce it with
> current dialects (smb3.1.1 e.g.) too not just SMB1 - so it is more
> about you picking  small wsize that found the bug than an SMB1
> specific problem.
>
> On Mon, Feb 5, 2024 at 7:30=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > I can reproduce this now with a simple smb1 cp - but only with the smal=
l wsize
> > ie mount option: wsize=3D16850.  As mentioned earlier the problem is
> > that we see a 16K write, then the next write is at the wrong offset
> > (leaving a hole)
> >
> > (it worked for SMB1 with default wsize)
> >
> > so focus is on these two functions in the call stack:
> >
> > [19085.611988]  cifs_async_writev+0x90/0x380 [cifs]
> > [19085.612083]  cifs_writepages_region+0xadc/0xbb0 [cifs]
> >
> > On Mon, Feb 5, 2024 at 3:37=E2=80=AFAM R. Diez <rdiez-2006@rd10.de> wro=
te:
> > >
> > >
> > > >> Unlikely as you didn't take them for the last merge window, let al=
one 6.2.
> > > >
> > > > That said, you did take my iteratorisation patches in 6.3 - but tha=
t shouldn't
> > > > affect 6.2 unless someone backported them.
> > >
> > > Please note that 6.2 is not affected, the breakage occurred afterward=
s. See the bug report here for more information:
> > >
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
> > >
> > > Regards,
> > >    rdiez
> > >
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
