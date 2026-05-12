Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A367357CEC
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592191; cv=pass; b=NKoE2PUAbAqZkZNqvv0TSU3OP+jhCsYPdJvquRfQi4I0RvVnfw9sRTjNnUmJQrbKTWvDERCzGZC1qHOYpSMsXBZhN85MC4CGwshPPmbur/5yq3UbDZ7vWR2pAIvoTtFhAVGMSMOQaxV05ZirjOd3C1YC2pZUQs1UHpw90cGcgcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592191; c=relaxed/simple;
	bh=oLNne5cobDJZx5zkoUSLGFP9qe8rytYx2dxIodND2sk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2BX61ZV9SjeJqmiI67SSAvxL2gy74Gelahiszpeyyi2G7pdc9zUh/BV6mV67OmjyNjK88E30iCWdAAtDJUl//Tcu8mA2iZQaemRJOk2jQ0gb8ggOHq3+K1BZMctAEKEGNVR0CnRbt+3ZsU4G3MEWgAdezDpD8WYw3NLS3wluyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7lItS+f; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7lItS+f"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-651c36a7ee9so886997d50.0
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 06:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778592189; cv=none;
        d=google.com; s=arc-20240605;
        b=MN++ctoGNGdhTMWZtqckhPNHPwJpBWNIfUmYd3g+QqnUdryS8/ulTbVLqJKVQGflen
         fcGEzXwBOjm4vYk17biuctX2mVSGkE83aQv/5RLUdaaAO+lfw51mdAZqmVBrDwJsv6J8
         t4BmY7VFK/ZZhs93oTldzVT1VFMBgOadR0EUs2WAoK9q+RT2guluJ8ilArExFDTgf16y
         Mhg5NP+sdVC56Iq9eJbM+fC3sCXWsyZHm0MDRgPwRY3nUVwmOlbaJMSXNed9PFTzDe+G
         qLWwHRl8R//lRZarWfmb6m/Kaq2gspAO4UNIw+B9HjPlkgXz6rdJKwtKE8YZZqUkQhcO
         ocGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QJPBnYs94tK7QkuXGsl4iBCO8CLdE5ARLqd4Db6XIiI=;
        fh=DZoB3aw9Z4lHFUc6zpWx+WgFzSOOawKy87LV4hF6ZAM=;
        b=BzUGcx9VsUjyoH8nLZL6qezCH6E5uB/mQHsWZZvTFO208uCzBkSqH/qARo6tA1lW10
         /rwd/iwhyOljhZfHbXnuE27yPkuLbRKyeUfuD1IgcIdAG5IMokEaYGRYqDr1lskHOaHp
         D7lcuCpmpt4FLLPWX7Cg/sK5lbsBrOc2ZIdX3KjG9VBZ0QFsWDEd/7YKs4GaCImYCSwO
         Hy5reVqCcQv02Rjipw65aKHtRzOGlgjpjGMm2MQkAtyKRzlxdoajzY4BZDP/rmwsAX2k
         Xo5w1FFE7ZKmELpfuB+u3DoCUjqy0dMK+Xo5KwSzKg05qc8rwL8NoPZJk8cV0GQb8lOP
         QpVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778592189; x=1779196989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJPBnYs94tK7QkuXGsl4iBCO8CLdE5ARLqd4Db6XIiI=;
        b=N7lItS+f7DWAjNLR2qC5vPqEH5cDwbCGT9nyrQOWTH1ixmkV4xQTwLkaY9wyx95xSH
         G2PlcAa8SGed6AWdVjLSVFUXhDiGBD0W3L1LQ2GwjBXrqYAslVI0bxXOanaCZhQKId/J
         sunNNGoOT3iMg8LJ5DhnZALN3hoY2hQH49KP1pILl1WBWCyYRbFojajJSy/tVPyi5kzX
         faaypv7neCLq73Ve05Y9HC/Zpjcrj2zuC17ExODCQpcNt3zvcajqHQ7kFPNudDuZBcVf
         Fp+Nb7x0Or8CYCJF93b3QE6+v8U50bv41GznUrm/H2FPrnIY+1pXDYFdmd+EQdxQ25RG
         zjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778592189; x=1779196989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QJPBnYs94tK7QkuXGsl4iBCO8CLdE5ARLqd4Db6XIiI=;
        b=sI1nwJXnvgHtuRlgMcPxArBdErwje7oW6SaxGyqr8IePnUodp98fQ3wamXJS58Q6/8
         i7kiNBCAVWdgEyzXJAKo4ibRNoKl3l4KIcmf5BsewwmlDz5qH6FAArF8WNHuGyjE5lLa
         P12cIttgDfGzyTIm8LIdceZIqBrl5FPpewbzSb7lu164IfZoJkIkb7XHamXhR2uWTbJI
         kdpZizQBR2eUuLVOxUjS2YqKA0Jzlel1I5ZlmyLmfZUd3AEnO+6JTtu5c6IGgK32FsHK
         z4I0RPIwCGlkQne58eklEPEjYTsDa0yAqvFWepoT8fIq+ARYXep5a+MEDy1zxmEL6C24
         gKaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4hHi56ar/a3P6OK5uIqAbZu4psp9PfmfAJEcORrq8TobiE2ND/HjJYFNijHAqnZ0b5jSrRf4q7Q95@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1Ksyf5mohnaKM57BD/b2fkO6nisO+99F6Y3J+6S/PkxFQda7G
	1Zo0FUGcCHSB6OEb9dD702JyqYlHYRh6HsqbSgImR3zSW4NopPYjw6Xj5/Gvxu3BERK647QIn8Q
	bQjDQF66nqU1BpOuqMW0DwBbS932opc8=
X-Gm-Gg: Acq92OGxWHjsq5rUIWVYzmiW4iqmtA4Rq8Ilmm3l0nUUD1o3btLbG4aKplMMYbCMOZ/
	GdcaGF3a6QIb5EOWzdQx1XwEOM0KxWxSZAelLH35S8Cr2sdHQEG3YDE1SA3t6S67mY01Eilbe2a
	LRFjo+5ydVIFSjrH83PCiTpNfQMS9FUukqo/pP5LhPJurwsdxRlVP8sGFWaM2Zcrx2JMeDIIB3a
	x73tQj/0TBA36ytnoD6OycM6zL679vjzSrf7/OGX829MnpNdWnxjGgA+q4kTU0CFj6Vbp3PDMvp
	CUDHX+EO
X-Received: by 2002:a05:690e:128f:b0:65c:124e:61ce with SMTP id
 956f58d0204a3-65c796f49e5mr19234437d50.0.1778592189338; Tue, 12 May 2026
 06:23:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512123404.719402-1-dhowells@redhat.com> <20260512123404.719402-9-dhowells@redhat.com>
 <CAMrLSE5jFZwmUrx5GWhz4AD9QpLsF9VsdaMJxiDa6ukXqH8RPg@mail.gmail.com>
In-Reply-To: <CAMrLSE5jFZwmUrx5GWhz4AD9QpLsF9VsdaMJxiDa6ukXqH8RPg@mail.gmail.com>
From: CharSyam <charsyam@gmail.com>
Date: Tue, 12 May 2026 22:22:58 +0900
X-Gm-Features: AVHnY4JVdrnalD3VcY2gJzGM9eUXbqquyOoAkwfHaKwpTwhqh9XLF19h2Tihueg
Message-ID: <CAMrLSE6Ff-_Kuyk44U1kbe6gjaeLuXanXUoBA5As69EYhZzw0g@mail.gmail.com>
Subject: Re: [PATCH v6 08/24] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, David.

Sorry for the confusion. I was looking at the current mainline code,
but after checking
the version with commit 8ef352bc015d, I agree that `ret` needs to be
initialized to 0.

Looks good to me.

Thanks.
DaeMyung

2026=EB=85=84 5=EC=9B=94 12=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 10:07, =
CharSyam <charsyam@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hi, David.
>
> It looks like ret does not need to be initialized to 0, because it is
> only used after being assigned the
> return value of iov_iter_extract_pages(). In the zero-length case, the
> loop is skipped and ret is not used at all.
> What do you think?
>
> Thanks
> DaeMyung
>
> 2026=EB=85=84 5=EC=9B=94 12=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 9:43,=
 David Howells <dhowells@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > In netfs_extract_user_iter(), if it's given a zero-length iterator, it =
will
> > fall through the loop without setting ret, and so the error handling
> > behaviour will be undefined, depending on whether ret happens to be
> > negative.  The value of ret then propagates back up the callstack.
> >
> > Fix this by presetting ret to 0.
> >
> > Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC =
into a BVEC iterator")
> > Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowell=
s%40redhat.com
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Paulo Alcantara <pc@manguebit.org>
> > cc: Matthew Wilcox <willy@infradead.org>
> > cc: netfs@lists.linux.dev
> > cc: linux-fsdevel@vger.kernel.org
> > ---
> >  fs/netfs/iterator.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
> > index 154a14bb2d7f..6903028b7162 100644
> > --- a/fs/netfs/iterator.c
> > +++ b/fs/netfs/iterator.c
> > @@ -43,7 +43,7 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig=
, size_t orig_len,
> >         unsigned int max_pages;
> >         unsigned int npages =3D 0;
> >         unsigned int i;
> > -       ssize_t ret;
> > +       ssize_t ret =3D 0;
> >         size_t count =3D orig_len, offset, len;
> >         size_t bv_size, pg_size;
> >
> >
> >
