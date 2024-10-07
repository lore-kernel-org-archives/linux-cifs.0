Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F098A12B64
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 04:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728275009; cv=none; b=RSbtcCjs73k55ja2pQ1rjBmUIvoH7cK6oCN6b8OukKmtp745zA8VHKhyzI8jOxr/URrDrxLzlOG7lKozHM/AN8mcZ9XZt4nYTdd2FCWw/qe7vhknkz3bkc86rOy8AThsG9PquoU7JdyWFjSdNcq6aWIqFzc1wFXvIrtk09RhDec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728275009; c=relaxed/simple;
	bh=DnPUPzLmwz+QbYpABJOmTLsrSIXOxNgh7KHQ4+njydk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPUd3z/qovXk9v/x+uKz7JBBMXBOQkm1PVpSq6BQKv7gxbaIFVMkH901HCws7YFRMJaScVrNOTj74jSbDeyi8bllbZ4QfCUYD3ka3XfQ4MIn2HVQhaZb1JLD4Nm3QxAG+JxrvFmGmq9J6MR3odfa7i+w1cNsqNt9EyztOPofE+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDB1ow9X; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDB1ow9X"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5398e33155fso4869805e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 06 Oct 2024 21:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728275006; x=1728879806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IE0n70gZwSC60pg1pzWrj07mzjL2pYFYuxyd30B7MY=;
        b=PDB1ow9XVRww/onBW+4TA+7lDhDLV0f7srCAUm2JADsPrkcUtos3KumQoDtcPmZvEB
         8arXhHSGgB04QcmFyTng/FHmX41qoJ/2/LqBLfK9u6duiRz4xWSCu9/nkF3Ekgojfgt8
         8Rfuh0QjpGB0XfhKRSatb534s3q5GfFLdKDOEkCYW0CRmy8ypYLhOb5iacStpYQlAH7a
         gngmbCDGrDztOipTvqoWH3PA8c/PXTqHP80dhrfyVFq/07P24anJXIHghl/5MM2nmXSu
         kGg6RJmFLnOEYTLhRqiP3FDNbiYAfcxiQ5ebpkabQbJXD3j/vuBjlVyxhkjDiUmkiLYz
         dClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728275006; x=1728879806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IE0n70gZwSC60pg1pzWrj07mzjL2pYFYuxyd30B7MY=;
        b=J023MnqAYrOotnro0dhcZW9r3Mc4maOeD/lGPB0w3Lf9BqiGCSGxCLTRtPacWcz4Ix
         /8HwuqWpzknx/j+Hyeuqk0qt4fZuQ89/zDI/hQ5A7XeOUZQ7SFYf2kHK300PYW9r7ZSQ
         ++RFVgyRan+GBUlB29OxvN6izb0mkWtNFXM8QZbwD/yzcX/MqcVCyOleYGHJvA1E0zUE
         AEBJaGvhmNThu7JGcOhKu7nvr1RP4Kqj+5lKU9f5WQDawfK1hcriaAx6VDGsoO88z51j
         WIvV5pnT1UJqLSX3XUlgX1sKxCWRaJqFyNGksNQWtohyOQdOalnR3rfzJTbVdRdGTCF4
         HpvA==
X-Gm-Message-State: AOJu0YySksi9S4xn2vQIXlzV8HsN6Y/3PfpeLnxAl/7zCw6cMJjirbj/
	QJq1cM9t9go7vfWjoicefQTdcCJ05TN9wk0VQwwOmULxoUnYGJazbiOGemzUr/3RCb9fQiJH9W6
	YZBEmVGIwChmlBX4eMVHThHJSRkUjJj9E
X-Google-Smtp-Source: AGHT+IGIf3pBIx0hIMxQ/oYIkSthSKdzmYgFKdoGA1ECck2YGFH2pS5XmqnQV1t6piQO2c+jsL7dPEpzHKG1yQ3B9Tw=
X-Received: by 2002:a05:6512:2821:b0:52c:d753:2829 with SMTP id
 2adb3069b0e04-539ab8778aemr4985572e87.19.1728275005842; Sun, 06 Oct 2024
 21:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006100046.30772-1-pali@kernel.org>
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Oct 2024 23:23:14 -0500
Message-ID: <CAH2r5mtKmLeNnicSkr2FsrLTUSO47kpYCTxKSHD1VP2iVJ8-tg@mail.gmail.com>
Subject: Re: [PATCH 0/7] cifs: Improve mount option -o reparse and support for
 native Windows sockets
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

this table looks potentially very helpful - my main focus is making sure
1) that symlinks work in the "native" windows format
2) that we recognize special files created in the various forms
(reparse nfs or wsl, and also sfu)
3) that the reparse=3Dnfs case works with or without the posix
extensions chosen on the mount
4) that we can create special files in reparse=3Dnfs and wsl, and also
sfu - use cases

On Sun, Oct 6, 2024 at 5:01=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> This patch series improves choosing reparse format when creating new
> special files.
>
> In following table is behavior of creating new special files before
> this patch series. In columns are mount options, in rows are file types
> and in each cell is reparse format which is created.
>
>           -o reparse=3Ddefault  -o reparse=3Dnfs  -o reparse=3Dwsl
> symlink      native              native          native
> socket       nfs                 nfs             wsl
> fifo         nfs                 nfs             wsl
> block        nfs                 nfs             wsl
> char         nfs                 nfs             wsl
>
>
> After this patch series the table looks like:
>
>           -o reparse=3Ddefault  -o reparse=3Dnfs  -o reparse=3Dwsl  -o re=
parse=3Dnative+nfs  -o reparse=3Dnative+wsl  -o reparse=3Dnative  -o repars=
e=3Dnone
> symlink      native              nfs             wsl             native  =
               native                 native             -disallowed-
> socket       native              nfs             wsl             native  =
               native                 native             -disallowed-
> fifo         nfs                 nfs             wsl             nfs     =
               wsl                    -disallowed-       -disallowed-
> block        nfs                 nfs             wsl             nfs     =
               wsl                    -disallowed-       -disallowed-
> char         nfs                 nfs             wsl             nfs     =
               wsl                    -disallowed-       -disallowed-
>
>
> The default behavior when no option is specified (which is same as
> -o reparse=3Ddefault) changes only for creating new sockets which are
> now created in its native NTFS form with IO_REPARSE_TAG_AF_UNIX reparse
> tag.
>
> The nfs and wsl behavior is changed to always create new special files
> in its own formats.
>
> There are new options native+nfs and native+wsl which creates by default
> in native form (symlinks + sockets) and fallbacks to nfs/wsl for other
> types (fifo, char, block). This is probably the most useful for
> interoperability. Mount option -o reparse=3Ddefault is now same as
> -o reparse=3Dnative+nfs
>
> For completeness there are also new options -o reparse=3Dnative which
> allows to creating only native types used by Windows applications
> (symlinks and sockets) and option -o reparse=3Dnone to completely disable
> creating new reparse points.
>
>
> Pali Roh=C3=A1r (7):
>   cifs: Add mount option -o reparse=3Dnative
>   cifs: Add mount option -o reparse=3Dnone
>   cifs: Add support for creating native Windows sockets
>   cifs: Add support for creating NFS-style symlinks
>   cifs: Improve guard for excluding $LXDEV xattr
>   cifs: Add support for creating WSL-style symlinks
>   cifs: Validate content of WSL reparse point buffers
>
>  fs/smb/client/cifsglob.h   |  18 +++-
>  fs/smb/client/fs_context.c |  16 +++
>  fs/smb/client/fs_context.h |   4 +
>  fs/smb/client/reparse.c    | 211 +++++++++++++++++++++++++++++++------
>  fs/smb/client/reparse.h    |   2 +
>  5 files changed, 218 insertions(+), 33 deletions(-)
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
