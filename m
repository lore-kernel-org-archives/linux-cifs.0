Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CB5395D86
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 21:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782942310; cv=pass; b=TALjbi6hN3BH3Cre4HJvIbPgnBhvw/cGZREk4fSKgK8uu1SfNg7zmCw/Nkxo7P83xy2giQYMJ1Ky4Qqetacn1NlDhV2z5YhOz9YzNAi2dsB3iIKGDPPdGCE3s0Y2uRaWKglRm6suwkMozua25aFHLyWU5gIjiSfMYvjRirhhzKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782942310; c=relaxed/simple;
	bh=ePO9CJQvigbJp4mYdLFff3Gx9iwPELq/2F1wYyKt6wQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VlZb62Qns8kudXeEwl9iL9TbkKY1uxq4e6ZC+plwlN/bfQu06XvRCB7l+pW6w0SyW6BXVBK4UNGu8Thkr56w250z/kbqUPujR4W6K+K8o5fsqfTk34YgYIvgHaY7CSm4gpYtHe4dRm3gXjFLdc14OqWdGdF8l74YDMCZsPKBOs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YuIa+zbo; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YuIa+zbo"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ee88fce476so9846996d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 14:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782942308; cv=none;
        d=google.com; s=arc-20260327;
        b=DvECQWhRxFnWjnFP2sVp3SECW1l2wFdED0eIOf4OzVZx8SbR6muMVBh/5iTE7n0HW8
         c3juwnCkS/d39OsFCbhV1GvBKbGP7624BRO2rCV5AA+xUsQ39hXXcCHBxe6piHPkkG+x
         8W0v26hiI3GgD7I7VgcHo0KaBmMP0ey2jpfuwPgzSM6XGgdww3iKPAI4PX+Dypo6iNBD
         YolCxkpFFBGv/2Z7dyzDVbNKlkTne2bkq90LBckBW7j+Rf9AWp18QvkutUkXFiuotxgk
         5e0YE8vY4mpeMFWT8iWVliQ5wjQPQRZ1j4yjrkai2QGLHJggaGiH+Q9U1/PJKB8E0ID0
         QFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bfdhlblgc0eQOUVL6ZW5i2tRBFOyNljYG8ekW+U7CS0=;
        fh=v4Pyf7MUJDs3cJsOsh35zBdwkRaYiN0BYG1bGEcUPng=;
        b=RKnsq/4wnLZOwEDd3oypKNkd+fI4sC5PSBgFZQlOXnFSCXnb+79pJuuLOJXQmK7m0F
         UAB2UXvj1A/0lY4sZWr1X1LlgN1LQCmN5/qYHP3P3I5xKXeLoHxrfrO/uHslpUbKaf23
         sjIw/+qB8e/oeygDf/vl78T48Fr+sDDoDCWJMoaAVqrBi8wLmeVriUQFVUJhCIjfuJ9z
         YMcLdfuWHe6yfG/YAGB1glYaYSX+VFVaSjzWueMlbGbDUbe7i56ygUe8CaXqvacfBEGR
         HtG9auUzKTabb7N2RBnAcCAGdcG0xFhd4bwk+9wdnON0wtigascac3q7WMXu23HrMukS
         kMwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782942308; x=1783547108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bfdhlblgc0eQOUVL6ZW5i2tRBFOyNljYG8ekW+U7CS0=;
        b=YuIa+zbom2zyvb+l1BPkpprTiMfQHoyReAkrsmv6S0PmKnvWuQFqHfd7O5N1ZL1MZk
         LFOZxaWkpGq1Q9Lx7lKqtkKI/B5YcO6aDobl5OtKn2DSDu+lRKs8Li38jYuXnuYjO3kV
         Z9mcxX9Jfu2VJ4dqo6qYZTMTULTQz4j4F31CygL+9KwisFv+cBqYXa/3dqAmyxchp51p
         PA4q93boU1Nt1KpYKvYXkM3zfRVu89h4jog4GYp8jljDuUm5uhyDKlB+TcIrAFWg/lTu
         86mn5u4xI7suqAdE1C46NdSuTCZi89h7RFmsg975MeP6FaFcWCTUBYeWY/AglGAMY8Q4
         EmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782942308; x=1783547108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bfdhlblgc0eQOUVL6ZW5i2tRBFOyNljYG8ekW+U7CS0=;
        b=SpEjscbHloB8druvH8BNmn7GxP2TBNDyF61hSslX1ZupbHKj3RM8ldrSVNVCe4qIlV
         ur+vpgQs1Nae8i72YbuvfyDsTA1seNbzrVzNewD1Dan0uxjPiDs+F8yOGz9K19mYG8NB
         2j29KJwE4INe9srquTiYH05v4rN6fqSDCFa1A3h7GqnAMJ00Vyg2VgTeNtoc6mnIBN5Q
         UHBg5TG2/RhQskVpgV3JbOIFXtKIEQtsOYtFwQ+4zJxFXIqrTUoFIRNNtGGanSgfwxBj
         eElovR9Qx/FkbcCThVY4Y4fMPmWVx1XZeJ7hKKsypXJ0MtFCeNirdZvO6cNO+WOZJhKJ
         CcYA==
X-Forwarded-Encrypted: i=1; AHgh+Rqemo3TnSfbDvIbiplXl5uMb2M5zzt/fwqUw9il9IjqI/+WYtyrOeGqJoLpETY+mXD2zLwPUoSq5k13@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjp7hXYBjqhk8wWTU8dtoyGbgnimrLxcywyADxHv9Sq57sGnSy
	8Rukug/MBZY/RQK9pr1H9vuU8miUmkuQ0029vaTM/1XfBZf8Yi7XN3F8vJPkZSt49MT5NCXp4JE
	uspTwxR0liUd9a35n0BsY/587AffB36Y=
X-Gm-Gg: AfdE7cmbhqJuQ3+jQvPIxnMTEjfHUTubxoaMBJ1osvRyauTcOJRj+5iScyXWUN1G0X9
	3bsYUBrthqrkV+j9xErBg1cci6vUBj4DOO0hsGLSg4VGwxYHAyzzocak8vS1QwMBnlFXQ5K2zyp
	wF34Y/bOJE/+B1pSLmg+iI/MciIGhk0iIqHgvdS4DYZKSlboW3huqDCU+8CGSfAVBMCnlqaDKVr
	67jcBHFw1C4mPBV8GQMRBV+0q2KhfHsEnwI05AJDFvUaH0PFR6bov5RWsCdtVN7OVZOCIrnfFe9
	t8dlPPy0AwyBH8kAOfqlCdM+WsR9fFOzA1tyP2aS5fIoe5yHqjT7s9Txcc9jFZOf1mjB5rpVpN/
	CNW22BsEKs+aTgz/t6o1lHik8quI52k9rZDnnI6tvycb8/2c5Y3ENufLdnFUILwhfHyifaGg2Ti
	rDZoQAEpWRfWw=
X-Received: by 2002:a05:6214:4e15:b0:8ee:fbc5:8110 with SMTP id
 6a1803df08f44-8f3c8b168c0mr47999036d6.32.1782942308123; Wed, 01 Jul 2026
 14:45:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701152157.822207-1-huiwen.he@linux.dev> <20260701152157.822207-3-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-3-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 16:44:56 -0500
X-Gm-Features: AVVi8CcDpUofZnDpqNdVok6QjGv0hOX2jF1vFm7tMSfSql7IOwoL0MKPxCNsPRo
Message-ID: <CAH2r5msyi5nvObkx+JUP78DKdthQLR4p+sg61SEW0RXATorcLg@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] smb/client: reduce fallocate zero buffer allocation
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Won't this hurt performance since for most servers the default max
write size is 4MB (e.g. Samba or Windows) or 1MB?  I did a quick
experiment with
"dd" and I see the 4MB writes over the wire not 64K

On Wed, Jul 1, 2026 at 10:22=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> The fallocate emulation allocates a 1 MiB zero-filled buffer even
> though each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE,
> which is 64 KiB. A high-order 1 MiB allocation is more likely to
> fail on a fragmented system.
>
> Allocate only the smaller of the requested range and SMB2_MAX_BUFFER_SIZE=
,
> and reuse that zero-filled buffer for every write request. Also reject
> a successful write that makes no progress to avoid looping indefinitely.
>
> This reduces the contiguous allocation required by fallocate emulation
> without changing the written data or range semantics.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index cc8e0595e504..23505ae9bd81 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3559,7 +3559,7 @@ static int smb3_simple_fallocate_write_range(unsign=
ed int xid,
>                                              char *buf)
>  {
>         struct cifs_io_parms io_parms =3D {0};
> -       int nbytes;
> +       unsigned int nbytes;
>         int rc =3D 0;
>         struct kvec iov[2];
>
> @@ -3580,9 +3580,10 @@ static int smb3_simple_fallocate_write_range(unsig=
ned int xid,
>                 rc =3D SMB2_write(xid, &io_parms, &nbytes, iov, 1);
>                 if (rc)
>                         break;
> +               if (!nbytes)
> +                       return -EIO;
>                 if (nbytes > len)
>                         return -EINVAL;
> -               buf +=3D nbytes;
>                 off +=3D nbytes;
>                 len -=3D nbytes;
>         }
> @@ -3611,7 +3612,7 @@ static int smb3_simple_fallocate_range(unsigned int=
 xid,
>         if (rc)
>                 goto out;
>
> -       buf =3D kzalloc(1024 * 1024, GFP_KERNEL);
> +       buf =3D kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KER=
NEL);
>         if (buf =3D=3D NULL) {
>                 rc =3D -ENOMEM;
>                 goto out;
> --
> 2.43.0
>


--=20
Thanks,

Steve
