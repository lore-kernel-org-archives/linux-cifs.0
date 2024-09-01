Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB8623AB
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 04:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725166126; cv=none; b=aPn82d4ieUhjuDENxyCWcCrHd0Xrb47DWrduwXXfRZ/wlGG3FRD5L5ztNnkHDlrpiaGKUd0wlJ/TNux9LS8JVX9u3mZVL3i304BZIwK6WIeYXaaLh0qcJaIMx4YbZ8qxSVb2wpbQ6DeSr6QeRXA/0KjO5yIGpwWlN3JWbQ5Fthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725166126; c=relaxed/simple;
	bh=ah1NGO8dUPaCQA0TbKe3InIYlOKWxRuKF6wqxonePFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fg6cEpKQBerziPgKI/zd8NdO7ORFRozM1tOMGRY5rAbRc2EKf2ZzShP7/skuBKOOGhzEcxwxZ/inCkFdYx6cfu0k7GHctUOw2VDySVePVhbpwig5U0Gwm4tRveB8YAbzNjIkca+TepZMr/BDzAg2Mz1cMbT4Iouj8KRzp4/2ZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9mXBpdB; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9mXBpdB"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f401c20b56so35195221fa.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 21:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725166123; x=1725770923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drAn+OEogOk2hHMHcgelOrOiEyMgZLtEgfnHfSpkeaU=;
        b=k9mXBpdBvXYAK2F7iOPducxhBh2vpny/jHcL718gKggIDeHtVGpb5zfhbL0rx6H0bm
         vPN/rWIYJd3qOc8ur5xVhXC4R7RsgUrYTHN6PRCAQTUk36GognlGaBtFd1QBNCdzXdbi
         BezorLYP5NvinOIpynEgN21wQ/ShOBffsezxzwFRwYpYL/K19QsLP0hDcACjSztAAZ7U
         Y3dIjITWkKjNoY4Y9+vkQDbCPTkvnRjL4pkfACJPXRijvfbYV2m1uCZ7WgqwESISehAI
         hKIKw5hxs2P+k+8eME1fsCkmpDaKc/AxIC8pIFuEcK+v0pTynqo5ChhMzoO+zKVdFDqh
         PCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725166123; x=1725770923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drAn+OEogOk2hHMHcgelOrOiEyMgZLtEgfnHfSpkeaU=;
        b=PNZAORgf5I4AIJ8f/C8JjVOspDLiGBKb8I+HmAFUKbtHBvsx48FEqYlnl/deppBZdf
         VzOqKSH99OUve2YUJw4ywUr1RKYVfhHzXuGd9EXz5/DhxFEbiiNvN+stAUD0A/R+xShw
         RM/rmeqKC3LFpkJ8wIKhunjGdlGCWHqmyOBT2j46RB1iDT8Cn+HlyKHaJnyeb+Wq7yEO
         xH5rwyvrNErBJRgx8QT8T9zlGKyq4fiyU8RuF+BQrdOwg3o8/USi3kpnxRSJg2LHBvyW
         aZ41QM14CZgxf/oCAeR+D0UNN9EDkn8CMAnLjgFGnn8OYIzoaUB2BlTDNRRVRcotbJ6M
         LydQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk/AVnXf4OIGWb4r3zKnOH25MdeANHaVdVjajptm1fLso7v2DCo3Yba8KrpYPTOwlijdv58HHpT4e1@vger.kernel.org
X-Gm-Message-State: AOJu0YzNX3OCXCfqEPhlVKs+FsNADLq/JJKmgqdVslAe7O5++ft+ve5g
	T9P+8C6fDkzaGVQ2jAILGH0xAmoUgrgeFP4y/LeB1sPHCiUAStGqGplhEqOPwPBIoFKVM69XqmQ
	i3T3gcx3acZc68N/KRXw7MCb0BDY=
X-Google-Smtp-Source: AGHT+IGWz6Z38Wa2hHnp0bXA8MW1udP0uX+y6PAr8B8J4RuS0wRClj7foyOMg5fyYXNdy4dN6pH63cMknybSu4CaQzg=
X-Received: by 2002:a2e:be0b:0:b0:2f1:922d:cc49 with SMTP id
 38308e7fff4ca-2f612ae5983mr34998171fa.19.1725166122348; Sat, 31 Aug 2024
 21:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mt8oV5E4A7RDYr_PLXzDna_Xvg_i1n5bq1vXMY_Mi2=-g@mail.gmail.com> <2720637.vYhyI6sBWr@wintermute>
In-Reply-To: <2720637.vYhyI6sBWr@wintermute>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 23:48:30 -0500
Message-ID: <CAH2r5mvGWrkmdtW++=3uaYFyGQ=CbfJzqsjq-v38Kru1wD5HnQ@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Kevin Ottens <kevin.ottens@enioka.com>
Cc: Andrew Bartlett <abartlet@samba.org>, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

the fixes for both the read and write lock problems you pointed out
are in mainline, and I see they have made it to some stable releases
(6.10) but will likely need to be rebased to be backported to some of
the older stable kernels (hopefully some of the distros pick these up
soon as well)

On Thu, Aug 22, 2024 at 12:06=E2=80=AFPM Kevin Ottens <kevin.ottens@enioka.=
com> wrote:
>
> Hello,
>
> On Thursday 15 August 2024 22:47:21 CEST Steve French wrote:
> > This (lock_test.cpp) was a nicely done test and turned out to be
> > fairly easy fix (at least for the write path), and it does help your
> > test (I will look at the read path next).   David also just reviewed
> > it so will try to send up to mainline (and Cc: stable) fairly soon.
> > See attached fix.
> >
> > Thank you again for narrowing this down.   Your testing with other
> > less common configs also helped fix two additional problems - SMB1
> > bugs (these two important fixes went in mainline last month).   After
> > I finish the patch for the read path I also will see if anything else
> > missing in the SMB3.1.1 POSIX path (on client or server side - other
> > than the known Samba server bug with QFSInfo).
>
> Thanks a lot for all this. Very much appreciated!
>
> Regards.
>
> >     smb3: fix lock breakage for cached writes
> >
> >     Mandatory locking is enforced for cached writes, which violates
> >     default posix semantics, and also it is enforced inconsistently.
> >     This apparently breaks recent versions of libreoffice, but can
> >     also be demonstrated by opening a file twice from the same
> >     client, locking it from handle one and writing to it from
> >     handle two (which fails, returning EACCES).
> >
> >     Since there was already a mount option "forcemandatorylock"
> >     (which defaults to off), with this change only when the user
> >     intentionally specifies "forcemandatorylock" on mount will we
> >     break posix semantics on write to a locked range (ie we will
> >     only fail the write in this case, if the user mounts with
> >     "forcemandatorylock").
> >
> >     Fixes: 85160e03a79e ("CIFS: Implement caching mechanism for
> > mandatory brlocks")
> >
> > On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <abartlet@samba=
.org> wrote:
> > > (resend due spam rules on list)
> > >
> > > Kia Ora Steve,
> > >
> > > I'm working with Kevin on this, and I set up a clean environment with
> > > the latest software to make sure this is all still an issue on curren=
t
> > > software:
> > >
> > > I was hoping to include the old SMB1 unix extensions in this test als=
o,
> > > but these seem unsupported in current kernels.  When did they go away=
?
> > >
> > > Anyway, here is the data.  It certainly looks like an issue with the
> > > SMB3 client, as only the client changes with the cache=3Dnone
> > >
> > > Server is Samba 4.20.1 from Debian Sid.  Kernel is
> > > Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC Debia=
n
> > > 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
> > >
> > > With SMB1 but not unix extensions (seems unsupported):
> > >
> > > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
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
> > >
> > > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
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
> > > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> > > mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
> > >
> > > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
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
> > >
> > > And with cache=3Dnone
> > >
> > > root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
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
> > >
> > > On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > > > What is the behavior with "nobrl" mount option? and what is the
> > > > behavior when running with the POSIX extensions enabled (e.g. to
> > > > current Samba or ksmbd adding "posix" to the mount options)
> > > >
> > > > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > > > kevin.ottens@enioka.com
> > > >
> > > > > wrote:
> > > > > Hello,
> > > > >
> > > > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > > > POSIX file
> > > > > locks in conjunction with CIFS mounts. In short: just before
> > > > > saving, it
> > > > > reopens a file on which it already holds a file lock (via another
> > > > > file
> > > > > descriptor in the same process) in order to read from it to creat=
e
> > > > > a backup
> > > > > copy... but the read call fails.
> > > > >
> > > > > I've been in discussion with Andrew Bartlett for a little while
> > > > > regarding this
> > > > > issue and, after exploring several venues, he advised me to send =
an
> > > > > email to
> > > > > this list in order to get more opinions about it.
> > > > >
> > > > > The latest discovery we did was that the cache option on the
> > > > > mountpoint seems
> > > > > to impact the behavior of the POSIX file locks. I made a minimal
> > > > > test
> > > > > application (attached to this email) which basically does the
> > > > >
> > > > > following:
> > > > >  * open a file for read/write
> > > > >  * set a POSIX write lock on the whole file
> > > > >  * open the file a second time and try to read from it
> > > > >  * open the file a third time and try to write to it
> > > > >
> > > > > It assumes there is already some text in the file. Also, as it go=
es
> > > > > it outputs
> > > > > information about the calls.
> > > > >
> > > > > The output I get is the following with cache=3Dstrict on the moun=
t:
> > > > > ---
> > > > > Testing with /mnt/foo
> > > > > Got new file descriptor 3
> > > > > Lock set: 1
> > > > > Second file descriptor 4
> > > > > Read from second fd: x count: -1
> > > > > Third file descriptor 5
> > > > > Wrote to third fd: -1
> > > > > ---
> > > > >
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
> > > > >
> > > > > That's the surprising behavior which prompted the email on this
> > > > > list. Is it
> > > > > somehow intended that the cache option would impact the semantic =
of
> > > > > the file
> > > > > locks? At least it caught me by surprise and I wouldn't expect su=
ch
> > > > > a
> > > > > difference in behavior.
> > > > >
> > > > > Now, since the POSIX locks are process wide, I would have expecte=
d
> > > > > to have the
> > > > > output I'm getting for the "cache=3Dnone" case to be also the one=
 I'm
> > > > > getting
> > > > > for the "cache=3Dstrict" case.
> > > > >
> > > > > I'm looking forward to feedback on this one. I really wonder if w=
e
> > > > > missed
> > > > > something obvious or if there is some kind of bug in the cifs
> > > > > driver.
> > > > >
> > > > > Regards.
> > > > > --
> > > > > K=C3=A9vin Ottens
> > > > > kevin.ottens@enioka.com
> > > > >
> > > > > +33 7 57 08 95 13
> > >
> > > --
> > >
> > > Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> > > Samba Team Member (since 2001) https://samba.org
> > > Samba Team Lead                https://catalyst.net.nz/services/samba
> > > Catalyst.Net Ltd
> > >
> > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > > company
> > >
> > > Samba Development and Support: https://catalyst.net.nz/services/samba
> > >
> > > Catalyst IT - Expert Open Source Solutions
> > >
> > > --
> > > Andrew Bartlett (he/him)       https://samba.org/~abartlet/
> > > Samba Team Member (since 2001) https://samba.org
> > > Samba Team Lead                https://catalyst.net.nz/services/samba
> > > Catalyst.Net Ltd
> > >
> > > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > > company
> > >
> > > Samba Development and Support: https://catalyst.net.nz/services/samba
> > >
> > > Catalyst IT - Expert Open Source Solutions
>
>
> --
> K=C3=A9vin Ottens
> kevin.ottens@enioka.com
> +33 7 57 08 95 13
>
>


--
Thanks,

Steve
