Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1762581
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 05:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749016548; cv=none; b=tD4EHRrB9ggRvvlcwgW/CLHkur5gdjKGOVsyHJLZ3FeeYb7NzSAlNZVZYVkcoo6TBfGX9lCDIdA/EjsD2VDE7a9aZPK83zPMYCxNwjFTpG3MFFZGzrSRl3P3eSsqJK6qqXqVI53NK/5lHIdRaQd46/zXr8oaT2yKQ1xaqdGo7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749016548; c=relaxed/simple;
	bh=jSlH1LL0cckAbt551iVIxSXeCMB2xvQffM5iVLdR6zU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzuV3Ku3aYCSkkm0zxUe7NbQk5f0/a4UNjE4PQIBezLCIkU+4NQ6+1G3Vj8/IogWO2In7deptGWshIJvSL8T+/wcRR3OSQWS+z2QFQ6bzgo207sOsWkY86Qx6qAOrZkoc5zzI7w3aiWThSulGX8nDMW8OQlpfa6T5sVBq7+iZbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DKWgr1ND; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKWgr1ND"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-601dfef6a8dso10492753a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jun 2025 22:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749016545; x=1749621345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TdPxOGC8ep3grZ2WA6OFbjncINiYIFWqbfo1FAV9lSQ=;
        b=DKWgr1NDdRllgj4U3skX0T6k0GN/X+/ZofHM7/A9nZUKtQvTvDaLwY/G+hYxt1jEkj
         U2TqkzUc3zAJsWEHq5btWDYOFax+MlyO2rtjoaqVN3LQ4hb2v261qm6sPA3i3ElCxBeT
         J5+OmyvnJaaOrl+79GPCaxKq2a/Q+I6mP80lmdpADRLQOwqE6JAkuYm7yLrFWvQbANRU
         hfrYZOxxk9SZYNjpkVs5F8OmDnDWKs6woYRjXqQomToXMrOlEDuRPuUCDy1a6a4rqvIK
         WACM/5fAkDnrn8Nceb6d0upq112OSEbNvTf3BhXAdCkYHdlrZOBcFYGznZHi+qUngv+P
         Kllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749016545; x=1749621345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TdPxOGC8ep3grZ2WA6OFbjncINiYIFWqbfo1FAV9lSQ=;
        b=O4pTHcqzj1qIr92JrYkhNYykmFZns/RmE8Xt+GaWXq9Wy1/jic617PfM+zmLHmnOiW
         yBS1Zr8nGmNKXDGSWj2Gx7owtVTvpmI9ggjp7ScpCGDvyzon+pN/7f2KfQP0kKnzF+S1
         1xquUSpqJf2iBHXaquUuB5HTYGVzT2ezCcr177xg8F0ps9kzmlFsdDFHbp8h1yjRewIw
         KGnBc6VUYZyQTrJibhXT0GDaGVvgXPMJRmIKp3PqVTRUvprStAI5LtTJvF+pW4mw6Biu
         WAh2FAXg4C3GboZvN74SrLL5gM5NLhMwcvd1OZNz/kd8Rd7e+CFFZWOCCpcckc4SUhcd
         RQiw==
X-Gm-Message-State: AOJu0Yyku0O/1STRFaZFJzLNSfINI4z6RsXWwE2MBN96E0lkOMVd1S67
	Vi2qqnZNRnElQHHV/FvRr9NJ/0Gwdy5mYsi+M2TUbZN0VtI+Wc0fZIXmtCPwpk2C4rCM6HphZyZ
	9gxA9RLx0krX2txPbONWym/7gNntd2MtYFu6I
X-Gm-Gg: ASbGnctpQV10RgxHdYj9YO1Oh6yst+2E41ZfKv/NnaY08A3v1UEzI7sblvfbBayPZVh
	LkZvIHPLCKBlyJaxsJ55VzGWKlQ6rR8ibpA59nWV2JI4PYI/6bk3sryiUZKJdPxOY645AAvgqEK
	d0uCWFzIM8fhJeZPM8Fki5lFGvqaVtkUxZjsE9XmS4Vg==
X-Google-Smtp-Source: AGHT+IG+zgV+ML+ztNa61HszmCLTW1OFK0g1FVrie2jpD4APnjwSEy7VClBz8eWLQnT2Y6AkbUG0qE8l5WKo6hUiYGY=
X-Received: by 2002:a05:6402:35d0:b0:601:fcc7:4520 with SMTP id
 4fb4d7f45d1cf-606e944f274mr1472546a12.4.1749016544493; Tue, 03 Jun 2025
 22:55:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603150736.134709-1-ematsumiya@suse.de>
In-Reply-To: <20250603150736.134709-1-ematsumiya@suse.de>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 4 Jun 2025 11:25:33 +0530
X-Gm-Features: AX0GCFsaET86kjUGo-gW0V0gx4tbQAI2TqWkwZTIresxMlQ_-itqdFuy-cclpIo
Message-ID: <CANT5p=oO0xsW7weZm=tXPTbvK1RCDDycQG=fQHtLa3DV=U2jog@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] mount.cifs: retry mount on -EINPROGRESS
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 3, 2025 at 8:38=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> cifs.ko mount might return -EINPROGRESS even for blocking sockets.
>
> This patch makes mount.cifs retry mount when DNS resolution
> returns >1 IP addresses for a server and such error occurs.
>
> It's ok to retry because cifs.ko will consider it a hard error and abort
> the mount anyway, so there's no risk of duplicate mounts.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  mount.cifs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 6edd96eb222a..192391360bca 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -2373,6 +2373,7 @@ mount_retry:
>                 switch (errno) {
>                 case ECONNREFUSED:
>                 case EHOSTUNREACH:
> +               case EINPROGRESS:
>                         if (currentaddress) {
>                                 fprintf(stderr, "mount error(%d): could n=
ot connect to %s",
>                                         errno, currentaddress);
> --
> 2.49.0
>
>

Looks good to me.

--=20
Regards,
Shyam
