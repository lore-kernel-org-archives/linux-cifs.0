Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3381D651A2
	for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708693244; cv=none; b=lBzpKkq+46MTLfQcEOWeCU3j00gFf5Irfvy1E7hB2XHsuBUc6t//c6fx+H3L9/f8flzYYZHT+d+5NuPXYR1TAsrHPV08psXFvVVSon57WzGCoIng15VTrxJjRhaG+kuWE8o/+HbtJz+V1e/sZGNP4K87rRfKYKA60jA1lNaRqkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708693244; c=relaxed/simple;
	bh=HN520ctj/MAKBUiUVK/+/VvX61Mlz0nj32QlWOdM92w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gY0Q5XgcmO40AYcMG140vLulBAT5vbb3tQdKMw1v55R6XqdbvnIWkS5dmhfpqeywKY81y5rqXJC4xiogOKK8ifyyymoShuXB7DhiFS6rfUUev3hVPbg7F7xgaM0wu327nw+HOI6MiprkxS0yphv94gPca7xLSRnaynZkfU7zsEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqlLiZIt; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqlLiZIt"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-512e1991237so283364e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 05:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708693241; x=1709298041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzz3qxipxvWc/8yj9v4t/ws/pFtr+5ndswJ69jV4L84=;
        b=YqlLiZItQ1QRo0kN0D7KQ4Ecy52PAlpvQ49OOkWotkJ+TDJ21uajUA0gOrdg36Njli
         TP+G8bVoT2M9+P+/s4sAZr2Fvc3s66mqeu3xvsrizEoWJHMk0cl9IWyuBGOyTJYllT/N
         9KevD+Bj7kVrKaaeVxqkHWXllbOTEg6fzyZawNPa2RTiJ5OeG56DRJIqU4SkzM5o48Yf
         Fx1FMnJESkjIwZcGbnJB1LOUEU8pglxT/m3hIJdohY7EcwgeJogoiCTN33zh5dAtgbeE
         SlRywUASF867ABNxpEZvCtw7n3dwJLGs8e203i/b9ldPndNApS+RBF15LXhWyLMSB2+Y
         vsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708693241; x=1709298041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzz3qxipxvWc/8yj9v4t/ws/pFtr+5ndswJ69jV4L84=;
        b=EPKYM2Xq5XoHMfCSWKJAB0wURAehCYMX7GgnVLxY4qsYNK4ELHrZn6VSxdOWZfAvEt
         C8UZ+Kj35pq4pz+dCOEu3IuBzg0I563sWLJTie857bWHJ0lcSGISiblnDazi14PKYylN
         wCsr6RdrSCqhpIMptQIuIixxS2DUnf5BXM5ifKhYOn0OWkAsJTASetGUsoIHtxvMJcK3
         UnyoLKJjGO87aAPzp5kPomsxhuiQFhFg4pMTaVbHsOWHB8N1KT7c3gjbdXMOaEaYk9gJ
         yI/eGrX/SerpTIhQF1CmEJOJ8TjC43Wl+0ibhCakSyCXIBojz1+L98Y1TShKGXIP2PCD
         Go4A==
X-Gm-Message-State: AOJu0YyFoaPEES9OBuKGbvxItnyBv1ROGfhjc95L52Cp9ceLp3mNlYpf
	6fjjTC7amD4fkwg/zxLwHQkdG7YkskQISSyYfSgZygXAyb8wPHtPQhhfnWqTZ5MBosUo46oh/dR
	SabHuThoBVqbuUELmD/rb17Wh9stW80PXtg8=
X-Google-Smtp-Source: AGHT+IEu/1kfc9b/Fj+hxX7FpSXyLmnqt4ria6ss+lJUfKQDWhUwB3Gr3AlJu3ivduwHM6DTNuG3tZFPErtj4POfw34=
X-Received: by 2002:a05:6512:3caa:b0:511:463c:32c1 with SMTP id
 h42-20020a0565123caa00b00511463c32c1mr2789802lfv.19.1708693240922; Fri, 23
 Feb 2024 05:00:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtsvNU--3EDFvAPSVuSnLpmbDr5A4YbaY=9rrndLyOpiA@mail.gmail.com>
In-Reply-To: <CAH2r5mtsvNU--3EDFvAPSVuSnLpmbDr5A4YbaY=9rrndLyOpiA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 23 Feb 2024 18:30:29 +0530
Message-ID: <CANT5p=rqWiiYtRnCjd-SYv5SLqAzEPwLknLUqT0AGibtwNq+Vw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] update allocation size more accurately on
 write completion
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, Bharath S M <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 12:10=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Changes to allocation size are approximated for extending writes of
> cached files until the server returns the actual value (on SMB3 close
> or query info for example), but it was setting the estimated value for
> number of blocks to larger than the file size even if the file is
> likely sparse which breaks various xfstests (e.g. generic/129, 130,
> 221, 228).
>
> When i_size and i_blocks are updated in write completion do not
> increase allocation size more than what was written (rounded up to 512
> bytes).
>
> See attached.
>
> This fixes the recent regression in various xfstests caused by the
> xfstest change
>
> commit b4396efc75aba5325f22690303857af4f63d128e
> Author: Alexander Patrakov <patrakov@gmail.com>
> Date:   Tue Dec 19 04:57:20 2023 +0800
>
>     _require_sparse_files: rewrite as a direct test instead of a black li=
st
>
>
> --
> Thanks,
>
> Steve

+ loff_t additional_blocks =3D (512 - 1 + copied) >> 9;
There are chances that additional_blocks could lesser than this value.
i.e. if the write started writes from before EOF.
We could then calculate additional_blocks as more than it should be.

I think there should be an additional check here:
if (pos - copied) < i_size: additional_blocks should be based on pos - i_si=
ze.
else additional_blocks should be based on copied.

Regardless of this patch, is this really a bug? This is only an
estimation that we do till we get the true value from the server.
A filesystem is free to allocate blocks as necessary. This patch
definitely improves this estimation though.

--=20
Regards,
Shyam
