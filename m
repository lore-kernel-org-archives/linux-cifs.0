Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00335318EC9
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775001379; cv=pass; b=W3jQWR25a+ghJ61dGmCtJ4svmGUR0YFuhcfLYF/UqOiGenD2/5MafoIpx4baYKv2MfzM2XsDFIMNytiIg8GAGP1X42CRfY/dJKpGFEPx3RrleyegALfF83G6VFeho+CZMXuzIhKmFZObBwyATCcy6GS+wt9G5+N7IJnQiEvAlAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775001379; c=relaxed/simple;
	bh=9SEUoZ75DhsDtbc37gzq1R8lzI+GIeNyfZKQ4+jIr3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y3cN7fAoam3qHQRXBtjG0HAjqyLEqo/o3rh/Nx2U5kF9wysHAjBxHjGaxEa8045RtBOo9yCwayXHsjD1ldJSumSeMuJxufHXDWBuNHtNehw3rnOmsXIp+ZVNqCvnGys0XrnzSzk/eZ88aMP45rjBSizqqMa4l/AmLDBJNhHfJ6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/wA6z2U; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/wA6z2U"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8a068db9989so4190006d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 16:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775001377; cv=none;
        d=google.com; s=arc-20240605;
        b=OcrzW3tu/qJ6UiR51fC1U1p7ruaP8vWG9qWsE2FifvQGmEC2/U32RSw/1drrxAXOqI
         AY4UkdG/jVrShJ9k4ao75x6vdpk5+E5W29CwQuBs62/RZdcWVDGJtkaUBfow4MO65xV5
         5hMcgUTp2PMw0ksm/VVMbs0btHkTbpWMk/HGdYKvO11kiZhy4XliSZpAK+CtjwNeXcGQ
         PHrIEj2pyjxXm/zwA+mMTKvd7/HQyxD0bnCJLjLHW/9/amQjvPqvpKwNGF0QUNpw7OUO
         A5tn/EntBsU4EAL46C6MTOAnqxyW1uS5I2JAR5klUd2sFp3MyAl3Gq8IvInIrBbWVHAJ
         qu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yXWpn/+pXJAWFfwR1fXi/Fj56eOlAFfOXd6vkbssCrs=;
        fh=vRNBWFAgmJneg5/L0xNXSNEPpclt8jjSgYn2oPgQ700=;
        b=RJ9zn0d3GJgxJ892YDDd1o/TWQeCX0p8HUkwrTYDC/Zbl90uffZDtB/uxpGlHFsR2W
         pW6DdlE6Zp4ZYs+fl23Q8ryHZV4IEOje5zIaIrDRgNtAQV4OGAvudkCb0wLX0nkkv7qm
         HWquYN/+uc3pMiROrxUrTnsW866F3wQ9xz7XN4cw6WmaAca/R6vTeguq+46dacTgSwe0
         VTqVC7MG5iObKu9V96S4e/UcfcyzXgHmFf6L5db7b0Hn4JxnMQXgkmMW9hWRZ9Ep7hPZ
         MHN67rnOJKG8oyBNQVXahvX0Fv96aYCuxsbjkj9G+PHsac1LY4Q+9L6chAVHWzG/2Dg0
         ao0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775001377; x=1775606177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXWpn/+pXJAWFfwR1fXi/Fj56eOlAFfOXd6vkbssCrs=;
        b=m/wA6z2UgvCQR4NfVuHmZ0KtFXJjR86L+AxAzkGVelF5jKKtoU7o35xhY8gav6+guu
         WfnLvASBr67M5qqagw+JU5hYcm0KyqPix6an4uBE/1+UEyuFAbzzr1xnoM/1GKL4d0zc
         FUxr0RP+5QCqrjqrCBgtnCZd6ygJChRASC1azi6KBTFdo9xX/9bo5Gn4ZgG6mPv3DLcx
         f3a9vUDJQ0WodbE27IiePUAeBoiomd+AG0gLehMH5zRgIxbmffDmrrUFGlrZfKA/wq8I
         S7qSDJ9P4dqp+clj3x5mDp5aWnULeoLf+PdcLDMl1TzD3uFSU2i0O19xNa9cZDPonwxe
         QVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775001377; x=1775606177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yXWpn/+pXJAWFfwR1fXi/Fj56eOlAFfOXd6vkbssCrs=;
        b=LGlM0svQd3st4tGkjckfutzH4V5SkdgzrWqCabofSC4Nj6q6l9kdkaoO2O1IFSB0j/
         laXEHx7SpVClkM59k7GX5IQWJtMGN5f70Olfv6NUGRLZNE45xquGlz9SY6GLKcZaLDde
         DxbTX3qeI0xGwCX4xwagbfvhh+l8fg4WKqgN3HSgvgHO5chXCYKfVfKHRHeNJpTSJnfT
         Isc5q+UZIRSKrmpVTYOuZu8/GoYRhqmmvES4yQYgi2DemYVZ8rzWLFOs51omog1sxNrY
         y5QlBG68aopqNGMHrQFsB03B0v6xl6c4loKve1Y+lTcOzi8yt7ZbK78CPHNYEkxlqOal
         RtDg==
X-Gm-Message-State: AOJu0Ywb9/Z8C8unUK/VpwHlJpnBb4CzIZ1iTMmPSj2YmQPl8sJ3PanU
	61yAJlvg/xjwZmtUWIW0C07Y4QewQ72aYaEjGlVIz9F0cFMJjVV/MlRkc/QoLnPVVgJ5rdHWiY4
	BQd/9+wyWjOWjuRSZXBRn9QPqVMoDk6Q=
X-Gm-Gg: ATEYQzy4TBsHVw0jcezZCpA7H+fHNaAkHRm0MjrnzhZpfJ5sUqNWH+3JLl/jioUmEUT
	vDV0vZJe3od4RCy67jC3q7TZqIqvuQBcaI0Li9ReNYsVCpomWQa2TsBfR5kGK2/oJUPZNSKYbqW
	5oghE8jEpxZagUAZz5KCANvPTzKTBsjZCaiaG47ZrpcKuAytuHv6191P+vd2Bjwzy9B10Lh6Wo0
	g6rQmJVPe2kNBd5qNX2HSX82+5TWWsKOK4I/sBb68Dv5y3Vr3/+JmHTUoN4eXoVL+gEiQIzpDpK
	G3tRGpOB1EBldszzlF6oV065o37sKx062FY6AteI08Fd/7TAsK1fo7OecPDZ6MhgdnHxBYKjgYL
	/QhGSQRLdCL1+nM0mraCPHTmu6F5SNUKK48xmlCScjA2PKBCz21t5EhGrRY7HTTNY8+uTsi3B4y
	3iILsJiOXOlMdTPngJjy+J
X-Received: by 2002:a05:6214:4101:b0:89a:8434:108c with SMTP id
 6a1803df08f44-8a4431bb6admr21151416d6.15.1775001376950; Tue, 31 Mar 2026
 16:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260331000911.16062-1-ddiss@suse.de>
In-Reply-To: <20260331000911.16062-1-ddiss@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Tue, 31 Mar 2026 18:56:05 -0500
X-Gm-Features: AQROBzAHVg2DryBsDYevw2e6bns7g7yAaK5M0LIy_Feb2TwYHxQD5M_21JOhifo
Message-ID: <CAH2r5mu56K0Ew8XHaVEsGK9KgxHv34WN5EkXTKUvFtxydFp9zQ@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, Bruno Bierbaumer <bruno@bierbaumer.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added RB from Henrique and updated
git.samba.org/data/git/cifs-utils.git and
https://github.com/smfrench/smb3-utils for-next

On Mon, Mar 30, 2026 at 7:10=E2=80=AFPM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> The existing (j > pass_length) check is insufficient to avoid dst buffer
> overrun into the start of the adjacent struct parsed_mount_info field.
> Check for overrun before writing to dst, and account for comma-expansion
> and null-termination.
>
> Bug: https://bugzilla.samba.org/show_bug.cgi?id=3D16044
>
> Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  mount.cifs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 1923913..d41ca6a 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info,=
 const char *src,
>         unsigned int i =3D 0, j =3D 0;
>
>         while (src[i]) {
> -               if (src[i] =3D=3D ',')
> -                       dst[j++] =3D ',';
> -               dst[j++] =3D src[i++];
> -               if (j > pass_length) {
> +               if (j + 2 >=3D pass_length) {
>                         fprintf(stderr, "Converted password too long!\n")=
;
>                         return EX_USAGE;
>                 }
> +               if (src[i] =3D=3D ',')
> +                       dst[j++] =3D ',';
> +               dst[j++] =3D src[i++];
>         }
>         dst[j] =3D '\0';
>         if (is_pass2)
> --
> 2.51.0
>


--=20
Thanks,

Steve
