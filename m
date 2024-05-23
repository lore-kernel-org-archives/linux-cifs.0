Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F388F9D4
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716480764; cv=none; b=UwsVpkimqMkCBUmOdvJaZfRJTRSwCRJzRaimZUmw/Ue3Dkk5v/CSHrKcsdOb3zd8SrbsRLuasFdmRcMmkbPBWHSiAk+gNAYwVZusifLJ5wM9ISGEHol9Bbo+b4LPkscBXvFLPq8VLVyyeVw7TD0QFO8doHM8D9XfOuoTAExiuWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716480764; c=relaxed/simple;
	bh=4EBGsaHnejMlpe7FXkOoU9mKY7SVzdOnepvOdTiWR9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVGNiAzHXY96ACSlgSau8D3t488X4r/cyCbcXrqM0nR4XvTAxECsL73T9sU3tvkQ2UiN/ruBsZR3DPB4AQtz7HRaZIEv/jaaPwPeH2MzEwbB5/Z984TgDCH9KCcRGwaO6gV0eAq4LwPHmdD7pKytQlT8UDVKv+6smKI31wmbOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qs63dWbT; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qs63dWbT"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51f71e4970bso9791703e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 09:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716480760; x=1717085560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIkC1tFrlubZTsOngwWMsHIUA6wsZSumHtDveHKeM/k=;
        b=Qs63dWbTywwb1fauZnDoOIFcWvs3lFn/UFowPBc5PlAX7FIeryXjiEswrTNj/DnM5j
         TCDZ/xCzGu3i6BLpmLaER+ds9Bgd2uZxeYW8LOSymZdMzITdy1iLyewabijjclCPfaWD
         pE1rch08Ei7LsuvLD3zmyK+Epu54OpFp2g0Q2IFz8GitzkuSKhBRHLDdIziVTpkKkYvy
         d0MI0Thd6VKqGU8X1mZ8I1+YqC/m0BO5lQrh12HsYJu+wn1920nPDr8rEL23cJ1RkvAG
         kXGedXIbK+s5W+jI4eATRO9uPJz0zhYll+GbLXxpBFn48GNU5BMZmmzR4VRSnIWqW7nQ
         zOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716480760; x=1717085560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIkC1tFrlubZTsOngwWMsHIUA6wsZSumHtDveHKeM/k=;
        b=keviAR0xKMVc0lLEnNUmVXsg/4gkT2gm7BZrOyzyelflKxLMS/sKUcrlWfCN5x6Moz
         wNz3QEGNCA0Q55NFkELlz8MROG3TXdFSnnZpQZCetNfvW8uMuB9MfvauOYqxsdSNFy1S
         gR4tyD8nvip7pJqz3+/Z2/3ryPuEPTB7ejepgttyfdjtKMeB3we0880rSwU7Jw7dBFFI
         BZAqwf+xDhRRyHRMDThSkyDt4cMH82tPlFEEV5bpascVfCfHsDU1rFX5w3NPpZNQF3Sj
         DboEPzD1hBA+XRq23lIOkZqX8NKc8pUQrimstsvSMm8Y0Z4acEM1P3Ca0dNjlETEGSse
         g3Zw==
X-Gm-Message-State: AOJu0YzThjbJBTL1xMC4YsouSEzXjBWYMv0+XyF0jxNof0ab5zXeSFRU
	fejqjYDmcdK6KzSx7VAs68e7708jXpIX6wsI0ZJzSXjMNcCXTpHM7/JPIvLabwWCyL+HdlOy6G0
	dGj73pGXyn3GFbtJxAx/dicIarxw=
X-Google-Smtp-Source: AGHT+IHAmTrtnsBX5wdx90ZqzGCTl9WKvThjMY5M7bXOH51WQzYELrycwt7d9YstPO5m+rzDeDnOiRXbLqsh887TkQg=
X-Received: by 2002:a05:6512:1586:b0:51b:539f:d1c2 with SMTP id
 2adb3069b0e04-526bf82dbdcmr6102743e87.33.1716480760124; Thu, 23 May 2024
 09:12:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute>
In-Reply-To: <5659539.ZASKD2KPVS@wintermute>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 May 2024 11:12:27 -0500
Message-ID: <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Kevin Ottens <kevin.ottens@enioka.com>
Cc: linux-cifs@vger.kernel.org, abartlet@samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What is the behavior with "nobrl" mount option? and what is the
behavior when running with the POSIX extensions enabled (e.g. to
current Samba or ksmbd adding "posix" to the mount options)

On Thu, May 23, 2024 at 11:08=E2=80=AFAM Kevin Ottens <kevin.ottens@enioka.=
com> wrote:
>
> Hello,
>
> I've been hunting down a bug exhibited by Libreoffice regarding POSIX fil=
e
> locks in conjunction with CIFS mounts. In short: just before saving, it
> reopens a file on which it already holds a file lock (via another file
> descriptor in the same process) in order to read from it to create a back=
up
> copy... but the read call fails.
>
> I've been in discussion with Andrew Bartlett for a little while regarding=
 this
> issue and, after exploring several venues, he advised me to send an email=
 to
> this list in order to get more opinions about it.
>
> The latest discovery we did was that the cache option on the mountpoint s=
eems
> to impact the behavior of the POSIX file locks. I made a minimal test
> application (attached to this email) which basically does the following:
>  * open a file for read/write
>  * set a POSIX write lock on the whole file
>  * open the file a second time and try to read from it
>  * open the file a third time and try to write to it
>
> It assumes there is already some text in the file. Also, as it goes it ou=
tputs
> information about the calls.
>
> The output I get is the following with cache=3Dstrict on the mount:
> ---
> Testing with /mnt/foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: x count: -1
> Third file descriptor 5
> Wrote to third fd: -1
> ---
>
> If I'm using cache=3Dnone:
> ---
> Testing with /mnt/foo
> Got new file descriptor 3
> Lock set: 1
> Second file descriptor 4
> Read from second fd: b count: 1
> Third file descriptor 5
> Wrote to third fd: 1
> ---
>
> That's the surprising behavior which prompted the email on this list. Is =
it
> somehow intended that the cache option would impact the semantic of the f=
ile
> locks? At least it caught me by surprise and I wouldn't expect such a
> difference in behavior.
>
> Now, since the POSIX locks are process wide, I would have expected to hav=
e the
> output I'm getting for the "cache=3Dnone" case to be also the one I'm get=
ting
> for the "cache=3Dstrict" case.
>
> I'm looking forward to feedback on this one. I really wonder if we missed
> something obvious or if there is some kind of bug in the cifs driver.
>
> Regards.
> --
> K=C3=A9vin Ottens
> kevin.ottens@enioka.com
> +33 7 57 08 95 13



--=20
Thanks,

Steve
