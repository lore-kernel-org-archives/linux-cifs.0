Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F9D3A3E93
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776695497; cv=pass; b=sWfJaOAOySt0s3igXjZuG3hA8haf+VzdQNe6koWMxicv8/DeC0+t9Uz0piWD8CnHUYfl0mXPGlWBlPV8jMl2yE/a7YrJ+vSjZpG146/SEJaSaA8KXB94EcPd/enTJfHbpQhhDSMr93SUeQiS+EaL9OGCZjmfpufj2sp1lewDO58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776695497; c=relaxed/simple;
	bh=kqPRzU1r8Upp5TYgefpiWZ9RVnkrVKI+N7GY819VmUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B8i1xGHOebwQrYeqmw70WBZPPJkLICnCBMAqQbytu7uSj7Z/yPfr7nqdGrqEZ5Dl7/boYC0WaEddAm+pwphr8+8mdpJmHV9F64ki41uwWIzNmdL7gKp1InKPALQvcPurpRZJ7C5Qv8qFEqXw3MkvYT9c6oMQD6GFltr4Z+yeq60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhQanICp; arc=pass smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhQanICp"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56efdc96b05so2030209e0c.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 07:31:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776695494; cv=none;
        d=google.com; s=arc-20240605;
        b=iVAMRF61wIIl7+taYdehJ9mvu8tc8W9gD8lQY2gvhG5B1YVstxl+rujPduNs85/5fb
         ZkpsDI7dBlqR8eeEBNwuxlACuJgu2TtcVoUIFrjEEHxX70XQnl64zFKtZhsYbWGubgUx
         iPXhS7+bPBUO4+TP7xF9Ez9RCxyNIaW4/ouv+3PPrL/e2PWG6/IuwGo2sica+oDObuJ7
         Ccynlk5FRbVa2/iXD38l57avLy7Epjmnvx6MeF6Gz1w9QuTedZGbX0aRD+eSsbXg1ZSZ
         RjnDfIGxqflJKP02uFsCd3gt9mtUzQTi+VgjQGVBV/LvGYxsC+SIatNgiN0XsO8HLMAX
         dDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4O8Xd8WCONGvKBMRsNl+HFLA/9jUjeJYvKk/a3SZv7Q=;
        fh=/K5aaURpUYHGQII7tVGcSsbDGVCmjrHYCegMc8u+CDc=;
        b=FwnJfWZJcOLlxd86/Xl+HI9JidXkDpjQJdpVG6N+UMr36oUOXAFigJOW/Jxm/8mz4i
         advbTdTK5dXok1LPsfaMspScBbJ4QUWn7nwEIP/BI2YvDCtej9MSSxR546v4eRA+Kxqz
         XjbH4ghQjqJ0raoH7QhDal5FhYX/z4B/lMVYfvaCZNmx+nmfZbibslUiOfvKUZdsWY21
         rXMTrw3T5UN10LlgZrTZ7c/sag41Xn82NA9fJiv56grqcQU6jq56r4C+h/dnkKshQ0NF
         QlYnXYH7trLJfpVY3gn/zi7koUEghrsg/orw52a3+iL8ctKhirAD/a09pdu4NrvJeD70
         ToUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776695494; x=1777300294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4O8Xd8WCONGvKBMRsNl+HFLA/9jUjeJYvKk/a3SZv7Q=;
        b=EhQanICpPv6wEMAT2QVDm8MgxITvcGEAYHe1m42iLSyMQj1Y0WareKAEFrCkR4fDyS
         SPGbqqTXwePHWW8p/f+2UlF/X2ihrUtbg8fbhtFxe6Qkqi2/QsyMkbJOzqro8eqXQAMl
         WcTOuWJXsUbOkZXsn0mFPAAJhM+mIGkIVvCxhoXQub2kbpvG2XE+6iWz+07ORoIJhtIs
         ClD0K9/EMLGHnjeD7QhTdYd1UAPBisbBisjidOI06FRByUtkXvWoSYx8MVyVgkzYR17D
         5S+1XoMelyZ02D7ZT3mCabthO4VIPjJuimT5uUTlee+2Q1h9TgB0nS+/3YwCJhdIarG8
         Pp/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776695494; x=1777300294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4O8Xd8WCONGvKBMRsNl+HFLA/9jUjeJYvKk/a3SZv7Q=;
        b=PaeMOEH7KMSPrvuDVwaSbREKhOwhO73sWEPHYhwlbnVwXE+Rz08fdI8M0U1K8vo/rO
         aSsSC7MosP0+f9F1h3CmkvDD3wyab++F4jKToe28VDgNrA2ho3Xt/jMLrfEaqt6VvrEl
         DmBz4HeYL792MWVlcE8ogokvQfjuqRQPXnjn0zTY16p0Oyu6jzzMaXZ14DphYprFVb+d
         smdic4C5Cx4BkItOvY8K7NF0h3SMAICbNoRb87YyVJOjByU6RpZGHyW8HmRbBbhDUf6Y
         T9YfEJYLcNInh5CkztDxhoYe6iVLVfvw88malJcjtUnB5eeTY74vylfURYiI0IvU7xM5
         TDzg==
X-Forwarded-Encrypted: i=1; AFNElJ+/sMZLsABpJbT2sSMe56jODV2MMYIPVYr7khcQCQqzTTRQORkSunvQjhdbZS+EKJhMV7HyJU9hxzwa@vger.kernel.org
X-Gm-Message-State: AOJu0YxDTDi+atJ0G7KWSQdbv4taDqI+NAGKOu2fLtLjfGXQd7v92qPn
	5mLa2GhCL4WcuoE6bIlMkYkC8PW5b+Uap5698WoXpyBNihHhVSkBe85Aq6kliy+/CMZ7pD9O/6T
	YsesHsryfloboNOZabMHXUhNFmQopXxw=
X-Gm-Gg: AeBDiev1PNRlZZ8hzsdNVeKIygZ8Edr7flKq6Q0v3w+iRp43H7IAQrALqoHg+Uajffj
	WowjY8rAZQLy5i+bXVD5nuZI46sr8g9AjFCTJXwa7vwoXIOHaBjK1UfpHPQY4j+0Tzcp6cXRJRN
	uyBUZTg7rFe8MDpcNyiGo0WaS6j4kM2GrqQQ7SvTVBuHyArEd5RF8JFMQEey+vbXcXJD4ezIvH7
	uOM88SjwVD616T1Jlmj/Pl7JRumnCYXn/C6xqGS9UuQT4BU+qBy3lkMluow+GMcVKAmd7Uch3zX
	4tKtWA23iXuIRxFXhAUbXrI6cx8tx9Kb+Wq5/RUiVKK8C1k76onr
X-Received: by 2002:a05:6122:4d12:b0:56f:9512:145 with SMTP id
 71dfb90a1353d-56fa5a39aa7mr6593038e0c.13.1776695494119; Mon, 20 Apr 2026
 07:31:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
 <20260416-abgraben-seeweg-a44ce660957f@brauner> <CAFfO_h5mORm0OuK-d4thzBWWySmyvLSVeVa7phZc4Df-8D=1Cg@mail.gmail.com>
 <20260420-laufen-einzeln-4cf4bb364a5d@brauner>
In-Reply-To: <20260420-laufen-einzeln-4cf4bb364a5d@brauner>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Mon, 20 Apr 2026 20:31:23 +0600
X-Gm-Features: AQROBzDP8Lx2bqkiL-O80tZkD0rFOUG8sjvNKKIkhcPgFqdc6FHkIJDo6D1Xn7k
Message-ID: <CAFfO_h5FH36eqYuuoYy2eVRXGytmQHLfz5p7fLi+3wHmQN9MnA@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] OPENAT2_REGULAR flag support for openat2
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, 
	arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 7:20=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Apr 16, 2026 at 09:22:03PM +0600, Dorjoy Chowdhury wrote:
> > On Thu, Apr 16, 2026 at 7:07=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Sat, 28 Mar 2026 23:22:21 +0600, Dorjoy Chowdhury wrote:
> > > > I came upon this "Ability to only open regular files" uapi feature =
suggestion
> > > > from https://uapi-group.org/kernel-features/#ability-to-only-open-r=
egular-files
> > > > and thought it would be something I could do as a first patch and g=
et to
> > > > know the kernel code a bit better.
> > > >
> > > > The following filesystems have been tested by building and booting =
the kernel
> > > > x86 bzImage in a Fedora 43 VM in QEMU. I have tested with OPENAT2_R=
EGULAR that
> > > > regular files can be successfully opened and non-regular files (dir=
ectory, fifo etc)
> > > > return -EFTYPE.
> > > > - btrfs
> > > > - NFS (loopback)
> > > > - SMB (loopback)
> > > >
> > > > [...]
> > >
> > > - I've added an explanation why OPENAT2_REGULAR is only needed for so=
me
> > >   ->atomic_open() implementers but not others. What I don't like is t=
hat
> > >   we need all that custom handling in there but it's managable.
> > >
> > > - I dropped the topmost style conversions. They really don't belong
> > >   there and if we switch to something better we should use (1 << <nr>=
).
> > >
> > > - I split the EFTYPE errno introduction into a separate patch.
> > >
> > > ---
> >
> > Thanks for fixing up and picking this one up!
> >
> > >
> > > Applied to the vfs-7.2.openat.regular branch of the vfs/vfs.git tree.
> > > Patches in the vfs-7.2.openat.regular branch should appear in linux-n=
ext soon.
> > >
> >
> > I don't see a vfs-7.2.openat.regular branch in vfs/vfs.git tree in
> > git.kernel.org.  Maybe this hasn't been pushed yet?
>
> Nothing will get pushed prior to -rc1 which is due this Sunday.

Understood. Thanks!

Regards,
Dorjoy
