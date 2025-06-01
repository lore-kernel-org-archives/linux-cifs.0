Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D82C859
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 19:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748805517; cv=none; b=R4tdlQmjVirkFHG9EgJmwsH6Eehmh8myE1QS5k2C4qGnEb1BaIL2g/MFAXOAA8DWENtv+tVO8R9IYoIGZGamy30t0kbJCXxiZPNWGanV4nO5357TttxknBmXeFHlrMlj/W6BlYsoXtKQOJbAajkJ5cr4BnsxC0t88qUUCAL0V+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748805517; c=relaxed/simple;
	bh=n2HpojCTFOKo1pbj/mbXQlNfvJbNXOb6WKZdlz4WI6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sf7HqIk/YCgO0ofE6ynNvS/KrBRtVEhKjqx3DG3T7V2aTYHhXvcGI+2UsWh8WTV4chpg1+Lj+7KkZw5glF5/jO0SrLIMPwsj9CHdXRAy33WQdd8wjKMsTHIeKOTXMyDkwtSvPpMSmfO/fUagoSE0f+f0VU212ouwNWONoFpEB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EtjCGvHk; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EtjCGvHk"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32a6b34acd9so28995571fa.1
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 12:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748805514; x=1749410314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMEgOS3+jin/RsJA5GQA8Qu5iXJ5j75neDGebwblTfM=;
        b=EtjCGvHk4o3uuNEJiByGHPUWWS4NsynzXWZHjIuzIvNbMBFYNbuFvaXYuyTQQgMQQd
         MLs3fgBiZXGol510cLD/8ew51Hn4aLL9LCv6CIYGXbpDYtF0JoJl8Ej109GLxOnl6d//
         9Tekm+r4pEn+kjHFOQlrskemWSG5JMcpCd0wLxtX9wXV9hLWZluLi0bx+/EX8ifFSZc0
         w5F4F9BL64LP3dOkvoluKzSoPVg2ecgQ3DR6ir4f36Is8yJLpGUw3xvuawQAddgL94LW
         2qnP6SmVlXWYZb64W0d2oyk07LCG++lDG6255J/XJ4itDOcL/79qG4Qv2MnqNtTeS6Wo
         XyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748805514; x=1749410314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMEgOS3+jin/RsJA5GQA8Qu5iXJ5j75neDGebwblTfM=;
        b=F7nRLoC6rOrVGn3p5ZoKESGj65OlGiItWRSnP9CoKcjpxkldLFIFzRija0vw3ri8zm
         409LcmdVVo3BoSBRl+kVi5u6g1XVsZaG2+BEH7Yyhi8TBoPlBn8HJ1QHKCF50NxajF3D
         Q9NSiDcq2yPRDVw2WACBqLYjgQ58o7ZYp6WS/17VmDH7A6xPsVE0PS/NuJmShYnIVOIZ
         PEOv4tt9ZPPAwlwgo2y7Re6CL6zsM1WD6dO7xg/khAWdJGwlBQv79xXR77CLs/y+80SB
         xua40jDDl8DlXSN9NyAMFNgl8uYzshRPL26wWEQlFVLVA7aO8UKG4VYnNUaTWwB8knZT
         Lybg==
X-Forwarded-Encrypted: i=1; AJvYcCXOGkJUtLVbESSHGRWv+wpf7rl4HFegzKFGcMTuBg511IuP7Sf8r5W1Up6gbc+HYB8+yDiYDh2fHK2I@vger.kernel.org
X-Gm-Message-State: AOJu0YxnrPvuG+J8XESmw5a6djelzIKZ/ahlnAxmKE/akNcGZNo5pJUY
	/5ULMdygY7+0vdqG3z+kvnUXRX6A7whX/4XFH3iJ/Lp55me0L+hDfn1bXuzeGsDrreSVbQ/et+0
	HVh8foqE8D37mxiQRUrRbQCdPM5MmDnU=
X-Gm-Gg: ASbGnctRJmK1y1A9TszkEUYPfbRoIqlt8hwq2xsZnGAOxTDqCthhyOpmAJslmEGqbm9
	0FbVlwmerGiZ+Hy5NDev2+jsD4mrtkpj2Dl5/nYfsKlsZ4RXklvGssXKWrGJGkKPznupj4Vujsr
	s460HH8auNIkw1cA88jb+2YNotN5QizdKLDsE/8NQ+v8bYKgZFTRtwdEdz3bENfVFPubM=
X-Google-Smtp-Source: AGHT+IEZfUQgY8zWqpZet+A6X9XyLervHmVY3noaE0owcla0vpEtgX9tjaglq3F45WFPBQ8Pp0Rc/YZOrEaikWWH72E=
X-Received: by 2002:a05:651c:904:b0:32a:864a:46eb with SMTP id
 38308e7fff4ca-32a9e7897a7mr13386311fa.0.1748805513283; Sun, 01 Jun 2025
 12:18:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com> <2025060107-anatomist-squander-d073@gregkh>
 <CACRpkdZ0w85ecgtjbiypG8K37eBF9hk-7oqSq8E9K6_+SE+nUQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ0w85ecgtjbiypG8K37eBF9hk-7oqSq8E9K6_+SE+nUQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Jun 2025 14:18:22 -0500
X-Gm-Features: AX0GCFsCMPCVmPqQW2joNOOvvHnz4RjVBOmFye62l2tUlgT4oD9jcNtoW4GfE_s
Message-ID: <CAH2r5mtqfQhQuGFW+XK37U9Q-qCSuKrGTtmNTue5uWNf-coXgA@mail.gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paulo Alcantara <pc@manguebit.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 1, 2025 at 1:54=E2=80=AFPM Linus Walleij <linus.walleij@linaro.=
org> wrote:
>
> On Sun, Jun 1, 2025 at 9:41=E2=80=AFAM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
> > >  So relying on that version becomes
> > > pointless, IMO.
> >
> > Yes, it is pointless, which is why it really should just be removed.
> > I'll do a sweep of the tree after -rc1 is out and start sending out
> > patches...
>
> In a way I'm happy with that result :D
>
> But what do you think about the original problem of making
> the dir /sys/modules/foo appear for a compiled-in module?
>
> So as to detect "functionality of module foo is present".

Yes, and also (at least in my example), I find it sometimes helpful to
look at module version number since it can give a rough idea of what
"features" are in that version of the cifs.ko module (especially if
tricky to access the git tree for that kernel build).  Seems harmless
to keep it

--=20
Thanks,

Steve
