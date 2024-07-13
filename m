Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307352E3E4
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jul 2024 05:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720849741; cv=none; b=ghPLpWooEovgU8iqXSCtPLyPRyWBbLuM6ydzFO7T74Zjd/FWFCn8DWv5PncW/o6Mr+90Gs1k/9gx6GvFlocc0VG8wrKN1XzVDxB3iEhsAgX1pnb0DW8gCWNHR2uoybvJl9hipIcwtlZFLifM+tMs/WzfBCDjNPA9lI305LNfO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720849741; c=relaxed/simple;
	bh=ZzbVMQSmkdo2OELypXOoxhJed0/vFORPlXCSJ2zsFlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lBvSQSSCHYdV0OOi9miHOdytHZqRxjRKrB0ZL0XWDwznjWSKE20Vi7Yens6L6uZqqSZiuYNGuxYlomePFg1kXBnyw3e4B9wwiBucg8TTKHDklgjJyV9ZO6impMt2/ewYDmMyF//hMK5fQ45Ow5GYCSf7l99JsMhW7Kt1o9dp2xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRrtANEJ; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRrtANEJ"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52ea5dc3c79so3795314e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jul 2024 22:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720849738; x=1721454538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAFb9ygn4t+yhC5XAo+LnDHiYZOFZtBcIf6QNmQl3X8=;
        b=JRrtANEJ2VjiON4GIcfRjibVDw0q5xbk6LPEMIzyiWajnRC48BRWjgVVl8h5Z3dKhr
         Uq5IDSanzkh80oeAjtlUNl234dgx4ObQ4NUTRIcxoeoksqZALjgSMxxzm+HgKvTVzz49
         w+xiDoEDfv2F9fRV6cStLvOSUKgHeWoD7ZuvScDmq1nTcKYZaGp6HtNOQQWiv8L7M0U0
         eBW/9c9zmlFI+kY2zRsv7gp4pIYQUdaowj26bfi04ltWkiEBqk1ypVFHgLSVYR1kwpki
         mp+6PV3TQoYP6vQ2aTmVbu2BdyvY6QuzVaYO3IOlrB3Th0SasuE1P1Q0WQQwNuYdU/vg
         g5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720849738; x=1721454538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VAFb9ygn4t+yhC5XAo+LnDHiYZOFZtBcIf6QNmQl3X8=;
        b=KZ2Hb2hanS+Nm7o1dKASgTW+dC3MXrU7CV8WvxZCX6JFE5GJG/9vzc4acX/tSebA/B
         l3JlOh3wqVQOvSUcJZTaCeB3GUXFWi3usGRA4cJ7FvK/Q//erubjo9h4yb+CJdcaHpAt
         Z0bmU+tFNRJos0wF3svyk0npepL6wRSZdKzqTJd6rUhLf+wRgYx+Ei9MifBU8bjkLHZq
         4sYvQdJRJEPt1k7CgkE/UKhBstoA+9NfHzl18sNo+A0Z5R2HSWBCK3nwRoAd2Gp1jr3A
         xj1jMvaitWAGdM2aCKapmMwAuKFE7Day77HufTvFl3SKoIiIIDuSKWght8eLubvLBt69
         my3w==
X-Gm-Message-State: AOJu0YyCuQFv6s2/DaH8S7xq2cz9difY9PdgO3gN3vLi5Wz3wHBBTZ3f
	jjn6Cy+8q8iJBXcn1z85KeBTQz+qjyo0X9DyYMYakBameNprldE0z9u//dOy3t7M7AGFZrFeNAX
	yJjH5hOb6VgxvXsZSm2mzx4qBxV4dZQ==
X-Google-Smtp-Source: AGHT+IGBPFr/6JyyTqHENo/wKQE8Wd2NIWuGjAtCa1AB6CUK42Kq+bHuYgl61IcxzABXofjzfSPIcas3Ohmsn2MD/z0=
X-Received: by 2002:a05:6512:3088:b0:52e:987f:cfc6 with SMTP id
 2adb3069b0e04-52eb99d33f6mr9567162e87.51.1720849738012; Fri, 12 Jul 2024
 22:48:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv2V3vdupgmR75WsNGrfdbaPo0Mw+6x82KK9vgUYu5AkQ@mail.gmail.com>
 <CAH2r5msriif9aOTVa57n2PnEjUHYgpimuz7vTG8deS=KOZt3hw@mail.gmail.com>
In-Reply-To: <CAH2r5msriif9aOTVa57n2PnEjUHYgpimuz7vTG8deS=KOZt3hw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 13 Jul 2024 11:18:47 +0530
Message-ID: <CANT5p=orFiPMujTrXE2_8kvxgV9fYU+QkXOSzg4eynDJY_Kr6g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix setting SecurityFlags to true
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 9:12=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> V2 of patch
>
>     If you try to set /proc/fs/cifs/SecurityFlags to 1 it
>     will set them to CIFSSEC_MUST_NTLMV2 which no longer is
>     relevant (the less secure ones like lanman have been removed
>     from cifs.ko) and is also missing some flags (like for
>     signing and encryption) and can even cause mount to fail,
>     so change this to set it to Kerberos in this case.
>
>     Also change the description of the SecurityFlags to remove mention
>     of flags which are no longer supported.
>
> On Tue, Jul 9, 2024 at 6:45=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > If you try to set /proc/fs/cifs/SecurityFlags to 1 it
> > will set them to CIFSSEC_MUST_NTLMV2 which is obsolete and no
> > longer checked, and will cause mount to fail, so change this
> > to set it to a more understandable default (ie include Kerberos
> > as well).
> >
> > Also change the description of the SecurityFlags to remove mention
> > of various flags which are no longer supported (due to removal
> > of weak security such as lanman and ntlmv1).
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
