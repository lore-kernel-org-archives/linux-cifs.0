Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD533BB48
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718060037; cv=none; b=A3UWan+l0EFQyqzNn6jak8Ua4BJxSMWlQbxU1r7Ed1HzQ7C6a4ab192ieIhfqprgdYSqHqPr0AfuC6/wr4IRtyiUXF0j6UrAfnPSyLzga4cEN2xkzgvWMptHCWsHzoR5MT6ijbMAOKPkPmou0wWUDi5EAGRp6vlfjH7rWqx1z/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718060037; c=relaxed/simple;
	bh=rTt+YUQxbNwULoydNvrOm0rBv/S2uLD3xmCCTYMUocc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a32395AJ4PHpUkqEMBwA6U/znVUPN34TUCoFBOZxKyAxL85AueVLawgus0+l4IsA6i1IS3+aFBi8QQF+8IPw6nxk2xLmn7tg2ujbfBdlS9yHtn/G0auHTKvnFSEfG0rfuNsA4dgEf7cBHlDxqvZ1CbRNA2CcH/8fGfHy+XkycFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=joVmpbZx; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="joVmpbZx"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52bc3130ae6so3449348e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 15:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718060034; x=1718664834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goUwjAI54vic8D0XycUEU0D0pI+Bz7f6RXRCx2wetXc=;
        b=joVmpbZxGW7rEOUf8HfH+NDW/Rajr/NtPgRlpGSeJ7kTNWE2ygI+RPyQth00yDtXgZ
         WvEMWSR2w4iaiDN5Z69nG+g1ow/4npAHPOWrGX2OjtOrgwtXEQ1h1VIdA1IJpkInzvtE
         OZc7J4CbbVxGNO+288tf/oBk43P+wGqdSq+p/C6D/Wl60P0rt1BygvkRdLVIh5j8VAC9
         3SDyxUQxiXs/ALHTNXRIXhrabj1uZUag1P9lhDuJCTrUou5VOiuyEmWxSO4M2lGeaDbY
         EMNOf+ZXUCXVmH9vN9iJMNq5czEtCiooX4hOfs6VdRHbeDDpp08qBFReyI0CKrOj5YIW
         vJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718060034; x=1718664834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goUwjAI54vic8D0XycUEU0D0pI+Bz7f6RXRCx2wetXc=;
        b=QSXDTBYoUWLc1Y6evB7CJHJR27aJLqatp045p0ADc6T6O3D9WDB2b8fAb1YbJJ16XD
         q4UGWz/LQLt/htaivXjAHhNjlnx9XNpeO5lml2tT6mGcdFFMRUl8eUxEl8zSi34JX2KE
         HVYIyuTz9kWqx8UaHE8VVP74Qi+mZc5ZgWXPlAKtx8yKKF2LTbRQZT2dm223PhxxWp34
         FiP1ciem/780llFAn0OWipeHQ65oS+AMVWMEkB4gg28UHHwjTAX2mpnoECqisCzvxMzg
         F1EJULdHqeNZCJwC9jlzIVJaqt2xrJ9+aThQz8EHLBQ18FKWzHtXhRFE0fBGlgfQ9Rnq
         VWhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCSQS5jyRcbMsKsbeoySdorz3wsedv3HJN32u4rPB1VKor/0Q+f5Vpmw7x9vPwPLTkX1n5j54qoqROSgAqj7e1BGkwpTrqyVoSCQ==
X-Gm-Message-State: AOJu0YwXVYPMkdLYKOb4d/GrCV9uoZzOpZYbijkIaPwH3Qo0KbIX7+um
	/lHoj7FyY6U13nfw//gODzMNX4DBYQoDkf0b6rnGc2kqJjMafLi/ZD92tyOGiN/FfOmY2fAV3uK
	KeOGzLmNw1GCujNDclvNMkrzs4SA2ET/M
X-Google-Smtp-Source: AGHT+IEIuDGyHMeRdiPPPdhjSRmy75pfOlNG7R/QhaP1MUS8UDA2irtFssuhio8VumnggbC/zWBwHPKkaVRhLT2j/cw=
X-Received: by 2002:a05:6512:239a:b0:52c:8b1a:5513 with SMTP id
 2adb3069b0e04-52c8b1a5670mr2611493e87.47.1718060033840; Mon, 10 Jun 2024
 15:53:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
 <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
 <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
 <0a043592-7034-4478-9969-9c17983886fb@samba.org> <CAH2r5mt=RgvYAMKX1zR-ofOEb2h+tcowerJn+ysiKY-+CrLtCQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt=RgvYAMKX1zR-ofOEb2h+tcowerJn+ysiKY-+CrLtCQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Jun 2024 17:53:42 -0500
Message-ID: <CAH2r5msCiu7Vaz4NzGFQc3=Lf4ErVaqtSfgK_MoVvjKZFkcM5g@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Ralph Boehme <slow@samba.org>
Cc: Andrew Bartlett <abartlet@samba.org>, Kevin Ottens <kevin.ottens@enioka.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 5:49=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> On Mon, Jun 10, 2024 at 4:19=E2=80=AFPM Ralph Boehme <slow@samba.org> wro=
te:
> <snip>
> > >> a serious regression in the server (but trivial fix).  We are waitin=
g
> > >>
> > >> on someone to merge the oneline fix to the server (which we tested o=
ut
> > >>
> > >> ok) from David.
> >
> > no, Ralph.
>
> Oops... Sorry about the typo ...
>
> > fix + test =3D MR + review =3D master
> >
> > The test is still missing and I was on vacation and am swamped with wor=
k.
>
> All of the standard ("fstest" aka "xfstests") automated tests fail, so
> trivial to test/reproduce.  Does anyone have a pointer to the
> smbtorture tests for SMB3.1.1 POSIX? It only needs a single query fs
> info to fail so this looks like only a few line addition to the
> existing SMB3.1.1 POSIX tests.   I do badly want to re-enable our
> automated testing to Samba with SMB3.1.1 POSIX (the "buildbot") but
> obviously this blocks every test.   We do test on every pull request
> upstream to Samba (and also to Samba with vfs_btrfs for those features

Sorry about another typo:
We do test (cifs.ko) -- to Samba server -- on every pull request


--=20
Thanks,

Steve
