Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A13AE712
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829626; cv=pass; b=DKMonjdEcq2WkKOvETU6k2m2NMikqF/CsXM6928gotOk9EOuGMYQTnSpDf3nSKkg2V9/Ad+42zWdzG5n742FgpFtywj3bX4B8q0PcGZB2nBVrPXfPg7vU3xZcum3Hn4mAfKBKDAKJ+A5ZrHG7HNqB1xWVAKTHMbtHSRjXwjGwc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829626; c=relaxed/simple;
	bh=c/2oV26oR0Zhc712J9EbXiUDflLKQWGDFSkFD8w27aE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdtymCR8OW6L4XXWPX6Ozn0TRzvYc61rbSmEDcUd5OPxfqrfpvhwLHbS2BuCil5aTA+0RnPLury5GPcvjc/ipRzl3QlRkxYFbrQmr02WWZ1vbTb4qR/8rI9wGBGRJdxuCaFo127ru761Rwn0lzKDySLzDbt17qo18VQ7ZjgPb4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0yhF502; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0yhF502"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15e03c2763so140205966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 11:00:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784829622; cv=none;
        d=google.com; s=arc-20260327;
        b=FWKXBkZHAMoZI8OkBivB5IHDphKoR0aUJM/TT25L/Ww5mXhwv58l5C+EgVtgBd4+zC
         tHKhZnEqB4UfWWIEqq8ummLWJppnpRAuE5IfWG8LPqDea13FQ0YI+y/DvxbST+NRUb1G
         AM4y5va47Hg5g7ZmoaI1UX+/g1JQ/6TgrQfU6gfGb17hY2IlL0kjW+Tl8vqq+hF3yv8n
         WNF7VHrPgDozIpBwngNuUE8v52lxI2176rsWMs9LIFlWWAI96LnUL7fWEbfZ+jdlSEfQ
         X3jfVIpoKXVCglTYG8wwBNJ9Esz5zndkjaVstr/UGHCDkTWqJ+A1EHg9WZqL7rm18plV
         JQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        fh=4lvDb4rLbDR7Obc98PEHy7svHCj4hV8rGWSTi4JO1Po=;
        b=k3ZL6LMqmRkjaihJXcBhlNZdmEbp5uxWOKjw9oaqslWnG0WCef5/V2/y/Ju17np5oj
         ZfIB/QpI/aUlQQOj6fPwnZcR2+KN1FDpgAyUmiwc+o7hmErsIvbuHtEFSvbN6FUYU1V+
         95OkXbZIZuJSy6hEQM0jzSoxITTJ43Kg9IENCX9AvqRrdR+tBBWkYa8KftR3lxfdatow
         uelD/Sv3WzKcrtCvCV96QiQQerdDdmFpYerECwVQcFsZZDrxl6GH8xGY8Qa7KQvLmN0T
         EVlrcBh/3zoAgiXVbtqkANk3HSWriapa36HVjLWrw0HzHToyxAgTCXBXerHLzENUO9LB
         ndcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784829622; x=1785434422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        b=M0yhF502p6ESg1y9tKRE57J1HflZeKuilWuRPSeqou6UZN1zxY/hoRHo8ew17QdUQW
         DGj4SMGzAeAjuDW4XRy4nHBu5Pprtq31udzSw/DGOH8nMK3dNYJ6MDXiIGBDHXT8tglT
         bLmO3T49Z26Df8wkCR23cuNqM4eZC3gYyuzo7Q2TA2PZ5ebEtYWOmT/aELQ1wDbWoVc1
         vcniFXKvCFsBDkHooOziGnuNoWDxUCn8NxO5QSvfhUcBFaTI5OEQ0n5t0enXlCdTFOnD
         VsaIRGPJ+dDYZbSwTZDeSz1dxL2g32vewTRRi19XpJjXsV3YvQSNNUphkkIiigAAFpj1
         UWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784829622; x=1785434422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        b=srPHNmy5M2RL6NCEf9+KJsIQFF9SY68TlzYm95sswBXohv1CF+lCLLdX+Xg6vjE/Nz
         wRA7D+ndyknY354yiZW/Spkyv5fv9KkAEpNAKYCDvol07YzilqgLE7Ju8JoLMMKEINMS
         V1FqlUqFit3UGyfkWCFd00tfvcNcdt28uw344+rQuk0/ALIqw4LT0anVlKWhD9FZ4+qC
         g4eKfLtbM38gPO5M3KH3Mr3Xj+csJTW4+d+2GLxPj6fOonA4nPyQYwUcov/hRIxVO7EN
         tUesL6qRzwK48ZzEqNsNWoUBbZiWgk/Vq1IUPnbN18JmsTs++JTaiD90SE3lsDmGED+y
         lOxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrbr5ParHNOwlQ2PGCRL5NN/cjTG5agFvuJQocc24ajIhtKBMz8JotSUquMPStnZCp3gWQQAQqDxr0Z@vger.kernel.org
X-Gm-Message-State: AOJu0YymHyYyolOaSX3mImE6nx/LQSUDbQqGM9WlMr/DXqGlU14rR1Fk
	Gft9ZLtmoNoTJYhsIzdPaiflsoU0LE1Ub9lfaOt/q3dTfioemDr2kOmEhkajMximJTJXI9RQ69x
	2FTRcnDDJz2Ka5U+HiO4/qvj1MwO2rAk=
X-Gm-Gg: AR+sD12MYC4LezkuHwEYsTSP3S53uc4YlCz852vec7WkOJ0JcD+jxLiN6BBPQVJdQFH
	BrkS4zPE7Lu4SjrNFzG/la9xJV77tnu/spl7ZhknGRkee44jycH/sQa4V68i57FL/QkM7jcMcCx
	O+WOaCIG74CjouPPtoHeF2GAcN4wwmZauVMa5vmBR1eK8QTv6N+4EXOCg9EQJlTFE3YcKkur/cy
	xkZeiavjiQ1q/C67zKTI7yPaZ9bOzOGcaQEW3MSmb2niq5q58FfeTZ6k72IbfghGacLcRwHwfiY
	WCWloaNiNz1bB+7PXXM=
X-Received: by 2002:a17:907:9619:b0:c19:891c:e1a6 with SMTP id
 a640c23a62f3a-c1c536c8d6emr180399366b.12.1784829621600; Thu, 23 Jul 2026
 11:00:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722130615.3163560-1-hch@lst.de> <20260722130615.3163560-2-hch@lst.de>
In-Reply-To: <20260722130615.3163560-2-hch@lst.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Jul 2026 01:59:44 +0800
X-Gm-Features: AUfX_mwYG6fMwqod_7vhQphcNSi4VFizKHSgiYv7Hwr5KRsNZH6h97bbms1Vw_s
Message-ID: <CAMgjq7ArsgdKf-uZ_drQ9Kqtq4i_MMZ+dP+tjNzPrsrR0YPBWQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for
 synchronous swap devices
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, 
	linux-mm@kvack.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 9:06=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Kairui Song reported that zram benefits from submitting each folio
> directly instead of batching up I/O because the classic LRU scanning
> benefits from clearing the folio writeback bit in the scan loop.
>
> Accommodate that by kicking off reads for synchronous devices for
> each iteration.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..c984a4023a65 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, =
struct folio *folio, int rw)
>         }
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
> -       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +
> +       /*
> +        * Write out the iocb if we filled it, or if the device is synchr=
onous.
> +        *
> +        * The latter is to work around expectations in the classic LRU c=
ode
> +        * which make synchronous clearing of the folio writeback flag in=
 the
> +        * reclaim path beneficial.
> +        */
> +       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) ||
> +           (rw =3D=3D WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
>                 if (rw =3D=3D WRITE)
>                         swap_write_submit(ctx);
>                 else
> --
> 2.53.0
>

Looks good, thanks!

Acked-by: Kairui Song <kasong@tencent.com>
