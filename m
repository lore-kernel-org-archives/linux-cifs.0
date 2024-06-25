Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9B146A86
	for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2024 07:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719301313; cv=none; b=UfECLB7sxQi/m21NkIlvOBGWyAbPeezLKXqF83g0f9Kz7Hwy5VP6uFXG5npQ+BEUzKgVN+/BZTShgqIF5TLxSTKCA3hkN/Mro+Wo+GJgFR3HQazVcjXWnUF+cxq3zRrnRF6NGriQDLJCxwdPSIUDOKkajLPA4cvrrKQ+xPnoQTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719301313; c=relaxed/simple;
	bh=DGVduj+HF7ZyTbZnGkEAtr16n/b15rqbw2R3B7JMOPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aR0zSf8bxnJpgGrGRJjnQ0jePVqAJg6fV2oeG/jl/ixPlLixjwL+GXLhcUiF3Jtj9O3D01tBCS9bGOxdu5HmCmFKG02NeDf409VJZTSxap86axHBDZIp9NGYTbvcgu15bi5G1P0Vvj4aXCAhWmmO6FyrOtx/XWTsozFyPP9ODF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com; spf=pass smtp.mailfrom=enioka.com; dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b=fPiL9pFY; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enioka.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b="fPiL9pFY"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 9F0131BF207;
	Tue, 25 Jun 2024 07:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=enioka.com; s=gm1;
	t=1719301309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mg3XLV+jWekGDuVIaRCR0Uudy8a6ob9yt7G5j1GI6x4=;
	b=fPiL9pFYpAn/gk2l9FVW3DoUaDcU3WgOeHmeK9GQhc3zYlXtrJb82pERFiHIoPVanMIVW8
	PX75TjrSgbA02qM4aISIcMVBn7w0pn+cDu++WffX51y4sxgkvWmMtbFZO/4LZRbbCd0vV5
	qf6ccR64HZI27tJHaWEy3wvucr1T16z3mPtA8IfAaMRZhV4rZGv7jf3aN0Zf+HwW9KnQW6
	RoP35kVYdjUXXzfqgqBe47Z+0kXTUQ7osmk3YP1U8mErq0WWaIcrzrbAghSKjO7hDEi5n+
	6ATEFYoOCGqvqvlXY5BsZbXRUMlnf6VcUemKa90UnFwI+dhETJbQKo4lC5m3aQ==
From: Kevin Ottens <kevin.ottens@enioka.com>
To: Steve French <smfrench@gmail.com>, Andrew Bartlett <abartlet@samba.org>
Cc: linux-cifs@vger.kernel.org, Pavel Shilovsky <piastryyy@gmail.com>,
 Jeff Layton <jlayton@kernel.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
Date: Tue, 25 Jun 2024 09:41:48 +0200
Message-ID: <2162098.9o76ZdvQCi@wintermute>
In-Reply-To: <0ed85d03cfc698093e649394739c1379443ab0c8.camel@samba.org>
References:
 <5659539.ZASKD2KPVS@wintermute>
 <CAH2r5mvQi6ydn73zZb=psyE1MujC2ovtipT-tWzX2B4q4uc+1g@mail.gmail.com>
 <0ed85d03cfc698093e649394739c1379443ab0c8.camel@samba.org>
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

On Tuesday 25 June 2024 08:00:11 CEST Andrew Bartlett wrote:
> Thanks so much Steve.

Thanks indeed!
=20
> Kevin can give more info, but no, my understanding is that this was
> "always" problematic, the reason it came up now is LibreOffice changed
> how it handled file saves, rather than a kernel change.

I confirm. It's been here for a long time AFAIK, but Libreoffice recently=20
enabled some code path by default (it was previously disabled by default).

> Even if the fix is to be in the direction that 'breaks' LibreOffice,
> that is OK, I have given Kevin a suggestion on using locks ranges
> towards the end of the file as a way to regain the desired 'advisory'
> semantics, but we wanted to be working on solid ground with consistent,
> reliable semantics that don't depend on cache modes.

Yes, the consistency is important. Once we have a solid and reliable behavi=
or=20
we can always get things adjusted higher in the stack.

Regards.


> On Sun, 2024-06-23 at 23:54 -0500, Steve French wrote:
> > This was interesting to dig through (and netfs caching changes made
> > it
> > a little harder to trace the original code) but it looks fixable. See
> > cifs_find_fid_lock_conflict() in fs/smb/client/file.c.   It does not
> > look new though - so let me know if you noticed that the behavior in
> > earlier kernels was different for the default case (smb3.1.1 mounts
> > with caching enabled).
> >=20
> > The problem seems to be that locking is enforced only in some write
> > paths, but these places where we do write vs. byte range locking
> > checks (although at first glance may seem logical) obviously do not
> > follow POSIX semantics which would allow a write to a locked range
> > (even if POSIX behavior is counter-intuitive and different from
> > Windows semantics).  Two obvious things to fix that I see so far:
> >=20
> > 1) It was harder than expected to trace since looks like we don't
> > have
> > good dynamic (or static for that matter) tracepoints for the write
> > and
> > write error paths (although netfs fortunately has a few) - so
> > obviously should add a few tracepoints to make it easier to narrow
> > this kind of thing down in the future
> > 2) We need to make changes to how we check lock conflicts.  See
> > cifs_writev() and its call to cifs_find_lock_conflict(). It looks
> > like
> > this is the original commit that may have caused the problem:
> > commit 85160e03a79e0d7f9082e61f6a784abc6f402701
> > Author: Pavel Shilovsky <
> > piastry@etersoft.ru
> >=20
> > Date:   Sat Oct 22 15:33:29 2011 +0400
> >=20
> >     CIFS: Implement caching mechanism for mandatory brlocks
> >    =20
> >     If we have an oplock and negotiate mandatory locking style we
> >=20
> > handle
> >=20
> >     all brlock requests on the client.
> >=20
> > On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <
> > abartlet@samba.org
> >=20
> > > wrote:
> > > (resend due spam rules on list)
> > >=20
> > > Kia Ora Steve,
> > >=20
> > > I'm working with Kevin on this, and I set up a clean environment
> > > with
> > > the latest software to make sure this is all still an issue on
> > > current
> > > software:
> > >=20
> > > I was hoping to include the old SMB1 unix extensions in this test
> > > also,
> > > but these seem unsupported in current kernels.  When did they go
> > > away?
> > >=20
> > > Anyway, here is the data.  It certainly looks like an issue with
> > > the
> > > SMB3 client, as only the client changes with the cache=3Dnone
> > >=20
> > > Server is Samba 4.20.1 from Debian Sid.  Kernel is
> > > Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC
> > > Debian
> > > 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
> > >=20
> > > With SMB1 but not unix extensions (seems unsupported):
> > >=20
> > > root@debian-sid-cifs-client:~# mount.cifs
> > > //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpass,vers=3D1.0
> > > root@debian-sid-cifs-client:~# cd mnt/
> > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > Testing with foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: x count: 0
> > > Third file descriptor 5
> > > Wrote to third fd: 1
> > >=20
> > > root@debian-sid-cifs-client:~# mount.cifs
> > > //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix
> > > root@debian-sid-cifs-client:~# cd mnt/
> > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > Testing with foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: x count: -1
> > > Third file descriptor 5
> > > Wrote to third fd: -1
> > > root@debian-sid-cifs-client:~# mount.cifs
> > > //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
> > >=20
> > > root@debian-sid-cifs-client:~# mount.cifs
> > > //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix,nobrl
> > > root@debian-sid-cifs-client:~# cd mnt/
> > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > Testing with foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: o count: 1
> > > Third file descriptor 5
> > > Wrote to third fd: 1
> > >=20
> > > And with cache=3Dnone
> > >=20
> > > root@debian-sid-cifs-client:~# mount.cifs
> > > //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix,cache=3Dn=
one
> > > root@debian-sid-cifs-client:~# cd mnt/
> > > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > > Testing with foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: o count: 1
> > > Third file descriptor 5
> > > Wrote to third fd: 1
> > >=20
> > > On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > > > What is the behavior with "nobrl" mount option? and what is the
> > > > behavior when running with the POSIX extensions enabled (e.g. to
> > > > current Samba or ksmbd adding "posix" to the mount options)
> > > >=20
> > > > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > > > kevin.ottens@enioka.com
> > > >=20
> > > > > wrote:
> > > > > Hello,
> > > > >=20
> > > > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > > > POSIX file
> > > > > locks in conjunction with CIFS mounts. In short: just before
> > > > > saving, it
> > > > > reopens a file on which it already holds a file lock (via
> > > > > another
> > > > > file
> > > > > descriptor in the same process) in order to read from it to
> > > > > create
> > > > > a backup
> > > > > copy... but the read call fails.
> > > > >=20
> > > > > I've been in discussion with Andrew Bartlett for a little while
> > > > > regarding this
> > > > > issue and, after exploring several venues, he advised me to
> > > > > send an
> > > > > email to
> > > > > this list in order to get more opinions about it.
> > > > >=20
> > > > > The latest discovery we did was that the cache option on the
> > > > > mountpoint seems
> > > > > to impact the behavior of the POSIX file locks. I made a
> > > > > minimal
> > > > > test
> > > > > application (attached to this email) which basically does the
> > > > >=20
> > > > > following:
> > > > >  * open a file for read/write
> > > > >  * set a POSIX write lock on the whole file
> > > > >  * open the file a second time and try to read from it
> > > > >  * open the file a third time and try to write to it
> > > > >=20
> > > > > It assumes there is already some text in the file. Also, as it
> > > > > goes
> > > > > it outputs
> > > > > information about the calls.
> > > > >=20
> > > > > The output I get is the following with cache=3Dstrict on the
> > > > > mount:
> > > > > ---
> > > > > Testing with /mnt/foo
> > > > > Got new file descriptor 3
> > > > > Lock set: 1
> > > > > Second file descriptor 4
> > > > > Read from second fd: x count: -1
> > > > > Third file descriptor 5
> > > > > Wrote to third fd: -1
> > > > > ---
> > > > >=20
> > > > > If I'm using cache=3Dnone:
> > > > > ---
> > > > > Testing with /mnt/foo
> > > > > Got new file descriptor 3
> > > > > Lock set: 1
> > > > > Second file descriptor 4
> > > > > Read from second fd: b count: 1
> > > > > Third file descriptor 5
> > > > > Wrote to third fd: 1
> > > > > ---
> > > > >=20
> > > > > That's the surprising behavior which prompted the email on this
> > > > > list. Is it
> > > > > somehow intended that the cache option would impact the
> > > > > semantic of
> > > > > the file
> > > > > locks? At least it caught me by surprise and I wouldn't expect
> > > > > such
> > > > > a
> > > > > difference in behavior.
> > > > >=20
> > > > > Now, since the POSIX locks are process wide, I would have
> > > > > expected
> > > > > to have the
> > > > > output I'm getting for the "cache=3Dnone" case to be also the one
> > > > > I'm
> > > > > getting
> > > > > for the "cache=3Dstrict" case.
> > > > >=20
> > > > > I'm looking forward to feedback on this one. I really wonder if
> > > > > we
> > > > > missed
> > > > > something obvious or if there is some kind of bug in the cifs
> > > > > driver.
> > > > >=20
> > > > > Regards.
> > > > > --
> > > > > K=C3=A9vin Ottens
> > > > > kevin.ottens@enioka.com
> > > > >=20
> > > > >=20
> > > > > +33 7 57 08 95 13
> > >=20
> > > --
> > >=20
> > > Andrew Bartlett (he/him)
> > > https://samba.org/~abartlet/
> > >=20
> > > Samba Team Member (since 2001)
> > > https://samba.org
> > >=20
> > > Samba Team Lead
> > > https://catalyst.net.nz/services/samba
> > >=20
> > > Catalyst.Net Ltd
> > >=20
> > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > > company
> > >=20
> > > Samba Development and Support:
> > > https://catalyst.net.nz/services/samba
> > >=20
> > >=20
> > > Catalyst IT - Expert Open Source Solutions
> > >=20
> > > --
> > > Andrew Bartlett (he/him)
> > > https://samba.org/~abartlet/
> > >=20
> > > Samba Team Member (since 2001)
> > > https://samba.org
> > >=20
> > > Samba Team Lead
> > > https://catalyst.net.nz/services/samba
> > >=20
> > > Catalyst.Net Ltd
> > >=20
> > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > > company
> > >=20
> > > Samba Development and Support:
> > > https://catalyst.net.nz/services/samba
> > >=20
> > >=20
> > > Catalyst IT - Expert Open Source Solutions


=2D-=20
K=C3=A9vin Ottens
kevin.ottens@enioka.com
+33 7 57 08 95 13


