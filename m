Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5636D5243
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 05:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705988789; cv=none; b=emD74bmdJR5Yd2mK12Lo98KlLlDlfEwhZlr/M/DJ8ETJukK5aFELofvIsr+mz2kGLPzX+z5Oll6p7cwvSgPHPA0FvVtekHPn7IB3kDaDccKHX1wu44K7xwjC4xPSVmQyTQ6QjbolMoKS2YLnxejAXkseXFmJI0TZQLVUSRLGlCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705988789; c=relaxed/simple;
	bh=4ZjYJDo29jCbG9SanZVTdGU2FiwpdD6O/hQtKvgRmCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r3EOtEMmGnsWzWIgnggnnljxqOsUBupgJm5gl1uJFQVO/gPGPOl/10rqk0oIXiXKoRWklmzJLYGD1hUSrAtSQnsFemY8f5y4dl9h0ZVD/t9JBjgF1plDkkfz92nza4IjSM6695E0gRkGjBj+oOE1D8ZooymO3jvJtO5MiEqA3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKJU/yxt; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKJU/yxt"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cf050ea05fso8467811fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 21:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705988786; x=1706593586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vvN7IvjTotjfLUJkTmhKH4I/RdPnSMwZKHtWoCFbQA=;
        b=lKJU/yxtlz5dUClhlWE/TV/tXV8dAHVdEDsm0ZWxolbBBIpvJ1lFkegF2K9XCs/C2l
         R7zMVVKXABqULjNkiaayVQmfKt+RunWf19gBivyIFm4oEp6RC3ASIlH0XHl2J1mRvQcP
         UAl2wQv8toAEkygCZ9qxjm2wXvAAu4Fdo+SyCZdH/mHbnwlq09N68RfWJHkVBka4vApB
         05lcJZm51+N0A0y34N4/6M6pNXjdgQ0eHj41S2cRgoWgCjZGRhBEOtpBOXbLT6u3ER6a
         FYSzzP4AOqVLMvfTLfzyTwHGzkP+r3Vk2I5CBw4WkLcKBJ1rv3lO6/HfOnoaVRLfVVj6
         tZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705988786; x=1706593586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vvN7IvjTotjfLUJkTmhKH4I/RdPnSMwZKHtWoCFbQA=;
        b=tawCdogMWBP7Nmo8OeRGEjlKP3qXZ6PUP0hDj21zitf5Sh5twrAFsNagP6PyQma6yd
         3S8gnnWGpAGcU0n6OVED+ddb2VfCzuo27o4r82ASmu9abEg1Dd82aBnKbnFmyQR8g37R
         g39gL17eW7rDWQCimUOpJXquusypKieASodXT+o1Ap7U9rXthsLFbQsgR7COzLibi/7o
         hCyV5hYjWUa+xJNKgWaq4+ojiBL7NGj2X3wWomOPQELSi6p+gOAV9dvCeCLZJv6BWu41
         5McfGXlBSZ+q0tXODPPZL/lDgGu1wL4P1817VhaMJF9DQnkRxUCjPFSCTpkddDTyF9UH
         JzeA==
X-Gm-Message-State: AOJu0YwIoHgAyHElYp73wk8UxY9jxOI+bXy+lHthvArAy6DkedOXEfhy
	zJG/rOxErs3tAPQTYFUT5INXo6ntY1QR17ztHqNOZ679O8th4BTlTAptoiuhljeaJDaylhGZt4B
	yYIO5BlW6XApJIGE07UmQxipJ6Ag=
X-Google-Smtp-Source: AGHT+IGyUa8pQ/uYTV1GLZFzWM/QqHjjjmW2rlIW08fM5Yw4opQvwmMY67yOKtM9zAvSRpsQoEMHrPL9Vd+jUGbYPfM=
X-Received: by 2002:a05:651c:4cf:b0:2cd:9959:53a5 with SMTP id
 e15-20020a05651c04cf00b002cd995953a5mr2332779lji.10.1705988786048; Mon, 22
 Jan 2024 21:46:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123050757.5373-1-sprasad@microsoft.com>
In-Reply-To: <20240123050757.5373-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 22 Jan 2024 23:46:14 -0600
Message-ID: <CAH2r5mt5VD2bO09ebGjwPxu_u1SiFeg1CSZaGYk6EM5UX9BhEA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix stray unlock in cifs_chan_skip_or_disable
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and
testing (and temporarily backed out the larger cifs netfs integration
patches series)

On Mon, Jan 22, 2024 at 11:08=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> A recent change moved the code that decides to skip
> a channel or disable multichannel entirely, into a
> helper function.
>
> During this, a mutex_unlock of the session_mutex
> should have been removed. Doing that here.
>
> Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichan=
nel after disabling")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2pdu.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 4f2cc8373b67..86f6f35b7f32 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -195,7 +195,6 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>                 pserver =3D server->primary_server;
>                 cifs_signal_cifsd_for_reconnect(pserver, false);
>  skip_terminate:
> -               mutex_unlock(&ses->session_mutex);
>                 return -EHOSTDOWN;
>         }
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
