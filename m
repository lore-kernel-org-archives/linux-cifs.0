Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5683D1A239A
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 01:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776129772; cv=pass; b=lA+gp87uzmkQjt1wIFSl4HTIAuIkVrMPYoWKavFbLhjz+zT2+jtAlCxEszKBiSisTMWX8nAYWBKdbu48uvp1zAeoOdUqYCqvftj6qEjpvRs1XCoSh02I9ozJnnNC+mnPocgIlblKpsOE56xS5Q1E3g580Ktp92ouGVh+Swj+UOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776129772; c=relaxed/simple;
	bh=CQIsGPD0F5nasdz+E3tZ0A0oo1YwfIwrZwXTzoz9w6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+6Kw4QEG9Y7rLMnZp78oGdjn4hNcAUes5MNY+BTs9sms5l3Qf8S4BQE2e17GAEYjjZvVPOIoNJPw/A0sW3xiIb5hFGsBRgqodJJ0Z+1u6WDkcOELEmudwNci7jD/zfeG1LKvCu1G55Y+0j0Pp6U9W2DL6M/4cPHEIkHK1nQ3uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMMqKalA; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMMqKalA"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a3342d301aso51872146d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 18:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776129769; cv=none;
        d=google.com; s=arc-20240605;
        b=ktawSZ+s2RNLBch3z+iFHz58ecu0Oh4gs9Pn5xQmR1vlu16g2zG5dlZCQbwCP59kAb
         2h4Y3t4vWKkSwD79BxH0CS2W0Eq/BPrf0XM6iWWyuID/VOI/Bv4w7u/A92CyBonhEEz6
         IlRK5R6GKvmJ0Wwo/QihfGTlD3M1w4tV4bbIfwMj0sKzDJz5ssBcDdL725zcHWl7E9Sb
         ga/ODPZcTz9koFs7OAFOlkf7TxF8exLdHRDnBWhGn5Q5Mfkqjh/RGqRqlmlKxojUANN+
         F2T3Du0/eH0oH5gyauKRbFORkpEDJ2c1Jc81GbMlQDRY+Ot4dVlLfAeF8exTdcQyiBN/
         g1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GY2ZAij4OBI53HOLjtZsYU0pIOYhrrDKlFmX1b1tBFQ=;
        fh=Ukg9gSPtoM9OuhG0Hpe7njPtUQUNsyetasbRqb/aMj0=;
        b=DEYQt32bNKdjT2SPmc37WfFB05daj9aW9ti9ZlRlzZk5y0j9+t3wsajX6ZTqJVB+AM
         glT9/dZZoO8ZcPNPDKpUISMA55zLVtayDT78TBOpsA8Q2hDNbV6n9iRe100Krj2Y3gx4
         v/MBYJ3FwM3Wk6iikByb8Vbtq5FKWrMUJocaxTWhmHy/RhsWAc5J3tzshOsRoIuyi7YL
         xU/2sjPGjcKTbZtz8JFKIheGfAK+JwNmASwssNVSI2zmPa5ZjkJ6MCOhUcR+sCGaTdnx
         vSPW1L+aoBeoa4fORNrquVydLp3IV6vJ/GwOUD0DsuCOdNiS7FLLlRsAQOm7UWEJkuLA
         A8kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776129769; x=1776734569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GY2ZAij4OBI53HOLjtZsYU0pIOYhrrDKlFmX1b1tBFQ=;
        b=IMMqKalAznzj2Qwk/4Cg+x28soDlWHpYqe7jngYaUW2NkkYFNt151YoctEHd3kCYQ/
         oqksL6nW0l7CuQYp3G2miYyr5aWP/ZwGXLlxT28d5nxseuci3Rf39TqDuI8GslgqeLTt
         MmZDHKKTM8vEROiJfptDxADr5i6v6dHpj1T7OVFB2PuVk4AzVqyWZ+Si97XHw47QPQyQ
         /9ZBQjCO4FtOSk8cZrPI4ojqk9PLcQl8WcZFwQdAqjnsnyqJsPh8Ca88qmzrXR2A1Ivh
         Rubvb7sx0UO0K9o94NJiZrw/q8TrAs8VUrcCPlMZ+yN7MX/zrygOyrrpGWpvTLilKsbw
         RBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776129769; x=1776734569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GY2ZAij4OBI53HOLjtZsYU0pIOYhrrDKlFmX1b1tBFQ=;
        b=XdXnK/W37gRJSbkUJ7Zn9X5KnZXW2CfrSuNGB/9Hl54gxoLAwi7Wq2WWDNVYyM3B6v
         wSWnLeHJQvFZUtQYuG0M2uVJ296yZPwu+QXyH6Haz0l0GD0ERHiSnnK5tyTbMEMyf5/G
         7WFatpRSqyWYBfq4Y2wNmG6VuDRzu1wkl2c5n7NVSo6eEzg/FPYa20h0kCrZEBC8zOh9
         YUddGmsLUD4SWW9aZuDT8bqUHhBvuWCkgx+cVgCPnfB8wyq+OjG411Tz+B751tsV5FoZ
         fPWWl/3tX0xk0dHu22DrdKk0MZPD3N5QJmrMc4h9sKaqu5LSA4emLaFsM+LhO9rvgye/
         Z0uQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MDHt/UP976KnUFuYqcpAa5+osPkAhMgqtcs1fRGj/GsGR7qdmch++3N5YX4OWyn3ZvvwVI2dPNtom@vger.kernel.org
X-Gm-Message-State: AOJu0YxbiNozoeXvsCU0gScHu4EC1bgtaFZOAncKZ1SkbFwf8AZXUJ9i
	QhNUr2N8W+169dfLdHHUV0bEG0uzskIsT7AZJpYN4GqDDtYk0LOxvBc6Rosax/gnn8flKsYpXt9
	pFW3dpTnkR+Yjtwf0/Hz8fgA+Cx+3LrhgXw==
X-Gm-Gg: AeBDievT1W9z4VJVbjeQTtffWTJ8wPDLGP92iH3z9nHp+0zlCI4y/B/H3mIoTvfQe7X
	+A+zxJPPUQGU8j4Br59iHHkxpmLwS6G1uJdun1Rcy6vUsu+u0b9ilwlIQ8aLHWpluKsx7IGurSR
	ttNSKeQGw6CUagbqkEaF3bhAMOYWw76f1arleHDYZ/QmG05ztz7v6ttZDiqgKTzDp4eQRBQeYgK
	zglTMsbAYTmzKVOIqI6QoRNNOYcu9H+S6uYUWIZK8SQMijhaaxVfQHBKo+xoqY1rqlZ3TygItC2
	8A+hybrFW6rCLTYHUXNDawnZFf14eGy4lwW1K96mGddTyZUYYXLeCiknylQLTP6lSM81Edt/OyN
	3Wfm61x505v9PKKNFNIEbzmucYZJsFQDjWWPP+iqErp7lQFBvUz6HMlNI5PWsN/NMd8aMx8YjYI
	xledYimjHdFZN3dKVPy0l5l3z0vpo4bTE7
X-Received: by 2002:a05:6214:4b04:b0:8a7:e3fd:4d8f with SMTP id
 6a1803df08f44-8ac86156698mr286548056d6.8.1776129769328; Mon, 13 Apr 2026
 18:22:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
 <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Apr 2026 20:22:37 -0500
X-Gm-Features: AQROBzC2TPcpNf1UHJPTeZeP5jzozf8of9Bk_cIpC8Ea9PViQuJ1cccfPV0yAFU
Message-ID: <CAH2r5mv04gWxkFLztfpro=AdySb2mXv_gafawXVaSa7VO+t+vQ@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>, Paulo Alcantara <pc@manguebit.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2026 at 7:28=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 13 Apr 2026 at 15:06, Steve French <smfrench@gmail.com> wrote:
> >
> >   git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part1-smb3-cli=
ent-fixes
>
> I've pulled this, but then looking at the dcache changes I noted the
> big forest of BUG_ON() which really isn't valid. Error handling is a
> thing - BUG_ON() is *not* error handling.
>
> And then looking at verifying the length of the name - one of the
> things checked for in that forest of BUG_ON() calls - the call site is
> an unreadable mess.
>
> You have this:
>
>         size_t size =3D CIFS_TMPNAME_LEN + 1;
>
> fifty lines earlier, and then you do
>
>         d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
>
> which is not just illegible, it's also illogical. That "size" is just
> voodoo. The string is generated by
>
>                 scnprintf(name, size,
>                           CIFS_TMPNAME_PREFIX "%0*x",
>                           CIFS_TMPNAME_COUNTER_LEN,
>                           atomic_inc_return(&cifs_tmpcounter));
>
> which uses several other magic #define's, and yes, I'm sure it all
> adds up to CIFS_TMPNAME_LEN in the end, but this is basically all just
> line noise.
>
> PLEASE write this legibly instead, and make that new dentry helper
> actually do error handling, not BUG_ON().
>
> Because this kind of mess is simply not acceptable.
>
> I don't even understand why you use a variable for an insane constant.
> The code *could* have done something like this:
>
>         namelen =3D scnprintf(name, size,
>                           CIFS_TMPNAME_PREFIX "%0*x",
>                           CIFS_TMPNAME_COUNTER_LEN,
>                           atomic_inc_return(&cifs_tmpcounter));
>
> and it would all have actually made sense. But stating the final size
> like that really doesn't - not without at least a big comment on how
> those random things are interrelated.
>
> So this is in my tree now, but I expect it to be cleaned up and made sens=
ible.

Will do or will have Paulo do.

--=20
Thanks,

Steve
