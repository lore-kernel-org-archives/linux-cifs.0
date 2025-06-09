Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BC3EAC7;
	Mon,  9 Jun 2025 03:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749440436; cv=none; b=B7NLuKttVGwtHKjZPkBcldh2exUQi1ABFDK7q0gO5orDwk3Ayq/loVK3qUMrZwa02NPluuoIOAkvrZ65frM1NqR9cbUQw6ZKdccpJ/+Vr5VujMc62tB2TmFnFNu66Y5F0aVt0BOGykhm8hOsjHX0t4ymSu3s2cfOTJLQaJ2h12Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749440436; c=relaxed/simple;
	bh=qmIzR1vVjPPPWihlF8to9ihMS5vsXWmFct/AolOv1iY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GCzoydo4H+RvJPlBVNtu1Y9/eK8k2HQjW7mvfBUQSRur+rVIigiJw58Tn/k+aP4+yJEa8FFSAyd2HFcasGYleuQLPGzy4gNU/c/VUTQkNGGZSnR3ijL7+QVUs9xKrfcexjTjJ1oJyvKe/uP+AvVF617prk6bir/jnXBQ7Qi/sq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcpTsjJi; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcpTsjJi"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32a9e5b6395so35300541fa.0;
        Sun, 08 Jun 2025 20:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749440433; x=1750045233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9O/knrPcwfhPhpwiiwZC23yGcT92rhQAt8ZZa9mlKJw=;
        b=ZcpTsjJivU9x2mGvX/wS9AP2FUjjUUU+RwgttASaBoF6/NAq/CcUmkYnMJnmbyL1Q7
         xfVJcwr32sZ6ejvdlp3BLH8qX6e5aNc4BBWQ8A2MgOU2CsxcujG0Zm2m9TjgbF51ISx3
         +EffUs5limd4gp3j0zPDJlx2l05LrAltOF/GOQyx32JuIlxc+Ej5DWtHOBMgDwRtlZP+
         M4okzFKRoWEKBPXx1iricYkdpPzTQV2TE735RzUPRQ1myKJ94yPncsL9LxvgQaNGZpRc
         Si6secBuUa5HRyQoqV11EXhptQRb7EgESKfWNXqIR37CB+wgU1UQDI4JwKZL1Awp13iw
         7jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749440433; x=1750045233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O/knrPcwfhPhpwiiwZC23yGcT92rhQAt8ZZa9mlKJw=;
        b=RAdNHtot6TUsN2zMESJXcHl+xho9lXaiarju0J4P9/eR1FBdl+fmqXpHoRdjSlISZK
         2B2SmTd2H7HpWk5f+fOT214XdX14KAp/Qa+xDdm70AZmtjC7E7lpP3NidzgVxiDLfL0i
         JoB9lUD97rkpu8j+rzXPzJoR6mxK0lxqBT89nsHd3acgI9cPSuslfCkif0o9cdCGBSmS
         WlULjsRqTeORkeFTkKEqk/c3N0LpywJ2oyO/FtUQuEH6LfS2hnWElgBCyt+7y+xhtUA0
         jIPuKc9TJCuVitKiNnEx1TD052j9ZD7BbBxCz7V9iMEOLnUSOCdJlVc2CPTnKTbN4suI
         r+gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHTi90s5dLlzsJbhZYxz7vDAHAv7lolCEsd6wxpkzUsVfnz02IWsYWM445VBg0wXqJrs4yks2L4Mcy@vger.kernel.org, AJvYcCUjO9VBL4it9QwkhXic3zm380spKsLR5ZlE5oX0wFWULSfcj57cTaIacuZXOaabdm/B59WZlocHil/38aDD@vger.kernel.org
X-Gm-Message-State: AOJu0YxFg0rKcZjLAC2T/33O7yiAOVuPf+6IdUIw8l3zlr4nhR9/KCAz
	IN3BPsIl+2yt8t6rcfxUwFWFCu5Hv5rxjdFZIR7uC1nz2HqA4YadnuN7UC+3O0vwkRDq6P/u1AO
	8rpOe+yS3UuV2p+RHyAD5rgQFeAYYxkAPEg==
X-Gm-Gg: ASbGnctAhwVOKm2QUXuvPGVVo64VdmSiiY1wkOryNyvB5/hlDYuCeVXtmGUl5FFv2Sy
	DZSUrBy87QRpm1oGOxpE9Jw+UsbKY7TKh+s5oa38trzMDi9ZrW4/w7Eut8vGewRSEFzMFswXY/h
	A4OLcyh/N7LwNs6QfW7C2rUQQLT+Itmi/pemCd+2LrbuHfnWHxXuY9d1RwiJ5JS8uNHvpwS46Zu
	BBCfw==
X-Google-Smtp-Source: AGHT+IFxGrGuozL8ELjvhJ7gGFyVJOfGU3v7RSwRV5piTvwXkEESCAot1wy6mFU5KTCDMxKu6nQqs2ECrLPiJrbEwZs=
X-Received: by 2002:a05:651c:210f:b0:30b:b7c3:949a with SMTP id
 38308e7fff4ca-32adfc3f0e0mr25009011fa.18.1749440432510; Sun, 08 Jun 2025
 20:40:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250608164453.6699-1-pali@kernel.org> <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
In-Reply-To: <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 8 Jun 2025 22:40:21 -0500
X-Gm-Features: AX0GCFtKblGjCypkyDvT-1magtfAJ3mVMESYFj8nMp4m3rKgBXTbzOmSd4tia6c
Message-ID: <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
To: Paulo Alcantara <pc@manguebit.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Since this could flood logs (e.g. in some DFS cases), probably better
to do these via the usual dynamic trace points (and can document a
simple "trace-cmd -e smb3_disable_serverino" script to avoid risk of
flooding logs.    cifsFYI is an alternative but the world has moved to
the dynamic tracing (eBPF etc.)

On Sun, Jun 8, 2025 at 3:57=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Pali Roh=C3=A1r <pali@kernel.org> writes:
>
> > Before calling cifs_autodisable_serverino() function, show reason why i=
t
> > has to be called.
> >
> > This change allows to debug issues why cifs.ko decide to turn off serve=
r
> > inode number support and hence disable support for detection of hardlin=
ks.
> >
> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/smb/client/connect.c   | 2 ++
> >  fs/smb/client/dfs_cache.c | 2 ++
> >  fs/smb/client/inode.c     | 3 +++
> >  fs/smb/client/readdir.c   | 3 +++
> >  4 files changed, 10 insertions(+)
>
> NACK.
>


--=20
Thanks,

Steve
