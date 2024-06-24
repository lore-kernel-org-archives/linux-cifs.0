Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87F9DDDC
	for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2024 04:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719204857; cv=none; b=QX5g0vS9WgX0dVYg9BZ2MktzAC++A8fSNVAhzt9tpOzeXfV3EenXuGQXChAiz6Q9oADnBNpAAhyspZ8pdZWM0dMguo1hzGq695EMvziOluwswBUsmDoavUzpfD8nGv3nX1aFlXhNTAU11yED91rRWi4lk5xLM9VW1Pqu9o2dCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719204857; c=relaxed/simple;
	bh=3+fCx3XtKK/JYpTO3u6bGp8DoT+Q2+19e5b6d20yr/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UPRkFbdzaNnUFBJ+95LfPapyJtArzT+uzeTCtzwHtD/b8rXRkSjD82mxXG3Wqhk5Xzvax96O7rjRsX+szMxAWGAMe3q4t1fKarCZpAEMDQlzLam73OWRhRSrZVqYD+/oKwy/6nctK5jCerPkOPSDBDCo3GFoPgv+lM8ZTGfCkWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0MMEMYm; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0MMEMYm"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5295e488248so4403374e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2024 21:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719204853; x=1719809653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlJWjPLT7i442pXS3ZXiDMyyq9aj84fm/1i+WjllsH4=;
        b=L0MMEMYmAenmqrLHDJuLj0keok6smzoutQ/YzwaHBUkhhBamF/xYgjMZg05a7PfcFw
         OzmWP7xbhL0GByZ9liwQaY07iYwX99bz+ArzTPI6hXETVfsBOhHB915BidejBIAH4NRx
         BfW6e4NmeEnEeoGnTy/rOZ79fvQg2oE1c+BZdR1Sb+7YOKczPwkhPg9wNEm3DzjsSpQp
         gPbFdB+MZDq8j4vr6RGulkMASbA+5Eh/6y36+jXFl6c9ySyrC3+8BdsfS2peqQIpzxOn
         SHatOV6DD9aid7r2BD2EhiAL7urJ3aXidAdM6AQVaxrAbMOmGo5nJE3srg9XjyK+oS5v
         GIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719204853; x=1719809653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlJWjPLT7i442pXS3ZXiDMyyq9aj84fm/1i+WjllsH4=;
        b=fIUF7dCFj6YHOv97bQEdEcAZjE3qnzg0QWn4Lrd5nTXH85VDzy37UmZBvYbNId76z1
         af9jZhVh9hvbDule7vIGVSNXyikVMG9xGkKS1S+WOctSs/dEsoG+f77xAUtKIk+sw7dS
         tF4N4BeZNPU1qLGL7H++wva0d/31wIVNXzPjUTwyQEbpLyadXFTwT6tlxyJ/g1Tc6gB2
         7XTBlvrq7QVLlBVmrcBiXkz8uqe7jXvx9p64emGzOa2k0Qa17ScmxMmuB51RirYf1CYU
         vSgnI8PUDNs1E1bxxrqfIAtbrgcz7syLoahOEGTCeyVLXo9Eip8leLSQVDxG0ml249JG
         yujQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw+a30OphUr0OrCjz0nys6ydm78TYqOzbqr2H5zHIG4X6JLxVjSaQTMkQ/RT3tcO00hlU/y7gs002XCeAncXb+egGJLxiuQmWZ4w==
X-Gm-Message-State: AOJu0YwtUxL0fzXBlp4NNtkEpeAs+mzBpwlYkpD8AZBkHDEj4j4DZCpE
	h+7U2ge0Wk/pq7ysTex5HMTD5vqzot/lcPKRCAiL5KMe+OqCLUbnsrh9ISgq4PzKoEfiB4b25SK
	GuDQ9DDkVdVHhOZEaaXXStev4bUE=
X-Google-Smtp-Source: AGHT+IECFz0xjh7IhZZV63lPBJpYq7h7MoHY7xwCq+1oXHz+sp0VJc/MJA6g6kzbOHIf+ufhyQw2CIPc9RTO6wgb2x0=
X-Received: by 2002:a05:6512:ea4:b0:52c:d5ac:d50 with SMTP id
 2adb3069b0e04-52ce186275fmr2354120e87.57.1719204852365; Sun, 23 Jun 2024
 21:54:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
In-Reply-To: <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 23 Jun 2024 23:54:00 -0500
Message-ID: <CAH2r5mvQi6ydn73zZb=psyE1MujC2ovtipT-tWzX2B4q4uc+1g@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>, Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was interesting to dig through (and netfs caching changes made it
a little harder to trace the original code) but it looks fixable. See
cifs_find_fid_lock_conflict() in fs/smb/client/file.c.   It does not
look new though - so let me know if you noticed that the behavior in
earlier kernels was different for the default case (smb3.1.1 mounts
with caching enabled).

The problem seems to be that locking is enforced only in some write
paths, but these places where we do write vs. byte range locking
checks (although at first glance may seem logical) obviously do not
follow POSIX semantics which would allow a write to a locked range
(even if POSIX behavior is counter-intuitive and different from
Windows semantics).  Two obvious things to fix that I see so far:

1) It was harder than expected to trace since looks like we don't have
good dynamic (or static for that matter) tracepoints for the write and
write error paths (although netfs fortunately has a few) - so
obviously should add a few tracepoints to make it easier to narrow
this kind of thing down in the future
2) We need to make changes to how we check lock conflicts.  See
cifs_writev() and its call to cifs_find_lock_conflict(). It looks like
this is the original commit that may have caused the problem:
commit 85160e03a79e0d7f9082e61f6a784abc6f402701
Author: Pavel Shilovsky <piastry@etersoft.ru>
Date:   Sat Oct 22 15:33:29 2011 +0400

    CIFS: Implement caching mechanism for mandatory brlocks

    If we have an oplock and negotiate mandatory locking style we handle
    all brlock requests on the client.


On Sun, Jun 9, 2024 at 11:41=E2=80=AFPM Andrew Bartlett <abartlet@samba.org=
> wrote:
>
> (resend due spam rules on list)
>
> Kia Ora Steve,
>
> I'm working with Kevin on this, and I set up a clean environment with
> the latest software to make sure this is all still an issue on current
> software:
>
> I was hoping to include the old SMB1 unix extensions in this test also,
> but these seem unsupported in current kernels.  When did they go away?
>
> Anyway, here is the data.  It certainly looks like an issue with the
> SMB3 client, as only the client changes with the cache=3Dnone
>
> Server is Samba 4.20.1 from Debian Sid.  Kernel is
> Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC Debian
> 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
>
> With SMB1 but not unix extensions (seems unsupported):
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpass,vers=3D1.0
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: x count: 0
> Third file descriptor 5
> Wrote to third fd: 1
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: x count: -1
> Third file descriptor 5
> Wrote to third fd: -1
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,unix,nobrl
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: o count: 1
> Third file descriptor 5
> Wrote to third fd: 1
>
> And with cache=3Dnone
>
> root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
> mnt -o user=3Dtestuser,pass=3Dpenguin12#,vers=3D3.1.1,posix,cache=3Dnone
> root@debian-sid-cifs-client:~# cd mnt/
> root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> Testing with foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: o count: 1
> Third file descriptor 5
> Wrote to third fd: 1
>
> On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > What is the behavior with "nobrl" mount option? and what is the
> > behavior when running with the POSIX extensions enabled (e.g. to
> > current Samba or ksmbd adding "posix" to the mount options)
> >
> > On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <
> > kevin.ottens@enioka.com
> > > wrote:
> > > Hello,
> > >
> > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > POSIX file
> > > locks in conjunction with CIFS mounts. In short: just before
> > > saving, it
> > > reopens a file on which it already holds a file lock (via another
> > > file
> > > descriptor in the same process) in order to read from it to create
> > > a backup
> > > copy... but the read call fails.
> > >
> > > I've been in discussion with Andrew Bartlett for a little while
> > > regarding this
> > > issue and, after exploring several venues, he advised me to send an
> > > email to
> > > this list in order to get more opinions about it.
> > >
> > > The latest discovery we did was that the cache option on the
> > > mountpoint seems
> > > to impact the behavior of the POSIX file locks. I made a minimal
> > > test
> > > application (attached to this email) which basically does the
> > > following:
> > >  * open a file for read/write
> > >  * set a POSIX write lock on the whole file
> > >  * open the file a second time and try to read from it
> > >  * open the file a third time and try to write to it
> > >
> > > It assumes there is already some text in the file. Also, as it goes
> > > it outputs
> > > information about the calls.
> > >
> > > The output I get is the following with cache=3Dstrict on the mount:
> > > ---
> > > Testing with /mnt/foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: x count: -1
> > > Third file descriptor 5
> > > Wrote to third fd: -1
> > > ---
> > >
> > > If I'm using cache=3Dnone:
> > > ---
> > > Testing with /mnt/foo
> > > Got new file descriptor 3
> > > Lock set: 1
> > > Second file descriptor 4
> > > Read from second fd: b count: 1
> > > Third file descriptor 5
> > > Wrote to third fd: 1
> > > ---
> > >
> > > That's the surprising behavior which prompted the email on this
> > > list. Is it
> > > somehow intended that the cache option would impact the semantic of
> > > the file
> > > locks? At least it caught me by surprise and I wouldn't expect such
> > > a
> > > difference in behavior.
> > >
> > > Now, since the POSIX locks are process wide, I would have expected
> > > to have the
> > > output I'm getting for the "cache=3Dnone" case to be also the one I'm
> > > getting
> > > for the "cache=3Dstrict" case.
> > >
> > > I'm looking forward to feedback on this one. I really wonder if we
> > > missed
> > > something obvious or if there is some kind of bug in the cifs
> > > driver.
> > >
> > > Regards.
> > > --
> > > K=C3=A9vin Ottens
> > > kevin.ottens@enioka.com
> > >
> > > +33 7 57 08 95 13
> >
> >
>
> --
>
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



--=20
Thanks,

Steve
