Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB203CF031
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261327; cv=pass; b=thT+VU1tvcBMjqDm501IgdCqpXoz9b0M8/Hn4rIDATXtdK5hViE5pTgEWCOAS9utasGgr2nafy3ii5TPGZ9b5daDolxlRVxhzXpo5IxwHv/1CSGAApB7tntmA1wMk63ocLGf2z9JTT6CrNKDyedaeNbXbIAB6D7oBWTicBHjNbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261327; c=relaxed/simple;
	bh=UpT0EKObg+jQzJ6YaNvY/P94MAqyWqCigqU3uXMRPM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlrGoihfcbH/1xnlTwsfnZGOWkxlmdmutPQAqLUm1drbcXxIa7OsQ7b3LlAv1UC41WvaJC4CeYue6AhOfvzqd5qgWQ6xvesXUm2/qhxsBIilw9jUnGy3P0VMv80dI4A+qdBGfYhD0agYS3J7UuZSswrjNkn0wmG1vd5cB1vHAHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXpBwPc9; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXpBwPc9"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8aca2726f61so46198666d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 06:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776261325; cv=none;
        d=google.com; s=arc-20240605;
        b=PEN7P0Linbcwl1q3pkQKayNiodqf4ESCGLOiux/EJHt6QuOB9Wi0460YmQTOJ40Le1
         vdisU0t1D3UpRolg+3BeYIwC6g1MY1KVgkVaGFjTrgDK9eKOj7MOyeUwsClTt5NIx/te
         sPFYl5w+BKeDPJ/mZGoOAvN46Z5fnI+D6Pe4NRVtM8gXZLYTxEBFvzUNhpacS2orqDnb
         Gz+ESVu2nPOMgnuMUzCXXNX1nY9ES8kvQv+FNX2JzTjq+1FsfRPcagpKZWgbmqP/dkfY
         yV8PuZZ8d7+ahJfPn9kZ8bMrr3FjPDf3isYV9i5KGPzTfeyoA0TcClOdQG21/MBhKHJW
         wLBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2kBf89uxyRhEvxT1gNsF/PxAWS7XuFq6Zxwh4oMnGdE=;
        fh=SKa/yK3bq2qTqJLOsrUlOGc95Hv8nlIHybK2fnv6Kjs=;
        b=Cy1vCvpD+kixAUfqSWPF/WPAJ5iCAFuE33T4MU1+U2IKbO0pa7pRhGwpzKJmJXhKQX
         u/TlUyEzrfbqe8SgSlm9w0qfTVfc7GPhut4x4EOJvswGQq/CiNMaTcjmcz7Z6WJGYnk9
         WJ6HU/maYH2BdXcguVDG+4HLHmbs2keTLo3Sfg2dIAngAmCKh3jcgcN0bv/qfVK91nOq
         yER5xktG+wQRSbMFWVLSl3VcH6Z14+bYy2KnotFq758t5ukyOO9v4r1Bx0YVJaphbOv7
         39J2G9DzJ1WRCEyQtfzUGD/njKj8kmKxI+KlWpIMqRIPk9xmoCHwFS2ZEw07cTDshgqZ
         hc7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776261325; x=1776866125; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kBf89uxyRhEvxT1gNsF/PxAWS7XuFq6Zxwh4oMnGdE=;
        b=bXpBwPc9tQVk1+ls+xt2zNK7IB+HnhiY3fUnL0D48IsywtEFJ6FOrsUrmob5lX2FDv
         hKbCxWcRasqwOKt6hK0MW9b9QlMAKAjTDAqNwPnTyq13tPkbPSJnlNjGvIkSjfzjv7XX
         KlOHl+iww9jYamGzeEjS8SEkV8PvEpy5rqQBjQMp9kxMuMAU26EGhLD6U4jrt52rAwSL
         ZR4pVkT8Ng+tReunE/EaSBa52pchaZy8GliGAEgVDpNDIIJ3NGUmGS/iZkps83gIS1W0
         F4jCOiPCMF2XOeCHxYS5pH4NiK661YwDAWs17diAUcUwE0uTJWp04bwX7sAI3yCez85j
         zenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776261325; x=1776866125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2kBf89uxyRhEvxT1gNsF/PxAWS7XuFq6Zxwh4oMnGdE=;
        b=kDHFZRm+3v7tfPDGGKvZ7aUkXZrgK8pE5GD3u4B3leIBDbwGLPO9LnmT8hmDEEqiGM
         WeL2cSuvZM126LlGsVODzkzoG4P5RaLxxHUyb8a7yO4Pag6Xlli22SFT4ayk3kpbzIyq
         O8dXym+LuqyREyv3FvIbNOEANT6el2R8uO4+iQFp7EomHHz7JKDmhz5jDVP6dnyLJRam
         Kja7U3k/VChHtEST42OLv+cjCc6saqJlNpqoEB/0Kr4R7LZrmCdjGHEgpBSgs5PcT1KC
         tMTj22dam6R1IBH7ne/GAcYlhcv8obXw3odAa3e/GGtcnyxl3hhhTtrQDChfk3ZssVHm
         SQ1Q==
X-Gm-Message-State: AOJu0YyZuEoLRMvV7nefSZgbHLB0+W+EPPnz5oboXG98d2xc2DASMqMa
	GX5CZ+e+gKKb1TzAsJBultQemR1ZPpVFuBRduqi0bA8C7Fo+DqYhg0WCvpC4S/c91P3GgkgBQQb
	ZYI8bGLV2xp90A8IW7i3zlOXsBBIO9v5+ig==
X-Gm-Gg: AeBDievz6J3Xf8nuXoZSEHiGIWTiT04i+mE0/WBvC0HATjFuAi/QRT+fGzCtAu57T7N
	/qELo1HwmaOMp3+mWWjjBmMCoNjGywkz6oUdTDolQf1kZJEqMZwviewfUhVWJ1aVZrVscbz2b2G
	P+gCmDFqMkfVr6iRO6CKXp0hl0ag6i8Z4mfAJV8SO1UMhmydENovjDxQEyZs+N2fbgeCKLKNzVB
	Q3/7cXuHplJwXzbE1YopaH7PpYz+70yLWN3xQT4uPX0Yjfd1rRptxe+1Q2B3AaECH4aoXPd4G2G
	SnQT3nb6yxvOvfAehsNhs+pFfQ/616EpY2QEKLbtjLXE683vvqtLT29f0vOAfwXZUya3Vb3U7qk
	HISWgyJNBhhqZLmKk742l0fU0ByD8hJ0wa5MyNiKtJ345+8/p+RlxzANlLP6of+wpHFe1f4WqLl
	4hockzVl32FglT2qBDeWqgcMKqNMzDVNrc923HJP3dxIA=
X-Received: by 2002:a05:6214:4985:b0:89c:4c6b:4615 with SMTP id
 6a1803df08f44-8ac861547b7mr342507106d6.8.1776261325526; Wed, 15 Apr 2026
 06:55:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad9r3jEtJJNv0IiA@sirena.org.uk>
In-Reply-To: <ad9r3jEtJJNv0IiA@sirena.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Apr 2026 08:55:14 -0500
X-Gm-Features: AQROBzBmh5DpYsR-bFwQMWvK7UtMrn-Fv0VZbpniWKuH9GrnyVn-JK5N-9uHCzg
Message-ID: <CAH2r5ms+Cstvmgoqs1bcfdqZcZOfJUBTR=kRBa_1J3FqmHuLaw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
To: Mark Brown <broonie@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

removed

It was missing a prereq patch

On Wed, Apr 15, 2026 at 5:43=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
>
> Hi all,
>
> After merging the cifs tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> /tmp/next/build/fs/smb/client/smb2ops.c: In function
> 'smb2_query_dir_first': /tmp/next/build/fs/smb/client/smb2ops.c:2655:70: =
error: 'CIFS_DYNAMIC_BUFFER' undeclared (first use in this function); did y=
ou mean 'CIFS_NO_BUFFER'?
>  2655 |                 rc =3D smb2_parse_query_directory(tcon, &combined=
_iov, CIFS_DYNAMIC_BUFFER,
>       |                                                                  =
    ^~~~~~~~~~~~~~~~~~~
>       |                                                                  =
    CIFS_NO_BUFFER
>
> Caused by commit
>
>   3777ce7e53f80 (cifs: optimize readdir for small directories)
>
> which really doesn't look like it's a fix - please note that we're in
> the merge window and only fixes should be being added at this point.
>
> I have used the tree from next-20260414 instead.



--=20
Thanks,

Steve
