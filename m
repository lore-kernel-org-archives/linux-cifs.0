Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC6194C62;
	Fri,  9 Aug 2024 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723217914; cv=none; b=CtCTrc432C7UwE0LgkOZ8mYlQvmuSUMzM+uSMkXE4n4s6jjiztxx5W1WfVYF3LqXersx5rMhyO1SJAPkT+k0BLeBJNnRqn2OK/m7CRDZe6janeltrxNn57b5q5rygl1jrbUhKxyllAkQBMz46fZPsycZSdorIo85rVI87hjZcT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723217914; c=relaxed/simple;
	bh=JwnkO9eMpObFo+OsLedKRFJApFZ3y9YoaamfM7OUxIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Inezhw0lBrB9GwWZDIKmFA0Ao5AFhQS59JjRnD5/ZjPpJtaC0KFPMGAyDpHmu0C4JT29AP9nBa733u8AT+ptkZR3J/0OxRnJeJVHxQ5UDnLhm/m/H2sJMXoh+2eEqvd/luzTIBzsdG21UsWfN34kkGyjRfEmNt1LJ0Nxo5EvHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kikk/yBt; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kikk/yBt"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f029e9c9cfso34623141fa.2;
        Fri, 09 Aug 2024 08:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723217909; x=1723822709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWXbMODiYuxXorvAx+kfN59eGwt8Ix7uvQ6uN1UXLrg=;
        b=kikk/yBtWVhm/tMR25QurCpNfDoHHIIDTRx9PGmaCd+o3VmVGsD7Hm/Rj1kN1dhiiN
         tKrHmJ7prbJh0sFE79L52ZbXsFCewUBxbWpEtk620nenmya2k527vgtie00OuDYqcuUo
         j1OYEABNWPBFIa5kbGs8p2Q659Dj82IqGnzA/pDTnFZlI1Vyj6rgodl5rBiOwJslYpBj
         ny09C4oIeICKvGiO6G/fEueoHVs8G+raMw0ewsBB9pQ66QOOImjKtYabR0tcIm0GfkIc
         aivUISgZQa/vF3HRVCVyLL67rMXSgs+fu7OPzFvP6k6/DnDCIkMu3pWDkZcw87mZv6cy
         GefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723217909; x=1723822709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWXbMODiYuxXorvAx+kfN59eGwt8Ix7uvQ6uN1UXLrg=;
        b=RDmLHyzkyOpfmSOVU3C9DsvW3/c4Nz5ItOmLMiwFwpd7wkM9dCtaghHwTa7JL39vOA
         U+t7mJ70WUcyz4zv/k74WrTMhkRX7oQN4WqtRFEKGaxWbG8SpgjGn+lPd6naq8mKmX5p
         q/sB/hyYpyXdS5jS5SzwSJCQvotEIuo/CCT0rxV5BhjbUH+JzxHFJw2bLlWOvzpASLkt
         FWKzQ59VyqazZ2UcNFQH+nhmjW7qk4bPza2Ds7biMKWtkiEBipstywViJaMDdaUeUnvS
         jDL96H8H8Ri8orkB9trF41rJzSyGx5skEJVETzSTyHk9Iu0blapdH0CfSyUedLiOUcBV
         MPsw==
X-Forwarded-Encrypted: i=1; AJvYcCXpOK/usHooZs7471OT3SqhTYURidy9NcvbeVylDKqDSYUZqoR9AJV0YGIwIWo/qWkm5i8yFlCkyu3YiSNURglP4h44vq0/u6PkZSBeljibYR0Bz9MTdSdFRCkMVc2oTLz3gblwp2bjC8PaMqdY2M64nOtDKOE9klz6HS4KMzeidfvldLxXXmCivQ==
X-Gm-Message-State: AOJu0YwCc5zuBHrhw6XYJ4VEaoX32nc85GnxHq5r50YHUejT++hfGUF5
	uxV/krazYLRBkRr/Ho+720j7cg2PjCFrBt5nvgyFXUliVf/eKtdFYjGbNNhDbmOUDGXgXKKwNnt
	DehDlHuZLizQLYzjDrk109+IqQak=
X-Google-Smtp-Source: AGHT+IFrrCUT+HJWFjXvxQEV3ITu84mxyWLhuzwLjtJ4nW5WcXBU4YeYGQ3URChdaQ8hO1rRYjy4qKNh6eDpVlwHt5Q=
X-Received: by 2002:a05:651c:102a:b0:2ef:32bb:5368 with SMTP id
 38308e7fff4ca-2f1a6c5c2f2mr17381101fa.11.1723217908335; Fri, 09 Aug 2024
 08:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808122331.342473-1-suhui@nfschina.com> <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>
In-Reply-To: <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Aug 2024 10:38:17 -0500
Message-ID: <CAH2r5mvHpNA-FLuq3gwV06tzwv+ioqQxFWqC8f3rcRPMrmdOFg@mail.gmail.com>
Subject: Re: [PATCH] smb/client: avoid possible NULL dereference in cifs_free_subrequest()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Su Hui <suhui@nfschina.com>, David Howells <dhowells@redhat.com>, sfrench@samba.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, nathan@kernel.org, 
	ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:01=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Thu, Aug 08, 2024 at 08:23:32PM +0800, Su Hui wrote:
> > Clang static checker (scan-build) warning:
> >       cifsglob.h:line 890, column 3
> >       Access to field 'ops' results in a dereference of a null pointer.
> >
> > Commit 519be989717c ("cifs: Add a tracepoint to track credits involved =
in
> > R/W requests") adds a check for 'rdata->server', and let clang throw th=
is
> > warning about NULL dereference.
> >
> > When 'rdata->credits.value !=3D 0 && rdata->server =3D=3D NULL' happens=
,
> > add_credits_and_wake_if() will call rdata->server->ops->add_credits().
> > This will cause NULL dereference problem. Add a check for 'rdata->serve=
r'
> > to avoid NULL dereference.
> >
> > Signed-off-by: Su Hui <suhui@nfschina.com>
>
> Needs a Fixes tag.

I had added a fixes tag

> Also when you add a Fixes tag, then get_maintainer will add the David How=
ells
> automatically.  I've added him manually.
>
> > ---
> >  fs/smb/client/file.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index b2405dd4d4d4..45459af5044d 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -315,7 +315,7 @@ static void cifs_free_subrequest(struct netfs_io_su=
brequest *subreq)
> >  #endif
> >       }
> >
> > -     if (rdata->credits.value !=3D 0)
> > +     if (rdata->credits.value !=3D 0) {
> >               trace_smb3_rw_credits(rdata->rreq->debug_id,
> >                                     rdata->subreq.debug_index,
> >                                     rdata->credits.value,
> > @@ -323,8 +323,12 @@ static void cifs_free_subrequest(struct netfs_io_s=
ubrequest *subreq)
> >                                     rdata->server ? rdata->server->in_f=
light : 0,
> >                                     -rdata->credits.value,
> >                                     cifs_trace_rw_credits_free_subreq);
> > +             if (rdata->server)
> > +                     add_credits_and_wake_if(rdata->server, &rdata->cr=
edits, 0);
> > +             else
> > +                     rdata->credits.value =3D 0;
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^
> Why do this?

add_credits_and_wake() has the effect of setting credits->value to 0
so seems reasonable here
(in the case where add_credits_and_wake can not be safely called),
even if an extremely unlikely for rdata->server to be null.





--=20
Thanks,

Steve
