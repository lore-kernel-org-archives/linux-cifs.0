Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148691D4339
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jan 2025 23:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737760634; cv=none; b=YZSCeLsPWOBadDBZs7OfD9aYU1VVM4lou6NbfJna4B7XcoVel8r5U+8vDFPoVzIVJ94E+Wm9BPw0YgqoSKzmR5pD6N/XHDlAchNX/eENDTfP9EBiOD2D//fle2n7I1PVTLxVMdhM2EJvlXiCyyQUjFJa1S0ZxaYRgW7iSc3wF8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737760634; c=relaxed/simple;
	bh=teZf8fXs+EgjmxNfBZEP9QhiJVsiFHxs3k0S4+s7G3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BElYAeyJ+xT9Zl0hjp54DFadxxh4gs0Li1WMpy4yGPhjemyMm+GG0F8snZFJIXXY7y2NHixQXIOhrWGfo/4bz+BOIH/GkJQWjt+k9JlMkOVOMPpTi4bUYKJvQxo4LfMirFSQjnsQ+hFtlwMKw9cydi1RitOMeEsFHBn9uBi8vVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBou5zI6; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBou5zI6"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5401ab97206so2725888e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jan 2025 15:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737760631; x=1738365431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpKyu+vUEtaQpEF1YlABC91GoHztg30rRD9tQySVjA4=;
        b=hBou5zI67Yj/C+RyNzh2UoCoagUgNcWwh4HnaWVJf/3opjGZk4rf1+Xzkf6RCsfWXU
         Dt6xDCKikwIgVFqmcwbR1CKGKYJugUo6ofCUOA7gjxGEqAeLb9uSc3j0a5ojrMIGIdVl
         peNng6LjJ6j2AaXYJg8VOQxgbIFpBRroyUR5fcqJz6paLyWzcI6Tb4mGiZDLvUcRakvA
         BauZtPbqB4qGL5unquRLmcAYF7vWDkUtLHzhkn+GsOId7yKr31n8hA0aowUghQGxro7T
         8H9PAhBNKAVh0XQ9LBvS64QsVvCuIaisYgZDwm4n8pvtY8rsulyDI+xTZE8Xf0x1GMUD
         28ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737760631; x=1738365431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hpKyu+vUEtaQpEF1YlABC91GoHztg30rRD9tQySVjA4=;
        b=R2xoJBqbNeThPvz7yV3wFWFOJIQxMc9YjXB7Onk0OtiH2Bw7YV5PeTQB2VoXOXsLUP
         s7VDXDoqbXhnAXsVluLE/LmUqxIHFebcJ787wOrbd9hYqHjhyz6zdXY6v7+teFSZzuJD
         cTRVy30wByt7ye182PNcc/Zs43dKatmpoDvAtz8xuJ//0bus/kj8idFIvqK+MwCgzkNh
         e8NnO6ryx24PJKxV4qnp1NBROMEZev2ZRSGtLxXxlac9U1qX69IjtaAZuVFAJiWYlP50
         OgjTUvjQFv1SjhmXbzsCHnbn17LHWCAzc48ME7qT89EknhaF3fWeQTKvD5BSaaT/whMY
         HkvQ==
X-Gm-Message-State: AOJu0YxkdlTr1FO99NfmXlBBckW6b39qvu4Y4bVvjies76tmybvZi2wQ
	5e3WODH9mubJ1ymPbIYzKhB+k/tQACYxTAgXQ9CwDY01OCTKCkumU0jgKcLGv7Q6H0u8Q6I83/V
	Ym509Pe2pY3xg2zdihuUXambrAhXeHQ==
X-Gm-Gg: ASbGncvvvIfuGheFSxAulxq148jFe8cjs1i9DWPWq+btOGXMvbJzWGIEY+zx/hXhWMJ
	JF2qq+G/871VLYmh24FOLttMmMWoc8XnsPpyNhbU/ZVvNlfpcgwGW6TFKfYecYoDBFwL0HNssB2
	UfeC8x9eJpiu/hbtaLEOv5
X-Google-Smtp-Source: AGHT+IFwbOS9P8cVteUczhO4AZP0/WXDPeNGIML90fd3TwToPbGzo+KjZA+whs3Yiugexmd2ew+csujJEptm/JzsyaU=
X-Received: by 2002:a05:6512:1252:b0:542:2486:697b with SMTP id
 2adb3069b0e04-5439c22a85bmr11252462e87.10.1737760630764; Fri, 24 Jan 2025
 15:17:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <85a16504e09147a195ac0aac1c801280@fabasoft.com>
In-Reply-To: <85a16504e09147a195ac0aac1c801280@fabasoft.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Jan 2025 17:16:58 -0600
X-Gm-Features: AWEUYZnXk2TQ3rWUyAT5QN_eEGdCx3Hf85Yfp54a048QgeK6HB3xKIOCjk5tVyU
Message-ID: <CAH2r5mses6tzPEyZSGWh8XXA=n9+vfe2YcwAHbF+ZUK_6=+ovQ@mail.gmail.com>
Subject: Re: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs. 5.14.0-503.15.1.el9_5)
To: "Reiterer, Horst" <horst.reiterer@fabasoft.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Since this kernel is presumably built on Redhat's 5.14 kernel, has it
been verified whether this fails the same way on current RHEL9?


On Fri, Jan 24, 2025 at 5:05=E2=80=AFPM Reiterer, Horst
<horst.reiterer@fabasoft.com> wrote:
>
> Hi,
>
> after updating from AlmaLinux 9.4 to 9.5 (https://repo.almalinux.org/vaul=
t/9.4/BaseOS/Source/Packages/kernel-5.14.0-427.40.1.el9_4.src.rpm vs. https=
://repo.almalinux.org/vault/9.5/BaseOS/Source/Packages/kernel-5.14.0-503.15=
.1.el9_5.src.rpm), chmod gets ignored by the CIFS filesystem when executed =
against a Windows file server unless chmod happens in another process.
>
> Mount options as reported by mount:
>
>   rw,relatime,context=3Dsystem_u:object_r:tmp_t:s0,vers=3D3.1.1,cache=3Ds=
trict,username=3D<username>
>   uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D<addr>,file_mode=3D0755,di=
r_mode=3D0755,soft
>   nounix,serverino,mapposix,reparse=3Dnfs,rsize=3D4194304,wsize=3D4194304=
,bsize=3D1048576
>   retrans=3D1,echo_interval=3D60,actimeo=3D1,closetimeo=3D1
>
> Reproduction (see source below):
>
>   ./test <path/to/mountpoint>/<non-existent-filename> all
>   Unexpected mode 100555
>
> strace:
>
> openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
> close(3)                                =3D 0
> chmod("/mnt/test", 0400) =3D 0
> openat(AT_FDCWD, "/mnt/test", O_RDONLY) =3D 3
> close(3)                                =3D 0
> newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D14=
07374884039565, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D=
0, st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
> 37759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_atime_nsec=3D242552=
200, st_mtime=3D1737759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_mti=
me_nsec=3D242552200, st_ctime=3D1737759300 /* 2025-01-
> 24T23:55:00.243552200+0100 */, st_ctime_nsec=3D243552200}, 0) =3D 0
> chmod("/mnt/test", 0600) =3D 0
> newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D14=
07374884039565, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D=
0, st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
> 37759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_atime_nsec=3D242552=
200, st_mtime=3D1737759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_mti=
me_nsec=3D242552200, st_ctime=3D1737759300 /* 2025-01-
> 24T23:55:00.245552200+0100 */, st_ctime_nsec=3D245552200}, 0) =3D 0
> write(2, "Unexpected mode 100555\n", 23Unexpected mode 100555
> ) =3D 23
> exit_group(1)                           =3D ?
> +++ exited with 1 +++
>
> Workaround (executing the test in two processes):
>
>   ./test <path/to/mountpoint>/<non-existent-filename> first
>   ./test <path/to/mountpoint>/<non-existent-filename> last
>
> strace:
>
> openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
> close(3)                                =3D 0
> chmod("/mnt/test", 0400) =3D 0
> openat(AT_FDCWD, "/mnt/test", O_RDONLY) =3D 3
> close(3)                                =3D 0
> exit_group(0)                           =3D ?
> +++ exited with 0 +++
>
> newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D14=
07374884039566, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D=
0, st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
> 37759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_atime_nsec=3D152930=
200, st_mtime=3D1737759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_mti=
me_nsec=3D152930200, st_ctime=3D1737759424 /* 2025-01-
> 24T23:57:04.152930200+0100 */, st_ctime_nsec=3D152930200}, 0) =3D 0
> chmod("/mnt/test", 0600) =3D 0
> newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D14=
07374884039566, st_mode=3DS_IFREG|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D=
0, st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
> 37759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_atime_nsec=3D152930=
200, st_mtime=3D1737759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_mti=
me_nsec=3D152930200, st_ctime=3D1737759449 /* 2025-01-
> 24T23:57:29.621213500+0100 */, st_ctime_nsec=3D621213500}, 0) =3D 0
> openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
> close(3)                                =3D 0
> exit_group(0)                           =3D ?
> +++ exited with 0 +++
>
> Please let me know if your can reproduce the issue using the sample.
>
> Cheers,
>
> Horst Reiterer
>
> test.c:
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> int main(int argc, char *argv[])
> {
>   if (argc !=3D 3) {
>     fprintf(stderr, "test <path> <all|first|last>\n");
>     return 2;
>   }
>   char *path =3D argv[1];
>   char *mode =3D argv[2];
>   int fd;
>   if (strcmp(mode, "all") =3D=3D 0 || strcmp(mode, "first") =3D=3D 0) {
>     if ((fd =3D open(path, O_WRONLY|O_CREAT|O_TRUNC, 0666)) =3D=3D -1) {
>       perror("open");
>       return 1;
>     }
>     close(fd);
>     if (chmod(path, 0400) =3D=3D -1) {
>       perror("chmod");
>       return 1;
>     }
>     if ((fd =3D open(path, O_RDONLY)) =3D=3D -1) {
>       perror("open");
>       return 1;
>     }
>     close(fd);
>   }
>   if (strcmp(mode, "all") =3D=3D 0 || strcmp(mode, "last") =3D=3D 0) {
>     struct stat statbuf;
>     if (stat(path, &statbuf) =3D=3D -1) {
>       perror("stat");
>       return 1;
>     }
>     mode_t modebefore =3D statbuf.st_mode;
>     if (chmod(path, 0600) =3D=3D -1) {
>       perror("chmod");
>       return 1;
>     }
>     if (stat(path, &statbuf) =3D=3D -1) {
>       perror("stat");
>       return 1;
>     }
>     if (statbuf.st_mode =3D=3D modebefore) {
>       fprintf(stderr, "Unexpected mode %o\n", statbuf.st_mode);
>       return 1;
>     }
>     if ((fd =3D open(path, O_WRONLY|O_CREAT|O_TRUNC, 0666)) =3D=3D -1) {
>       perror("open");
>       return 1;
>     }
>     close(fd);
>   }
>   return 0;
> }
>


--
Thanks,

Steve
