Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E426430BAF
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 10:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772360186; cv=pass; b=ThE1Y8EOkcdE/Wx2cN+B9Xa7cmKV3RunTPxgqUJrM1h2Dflv5Ru+Hux3/gBbNxKrviz+BwN4nK/UbrQ7x/loiBVuA8Yam/ASIq9yx7g3wa9Hc2SbmHL1DkF/95pKzsLAGSUxubSu2ocZ/FlcKEbBP/jnT/uyz452SRFgmuUmraY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772360186; c=relaxed/simple;
	bh=s7rfjnPtFd6SU6xoPH3SYe9hNrVk5+6PWUoUYgGCnIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQniZ0UHdc0Yizy9PmPTEGDp2OFhJKPCRjfPV77k/T8NkaKK0CYx4j4zfGA5VcMkTwo+u5cw5fnZth1nOiTaprVbahdfzXNqT7JIe/4JZ3QxORvLoWArORPsJUlqNitaMaFUbYxJ6pFnwY0h2lbZgVbGApa2k7Cxz2NrjD++9pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N04lOntM; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N04lOntM"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-948029fb1f2so1043455241.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2026 02:16:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772360184; cv=none;
        d=google.com; s=arc-20240605;
        b=C9sdDPBOqmHnq9dR2O0c6bpy5kpM9xNW07WfLJoAvGzWgH719H6W6eHZ8i5JWKBcdA
         o4M4Rk0Ph/YUNeDaO12mNSHBiQVn8xd14UvrgJZiLhkODhP1mcb9+HYMhWy9FBaBSG4N
         wcXO8GgM+0oZlJ0/PopmskyQyqnvlC+EQmCrdQHEHBBM7BICKk9EMBqBDyCOLH0yo8Uz
         0bS5rWWmXIIj8J2HpjXh/Vbl7p6JrLA0ISrboGKDLi5C7kcWG3BrUZpblZifj8Vyj3YU
         JwmFKlU+CrhkORhEYXhn7EAm/VHYbPNXvp3kw/Fs/mom80+p1m0WfrB03f9hOnHfgTMZ
         Gctw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZrlN72XdG30IkaSiOSU/cpdfc/g67VmbA5qDRZerWc4=;
        fh=kvCWJ2IepAC7CyDgcPozIW9zEPyEAKby42qcQqAUu3c=;
        b=ksMJwxaYtq6brc/OKC+xZwHTJsAXL/4B1Rs49C2KdjcdZl/IBXaVheBtVary893K3P
         iDKc5PHswaZ+QJcZoySUgccZ6HD64dwXbk031/A7EEy0llD92H78ECfJpULzwdPDJoeb
         QoFSm1P/znglXFe67ORQm6cIqafRM5lgUftEUvnrZfHi4M0XFFqnwqwiENmDwKXotZ5V
         0rYnPXx/ctclKfOn32zjKOBwQbEyaUhaf6rr29EhdA0QCJvdG0AmaJ5w5ECMOMyqjOD6
         4pT5OtWE9ZlO973g0j0Bo/Vp+AWJcXvPseoQMDOp/E/wcAiTE4VURGlp4a12u0ECDSHs
         QM2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772360184; x=1772964984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrlN72XdG30IkaSiOSU/cpdfc/g67VmbA5qDRZerWc4=;
        b=N04lOntMi64Tm+WqmzZhhWbQVrZnkQBqb/MlNznFDsXrPLPhUMz2dw+9bZmRLd62x6
         gIZip+2v7bDGN3YmJtyk4HJAS4UVN1WG1U0Aqu+faG+/IK+3n9PscrvR3J8Hc2r3L5vD
         A5uXJoMIZWCHG9gWgha3KPr9hJU5Pwao6gkNx9B+qbzu5kCnHRCJ5NXOFZVE81rWZMuy
         oNEWxKfvREP7ll/7g5gPcPb1e+5IBkH+hqPqacUdRkaFalxafjYraKIm9CEePams18fe
         kE2Ybd6TdGJv+3qXBbPDTeW23hLy3ZGb08T1SoziBB2S3B18vq2kSbBKkP1SUMhuR+Hw
         L1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772360184; x=1772964984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZrlN72XdG30IkaSiOSU/cpdfc/g67VmbA5qDRZerWc4=;
        b=A8I1tjKGUmJ0bI7wil2mNIXuCLKgGdDZAgLgjHnIc5aQ5aKSBzr4wvBsMGr3sxQZEs
         d21oR4DCAMD8p74J15bfDS6rOQaznkldMIgzbgBQ0Y66gAZjVRYA1YWmwaTGWzbMSQ2C
         Z3rF3mloVMub6beoMCpErgFZg+gbXI7X+QrMzZVv4TWH0yUOT9bz1bhj5pRFv+CNtwU6
         Glw4FJRKhGzxSKcWaPxhdZvj80G/2yZkkd9hgEU1CX4EyM3hFgkcvnjGm8b8mog808og
         4rIs7dWoHb0cfqxigvsE9xbg3L9H1KnVBfxfqQMckwEMqUAanoDnjejT/Og9d8sDgB/l
         vuOw==
X-Forwarded-Encrypted: i=1; AJvYcCXd3jK9hkz7F7souCGHeSl/u/sqcriytkVDQcGnVoPPhkItklIMpBCLwd7sdunCgR83qpCb+NLWAZLo@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz+UtZ1NJKiwkX6oUV9ap9VUAkkaD/YTVadPPd5FGtguznVLfY
	yHRKGF3RoNnkv6IsHfM7YbmSDzrLIU9vBgiiX4bmzc5oyDx4XfBC/Z0iro6l3MiIm7HRvOj5I+/
	OcZF1LcbuTvZUa4Nivo3oNrplrzojC+4=
X-Gm-Gg: ATEYQzwkgqTJUzvh+BTibqqYphgxN0sgGL7OpNjJkCZb+4CY68+GkQyrauuii776iu1
	FIffkovbG939fbcvZBf7nWFsD1PoVWpdk38xdcYZH0L5HAQlnuYSE4x1ZZuKIAYmmyy+IOm6WFQ
	i8ymVbKIZHXmNE8QckgDJj2G0Y5zwjD8fN6CSPyn0xbXH5YEji71fiA4R5pDM7gsAQEtfPOaB0T
	gu3gDERstPWjAwIWmqfK4Sve2udkey6sYi9vXqwAx9iDsPl4LPhiM/LgcRIc0Xvs/CVhENnZytb
	vuaIgZNFM6At+LXfcE8opTRGb2EayNzpT1FDXX21aQ==
X-Received: by 2002:a05:6102:5091:b0:5f7:24dc:3ac3 with SMTP id
 ada2fe7eead31-5ff322bf4bdmr2863289137.7.1772360184080; Sun, 01 Mar 2026
 02:16:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260221145915.81749-1-dorjoychy111@gmail.com>
In-Reply-To: <20260221145915.81749-1-dorjoychy111@gmail.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sun, 1 Mar 2026 16:16:13 +0600
X-Gm-Features: AaiRm52S_i7uxGvz2GvDZgmu6T0jp37pcUwvZrAaDhnW-l9lgBlZerFtvlbrSME
Message-ID: <CAFfO_h6Y1QcW7mNGdCuY-_J6zrF_F8aW+Q8O9SvoBbXTxteFjQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] OPENAT2_REGULAR flag support in openat2
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, jlayton@kernel.org, 
	chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
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

Ping...
Requesting for review on this patch series please.

Regards,
Dorjoy

On Sat, Feb 21, 2026 at 8:59=E2=80=AFPM Dorjoy Chowdhury <dorjoychy111@gmai=
l.com> wrote:
>
> Hi,
>
> I came upon this "Ability to only open regular files" uapi feature sugges=
tion
> from https://uapi-group.org/kernel-features/#ability-to-only-open-regular=
-files
> and thought it would be something I could do as a first patch and get to
> know the kernel code a bit better.
>
> I only tested this new flag on my local system (fedora btrfs).
>
> Note that I had submitted a v4 previously (that had -EINVAL for the atomi=
c_open
> code paths) but did not do a get_maintainers.pl. It didn't get any review=
 and
> please ignore that one anyway. In this version, I have tried to properly =
update
> the filesystems that provide atomic_open (fs/ceph, fs/nfs, fs/smb, fs/gfs=
2,
> fs/fuse, fs/vboxsf, fs/9p) for the new OPENAT2_REGULAR flag. Some of them
> (fs/fuse, fs/vboxsf, fs/9p) didn't need any changing. As far as I see, mo=
st of
> the filesystems do finish_no_open for ~O_CREAT and have file->f_mode |=3D=
 FMODE_CREATED
> for the O_CREAT code path which I assume means they always create new fil=
e which
> is a regular file. OPENAT2_REGULAR | O_DIRECTORY returns -EINVAL (instead=
 of working
> if path is either a directory or regular file) as it was easier to reason=
 about when
> making changes in all the filesystems.
>
> Changes in v4:
> - changed O_REGULAR to OPENAT2_REGULAR
> - OPENAT2_REGULAR does not affect O_PATH
> - atomic_open codepaths updated to work properly for OPENAT2_REGULAR
> - commit message includes the uapi-group URL
> - v3 is at: https://lore.kernel.org/linux-fsdevel/20260127180109.66691-1-=
dorjoychy111@gmail.com/T/
>
> Changes in v3:
> - included motivation about O_REGULAR flag in commit message e.g., progra=
ms not wanting to be tricked into opening device nodes
> - fixed commit message wrongly referencing ENOTREGULAR instead of ENOTREG
> - fixed the O_REGULAR flag in arch/parisc/include/uapi/asm/fcntl.h from 0=
60000000 to 0100000000
> - added 2 commits converting arch/{mips,sparc}/include/uapi/asm/fcntl.h O=
_* macros from hex to octal
> - v2 is at: https://lore.kernel.org/linux-fsdevel/20260126154156.55723-1-=
dorjoychy111@gmail.com/T/
>
> Changes in v2:
> - rename ENOTREGULAR to ENOTREG
> - define ENOTREG in uapi/asm-generic/errno.h (instead of errno-base.h) an=
d in arch/*/include/uapi/asm/errno.h files
> - override O_REGULAR in arch/{alpha,sparc,parisc}/include/uapi/asm/fcntl.=
h due to clash with include/uapi/asm-generic/fcntl.h
> - I have kept the kselftest but now that O_REGULAR and ENOTREG can have d=
ifferent value on different architectures I am not sure if it's right
> - v1 is at: https://lore.kernel.org/linux-fsdevel/20260125141518.59493-1-=
dorjoychy111@gmail.com/T/
>
> Thanks.
>
> Regards,
> Dorjoy
>
> Dorjoy Chowdhury (4):
>   openat2: new OPENAT2_REGULAR flag support
>   kselftest/openat2: test for OPENAT2_REGULAR flag
>   sparc/fcntl.h: convert O_* flag macros from hex to octal
>   mips/fcntl.h: convert O_* flag macros from hex to octal
>
>  arch/alpha/include/uapi/asm/errno.h           |  2 +
>  arch/alpha/include/uapi/asm/fcntl.h           |  1 +
>  arch/mips/include/uapi/asm/errno.h            |  2 +
>  arch/mips/include/uapi/asm/fcntl.h            | 22 +++++------
>  arch/parisc/include/uapi/asm/errno.h          |  2 +
>  arch/parisc/include/uapi/asm/fcntl.h          |  1 +
>  arch/sparc/include/uapi/asm/errno.h           |  2 +
>  arch/sparc/include/uapi/asm/fcntl.h           | 35 +++++++++---------
>  fs/ceph/file.c                                |  4 ++
>  fs/gfs2/inode.c                               |  2 +
>  fs/namei.c                                    |  4 ++
>  fs/nfs/dir.c                                  |  4 +-
>  fs/open.c                                     |  4 +-
>  fs/smb/client/dir.c                           | 11 +++++-
>  include/linux/fcntl.h                         |  2 +
>  include/uapi/asm-generic/errno.h              |  2 +
>  include/uapi/asm-generic/fcntl.h              |  4 ++
>  tools/arch/alpha/include/uapi/asm/errno.h     |  2 +
>  tools/arch/mips/include/uapi/asm/errno.h      |  2 +
>  tools/arch/parisc/include/uapi/asm/errno.h    |  2 +
>  tools/arch/sparc/include/uapi/asm/errno.h     |  2 +
>  tools/include/uapi/asm-generic/errno.h        |  2 +
>  .../testing/selftests/openat2/openat2_test.c  | 37 ++++++++++++++++++-
>  23 files changed, 119 insertions(+), 32 deletions(-)
>
> --
> 2.53.0
>
