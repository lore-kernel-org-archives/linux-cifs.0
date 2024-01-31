Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD122134F
	for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726807; cv=none; b=Ru1Lv18FlJ02gp/KPxYcE/HnHpGZ5DaQvtTi5ov0gWvakfUTq/aYwsb+wo0L72lfbY9+me2PHCnltEFjiZenoLuuobPMFns8S40dnXaZ8jrcupH3BwcBINTv4mPUZyeQFAFOACFDdk4nBhetMOQLmiCs2EsGTY98ZbWI7EuI7w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726807; c=relaxed/simple;
	bh=AZv2Lb5jovdsTBtDNuZSBrXMQpXu/M73zfFem6LfC8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=s9r4RRcUXpdZ+ZD0s2kidSd2YqnFCAldLDeRNeGE9GEGeL44F69O6O0WGN32w92sRJo9YKdi2Qs8dczIMkm8Erllc3kW73toeC2IOR63wpOHy2A3VQwWlHieBiXHaoQermlAOHYPjJ80hlHuFsmUa3OE+8oxQGY7p09jPb0Xe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mG53SePG; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mG53SePG"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cf33b909e8so11823961fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 10:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726803; x=1707331603; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZv2Lb5jovdsTBtDNuZSBrXMQpXu/M73zfFem6LfC8s=;
        b=mG53SePG0Yxm5ayCLR/Chww/bI+uqfbix3rItbFNRCEC7aYlxovfNlIL9uP4T41sbC
         JUCoqvDdUsQgnMUSzcbQ16Gg4blKM/NGa6Y8T+R0KfpXQWOvWyrD63xtdms6JxNi3X+g
         nOIeBrX+vgvlrtV8K057J/qDBiZF59Wi5WmuSvoAJS5T05R/9g19IqnqC5rWsMz4IVGe
         Hs7zeO8PVpyCSXq9Awgj7FcBFi7aFa+IPYGQINEHu4QiEgJgVRydSElU56C7tp0zNonF
         ddW/cz0/TUB9towCRW7sJ//LaVq0HYIXPDARDaedutJq1PPxPGFvnIGPi1E830qnVxGu
         2S1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726803; x=1707331603;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZv2Lb5jovdsTBtDNuZSBrXMQpXu/M73zfFem6LfC8s=;
        b=GuMwQRatGUy5p0KxmG74CdzG8KXdcVPAM3WwCBv3JJ9rw8HPcXwfFvy6ml9hCZWRcA
         BYuXqrT34LhOczQmTtRxU7Dr+/3BkWPU2/k/e1HGo9HQ7lraKWGmlfsCnLTPqjL3U9AT
         AlAABqMEmRqg0sEryBMLOLu5hNOdw8fcouQ4RwsW6h9wxlnP+sCfsE4i8n7NuLic14zh
         0AFVyVanKCU6mjfT4s+WE45zAKJIMQfmL1FqZjozjrO9Do/3Ekj8bA6ASOuh7uCH6C/o
         /7+YjUh1gDdC2gt8uKlyTg714dWJwk2l7BEioEw6d/id5X9WXQq/dZRn8Bavl8i2Cngh
         Dgzg==
X-Gm-Message-State: AOJu0YxrGvX6XWGfOh+Iqy0ymreLEHP2DgDsYyndHidDP9+sQiGdihHs
	bUFks0Adza85w4fBCXCgRm4vDoYNpjwltTt/tuxlfifX0xheFbP/kaGT6nPRIVRyzDHPVUb2GYV
	0JJdODvK4Hbfj5MiXWLJk8H1b/DmEpG4V
X-Google-Smtp-Source: AGHT+IFkV1Xw+BBKYIr1HD49YOCW3XpEB1dBpEt6p0dy+Ncg6uUNYZ01J64Kg+x0p6QLVfznwOE3d98lrGKBwHx2KPg=
X-Received: by 2002:a19:6404:0:b0:510:1798:788e with SMTP id
 y4-20020a196404000000b005101798788emr43860lfb.32.1706726802833; Wed, 31 Jan
 2024 10:46:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHgtwXSTxL=bj7u2rSvOgoEuWtq0eMtSUacy88GV3N8+LT7dJA@mail.gmail.com>
In-Reply-To: <CAHgtwXSTxL=bj7u2rSvOgoEuWtq0eMtSUacy88GV3N8+LT7dJA@mail.gmail.com>
From: Tashrif <tashrifbillah@gmail.com>
Date: Wed, 31 Jan 2024 13:46:31 -0500
Message-ID: <CAHgtwXT5S-w8iFPbO7GfDJthjeRh39vvpOc3hqRS8Uzt=8XFFg@mail.gmail.com>
Subject: Re: multiuser mount not working in CentOS 9
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The issue happened between CentOS 6 server and 9 client. Once I moved
to a CentOS 7 or 9 server, it did not happen anymore for the 9 client.
So I suppose kernel of CentOS 6 cannot recognize 9's ntlmssp method.

Best,
Tashrif

On Wed, Jan 24, 2024 at 12:17=E2=80=AFPM Tashrif <tashrifbillah@gmail.com> =
wrote:
>
> As root, this works fine:
>
> $ mount -t cifs -o
> credentials=3D/etc/creds,vers=3D1.0,multiuser,sec=3Dntlmss
> //example.host.org/pnl /data/pnl/
> $ ls /data/pnl/
> (all files are listed)
>
> But as unprivileged user abc, this does not work:
>
> $ cifscreds add -u abc example.host.org
> $ ls /data/pnl/
> ls: cannot access '/data/pnl/': Permission denied
>
> =3D=3D=3D
>
> In /var/log/messages, I get the unhelpful error log:
>
> CIFS: Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
> CIFS: VFS: \\erisonefs.partners.org Send error in SessSetup =3D -13
>
> =3D=3D=3D
>
> Observations contradictory to the above:
>
> (1) The above multiuser mount worked fine in CentOS 7. The problem is
> happening after upgrade to CentOS 9 Stream.
>
> (2) Direct mount as abc works fine:
>
> mount -t cifs -o user=3Dabc,vers=3D1.0 //example.host.org/pnl /data/pnl/
> ls /data/pnl/
> (all files are listed)
>
> =3D=3D=3D
>
> Can I get some help?
> Thanks,
> Tashrif
