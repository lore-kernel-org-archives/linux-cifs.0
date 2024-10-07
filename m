Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C607F1714D7;
	Mon,  7 Oct 2024 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728318908; cv=none; b=lOW8h9WsQjZP0YcxCqLIXI1iJ7WW+xve9Msjj24MsZ/gkWa2q4GPL+O854YeusxQmuJpNKoQeBv7GhCrNIJlvJFTw0o7vhsWvdSTIYvyYTrnvgIrIsJZnXmY9R4MVoy4FvrH7RBbpQ0v1dQKDMaBJGrUNTj1LXTy5vGUxBPm2OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728318908; c=relaxed/simple;
	bh=cUpTqj88QUzPXFDA8qF/UYoHOQ2iMS56WKWuHVFMABg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S1lcPwHpOh4IaLHM6ZbyeyKJL5L/1oEC/xGPzzJqSTglSpHFrArKlNQ+p/1UKide0J+TTqeked0X4kwHmYoUxSFJePYoCJKDBAiajQJ7nlMdpPcaTvf/TawCx8UDKsfade5LPk/7NbuFzpUsU4jHubJydpT4ETmDUkQx6iy8anA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDB9fXKC; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDB9fXKC"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53993c115cfso5898027e87.2;
        Mon, 07 Oct 2024 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728318905; x=1728923705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxmY+nGUCZfbuIzWB3p+ETPtotVwDRzbpkoSK23MWjw=;
        b=YDB9fXKCWDmQ5VwNTWCpvpVwa+2H5/LaCJIar5uA/x7AXcfscztOZFIOP85HtuZsar
         bggUAwCeCXwfwEHbkAh3Rp1M+miN/FcQB32wpXUpxBdgvTHf9NT8yNUnhKfLfxv9MbtJ
         YvuYMtqpS1Ra8VuotOy1odE7HIHXx8/GtYVHPeX20NbDlVegSZiA8uNhs38K3l8wI91W
         mVZc7nIek2g1DzoZ4IsLpKmLVPFfRzvZf/9OfWPFX6g7cmsEzAXYX1VoCXtsDi8yIANs
         8bnDXf8/vKYJO8w6Jx/pJPYMWGvd98iupbw2jRQaqgCoItInIocP0OgtLgK9aRgOSgQI
         cdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728318905; x=1728923705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxmY+nGUCZfbuIzWB3p+ETPtotVwDRzbpkoSK23MWjw=;
        b=wpFkJisC+XLWDkaIzbkoIfo5ZlssuiC4S7n1u9wKzG5FCWukisXJDTWUwWF/So6WDv
         iNMgnoZIOeVQblWvP44w24U6RYbOJuSZxyNcRtiEt9qv7EGsctY65UzaBR01P7R077LH
         7fKM9rl7O1LAMC87m7oRUgoUGb0KB7gpqy0e1JJ7jNh5rNKK8+h/QYbLX3uMySTMbxMp
         5RogG0rEF8KDc0KHsN+lZaS7PF1j2QH3y7OBR2ZZwVqoSFQ4SYBPdWfrnRBAAYaYX+05
         cP7a7g6v2885kAMh1ViJktKVM8//rPpAtQ/2p225gPCaK5jP0QajiOyzK3LzIBSCr5Ys
         0PtQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6SdgOyNYER2jYGfLhnRAkOeq2VKMRV+k8u6/Ul7537eG/NhZo06l9pN/gh6ShBLiDtVSPd8pZvWHmW8Ls@vger.kernel.org, AJvYcCW0KjL8CEZ7i1HhVTa/5jl4go9kdyO6o4INEjCK8yUYOTrhXEYw7hOolWaxgdZQsaoE7MkDZ9Mkhtzt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0h6Ng846Ja6FZtb+mypv18KLDwgpyd3xLqE85CyZnp3aNThpZ
	N6NF99eyVsIWwD12l7OUHapNSfFLJ8R2v5el3I3QAZqW+5lGr2qEG8PXLPm5UVyci3TABFJQpFD
	T+hDCgMKfOrQRSyzsC/Db6uGLVvk=
X-Google-Smtp-Source: AGHT+IGAkFQFjCGt+USfWPhUv17P2w7WoFstu7v6F6U9LDb9UEccZtgj5hMC7YTlbZH657NcJIEV0K0IjU8qKkoCB44=
X-Received: by 2002:a05:6512:158e:b0:539:8876:5555 with SMTP id
 2adb3069b0e04-539ab88ac11mr7279152e87.29.1728318904194; Mon, 07 Oct 2024
 09:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007152334.11780-1-advaitdhamorikar@gmail.com>
In-Reply-To: <20241007152334.11780-1-advaitdhamorikar@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 7 Oct 2024 11:34:52 -0500
Message-ID: <CAH2r5muZn5OEUsXJ-LujJmnHmVMq+TuH89uxkbfXwVjLiCD+TQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb/client: Fix logically dead code
To: Advait Dhamorikar <advaitdhamorikar@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	David Howells <dhowells@redhat.com>, Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, anupnewsmail@gmail.com, 
	Colin Ian King <colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next

(also FYI - a similar patch was submitted soon after this one by
Colin, but was duplicate)

On Mon, Oct 7, 2024 at 10:23=E2=80=AFAM Advait Dhamorikar
<advaitdhamorikar@gmail.com> wrote:
>
> The if condition in collect_sample: can never be satisfied
> because of a logical contradiction. The indicated dead code
> may have performed some action; that action will never occur.
>
> Fixes: 94ae8c3fee94 ("smb: client: compress: LZ77 code improvements clean=
up")
> Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
> ---
> v1->v2: update short log and changelog
>
>  fs/smb/client/compress.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
> index 63b5a55b7a57..766b4de13da7 100644
> --- a/fs/smb/client/compress.c
> +++ b/fs/smb/client/compress.c
> @@ -166,7 +166,6 @@ static int collect_sample(const struct iov_iter *iter=
, ssize_t max, u8 *sample)
>         loff_t start =3D iter->xarray_start + iter->iov_offset;
>         pgoff_t last, index =3D start / PAGE_SIZE;
>         size_t len, off, foff;
> -       ssize_t ret =3D 0;
>         void *p;
>         int s =3D 0;
>
> @@ -193,9 +192,6 @@ static int collect_sample(const struct iov_iter *iter=
, ssize_t max, u8 *sample)
>                                 memcpy(&sample[s], p, len2);
>                                 kunmap_local(p);
>
> -                               if (ret < 0)
> -                                       return ret;
> -
>                                 s +=3D len2;
>
>                                 if (len2 < SZ_2K || s >=3D max - SZ_2K)
> --
> 2.34.1
>


--=20
Thanks,

Steve
