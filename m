Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56632481240
	for <linux-cifs@vger.kernel.org>; Wed,  6 May 2026 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778083454; cv=pass; b=bIco80JX8H1UGP+p2m/B53ZCMwcK88JOvxjKkQ0hGedq5gPlqh4WpRwSOh/wqyF00r3jAN4AmNegKP31ZzTfsJkixrEFyrtkKk+Do/PyCF4YVPtjlc7gRNyzq1Xh0UoFfc61KgYfXMlQOkRmSYK7Qpq/+xMZ5lDztb0HjFDIad0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778083454; c=relaxed/simple;
	bh=Fg8EEuRqGMcuOJonHCZqjWuPeHMx8eaMvTea/nfCVxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oU7qHPbM2f9YrpES//OTvWmEw3APFlGPkw+NtjiOlMCa7e9QMrJlgsis2Gomi9NVhrvD7rp/0KnqdHDydFIX+ukpLwMg3IizC0dfwUGnOzw7veMIXbx3VUWwqnPC43OJTecgPFxzBDHG+MOVWHSS+XLSJPcYUkq0tchp5UVCS5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dcLYxkJr; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dcLYxkJr"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dcdd1b492eso1028147a34.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 May 2026 09:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778083447; cv=none;
        d=google.com; s=arc-20240605;
        b=a6JW3QA24pBjAxuAsgYbYVNt7+I+Dgq65Xo8bZLSssGl9erQsO+OlMilXc7GkQRidV
         4CzEHeywQ4bfGU4ySOo7t0RL8Bwns3xmZ2b2G8DWhNTnOSn8eirQ2hYXWfSiYTm0jjKn
         hr4xYAt6vLtzq8O+cuhCO3PKuTdCZOaQIeBkQws9oRTVkA+TbivJPiZrC0lHnLqfCpKI
         rcMCo3NxhLHgQvIMXXPEIdIJQTCQvUfkAx0/OHnvBtvRwe/pfN1+OeTQGiWrH7G9kcUz
         HH56606gDOqr4AhZAbGnPPoOrCC6ixIZHE2nd/ZX4jcbGGSrCCIWvdhHLOsXt3WgAmmz
         NuNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=27ftTifho9ijIe7sntRorAaSI5wWwVR8Uit6oJpMlo8=;
        fh=Df8lK7ZuOv6vAb05xfHK2VCbqKF5fakvyygoVhIOMb8=;
        b=FBWRLSaIKg84cLdREjIHTKpOFkwhJUES3Wwq8SP41lBUV9qe4h8Yav2yAWDa+ZpS9G
         N1IF2upVRh/a/cNjnP4tYNnwMOUVf0wo3EithUhIGxHNdL2ZEA2P8A9AhjUgL6E3VRmC
         PrjZpbtvMiSYa/LQY9qHeC1u2hE9iOGsri+Evy3/WV5LYCBFHBSwEr/GK5h6OE6rWrBz
         Eykk7MlaG6O9XoTRUFgLebSyJw274Igs4Yzw+uo3Kw4mOD7PI2iG+eOOyFQXypX+XGhG
         1fauObUasUx+b9/uYGGzU4ENtNdIm2AX8l+wybhQID2k9qCqpDOmT3hSxNvKs/an0w3M
         UzYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778083447; x=1778688247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27ftTifho9ijIe7sntRorAaSI5wWwVR8Uit6oJpMlo8=;
        b=dcLYxkJrmeZiDOns0wKITnZZFT808nnc2q7+14e7hzi2Dkk4tVEa/RI0LhGbx6rAnG
         TMIHGCVttDuzCZ4512XPzbXcDeVLcfGtopxDFkEBnOkL5pehCJgNAkkhFKS/DwJf9cdf
         oU0DhrKNaP1OfsugnNxtpUngGDXXHSCthnxEoje6es2TuycRHNKBMLkFGj0UE+4hXDzg
         oW32FC6lCE58gYGjDuk7J8l9ldeAFUbq0898Exb94bTVcF8VcdRFvh9Ar/NoC6cs2WLo
         zc/dvlIlZAILJyDT/R2XeJJl/2FsxDRbdKkjPPehdzcFq/rJpvFzixP2u8LnOEzVEnNt
         VUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778083447; x=1778688247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27ftTifho9ijIe7sntRorAaSI5wWwVR8Uit6oJpMlo8=;
        b=Hx4s5I3gyjc0ht+zvRfg19Kn+VlcZ47KjgBvw4zwyzdrPH8gIjWTJDQWNWp0gWZZ6d
         lVNka4u2BFI3a39p230M/7ItpiqbrUaEifhnEzlQMnZlFha/Uoz0FT+7YUw3RW4txO+i
         B2hM8S7vLENWK4tsABLZl/9Y3oINtidZrX5mYxs+jJleZluQ2K6dW3H3sGoI1PTiPIrS
         SIPF8dl8WA+zgEht5/NJu9NXf73CI9kFytMhzo13vkvcxGsLoRMWDrfTcu2laBkDbUII
         jInKH5HZOXM9MXC7QkyOeglsT2T2bG4XSUIT+fHmV8jTcguoKi79n0+Hjdo6U+EFgbyW
         LGDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pGaFDYXseFXs3MNSSGw1BC48C8U1Q7tblSWQIQH+ccF1s+Vu8dGj+YZqdhFszXojYOnWBvYvebaiu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8vfITYAGUSGsnuaX5gibojrWqvCrQD98IhPbraI4QYFAqx4D2
	QbhdLSFdA1C5zP8chAqQuN/TPvaKbuZSq7C7no6FV5biq8pJ9CSm3KDtub3oT+sxMkWQZlEqrbN
	S7gpgXz8AyU6gw1D9gjwfMVMcDcs61uk=
X-Gm-Gg: AeBDietnMmmyhCtCPqpTjhgSqsRsfIO1QhLOU8kt/EbssKn0Iv2OiLz0GnQUl6odef1
	JsvyIKby55PiwjPIRT/+YkykUFm3+DFrRT/tYJ6VoJYzpazhZhkelrC87PANpVX4vu/eZWreSCe
	Vuq2LP8IBUGLsMqT/GklAOymI5pBOx7z9PT/AQnOHXo9UODgq3iiciosf9wbkrXdrI0ekgGa0Mh
	gj4jsV6IAjdtyRU5rekW51URxKVi7s4U6sy2gB3lSOnokLzHudArrmYECuOlC9KOiDvKq9mW+b2
	x12ql+VhX9WPUsfJx9Fp+T5AsSFV1Va1yPWcdF8GyIXU5eIMOOWFcgNc3kF1M8388EcOPZNJq/P
	YvOQKcCornXNH83+bx1DTfEhhxakq1uQ4Sx+BB4HyhKWHXU1hOXEUTY3QUHUxTq6VI+biBiCTCc
	Y+27gRZyK+RqJEAn9mM29Ff98PP6Er+7i5
X-Received: by 2002:a05:6830:1647:b0:7db:f286:18ee with SMTP id
 46e09a7af769-7e0b06486d5mr3447978a34.4.1778083446543; Wed, 06 May 2026
 09:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260506034908.3874700-1-zisenye@stu.xidian.edu.cn> <20260506034908.3874700-2-zisenye@stu.xidian.edu.cn>
In-Reply-To: <20260506034908.3874700-2-zisenye@stu.xidian.edu.cn>
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 May 2026 11:03:55 -0500
X-Gm-Features: AVHnY4KD8pSY21c_3lP4hp3SV5i3cobuPX3SGSnjTR8A853UrRYet998deLuDxQ
Message-ID: <CAH2r5msBgZn6QC20gR1p8pMMv-iTKabPbqU78O1MzfW2-1r+JA@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] smb/client: fix out-of-bounds read in smb2_compound_op()
To: zisenye@stu.xidian.edu.cn
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, gregkh@linuxfoundation.org, 
	chenxiaosong@chenxiaosong.com, stable@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing

On Tue, May 5, 2026 at 10:49=E2=80=AFPM <zisenye@stu.xidian.edu.cn> wrote:
>
> From: Zisen Ye <zisenye@stu.xidian.edu.cn>
>
> If a server sends a truncated response but a large OutputBufferLength, an=
d
> terminates the EA list early, check_wsl_eas() returns success without
> validating that the entire OutputBufferLength fits within iov_len.
>
> Then smb2_compound_op() does:
>     memcpy(idata->wsl.eas, data[0], size[0]);
>
> Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
> memcpy can read beyond the end of the rsp_iov allocation and leak adjacen=
t
> kernel heap memory.
>
> Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af=
19e0@chenxiaosong.com/
> Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2inode.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 286912616c73..6c9c229b91f6 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -111,7 +111,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>         u32 outlen, next;
>         u16 vlen;
>         u8 nlen;
> -       u8 *end;
> +       u8 *ea_end, *iov_end;
>
>         outlen =3D le32_to_cpu(rsp->OutputBufferLength);
>         if (outlen < SMB2_WSL_MIN_QUERY_EA_RESP_SIZE ||
> @@ -120,15 +120,19 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>
>         ea =3D (void *)((u8 *)rsp_iov->iov_base +
>                       le16_to_cpu(rsp->OutputBufferOffset));
> -       end =3D (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
> +       ea_end =3D (u8 *)ea + outlen;
> +       iov_end =3D (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
> +       if (ea_end > iov_end)
> +               return -EINVAL;
> +
>         for (;;) {
> -               if ((u8 *)ea > end - sizeof(*ea))
> +               if ((u8 *)ea > ea_end - sizeof(*ea))
>                         return -EINVAL;
>
>                 nlen =3D ea->ea_name_length;
>                 vlen =3D le16_to_cpu(ea->ea_value_length);
>                 if (nlen !=3D SMB2_WSL_XATTR_NAME_LEN ||
> -                   (u8 *)ea->ea_data + nlen + 1 + vlen > end)
> +                   (u8 *)ea->ea_data + nlen + 1 + vlen > ea_end)
>                         return -EINVAL;
>
>                 switch (vlen) {
> --
> 2.54.0
>


--=20
Thanks,

Steve
