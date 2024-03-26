Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1D03217
	for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711415945; cv=none; b=akWC+xFMYCF4frVDoOEkrtEEc7awrOnYxBDMR2U138y6oKCcsUnAsL1vhsmNqfWij/M3zoDMv4sOlSPKUFDmifY9Xbe9J2xQ7gdSVAwP+NW7a6MR5r3ZZaHxf/FDXJv95RzaWrqy9PO0n//+b+8THCfP6NF+XaNmKsMbZrBPKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711415945; c=relaxed/simple;
	bh=RJqZWwsapDHXC1Vom3nNou/Swnk/dTv8/zxI2PkdVrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MdQX/3mG4WMHAWbzV8R51q89/Pe6blRqVeb/yyZIBCL+NlnpVrdaJDNfeEWzD45cS1gDUrsQa172GlHqhdlVwgIaE6EaBpct3pFAxyIYmI+uxZecPI27tno+mNm1oYyXza5PtGHz9D2PL5MYTO3DOpKlor7pKb1ObtEHrU/23OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izfvtk75; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izfvtk75"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a46ba938de0so669147666b.3
        for <linux-cifs@vger.kernel.org>; Mon, 25 Mar 2024 18:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711415941; x=1712020741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nK41PCszesUC54WGtHBM6CmKBZyvyxvO+O1eGz7u44s=;
        b=izfvtk75J4XCG6FbkXuVP/4ZTxdpEPz196wJGDvu7QeTbQG0bENsR5yFeX/25OcDGk
         i6eIjNU2dXfatQDrx1E43DtBrYnVAnlxsUN7x4xN7A/BByzq2T0WfzLS2WPhdSncMebu
         wfna7YsJ8klIQCwafXufLF++US9+l0WKq6IiYTXM9PyxkVPKvWmQoAhkpUpozcsVBqo7
         KI+DwmrirMigPkRgBYtVZey2OlpxD5KT0ndnbUMayJ+x/gS5mCjgd2ajqe72C1MYjy75
         mde2c+lvgGjr+ba+PUK/vPFK7rDcKw2e2FqLwE+pe0bAKgkS2nB4uByY8IuA8LAaKn7H
         yoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711415941; x=1712020741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nK41PCszesUC54WGtHBM6CmKBZyvyxvO+O1eGz7u44s=;
        b=S5ZVWR7Gc9/3zBa9uLWbXbVAiBTmlUvXN6rc9bWDuWoZH6ytelDxWWxKjAOf3+C0qe
         jCtHuunvrU3cDND2o42XoCfNdqO/sOXp/VYrdEwGBC5am+eyy6ujWSZsdczIymVLQnxw
         G6jnVLPJ6rlTdalEY9yaopToYpN/i0uoszx59KvuvSV5dt/+kIuEhn+cD3X4OFoA9MkT
         RvMAJhQehK9VUYdETSBP+RPB/FVCQ1+NKrYGyGeqNdJvDHkWkfmZu4Xa0EO3SmrW05Tg
         7idKvlsd/enpjq4ivXjNOkEpjm5ckUaEE1Y1lBvluI1zvEEs08/V5gd3YjXgmc8DC/em
         zUsw==
X-Gm-Message-State: AOJu0YzUtw/dR8qp3yTg6lyP1bKvLPrNB0T/Ec3fJeOhu8syHSQGuz9K
	H3ayQh4K9XgOzZJ1x7bM1mW9R7Odpr4SWl78zf56lk8YXi/JYV8PsNaOXMtX8hdqYiNAZjbNjzx
	xRRosTbUVugkYE7kPrf7KsJc2fWH59Mo=
X-Google-Smtp-Source: AGHT+IE9EST0WPWPakGDpg0FT8DROWO7mYwdefcPdoIJ0J+734RTOyUq92vOZibfQZb/cJ+LDFNUYl71Qa6D9HDrpkA=
X-Received: by 2002:a17:906:5910:b0:a4d:f0c3:a9e9 with SMTP id
 h16-20020a170906591000b00a4df0c3a9e9mr441952ejq.28.1711415941323; Mon, 25 Mar
 2024 18:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220603203459.21422-1-danielrparks@ti.com>
In-Reply-To: <20220603203459.21422-1-danielrparks@ti.com>
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Mon, 25 Mar 2024 18:18:49 -0700
Message-ID: <CAKywueTOwZDtArbHFddkTdUROgVGd-Q9EP9pBuFKSQYXPdBf5A@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: Make automake treat /sbin as exec, not data
To: Daniel Parks <danielrparks@ti.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into the next branch. Sorry, I somehow missed this patch before.
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 5 =D0=B8=D1=8E=D0=BD. 2022=E2=80=AF=D0=B3. =D0=B2 22:05, Dani=
el Parks <danielrparks@ti.com>:
>
> Otherwise, $(DESTDIR)/sbin doesn't get created until install-data on a
> -j1 build and install-exec-hook can fail because it might not exist.
>
> Steps to reproduce this bug:
> $ autoreconf -i
> $ ./configure
> $ mkdir image
> $ make DESTDIR=3Dimage install -j1
>
> Signed-off-by: Daniel Parks <danielrparks@ti.com>
> ---
>  Makefile.am | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 84dd119..b1444f6 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,8 +1,8 @@
>  AM_CFLAGS =3D -Wall -Wextra -D_FORTIFY_SOURCE=3D2 $(PIE_CFLAGS) $(RELRO_=
CFLAGS)
>  ACLOCAL_AMFLAGS =3D -I aclocal
>
> -root_sbindir =3D $(ROOTSBINDIR)
> -root_sbin_PROGRAMS =3D mount.cifs
> +root_exec_sbindir =3D $(ROOTSBINDIR)
> +root_exec_sbin_PROGRAMS =3D mount.cifs
>  mount_cifs_SOURCES =3D mount.cifs.c mtab.c resolve_host.c util.c
>  mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
>  include_HEADERS =3D cifsidmap.h
> --
> 2.17.1
>
