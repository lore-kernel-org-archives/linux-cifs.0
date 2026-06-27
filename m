Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D972773DE
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 23:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782602492; cv=pass; b=IJpWCV2KQ6nlVAAe4BKVjfqj64HBgmPjOEyurgSNQ07iM/PBMe4WmlbawguayeNbbQ41CcJPYUyVojoi00Amh3BF4vkzkDjGbBP+LCxkZ+L93gq5GU4BhCWA0RZli9IMeu+8FW5elSt9SE/PqBJRhnt+PFQTwfB/UW/2v0wpfug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782602492; c=relaxed/simple;
	bh=1dvHWZ6wZKPZ/cjYB7O5T6PaDLL5NL9L8oOgGrFpb7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=stYgbJF4JGY4kvzxgSDSBrErPYLwqrmMd9qUnpAx6QkNL1ITVuRoS/Hn1/9aAbT2w+8LNtQHTfdzwfe9tObBBV+jmDOjenXWagGZ/QkikuZ/MkZ6kEp/y/dLgX54ldKJudtW0LSEzCKoVfR1PChqWT7qyC9wzezPhrZ/6EJqBwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghkTOCXp; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghkTOCXp"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8de7bfa31d5so33945426d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 16:21:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782602490; cv=none;
        d=google.com; s=arc-20260327;
        b=lNqAzNAtGrr2Ff1C77GpeJqQnduUegAjNsUp08FOMS6cd5x/j3GIn0Aof6lQhbiCpc
         BWkgrp1TGyVfL73I3pe85YJC9zlhD/W/sgrrDPH5p8jc8ss75l/t/mJg2ZiNOxKnk/7R
         9oUl48ufUthDfRutVWGwQbF9Ao+8jGLyVm6C4roUp5h9ldqiA/b1duQhLdlVLlSW52r8
         SpHkQH3M3ufwb+vKkb7j9uBQHpetj87uRV35kiMhRHy5m+WMFGaQt/cwZ0D+xa2VKF/e
         k0qRmWiav4hzgRwpdUHAh1sXrU/vkGvARkLDG2P3/+7u5yCtxh/FX2oqzTAAlfOTnDBB
         6YcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DFZgXEnWC29k1srizSUUAbCZ/GTFmOKcdt77b2O1vlM=;
        fh=rvGTMmfgsj//ZavmL8w2rGffh4F0xW44YfROYE9ok7E=;
        b=UVnCSDYOj4ICO4vDniRpFaHmpX0ZEujNI0DkpLOPXDUaxIRXf0nIcM43rrsouuPhSG
         Q/Xpzn/7CbzhKWFgP5VD8EDik8FgnaLvJWjBf8IrKusqdpyYiVJnZK6rtgar7F9/fSQ3
         L/GbvZ15fxeM7LIHVFBmKX/PfbU5R+GxK2Lz64oRIPBydwmLGjJIUmBM40I63Xy5Qrs1
         hG75xK6A8cMetIK9tCPDn1okJgQ3uSVqUzHAiz9y2qYCHJlSq99PCSBEapreT0YPaseh
         2LR3a9Q1iW3ukffjzhhji2s8v77KQYqpgBnEkgzSqlmXru8KJyTYpofcONMJ2jMZfM1o
         ifHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782602490; x=1783207290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFZgXEnWC29k1srizSUUAbCZ/GTFmOKcdt77b2O1vlM=;
        b=ghkTOCXpkfYVjbpVAzAz1OPbT+aqYN7UWBqpA20Q2pw30hlFCvX6q6S83tZZU3sVP+
         rqFRxvcH9x8FcZ3LLLEzndnyJPMMYNXJjC0qbKVbpZOfRzwx4QLDunETjEv6BP5CKM5S
         QastrzjWh3Sj4MattbKjQaryX9oOTy4KZuLsv96a3Up2z1qb76fmWJQbN9sT3/tvyR3A
         DDYiLJMf1DWL8Oe8fBI0vICZDlHL2s5LsuoX1CbMPPcfgv8VGt3wps1KsTnm9QAFlLlN
         xSeWei72TZVD4DgFccuJnyfDgfe6taVQNYPX5JBJnW3qNcCyGwFARyX3IpvZH8BErRtU
         ROfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782602490; x=1783207290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DFZgXEnWC29k1srizSUUAbCZ/GTFmOKcdt77b2O1vlM=;
        b=cVZ7orLBkxAsJ0ygqCiX1OFwtRpHrd4pgQgR5NcSrU9Cqxvr5/yniVnfRsRB9RIdJB
         q8bMA1YNEbkYxkOUReYdFE2fQPAU50XNI0/v0K0Z1awMr+nxSn51R/I8sNrhew3PeXm0
         BtzoMy1hahF1onoXGBPJ3bOkZWhpvRnEBb77MMIADLld4qcRhedTh6HO0YxmIczF69++
         HPkqiBjcSFbKWn7rWJKhVZ6xDYwkrSL20Nk+QqmPU8EZa9ag3T+xTlvPikijjLyKP0Xh
         jfzQ7yUuwUDyjLxGTDwRQyYP5fHlLIQJ2XPfTgM/iv50ZCvGvdnYuIl3gYSuosRlB2t2
         u6IA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7l0kpscca+CW9KB0aoutku0Sve+0BjdIUdoS7HKbMs5JlH+RixvpG/X3ecBvEeBz22SVxCdLvzU6d@vger.kernel.org
X-Gm-Message-State: AOJu0YwVD215mwcedEhdDQL9F8z2McTaV/gi4CxFnB2YTnyRYDdq3NDJ
	dJvpB25YjtmzqE1ZD/oYrdtUWhXEbaDeIxr2Q0pA2Ogt2kGFmR3/jSy79VbCwZHqQmwHX8tTkrn
	91oFVeYuQQuQkCcAdn5njaq1FLNXNd+w=
X-Gm-Gg: AfdE7cnrlfjpY5ZsdC0MvHbluC2v2y7Frymu+YAeMM2xBJxZiHZSZDWFxc6DFmXUL0q
	ojZBiAZf7xj1M9fh8/jmW/UPnxyqLFsAZldtCtQvWh+y32rzWZ5kWHZA4bNuYXHrjdg59faf8tU
	9TDG/VX4fWL006bytprN8HEL3RgtulLPjA7TIkJRrsJ9b5YkRyM/wixRY+JlEYs0D3lL8Z0VA11
	V2J+7MYPnsuLwMYf+9H1BySooSeX7B3dw3pH+Yfi9YVMiI1aZOexaitrrcp+hbNHtbEcMcsEA/c
	KFQTUWNDHJ0L1cWTzoGXKD/OlNyPB2nSj0X2N9PHUBLpWYf09CFWJXJmijcnhEL2DABvE0UmrZF
	F0KsHbv64Dz/4y7hWxWUr8Jx5nONfr0SJJC/nWKG+W1bcFfDiKinRykxHcYNaq/WYEN7M7s7UYt
	lEwAB33IwKmhA=
X-Received: by 2002:ad4:5007:0:b0:8ea:47d7:5e41 with SMTP id
 6a1803df08f44-8ea47d77402mr54305776d6.45.1782602490166; Sat, 27 Jun 2026
 16:21:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <33ca19f8-6c6e-4738-bfab-25e70f77dcf3@samba.org> <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
 <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com> <20260627231638.pbjmqnfxg6wbrlls@pali>
In-Reply-To: <20260627231638.pbjmqnfxg6wbrlls@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jun 2026 18:21:18 -0500
X-Gm-Features: AVVi8Cckom9LBZFUJhDI5L0oSy88Qtk-uwNhckOf8xmgz9B6PNqLgLGKR4G5QDA
Message-ID: <CAH2r5mujZ003gkxbGp1meQAHaCbkrZRQHWK54ZfVeeRYBzi4qA@mail.gmail.com>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Max-Ulrich Farber <m.u.farber@freenet.de>, linux-cifs@vger.kernel.org, 
	Jeremy Allison <jra@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

symlink creation with "posix" (which defaults to reparse=3Dnfs) creates
the wrong target path when it is an absolute symlink (leading slash)
e.g.

   ln -s  /mnt/scratch/file6 symlinktofile6

is sent as

   mnt/scratch/file6 instead of /mnt/scratch/file6

and stat shows:

root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# stat symlinktofile6
  File: symlinktofile6 -> mnt/scratch/file6
  Size: 17        Blocks: 8          IO Block: 16384  symbolic link
Device: 0,61 Inode: 403750517   Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: ( 1001/testuser)
Access: 2026-06-27 18:06:36.415314500 -0500
Modify: 2026-06-27 18:06:36.415314500 -0500
Change: 2026-06-27 18:06:36.418477300 -0500
 Birth: -

On Sat, Jun 27, 2026 at 6:16=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Can you give a full context of the issue/bug? Link would be enough.
> I just did not caught from this description what is the issue.
>
> On Saturday 27 June 2026 18:14:07 Steve French wrote:
> > Yes - I have verified that it is the client code (so copying Paulo and
> > Pali who did most of this code) that has the bug.   When the
> > FSCTL_SET_REPARSE_POINT is sent by the client, the leading '/' is
> > already stripped off.  This affects both reparse=3Dnfs (default)
> > and reparse=3Dwsl.    I would recommend mounting instead with
> > "mfsymlinks" (which is safer for most cases as well since the
> > symlinks are not processed by the server for the "mfsymlinks" case).
> >
> > Paulo and Pali,
> > Any ideas about this bug with absolute pathnames in symlinks being
> > broken with reparse points by stripping off the leading slash?
> >
> > On Fri, Jun 26, 2026 at 1:15=E2=80=AFPM Ralph Boehme <slow@samba.org> w=
rote:
> > >
> > > On 6/26/26 7:41 PM, Ralph Boehme wrote:
> > > > Now that we store as empty file + xattr on the server, not real
> > > > symlinks, this design decision might need to be revisited.
> > > >
> > > > I don't remember of the top of my head if this behaviour is impleme=
nted
> > > > in the client or the server. Does anyone remember? I'd have to chec=
k.
> > >
> > > it's the client: in cifs_convert_path_to_utf16() it strips the leadin=
g
> > > slash for the symlink target when called from create_native_symlink()=
.
> > >
> > > As symlinks in SMB3 POSIX may be created any way the server thinks is
> > > safe (Samba does file+xattr, it never creates real symlinks on the
> > > server), so symlinks are just a client side thing and we should allow
> > > creating absolute symlinks. POSIX allows it (and users use it), so we
> > > should (safely) also allow it in SMB3 POSIX.
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
