Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDA1474D7
	for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709050649; cv=none; b=bmxFeDrtYmgy6AVqBuS5AS99VtpSmaVYZTewws26jBBY8ApRVaqGI9diU+tqEFmoJ5a1w7B4Jgp+eUes5j2gYCrpagoHOWn0QtPd4+tspxi1+V8YZ2cJRiD+zBF88jU7StteJvOXLkAxo3AcA7nM1YbZ/z6r3JT2F6d2uraRVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709050649; c=relaxed/simple;
	bh=4H1PWqXX700ME+L5//johzqPLxXtApuDpsumjDcUDhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qMHJ/iVR2rRC/YtKeL/LZDY5z/rj1I6DKHPl4JVLKo6r62Coc2MfkK4NSpgWfcoojjqG6OXzGrfDnjlIYDsop4W+9SOkOd7+aFOhQimFEVWJIfQyz7gOzZuBCysyOhXDjSlhKvpD7uaIBL0UYeHAZ6ACC3RyJDPg/DOEDzkn98k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nj9bLAal; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nj9bLAal"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d26227d508so51729471fa.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 08:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709050646; x=1709655446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kx1Yb6p6Bvlils5cCbph7HQHDXBJAQ/yFTdBm5PeEs=;
        b=nj9bLAaluHdCeUzQo5TKGSWfpI+CzCySw8txs8jO3f8NtzqN2NjxgPlNGcJEix6BkA
         ZpY3Txl0ISn6BkY1GomwjII7bxSNzxXadjFBFkK/gnL5CxciWFheDL2XvUcJO0uBP9BZ
         43wUXjgBpvkgZmvVw5u5SLfZG12zDc5C43jmeMJIaQgBJ8PytC4fbrszox2xx5BFvtaB
         YtThoFglHQKPS+CzQ63xNEflRilX+5SHGrKU/qh/q43Hu9g0Pmv+ejM9ClBQ3uitQbVW
         P6O6gNfpHK7bCiPSpM/xGSIc0LFVjJhPLCCnIlRHWExa7mJPLOhNtGGCtTMx/rKv3CXQ
         jivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709050646; x=1709655446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kx1Yb6p6Bvlils5cCbph7HQHDXBJAQ/yFTdBm5PeEs=;
        b=surBlG5QPAIve5CS8KVlprBfZrtkneaUH3lp6Dh4oJjIXPT3oStWo36T8vkz2y6+o9
         uVU0Y8PGQgbadsimrYg6g5b6s1l5WPQDwsVUHEPwxSZ/R4sda+8QHoOT27HCHHLaelAL
         ZZAzi6qdKdZkezJzunSTq2T79GLo/nOMMVtXuaNiAktfAKgT33Rbork8N/O9zcyGCpec
         xPA+s15LP9VOXrKhJsm0eb2EMPe1pwou6vmQrTxhay3xWvmhNzz1QT923+GyCC02UrsM
         /MGL17lVtBHJ6/H+JagmPT9LiVXb9CPkn3N/DG/fGH8iwRg0otC+M4hfUmrjAoso8Vha
         3k7w==
X-Forwarded-Encrypted: i=1; AJvYcCV0oWpIU+maGS9frUdTwLB3FhWCcSd9KFkZcsmMzUlFQt6e7CzAsvNU1Lh2W93wtzm7v2Y5HsBka20puHoRUBGXor3pEG9YfaFO2A==
X-Gm-Message-State: AOJu0Yz0Krg3JlZ8ZFbtnKc613kxi2yjPpf0WQzrSQaSrxgKv08+cbMK
	XstGMTjLgGaQhTYQVR4pAxFhCYaThhe4Ak0q3EPs/I8Dy5MoISgzfvk2uICu4jaq61PQjRJE+eH
	y1qAX9LzVV7Bb9dTzTDg5txmp+cs=
X-Google-Smtp-Source: AGHT+IGOd3avtFT0GdUHau8/Uz2IkmBuXsfLgmMcQnTdh2uuxkoiTZGLyjAhaUbAwbMXc+Tw2FAZubdaA5jUk/to3rg=
X-Received: by 2002:a05:651c:556:b0:2d2:a443:9c64 with SMTP id
 q22-20020a05651c055600b002d2a4439c64mr1207121ljp.45.1709050646274; Tue, 27
 Feb 2024 08:17:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
In-Reply-To: <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 27 Feb 2024 21:47:14 +0530
Message-ID: <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
To: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, 
	Stefan Agner <stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 4:46=E2=80=AFPM Jan =C4=8Cerm=C3=A1k <sairon@sairon=
.cz> wrote:
>
> Hi Shyam, everyone,
>
> On 10. 03. 23 16:32, Shyam Prasad N wrote:
>
> > +     if (!ses->iface_count) {
> > +             spin_unlock(&ses->iface_lock);
> > +             cifs_dbg(VFS, "server %s does not advertise interfaces\n"=
, ses->server->hostname);
> > +             return 0;
> > +     }
>
> May I ask why this is now being logged, and what can be tweaked in the
> case that a server does not advertise interfaces? After updating the
> kernel from 6.1 to 6.6 in Home Assistant OS, we got a report [1] of
> these messages appearing, yet so far only from a single attentive user.
> I wonder if we are going to see them more often, and it that case a
> suggestion to users would come handy. If there's not a simple
> resolution, could the verbosity be lowered to FYI, maybe?
>
> Thanks,
> Jan
>
>
> [1] https://github.com/home-assistant/operating-system/issues/3201

Hi Jan,

These messages (in theory) should not show up if either multichannel
or max_channels are not specified mount options.
And if multichannel is enabled, then the server should support the
ioctl to return the server interface list.
These messages are meant to help the user/developer understand why
multiple channels are not getting established to the server, even
after specifying multichannel as a mount option.

The repeating nature of these messages here leads me to also believe
that there's something fishy going on here.
Either the network health is not good, or that there's some bug at play her=
e.

--=20
Regards,
Shyam
