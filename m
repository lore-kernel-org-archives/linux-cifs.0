Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE43D1CE6E3
	for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346371; cv=none; b=A/GmLn7vxPj+1GzVmxHnerIHPR2t5qV78VyLmIUx3oqBh/e9eHDpUUZEbL1sVDc277lChRJkUYp9UKkB0cDqXK0JuQq2/u/qHki5KwU793tEEfihkZ3QQBxvYcIuf97x2yAwVw00CQ90viAIZTRzyob63GtpwlwaLZPicGfRYZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346371; c=relaxed/simple;
	bh=3/YwzKCNlA4mxhBXv055biHoTJEOwkpzsFEQ24/EDow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4cgvVoK1W1xmbUIBx65B1nty2GIKarL+A2cjhUZz1MaTzeb4MOl7+RELgD9zCDdgXHPpGIpwXM0/qPzei435puknboUyN0fl1ZpJxte7tH02NuSHj0OmRyt1bfhoYfORN9OkRaNEpKAZkjUGwuxXB/No+G/8HyN4FIeEfq5BHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com; spf=pass smtp.mailfrom=enioka.com; dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b=k8cOiznz; arc=none smtp.client-ip=217.70.183.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enioka.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b="k8cOiznz"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 485191C0002;
	Thu, 22 Aug 2024 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=enioka.com; s=gm1;
	t=1724346363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PJNsdtVtVcJR3gtkbpZTVEhcsylZgftiJq7hX0gwc1U=;
	b=k8cOiznzUUqKc+S3KDkVMdWKu27fv5nbwg+XdEi21gHwLC+cd0RbOsdjES2OxfjNNm6hdg
	PyB1zYVqdaYPsQqA3rbzNDWvSMRuKly7EwU+VqDQpe46adsoLE4Ws176U06lxmqttS20bH
	AuwGKl2oNkciAVf9K4MBoDmtZLcyi2/a4mz0flUsjxS1aZXazzwxtdCT9vlrI9NLJ5hq7A
	63Ysz2haJuTffYFPM0ELvgzRyPwC5GfLtrBTy0JoC89C5EDI08VI7vgbJN8r/rW76zpT2g
	v/Ru+9y4P/F+yq/1zuQB1xqqKhRKTvduxkLRXlL763ycerIL3kU5qeeqaeT9Wg==
From: Kevin Ottens <kevin.ottens@enioka.com>
To: Andrew Bartlett <abartlet@samba.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
Date: Thu, 22 Aug 2024 19:06:02 +0200
Message-ID: <2720637.vYhyI6sBWr@wintermute>
In-Reply-To:
 <CAH2r5mt8oV5E4A7RDYr_PLXzDna_Xvg_i1n5bq1vXMY_Mi2=-g@mail.gmail.com>
References:
 <5659539.ZASKD2KPVS@wintermute>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mt8oV5E4A7RDYr_PLXzDna_Xvg_i1n5bq1vXMY_Mi2=-g@mail.gmail.com>
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

On Thursday 15 August 2024 22:47:21 CEST Steve French wrote:
> This (lock_test.cpp) was a nicely done test and turned out to be
> fairly easy fix (at least for the write path), and it does help your
> test (I will look at the read path next).   David also just reviewed
> it so will try to send up to mainline (and Cc: stable) fairly soon.
> See attached fix.
>=20
> Thank you again for narrowing this down.   Your testing with other
> less common configs also helped fix two additional problems - SMB1
> bugs (these two important fixes went in mainline last month).   After
> I finish the patch for the read path I also will see if anything else
> missing in the SMB3.1.1 POSIX path (on client or server side - other
> than the known Samba server bug with QFSInfo).

Thanks a lot for all this. Very much appreciated!

Regards.
=20
>     smb3: fix lock breakage for cached writes
>=20
>     Mandatory locking is enforced for cached writes, which violates
>     default posix semantics, and also it is enforced inconsistently.
>     This apparently breaks recent versions of libreoffice, but can
>     also be demonstrated by opening a file twice from the same
>     client, locking it from handle one and writing to it from
>     handle two (which fails, returning EACCES).
>=20
>     Since there was already a mount option "forcemandatorylock"
>     (which defaults to off), with this change only when the user
>     intentionally specifies "forcemandatorylock" on mount will we
>     break posix semantics on write to a locked range (ie we will
>     only fail the write in this case, if the user mounts with
>     "forcemandatorylock").
>=20
>     Fixes: 85160e03a79e ("CIFS: Implement caching mechanism for
> mandatory brlocks")
>=20
> On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <abartlet@samba.o=
rg> wrote:
> > (resend due spam rules on list)
> >=20
> > Kia Ora Steve,
> >=20
> > I'm working with Kevin on this, and I set up a clean environment with
> > the latest software to make sure this is all still an issue on current
> > software:
> >=20
> > I was hoping to include the old SMB1 unix extensions in this test also,
> > but these seem unsupported in current kernels.  When did they go away?
> >=20
> > Anyway, here is the data.  It certainly looks like an issue with the
> > SMB3 client, as only the client changes with the cache=3Dnone
> >=20
> > Server is Samba 4.20.1 from Debian Sid.  Kernel is
> > Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC Debian
> > 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
> >=20
> > With SMB1 but not unix extensions (seems unsupported):
> >=20
> > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > mnt -o user=3Dtestuser,pass=3Dpass,vers=3D1.0
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: 0
> > Third file descriptor 5
> > Wrote to third fd: 1
> >=20
> > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: -1
> > Third file descriptor 5
> > Wrote to third fd: -1
> > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
> >=20
> > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix,nobrl
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: o count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> >=20
> > And with cache=3Dnone
> >=20
> > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix,cache=3Dnone
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: o count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> >=20
> > On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > > What is the behavior with "nobrl" mount option? and what is the
> > > behavior when running with the POSIX extensions enabled (e.g. to
> > > current Samba or ksmbd adding "posix" to the mount options)
> > >=20
> > > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > > kevin.ottens@enioka.com
> > >=20
> > > > wrote:
> > > > Hello,
> > > >=20
> > > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > > POSIX file
> > > > locks in conjunction with CIFS mounts. In short: just before
> > > > saving, it
> > > > reopens a file on which it already holds a file lock (via another
> > > > file
> > > > descriptor in the same process) in order to read from it to create
> > > > a backup
> > > > copy... but the read call fails.
> > > >=20
> > > > I've been in discussion with Andrew Bartlett for a little while
> > > > regarding this
> > > > issue and, after exploring several venues, he advised me to send an
> > > > email to
> > > > this list in order to get more opinions about it.
> > > >=20
> > > > The latest discovery we did was that the cache option on the
> > > > mountpoint seems
> > > > to impact the behavior of the POSIX file locks. I made a minimal
> > > > test
> > > > application (attached to this email) which basically does the
> > > >=20
> > > > following:
> > > >  * open a file for read/write
> > > >  * set a POSIX write lock on the whole file
> > > >  * open the file a second time and try to read from it
> > > >  * open the file a third time and try to write to it
> > > >=20
> > > > It assumes there is already some text in the file. Also, as it goes
> > > > it outputs
> > > > information about the calls.
> > > >=20
> > > > The output I get is the following with cache=3Dstrict on the mount:
> > > > ---
> > > > Testing with /mnt/foo
> > > > Got new file descriptor 3
> > > > Lock set: 1
> > > > Second file descriptor 4
> > > > Read from second fd: x count: -1
> > > > Third file descriptor 5
> > > > Wrote to third fd: -1
> > > > ---
> > > >=20
> > > > If I'm using cache=3Dnone:
> > > > ---
> > > > Testing with /mnt/foo
> > > > Got new file descriptor 3
> > > > Lock set: 1
> > > > Second file descriptor 4
> > > > Read from second fd: b count: 1
> > > > Third file descriptor 5
> > > > Wrote to third fd: 1
> > > > ---
> > > >=20
> > > > That's the surprising behavior which prompted the email on this
> > > > list. Is it
> > > > somehow intended that the cache option would impact the semantic of
> > > > the file
> > > > locks? At least it caught me by surprise and I wouldn't expect such
> > > > a
> > > > difference in behavior.
> > > >=20
> > > > Now, since the POSIX locks are process wide, I would have expected
> > > > to have the
> > > > output I'm getting for the "cache=3Dnone" case to be also the one I=
'm
> > > > getting
> > > > for the "cache=3Dstrict" case.
> > > >=20
> > > > I'm looking forward to feedback on this one. I really wonder if we
> > > > missed
> > > > something obvious or if there is some kind of bug in the cifs
> > > > driver.
> > > >=20
> > > > Regards.
> > > > --
> > > > K=C3=A9vin Ottens
> > > > kevin.ottens@enioka.com
> > > >=20
> > > > +33 7 57 08 95 13
> >=20
> > --
> >=20
> > Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> > Samba Team Member (since 2001) https://samba.org
> > Samba Team Lead                https://catalyst.net.nz/services/samba
> > Catalyst.Net Ltd
> >=20
> > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > company
> >=20
> > Samba Development and Support: https://catalyst.net.nz/services/samba
> >=20
> > Catalyst IT - Expert Open Source Solutions
> >=20
> > --
> > Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> > Samba Team Member (since 2001) https://samba.org
> > Samba Team Lead                https://catalyst.net.nz/services/samba
> > Catalyst.Net Ltd
> >=20
> > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > company
> >=20
> > Samba Development and Support: https://catalyst.net.nz/services/samba
> >=20
> > Catalyst IT - Expert Open Source Solutions


=2D-=20
K=C3=A9vin Ottens
kevin.ottens@enioka.com
+33 7 57 08 95 13


