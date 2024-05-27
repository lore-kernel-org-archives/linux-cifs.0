Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB0F7344E
	for <linux-cifs@vger.kernel.org>; Mon, 27 May 2024 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716827926; cv=none; b=Ry8xujfGmG+zKYiwtDk+OBnp01IheHxQ/oLuOx5GnrGxGsguNAUFl16fXTfrCoQyImu/5CqKML4+Dr1VSIDgdYzMMU9sVGoz/2S3WYfVpy9E0fHA4WSoPD/x9QFISia6FWlWRdopZ89XHnEKK3qcqiPAe2EJsY5IzCDRLV4dnDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716827926; c=relaxed/simple;
	bh=3FYoAvauqv4MuTo8FlGLwaJ0YJtURfESdNd959BXArs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDh8zKiGRwXhLOyUKPzmpziY2eHCGCf8pr+bYeDitD+qDYicBjZZuXGjN1V0fydh5YTtHSwMlv0ttEzfjMbGyCoyYEs/FWvCuj/NiTkSF7UbQfFWXiP9VwqWHzGO6NmA/oFa/0NY5MLyKjSaCHeyMztmA9s3wBWu2Coh51VXjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com; spf=pass smtp.mailfrom=enioka.com; dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b=SEJ04Im8; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enioka.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b="SEJ04Im8"
Received: by mail.gandi.net (Postfix) with ESMTPSA id DC1991BF20A;
	Mon, 27 May 2024 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=enioka.com; s=gm1;
	t=1716827922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDFEf+fFUJhx0xKp/fAJ4738pNvVI70e/V9NDOlnx68=;
	b=SEJ04Im8qubiuVvNIDX5AA4Nevpz00UK3iVpcJEPAhXH/4p5EW6Ki0vOJ+i8JvfUFhOLIL
	nYptAXU05NkTP7Nwqg4UwYMwnzbJp72aKE15ZoXTnTG1V1FOfArIyBRmAFnWuOtJqzVKkI
	bKmhemwzg/FvOensGIvBAAwha3B303DmsljPwGD0kQdriLbypXPWWSCV2kuODZ9dxlmCDY
	8nrmNjOJmMyA88HYYsCabSm824xrU5cUNopEvbP2sXJpvfsFk6SdUEU9IZ8HaZoo5ijNnx
	s4UKd69AqcwnAl8/uTl3Jm6/H5635fBtd5IVyV2DWnmz8LEOFHlnvHPJfVoRvQ==
From: Kevin Ottens <kevin.ottens@enioka.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, abartlet@samba.org
Subject: Re: Different behavior of POSIX file locks depending on cache mode
Date: Mon, 27 May 2024 18:38:41 +0200
Message-ID: <6658550.MDQidcC6GM@wintermute>
In-Reply-To:
 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
References:
 <5659539.ZASKD2KPVS@wintermute>
 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-GND-Sasl: kevin.ottens@enioka.com

Hello,

On Thursday 23 May 2024 18:12:27 CEST Steve French wrote:
> What is the behavior with "nobrl" mount option?

With nobrl no failure shows whatever the cache policy (so my lock_test give=
s=20
always the output of the example with cache=3Dnone below).

> and what is the behavior when running with the POSIX extensions enabled
> (e.g. to current Samba or ksmbd adding "posix" to the mount options)

By current you mean 4.20.1?

So far I tested with 4.19.6 but couldn't get it to work. I get the followin=
g=20
in dmesg:
CIFS: VFS: Server does not support mounting with posix SMB3.11 extensions

Despite having the following in my smb.conf:
server max protocol =3D SMB3_11
smb3 unix extensions =3D yes

Am I using something too old? I honestly don't know when the extensions wer=
e=20
added.

Regards.
=20
> On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <kevin.ottens@eniok=
a.com>=20
wrote:
> > Hello,
> >=20
> > I've been hunting down a bug exhibited by Libreoffice regarding POSIX f=
ile
> > locks in conjunction with CIFS mounts. In short: just before saving, it
> > reopens a file on which it already holds a file lock (via another file
> > descriptor in the same process) in order to read from it to create a
> > backup
> > copy... but the read call fails.
> >=20
> > I've been in discussion with Andrew Bartlett for a little while regardi=
ng
> > this issue and, after exploring several venues, he advised me to send an
> > email to this list in order to get more opinions about it.
> >=20
> > The latest discovery we did was that the cache option on the mountpoint
> > seems to impact the behavior of the POSIX file locks. I made a minimal
> > test>=20
> > application (attached to this email) which basically does the following:
> >  * open a file for read/write
> >  * set a POSIX write lock on the whole file
> >  * open the file a second time and try to read from it
> >  * open the file a third time and try to write to it
> >=20
> > It assumes there is already some text in the file. Also, as it goes it
> > outputs information about the calls.
> >=20
> > The output I get is the following with cache=3Dstrict on the mount:
> > ---
> > Testing with /mnt/foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: -1
> > Third file descriptor 5
> > Wrote to third fd: -1
> > ---
> >=20
> > If I'm using cache=3Dnone:
> > ---
> > Testing with /mnt/foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: b count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> > ---
> >=20
> > That's the surprising behavior which prompted the email on this list. Is
> > it
> > somehow intended that the cache option would impact the semantic of the
> > file locks? At least it caught me by surprise and I wouldn't expect such
> > a difference in behavior.
> >=20
> > Now, since the POSIX locks are process wide, I would have expected to h=
ave
> > the output I'm getting for the "cache=3Dnone" case to be also the one I=
'm
> > getting for the "cache=3Dstrict" case.
> >=20
> > I'm looking forward to feedback on this one. I really wonder if we miss=
ed
> > something obvious or if there is some kind of bug in the cifs driver.
> >=20
> > Regards.
> > --
> > K=C3=A9vin Ottens
> > kevin.ottens@enioka.com
> > +33 7 57 08 95 13


=2D-=20
K=C3=A9vin Ottens
kevin.ottens@enioka.com
+33 7 57 08 95 13


