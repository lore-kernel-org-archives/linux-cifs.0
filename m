Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA81367;
	Wed, 28 May 2025 07:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748417182; cv=none; b=a8k3NqfR1V1h67Ip4t9fS6UwVSHHuPVawIdKRvCS/zZYgk4NnRmhbAE+BCrorze+V62Zlhl8e8I/4klnHYwu4BYg5kFTemu6P5+pUmriKi1AeB8AnCN8jcSF+ZHr/0ZiJe2hAZyKufgl1IWIGYriKwR5RMYlWVEi9rMqMbFchLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748417182; c=relaxed/simple;
	bh=lwmrJEY5WsLS1UvqABzKOknlzeEFM2wNdRqM8lp38+U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJkFGh4eeB5/S7tQmVw6Yt6BYer2NonoQ81L+mwEn7SWymlU4foSRVnMKb0O1/twdByavpAgInQj5MNBxOO8scYAbUyLRe3AVcHinwCLeP6EP8gUcvqY+48CHXzpnEbv46ICwCPpmOEuqrNMPm7nwTypTfzHs3ZypReOXzCDnPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nsEqO/Rn; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nsEqO/Rn"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-442eb5d143eso44420875e9.0;
        Wed, 28 May 2025 00:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748417178; x=1749021978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkfWKZJIfL0XCEmcdjSVWnaS0MJDkdIq6iKveQpAWPw=;
        b=nsEqO/RnNqV6fU5IqV9WODwwJyPiAmaG7xBTyK2/F8YK5ZF/QMJjYrkZIzkH6WiUsa
         eX2Hj/ctx0xGt6nzMItGnbVQLPMDT9/CEKcnLDcaQkz0YNQZelSFl08JXTAmRsGJ1BkH
         YWmSZRLIUJtRJqtzdKMVS6cQXvuCAOe7i2Jcgj02RD2Y3lv211jUXZs9FOV4GNKjqP4U
         yOsM0dfP4LEcl7emxWGC5RyjhxXmLpdOfjAbIC2nN3cST9iuaukwp0FqApKKQ8otZfoq
         +fRJZs7hzqS1LW+qt+NUUUNMn/XK+V48e9eBtGAP8LLtHmqhvrU4jsJeQqXfvx1GD40m
         +cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748417178; x=1749021978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkfWKZJIfL0XCEmcdjSVWnaS0MJDkdIq6iKveQpAWPw=;
        b=tmT0M7mfwM2O0h7qKuSwoQUInnHwkyQBc17nmNSOyl5mye20yjGWzCEx6Zbgn4CgVg
         itjI4uUCsN03qekP3oZQMlBnx4Al90f2JfrRehU9kqMaaVT+A5J+t1MrEgNYTPdWvU/I
         5BVVfUamIKMDfdd8NWRquudF66O4LmqKe9CHRoNr6brFQfBnlJSYlv2X9fuhcnHdk6zf
         o2svq5h4oR7Xw4F9SimRLlmExGh2LN0aGpvEhWOi+ZjNpFhoJ1kWtHiPotEaALHJYvBa
         fdZ71Zy8cbckrz7obDwXRD9XPKhLMwPhGbx5lCOuvoBASyy6e/pECz2dPhj+b1zHgzM7
         xMWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUctbisSUUp/YhCotbX37Ks5X0sMWijRXlxrWrAjwCzF1MnQngDcXJ70G9hf77jJiVZzuFs9TPyd42m4wGO@vger.kernel.org, AJvYcCWa74+agDz6lNWMiGg+uSYG1HqMmzFMPt0RAeMEO6LBjJTJSgdi6tAtiJ7F8sKqFht6rI4G8SQikAk2@vger.kernel.org
X-Gm-Message-State: AOJu0YyPBbIAC2VrOaNlV7BZEWEmxoQVU1YIViQpSLHQ285bjHDHa+f6
	KUagcRhEdtf9GsbFvFonh3YL65Wve8np4e9zLhk+PKMpZW3XOgfc7Ea4
X-Gm-Gg: ASbGncsBFi+Na4gkhlXaxKQB+D5q7WZAEUkaw/hyLXAb+8DWov+y5BerjnaJhb+qxpM
	tSt2AhKi+nHCjMtzfVjYiaYtzYhWakegBinJwpndLGug6Bx+0VYfEdwnM/taMmcqhA+6X/bnyj5
	uTEMh0oTOB0GF2uuGtnj7NOYNJlAYoSuNbqKb67o/lG+CRrdEYfAJvhEEHK9eyB0dCLBqIJHr4A
	zgZmejO524rfGUsl8VClpODt7YEFYvx3C4KNTEYU0TIkZGzW9o18mQSyYOQ8zVCbb2n5CToK1Fi
	nEhLII80pqgD61lPyPj6kEZjHN5KA2/elOylh+BMhc0FjDdEbGAd+W8w7DrGPKn0kinVfR+n8mI
	Q+A61zRVr8HzQsw==
X-Google-Smtp-Source: AGHT+IGrRxtjywdSrwG18d4jZWZ2n2ZZGLg+MufrljT6xq4RFcU3buVDPseRz2yhWFDrqogGyddaRg==
X-Received: by 2002:a05:600c:698e:b0:441:b698:3431 with SMTP id 5b1f17b1804b1-44c932f9329mr120201165e9.28.1748417177340;
        Wed, 28 May 2025 00:26:17 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4500e1d85b5sm11918585e9.32.2025.05.28.00.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 00:26:17 -0700 (PDT)
Date: Wed, 28 May 2025 08:26:14 +0100
From: David Laight <david.laight.linux@gmail.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Steve French <smfrench@gmail.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, ChenXiaoSong
 <chenxiaosong@kylinos.cn>, Wang Zhaolong <wangzhaolong1@huawei.com>, Enzo
 Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH] smb/client: use sock_create_kern() in
 generic_ip_connect()
Message-ID: <20250528082614.5ee971d1@pumpkin>
In-Reply-To: <01BDDAE323133ED0+e7d23f35-c6d8-48a3-8fe6-c23e3a9c64dc@chenxiaosong.com>
References: <20250528031531.171356-1-chenxiaosong@chenxiaosong.com>
	<CAH2r5mtAYV925FbL-5GPGvk3wMG5u0027_icNtUw6uZ9yOBqyw@mail.gmail.com>
	<01BDDAE323133ED0+e7d23f35-c6d8-48a3-8fe6-c23e3a9c64dc@chenxiaosong.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2025 12:09:01 +0800
ChenXiaoSong <chenxiaosong@chenxiaosong.com> wrote:
> =E5=9C=A8 2025/5/28 11:39, Steve French =E5=86=99=E9=81=93:
> > Weren't there issues brought up earlier with using sock_create_kern
> > due to network namespaces and refcounts?

> This patch is simply a cleanup that wraps the original code for=20
> explicitness, the last argument of __sock_create(..., 1) specifies that=20
> the socket is created in kernel space.

Except that 'kernel space' doesn't really mean anything.
IIRC it does two separate things:
1) Skips some 'permission' checks on the current process.
2) Doesn't 'hold' the network namespace.

The extra permission checks might be relevant even if the socket is
only indirectly accessible from a process.

But code like smb doesn't want the extra checks but does need the
namespace held (or it has to go through 'hoops' to request a callback
when the namespace is removed and delete the connection from the
callback).

Maybe there should be a 'kernel_socket()' (cf kernel_sendmsg()) that
code like smb should use.

	David


>=20
> >=20
> > On Tue, May 27, 2025 at 10:18=E2=80=AFPM <chenxiaosong@chenxiaosong.com=
> wrote: =20
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> Change __sock_create() to sock_create_kern() for explicitness.
> >>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> ---
> >>   fs/smb/client/connect.c | 3 +--
> >>   1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> >> index 6bf04d9a5491..3275f2ff84cb 100644
> >> --- a/fs/smb/client/connect.c
> >> +++ b/fs/smb/client/connect.c
> >> @@ -3350,8 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *serve=
r)
> >>                  struct net *net =3D cifs_net_ns(server);
> >>                  struct sock *sk;
> >>
> >> -               rc =3D __sock_create(net, sfamily, SOCK_STREAM,
> >> -                                  IPPROTO_TCP, &server->ssocket, 1);
> >> +               rc =3D sock_create_kern(net, sfamily, SOCK_STREAM, IPP=
ROTO_TCP, &server->ssocket);
> >>                  if (rc < 0) {
> >>                          cifs_server_dbg(VFS, "Error %d creating socke=
t\n", rc);
> >>                          return rc;
> >> --
> >> 2.34.1
> >>
> >> =20
> >=20
> >  =20
>=20
>=20

