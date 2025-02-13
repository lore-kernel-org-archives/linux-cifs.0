Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D5C28A2D4
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472786; cv=none; b=CdrLSiDHo+X7PagWUE0IrJyB0PNUpyDI9+dfSg3n44SzD21bklBld3wLgSqiaPCSw7JxaMsVKZOT4U6xEFYx1W92b2T6IbHX0S2zUyP04TnqhFCvilIP9cwt+lKz7T+2U7cURS4Vs+M8y3UDVkrdMZzybk0180pulCKgYmjTx5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472786; c=relaxed/simple;
	bh=dm7jV58hpprAVKqWNDtKIR18Pobvc8acwfrU3mMqRCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUJCep+bXFiJIcuz0lgVE0KLDBd252J0T1jRE0syV0QlGM3i/gghg1YTkfrK5fSxq9mN9wPM2T7i1gvNIpvqtL66FcFgeoiSchE1eQyuIVPtBifEk5p+8lJvhH2uBYYAcOtKZPfqSgbENGzyO/jpAuiBcaav/d4bH79B75EyD60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O0WKUZIr; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0WKUZIr"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-543e47e93a3so1309721e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 10:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739472783; x=1740077583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nI0rNuJsJiIJomQqZMwBLOtU8hZvywS091vgzhfvM4w=;
        b=O0WKUZIrKRcpFCcfd8aga07TGXu4ZprrdI/9z/1iOhgUt1tY2d39GvzTxKXk5o6Lux
         UH1qv/nUOThczDVwnKyok1L7j7ARTTGbKTp0xFIng0EqG21TfXcv+Dgqe1mxzKbPvh8s
         xm8APfR4evaaROO71IF7ufIN8jp6amKT5KLcblpy0QHcAiOyC1cTQG4OGKP2xsEloyAz
         wOj92+pFFCAw/UcxHURvXFi+50E6y8W9TBk6ercLUL/RKJUyotxU55hqRQ3Yz3P1GlvF
         9BpycVQBtF21RdXQJMMor2797uwsqBSakXxWeZN4cDEBGZwKh9OOfEAWKIbkfFgeqZi3
         8IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739472783; x=1740077583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nI0rNuJsJiIJomQqZMwBLOtU8hZvywS091vgzhfvM4w=;
        b=tCtVwADWd54v1+T7X9NIBlNhnsN6lNWv7zFhY4a8KgrFj6Lzzu1MczsK1UqU3j5UG4
         XFIVuMnQ4aqz52Q9tLJ+3gmqGa5nCa3xv7i/+RWCvz22p2D0KnNpv7gPHf0GUGUzhL/b
         2kyad2qiJ8kSDILaKzHVGhNsfo61FlbqpE6MyJCvpKmG0jSl7wll4TmqIZMzP0vpnxhn
         ByzI3UaKCBQN5SBOto2C/1ZiVbXx0xfPYpN+HQGMxh1hgwKnGckdkRdHGdU/wGGJNn1S
         htCtah5V2xBgr9t1CQ+vz6WnAffLDm4tZZh7yffAt+K50roKHkZb8QEsvdC5rQkYraEf
         tCgg==
X-Forwarded-Encrypted: i=1; AJvYcCWB05wujFWbRzU8658x8JeG1pJfc3ocEQtA37wBOBDuZ9/uEM0PYc78Lxk4g28x4G3QjSmTSq79f08E@vger.kernel.org
X-Gm-Message-State: AOJu0YxFhgRHNrUqFtFazedVJ2FUu67PiFBeJcS3+yqd2IU9ppu1DgXv
	QJQVkGCCf8wtA42syOQwmgpSG3Y+xHXXa7lM7Au++9FRLyqoaGjlDXtlXdzmuWGschxddeu6D00
	p+gjtsAzzlnKltVYMNwHICcpo/IFMVg==
X-Gm-Gg: ASbGnct1D+mlYvQtcKkDaaW+4kRr1lfx04fDw2b3gOMDp8iPJsjXjbor4x1IRDT+ATX
	ZZhfEeD48qOYwdZeOkeDqGVpbLuKfN+xv+2IK1eTF4mlF8xp6GDQpVI0XawPoUUeDLg4vtVtaHQ
	==
X-Google-Smtp-Source: AGHT+IGwjokxqPcGEGmTlDu9Aic5qFN8haIo1T9+SZNyigowwgqcFjmO/N3i6S6TqWbdKqJMTFbIu44EIc7Ra1UL/co=
X-Received: by 2002:a05:6512:2209:b0:545:109b:a9d4 with SMTP id
 2adb3069b0e04-5451816666bmr3210579e87.43.1739472782490; Thu, 13 Feb 2025
 10:53:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali> <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali>
In-Reply-To: <20250213184155.sqdkac7spzm437ei@pali>
From: Steve French <smfrench@gmail.com>
Date: Thu, 13 Feb 2025 12:52:50 -0600
X-Gm-Features: AWEUYZm8LGGkzbWbG84GwWlQGJDXaO6MaLrsVfg16zc2L3ne48p0ztBbZmVMKgQ
Message-ID: <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This change to fs/smb/client/xattr.c is probably safe, and presumably
could be removed in future kernels in a year or two as the updated
cifs-utils which properly checks the error codes is rolled out
broadly.

On Thu, Feb 13, 2025 at 12:42=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> > Pali Roh=C3=A1r <pali@kernel.org> writes:
> >
> > > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> > >> Steve,
> > >>
> > >> The commit 438e2116d7bd ("cifs: Change translation of
> > >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) becaus=
e it
> > >> expects -EIO to be returned from getxattr(2) when the client can't r=
ead
> > >> system.cifs_ntsd_full attribute and then fall back to system.cifs_ac=
l
> > >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that=
's a
> > >> different problem, though.
> > >>
> > >> Reproduced against samba-4.22 server.
> > >
> > > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > > translate -EPERM to -EIO. This will ensure that getcifsacl will work =
as
> > > before as it would still see -EIO error.
> >
> > Sounds good.
>
> Now I quickly prepared a fix, it is straightforward but I have not
> tested it yet. Testing requires non-admin user which does not have
> SeSecurityPrivilege privilege configured. Could you check if it is
> fixing this problem?



--=20
Thanks,

Steve
