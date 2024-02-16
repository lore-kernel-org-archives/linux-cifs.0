Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518DF33987
	for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708103213; cv=none; b=NXe1BF/K+jjTOggrNlkur4pOv03KH5jmi2sPFnJ9Zj6EAvmxGpizYJzJYj1v74mGYLO5AGwDK99EK0iNmdTWysAhlcZs3J4C3h2+A9YJfR+vEokrBDW80uLtzfyOEPSd5L1rUrA2/M4m8zKg83jKzbDaSMAQk7He7lUMCSqjVKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708103213; c=relaxed/simple;
	bh=IT2jgpcHkg2Xs+j6qg+Zt64BB7/OA0F7iWDp3Y86wRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gmK3SXIxqMuT19yt9l5JQnSy2dUUvRZbWzEDgXvLG5AcwmxjiF4/rgPTmYIVyyV12SBR3syiMX3rKAnDMlTiMgxx5yd4OoBel8A9dIM+4xq5Id2OmizmiKrYOoI8bbZfCG6v2/p2bhC/g6BDvfWZAlHuL93rmP4OzQ67VixXVuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtLscXP6; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtLscXP6"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5128d914604so1932421e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 09:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708103209; x=1708708009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjga3gQH/IKqLKITQswThucC6tah7iPo/cvtowVSbxY=;
        b=NtLscXP6f2smaufsehbm29p2O+KFai2u+RHL4Xp2fKnE57oBcPtmGT+p+YVf/P8mei
         W/XAz8kCB/Nu6mfFxWjNEd1DhP2yKGbV2/7HogeMf6lBVk9GcOhXPNexD3EbfTdl9xYe
         9Fa5C8D9NT3ovfVpzmnwsRWeZoZURbArtc7e4BXfh3Unckt3VIvksKkKwXClI0TT6gkO
         KjfCHpPzB/ad3cijw7V7Zlmm8yb++aiTw+I+IJ8lyyKw88wDtrj5plCdH2et+k1YIWgG
         oDU0GTkP71wbK1JR7lHUi/Vx2uRC40GIQTF85hljKEBi4fJOdTVOeXglEn+90zipKFiq
         LG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708103209; x=1708708009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjga3gQH/IKqLKITQswThucC6tah7iPo/cvtowVSbxY=;
        b=vqvfZutE6OEs0mQb2mWNfSaN/mvbybh0O17oH/jEYtPZwlTjzP4566qREOUvcMHKMQ
         ipcVfW0BL+NMfBC2MrSaeifR8R6W4vMl2JOTtLU0J2vg5f5RZqIj0KrzI2DwkvsnSyeq
         Af6wk1EuQhmvs93q/aufRtPSV+quWhwIammP/kE6FpxV5ncW5ozN+5dM75immuSKdEBn
         GSV8R6hkL+e2aJPXNVgzrG7wCr5zt/zpMH3CHXn1s/YlVwSyIVYpUDhO/2x3znUSJuFq
         QJ8tigVzLqspL1nZZl7kUlw6K6tUQV8uCE+pMlo7fFOvNveUbrAritgD6gwfhy/W1THA
         If8w==
X-Forwarded-Encrypted: i=1; AJvYcCX12oGXmJwO3a7oaUkUR6lo3uwlCBRTlK7JwpO4Ir9hxbyc+xc2s77rPBf8h3iksL3RrO3gS7xk7N2+P8YEWrzFYiJ4tDM9GYqsjw==
X-Gm-Message-State: AOJu0Yx8p9BMYiCGXy1gnt2D1tsNy/YJ0BcovNtT/ztW/IcZhS+C+35l
	CYPv9iScUtv140CWbMEUkXcu/rPzKp/PyNjRI+4TKC7gWnJ0fgsqxoJtKcz4ZwPOZvdufjwyj/t
	3NTajYzZ+sYwMSZG33oFtnRZAu54=
X-Google-Smtp-Source: AGHT+IHXVhMOz/uDEfxZUOpgcZDeBm7klLlZKI6uwOxY3T9Y1IC943I3H57dHd6tAzB90H6h5q6I5MHfV+aMWgHHbP0=
X-Received: by 2002:a05:6512:3b9c:b0:512:8db1:8784 with SMTP id
 g28-20020a0565123b9c00b005128db18784mr3372861lfv.6.1708103209022; Fri, 16 Feb
 2024 09:06:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com> <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
In-Reply-To: <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 16 Feb 2024 11:06:37 -0600
Message-ID: <CAH2r5mvd3u3eg9hZ7Brx7bnbPkC9K2P3KVyxM+mTajE=uqT3tA@mail.gmail.com>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	David Howells <dhowells@redhat.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 8:41=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > need_recon would also be true in other cases, for example when the
> > network is temporarily disconnected. This patch will allow changing of
> > password even then.
> > We could setup a special flag when the server returns a
> > STATUS_LOGON_FAILURE for SessionSetup. We can make the check for that
> > flag and then allow password change on remount.
>
> Yes.  Allowing password change over remount simply because network is
> disconnected is not a good idea.  The user could mistype the password
> when performing a remount and then everything would stop working.

I agree - will change patch to do that.

> Not to mention that this patch is only handling a specfic case where a
> mount would have a single SMB session, which isn't true for a DFS mount.

We should do a patch for that too.  Agreed.

> > Another option is to extend the multiuser keyring mechanism for single
> > user use case as well, and use that for password update.
> > Ideally, we should be able to setup multiple passwords in that keyring
> > and iterate through them once to see if SessionSetup goes through.
>
> Yes, sounds like the best approach so far.  It would allow users to
> update their passwords in keyring and sysadmins could drop existing SMB
> sessions from server side and then the client would reconnect by using
> new password from keyring.  This wouldn't even require a remount.

Yes - I was discussing this with David Howells, and having a backup passwor=
d
in keyring is helpful in long run (and better solution for some) but we als=
o
need remount because that is what user's would intuitively try first.

> Besides, marking this for -stable makes no sense.

Problem we have is that it can be (and has sometimes been) a big problem fo=
r
user when password keys rotate and no way to fix it other than unmount - so
we will need the "easy and low risk" solution available for distros
since keyring
won't work for some use cases (although helpful for others)


--=20
Thanks,

Steve
