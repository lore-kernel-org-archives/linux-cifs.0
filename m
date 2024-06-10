Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13191B812
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 20:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718049926; cv=none; b=Th4j2oNcXCIhXYqbGHlJLnmr6EY4yZGVDXpT4Gxs+tS3I3VzkG9E6+JKk9K723w+82lKrq2nA2qwazAROtKkA6+28jmOBlQpdbzJ6JrTNM2gcH1qhoReIblEzsqTa+R8Y5LPZw9cGjYHKVdlu+1x/aUPtOphAwMkDDGYb73Xbsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718049926; c=relaxed/simple;
	bh=yJNmEoenUWrw8vyhgqrskSHIM6AFpbBf9D3l557usME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTXJvMThBHKloqG9H3m68VUABFsSNQ9zjxRp8imhuwSoM7+bXkVxMQGp3+j4bgryX7UVfCGCW9IIySFmetcH5SX0ofs1cflXm1Biid1KmFAXfaAK5FqgH2oeHpmyMhzEF4yapCSmpILxABnkR9DuRMYm0xgcydqDglt84ot+SRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDf/Dn5n; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDf/Dn5n"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52bc335e49aso455992e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 13:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718049923; x=1718654723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dvSvY6Nl0S99MPKBQPNt0oPHjcs6hYqvsv4wixiCtI=;
        b=iDf/Dn5nNCyGJBKRlRTdesljLWa5cM4Ky/4pr2yn79BiqIQnFMXVTbNk68QX0AybtZ
         mHUxhjthAPN8A5ZGFcfL31FUu8AJWRxN6jwRqMk8kev8RTS7nQW7IysaD7TfUBkqS5jL
         JwYgBFXXlLMBoF+0aLOZJiNFg4QrF3Uz3nJf51Lpenaq9eu3b4MTOOgB6t6A+cGRbLlu
         /kgoXdcbhb5UjPosQaFSEmtGFb5F3eZzSpjti3FQajOkefsJqGmzszyics2EzC9bLNxE
         kghCkaspgt84Zr4lIlz/v7Z9SkAjz221PqXv7yhczLqI4O7IsZDJ9aloPa1GScV4m0CA
         JbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718049923; x=1718654723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dvSvY6Nl0S99MPKBQPNt0oPHjcs6hYqvsv4wixiCtI=;
        b=WkpAOtlID4v7WxvY5QthYNg+q/cTGCnJJIxx93Nrt4hol77NQK2NRgRWh6hAC0pe1i
         erJKhNk63DLCONxKgFXrkIxwrOn5KiT0sM7FqtqPwuh7w+7CaNo+lWgY8xvgRdJD1qKo
         CaOrMNU10HumG+CDdGCgwotnM+klWckgFnebrKrkpnjI+vWihKBJCjMtYMTkjDf9anfU
         3FDHVN4+pXYNjmK+OCVH6+KShTOMusQ+Cga45rRzOQjgdSmF+wEVbeRzbYpTF/wpqLJr
         Vnz7GdqDOL6v15Srzy+LifLW/vY28Joq4NJLUeL9qJOLMN2Z7He9+gKBSrhutp1OV72Y
         k/xg==
X-Forwarded-Encrypted: i=1; AJvYcCV07M41oSdrVJVLVYZgdSxMx+hY5QIKOdpPafIEdW0EfODb21NuW5NFbfNvZKTriOBZYiT+raChM0/qKPsNnDub4n3wwd2Wxu2N+w==
X-Gm-Message-State: AOJu0YyMa35LYClF47nzr8GSe0ajuKzAc44xyTOm895gDkjL/n98P+Ic
	c1A3tE2lVIH6OkKiKHuAHHzMTrowQp79BnycfprcZe3p4SfX1ORKBgxEGxJ6+XtWa3azdWmJB0y
	DYNawg8r2oiYetSB7YmvAH4qVHbwult87
X-Google-Smtp-Source: AGHT+IFPCB15Rl5ZqH+oYsl+xfa+un4/ahwk1e7E+anjCi2ryWPfWI6E2appDfQ+XQu6je+wWyixQD3/bt4waLogNw0=
X-Received: by 2002:a05:6512:252b:b0:52c:47fa:e7d3 with SMTP id
 2adb3069b0e04-52c47faea94mr4529281e87.41.1718049922403; Mon, 10 Jun 2024
 13:05:22 -0700 (PDT)
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
Date: Mon, 10 Jun 2024 15:05:10 -0500
Message-ID: <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes - the reproducer helps.  The bug is easy to reproduce.

I wanted to verify that the succeeding cases are the same that I see:
- works with "cache=3Dnone"
and
- works with "nobrl"
and
- works with "vers=3D1.0"

All other combinations fail ...

Should be straightforward to fix in cifs.ko.  Will look at a fix for
this later today.

Note that the problem with SMB3.1.1 POSIX extensions is a Samba bug -
a serious regression in the server (but trivial fix).  We are waiting
on someone to merge the oneline fix to the server (which we tested out
ok) from David.

diff --git a/source3/smbd/smb2_trans2.c b/source3/smbd/smb2_trans2.c
index b43f8f6330a..d03250a8912 100644
--- a/source3/smbd/smb2_trans2.c
+++ b/source3/smbd/smb2_trans2.c
@@ -1992,7 +1992,7 @@ static bool
fsinfo_unix_valid_level(connection_struct *conn,
                                    uint16_t info_level)
 {
        if (conn_using_smb2(conn->sconn) &&
-           fsp->posix_flags =3D=3D FSP_POSIX_FLAGS_OPEN &&
+           (fsp->posix_flags & FSP_POSIX_FLAGS_OPEN) &&
            info_level =3D=3D SMB2_FS_POSIX_INFORMATION_INTERNAL)
        {
                return true;





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



--
Thanks,

Steve
