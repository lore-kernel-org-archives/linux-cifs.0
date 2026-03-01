Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD62EC0A6
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772377332; cv=pass; b=t84CX2F8SyhxT+5ibuUvlYlIqObKc7AtJMh2w2FpKZF0MoVb4lu8LtNGNcf/XcdYIuOsWM4gqweGTjyuCrFrysSzb9kW/kEJQ31wuj0vRs7D+KbZPDy16+6b0mv6GeGon142N2+7qJa8tVhwwNH1Bwk2CY6QgUS1Iw4zIoc9PUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772377332; c=relaxed/simple;
	bh=V37CR9us1N0esOdbbifQtaXVD0Ciudjbj+QVzwLv+pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5qEEENBmtdvjCYvRKwpgrWN6bqc4f4j46u2E2PEedNGjPOUrJN3NU1N1CASrALb1IIwl7I/Ev+VHjwYXd4ir5jILWkiPRpYcmC9ZWBxSWaYC9RC68YBsvbcEqHGUQGe10gM3L3YA2fgUrknVawt95pDJJZJzSh2Eknv1yKrqRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMBPcvuu; arc=pass smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMBPcvuu"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5fded42aa7cso2501399137.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2026 07:02:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772377330; cv=none;
        d=google.com; s=arc-20240605;
        b=erTuzklXiJXoY9FFpbnllbsOOu5RBu07Nwr9Q6/vaJoDsBkHi05ePeCaXAMRQacLsu
         uf03bSnSHDobC1vpev8zclao3widMIaSKnDe6GvE6/W/ckdbGqaDJdsyB1u56tRqYMJr
         m3TJRl8ThSLSkHyZsii8WRMxDSttSHJSAY3t0WRtH8xUaLpTj/io8NYqi3mN4YlNQKJS
         oD4fiF5Samp0KfoAJpR8zOnK41p86HuP+LsEd/jeVwMrk5gUXzo7fqvK/5dMOZqhcjoy
         vcoGf6w+aDLfB9bLo19RC6hLVBoIhLbmATj0UY1pp6Rw3iGcvU+vvi5J04RN6PNBZxL3
         3kNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2DEbj6UlaLHWTSmc9tFmxEh3Nd0lpNrPuON3F9X96hM=;
        fh=lV31WIyO9mjiGQ7DULRgBzT/AemCdwwWHomUiK6ArFU=;
        b=UAiDHsX2lLB5+WHIGycfnPE55Fq1D3cXgzpIGwafieA11Iy2GpDFxWSd8tH/6UioYO
         XS/9PAdboY5eU5RTKOdJgHG5maNWD48ULXStp7y2UY5iMpBudA+XY7CIE3uX7sE1FJwf
         +Jec7Ae4wFK8Ms2GBvkn7Qkcd7EVY29Wt7cumlhElKHq3+gpBJdiy5pJ+PEVlnc3PCmG
         lcE+bow6pi+jTyXsD1QlKUQeou8xc97pXYNNSmb+pqif/kqUOcP4ZrZNMrqVIh+k2U8/
         GkSKz7wTSpqZGamYfnS5gd9Cr6apGYCYjxeOXRy7fsv4FjBSrFSmTW+192w38jAZ7YOM
         p9RQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772377330; x=1772982130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DEbj6UlaLHWTSmc9tFmxEh3Nd0lpNrPuON3F9X96hM=;
        b=mMBPcvuuF06lWTN+/TyD56IA4ZxnV47aeOImyEfUxIhwJ8ARyQhMXNydHupIySiwKo
         3B4GrMVPoNudjz+R81qvW4zSrF+Kw/fQXKoE7x4eI2QD8v78T0YAjvQyyOqBukk3G9m/
         5hsmJm4bWhUFIuBmfeCtGcxJr/dNshVdKduoNXeFOQGX+Riq6k7FhXmdMiBAuPnU0LbV
         TU5gBV+m17qa2RRhmXg3iI4QOAYwHd+GG5MUuYQVxFwJkAWUAmy+yJa3WnouUGwW7wyj
         Nl+T+4tLUifJ6fmu976xdHtvP4nQhkkjPAwckmLn6Z4J+C+JWryxLiZ49no7EqpMmu/+
         LTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772377330; x=1772982130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2DEbj6UlaLHWTSmc9tFmxEh3Nd0lpNrPuON3F9X96hM=;
        b=JHX1Om25PeCYllm/ARN5JXraw9mycBg2ClMWRRvQ11GwEHfPfdF67fEHIwfQ4haj3l
         uP3XtZqXaowJiYYWodpvX0uN6WMAYoBYCvEKX6Q/3XFqHYNwC597giBXsnhnkCfD7PC7
         7iQWjf4YxlqLioG+UOi6Haeh5rKEVYlwuKeYMQk8IO9FNPV6WndVE9mXMtq1P92Vk0It
         zciOxGeUI3jG6wLm2ad5MynDrBQ5uYVNq6SWaYmEToqgUH/FErub+wkrVy9gKURCg92E
         z9fLCrw8p7rv/q9U9TZOoj65bCTkioAK3xloiXGVol6YRRLnFzdpfXxfw+NlLkhW7mYD
         PUOw==
X-Forwarded-Encrypted: i=1; AJvYcCV9ndUhLD+dS4gh6MFmpdr/qsvbbMikz+c6fAiMgp0KSby9xFDYuCuYpQOdB4JNmIgADl2oCVVEaKu9@vger.kernel.org
X-Gm-Message-State: AOJu0YzdfJ7aTdRYLrTv8riW1Jda75HdU2PUgR7J3U7E2eYc9gZ6K0mI
	NouI0JFZuGGaY9iDeJ8RsKrD0W+/yGuJozMqXH7ZqqZnOKk96AQRRiwzHVtdvvJ7QO6LBOkp/P6
	kvR7UvOku/sBUNH8e6m6Duyy/ljJFU0Q=
X-Gm-Gg: ATEYQzwsEXNYVxFBfrC9Wo9aQy9kMhjrKmhl/Vf2r+2lEIN4ifPVra/Sroqsma2CTLX
	aKWbDC9oxAk3sHIepJE4AqUou1SDjLNHI/zgAK62mNppza6niQvUqr0cHMRgT28JZCxYi9hIjGo
	NVH2V5i9V5Ke+nquuns1Fdh8bfHygXvkkC7EmyA/sW3iujoFS6zJuDsIedRC2QINvNuFFVJ43bv
	25EOeeBUbYuGEvh3VBIUIB+gil86ECw7vivpMosWezOVv7MEdTIM70VHjCrHnHB85iHqMhK9Ayf
	zKO0Q5W4QfTcCL73rdKWuF6hfSsmEEnNwIdAmN3PNA==
X-Received: by 2002:a05:6102:cc6:b0:5ff:1445:88ff with SMTP id
 ada2fe7eead31-5ff322714abmr4377922137.7.1772377329579; Sun, 01 Mar 2026
 07:02:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260221145915.81749-1-dorjoychy111@gmail.com>
 <20260221145915.81749-2-dorjoychy111@gmail.com> <2f430eb613d4f6f6564f83d06f802ff47adea230.camel@kernel.org>
 <CAFfO_h7i86qdKZObdFpWd8Mh+8VXVMFYoGgYBgzomzhGJJFnEQ@mail.gmail.com> <ed5aeaa81ad9b87926fa7ebee0308aeb8df9f0ac.camel@kernel.org>
In-Reply-To: <ed5aeaa81ad9b87926fa7ebee0308aeb8df9f0ac.camel@kernel.org>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sun, 1 Mar 2026 21:01:58 +0600
X-Gm-Features: AaiRm50b25Ilp0U_HqmXYGEDuiLaRPqAldbyxEp-tlfkTSKlimm7-yBVSXDXKJs
Message-ID: <CAFfO_h5za6gV99TQS3pwHnf7zyCeVySn3CdRyV+_jFqjovGBqA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] openat2: new OPENAT2_REGULAR flag support
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
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

On Sun, Mar 1, 2026 at 8:47=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> On Sun, 2026-03-01 at 20:16 +0600, Dorjoy Chowdhury wrote:
> > On Sun, Mar 1, 2026 at 6:44=E2=80=AFPM Jeff Layton <jlayton@kernel.org>=
 wrote:
> > >
> > > On Sat, 2026-02-21 at 20:45 +0600, Dorjoy Chowdhury wrote:
> > > > This flag indicates the path should be opened if it's a regular fil=
e.
> > > > This is useful to write secure programs that want to avoid being
> > > > tricked into opening device nodes with special semantics while thin=
king
> > > > they operate on regular files. This is a requested feature from the
> > > > uapi-group[1].
> > > >
> > > > A corresponding error code EFTYPE has been introduced. For example,=
 if
> > > > openat2 is called on path /dev/null with OPENAT2_REGULAR in the fla=
g
> > > > param, it will return -EFTYPE.
> > > >
> > > > When used in combination with O_CREAT, either the regular file is
> > > > created, or if the path already exists, it is opened if it's a regu=
lar
> > > > file. Otherwise, -EFTYPE is returned.
> > > >
> > >
> > > It would be good to mention that EFTYPE has precedent in BSD/Darwin.
> > > When an error code is already supported in another UNIX-y OS, then it
> > > bolsters the case for adding it here.
> > >
> >
> > Good suggestion. Yes, I can include this information in the commit
> > message during the next posting.
> >
> > > Your cover letter mentions that you only tested this on btrfs. At the
> > > very least, you should test NFS and SMB. It should be fairly easy to
> > > set up mounts over loopback for those cases.
> > >
> >
> > I used virtme-ng (which I think reuses the host's filesystem) to run
> > the compiled bzImage and ran the openat2 kselftests there to verify
> > it's working. Is there a similar way I can test NFS/SMB by adding
> > kselftests? Or would I need to setup NFS/SMB inside a full VM distro
> > with a modified kernel to test this? I would appreciate any suggestion
> > on this.
> >
>
> I imagine virtme would need some configuration to set up for nfs or
> cifs, but maybe it's possible. I mostly use kdevops for this sort of
> testing.
>

Got it. I will try to figure this out and do some testing for NFS/SMB. Than=
ks.

> > > There are some places where it doesn't seem like -EFTYPE will be
> > > returned. It looks like it can send back -EISDIR and -ENOTDIR in some
> > > cases as well. With a new API like this, I think we ought to strive f=
or
> > > consistency.
> > >
> >
> > Good point. There was a comment in a previous posting of this patch
> > series "The most useful behavior would indicate what was found (e.g.,
> > a pipe)."
> > (ref: https://lore.kernel.org/linux-fsdevel/vhq3osjqs3nn764wrp2lxp66b4d=
xpb3n5x3dijhe2yr53qfgy3@tfswbjskc3y6/
> > )
> > So I thought maybe it would be useful to return -EISDIR where it was
> > already doing that. But it is a good point about consistency that we
> > won't be doing this for other different types so I guess it's better
> > to return -EFTYPE for all the cases anyway as you mention. Any
> > thoughts?
> >
>
> There is a case to be made for either. The big question is whether you
> can consistently return the same error codes in the same situations.
>
> For instance, you can return -EISDIR on NFS when the target is a
> directory, but can you do the same on btrfs or ceph? If not, then we
> have a situation where we have to deal with the possibility of two
> different error codes.
>
> In general, I think returning EFTYPE for everything is simplest and
> therefore best. Sure, EISDIR tells you a bit more about the target, but
> that info is probably not that helpful if you were expecting it to be a
> regular file.
>

Good point. I agree. I will fix this and return -EFTYPE for everything
in the next posting.

> >
> > > Should this API return -EFTYPE for all cases where it's not S_IFREG? =
If
> > > not, then what other errors are allowed? Bear in mind that you'll nee=
d
> > > to document this in the manpages too.
> > >
> >
> > Are the manpages in the kernel git repository or in a separate
> > repository? Do I make separate patch series for that? Sorry I don't
> > know about this in detail.
> >
>
> Separate repo and mailing list: https://www.kernel.org/doc/man-pages/
>
> ...come to think of it, you should also cc the linux-api mailing list
> when you send the next version:
>
>     https://www.kernel.org/doc/man-pages/linux-api-ml.html
>
> This one is fairly straightforward, but once a new API is in a released
> kernel, it's hard to change things, so we'll want to make sure we get
> this right.
>

I did not know about this. I will cc linux-api mailing list from the
next posting.

> I should also ask you about testcases here. You should add some tests
> to fstests for O_REGULAR if you haven't already:
>
>     https://www.kernel.org/doc/man-pages/linux-api-ml.html
>

I only added a kselftest for the new flag in
tools/testing/selftests/openat2/openat2_test.c in my second commit in
this patch series. Where are the fstests that I should add tests? I
think you added the wrong URL above, probably a typo.

Regards,
Dorjoy
