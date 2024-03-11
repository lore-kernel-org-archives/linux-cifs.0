Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9841757
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168001; cv=none; b=KspQKBRpr6l8uxHHrgrgc0o4Ylf4mW9V4AaxzEVi1q2BmrB8Bk4dYoiTflKgi7gc4LumHi8REG5ZplhSp2emjpA1wo0qxjmtYWnKoP/KyliXB9HaMTq1PV+Exnb45WGhyGeSgpRNEcgR5YfkoJpaF0Dm0QHixJrwUxXenpk55VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168001; c=relaxed/simple;
	bh=YzXfKRMkFpzS2EepEb0P0kHreWX3il8z2j7rWbSb7Xo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X509ZGT5Aa4q2KWTowOyoOqd7diGINysxIijtKE5X1N97iTe9War+oHm3v4Vx5c41lQXUyGLukyClQpilJDZA82eF0m153MxVOq6Ux9Q0e2RKvACXMuSxP0lB2lFyzCQ1XViTwJAreoozgNta3qsplrwkfVytlPdL1ZmhP1AcXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LivbrN2O; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LivbrN2O"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5131a9b3d5bso3820818e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 07:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710167998; x=1710772798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp0xFofWrxDS6exdLwIEbaN316KVk7xGemggEwhjQk4=;
        b=LivbrN2O8tCY8NgB6WJa2puAokHZ9O91WQzYHc5h0adxVD+YCfIz4OMVoruQ2Nvf0P
         hnvwGmyBoGsqdGCJtt14m643yUKXzUnt99XVvRc7kNAWC2suG2t/cF8Ip+hDVs3mXpXX
         a5K42Cc54PF4qAl7DFGpQkutGbYSOFIFyEHVYi5NwNw/Oy7py9C+5KOtuZDdtrN9pBDQ
         KvHKAe5QZRcBM6ncWLr46pXUN1hXhiQbiwUy/8/+KyK/euJyK+8if3hOrFrMjqzvP2XD
         S2vBMGtp10hYl4DIzb3mGLigfovDrw7NVSIUhOK3buq0FeUoJCo+36iHb6mq8bnwU4HR
         gQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167998; x=1710772798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bp0xFofWrxDS6exdLwIEbaN316KVk7xGemggEwhjQk4=;
        b=BbgdeW5qNV/RRxF2EX7q5bISozyq5lXDeik/AjcKl2NFbp1/vFcN6HlbaimVWvAzms
         wL6YhbSBaYLHswa0bpP/godxLwirgZtc/iGV3XtMnHQPJEkFEEgOA1nBKHC22twYdNYb
         TFFJd45s+TxT+8qU+Cg3LAY0LQbd1yTxrvclGo82dWo9QbtzGNQJvgYbXgln43dOagwQ
         lYg+kBKM6arys4Tt4WVewxGdQ3ORZsiwfLdpTsPIIEhEd5KZnaYgSFRq+2U9nZLXgDmL
         xVoQmR9xn++wyjhfHjTjHsheicCh1L5nIIRq6XPj9O6bPA1SomrJ++Tl1XZ//UzMXMPj
         ESiA==
X-Forwarded-Encrypted: i=1; AJvYcCXtz8hqZIamuu3s0Yb5kXkJ7Iv9KqqCHY1YIgHCjwu9tNJ3YaVD561s01rlSWz3AMqZTpzVLvvjrYH9sQtuWTMWOGUpG92trgEEJQ==
X-Gm-Message-State: AOJu0YxdMwxQfN2CuYk/RA25hDLdpHcOJ57+QTjoeYYK1hJKd+4CVJvy
	qGtiuvF40Hyf/bPxnJcJM1j6gEH9OAY/gjGJ6lZqWCNAHCofew5fWIXES19o9X7DZJ+SFm9gwas
	mBSbFEJffxI5ah4T0pk67MJxNBf8=
X-Google-Smtp-Source: AGHT+IEUXmHS0Eq/REGcXHCS/ca58Zj7/jZTAWZmBF/ZWHDIWCJnH6hCr/0mWqxypZUnjeOT9AqcTK6DHP5c5+D+quI=
X-Received: by 2002:a05:6512:480f:b0:513:1804:9359 with SMTP id
 eo15-20020a056512480f00b0051318049359mr4419122lfb.17.1710167997654; Mon, 11
 Mar 2024 07:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311012425.156879-1-pc@manguebit.com> <20240311012425.156879-2-pc@manguebit.com>
In-Reply-To: <20240311012425.156879-2-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 Mar 2024 09:39:45 -0500
Message-ID: <CAH2r5mvXVfH8g0R0086qBtAcpR1NV8oyK5OF1ENGMqUeitbBBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mount.cifs.rst: update section about xattr/acl support
To: Paulo Alcantara <pc@manguebit.com>
Cc: piastryyy@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You can add my Reviewed-by: Steve French <stfrench@microsoft.com>

On Sun, Mar 10, 2024 at 8:24=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Update section about required xattr/acl support for UID/GID mapping.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  mount.cifs.rst | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index f0ddef97a0e8..bd39c165c130 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -321,11 +321,12 @@ soft
>  noacl
>    Do not allow POSIX ACL operations even if server would support them.
>
> -  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba
> -  servers version 3.0.10 and later. Setting POSIX ACLs requires enabling
> -  both ``CIFS_XATTR`` and then ``CIFS_POSIX`` support in the CIFS
> -  configuration options when building the cifs module. POSIX ACL support
> -  can be disabled on a per mount basis by specifying ``noacl`` on mount.
> +  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to
> +  Samba servers version 3.0.10 and later. Setting POSIX ACLs requires
> +  enabling both ``CONFIG_CIFS_XATTR`` and then ``CONFIG_CIFS_POSIX``
> +  support in the CIFS configuration options when building the cifs
> +  module. POSIX ACL support can be disabled on a per mount basis by
> +  specifying ``noacl`` on mount.
>
>  cifsacl
>    This option is used to map CIFS/NTFS ACLs to/from Linux permission
> @@ -750,8 +751,19 @@ bits, and POSIX ACL as user authentication model. Th=
is is the most
>  common authentication model for CIFS servers and is the one used by
>  Windows.
>
> -Support for this requires both CIFS_XATTR and CIFS_ACL support in the
> -CIFS configuration options when building the cifs module.
> +Support for this requires cifs kernel module built with both
> +``CONFIG_CIFS_XATTR`` and ``CONFIG_CIFS_ACL`` options enabled.  Since
> +Linux 5.3, ``CONFIG_CIFS_ACL`` option no longer exists as CIFS/NTFS
> +ACL support is always built into cifs kernel module.
> +
> +Most distribution kernels will already have those options enabled by
> +default, but you can still check if they are enabled with::
> +
> +  cat /lib/modules/$(uname -r)/build/.config
> +
> +Alternatively, if kernel is configured with ``CONFIG_IKCONFIG_PROC``::
> +
> +  zcat /proc/config.gz
>
>  A CIFS/NTFS ACL is mapped to file permission bits using an algorithm
>  specified in the following Microsoft TechNet document:
> --
> 2.44.0
>
>


--=20
Thanks,

Steve
