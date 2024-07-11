Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D093201
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jul 2024 02:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720663411; cv=none; b=D9fM555p8dsTeHux09Xau2NW9/0NepKqTjx0PONCDMbFYQCgfqM9omyRaJmrqJYnwWZlnudFPfAkO7xGt3uVbt+zm9MrHbb4x7RsUWZ6FKOjB87C325HJpbjK8+P43ob4kM/WL6fQyy2gUOevPUw/gi04Iza331762s975DGL1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720663411; c=relaxed/simple;
	bh=wmExPUnszEWjsSift8g4ONMM3Wo5O0RJv7GXKJraoQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ns2sQLpZ2mRA4iOZi8I9FTEDfOP5vxERguC0f8Hop0OkC3dk8B2l/v1cHaSlS9c1MWujYkqJ2CWC1woAFvi9+t7AZ13fgLqCWEWw6jgudVwrwx1way1Hmh8Ni+7C/Z7WsrElXSUYE+Mq6aRkAErBmw+zSXRwGKzvAy7MdyS+xLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hAYRTYDD; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hAYRTYDD"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52ea1a69624so376691e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jul 2024 19:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720663407; x=1721268207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRiCfI93WqvJhOD7C/I62N2cCAYOp1y+1Rjy9aH2IOk=;
        b=hAYRTYDDHvuDoTfaVE679ErfowBreGpZd7MuLEZAkgIl6RTRAsJiM65aDhN7RZMwMC
         CQohOnKMuTAPVfwPpFoFJ+bfBq1TJQsvfsds0weXj+P1pOo4UHU5gl3KxbO3G7b4yhWZ
         gwxU0f+jInytG7LTduQRXWIoEH+dg7YGvfH49VTA6Yp+YFm+jl4aagRorhzyci7wnVpX
         8tV3pC2dwWi+0cfg3ClFTFXx43uyV+mneB2AAj0GZchrwgtwxwm/81sOWw1gZ88QioGj
         OBzJ94om/07p+yLAPOBG1Wss7Oc6fMvDAebDt95YeVpEI36/3sBsbCvQ5MBuoBrAueQq
         hmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720663407; x=1721268207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRiCfI93WqvJhOD7C/I62N2cCAYOp1y+1Rjy9aH2IOk=;
        b=uMiCTEyGSdDFYXWjaZPN0lwx1ZkOTWoRdCk8yLYuCHfmkamw2PR8r4K9b1v228LCey
         BKtP6i9weEhjegNSW69hewl5k4PVgM7vPSk01J+77Zt5Kclj9/9JQxuGSYsa2YFpHYv/
         NYbe/JAtuB53xqRIsc1uIkb9z8+jpKW6bNe3nIrLLuEkSbvucgbPwvp77WR62nKlBDfP
         LF0N+YtgQ+vkJ9loRkUQ87LjF3QgaEiHdKTHGGZ893keWfjKjBan4PGedysM+PYJJhhF
         fTrfsyp/xRKsXKt43X4Fmn3NKJ9LNsVc3HDmkjdt7uDvk9xy6TRAc7jgWoxoDNVWU2VF
         pYQg==
X-Forwarded-Encrypted: i=1; AJvYcCXCzGnvkpxnzEnOKaOIIw1iUiBzd8nVxtWj0udOTr1/+iIy3m0Pj7kR2krsnX6gu/1XgQ9g4ZaJIGKxv0+1lPcBPar1oUjptIVOIg==
X-Gm-Message-State: AOJu0YzUxw3R8Ht/5yftu+qEQX2hHfMKrYKs8I/SHrL4qUcMA2uBMKbv
	hnFU0iqHe6ezSy87e2QJ28ZBHYyMGEJrfqgQ6/ctvaqst1ZC4VGZxuBXcL3VMrMjqgxDSWJVwa5
	CXe1szhvzL2pRmnmDyqIVR1Mmzqg=
X-Google-Smtp-Source: AGHT+IEtvtdULdixQc82dnscSv/r7EN0tyVAVzv6b5IhCUYApUehQbRjKAYcEAud7Pbt7yqUukEgEaW+egdddA18JmY=
X-Received: by 2002:a05:6512:224a:b0:52e:9428:c6dd with SMTP id
 2adb3069b0e04-52eb99d3df9mr4585132e87.59.1720663406904; Wed, 10 Jul 2024
 19:03:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <0ed85d03cfc698093e649394739c1379443ab0c8.camel@samba.org>
 <2162098.9o76ZdvQCi@wintermute> <2693651.lGaqSPkdTl@wintermute> <db9229639fe476ca743294ae013864b2470d81a4.camel@samba.org>
In-Reply-To: <db9229639fe476ca743294ae013864b2470d81a4.camel@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 10 Jul 2024 21:03:15 -0500
Message-ID: <CAH2r5mu-TXypF+5u4r=WzsbtmC2Xxk-LvNNwwhpPskC36cWm5Q@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>, Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I haven't had a chance to look at it again this week (trying to deal
with the 6.10-rc regression in netfs/folios changes causing the
"add_credits" error) - but do plan to look at it later this week

On Wed, Jul 10, 2024 at 4:28=E2=80=AFAM Andrew Bartlett <abartlet@samba.org=
> wrote:
>
> Kia Ora Steve,
>
> Just wanting to know if there is anything more Kevin or I can usefully
> do to nudge this along, or do you have this in hand?
>
> It would be very good to get this consistent.
>
> Thanks,
>
> Andrew Bartlett
>
> On Thu, 2024-06-27 at 17:04 +0200, Kevin Ottens wrote:
> > Hello,
> >
> > Is there anyone working on a patch for this since you narrowed it
> > down a bit?
> > We can probably test the changes if that's the case.
> >
> > Regards.
> >
> > On Tuesday 25 June 2024 09:41:48 CEST Kevin Ottens wrote:
> > > Hello,
> > >
> > > On Tuesday 25 June 2024 08:00:11 CEST Andrew Bartlett wrote:
> > > > Thanks so much Steve.
> > >
> > > Thanks indeed!
> > >
> > > > Kevin can give more info, but no, my understanding is that this
> > > > was
> > > > "always" problematic, the reason it came up now is LibreOffice
> > > > changed
> > > > how it handled file saves, rather than a kernel change.
> > >
> > > I confirm. It's been here for a long time AFAIK, but Libreoffice
> > > recently
> > > enabled some code path by default (it was previously disabled by
> > > default).
> > >
> > > > Even if the fix is to be in the direction that 'breaks'
> > > > LibreOffice,
> > > > that is OK, I have given Kevin a suggestion on using locks ranges
> > > > towards the end of the file as a way to regain the desired
> > > > 'advisory'
> > > > semantics, but we wanted to be working on solid ground with
> > > > consistent,
> > > > reliable semantics that don't depend on cache modes.
> > >
> > > Yes, the consistency is important. Once we have a solid and
> > > reliable
> > > behavior we can always get things adjusted higher in the stack.
> > >
> > > Regards.
> > >
> > > > On Sun, 2024-06-23 at 23:54 -0500, Steve French wrote:
> > > > > This was interesting to dig through (and netfs caching changes
> > > > > made
> > > > > it
> > > > > a little harder to trace the original code) but it looks
> > > > > fixable. See
> > > > > cifs_find_fid_lock_conflict() in fs/smb/client/file.c.   It
> > > > > does not
> > > > > look new though - so let me know if you noticed that the
> > > > > behavior in
> > > > > earlier kernels was different for the default case (smb3.1.1
> > > > > mounts
> > > > > with caching enabled).
> > > > >
> > > > > The problem seems to be that locking is enforced only in some
> > > > > write
> > > > > paths, but these places where we do write vs. byte range
> > > > > locking
> > > > > checks (although at first glance may seem logical) obviously do
> > > > > not
> > > > > follow POSIX semantics which would allow a write to a locked
> > > > > range
> > > > > (even if POSIX behavior is counter-intuitive and different from
> > > > > Windows semantics).  Two obvious things to fix that I see so
> > > > > far:
> > > > >
> > > > > 1) It was harder than expected to trace since looks like we
> > > > > don't
> > > > > have
> > > > > good dynamic (or static for that matter) tracepoints for the
> > > > > write
> > > > > and
> > > > > write error paths (although netfs fortunately has a few) - so
> > > > > obviously should add a few tracepoints to make it easier to
> > > > > narrow
> > > > > this kind of thing down in the future
> > > > > 2) We need to make changes to how we check lock conflicts.  See
> > > > > cifs_writev() and its call to cifs_find_lock_conflict(). It
> > > > > looks
> > > > > like
> > > > > this is the original commit that may have caused the problem:
> > > > > commit 85160e03a79e0d7f9082e61f6a784abc6f402701
> > > > > Author: Pavel Shilovsky <
> > > > > piastry@etersoft.ru
> > > > >
> > > > >
> > > > > Date:   Sat Oct 22 15:33:29 2011 +0400
> > > > >
> > > > >     CIFS: Implement caching mechanism for mandatory brlocks
> > > > >
> > > > >     If we have an oplock and negotiate mandatory locking style
> > > > > we
> > > > >
> > > > > handle
> > > > >
> > > > >     all brlock requests on the client.
> > > > >
> > > > > On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <
> > > > > abartlet@samba.org
> > > > >
> > > > >
> > > > > > wrote:
> > > > > > (resend due spam rules on list)
> > > > > >
> > > > > > Kia Ora Steve,
> > > > > >
> > > > > > I'm working with Kevin on this, and I set up a clean
> > > > > > environment
> > > > > > with
> > > > > > the latest software to make sure this is all still an issue
> > > > > > on
> > > > > > current
> > > > > > software:
> > > > > >
> > > > > > I was hoping to include the old SMB1 unix extensions in this
> > > > > > test
> > > > > > also,
> > > > > > but these seem unsupported in current kernels.  When did they
> > > > > > go
> > > > > > away?
> > > > > >
> > > > > > Anyway, here is the data.  It certainly looks like an issue
> > > > > > with
> > > > > > the
> > > > > > SMB3 client, as only the client changes with the cache=3Dnone
> > > > > >
> > > > > > Server is Samba 4.20.1 from Debian Sid.  Kernel is
> > > > > > Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP
> > > > > > PREEMPT_DYNAMIC
> > > > > > Debian
> > > > > > 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
> > > > > >
> > > > > > With SMB1 but not unix extensions (seems unsupported):
> > > > > >
> > > > > > root@debian-sid-cifs-client:~# mount.cifs
> > > > > > //192.168.122.234/testuser
> > > > > > mnt -o user=3Dtestuser,pass=3Dpass,vers=3D1.0
> > > > > > root@debian-sid-cifs-client:~# cd mnt/
> > > > > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > > > > Testing with foo
> > > > > > Got new file descriptor 3
> > > > > > Lock set: 1
> > > > > > Second file descriptor 4
> > > > > > Read from second fd: x count: 0
> > > > > > Third file descriptor 5
> > > > > > Wrote to third fd: 1
> > > > > >
> > > > > > root@debian-sid-cifs-client:~# mount.cifs
> > > > > > //192.168.122.234/testuser
> > > > > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix
> > > > > > root@debian-sid-cifs-client:~# cd mnt/
> > > > > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > > > > Testing with foo
> > > > > > Got new file descriptor 3
> > > > > > Lock set: 1
> > > > > > Second file descriptor 4
> > > > > > Read from second fd: x count: -1
> > > > > > Third file descriptor 5
> > > > > > Wrote to third fd: -1
> > > > > > root@debian-sid-cifs-client:~# mount.cifs
> > > > > > //192.168.122.234/testuser
> > > > > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
> > > > > >
> > > > > > root@debian-sid-cifs-client:~# mount.cifs
> > > > > > //192.168.122.234/testuser
> > > > > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix,nobr=
l
> > > > > > root@debian-sid-cifs-client:~# cd mnt/
> > > > > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > > > > Testing with foo
> > > > > > Got new file descriptor 3
> > > > > > Lock set: 1
> > > > > > Second file descriptor 4
> > > > > > Read from second fd: o count: 1
> > > > > > Third file descriptor 5
> > > > > > Wrote to third fd: 1
> > > > > >
> > > > > > And with cache=3Dnone
> > > > > >
> > > > > > root@debian-sid-cifs-client:~# mount.cifs
> > > > > > //192.168.122.234/testuser
> > > > > > mnt -o
> > > > > > user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix,cache=3Dno=
ne
> > > > > > root@debian-sid-cifs-client:~# cd mnt/
> > > > > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > > > > Testing with foo
> > > > > > Got new file descriptor 3
> > > > > > Lock set: 1
> > > > > > Second file descriptor 4
> > > > > > Read from second fd: o count: 1
> > > > > > Third file descriptor 5
> > > > > > Wrote to third fd: 1
> > > > > >
> > > > > > On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > > > > > > What is the behavior with "nobrl" mount option? and what is
> > > > > > > the
> > > > > > > behavior when running with the POSIX extensions enabled
> > > > > > > (e.g. to
> > > > > > > current Samba or ksmbd adding "posix" to the mount options)
> > > > > > >
> > > > > > > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > > > > > > kevin.ottens@enioka.com
> > > > > > >
> > > > > > >
> > > > > > > > wrote:
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > I've been hunting down a bug exhibited by Libreoffice
> > > > > > > > regarding
> > > > > > > > POSIX file
> > > > > > > > locks in conjunction with CIFS mounts. In short: just
> > > > > > > > before
> > > > > > > > saving, it
> > > > > > > > reopens a file on which it already holds a file lock (via
> > > > > > > > another
> > > > > > > > file
> > > > > > > > descriptor in the same process) in order to read from it
> > > > > > > > to
> > > > > > > > create
> > > > > > > > a backup
> > > > > > > > copy... but the read call fails.
> > > > > > > >
> > > > > > > > I've been in discussion with Andrew Bartlett for a little
> > > > > > > > while
> > > > > > > > regarding this
> > > > > > > > issue and, after exploring several venues, he advised me
> > > > > > > > to
> > > > > > > > send an
> > > > > > > > email to
> > > > > > > > this list in order to get more opinions about it.
> > > > > > > >
> > > > > > > > The latest discovery we did was that the cache option on
> > > > > > > > the
> > > > > > > > mountpoint seems
> > > > > > > > to impact the behavior of the POSIX file locks. I made a
> > > > > > > > minimal
> > > > > > > > test
> > > > > > > > application (attached to this email) which basically does
> > > > > > > > the
> > > > > > > >
> > > > > > > > following:
> > > > > > > >  * open a file for read/write
> > > > > > > >  * set a POSIX write lock on the whole file
> > > > > > > >  * open the file a second time and try to read from it
> > > > > > > >  * open the file a third time and try to write to it
> > > > > > > >
> > > > > > > > It assumes there is already some text in the file. Also,
> > > > > > > > as it
> > > > > > > > goes
> > > > > > > > it outputs
> > > > > > > > information about the calls.
> > > > > > > >
> > > > > > > > The output I get is the following with cache=3Dstrict on
> > > > > > > > the
> > > > > > > > mount:
> > > > > > > > ---
> > > > > > > > Testing with /mnt/foo
> > > > > > > > Got new file descriptor 3
> > > > > > > > Lock set: 1
> > > > > > > > Second file descriptor 4
> > > > > > > > Read from second fd: x count: -1
> > > > > > > > Third file descriptor 5
> > > > > > > > Wrote to third fd: -1
> > > > > > > > ---
> > > > > > > >
> > > > > > > > If I'm using cache=3Dnone:
> > > > > > > > ---
> > > > > > > > Testing with /mnt/foo
> > > > > > > > Got new file descriptor 3
> > > > > > > > Lock set: 1
> > > > > > > > Second file descriptor 4
> > > > > > > > Read from second fd: b count: 1
> > > > > > > > Third file descriptor 5
> > > > > > > > Wrote to third fd: 1
> > > > > > > > ---
> > > > > > > >
> > > > > > > > That's the surprising behavior which prompted the email
> > > > > > > > on this
> > > > > > > > list. Is it
> > > > > > > > somehow intended that the cache option would impact the
> > > > > > > > semantic of
> > > > > > > > the file
> > > > > > > > locks? At least it caught me by surprise and I wouldn't
> > > > > > > > expect
> > > > > > > > such
> > > > > > > > a
> > > > > > > > difference in behavior.
> > > > > > > >
> > > > > > > > Now, since the POSIX locks are process wide, I would have
> > > > > > > > expected
> > > > > > > > to have the
> > > > > > > > output I'm getting for the "cache=3Dnone" case to be also
> > > > > > > > the one
> > > > > > > > I'm
> > > > > > > > getting
> > > > > > > > for the "cache=3Dstrict" case.
> > > > > > > >
> > > > > > > > I'm looking forward to feedback on this one. I really
> > > > > > > > wonder if
> > > > > > > > we
> > > > > > > > missed
> > > > > > > > something obvious or if there is some kind of bug in the
> > > > > > > > cifs
> > > > > > > > driver.
> > > > > > > >
> > > > > > > > Regards.
> > > > > > > > --
> > > > > > > > K=C3=A9vin Ottens
> > > > > > > > kevin.ottens@enioka.com
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > +33 7 57 08 95 13
> > > > > >
> > > > > > --
> > > > > >
> > > > > > Andrew Bartlett (he/him)
> > > > > > https://samba.org/~abartlet/
> > > > > >
> > > > > >
> > > > > > Samba Team Member (since 2001)
> > > > > > https://samba.org
> > > > > >
> > > > > >
> > > > > > Samba Team Lead
> > > > > > https://catalyst.net.nz/services/samba
> > > > > >
> > > > > >
> > > > > > Catalyst.Net Ltd
> > > > > >
> > > > > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT
> > > > > > group
> > > > > > company
> > > > > >
> > > > > > Samba Development and Support:
> > > > > > https://catalyst.net.nz/services/samba
> > > > > >
> > > > > >
> > > > > >
> > > > > > Catalyst IT - Expert Open Source Solutions
> > > > > >
> > > > > > --
> > > > > > Andrew Bartlett (he/him)
> > > > > > https://samba.org/~abartlet/
> > > > > >
> > > > > >
> > > > > > Samba Team Member (since 2001)
> > > > > > https://samba.org
> > > > > >
> > > > > >
> > > > > > Samba Team Lead
> > > > > > https://catalyst.net.nz/services/samba
> > > > > >
> > > > > >
> > > > > > Catalyst.Net Ltd
> > > > > >
> > > > > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT
> > > > > > group
> > > > > > company
> > > > > >
> > > > > > Samba Development and Support:
> > > > > > https://catalyst.net.nz/services/samba
> > > > > >
> > > > > >
> > > > > >
> > > > > > Catalyst IT - Expert Open Source Solutions
> >
> >
> >
> --
> Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> Samba Team Member (since 2001) https://samba.org
> Samba Team Lead                https://catalyst.net.nz/services/samba
> Catalyst.Net Ltd
>
> Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> company
>
> Samba Development and Support: https://catalyst.net.nz/services/samba
>
> Catalyst IT - Expert Open Source Solutions
>


--=20
Thanks,

Steve
