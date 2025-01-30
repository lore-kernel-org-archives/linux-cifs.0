Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BB138DD3
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738261736; cv=none; b=tW3ziVVcJct98DFnjcKS7YAASpGQFTVJDZeSqdurlHywUYSxT6pkiMxz73Ro/weOwFUoru+VzrEMRekh+edsKURTXvp/G1qrwT3PJ6CcWY8sPzoGJ0aEJxaURRG+Cv+MVxGqMnMyMnhdL26AvmvyPX1YVDJTCZcw2w/V1N1djYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738261736; c=relaxed/simple;
	bh=UMHaD7iXla0f8tY1SoN0fMqYmg4KEr0a8V3Ldr+cHdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vt3aTPDyN/iLgnIoWjjkzj60rtP8k+Syy0CtTASSore1d5gTFB1ffsSU5vR9i1y3JxOGeKZDh5TNfO4ed2T8PrNVLM3wuUnSXo3fy+ZS3sFM83lOxFpmasCpzKFrcAsk+e+2uXnd2qE61m819kng8wCV1q5Y4mm5DTZILkz4OMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhRFTwVU; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhRFTwVU"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5426fcb3c69so1002724e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 10:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738261731; x=1738866531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TMjvMB44tkdXxnl9yFN8zxps9cOrEN6+Of/tewxuD4=;
        b=XhRFTwVUaHi4UQQP3mZy6tFI7N05VyDoKCnWv9bBbxNK7BfvEe4VnlGI4IfA7IzaWg
         dUQK30tAwFNMlf8B8ZDoGRu/HA9J2eZCuJYmNerUaU2lHLJbZEIc8hxXSZn4DRg8cjKn
         /K6pn3JLc4Np/eW4PAfoQVxd5E6Ax+DqHfS4lyNaSHuGCkFdeaw50DKjqOom660uQObz
         ohplM9Ub6/PaBihHDPDDcIH8EAU4XQJNZjOl0/kF0RuOlMX0PQolJcoFovh+bCOgpo1m
         tvA6U2iK0M7Do2ePuM6Z9c7dAw4uLAnKOieMPPCL68oazCRM/n1Ri3ysG9KfqBGpr2du
         Sf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738261731; x=1738866531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TMjvMB44tkdXxnl9yFN8zxps9cOrEN6+Of/tewxuD4=;
        b=kLEqlCFdVvpbsjhpUFKZSU86LBPfHOZ0z0eQNRIfuDdQTkd4h1psi6VVC68ID4VbAT
         kPDy4sitU7B7VrVFI/TV003nIwA9u44MXNCX9bk5LJ+Q/ke08uFxMC5ILiA0SKhv7abE
         EvABgMGOEeWsF6UdRxmAlUchLfKp7CIjyUW+kyCeF7Bkkc20b+caJEINVdohNKP45qJx
         iZ8HWnljpmN/WZhNGQK6HE7oz7vFXeHHMcvMuDEd+yHcGXS72UriQZi3uAoO6NWXTqJG
         YSLcsQoHn0IJT2c3ePwvwLvyNwm85GhTPAhH/95Lg6EVFfyqNePX3mlej3pklgNvLh2f
         8/Cw==
X-Gm-Message-State: AOJu0Yzv2Vayh6x+5guzr38zW3KsQPZxuCQggQxtUGjmoF0KNwR15cwN
	Bmr99qvgbAyp2KEH761BZE8XN7Ik6g6naXfItH3XTVMoE/V12lZETfdzkklS1RCaUyM1QVpjcBp
	XYA61c7Prv3Nsd70Ro4/lP7yCG6WH/vaq
X-Gm-Gg: ASbGnctBLwZE3dkOzYWzrT1P/VaVxupDrDkzTZ5HAK2xKBqU4DKXyN+xZHnqHm/gaRw
	abbSx50IPy9Hn0kQdVpNSZvKMkXweyd2x4oDpnYCDJrTLcJSPR4tFFPjedAlnH7jCNbSAWi4XGN
	l36kWWVQQU5IGuZNQan2WFFQENt17A
X-Google-Smtp-Source: AGHT+IE/BnMwkvg9L0LjlNitiJD9ORfblr0WHkTk7GIcnKYtUhHJxyTHEDCqCfwd5sTJjhlIhFT9ndbBFudxqOvoUVU=
X-Received: by 2002:a05:6512:239e:b0:540:1f7d:8bc0 with SMTP id
 2adb3069b0e04-543e4c3c25emr3201748e87.49.1738261731000; Thu, 30 Jan 2025
 10:28:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EPQ647ii+vEbiaYT5dQXn__t2KEVypKyfsovbrwCrBQcTZow@mail.gmail.com>
In-Reply-To: <CA+EPQ647ii+vEbiaYT5dQXn__t2KEVypKyfsovbrwCrBQcTZow@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Jan 2025 12:28:39 -0600
X-Gm-Features: AWEUYZmAb0iyyHUpGm2dUQIkt6fJITnIelqliwibCYwh9ai-RjgBG6FDI-eL2f0
Message-ID: <CAH2r5mvd1Zm0T-fBP8cdgarxz+Ao4D+Gn5U5xXB0q1ASSK-oAg@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: add documentation for upcall_target
To: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad <nspmangalore@gmail.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have updated cifs-utils for-next with this (after cleaning up some
minor whitespace warnings)

Currently have the following 16 patches in cifs-utils.  Let me know if
any objections.

/cifs-utils$ git log --oneline -17 --no-merges
cf63240 (HEAD -> for-next) cifs-utils: add documentation for upcall_target
f6fddc4 (origin/for-next) cifs-utils: avoid using mktemp when updating mtab
5e80978 cldap_ping.c: add missing <sys/types.h> include
119f7bf configure.ac: libtalloc is now mandatory
1561527 cifscreds: allow user to set the key's timeout
f9d2e82 (tmp1) cifscreds: use continue instead of break when matching comma=
nds
974249d Do not pass passwords with sec=3Dnone and sec=3Dkrb5
71103eb docs: add esize description
4882c91 docs: add max_cached_dirs description
a241032 docs: update actimeo description
3b39843 Fix compiler warnings in mount.cifs
89b6792 CIFS.upcall to accomodate new namespace mount opt
af76bf2 cifs-utils: Skip TGT check if valid service ticket is already avail=
able
a8252db use enums to check password or password2 in set_password,
get_password_from_file and minor documentation additions
e447a48 cifs-utils: support and document password2 mount option
6cf2f47 smbinfo: add bash completion support for filestreaminfo, keys,
gettconinfo
0fae4c7 (tag: cifs-utils-7.1, origin/master, origin/HEAD, master)
cifs-utils: bump version to 7.1

On Thu, Jan 30, 2025 at 8:43=E2=80=AFAM Ritvik Budhiraja
<budhirajaritviksmb@gmail.com> wrote:
>
> From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>
> Update man page with documentation for upcal_target
> mount parameter.
>
> Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
> ---
>  mount.cifs.rst | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 67c5138..631482d 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -636,6 +636,21 @@ acdirmax=3Darg
>    If this option is not specified, then acdirmax value will be set to
> ``actimeo``
>    value, see ``actimeo`` for more details.
>
> +upcall_target=3Darg
> +  Determines the namespace in which upcalls from the SMB filesystem
> should be handled.
> +  Allowed values are:
> +  - ``mount`` - Resolve upcalls to the host namespace.
> +  - ``app`` - Resolve upcalls in the namespace of the calling thread
> (application).
> +  Default value is ``app``.
> +  This option is useful in environments like Kubernetes, where the mount
> +  may be performed by a driver pod on behalf of an application running
> +  in a separate container. It ensures that Kerberos credentials and othe=
r
> +  user-specific data are accessed in the correct namespace.
> +  By specifying ``app``, upcalls can be resolved in the application's
> namespace,
> +  ensuring the correct credentials are used. ``mount`` allows resolution=
 in the
> +  host namespace, which may be necessary when credentials or configurati=
ons
> +  are managed outside the container.
> +
>  multichannel
>    This option enables multichannel feature. Multichannel is an SMB3 prot=
ocol
>    feature that allows client to establish multiple transport connections=
 to an
> --
> 2.43.0
>


--=20
Thanks,

Steve
