Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F654664
	for <linux-cifs@vger.kernel.org>; Tue,  9 Apr 2024 02:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631434; cv=none; b=FCbiL8KS7jUsPilJJ7ldkAO/YUjh7YhrY6ypyXvKKc5fHzKgg3aIesfSDP79u+yLFTb5ZY4xvFo3hweo/qjmzGcMrSvNZIdraYCsspJZI4zHNaOunhnyhD6ZPnBry8Q8326VAwTWXW8AkwPaXFLb5H3ne7kYH0nnTBVAmI1LhPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631434; c=relaxed/simple;
	bh=Pyz55rlmpLa8wA08dhaQZGOdH64rpWlewvTqOS4IbSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Ro+BRWAt4QVVUG45KsfXdQEVOw1JIOdSy9953sepXTz2938+oaZJnrQZ3M3Ez3hvQrxqNaAkIihLwOD97Twdk8Ylmx9TOdPZJUrmnpiMuA73P086+o0oV/AkSmX2vgSHRXXOIU2oXxp2UCh7PY4ZktLRb6ri54NnZkrswBv/2us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqiXxSXl; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqiXxSXl"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-516db2214e6so3489140e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2024 19:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712631430; x=1713236230; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wURkXDPItmAbzKhytSn6W+yKeTGtfi25aitI/ZkF7xk=;
        b=NqiXxSXlzcW/0iACZSIdJ78q7jtXMhfR6VZX330zEgXOhJiDMjKHyig6wK50Zhk+4G
         JY0LUZi2oYmRF/WcoNEn1dJqFn5x6K754uVLy+t53n6S3mop1ICbnSxa8HTk163bC22Z
         LXvennmO2njJthkIXgko40l142CLl/rA7UVCty80rlLui7GLhfWNc0lfyoZv9WyGi1g5
         kAMZcUFbz+5kV5/gQIddIMbzkkUtHsLFSquaRFRoJ/uKiEO4ayiuzcJn/fsHn6WY6WUU
         haI4nl/OsAUcX0lmCRMR+dB3M05Eky7HSDMey2QE6DhqVumhXmCXT4SK2Pq0n/2DVUKF
         i5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712631430; x=1713236230;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wURkXDPItmAbzKhytSn6W+yKeTGtfi25aitI/ZkF7xk=;
        b=aZqlD7tupTvPt9A8VQQbH6oCTOxbfJUNGH/+iEghU/H5c/6XFuJ4ZVCbOm1dKoX1tD
         HHfo3chZc1MuPiu39zOf0JkG3Bjeej2U2QCWW38laUU/SaHKWOk4rSBUt6mW5Nkkdism
         YScs3stnImCasmja2BFs6Sieu+d1+toF+Q7SiaZ05ikkbFRjAeZQQt6FRWKc3JBwOCts
         qpwE0vMKuX8SX6TnnJ0NKDwYWT8DtCWGLJtsQKVbCrCNXAz8aBkBkuQ35AWtL37I/31C
         ZC30xIv8pzeijZV8yKRwjeuQjrAw9tbnc3wOFzWzKfAUT1WCJ5J0TpSMj4BycXRCaWwx
         V6pg==
X-Gm-Message-State: AOJu0YyYozMzoHqmlY9MrD/VKuAm8xQnn94FjRYo6Qz78gUBtFxNqPHU
	FkFnR8hUwGl8Pf6gV4UKi/sVfkbyB2pl4nIp8YnCzbXRLiP8Ghj4yZdiM0abTJ0obmA8/705xOK
	Pyp8Qvlawm5EkmM2M/8Rx4l/rLisEVzRC
X-Google-Smtp-Source: AGHT+IEmXmLXaNMcxD1yxm01zvHsEuEEPzV8CRlJyyCYit8CDcUcAZdBThTlAHTqM6ybiyGXMjoNDuqUScMK8zQWNjo=
X-Received: by 2002:ac2:4c13:0:b0:516:d538:35b2 with SMTP id
 t19-20020ac24c13000000b00516d53835b2mr6868809lfq.23.1712631430180; Mon, 08
 Apr 2024 19:57:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muOk9hfCqMzRKnKR3sXOOauGdjbvuzms_bKM+U0t5zihA@mail.gmail.com>
In-Reply-To: <CAH2r5muOk9hfCqMzRKnKR3sXOOauGdjbvuzms_bKM+U0t5zihA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Apr 2024 21:56:58 -0500
Message-ID: <CAH2r5mtNZT-zvPjxgqKak5uA6pwyAbvEjOmTB24Vg5O_2-91cw@mail.gmail.com>
Subject: Re: Hang in xfstest
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On a more cheerful note - although we do have a regression to fix
here, since 6.4 we have fixed A LOT of things, and lots of
improvements.

As some examples: xfstests generic/075, generic/112 and intermittent
failures in generic/047 and generic/049  which used to fail, now pass,
and multiple tests have been added to the "buildbot" regression
testing automation.

And in the future it looks like we will catch these earlier.  If
anyone has regression tests for bugs that have been fixed over the
past few years (that aren't already covered by xfstests), I would be
happy to add them to our regression testing bucket of tests we run
regularly against various server types.


On Mon, Apr 8, 2024 at 5:31=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> I narrowed down (bisected) the cause of the crash in unmount
> generic/046 (to Windows) which causes the hang on following tests
> (generic/047 etc).   See
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
3/builds/61/steps/73/logs/stdio
> as an example.
>
> The regression started when I add the patch from 6.5-rc1 "cifs: Add a
> laundromat thread for cached directories"
>
> The workaround is to simply disable directory caching for that mount -
> ie "nohandlecache" mount parameter.  This unmount race is only an
> issue to servers which support directory leases (e.g. Windows).
>
>
>
>
> --
> Thanks,
>
> Steve



--
Thanks,

Steve
