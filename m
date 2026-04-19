Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417F13D503
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 01:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776562542; cv=pass; b=PNvx3ounD+v8D3AtXS7yApao0VUKPVsuyLELuB/uTZqSBYlKL6iweI6c5qUBGLEMktd1P+U9DC+I8uDnTwQ/MWHm4aFulzLvh6FSmN0+VerRiAWvejuEzcCskkJrNGfMUM3GdENNe1gzqcfWM65UnJCDRt6ILgyntjDVpR4NXc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776562542; c=relaxed/simple;
	bh=lcvIlPsdDcCuLZWc5L72DnCt7HcsGssFjaoId6Fn1Kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWTn5VN7GFRnFLrsuZeJHQo0DN/kzPySESDRoMDdkLBR0DcIuSm3hHmd0A9y12hQCBV+CElR3zSXbAb5mcYom3M3ZdReWFyz7cQfOgh8DeDdg1NW++vEyshaPGaYWOKD6w/d8AunpGPuN6n4dRNBiWkUx24cS4UffiX4Et1qkRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ElNK8775; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ElNK8775"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so29996586d6.2
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 18:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776562540; cv=none;
        d=google.com; s=arc-20240605;
        b=R+Fi0eybBCh/OJAgcd2dPRWBoiiAPacW1Jp3cTRvJYl7q3e6pYvU8e8iFjzUYmsBA1
         GgBnw0saUAJ1UBTJAxAu5duZxxYwQ6ofFHYPVnfuk0j6h1ThXVZi6ehUK+YsBZWeM8+P
         ztBw15iHdqTlfHUhgmCrFyLJ8c6I+U+ixOJZrJWXjsK7qFDmp8WIrQyotUF6q9OEW702
         2/Le+0oy1T3IB5piBMwSigNoGB9ZLJJZLwzuurd6HaR2TqQd4sf5DaucICcGUApVf42E
         FgUhHQbWRIOGaVmQNer8rU2/RO1T7t+IhX8jUoXIGp4MnPcYRCJV9A5KitaCf+Ymy6Hd
         5pFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JzFn1DdpqAIgX9exE4IN6lU5puwoTwb7tv/UGHT/WFw=;
        fh=ifo8ct5CYa+Yz0DKbCP++JDsJFnUFyyZGythcxLZy8g=;
        b=P5VdgolgaYRRqxNw2QIG0oygQnwtbv/t0rNeW4wuGR4fom0pDMFkGdC3hyPBWEKyqY
         9w2wUcNxSLhlvShRETjaTy9+yUzl0DOUskMZySJNCxufmqtxq/bk18WuAYls9FDOW59l
         Jh+L82V91HfBp+xBFcSJza1c1OlHQt0EbDFMcK3xxfbPPshlKzfrM+a13l+eci+EZa1O
         O2anx2cLqQCEldCesgl1jqUGehsN+HM12+jsY5yG+IGu29c1UBCx06eUCfp/sHvBbL/a
         2yb3zFADK2jnnq/muEe4G68BWhwCTlOmQsX/Pm/Dwpa11AYRXDtud2b7N8VFOLvXFgGa
         HdRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776562540; x=1777167340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzFn1DdpqAIgX9exE4IN6lU5puwoTwb7tv/UGHT/WFw=;
        b=ElNK8775+vE1GayVmOhQPKdfukX/B2ghToMheh3GPFaYHe53yoge+X5bpKxmVTFf5i
         R/OFF2vQdjATjX+XWJbhE/CIECsftzmLLiHKeaIhoAF8YDV8U/uMF7T89P0dWe2eGMDm
         OXqaPPAXksjcuj6J2yBxAtFOHxvu1tgbttShWL5eiUDUsh9u4GoN5ioyO2Ckq5i56ZvJ
         XdetULMUVjmZNs8lXadfVNtV2Qjq4kAgqj2BTHEnyrU4F2iAYPrdyxOROpK6fp+6odig
         oxIf1uIc2sUhf/cji1rD0GgwnXQjokcqvgsFOKn6qw9Kl2FGs5dgCzeSOWwL9eK5PAhI
         oZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776562540; x=1777167340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JzFn1DdpqAIgX9exE4IN6lU5puwoTwb7tv/UGHT/WFw=;
        b=FK7ulHBcozIfhEl0oZkUmVn2k1gx7gWt42p1jkr4N9OdVBEHaa9xjqJIOBPz+ZP8Q+
         z5iTVrjiAPp6EISIdjfJPm0WwVmmdvjqas6l0bFJ/OsYkIRRcvvneDllhPivOOCpmpit
         q4NU3fA62o6WJreqHq+doGhk6phBBt9BpIzFVH4gXnklKT/jZzXJ2mstH4tEhpQ7bE12
         hESVvkYblGtWEmYeCCGBJP9tBbLmBgS3eCPEuG5ulOPhmsjda3XZRPem4VIJtxM498nz
         mASlBIQbRqbsqcyvFHmcJuFXGAK7QhCNPaIr15Ac2ZNP2OkBMpHcxfPmnRhNElSk1d1Y
         wB/w==
X-Gm-Message-State: AOJu0YzQhUgTLRJYwp0V5/NvyGf3KWw/rUUZBI4JcU3YnlE/QHg9zOID
	T3XT6bcFH2nTwY626IlKdiJ6KDLFO7G0DsSqeBp9zNc4n+ViCgC2dIZrr5J8vDhLL/AodFRu1Mn
	nP0vyYDsz9VLxDPjuG1gjQJbTpeCygXU=
X-Gm-Gg: AeBDieu20joXC8lhPD9cmPa3PDrEbF2j1FAgkL2W4O0o84gGyZ4I/BjPkyqxZw8sLfD
	ONJUesN5TXqCnGEbYomAE5NcKSor3bRKWAP2xsMJVBNVzF9m7CmpE2C1qZqFMUQcWMlWZDOhNqH
	Qa56C6QZy3bNMa9O5B4XkwvHOVekPSz0MVnwNDSL4i3oItSOtc/zxtYqmGoK9EcDxd5tgk1ozPl
	F9ghMXwamgswQltXvNxrqZkwUwkHqL60SRplk6Aj+A2shNSTOqpXFF0JmFHZ22fP4hI59ultFNq
	dzk8czMIds1MjbTOPTDmVyoGrLxK3brzs1PZ560chEtPaSdL86b8QHXGVb3UpkkGULssVn9CpWM
	gQ/ZdIOFxlodynUiAjCMCmDORhOElVOsxcsUXaigf/0rTaObJ//U7qC57aCo5+Dx5v7Nomq5o7Q
	gigFEpKnNSoTpO7TNmLf21qzqeM8h3g99Q
X-Received: by 2002:a05:622a:5c1b:b0:509:211e:3624 with SMTP id
 d75a77b69052e-50e36823dd8mr150373111cf.4.1776562540198; Sat, 18 Apr 2026
 18:35:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413190713.283939-1-ematsumiya@suse.de> <20260413190713.283939-2-ematsumiya@suse.de>
In-Reply-To: <20260413190713.283939-2-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Apr 2026 20:35:28 -0500
X-Gm-Features: AQROBzCh3ngMuytDfslPqCPObOzGbcADmlfRZo-czjwEzV_sXYcHxWz2NCLWtAI
Message-ID: <CAH2r5mt1_wE_9A_rJa=Z85kkg-KTZ4BEvMiM-b7c+Yaa5SjBaA@mail.gmail.com>
Subject: Re: [PATCH 2/8] smb: client: compress: fix bad encoding on last LZ77 flag
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Apr 13, 2026 at 2:07=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> End-of-stream flag could lead to UB because of int promotion
> (overwriting signed bit).
>
> Fix it by changing operand from '1' to '1UL'.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/compress/lz77.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.=
c
> index 16c7d8f3ef17..c1e7fada6e61 100644
> --- a/fs/smb/client/compress/lz77.c
> +++ b/fs/smb/client/compress/lz77.c
> @@ -216,7 +216,7 @@ noinline int lz77_compress(const void *src, u32 slen,=
 void *dst, u32 *dlen)
>         }
>
>         flag <<=3D (32 - flag_count);
> -       flag |=3D (1 << (32 - flag_count)) - 1;
> +       flag |=3D (1UL << (32 - flag_count)) - 1;
>         lz77_write32(flag_pos, flag);
>
>         *dlen =3D dstp - dst;
> --
> 2.53.0
>


--=20
Thanks,

Steve
