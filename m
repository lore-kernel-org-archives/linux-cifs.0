Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4904067E61
	for <linux-cifs@vger.kernel.org>; Fri,  9 Feb 2024 08:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707468675; cv=none; b=BRxxracpLaOITWRia/9KUSD+crUWijlLZXQ5uh1aaqw5ymfEqq3VcTaNczbQMVzUt6HzuLoMBm8aHj2jItLPy5VPEkLhpj8bDtXF9Ek6OXlwYJUR+MSpGrcMuuB8iwQr4kUkdTTwnaErhR99PxdWjJv/Hmxr4U+LTnGYDhHOuQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707468675; c=relaxed/simple;
	bh=5kRNuoPL140t9BwjXIY+LDVJvq8k5b+JD/xF5dhKkuE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lMVUG0P19Q2+1r3AAHl62rVgZyUvd3ZMFuzCxQVU2XGK0mE1Lsk3i4RqtI+tM8IaufJDtbdZ6ENvVk8WFs/dr+0783ZHYkVHs85YSOpLnB+qkCRokmZJn/GwRvmqgF1AEQrwxePfY78faFhsG4Far3Fwtpv1Z9IF8EhBI7O36x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=GU0fN4Hu; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="GU0fN4Hu"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F0EBD3F5D9
	for <linux-cifs@vger.kernel.org>; Fri,  9 Feb 2024 08:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1707468664;
	bh=ZOis+6PIXMFRF8sRW0y0YYjqTXkkGX9bSDbpA1lDxl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=GU0fN4HuqFbpUH4UW38OszXuM79pOPXBNn0fbxfw4KA1XSaFthp/MnXX6hiHbf/SB
	 NXNov2rOrbKY8OibqlD5HIfbiT0wCGl8mVeADx2J7+gDJGmlA65pj58tKlx2u9nKzz
	 9uvzUwnjx+K2TBAj6hFzxHVxF0nHTZtBwMFZOc6lRJY1CAfpBE2zoVlHCdy75wEoTD
	 0O/2WuOQRLJG5AFRUjy6jeljNnOgxItMNeKrqzdyrSuIXVM/870rqp/JL+UPliFbhz
	 /jLAoMpXqZ+fWARP1NxgOy8muAqM+mPwtPKF907uhw+v5OJGgOVJObZxGBdUIkZrAK
	 q3P4/l9ItGk8g==
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2967b607cb1so647900a91.3
        for <linux-cifs@vger.kernel.org>; Fri, 09 Feb 2024 00:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707468662; x=1708073462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOis+6PIXMFRF8sRW0y0YYjqTXkkGX9bSDbpA1lDxl4=;
        b=sDvI3r4eKJoP6g1q6Y+fFsSJ65Pbme69gaKS+LsHbqheOLe75COTKQgW5Ow1ZG84zL
         JYewR/+m7hs0IeIQVGKr11npDqswjW8dp854EQpdiBCXkcm4ERu276w3A96Mg+EShcSq
         btx4pEFeukT+j74pReuZ+d7DEjsOHStYvLMi77Y26JfCelkdmYKnqEwcxeP6VEKiC+OK
         /hv9FuIYhq2QruDClaXZPD2Oy0AGqoT5X+GXzeRBzWmDXlsS5fAx19k4I3vsKMEjslXK
         Ct6lgJIvfInZSafd9m+gX2C7WtIFOw/iBei6s1c/oj6v98Zi2U9K/E3ykIF5rHbjPhvW
         h35w==
X-Gm-Message-State: AOJu0YxlRymlEsbdKTFUgfmZwm/PAtnWFNiQSydLj4Cu03Vd61DTqdMQ
	+pExVbE+6MP8lqxvQ/2beHWj3TeX62M7LJNWcZu32Y0Lc4pKKQfm20OamJNo9VuLUF4YHLElyJP
	fkhwzPofZ/YPmUD8+9tfta/3cKYzAqUJM1wX32lhK8ZuIaSTHp+Qa7X1M+lZ63uXuHuvyBKAzyF
	V3WhHwG+OL01+ir/8ruhNzYfV1kJShhxVmUuvC6rbfZYkYYepQ8g==
X-Received: by 2002:a17:90a:948a:b0:295:cb78:a6f7 with SMTP id s10-20020a17090a948a00b00295cb78a6f7mr809770pjo.8.1707468662376;
        Fri, 09 Feb 2024 00:51:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbHy2HAJgClKagQGxo7+nvyFeVCiFVJ5Y0z8TK2IFp0uR4VNs/y3U/7Hxetr/yKuWyhlQBQ4YWl+3d69HeXgs=
X-Received: by 2002:a17:90a:948a:b0:295:cb78:a6f7 with SMTP id
 s10-20020a17090a948a00b00295cb78a6f7mr809761pjo.8.1707468662087; Fri, 09 Feb
 2024 00:51:02 -0800 (PST)
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
 <CAKAwkKuJvFDFG7=bCYmj0jdMMhYTLUnyGDuEAubToctbNqT5CQ@mail.gmail.com> <CAH2r5mt9gPhUSka56yk28+nksw7=LPuS4VAMzGQyJEOfcpOc=g@mail.gmail.com>
In-Reply-To: <CAH2r5mt9gPhUSka56yk28+nksw7=LPuS4VAMzGQyJEOfcpOc=g@mail.gmail.com>
From: Matthew Ruffell <matthew.ruffell@canonical.com>
Date: Fri, 9 Feb 2024 21:50:50 +1300
Message-ID: <CAKAwkKsm3dvM_zGtYR8VHzHyA_6hzCie3mhA4gFQKYtWx12ZXw@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, rdiez-2006@rd10.de, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Yes, I am specifying "wsize" on the mount in my example, as its a little ea=
sier
to reproduce the issue that way.

If the user does set their own "wsize", any value that is not a multiple of
PAGE_SIZE is dangerous right? Shouldn't we prevent the user from corrupting
their data (un)intentionally if they happen to specify a wrong value? Espec=
ially
since we know about it now. I know there haven't been any other reports in =
the
year or so between 6.3 and present day, so there probably isn't any users o=
ut
there actually setting their own "wsize", but it still feels bad to allow u=
sers
to expose themselves to data corruption in this form.

Please consider also rounding down "wsize" set on mount command line to a s=
afe
multiple of PAGE_SIZE. The code will only be around until David's netfslib =
cut
over is merged anyway.

I built a distro kernel and sent it to R. Diez for testing, so hopefully we=
 will
have some testing performed against an actual SMB server that sends a dange=
rous
wsize during negotiation. I'll let you know how that goes, or R. Diez, you =
can
tell us about how it goes here.

Thanks,
Matthew

On Fri, 9 Feb 2024 at 18:38, Steve French <smfrench@gmail.com> wrote:
>
> Are you specifying "wsize" on the mount in your example?  The intent
> of the patch is to warn the user using a non-recommended wsize (since
> the user can control and fix that) but to force round_down when the
> server sends a dangerous wsize (ie one that is not a multiple of
> 4096).
>
> On Thu, Feb 8, 2024 at 3:31=E2=80=AFAM Matthew Ruffell
> <matthew.ruffell@canonical.com> wrote:
> >
> > Hi Steve,
> >
> > I built your latest patch ontop of 6.8-rc3, but the problem still persi=
sts.
> >
> > Looking at dmesg, I see the debug statement from the second hunk, but n=
ot from
> > the first hunk, so I don't believe that wsize was ever rounded down to
> > PAGE_SIZE.
> >
> > [  541.918267] Use of the less secure dialect vers=3D1.0 is not
> > recommended unless required for access to very old servers
> > [  541.920913] CIFS: VFS: Use of the less secure dialect vers=3D1.0 is
> > not recommended unless required for access to very old servers
> > [  541.923533] CIFS: VFS: wsize should be a multiple of 4096 (PAGE_SIZE=
)
> > [  541.924755] CIFS: Attempting to mount //192.168.122.172/sambashare
> >
> > $ sha256sum sambashare/testdata.txt
> > 9e573a0aa795f9cd4de4ac684a1c056dbc7d2ba5494d02e71b6225ff5f0fd866
> > sambashare/testdata.txt
> > $ less sambashare/testdata.txt
> > ...
> > 8dc8da96f7e5de0f312a2dbcc3c5c6facbfcc2fc206e29283274582ec93daa2a1496ca8=
edd49e3c1
> > 6b^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^=
@^@^@^@^@^
> > ...
> >
> > Would you be able compile and test your patch and see if we enter the l=
ogic from
> > the first hunk?
> >
> > I'll be happy to test a V2 tomorrow.
> >
> > Thanks,
> > Matthew
> >
> > On Thu, 8 Feb 2024 at 03:50, Steve French <smfrench@gmail.com> wrote:
> > >
> > > I had attached the wrong file - reattaching the correct patch (ie tha=
t
> > > updates the previous version to use PAGE_SIZE instead of 4096)
> > >
> > > On Wed, Feb 7, 2024 at 1:12=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> > > >
> > > > Updated patch - now use PAGE_SIZE instead of hard coding to 4096.
> > > >
> > > > See attached
> > > >
> > > > On Tue, Feb 6, 2024 at 11:32=E2=80=AFPM Steve French <smfrench@gmai=
l.com> wrote:
> > > > >
> > > > > Attached updated patch which also adds check to make sure max wri=
te
> > > > > size is at least 4K
> > > > >
> > > > > On Tue, Feb 6, 2024 at 10:58=E2=80=AFPM Steve French <smfrench@gm=
ail.com> wrote:
> > > > > >
> > > > > > > his netfslib work looks like quite a big refactor. Is there a=
ny plans to land this in 6.8? Or will this be 6.9 / later?
> > > > > >
> > > > > > I don't object to putting them in 6.8 if there was additional r=
eview
> > > > > > (it is quite large), but I expect there would be pushback, and =
am
> > > > > > concerned that David's status update did still show some TODOs =
for
> > > > > > that patch series.  I do plan to upload his most recent set to
> > > > > > cifs-2.6.git for-next later in the week and target would be for
> > > > > > merging the patch series would be 6.9-rc1 unless major issues w=
ere
> > > > > > found in review or testing
> > > > > >
> > > > > > On Tue, Feb 6, 2024 at 9:42=E2=80=AFPM Matthew Ruffell
> > > > > > <matthew.ruffell@canonical.com> wrote:
> > > > > > >
> > > > > > > I have bisected the issue, and found the commit that introduc=
es the problem:
> > > > > > >
> > > > > > > commit d08089f649a0cfb2099c8551ac47eef0cc23fdf2
> > > > > > > Author: David Howells <dhowells@redhat.com>
> > > > > > > Date:   Mon Jan 24 21:13:24 2022 +0000
> > > > > > > Subject: cifs: Change the I/O paths to use an iterator rather=
 than a page list
> > > > > > > Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvald=
s/linux.git/commit/?id=3Dd08089f649a0cfb2099c8551ac47eef0cc23fdf2
> > > > > > >
> > > > > > > $ git describe --contains d08089f649a0cfb2099c8551ac47eef0cc2=
3fdf2
> > > > > > > v6.3-rc1~136^2~7
> > > > > > >
> > > > > > > David, I also tried your cifs-netfs tree available here:
> > > > > > >
> > > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linu=
x-fs.git/log/?h=3Dcifs-netfs
> > > > > > >
> > > > > > > This tree solves the issue. Specifically:
> > > > > > >
> > > > > > > commit 34efb2a814f1882ddb4a518c2e8a54db119fd0d8
> > > > > > > Author: David Howells <dhowells@redhat.com>
> > > > > > > Date:   Fri Oct 6 18:29:59 2023 +0100
> > > > > > > Subject: cifs: Cut over to using netfslib
> > > > > > > Link: https://git.kernel.org/pub/scm/linux/kernel/git/dhowell=
s/linux-fs.git/commit/?h=3Dcifs-netfs&id=3D34efb2a814f1882ddb4a518c2e8a54db=
119fd0d8
> > > > > > >
> > > > > > > This netfslib work looks like quite a big refactor. Is there =
any plans to land this in 6.8? Or will this be 6.9 / later?
> > > > > > >
> > > > > > > Do you have any suggestions on how to fix this with a smaller=
 delta in 6.3 -> 6.8-rc3 that the stable kernels can use?
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Matthew
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
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
