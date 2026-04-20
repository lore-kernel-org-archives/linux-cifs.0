Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB12B2E7F39
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720696; cv=pass; b=PJ+Q7tTMhpbtRyk0jOrWOCmZA281YBDBExC7Qp7OeZykjqKZfz9yjd9lYKOi+MBv24uHjAB9oZ5LRnTOl/sfLqdgNkFbWX73qHq6+62JZ3VQUk9uJM79DEdXGOg5vNC36RRbQo2z5+q85nIsiSyyly5QdM2jtnSg5zyrYHFgrCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720696; c=relaxed/simple;
	bh=DjOhWF9JW3nbtm8x+voCE/d1HS1JNVtNmrGnKTlDU3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7xAIbB3/M1Z14xtBqr7xm6vnOFqM48ofuroL/HAiT52N04+Ax3mlqJdt5mPKsicjp2HUx/FRWa/TMBvt8wjB19L7olhmZ5FkgwlptIuULK1e08aaWU73i7i6UuCWnf98qnaksur5H1UaWkQzhnu+Nz4McsuM3Et977cN3oWQm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcJYXi6r; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcJYXi6r"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a032383008so36814276d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 14:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776720694; cv=none;
        d=google.com; s=arc-20240605;
        b=QhRILBup00Dg4tc5l+L+nxNXa5tYo2NDZFiBHBgPNSPNsQR+CMz3ZAl6jOZ2YX4645
         8Lf29l+6ng63753LAnTtM5f9qfEKylpmgY9rT6S6YYvN5XQv+7MjGwQ1MOZlWhOqHAWP
         Ty3jvVRCbDJeuJewvsNUsDKni3H82/VJWl0F8szjs472Ft4/oRybNPc2TYiEzoP1TrbR
         EzTlaECnJcOodivB5zO5rwb54nRosRO4S3pxzVmEug+LDTmLBNjNdJnaMbX88yLCCOh+
         UzbbXIuLlL17pQ68dPEAUjZSkDy/IuOmrawxuLcdlW4QYA2Hm/qOx57GrMSko1E6lHsC
         mHqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yc0EIbC29LTRCqJQzwYJBjbv+jR1/9oVQPTdUyHcK1I=;
        fh=vaBfeicUzafSj2wtRaHErwhpXZD14LRDnv8RJmanKdg=;
        b=EttOpcDft7xyJ5Zqhu2y/fMh8i51T4u/PcVoO9zTWSp3gXTrXPbGjEEDW4aE9LzvsV
         5yY9GEdJsrwkXe7uEUJogEqJf1ZOjt2NAB0aWjm6qlW7B52yi84PfTlk+zYLRpLAEVlL
         kQOuxvdGsMxsdXzR8sQokRuxmx7PFsUmEkyFcRd66pcBawX4exJekZMWiOKLiFhHLXZf
         Un5zZqDDxO7EiuHj58kgvQyk+wAvoOmq8RGlZhfhkAcuQWQQQ2viw6ih0d9KUVC7CyaE
         621UD4Q+FErSuXvQ3cX3i/Vb2dWEK5hViUXt2CnODV6VkcYCjblFCgnpeVWWZ/HiUmpL
         E+rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776720694; x=1777325494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yc0EIbC29LTRCqJQzwYJBjbv+jR1/9oVQPTdUyHcK1I=;
        b=bcJYXi6rcmX5/0Fh6TbT8vYIgn3ozsS+8xCa+8EZaFHESHAecDNVgG1Z1Ddl/zB396
         ANPUFBeKo6TJDBOdgkSqM55zByE7919lc7N+R5vRrA3ZbAxwiWFYahyJaiMTzLXwZpYg
         HBBjPxZCiFlN/9jchFEwlWIeWir9J42CdotIm2KejdxSHBvCKC8ujwyNmW9x5dkjak2X
         Td0zNEPOCIq3ua60PvUNLlBPD5STgAh+uhfSCJubjAEjEVmb4GM8BNFOi5EEEBnzOyhr
         tpItCJothPNlvKo6/y9NLTcnno4oWkx52nIspdXNN78W2vEgSH20Pa0UOseOib5ERMXn
         0ejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720694; x=1777325494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yc0EIbC29LTRCqJQzwYJBjbv+jR1/9oVQPTdUyHcK1I=;
        b=c9hvriDBL+V5mix8r3kfYyjhvcfWkRZypOKoSTHDgEbLnX+GQh7baf9FHdn1MzJe0O
         QsPLCm08EMTYzPNSyp3wOSN0htH75jqaWBMw8i/vPjrFYimHi6jU23bkG6X5w84Bk3qL
         Vf/VtCi8a0cq22puMCkxuhs7wB1fMNDFT2CdIHJYTReD2/UcDyozqcCD7AO4SeLq27P+
         4yJGbWDW81Z3ydOyV9znXxNe25MHg4l3JxDbOVIC30kxOqMbBgfjKX5sPplGwAOM6CKC
         VlukYuKCAGX6+ffnaAZF9oh2RcAoQLFXPs2YTlv3dNig+0g8lvc3crTJSbRtdO9ypLPe
         PB2A==
X-Forwarded-Encrypted: i=1; AFNElJ+1EVFlVLfFHafBD2ONtlswm9qDOcadKGIJikg702c4p5NuFluQtJMcveCNR3sgyTCtMj2lufJ9WoE5@vger.kernel.org
X-Gm-Message-State: AOJu0YxjVA3eWAQ0n2B7SELLGLATFiW7ecmjUhuUFJT0AMkRAdkFs3JO
	TlBqLorBHTuaVHz/69SqXhUp6+YkTVu4xQ/4N5MdDRO45/Gm97IKdobnlYSguazb6Sz5PWm4n9m
	tP1KvTieVrzj7zyf3MNYIFRRQhHocr0k=
X-Gm-Gg: AeBDiesPWMOIsPYOQdUWG3tUj21zU3znhExoDG6Y2Ev5MjrM8LJ5mscRHKk2RNFaAgi
	v7JgGcZtLMJ2RhOXiYyOkjJNQ2GSzVzr4OLHaDXa75L4Qwny145YreWevCHUVGXrZGgHfFw6OPw
	bT67fmDwwvIUePVR3cVzR//3uCaxFRhk1AidYLBuafMoB+RZbKYGxoN/cQQu7zR2CWc4GEKN3D+
	5Yl2sdaGI+K9gJyRo635Me+2o8qO+VMxsdnm7oGwfNwcfI/owjBPc1SZ54sKU8iq72CF15JvXQA
	2ikRoslgJJ2tTC0N+4iS0ELM7KM4LOnvo0Rf7Rk4VhwlLo+3zBtSDdcZ8+G8Hwe3BT1H1p769ki
	6GfLZbrrvN/Sp/L1AyQUCQ8ihukSpFZlyCmkNR2YLQ3wsZnsKycWnGzhnj1WIfy//Wz6RkK7IfS
	wX
X-Received: by 2002:a05:6214:4787:b0:899:fd8c:55c3 with SMTP id
 6a1803df08f44-8b028084c84mr227144626d6.22.1776720693872; Mon, 20 Apr 2026
 14:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413190713.283939-1-ematsumiya@suse.de> <20260413190713.283939-7-ematsumiya@suse.de>
 <20260420212411.GA2260299@ax162>
In-Reply-To: <20260420212411.GA2260299@ax162>
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Apr 2026 16:31:22 -0500
X-Gm-Features: AQROBzDPVbyjRmAUUYNogTWfIG1LTgv4Hd8YQ_zgLoVtgXYWmXMe4Oyxg9qIKa0
Message-ID: <CAH2r5mtsATtgdZHV1924K=_mc3+XVTW_6FMQ+FxtKeX0F1O9Ng@mail.gmail.com>
Subject: Re: [PATCH 7/8] smb: client: compress: add compress/common.h
To: Nathan Chancellor <nathan@kernel.org>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 4:24=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Hi Enzo,
>
> On Mon, Apr 13, 2026 at 04:07:12PM -0300, Enzo Matsumiya wrote:
> > Add compress/common.h to aggregate helpers and definitions that will be
> > shared with other compression algorithms.
> >
> > Also add a few build time checks for proper support.
> >
> > Changes:
> > - update affected call paths in compress/lz77.c
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> ...
> > diff --git a/fs/smb/client/compress/common.h b/fs/smb/client/compress/c=
ommon.h
> > new file mode 100644
> > index 000000000000..b5ccf5debd22
> > --- /dev/null
> > +++ b/fs/smb/client/compress/common.h
> ...
> > +/*
> > + * Build time checks/asserts.
> > + * These are assumptions/expectations for all algorithms implemented.
> > + */
> > +#ifndef __LITTLE_ENDIAN /* TODO */
> > +# error "SMB3 compression is only supported on little endian architect=
ures"
> > +#endif /* !__LITTLE_ENDIAN */
> > +
> > +#if BITS_PER_LONG < 64 /* TODO */
> > +# error "SMB3 compression is only supported on 64-bit architectures"
> > +#endif /* BITS_PER_LONG < 64 */
> > +
> > +/* Build time double checks (probably unnecessary) */
> > +static_assert(sizeof(u16) =3D=3D 2);
> > +static_assert(sizeof(u32) =3D=3D 4);
> > +static_assert(sizeof(u64) =3D=3D 8);
> > +static_assert(sizeof(size_t) =3D=3D 8);
>
> Steve pushed this change into -next as commit 20a248d5e77a ("smb:
> client: compress: add compress/common.h"), where it breaks the build for
> many 32-bit architectures for obvious reasons:
>
>   $ make -skj"$(nproc)" ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabi- mrp=
roper allmodconfig fs/smb/
>   In file included from fs/smb/client/compress/lz77.c:14:
>   fs/smb/client/compress/common.h:34:3: error: #error "SMB3 compression i=
s only supported on 64-bit architectures"
>      34 | # error "SMB3 compression is only supported on 64-bit architect=
ures"
>         |   ^~~~~
>   In file included from include/linux/init.h:5,
>                    from include/linux/printk.h:6,
>                    from include/asm-generic/bug.h:31,
>                    from arch/arm/include/asm/bug.h:60,
>                    from include/linux/bug.h:5,
>                    from include/linux/slab.h:15,
>                    from fs/smb/client/compress/lz77.c:9:
>   include/linux/build_bug.h:80:41: error: static assertion failed: "sizeo=
f(size_t) =3D=3D 8"
>      80 | #define __static_assert(expr, msg, ...) _Static_assert(expr, ms=
g)
>         |                                         ^~~~~~~~~~~~~~
>   include/linux/build_bug.h:79:34: note: in expansion of macro '__static_=
assert'
>      79 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_A=
RGS__, #expr)
>         |                                  ^~~~~~~~~~~~~~~
>   fs/smb/client/compress/common.h:41:1: note: in expansion of macro 'stat=
ic_assert'
>      41 | static_assert(sizeof(size_t) =3D=3D 8);
>         | ^~~~~~~~~~~~~
>
> It is unacceptable for the build to break in this manner in my opinion.
> You should really use Kconfig to gate this code in a proper manner and
> not emit any errors or warnings when it is unsupported.
>

Thx for pointing this out.  I have removed the patch from cifs-2.6.git for-=
next

Let me know if you spot any additional problems


--=20
Thanks,

Steve
