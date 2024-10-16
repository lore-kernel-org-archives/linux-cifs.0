Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C83D21E3A4;
	Wed, 16 Oct 2024 05:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729056972; cv=none; b=ox2aQyw9aa8tQVR0tmAcYJnjoLOUrywRI6XJV4YGhmVvErzRVXxoNUUrvq0GbXQje6ANIY48560X9PvFF+tVigpOZM+9Lc4D/yK4dCBm4toJ10AHN0RytlZxeZlGEvXRqX03RdjDTaX4dyZRgg9Bql6za+PH8B8yDpyzwuFiIRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729056972; c=relaxed/simple;
	bh=AkFlicyemJIypTbpaoNWqMseVAcg9/xRYW9x0I/QujU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRnL2YNYWH5V8B/GBUhGUCMUHcLUfOOlVhlwshtSl/8tbc1c6BSGzEcDOYX4GxqzyMlhTiCgJM3pJXl8dSb/CC9emcztuwh+Ok3k7mDDuV9wLHSwI3CcTzsGuvhRBih9jzw/OEvt/p7I3ZEdcmmN/hfNyJEUHMFtuXEdFbS/1xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpOf2n+v; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpOf2n+v"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e6c754bdso3383966e87.2;
        Tue, 15 Oct 2024 22:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729056968; x=1729661768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpFzgW48v/2WJ52rpa7W+YR88yLyOSmQvacK2YcE0vs=;
        b=CpOf2n+vo0pa82tUjxQEBWLMvOkqHtw3qpB8Xr469Cvjxb8200tSARbOUmxQ5M+u0N
         aByhHnotzDZrf474lTMVZZzlJwYMkxkPvWGlcBOKWP0VufiizH5dm57U89nHZUIR9Xh3
         F5Gw9Ix3VIlO33KESKE785l2Vnmnq54OdsZ2onfzgvNKbIexK8uRUfCrYJUdwW7LCjvm
         4wCTwUClxR+b4yN32KgqtXB0okRsXni8eLHd6B6sPn/IAE4IxEKWeUb5LJGE80wlJE1p
         TUbgiGwU+vaSdWEblJVeIIIco2KLSorNwXrpCBXqLImak33kBVSj/07SdOlp01kuad5O
         +4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729056968; x=1729661768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FpFzgW48v/2WJ52rpa7W+YR88yLyOSmQvacK2YcE0vs=;
        b=EaYQFZOkSCyfZgYEXYTaeBZR7MKLRyENSpUgzhclVCO7kSMsKbSQPI+27Y7pjfdvGs
         Y/uUhCgCI4IKL7/oU5b6oA5rh7XFCR0o/BDvfWni09vm8na80OCw0t3w8IKevmA7tS+A
         OPP+sdCDJgt9K+jBvYDyL7B4VRTZtR8MmLzeQBDk0XYQAluI2WQDRSZW0wY1Ww4Q+Y7q
         0LmKHL9i+44j2USgBeMs0TLwuifPiAhpUrJ/sHBEjLdGlPH5jR9lhrohZNSvvFqhB02W
         UvLbDuTRygIX7XcFPp/zF4eUZ2cBsTb6Px0l+m77pT5/UMpw6WClt8M7zuW9Misur8U+
         1AHA==
X-Forwarded-Encrypted: i=1; AJvYcCUoSqsJ2/bIbwMbQbjjhrzoggaCOfEdMBYg11YfvMQ64yWm19ofCoS8OADscT2talMCcxGBhLpjb7VdUa1y@vger.kernel.org, AJvYcCXBscylOEf3agxzmfCAUMiEohzD6eS3ud9hMHK4eWmYvfaGbSaMkErFC6/q+M0yIc6fukdSlhcf8ABTYg==@vger.kernel.org, AJvYcCXLJ3LH0DGiSTNxL843vmDLOImNZlgZUZ93Fo2RKd1/V+VptPEvvVwf3J//fOlEn+TOmy9JkxZP7wmmQruXGqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxtzezgPvB8b5UdSGoJ9LC1uWXwwwYHH0nhvLOtdZtoH8c5wUK
	djd7u3S9/VuG+Tvr9ZkJXhTGaNLOgWrGeu9wQyKodSX1WGQUbUxRTgIqWpJ3erSRBwjp4lAux3+
	6i/+CXeMAOUAq0cYXt/CCwyTHvaVzgAwA
X-Google-Smtp-Source: AGHT+IHndmCm/EMXJXuOFINZjOEoWro6KrtmVvkmaBHgAUiFCfIOV+zT26SggvV9rS71zmBuYVLfzcWnox5WdYRK8qs=
X-Received: by 2002:a05:6512:3f29:b0:539:ee04:2321 with SMTP id
 2adb3069b0e04-539ee0424e1mr5151271e87.33.1729056967486; Tue, 15 Oct 2024
 22:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015102036.2882322-1-suhui@nfschina.com> <c0afa02b-991c-4601-bacb-13ace9cb96f2@stanley.mountain>
In-Reply-To: <c0afa02b-991c-4601-bacb-13ace9cb96f2@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Wed, 16 Oct 2024 00:35:56 -0500
Message-ID: <CAH2r5msLmsCn_uHqyzFy8CXy6uCheOECNSXLReJdS4u1C4aN0w@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix possible double free in smb2_set_ea()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Su Hui <suhui@nfschina.com>, sfrench@samba.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, stfrench@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, nathan@kernel.org, 
	ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing

On Tue, Oct 15, 2024 at 5:45=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Tue, Oct 15, 2024 at 06:20:37PM +0800, Su Hui wrote:
> > Clang static checker(scan-build) warning=EF=BC=9A
> > fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
> >  1304 |         kfree(ea);
> >       |         ^~~~~~~~~
> >
> > There is a double free in such case:
> > 'ea is initialized to NULL' -> 'first successful memory allocation for
> > ea' -> 'something failed, goto sea_exit' -> 'first memory release for e=
a'
> > -> 'goto replay_again' -> 'second goto sea_exit before allocate memory
> > for ea' -> 'second memory release for ea resulted in double free'.
> >
> > Re-initialie 'ea' to NULL near to the replay_again label, it can fix th=
is
> > double free problem.
> >
> > Fixes: 4f1fffa23769 ("cifs: commands that are retried should have repla=
y flag set")
> > Signed-off-by: Su Hui <suhui@nfschina.com>
> > ---
> > v2:
> > - Move 'ea =3D NULL' near to the replay_again label.(Dan's suggestion)
>
> Thanks!
>
> Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
>
> regards,
> dan carpenter
>
>


--=20
Thanks,

Steve
