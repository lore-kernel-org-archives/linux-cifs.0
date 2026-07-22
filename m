Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB24B401A25
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739468; cv=none; b=uX4MzGX+aqmD+hjGWq8rdt9GOs2POlh+BT+jSsFBXvwX2rlKOB/I2oZWXOeihFrtESYPKOSFlL42sN0A35Pb9EOc8ldwR1dlLoslqJmMp8JNjA79ypKrPg7AhJpZBhndWo3PVD2kQHx5dh7eRffiiS4pdCrsuSO9urSAcAPdSeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739468; c=relaxed/simple;
	bh=e1FkolQyDltw5pfWJiQXzOw3WvZiHAK9iH/NrYvqCBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALlcroWacxsV9fR9Eg217jcak0qZfFqbC2rKmpGHbXva3BBGmoTkYPJJQ0andS3jKDppvdVWB9IelFw5zZr/3wZDWjjKHToYuLWn9/RdJYP0tE3Gpd5gSSSKsyiADSh0AskgAiU4xwp+ChiSsn9OZ841Tz0UaGIlDzeg6DZsQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3JrSeJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3JrSeJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843B71F000E9
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784739466;
	bh=LPcOdVZMMcgm6b/T5m22MfHqQlIHIR7KE5HKHozKnrE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m3JrSeJvvdk8Fm0c9Bts9j6plhi1hxFMHFAWKUI9fog81r6tnrufpwpRHW91Tyu3n
	 neIp6ut7S8hK6DkHU9cS7uqqWIKX0dhGW/U2YDL7IvcAYPk++GVmM8Ywd6kQD020nU
	 8Kv62SQhHcbi22QEK0uem5TFwpHC1yamO58EVQTkg6l1Nsq3DYDb7GTUkBJoi7Qb+/
	 wCXimisEeffKUZqoNEz8os5MA5MdfJmF/7e4q3Ou19NJxs3T/4YpTGO4ICJfjPJGWc
	 mPZFvK/uYk6vfgekY28H3t6jmnyiAIFM89stl/CXomJDEW/PMtKZu6yPwPv/QyiHFe
	 d9nLTgKstq9uA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81e9d8f3289so104960877b3.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 09:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrl8lq2uPmJk9CwMfUqHZad/pzzuxfxb/dcysnCTZ8t7pIWGeRiUseWH1YztFQLZFvUWdFsws7wquwk@vger.kernel.org
X-Gm-Message-State: AOJu0YyPg/C9wP+/+XKG9GJ+pjayPSRj3N1+9nEbJupT5RMjkaudv33R
	lRrAcDUtbVyb9VWNZzbQsgEwUb6YZU4LSHH470NAMtmUvM13KOBxXzS8S8ZMAeZDA5mE2w5lzzY
	u/Z8fURGaKv3Mth8G5Rty3sUSTD8B9oJuRC0jHIkH/Q==
X-Received: by 2002:a05:690c:e3e4:b0:80e:1ad2:afc3 with SMTP id
 00721157ae682-81ef22ef457mr71652027b3.15.1784739464993; Wed, 22 Jul 2026
 09:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722130615.3163560-1-hch@lst.de> <20260722130615.3163560-2-hch@lst.de>
In-Reply-To: <20260722130615.3163560-2-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 22 Jul 2026 09:57:34 -0700
X-Gmail-Original-Message-ID: <CACePvbWpxJ-5kzvkFwNRcpxqxsKNowsKkWLC6BtzuabyNZv4oA@mail.gmail.com>
X-Gm-Features: AUfX_mxaUX8OlbXL4sZ1zJoB_AVHbNO17lVhNRIYu9y_lmljMjecn4zlQmCtqew
Message-ID: <CACePvbWpxJ-5kzvkFwNRcpxqxsKNowsKkWLC6BtzuabyNZv4oA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for
 synchronous swap devices
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 6:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
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

Acked-by: Chris Li <chrisl@kernel.org>

Chris

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
