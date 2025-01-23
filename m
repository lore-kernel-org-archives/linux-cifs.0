Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C379413B7A3;
	Thu, 23 Jan 2025 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737616152; cv=none; b=nP4t7r1BpoZXIYzWBBA8YwXBzaq7aI3keWmQLZ9tLSYhNkIkLlPV18eHEe+MiO6HAvPfXRerD0FgDBXDH/kdn53wpJPZvTKe+Xs+864XCKaS60PcD56t7H4ydnwaU3iqUCW/WQ7+cqXc/0zyygPTu7FtrwtxRaqJx3AXJOgUtYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737616152; c=relaxed/simple;
	bh=hbjrAXdHmfk7cv6vDQsnpOKhRGQn5VMaCqFvInWXzQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AX76sf2LPdSYW2oldBt3eF22ZzYTFEDF6sji84YclQ1YfEP4BPrbSett7Xi3QN2XfztTgmlvZbV5kfMUGxJNfESdTCgLCbkRYy2XrjSlNFfPbtatgOAHjkimE8usO61a1zKOzUuJU4KK6yYPT1JSjKGaP9wMeaM55Tkxtww7oL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QayW0I3J; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QayW0I3J"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5401bd6cdb7so634762e87.2;
        Wed, 22 Jan 2025 23:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737616149; x=1738220949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4rkMsWW0RDeeD8nJ39BOxr84N8T1/wgbed1XpzG2QI=;
        b=QayW0I3JGsxYQCtQAmFMCuY3gME6g5F6bT+L7TU/P4U2EIpjw4ELD3o8tRtYnlhp3l
         EQEZTkZS7L5U22c/i2bkSnrNfX3YXzFRTQ0FA18PYJ8E3WbZJTboWWoxkX085dEeaf2h
         XwcOJtMlD0L2KQ+oK/uRar0xhEG8jq8OvNOnHsYVng3/KstdSkXJMY3/Afi6PstxVMql
         zqfSe8xhq8xwgiNibnFtKEyk0ThNzEzQUcGuS56pKv3SZKo8mRSFXRGz7/rpZ8POKuTt
         fsRSv7ag2vs9NokLJcy8vMTbFFbKV7L+f9lMjY0Bd4KmHjE1AO8ur9e7QJaacnjjjcuT
         I4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737616149; x=1738220949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4rkMsWW0RDeeD8nJ39BOxr84N8T1/wgbed1XpzG2QI=;
        b=PHxhw4fKBHi1KOkSzMAUUiik0myFkG3pJY1y6qmjAVonYSOKByxAhN5wMMnrnvY6+v
         8aNnfRvvgCbdMtp+xVgjwn8P4kZ+wnyKyzWA+hjQhv9e7bzGML0r57v/tGQXg6E+QHsJ
         Vxq6erGAFuVcyww71iBdgZ9UE4QxeFaqHbFtZMpArse1dbGadELW7DvlDxJfHT1XOutQ
         LmPfi71wStuhPMeh+02VSyKG6115RlAxM5cuH1bTb/ctqowtgq2m7zrxIcbSpcfcqG6G
         wNSWk+r+mSkuydeEtv0umqndnXvqBBcBpa3CHwEuBGI2ufLB9n8UcxbcDPKDZiRvkQ+p
         ms9w==
X-Forwarded-Encrypted: i=1; AJvYcCWVQ6qHdE3+QKrT2XZ5iEcpkKMmYylAchicAsC3YqAbQnJ357A8EtIivA9CmxQoIqdWHhvd80hSWxKXQ14=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBoE86sTW9d7paNYkKIeLchxWtpATEMXdCDsBdEGb4C/2hA5gB
	4Mqprx3gBDKblI1px76QF07kN/g+JaZZY9zRSKs1WMzQ5AA78tuWw0/yT6hDIbVlXwZmiPqEGBD
	4HPQc2WRhakGLcE6B5O/xHPrVouM=
X-Gm-Gg: ASbGnctY2onGmia2qqgioW2KpBDBkkTtwyGfayGhEnohsukpjGZ05OnNp0Yczv5Xxnr
	K8JBQqQcJTE/I3TOKQZlkFQbsum3xR8TTuZYTCj/MzlE9tC1J2QlrAEVy4U9cFA==
X-Google-Smtp-Source: AGHT+IFOWJEi3/q4B0k65yhMG8okQtJPffEx+2AH+oieI6vAHTC8JsfUdKAV6m5h+qsy7kJKUFapN1GpTNIHc4igjAU=
X-Received: by 2002:ac2:4294:0:b0:540:1f7d:8bc4 with SMTP id
 2adb3069b0e04-5439c281105mr8228903e87.48.1737616148331; Wed, 22 Jan 2025
 23:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
 <CAH2r5mvnJ6SLtHM_PWOQZ9dTsDd1BaQbOK2UBi9-AxRzt4sJpg@mail.gmail.com>
In-Reply-To: <CAH2r5mvnJ6SLtHM_PWOQZ9dTsDd1BaQbOK2UBi9-AxRzt4sJpg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jan 2025 01:08:57 -0600
X-Gm-Features: AWEUYZnTQSNMiJRW9mE_rweQVteoeTfiX4TRocN5OuShg3kRiaMvx8DvBrovhJI
Message-ID: <CAH2r5muwsjAXMHJ53HVBYbZSCmFE_XGz0KV-QaDskMtc963+jw@mail.gmail.com>
Subject: Re: Bug in getting file attributes with SMB3.1.1 and posix
To: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also did verify that your patch does fix the problem - but also am
checking if better way to fix it

On Thu, Jan 23, 2025 at 12:53=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Very good catch - sorry for the delay.   I can now reproduce the
> problem.  Looking into it now.  Thanks for pointing this out
>
> On Wed, Jan 1, 2025 at 11:05=E2=80=AFAM Oleh Nykyforchyn <oleh.nyk@gmail.=
com> wrote:
> >
> > Hello,
> >
> > I encountered a funny bug when a share is mounted with vers=3D3.1.1, po=
six,... If a file size has bits 0x410 =3D ATTR_DIRECTORY | ATTR_REPARSE =3D=
 1040 set, then the file is regarded as a directory and its open fails. A s=
implest test example is any file 1040 bytes long.
> >
> > The cause of this bug is that Attributes field in smb2_file_all_info st=
ruct occupies the same place that EndOfFile field in smb311_posix_qinfo, an=
d sometimes the latter struct is incorrectly processed as if it was the fir=
st one. I attach an example patch that solves the problem for me, obviously=
 not ready for submission, but just to show which places in the code are su=
bject to problems. The patch is against linux-6.12.6 kernel, but, AFAICS, n=
othing has changed since then in relevant places. If I have guessed more or=
 less correctly what the intended functionality is, please feel free to use=
 my patch as a basis for corrections.
> >
> > Best regards
> >
> > Olen Nykyforchyn
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
