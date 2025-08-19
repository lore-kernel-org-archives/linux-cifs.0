Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CCB25C711
	for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 23:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645266; cv=none; b=Cbj3e02X3ltgs6JF2iU7LK2c2BJcSM9JXPU0rzPaYoJKh26lX77Shr03KH1BRGRiMQIY2dLXuuURr3iF2wIBRszFHMrFwkASXxnc167Fq2Pg9Elxg5HGI17RUbK7q+VdW8JJ2V+u87kS51qkRGnlytyOQ6HLINz4094F5a28wcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645266; c=relaxed/simple;
	bh=SUTSj7EVQitAEn0jmhQCrVHteuQ63IdDjK8L5BvFziM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IYdNWT6UFV7UUT+0oA4dxawHirqB7rEi+WbE3aRQ+3Sb9XFfecw854wIqGnCMER35BH2pJIclrAYwOIWDZOomAgdcO5QRaIQDQL7n/zuZ03e26eclNyh2p9de5oLLR6y7RkepLFeU7LQcCFnVWAo+Afvku0ZSKJgAHpjZcEr8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgnzVjEn; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgnzVjEn"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b109c482c8so99972301cf.3
        for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 16:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755645264; x=1756250064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRIhHDI7n6du0QbPIi7uv6qYe3yHhaHsPB+EW8K+U/Q=;
        b=cgnzVjEnvfc8OG8IGRsBAl9DMqNrQcQWOJIe4MgLYJYAnJ3RkSHsfMD9RqWeQ3Y48P
         IU+Fl2Jo8UtHo6qJwbYY1cm2y9K/Winlsfmkcj0R/b3TXCsqt1BRso4DvpLhIs5wWYfV
         J2z4JsWrBWvBcaBT/d9SQRpHasezXpjyNibWkYGA9Njgc62LkD+TdnuRtoVphnu1QaxD
         qFgWZIhRKMPcljr1nxSRfdgBLVDxWXmPV40Eo951gc0AfNX1PIXSzBQyEstGREuVF2fG
         1kjN9vewh31Gpp4KJeFpRbTr0f38RI4tl7CF+8DXXkhDHaXZSMNQfBVxxi3b40iqDEBy
         uwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645264; x=1756250064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRIhHDI7n6du0QbPIi7uv6qYe3yHhaHsPB+EW8K+U/Q=;
        b=Sur0vevJg76pqHUlVauW08EQ8CPgfYcQ61XgKSGY5spN1l/+NVD+T490uswUI9P9JK
         i3ICtaMMllCdBA7hrjn5wI93KOPqiK4Zf83MVNEI1BvkZPgL/rZ/fVEZCdgp1LQHlePQ
         fWP8XcVZTo9AB740YEjNcDuWA/N7SD4yjqSe9cOdxICPCFVmgC1MbQxIVdn8ra4PNfHp
         ICFFKxddnHQmt6rc85WixoXcke2EITnCppQrULT1lWBFRCCRgYa9pYrOmf1s5Be4z/0c
         5OOX6yTuI4p7tYrkJOl2Zt8iT1z2FHXQfiyzD57dxvTjPOeT73f9wBhzhmEZ+lMRTzlk
         kViw==
X-Gm-Message-State: AOJu0Yzc95XTyJB6681ebjg11ZTzHuHYpvlsQ3szbJLrfGWcjI7uO5rz
	45r45g0SP5uo/DcHDXqQjcxT0dWnmtx3v+pM+5vPNeW54WYLtgRnUC73RafLhWbBA2IE7W62SXI
	uOG06QVFxNtj8e7/qhFAxsalpzB2TQzk=
X-Gm-Gg: ASbGncsGQrgKY0YXGPjUHdyguk8foeuaNiAyxVoPIUnnlYGS3x7cRmgnxSbHZT1MVgv
	k00RXUdkdEKrXVrVBe3uubTHl38vkYRLgzIJDPl1VDfw4UNB4wlvaMstuu3FP2tnVXl/vsREDLj
	vEDOiuk4sPDAyoEsDx2cyGZq2zO7G3MiMwqhp9Mg19pbrzobFLBbW/K/u9lIMoUebWkzpzoxJuD
	44DrSBqGHLwbvRnvWsu0Fu2XOmet9bDdb19t1GB
X-Google-Smtp-Source: AGHT+IFii8rYzWPheE86vrgK/y9vVXDWIVznzdwKtFVvVf3xW3VvEMWrHBlJYJweFepd0qaUdCjQQj+v4YL+oAeLWzQ=
X-Received: by 2002:a05:622a:1a11:b0:4b0:a07f:c1d0 with SMTP id
 d75a77b69052e-4b291a44fedmr11606651cf.5.1755645263695; Tue, 19 Aug 2025
 16:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814212256.1653699-2-e.bachmakov@gmail.com>
In-Reply-To: <20250814212256.1653699-2-e.bachmakov@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 Aug 2025 18:14:12 -0500
X-Gm-Features: Ac12FXw_X8lmFSf4piRzp9I_CRQPcmPIJDIaUc2jUhhs1wdCHfoOwYLDa80ZldE
Message-ID: <CAH2r5mvT+u5tNo-H2HOmEBvH-+0mTvEg2qgOtS2p7=J+6X+fcw@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: Fix documentation for character remappings.
To: Eduard Bachmakov <e.bachmakov@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

good catch.

merged into cifs-utils for-next

There also are some undocumented ones that would be great if someone
would add (and probably some that could be made clearer as well, or
rearranged so less important ones are less distracting) - looking
through fs/smb/client/fs_context.c and comparing to mount.cifs.8 could
find a few mount parms missing descriptions.

On Thu, Aug 14, 2025 at 4:26=E2=80=AFPM Eduard Bachmakov <e.bachmakov@gmail=
.com> wrote:
>
> Current documentation swapped the relevant specs. Additionally,
> elaborate on SFM a bit.
>
> Supported by fs/cifs/cifs_unicode.c:{convert_to_sfu_char,
> convert_to_sfm_char}.
>
> Previously raised in:
>
>   https://lore.kernel.org/linux-cifs/CADCRUiMn_2Vk3HZzU0WKu3xPgo1P-1aqDy+=
NjEzOz03W-HFChw@mail.gmail.com/
>
> Signed-off-by: Eduard Bachmakov <e.bachmakov@gmail.com>
> ---
>  mount.cifs.rst | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index d489070..9eee7d5 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -307,10 +307,10 @@ rwpidforward
>
>  mapchars
>    Translate six of the seven reserved characters (not backslash, but
> -  including the colon, question mark, pipe, asterik, greater than and
> +  including the colon, question mark, pipe, asterisk, greater than and
>    less than characters) to the remap range (above 0xF000), which also
>    allows the CIFS client to recognize files created with such characters
> -  by Windows's Services for Mac. This can also be useful when mounting t=
o
> +  by Windows's Services for Unix. This can also be useful when mounting =
to
>    most versions of Samba (which also forbids creating and opening files
>    whose names contain any of these seven characters). This has no effect
>    if the server does not support Unicode on the wire. Please note that
> @@ -322,7 +322,8 @@ nomapchars
>
>  mapposix
>    Translate reserved characters similarly to ``mapchars`` but use the
> -  mapping from Microsoft "Services For Unix".
> +  mapping from Microsoft "Services For Mac". This additionally remaps th=
e
> +  double quote and a trailing period or space.
>
>  intr
>    currently unimplemented.
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
