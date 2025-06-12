Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B42C3755
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741820; cv=none; b=jV61Q3wdBObtereP36pgTFzF51oyCwGEkSo8nP1IGFASupJt2t4vB9Vsmc6a7N276I+q3zHg2Vsvq9mavVQDfBM6eqskigGRdeaeIgr0sJ/YucpIzERviaGOsY9ifhrB7N/US8j90g7K1TXp6Vqs5Mh0ldhMm/lM+9Mh1hdvogs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741820; c=relaxed/simple;
	bh=vl+fUDKb+WV4cOO8HwCHI9JCyFeny1pkpyF5bZJKfsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WGlb0OYLzH3N9ZgFaYj1kYUoouqdjK5p7ytkCAVrHX+jik1x0cZIcGwFsrXPWm7ntOI2OaFNmuaWy36xgrwoxTjmdcGKJNY3gZ6yTk6Xe5INkxiqsaor5XKiOrQ+LR1RL8v0pXW0phjly/MzhXdvsgY8LPvvRFD0Z4ZxZKWgenU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPbwP+qX; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPbwP+qX"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32a72cb7e4dso11908411fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 08:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749741816; x=1750346616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnsKiVj47NVRzY4n461D0keXJb+XUeZ99rzGMYOWXoc=;
        b=DPbwP+qXWQ8Ink9sZJ9RDqD7OM8L2MOykBBOJ2/CWo6RJLopfwiqh37Y/tPcQFYXoJ
         qLj/LG9pbcnNkR0Q7gK7jPq/nhuRrdupGbIqcmkoK1JF1y+F7S4v7GbLgF/7gQgGza8O
         ZBOsH6n0iYGmiw+zwu+VybfRBtHAQjGoeaRBLe52giX6Ohk9dZH0yIOMf92pUu2j13CR
         P7slP+fSBgqIZ8zNhvS6FYJiSg4ORZAR8xttM6bzXA8ScvdpEnUFqxZFcNWJL3afGUmw
         DjBTwbsSwvJzMevue1zOvJg7vM9NEv6/6z5DKEvHAteIuotFwdCTnRbz1EHCh8OF08mo
         XH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749741816; x=1750346616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnsKiVj47NVRzY4n461D0keXJb+XUeZ99rzGMYOWXoc=;
        b=DcwZlJaZ0qnSu0qEtQsmkIk7oqLQ3aV8GX4J55qcWjo2GhFyTDkcQk3+nEat0L9YoZ
         PlqRPaVQm2pdotuczlryfTEMQnOiJNfjynXOeE4+ypYnECS6cYuilu0mWevorrJb7Ozm
         o+ZqwOEm3T7DWES8ZWAjUiGhH7P5BD+0jasGNIyxLtmLaAi0/D9L2MIDqbVafjj2eK/I
         Z7VIVZ3e2W5gUWgy8Wd3DB0pO4KbCtvPfkabHFbJJq50jsJv3yuqzyPC/+YhNigsSSWA
         mMRtFH2Y2CGaEFytkVZUjZuXa/cvL70xkKGgwRulf6wAm1UaVdMogBA1Jr7YtecDdLSm
         Qerg==
X-Gm-Message-State: AOJu0YzkbkVIU/jrat1L/KRC9OzyyAbYBMhDDhvgaQOGU2asESvz7Blp
	msTfi2ORUI5Dwe/3ywAm46eqMbvlaQ+2/HaF7q+ORQQrkasFrtDVuoPxEkD9a7Ry7e0IRGZVk/A
	jwyaFrPnvOqQ/sYJheCwopWWwjG06hTU=
X-Gm-Gg: ASbGnctxqmatmk8uNEq+pbZ47Th8v4cSkJYPvn7NqkoWpJfMJrBx3WeXrnAOYwKMM3H
	rcAD1MX5hTuYu+ZrWFLeJnV+uw1j6BlSISxKpTnPdKJG9wVu41EgyLbtBVkaOmqoiO8g//tQORH
	sqxE6WsuI6XZi0Kz3l9zKIIi31BR27xjKQjE5FhjZwFA==
X-Google-Smtp-Source: AGHT+IE+RAqyRLCX5/++7kVi9l5pjPP7oGSMoRah65rMpqZmfLWQQviAtDh5oDXGiP4VnELejRBqzNTJKEljT52aeek=
X-Received: by 2002:a2e:be1f:0:b0:32a:83b5:34ba with SMTP id
 38308e7fff4ca-32b30701949mr11160141fa.20.1749741815910; Thu, 12 Jun 2025
 08:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
 <466171.1749738030@warthog.procyon.org.uk> <CAH2r5msdNx3ADkr2+AGqtWWW1x2v9p7x0JdDbh8NrA1qAs5gqw@mail.gmail.com>
In-Reply-To: <CAH2r5msdNx3ADkr2+AGqtWWW1x2v9p7x0JdDbh8NrA1qAs5gqw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Jun 2025 10:23:25 -0500
X-Gm-Features: AX0GCFu6n4k7Q6FprKjeYpfzudDeWNXJ0rcEc9CxIzd4r3xSWFaE7fJBJelyUuA
Message-ID: <CAH2r5mv2iKPkFa8xaAL7dR+8RjA99GLE139fKtrYF0pNr=-isw@mail.gmail.com>
Subject: Re: netfs hang in xfstest generic/013
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I do see one suspicious thing in the dmesg log (invalidate inode
error) for generic/013:

Jun 12 09:48:46 fedora29 systemd[1]: Started fstests-generic-013.scope
- /usr/bin/bash -c "test -w /proc/self/oom_score_adj && echo 250 >
/proc/self/oom_score_adj; exec ./tests/generic/013".
                                                   Jun 12 09:48:47
fedora29 kernel: CIFS: Server share
\\linuxsmb3testsharesmc.file.core.windows.net\test does not support
copy rangeJun 12 09:48:49 fedora29 kernel: CIFS: VFS:
cifs_revalidate_mapping: invalidate inode 000000002916a2e4 failed with
rc -5
Jun 12 09:49:01 fedora29 kernel: CIFS: VFS: cifs_revalidate_mapping:
invalidate inode 000000002c7fa8ec failed with rc -5          Jun 12
09:49:02 fedora29 kernel: CIFS: VFS: cifs_revalidate_mapping:
invalidate inode 000000002c7fa8ec failed with rc -5

On Thu, Jun 12, 2025 at 10:03=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Reads  : DR=3D948 RA=3D6257 RF=3D1303 RS=3D0 WB=3D0 WBZ=3D0
> Writes : BW=3D14322 WT=3D0 DW=3D2111 WP=3D7265 2C=3D0
> ZeroOps: ZR=3D4241 sh=3D0 sk=3D0
> DownOps: DL=3D8492 ds=3D8492 df=3D6 di=3D0
> CaRdOps: RD=3D0 rs=3D0 rf=3D0
> UpldOps: UL=3D9387 us=3D9394 uf=3D73
> CaWrOps: WR=3D0 ws=3D0 wf=3D0
> Retries: rq=3D0 rs=3D0 wq=3D7 ws=3D7
> Objs   : rr=3D1 sr=3D0 foq=3D1 wsc=3D0
> WbLock : skip=3D25 wait=3D20
> -- FS-Cache statistics --
> Cookies: n=3D0 v=3D0 vcol=3D0 voom=3D0
> Acquire: n=3D0 ok=3D0 oom=3D0
> LRU    : n=3D0 exp=3D0 rmv=3D0 drp=3D0 at=3D0
> Invals : n=3D0
> Updates: n=3D0 rsz=3D0 rsn=3D0
> Relinqs: n=3D0 rtr=3D0 drop=3D0
> NoSpace: nwr=3D0 ncr=3D0 cull=3D0
> IO     : rd=3D0 wr=3D0 mis=3D0
>
> root@fedora29:~# cat /proc/fs/netfs/requests
> REQUEST  OR REF FL ERR  OPS COVERAGE
> =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D =3D=3D=3D =3D=3D =3D=3D=3D=3D =3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 00003699 DW   2 3120    0   0 @16200000 0/100000
>
> On Thu, Jun 12, 2025 at 9:20=E2=80=AFAM David Howells <dhowells@redhat.co=
m> wrote:
> >
> > Steve French <smfrench@gmail.com> wrote:
> >
> > > I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
> > > directory lease patch from Bharath and the fix for the readdir
> > > regression from Neil which look unrelated to the hang).
> > >
> > > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/build=
ers/5/builds/487/steps/29/logs/stdio
> > >
> > > There were no requests in flight, and the share worked fine (could
> > > e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak=
,
> > > or lock ordering issue with netfs. Any thoughts?
> > >
> > > root@fedora29:~# cat /proc/fs/cifs/open_files
> > > # Version:1
> > > # Format:
> > > # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
> > > <filename> <mid>
> > > 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
> > > f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928
> >
> > Can you grab the contents of /proc/fs/netfs/{stats,requests} ?
> >
> > I presume you're running without a cache?
> >
> > Would you be able to try reproducing it with some netfs tracing on?
> >
> > David
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
