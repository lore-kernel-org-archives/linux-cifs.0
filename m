Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083677082F
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771688981; cv=pass; b=dPG2NwJNgJHJw4mWQk+S9LuZ4hDqHVZ730HEvNcTcTnlL5xD9JM7Kf6ERCmoOBXkPMhYOSupsftaCKRBslJquGZbwUmhMoL3Fk/58C6iYteb3k/Ll4HZ9gILAaL3TF6ZNoahYlOjDv5LTqgM5RmAWhbU+I3d80Hs9m2RNNmB5sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771688981; c=relaxed/simple;
	bh=23P6V3/EZFsgY+c1DhMXwm+sT4gSINYfgO8QSA/c/N8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+EX2TGw/Is/Q14l96xhlvgaBsaUw1MoYdq2jo423qz3Xa81JfibPDD5DM3wmHSyaE0COIEZUR4ZpnxKPYJ122EYZhhkrMXqDFP+svHw4XKOYVCo2YHruY+h8+HIpRhsTtrqtVw70FSmF2cYRi3eyZG5ur+PPOq4mKI/ngfKgxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gkb4fODz; arc=pass smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gkb4fODz"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-56753dc51baso1369062e0c.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 07:49:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771688979; cv=none;
        d=google.com; s=arc-20240605;
        b=S39tiearQZclVuHArciDDEVLpLjd5+tXNpvjxV45Qdk4e61d6rgxAkY/K3ZtHQEoiY
         B/KcPbeu5RLNOg70z7zhzI7Qdeq37biiZcqUmP1CSIcsZOQZXZOKBAKtHZIP4RKqG57F
         88pQ7pFZzUk7B1Z+9J+yODKJqIevSnc4eiikpG/YDV9UJsO70Bgm62RxF165nnOLGJP9
         vuX3U8QWugXHAYNdgf6V1ssiJwHF96SRY4/yPQv97pl0BQj412GMtDkjlwJ/fKeV30wG
         Q1wknK/Q+oNV0ApjGNoRQDEOm+mYy0pgKBkgXtFcU3mlAzrQv7fqZsICQ0pAQ12eumrL
         mwbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+CV+mZKQ0tWQcWo2Qtxm/k6mbCGnay44Iva+S/9PlIo=;
        fh=17BnA4XS7yTusK69CrWUbY7N5cmtCbr7J8Wg3HBzQgA=;
        b=keNAG9qd91KSKcWQTv+D2hCx19QJ/XZFtXSpzctYldcrwmsnyz5J6+ZHyPHQA1E0cx
         pR12+0KCoBv/xlES4zwOl6Um+WNClWME4gyL2G1zUkgb9sVArcwuhAvHUndZE3sFsBP2
         EO+rO4HV6BA2Z4oikdYB8aQTRzpokwKVF4Oht9+D4w0d9oAU5G8LwfryONT8cN/hTZgJ
         xisOywj/l1o/mS78qsszarYxsmjBBAHnb+ZUC13akI2ChvN3+qMorkudyfQQun8RORpw
         9k7dpnn25elUlwxl84vndHJiVGPc4O/U6PxJ/WcOYU6GZONIk9kRSBH2E9uq//GYk93+
         LCpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771688979; x=1772293779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CV+mZKQ0tWQcWo2Qtxm/k6mbCGnay44Iva+S/9PlIo=;
        b=Gkb4fODzMaw1FLWV7mj2nCgQ03v5D6/tPz5gHoVwIGz2lLtM06+6FOW6rnoYecBJL1
         Uikc2GaVK1cDHI42+uotLOIYJ/g3huSLJtoxuXUDOk7Fr2lCTZn/Rl3MZ9XPCO4HPhD/
         UtNuy4LArncf6UKt57ejd7jtyhd3w5eBdWMIk4LLIA/cJVAaVdQC/TiWyiW6dNqUSFMX
         NLeThlFQuWxY0TzxS0mNhI44QpBx+ybld6i7VIXlxb3yPUx73HYZhK/4WK9tRdCVwbAe
         NMWcuQj+hR4G7Xdg0TAlaJH2OFWMi3S6BboSVmZ4WKVbvgJDdpgdpTfoWJQYQ0VwpgHE
         HDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771688979; x=1772293779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+CV+mZKQ0tWQcWo2Qtxm/k6mbCGnay44Iva+S/9PlIo=;
        b=IaEqc9ZT85q/IBJmkRuqvKflPFHHu8NU5Y48GDlUZ9PGKVbm3mMOFNliGraqwokir0
         NYKicObYexrS5qyjJmfcSDt54/fQ67H6D6PVsb3HC90iURutXf7jF7Lm67SfZs2kqmx2
         LXuwpYUIQ6VOuExJYDqFuUvGcY8D+j4Jlm2jFuq1GmfRfs4XcUqjYk/dMry6RwQEwdbD
         ms6UAvuTCpOJPpjUrfSWdGJcwkB0v7bf/gcC9j12NBWXUa5pcQAoyfIojcRr1HnnlEe9
         KtwdEVVOLDv5l9ZTlPuLaJvgzE8k1jf5siUlrD1/O3r1QeGGMyQg7iFHK20YJcsra5Mr
         BX7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXKXJ95K/eg03j+2nX3ZBmmWaMdTagzWY5Y6THzVg7no2g/K9RnYe9xG4NPrCxhgLBEqtz1stRWvHtQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzugvZ0fCG6gtKHLA+mOyOyJAvM/XK0b/r6PgdlIjiFcNL1zEte
	m7oFucc9fOnPuvJK6VP2qwseVANZqxkq0ZSsYyLfxT2/RjNqko7qXYeR1rABz84slwkI1dyXOEO
	iEVcECom38pI9adV6SOgilv/zDdfmw1w=
X-Gm-Gg: AZuq6aIrDaclLQcpjuOrLm3NfXx/tmJn9OL8KAhAGqVA2AQxq7clQ+gBWYIaIYgngfH
	OcjKiwINHkzGO80fFgZaxcuBqw7stEkMpmFd3QFyecf0u3rw0AmspEqq0jEEh6djm8eE5MIuuq0
	WxzXtF4uYIVvPel0dOxvCtPtLIgm/TOi9k7kPlzQ7Rd8Oj13Fsjn+YzGXg7iy++hsC5lBWnuzDb
	bim6Z+Ia8dd2mFs2IhhOMa66mH6c3Ln+Xu0M+jKKWkhp0YLUGRIT2eOTls0Ff2Q1NB9o4sQBDrF
	UdPkHUjLsxYPcoqDvOMWSNTEM7Da72Bp3ro3Jf51eSk=
X-Received: by 2002:a05:6102:6cd:b0:5db:f031:84ce with SMTP id
 ada2fe7eead31-5feb30aa44cmr1230671137.29.1771688978916; Sat, 21 Feb 2026
 07:49:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260221145915.81749-1-dorjoychy111@gmail.com>
In-Reply-To: <20260221145915.81749-1-dorjoychy111@gmail.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sat, 21 Feb 2026 21:49:27 +0600
X-Gm-Features: AaiRm52uxICzwXE4h2cG-NB71vMvoLaBUhNK0X1besn-bhoE2jLckvjHX39jcu4
Message-ID: <CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-sb5Mpk3ts1oVUHtg@mail.gmail.com>
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

I am not sure if my patch series made it properly to the mailing
lists. https://lore.kernel.org/linux-fsdevel/  is showing a broken
series, only the 2/4, 3/4, 4/4 and I don't see cover-letter or 1/4.
The patch series does have a big cc list (what I got from
get_maintainers.pl excluding commit-signers) and I used git send-email
to send to everyone. It's also showing properly in my gmail inbox. Is
it just the website that's not showing it properly? Should I prune the
cc list and resend? is there any limitations to sending patches to
mailing lists with many cc-s via gmail?
