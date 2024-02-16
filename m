Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE35B1429B
	for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 05:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708062045; cv=none; b=Y685PdkDepNADb01uzOl3w1P9CcNsJ6TpphYjGzWpX1n/nQj5Ah9rI8J1GKBEFVIAcU841gIMU8wMx/4XdesduHTGRZNxSQv5qHsw3kZvVaQSiXze8Y/qyAj2mBmcH49uDfBk9ZpwCuNDkdwiRfrocGxXxyXCRXmODnliS57axY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708062045; c=relaxed/simple;
	bh=xWhBmMKcI/nP3gcdjkp3AAXeNPAcSkbra6MqIEYjhFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oh4sU+xXOvLAX+ASI3612S+M4tetE19fI+K2LzaUAToNVnmYdv2Nx33ovFjOwAfxJ80fRfd6+omJ1IBBdMREZdbesAzI7zzKnBmw/fuoMT415tYvWg86Un2nP6b12sVjCA8X9HZi8O+PFzJiccPeems+KrmrlIYdUM9jghePTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=PaSxzXxr; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="PaSxzXxr"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F1F2A40C79
	for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 05:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1708062039;
	bh=g0nB89Iz0YHAvplmLLvt1SAPbgyM6rOD4Tu/+/NoPYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=PaSxzXxr0yB8Popy6r+hcmKXLClPItO3QyHssx16q2mLWyNf2VA+Okpj/ssqInNJ9
	 67bTblcGaOoR9iTUVLMWKGPyImQKe+KC6395xpsRYnVlbzU2dkxerShfS5rQo/R/UR
	 qnPAaKrrNGdyIN1HJkXgsnsR9yRcidXjp/JXGwmzDRqjSj+LV4kiFan07JVOCFYBhe
	 HfORAXzIMSS4jRwgQguW6sUPFuAmOC5p4qBUBFYpYd/qnuKxQOtzg7Ai2GdGakwlQe
	 0Qd3EY3yep70XH0Mto3fJ9dFQXbjCxi84huN8otrbg7S/qOgHr9nM+jjKpjpp8G7iE
	 EDU4ihV//IPOg==
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-298ed31e228so1039654a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Feb 2024 21:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708062037; x=1708666837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0nB89Iz0YHAvplmLLvt1SAPbgyM6rOD4Tu/+/NoPYY=;
        b=bIPOKzhQDFf1ttS0VpY5KwtviDQ+i0DucBhwTQMKsjwgBJ4EMQR3IP4dhX6J792VWa
         lL7yWONeNQYyiQX814r0H3f0/byujBhPDrTdZsUAmB9Fjdv9Kzo62BCX7MsrgX/7jTJq
         KYOxbFZFcVUAS5dB6cLAEkjDILo+OooOLMlO4YBqsR49/j9jJVJrYT+tRXxUR3KlX6lr
         xR1jiGyg2Cbs14PkQfTXWR2yR/9JSGuqeoo2j4Xkn1pzGVHCP9T88DyaHz61KDI0oaoT
         QUtIQURd1WITbtv+eVh2y4F/QglX+5n8SpQ2fDtVwwSP/bhU6ax9fwvCqfprewzKCQPi
         ewJg==
X-Forwarded-Encrypted: i=1; AJvYcCWeCvQmpYvifiY/kYoTO4BJ6vFaArUzZbbDmHYBfEPmjR4rOCId1XC3JPDq2Gg9l0MdsXMsO7QLzRSD+E/RfeABk9DicCjrS1wy+g==
X-Gm-Message-State: AOJu0Yy9e/Xxxi1mPBZ0f7Y9Aff72XQI232Hq+fikB/+TI0xx63dhB/N
	fcLolfg/K+HmMZeZ5ltQBpf16f/NJc39mitH/HFNlqeVcUXAu9s2e9yjUW+5QiCF4VUm8FfhDHD
	nLB5mXSCOOiZJn8uxjx1ix8YfDvAIAKlZcUPdbYWg+Ym8V0eVBBVKWRSi8UeV66OX8+8F9MVJCN
	TJwkueVK2Op9stF9wDurWxa1iYSevlqYjW4/BssoDBW/P1I1yj+cprW4/SVE1U
X-Received: by 2002:a17:90a:c908:b0:297:228a:fa6c with SMTP id v8-20020a17090ac90800b00297228afa6cmr3930358pjt.3.1708062037429;
        Thu, 15 Feb 2024 21:40:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEK0fkTl0eeT0JQUhavBcBGZZRTpFD8W4RSYnvV92Mit6Qr2YTGDa58ASJioi61JU9wM5ELgg8aKv427bS8tCo=
X-Received: by 2002:a17:90a:c908:b0:297:228a:fa6c with SMTP id
 v8-20020a17090ac90800b00297228afa6cmr3930343pjt.3.1708062037062; Thu, 15 Feb
 2024 21:40:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mswELNv2Mo-aWNoq3fRUC7Rk0TjfY8kwdPc=JSEuZZObw@mail.gmail.com>
 <20240207034117.20714-1-matthew.ruffell@canonical.com> <CAH2r5mu04KHQV3wynaBSrwkptSE_0ARq5YU1aGt7hmZkdsVsng@mail.gmail.com>
 <CAH2r5msJ12ShH+ZUOeEg3OZaJ-OJ53-mCHONftmec7FNm3znWQ@mail.gmail.com>
 <CAH2r5muiod=thF6tnSrgd_LEUCdqy03a2Ln1RU40OMETqt2Z_A@mail.gmail.com>
 <CAH2r5mvzyxP7vHQVcT6ieP4NmXDAz2UqTT7G4yrxcVObkV_3YQ@mail.gmail.com>
 <CAKAwkKuJvFDFG7=bCYmj0jdMMhYTLUnyGDuEAubToctbNqT5CQ@mail.gmail.com>
 <CAH2r5mt9gPhUSka56yk28+nksw7=LPuS4VAMzGQyJEOfcpOc=g@mail.gmail.com>
 <CAKAwkKsm3dvM_zGtYR8VHzHyA_6hzCie3mhA4gFQKYtWx12ZXw@mail.gmail.com>
 <CAH2r5mvSsmm2WzAakAKWGJMs3C-9+z0EJ-msV0Qjkt5q9ZPBzA@mail.gmail.com>
 <CAH2r5mvPz2CUyKDZv_9fYGu=9L=3UiME7xaJGBbu+iF8CH8YEQ@mail.gmail.com>
 <CAKAwkKu=v8GYX0Mhf1mzDYWT2v6dnLB=_zs7jk6trocAN2++4g@mail.gmail.com> <CAH2r5mvdPzy8v=yzaZYemYxFJ5u29No7yWTeZKzsLmfp2Rtsow@mail.gmail.com>
In-Reply-To: <CAH2r5mvdPzy8v=yzaZYemYxFJ5u29No7yWTeZKzsLmfp2Rtsow@mail.gmail.com>
From: Matthew Ruffell <matthew.ruffell@canonical.com>
Date: Fri, 16 Feb 2024 18:40:25 +1300
Message-ID: <CAKAwkKtA_wYbQ7Fyrd2xvA549GXrqdQy_dL8AxwmP3VP74L0+A@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, rdiez-2006@rd10.de, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

I have also tested this patch, and it is functionally the same as the
previous one.

I'm happy with this, please pick it up in your tree for 6.8 if possible.

Thanks,
Matthew

On Fri, 16 Feb 2024 at 17:22, Steve French <smfrench@gmail.com> wrote:
>
> Lightly updated with Shyam's modulo suggestion
>
>
> On Thu, Feb 15, 2024 at 9:46=E2=80=AFPM Matthew Ruffell
> <matthew.ruffell@canonical.com> wrote:
> >
> > Hi Steve,
> >
> > I tested the patch ontop of 6.8-rc4 and it works great.
> >
> > $ sudo mount -t cifs -o username=3Dubuntu,vers=3D1.0,wsize=3D16850
> > //192.168.122.172/sambashare ~/share
> > $ mount -l
> > //192.168.122.172/sambashare on /home/ubuntu/share type cifs
> > (rw,relatime,vers=3D1.0,cache=3Dstrict,username=3Dubuntu,uid=3D0,noforc=
euid,gid=3D0,noforcegid,
> > addr=3D192.168.122.172,soft,unix,posixpaths,serverino,mapposix,acl,rsiz=
e=3D1048576,wsize=3D16384,bsize=3D1048576,retrans=3D1,echo_interval=3D60,ac=
timeo=3D1,closetimeo=3D1)
> > $ sudo dmesg | tail
> > [   48.767560] Use of the less secure dialect vers=3D1.0 is not
> > recommended unless required for access to very old servers
> > [   48.768399] CIFS: VFS: Use of the less secure dialect vers=3D1.0 is
> > not recommended unless required for access to very old servers
> > [   48.769427] CIFS: VFS: wsize rounded down to 16384 to multiple of
> > PAGE_SIZE 4096
> > [   48.770069] CIFS: Attempting to mount //192.168.122.172/sambashare
> >
> > Setting the wsize=3D16850 rounds it down to 16384 like clockwork.
> >
> > I have built R. Diez a new distro kernel with the patch applied, and wi=
ll ask
> > him to test it. He did test the last one, which worked, and also rounde=
d down
> > the wsize that was negotiated with his old 1.0 server.
> >
> > When I get some time I can help try bisect and locate the folios/netfs =
data
> > corruption, but I think this is a good solution for the time being, or =
until
> > the netfslib changeover happens.
> >
> > Thanks,
> > Matthew
> >
> > On Thu, 15 Feb 2024 at 20:32, Steve French <smfrench@gmail.com> wrote:
> > >
> > > Minor update to patch to work around the folios/netfs data corruption=
.
> > >
> > > In addition to printing the warning if "wsize=3D" is specified on mou=
nt
> > > with a size that is not a multiple of PAGE_SIZE, it also rounds the
> > > wsize down to the nearest multiple of PAGE_SIZE (as it was already
> > > doing if the server tried to negotiate a wsize that was not a multipl=
e
> > > of PAGE_SIZE).
> > >
> > > On Fri, Feb 9, 2024 at 2:25=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
> > > >
> > > > > > If the user does set their own "wsize", any value that is not a=
 multiple of
> > > > > PAGE_SIZE is dangerous right?
> > > >
> > > > Yes for kernels 6.3 through 6.8-rc such a write size (ie that is no=
t a
> > > > multiple of page size) can
> > > > be dangerous - that is why I added the warning on mount if the user
> > > > specifies the
> > > > potentially problematic wsize, since the wsize specified on mount
> > > > unlike the server
> > > > negotiated maximum write size is under the user's control.  The ser=
ver
> > > > negotiated
> > > > maximum write size can't be controlled by the user, so for this
> > > > temporary fix we are
> > > > forced to round it down.   The actually bug is due to a folios/netf=
s
> > > > bug that David or
> > > > one of the mm experts may be able to spot (and fix) so for this
> > > > temporary workaround
> > > > I wanted to do the smaller change here so we don't have to revert i=
t
> > > > later. I got close to
> > > > finding the actual bug (where the offset was getting reset, rounded=
 up
> > > > incorrectly
> > > > inside one of the folios routines mentioned earlier in the thread) =
but
> > > > wanted to get something
> > > >
> > > > On Fri, Feb 9, 2024 at 2:51=E2=80=AFAM Matthew Ruffell
> > > > <matthew.ruffell@canonical.com> wrote:
> > > > >
> > > > > Hi Steve,
> > > > >
> > > > > Yes, I am specifying "wsize" on the mount in my example, as its a=
 little easier
> > > > > to reproduce the issue that way.
> > > > >
> > > > > If the user does set their own "wsize", any value that is not a m=
ultiple of
> > > > > PAGE_SIZE is dangerous right? Shouldn't we prevent the user from =
corrupting
> > > > > their data (un)intentionally if they happen to specify a wrong va=
lue? Especially
> > > > > since we know about it now. I know there haven't been any other r=
eports in the
> > > > > year or so between 6.3 and present day, so there probably isn't a=
ny users out
> > > > > there actually setting their own "wsize", but it still feels bad =
to allow users
> > > > > to expose themselves to data corruption in this form.
> > > > >
> > > > > Please consider also rounding down "wsize" set on mount command l=
ine to a safe
> > > > > multiple of PAGE_SIZE. The code will only be around until David's=
 netfslib cut
> > > > > over is merged anyway.
> > > > >
> > > > > I built a distro kernel and sent it to R. Diez for testing, so ho=
pefully we will
> > > > > have some testing performed against an actual SMB server that sen=
ds a dangerous
> > > > > wsize during negotiation. I'll let you know how that goes, or R. =
Diez, you can
> > > > > tell us about how it goes here.
> > > > >
> > > > > Thanks,
> > > > > Matthew
> > > > >
> > > > > On Fri, 9 Feb 2024 at 18:38, Steve French <smfrench@gmail.com> wr=
ote:
> > > > > >
> > > > > > Are you specifying "wsize" on the mount in your example?  The i=
ntent
> > > > > > of the patch is to warn the user using a non-recommended wsize =
(since
> > > > > > the user can control and fix that) but to force round_down when=
 the
> > > > > > server sends a dangerous wsize (ie one that is not a multiple o=
f
> > > > > > 4096).
> > > > > >
> > > > > > On Thu, Feb 8, 2024 at 3:31=E2=80=AFAM Matthew Ruffell
> > > > > > <matthew.ruffell@canonical.com> wrote:
> > > > > > >
> > > > > > > Hi Steve,
> > > > > > >
> > > > > > > I built your latest patch ontop of 6.8-rc3, but the problem s=
till persists.
> > > > > > >
> > > > > > > Looking at dmesg, I see the debug statement from the second h=
unk, but not from
> > > > > > > the first hunk, so I don't believe that wsize was ever rounde=
d down to
> > > > > > > PAGE_SIZE.
> > > > > > >
> > > > > > > [  541.918267] Use of the less secure dialect vers=3D1.0 is n=
ot
> > > > > > > recommended unless required for access to very old servers
> > > > > > > [  541.920913] CIFS: VFS: Use of the less secure dialect vers=
=3D1.0 is
> > > > > > > not recommended unless required for access to very old server=
s
> > > > > > > [  541.923533] CIFS: VFS: wsize should be a multiple of 4096 =
(PAGE_SIZE)
> > > > > > > [  541.924755] CIFS: Attempting to mount //192.168.122.172/sa=
mbashare
> > > > > > >
> > > > > > > $ sha256sum sambashare/testdata.txt
> > > > > > > 9e573a0aa795f9cd4de4ac684a1c056dbc7d2ba5494d02e71b6225ff5f0fd=
866
> > > > > > > sambashare/testdata.txt
> > > > > > > $ less sambashare/testdata.txt
> > > > > > > ...
> > > > > > > 8dc8da96f7e5de0f312a2dbcc3c5c6facbfcc2fc206e29283274582ec93da=
a2a1496ca8edd49e3c1
> > > > > > > 6b^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^=
@^@^@^@^@^@^@^@^@^@^
> > > > > > > ...
> > > > > > >
> > > > > > > Would you be able compile and test your patch and see if we e=
nter the logic from
> > > > > > > the first hunk?
> > > > > > >
> > > > > > > I'll be happy to test a V2 tomorrow.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Matthew
> > > > > > >
> > > > > > > On Thu, 8 Feb 2024 at 03:50, Steve French <smfrench@gmail.com=
> wrote:
> > > > > > > >
> > > > > > > > I had attached the wrong file - reattaching the correct pat=
ch (ie that
> > > > > > > > updates the previous version to use PAGE_SIZE instead of 40=
96)
> > > > > > > >
> > > > > > > > On Wed, Feb 7, 2024 at 1:12=E2=80=AFAM Steve French <smfren=
ch@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > Updated patch - now use PAGE_SIZE instead of hard coding =
to 4096.
> > > > > > > > >
> > > > > > > > > See attached
> > > > > > > > >
> > > > > > > > > On Tue, Feb 6, 2024 at 11:32=E2=80=AFPM Steve French <smf=
rench@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Attached updated patch which also adds check to make su=
re max write
> > > > > > > > > > size is at least 4K
> > > > > > > > > >
> > > > > > > > > > On Tue, Feb 6, 2024 at 10:58=E2=80=AFPM Steve French <s=
mfrench@gmail.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > > his netfslib work looks like quite a big refactor. =
Is there any plans to land this in 6.8? Or will this be 6.9 / later?
> > > > > > > > > > >
> > > > > > > > > > > I don't object to putting them in 6.8 if there was ad=
ditional review
> > > > > > > > > > > (it is quite large), but I expect there would be push=
back, and am
> > > > > > > > > > > concerned that David's status update did still show s=
ome TODOs for
> > > > > > > > > > > that patch series.  I do plan to upload his most rece=
nt set to
> > > > > > > > > > > cifs-2.6.git for-next later in the week and target wo=
uld be for
> > > > > > > > > > > merging the patch series would be 6.9-rc1 unless majo=
r issues were
> > > > > > > > > > > found in review or testing
> > > > > > > > > > >
> > > > > > > > > > > On Tue, Feb 6, 2024 at 9:42=E2=80=AFPM Matthew Ruffel=
l
> > > > > > > > > > > <matthew.ruffell@canonical.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > I have bisected the issue, and found the commit tha=
t introduces the problem:
> > > > > > > > > > > >
> > > > > > > > > > > > commit d08089f649a0cfb2099c8551ac47eef0cc23fdf2
> > > > > > > > > > > > Author: David Howells <dhowells@redhat.com>
> > > > > > > > > > > > Date:   Mon Jan 24 21:13:24 2022 +0000
> > > > > > > > > > > > Subject: cifs: Change the I/O paths to use an itera=
tor rather than a page list
> > > > > > > > > > > > Link: https://git.kernel.org/pub/scm/linux/kernel/g=
it/torvalds/linux.git/commit/?id=3Dd08089f649a0cfb2099c8551ac47eef0cc23fdf2
> > > > > > > > > > > >
> > > > > > > > > > > > $ git describe --contains d08089f649a0cfb2099c8551a=
c47eef0cc23fdf2
> > > > > > > > > > > > v6.3-rc1~136^2~7
> > > > > > > > > > > >
> > > > > > > > > > > > David, I also tried your cifs-netfs tree available =
here:
> > > > > > > > > > > >
> > > > > > > > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/dho=
wells/linux-fs.git/log/?h=3Dcifs-netfs
> > > > > > > > > > > >
> > > > > > > > > > > > This tree solves the issue. Specifically:
> > > > > > > > > > > >
> > > > > > > > > > > > commit 34efb2a814f1882ddb4a518c2e8a54db119fd0d8
> > > > > > > > > > > > Author: David Howells <dhowells@redhat.com>
> > > > > > > > > > > > Date:   Fri Oct 6 18:29:59 2023 +0100
> > > > > > > > > > > > Subject: cifs: Cut over to using netfslib
> > > > > > > > > > > > Link: https://git.kernel.org/pub/scm/linux/kernel/g=
it/dhowells/linux-fs.git/commit/?h=3Dcifs-netfs&id=3D34efb2a814f1882ddb4a51=
8c2e8a54db119fd0d8
> > > > > > > > > > > >
> > > > > > > > > > > > This netfslib work looks like quite a big refactor.=
 Is there any plans to land this in 6.8? Or will this be 6.9 / later?
> > > > > > > > > > > >
> > > > > > > > > > > > Do you have any suggestions on how to fix this with=
 a smaller delta in 6.3 -> 6.8-rc3 that the stable kernels can use?
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks,
> > > > > > > > > > > > Matthew
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > --
> > > > > > > > > > > Thanks,
> > > > > > > > > > >
> > > > > > > > > > > Steve
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > Thanks,
> > > > > > > > > >
> > > > > > > > > > Steve
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > Thanks,
> > > > > > > > >
> > > > > > > > > Steve
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > Thanks,
> > > > > > > >
> > > > > > > > Steve
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
