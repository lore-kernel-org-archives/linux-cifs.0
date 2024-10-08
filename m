Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B4161
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728346059; cv=none; b=dS1OTwthiu8MdUpZVWoljoDeNSd8evnPxqKecrJF/5Rc/56cT9YLf6rAtwUAZHU2K2JZzHmNifi25kId2WBnrlUCdCeEGB0Ms8Q9x98PJoxgWRTGymduFgyiBeMt1OggKMjyRgFzMKfpDZEFNrlI/AX3tAR5L7jv+R25wggQ10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728346059; c=relaxed/simple;
	bh=vyvFWcTjBBu4h6P9y4rI8DCLeut8LbtxqcDVAVT8oYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E80UDsf97iBCFnjExeuWVEip9cYWHVT1YGX/HuQ7wYlPJYOnPc0N2l8LoUVH8MrG2RHayiTif+zDI/sqP5YjkeFK6Igjp3agfri9N3IYw0AT+n1aujKLjz+I7nECmTbe6yfn0leqyKLwaV058spsDr/KasNYRdJ9JSIpf3e0e0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cmlm0JAP; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmlm0JAP"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5398e4ae9efso5468842e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 07 Oct 2024 17:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728346056; x=1728950856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyvFWcTjBBu4h6P9y4rI8DCLeut8LbtxqcDVAVT8oYk=;
        b=cmlm0JAPQRqoLn5AaakoBAAwImZt+0HCGvjkO+r7w5omFLd7qUBcZ9Cz5liGBDum52
         AnMXCeC8ejWWuF8ePCoX8y4a6wnFZqEia+/ukUir7c41xwHsk6/dcV7eBEZsRHz+4CCc
         UXIBuK5Szn0qDnOtTN/OZ4cFgwPsiF9QR8NL3FhSiWowjBWrxreLljJyS5A/+dY3K7N9
         fgqNfci5KCOKR0OwgpITSJ9/hmdGGn4KLeH8dlRZt6afGLvTlUB1gQEutYHv88NBXolF
         JksmFA2lt5OeeokG3dLycHZe+ndqd7O3hNeeqd67YFg+CJzhXOWeix4jYScK7ouPiubj
         ejHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728346056; x=1728950856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyvFWcTjBBu4h6P9y4rI8DCLeut8LbtxqcDVAVT8oYk=;
        b=AoTfVZOF9YLontSoMIARWB6BgzUE5YBXoLFWOSyjdmYM+juAkH4lX38hwkufA7e1Na
         xFiELZ4Apn8lQPhR1HtJGDOLV22sM+Mc9Fl+FrJfRiCjtFx4I9EuSucvr8XyMLVgbpsH
         Xist67ecOuIGSsP68+qBM6V0flWTlRA7R1EzACXarfIIjacd5Hh0hoUz3Hn2sis9hjC9
         /4JsET+rt+wamJPqYHgZAJIp04eM5BT5SqrFf40ffXYlq0frOI1qju3ggFs3gh3vu0wo
         IRwRgV2Pr7LVZAm1SHBYtS6I/AR6KfgcvHgAloAmnyiIlGYzDcx4CJSZ3u54EzJLmLLF
         BXIg==
X-Forwarded-Encrypted: i=1; AJvYcCUrHM66PlpH1+WyRyyyYofuIQxGbO0rL5U/GXuFj4JErdk8kmy3SlpAQdPCPc2Po8vefy6XMX+DMQDp@vger.kernel.org
X-Gm-Message-State: AOJu0YwYjO0/YXhGWUqKXj283D4QRHVQMz6z4/CLK4Q8aqkdao+DLs+n
	/HQzX5ryPZvszgQ+zUJfQ9JrRqQasYS0Ho7Ap1Vr1HU1qzVoIYsJgl24NjUOO8qz76z0uGm+m6k
	h1W9x3ZYIFFK9Zrya7B8wrldhGbA=
X-Google-Smtp-Source: AGHT+IGwZ+9WXqrbNkSb/v00YpxvkWkfuZG78taF/pIIZevSwviIlHJiDvtnSFkv5YimbB+4KTwiceaIyLoFI1i+L88=
X-Received: by 2002:a05:6512:3c97:b0:52e:91ff:4709 with SMTP id
 2adb3069b0e04-539ab87757amr7051488e87.21.1728346055632; Mon, 07 Oct 2024
 17:07:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006103127.4f3mix7lhbgqgutg@pali> <CAH2r5muZcbhy-MbhsLXgvoBCv3kZo_XhgtNPOkMyjEvLFDWbCg@mail.gmail.com>
 <20241007184853.cocdfouji4bngcry@pali>
In-Reply-To: <20241007184853.cocdfouji4bngcry@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 7 Oct 2024 19:07:24 -0500
Message-ID: <CAH2r5mvyn8w6LWMXZg-3umgRj+TQOR277w3Fh1GePURXS61S9w@mail.gmail.com>
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 1:48=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> On Sunday 06 October 2024 23:18:28 Steve French wrote:
> > On Sun, Oct 6, 2024 at 5:31=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org=
> wrote:
> > >
> > > Hello,
> > >
> > > Windows NT systems and SMB2 protocol support only DELETE operation wh=
ich
> > > unlinks file from the directory after the last client/process closes =
the
> > > opened handle.
> > >
> > > So when file is opened by more client/processes and somebody wants to
> > > unlink that file, it stay in the directory until the last client/proc=
ess
> > > stop using it.
> > >
> > > This DELETE operation can be issued either by CLOSE request on handle
> > > opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
> > > (FileDispositionInformation) and with set DeletePending flag.
> > >
> > >
> > > But starting with Windows 10, version 1709, there is support also for
> > > UNLINK operation, via class 64 (FileDispositionInformationEx) [1] whe=
re
> > > is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
> > > CLOSE and let file content usable for all other processes. Internally
> > > Windows NT kernel moves this file on NTFS from its directory into som=
e
> > > hidden are. Which is de-facto same as what is POSIX unlink. There is
> > > also class 65 (FileRenameInformationEx) which is allows to issue POSI=
X
> > > rename (unlink the target if it exists).
> > >
> > > What do you think about using & implementing this functionality for t=
he
> > > Linux unlink operation? As the class numbers are already reserved and
> > > documented, I think that it could make sense to use them also over SM=
B
> > > on POSIX systems.
> > >
> > >
> > > Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
> > > which can be useful for unlink. It allows to unlink also file which h=
as
> > > read-only attribute set. So no need to do that racy (unset-readonly,
> > > set-delete-pending, set-read-only) compound on files with more file
> > > hardlinks.
> >
> > This is a really good point - but what about mkdir (where we have a
> > current bug relating to rmdir of a file after "chmod 0444 dir"
>
> I'm not sure what is doing "chmod 0444 dir". It is setting SMB/NT
> read-only attribute?

"chmod 0444" (since that has the effect on Linux local fs of making a
file "read only) has the effect of setting the read only file
attribute for cases when ACLs are not supported (e.g. cifsacl or
modefromsid), or where POSIX/Linux extensions are not supported

--=20
Thanks,

Steve
