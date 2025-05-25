Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83C42DCC0B
	for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 22:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748213119; cv=none; b=TSxcKuXa+/FPFozW4EZHX8ziQuq2Yp5Q8iSL6j+YAcyzCbuGruHh0Vmq4J81SIzTD4UQ0GJybkSvCqGOuzh5212BoNzQTmz27PCE5bP0SNj0/VGWJV5T0KLRe+LLXFTMLgoXC6abR8iEP3YhB9PLFSFvZ0sWHFOhtjLtKorEGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748213119; c=relaxed/simple;
	bh=aE67W4Yq2hb4pbdq86LqoM1poPQx6T3hJKK7EsVKP+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ots1L345bXqUImwN4Z03reRNRyZapSEFqy1MXWZOI7DfvK7wJNanD/wu+O0v3im/KYykbAryjqYcePzH4Zad4QRznsYNuc394VJE6VrSasYynQwXB9+gzietYlEEqz5eB6pxsSXZbhLYDXO/bnE+fsdHzQQKIrx6S1YWwnuE4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Asp+SfM4; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Asp+SfM4"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-550ea5df252so3162741e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 15:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748213114; x=1748817914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c71IdX+C/bIHEZ/7Yvu11aHuzYwgdu2AG0ucx/+SRV4=;
        b=Asp+SfM4xdukmHD03eeis5c6BkL3zBXMfjCjqVdQALume24jeK0WLlAzoJtcHJmfUl
         nEZpr/L1AHmO6uQsJUIUhZUbWtxyH6kz7/5zlqFakxk1nqJy9ED68vCjTOhp0kD2Iwss
         vMiW6xt+mgl7pGz6L88D2aEmPiMPq46A0/r9G0eepjlTWQysqPRabto1/Vy4yh2uKnDP
         WbqE3f9MK7Em4V/Tj3abP5soO6w1poDZZTPpg19neYA98dvRwJv21TP52Be47A9BaVQP
         OqGSqqVLKnXPzH6OmwAN+9X/h6xBbB0pudrM2lenqEjpYC1jA9A57RYJeCYF4aiwLPGj
         JFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748213114; x=1748817914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c71IdX+C/bIHEZ/7Yvu11aHuzYwgdu2AG0ucx/+SRV4=;
        b=jakJqSy67zAypIbCx3ZWiw/io+J9HrILMjKFbGX+tHxWOhsO/TGndL27jmPWhRMDuP
         lcdH+2W9JY6dmPqNJ+Ys2hwVRYJ/BVHGqzFCSxVnjftS8OK8WM0x7GIojLyAww9zchKX
         uM9JaDXfkHT+nZgL8hckL/jzeOQ5O520L5E7rx/cSq2Y0RpiR0orYI9iF7AXBBt8hD4/
         QWRTwxHyNJrHpFNDE6H9+x4ODWrJyiPKPI+0zOuB14uh3MaZAqvO2HFCOH3ARliKjzO3
         GKoWo4fx9sYHJlYga93dCNAWbiJp9Stw/QvfUhYa1lN+DbKY0SrrTtjQ0OzJ58rDgaiL
         ACxA==
X-Forwarded-Encrypted: i=1; AJvYcCVwA50Xwou+wvLVm27FZJCJDXiXO6UmgumgV/wbzwf552cm1VHSTMPwlcqxFRa+QpG4UARgxXNp/CKN@vger.kernel.org
X-Gm-Message-State: AOJu0YyNiqVdmGAsky41lSNDNlJ8MMH+qxqvJIzFfnO3x/1Fn1STUhID
	+CxyKGaspfsHCPJi5DbjpE75JLQiNYghOmCNfC/nahBN9OxPfg3/rCmc7pOGEdHFbVZk6s/V5r5
	vlPWn8oEbBmMFoHyrlMsmrgmgHiyCl8pxmQ==
X-Gm-Gg: ASbGncv3QtSvin+UfET3dEgrI8OKKjDJ85TlBmZlSYuXhMJkI9we4VrBanQ228aQdGr
	AlcTcLSAhRqzyHvE74IpEKXwnLjwFX8+MuMpmeo3RqCdRUzvgOgDPZKQmTYzMwQ+s3L58qEz0aV
	071E6LzNbRvvIyqLC6B9mRLLd+uSoWq+QffMamr4iPyG8y1MqdkaQj4epZMxdnMM6poUY=
X-Google-Smtp-Source: AGHT+IE9mPTthvYbbaty4ebG7nFniEUxBL3gtxcAhlFq9CSG4slnAOvfoPvW3IM+AJt4xWCHSH++//oOCFzHkn4hJZk=
X-Received: by 2002:a05:6512:1395:b0:551:e99c:de65 with SMTP id
 2adb3069b0e04-552156a2b4fmr3074637e87.15.1748213113568; Sun, 25 May 2025
 15:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de> <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
In-Reply-To: <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 25 May 2025 17:45:02 -0500
X-Gm-Features: AX0GCFslDkTMWOie7ywJKrLgWK58LZ309hOMICDE0pgfUwgWBzVpl0p13i67gH0
Message-ID: <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 25, 2025 at 3:19=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sun, May 25, 2025 at 6:57=E2=80=AFAM Philipp Kerling <pkerling@casix.o=
rg> wrote:
> >
> > Hi!
> >
> > I've been reading a lot about the SAMBA 3.1.1 POSIX extensions and had
> > (perhaps wrongly?) hoped that they would allow native support for all
> > file names valid in POSIX if the server and client agree, so I could
> > continue to access my files that contain colons or quotes as I did
> > using nfs. I know there are remapping options for the reserved
> > characters, but they are very annoying to use if you want to have
> > direct access to the files on the server machine as well or want to
> > serve a directory that already exists and has "problematic" file names.
> >
> > I have been playing with this on Linux 6.14.6 with ksmbd as server and
> > Linux cifs as client. Unfortunately, I was not able to access any
> > file/folder containing, for example, a double quote character ("). From
> > what I can tell in the logs, this is due to ksmbd validating the name
> > and failing:
> >
> >    May 24 22:25:15 takaishi kernel: ksmbd: converted name =3D Jazz/SOIL=
&"PIMP" SESSIONS
> >    May 24 22:25:15 takaishi kernel: ksmbd: File name validation failed:=
 0x22
> >
> > This seems to be an explicit and intentional check for various
> > characters including ?"<>|* [1]. If not for that check, I could access
> > my files just fine (mounting with -o nomapposix of course). I've
> > patched it out locally to test and it's working great. Even smbclient
> > and gvfs are happy with it. Is this something that would make sense
> > (even if only as an option), or are there other restrictions/security
> > concerns in the SMB protocol that prevent having the special characters
> > be treated as valid?
> Files containing special characters are not recognized in Windows.
> That's why ksmbd restricts the creation of such files.
> However, it seems right to allow it when mounting posix extensions.
> So we can probably handle it like the following change.
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 3a4bffe97b54..de66eed6afb9 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2925,9 +2925,11 @@ int smb2_open(struct ksmbd_work *work)
>                                 goto err_out2;
>                 }
>
> -               rc =3D ksmbd_validate_filename(name);
> -               if (rc < 0)
> -                       goto err_out2;
> +               if (tcon->posix_extensions =3D=3D false) {
> +                       rc =3D ksmbd_validate_filename(name);
> +                       if (rc < 0)
> +                               goto err_out2;
> +               }
>
>                 if (ksmbd_share_veto_filename(share, name)) {
>                         rc =3D -ENOENT;
>
> But There is one problem. cifs.ko always sends
> SMB2_POSIX_EXTENSIONS_AVAILABLE context
> to the server regardless of mount option -o posix.
>
> Steve,
> ksmbd assumes that the client is doing smb3.1.1 posix extension mount
> if it sends SMB2_POSIX_EXTENSIONS_AVAILABLE context.
> If cifs.ko always sends SMB2_POSIX_EXTENSIONS_AVAILABLE context
> regardless of -o posix, how does the server know whether posix
> extension mount or not?

If the POSIX/Linux context is included in the SMB3.1.1 open then we
mounted with ("linux" or "posix")


--=20
Thanks,

Steve
