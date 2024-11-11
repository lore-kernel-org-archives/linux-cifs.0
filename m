Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB97AD58;
	Mon, 11 Nov 2024 01:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731288336; cv=none; b=prX/pcqg5+3EzY+7ocRtQy77BdN4CGtN+Yg4DUX4kAolGGWbz3pXZ85DOcxyeUlOZEJgi3qYUnVfwZw05VprlPKH+2TJQgFOfcdecb0zQZlfOtfHC3fEgwK1ww93GaTEH+EkErxThVkR1Ig6Rpo/tonyoqMdowTZ5YVar8WbQbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731288336; c=relaxed/simple;
	bh=QHVR0GGGN1Y3Qe57p9sktkTdO/4KfFP/Xl52rcTgU0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWKlyPN3yTVlJ9HjBcIND/WybhglvmUpgucgmyB/Z9XBRJVFg39AbmIlfLJfLJ+hwNkScWAWFRuplPdRe6diClLJntry0vzFhaxb20OZIi11MK74oUkEXJcFDeaqi1ey69juzqDFj0Cmx5ZwQCUZ66Bs45Us/CEvYAs6ZAyJgms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ClNZg+U1; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ClNZg+U1"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539f4d8ef84so4977171e87.0;
        Sun, 10 Nov 2024 17:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731288333; x=1731893133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hjbh6lLUqnJxi3HSXhOyrGpP22ujh50AM4aiBwHCyh8=;
        b=ClNZg+U1+Md9g/xfbWngChvSlzHG3TRxFTO73+OMAumMhn/Tv/p1g3ycFefrrt1UCS
         pROI28tf0EQGYolwFxQyKv6WhCtbUaDCXPzcks0b2lzte1pXkrR2KiJxOueQwbQEmWAu
         JH6hXiPEhGj8Mv1zYfE/cDJMaDt35/6CWA2kaE5DqR6p6a1Phj4pphsjtCy5PVHaiAIn
         bCpxyAwEEPIwLptTv2mc6o8BfR8K5QgN2M8tdZs0K/ik55hcC2ooNRh3j0A1VfBvwjDG
         llMQchTv59aED6Ful+2ezSeOfb1RNQYLkwy+CzvqVwD1pO9XxJIOuF6d0QDpVvpGO+W7
         xMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731288333; x=1731893133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hjbh6lLUqnJxi3HSXhOyrGpP22ujh50AM4aiBwHCyh8=;
        b=HenPX32ulbI5oY9LQWpVQttAA7yWqdXKT/nC8vIc+cl+9WrZTwpQCmrdPSzrqzEMwD
         bYb8mHVly+HcKBTl7AEArdEoMYYO4uN/42ctcukyvtr7HLY3g5RXlZ8Jj7EObWFSTcTP
         dp1g6HK+jwMpP8Ol6Xq27SdW0brF4wyg/SnUXboHOQLkgZA9qDjYEolqAY+MI8vTrgxM
         YtWoNiLXPkYKIzk2Lg6sBcf4sA2lxuY2PvM/GKOG7Upj2c6tNsNjDk7N7r4zPqHjnXs0
         spygzBYCiJ+s2XYaQNXN95Wt1nifFUbnFq2kSqRJhfwCsj0CCNXlwo2L3X+T6+dm7zP3
         u1HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWc8uydZ8SagmMR1PIh8honCijMFd1qHU24q18UHw3/mBQOts2iBCViVQlDm4925TGs871ATOYk5z7TTi+8@vger.kernel.org, AJvYcCX9Jl+CLCRRHyvhDA5NOvkyc3/r5YGteEEciMwvgzaYHKODejlhegNEFEKkNoRFsYl9QyTQKeUzWcnw@vger.kernel.org
X-Gm-Message-State: AOJu0YxEp8nxcLNvEQR3fXFo7VXeinaWG84qdhhAFwEC5vdBHyzbq1uj
	a3XPQfSGdQA4+AqdaENd31SQryFE9ipRNSuunb6Ewh2L5BiRqEedk5UuzYIMO2Ws+w+FrCnYL+d
	6uOsUYCL2ZFa9Vk+tuT3vu3K95Hw=
X-Google-Smtp-Source: AGHT+IGM3TTaW39blKH6IzIldaKyw7LDF83ZaE9I6qYRNEv42LlXzuX3QmlZFITFjrJVPXuF8B3ilP7N9GcJ1LTabq4=
X-Received: by 2002:a05:6512:3e15:b0:539:8fcd:524 with SMTP id
 2adb3069b0e04-53d8623fa76mr4343924e87.30.1731288332835; Sun, 10 Nov 2024
 17:25:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007210214.102568-1-linux@treblig.org> <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
 <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation> <CAN05THTgj+_78kG3LFnpU9zsjEEBAsyDZ0P20YL3-DP94r3KUA@mail.gmail.com>
 <ZzFaSf20nIbppt8w@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZzFaSf20nIbppt8w@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Nov 2024 19:25:21 -0600
Message-ID: <CAH2r5muJ_+d5zemgPUG8y6stiCmw4nnR=iyK683N1Gii4134TA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: Jeremy Allison <jra@samba.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath S M <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

SMB1/SMB2.0 can be disabled fairly easily in the Linux client build,
but there are occasional requests for it due to SMB1/CIFS still being
used to access some old devices. Also some of the SMB1 code was moved
to SMB1 specific files to make that clearer, and to make the module
smaller when SMB1/SMB2.0 is not enabled. Even when SMB1/SMB2.0 is
configured in the build, in the future it may be useful to not load
the SMB1 specific files (put them in a helper module that contains all
of the SMB1 specific code, rather in the main filesystem module)
unless the user specifies "vers=3D1.0" on mount.

On Sun, Nov 10, 2024 at 7:13=E2=80=AFPM Jeremy Allison <jra@samba.org> wrot=
e:
>
> On Mon, Nov 11, 2024 at 09:02:03AM +1000, ronnie sahlberg wrote:
> >All of SMB1 should be removed.  Not just disabled but deleted.
> >
> >What are the plans in samba? Any timeline to literally delete the smb1 c=
ode?
>
> It can already be compiled out of any build,
> so it's an option for any distro or user of
> Samba.
>
> I'm not sure deleting the code is needed at
> this point, as it still has legacy uses
> (there are still commercial uses of OS/2
> out there for example).



--=20
Thanks,

Steve
