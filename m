Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B9A1CD2C
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 02:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762051942; cv=none; b=Z6T4VTkQrfsF1fvzUAuUJ1Xg2BA4HTeunkB8A/6V5OlBX/m9Z5YnAgTtZimy8Hm8+5p5cTdjl56X+bIA1JdQp83sjtWuPoVlFdWm9Wmtg7RfqOg8Ii0qoc8vxZlD3NoEooDccAWqOeTmw7v0mBENmLWXuLnR/uZEScEAZ7O8neM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762051942; c=relaxed/simple;
	bh=F+HyW/567YNuckawSHyL+0ewc+fMloQSgSE0rdmXGp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=kdsqh8Jc44S/6hA3ZZWDgM1Vpk+6h4gM6keEqHLudQsf+1ZW8HgRCIHmISK5w8TDt3O0dvIMp1kz88Eokzy5VIZ9FVZqhTqoGAsgLKob5+hA4xYXEOCmncO/C2vqfB87zCv7fgyF+zskc3/X6K0yCbydLhz67e09JyGp3XSCxiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFIY21/2; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFIY21/2"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88033f09ffeso21461196d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 01 Nov 2025 19:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762051939; x=1762656739; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D89yYMaLJ9+jleYKnzuQ+wNBa7C2AyEiPGASNv+3lvg=;
        b=WFIY21/21oefD1rcneBx7MCmpIb/qgxBzXWUX4KPQDfprJE7qGmBIeyUzwL3z9z9/+
         VIWw25Hs0LsvwGgwL7iqYZoJaM+HCSQoGOQvyfxUpZfQbLtm119s5RdrqxVdE+HWNCQr
         FZ+iRBIBIRbcUns0ePV1kbcS73a5K5sEb/ChHFq6ihnWoSMIZL1u0h2698C4yo+38BxY
         Bb9G/h9XwvGWSyw1MS1qiySeO30JgrF/3xgaDX9LPoksK2ybwp/ysj6MaDauzow1u5EC
         AA8ijEpsXpYYgjZBRKhnKkBXWk2poQEF99tnLbVWkgZ4zWeTh4LXO/V8rKcwkmjVWwD3
         W03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762051939; x=1762656739;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D89yYMaLJ9+jleYKnzuQ+wNBa7C2AyEiPGASNv+3lvg=;
        b=WW7PdauOuPnzvauIJNZVArAOxk6rW3yYMDHAtbyjriaWru0TLeYvnWFGEDv5CXCV4y
         e5FfcO5xnM3UEaMuKPqdJ6FTz3YpZK/GeNNEDZllksBXHLARz5f9b2FGtjgDK4ddrRay
         hz6rQvBI0rnHNMKOgToyfnF4a1nUohDfK0WSQOCnAX/0JZ8J2IaZW+NMzEq42isiQb8H
         9/HvmxW11RgWadYBcHDg8GeYuGxlLW7syLca8ZOKU+UbiYqfwxdUnIwmkQ8Hm+dkhR0h
         ekcigWnfyykaVWI9EMeM9SJdz1Mr8Ffy9/jePH/HjDo6JVsTeAC55ej+0N5QDE0MUk+y
         iv4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpa1ofPCJhc8lfiEWRTXYFAaGOMJgfrEilUF40fmR2PL57SUg17xpBs0SJX1quTvjBy/RYMAuRW92p@vger.kernel.org
X-Gm-Message-State: AOJu0YyDOt9g9pbBXfsmoYp/QIyo6H4ssF9zwwDmgqRlvACjY9tDgPqQ
	d9Eq46z5rzibyvYNV5CoiomRoJa39FesxJ8x5afwM3nQUrUMIPN4E3WVrO5/84BfXqC0mcr5ATs
	uHW1WaH2yWRoZbAPd6kRn6qQuaDj1T/FmHYOX
X-Gm-Gg: ASbGncs/rUhXG/qvwqBr8ibwdcn4Zb7HZzfKSo+afvTNtXcJ8+HUXOvEXbSpYxEUHze
	+/mBLnmIeD+o+q3I3PS4//naZxPIsJtEIXA3HPQsobY28VPzAk65xAQAkL6HGha6HWjVEsCTwXx
	Uz7n4VT8gJ5E8gfalWKA8Uxr0WwC9U2v47d5uj5+exi6KWc3ClCDkjc6v/lvqeqw7TdqsodjvCu
	Fj0or1zNHVnONcWCVExo3GhVXq64HbPbkTmTfav+c+GwFZbE0y50IycatZZCzUfjgGS2P52eW6g
	9mQirMI4H97Wk8RnVB8zoV/LSjYiPkr9jKivnkiJnGkMdDPZghMYSin0NzhPk0QZ/gDgD++u2qW
	ijddv1AzIB2s6J1haDC1dfXOUC/w9ubX8BL8uqn3EgUD0YKdg6BsB8jegzWaj62YdB5HcuBvxNa
	kYU7Ve2rRGGA==
X-Google-Smtp-Source: AGHT+IE2y4CV26UIfn0PBJBVwAugINt0YwQ8dyKgsJZ7ZeITobYnjy45l5bO/CqNnBOO5HdtIuTsRqCmaDJ0JfTBYB4=
X-Received: by 2002:a05:6214:d0b:b0:87c:1953:dd98 with SMTP id
 6a1803df08f44-8802f445ff0mr97512986d6.40.1762051939041; Sat, 01 Nov 2025
 19:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251017084610.3085644-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-DxRTEu65-YKwXw8jA478jmgQAtOUNR66Tjb+czxp=xw@mail.gmail.com>
 <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev> <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 1 Nov 2025 21:52:07 -0500
X-Gm-Features: AWmQ_bnhbi-V8hTcobmCNelb7Odr3XwHp7iWPVywwpBwYmt4x16EDQvhHIbn72E
Message-ID: <CAH2r5mttHJfMTEc7xS56va-WDohXQ3DfuYKq0OFWgFiGEQHoGQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] smb/server: fix return value of smb2_notify()
To: Namjae Jeon <linkinjeon@kernel.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I am also very interested in the work to improve the VFS to allow
filesystems, especially cifs.ko (client) to support change notify
(without having to use the ioctl or smb client specific tool, smbinfo
etc).  It will be very useful

On Fri, Oct 31, 2025 at 7:10=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sat, Nov 1, 2025 at 9:05=E2=80=AFAM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
> >
> > Hi Namjae,
> Hi ChenXiaoSong,
> >
> > I=E2=80=99m referring to the userspace samba code and trying to impleme=
nt this
> > feature.
> Sounds great!
> There are requests from users to implement it :
> https://github.com/namjaejeon/ksmbd/issues/495#issuecomment-3473472265
> Thanks!
> >
> > Thanks,
> > ChenXiaoSong.
> >
> > On 11/1/25 7:56 AM, Namjae Jeon wrote:
> > > On Fri, Oct 17, 2025 at 5:47=E2=80=AFPM <chenxiaosong.chenxiaosong@li=
nux.dev> wrote:
> > >>
> > >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > >>
> > >> smb2_notify() should return error code when an error occurs,
> > >> __process_request() will print the error messages.
> > >>
> > >> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
> > >> in the future.
> > > Do you have any plans to implement SMB2 CHANGE_NOTIFY?
> > > Thanks.
> >



--=20
Thanks,

Steve
