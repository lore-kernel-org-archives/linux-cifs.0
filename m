Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4D12B143
	for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2024 06:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725949918; cv=none; b=oQfqtHhjlcCi/UOncCVWLSvsu+ciwrIBtXVUVsrjWvPvGbM/K9UNmFrifApQOMD2jRybUEN4+YoJIXVBurTacbzg02jXrWeVCsvzM0OG29I3rNwbHamsraHmz9KBcj0B6o7+xn4ceOXCtk7JKAQMgOEXi868TTykFSgr/N0Z0HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725949918; c=relaxed/simple;
	bh=sX4Ghjrh3CqwRCkbilerQsQukmQeRNQPy01Wb72hb5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PPgo9q1naHAtJ7eCZNkgjfkRl4PZuHCTbeu5QX2PfQ9Z9UKkF/Eh5ELzGPKJCzC7kb7xgEkYH/LZBrlj1cVF2616kTkHo4oGh5Sxy1Ing4uP/qROTMWXKt5u+W50Un1Z9/zg+tp2G5+6iyvlVUu4zKwqJtuKdj/hJ/kS8PbqvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bL1QSJHZ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bL1QSJHZ"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5365928acd0so4537258e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 09 Sep 2024 23:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725949915; x=1726554715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHHDxP8q1G6s76c8erH0zozRAfA5zWrhh1AM5ajLUl4=;
        b=bL1QSJHZ1l3pKsCzJyaQ4wSuPPNn+3DDI1gv6BdNTGPK26b2+gTUg+G+Gw+qZ25nnu
         sisGqgl49rBbUn9Y1umoEWbDzbCM29se3IHTMS2YBgdi1/LMEefMOc8Allo4k1RiDudP
         JKJJck/pHEUPrJ7U562TYEb898OMjF7SGYZOGEd5IdHDKnsJO/FTkisncppKuHEMfds3
         WGv8wZqkERpRWfFnI7+SsAWlnFtsvtVDxNTZYf90s6ZAlfwF0nQ5l/IpCisdsimSRCoc
         ghMoRh96zbjYQpN54T4o6a1T5U/HKcp2O8ZIFLFtfOEjrqpddJjaTE1A/qNMHYwNPlqJ
         FMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725949915; x=1726554715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QHHDxP8q1G6s76c8erH0zozRAfA5zWrhh1AM5ajLUl4=;
        b=SoD6cBdPU5IzZ3pfl+RrXIjUCvfmkarrFf3dMBCj3EiQc26oaCCsLxfMSTUBZVJOTN
         yGKwyWTqV4idSuvU74gUNpeamrIHOJH5LAt52T4A4x8so24xFCkLIpczsQajDRn8Atq4
         4FCXo/QR7UdSaCsXsRrLFzFZcRHUMhwS58cwdwdyGPQxhE5MmKrs1CeIzNrtIKa8gRYu
         MkHDthwzu7dalEmS/LzJwAFDPH2GS45Fvh/9Z21b9JE5aD9zqC6LN5uvgwhA27MmbbxD
         aXaZLir8/l7eU8sKPJGvmhM61GGjY29OikK7xuZp2P/Tlqtnvzkph8oki1bwDVSxoYWx
         A95g==
X-Forwarded-Encrypted: i=1; AJvYcCUxw0RTCVguM97BPAAfqYzIt5U7M3XheEnyUTqvz1zFp1tnJ0elNwd9Cj/pS/RlDOk7GDVpkNWTepD8@vger.kernel.org
X-Gm-Message-State: AOJu0YwzeOYS6XlgIMtC8hf27h0CJN/rispiUhFyFPhj/saAQMabo5bL
	u0MGdsHMByFx98e2Dc2A31J32aA5IHUEu4Fvdy3ClpS0prwOfSGjqTDDqHxizbBbWbsU3tOPsK2
	QigEBS32xGD1wjTsxuV1LuOicDp5Ja8pm
X-Google-Smtp-Source: AGHT+IH+7EEc+C2nGHJwLNTOiThWrJQIkEF3cND3sycvQdbIm3Qrf4Plp+uRx9QJO0EjbFk8/NH4qpMM4wHQbWeDI/U=
X-Received: by 2002:a05:6512:1395:b0:52e:764b:b20d with SMTP id
 2adb3069b0e04-536587b4d0emr7807964e87.28.1725949914702; Mon, 09 Sep 2024
 23:31:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829115241.3204608-1-liyuesong@vivo.com>
In-Reply-To: <20240829115241.3204608-1-liyuesong@vivo.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Sep 2024 01:31:43 -0500
Message-ID: <CAH2r5mt4TNMYe73UJCA_VLXMCm+5p48yDL7dEprJc4fgr0+tsA@mail.gmail.com>
Subject: Re: [PATCH v1] cifs: convert to use ERR_CAST()
To: Yuesong Li <liyuesong@vivo.com>
Cc: pc@manguebit.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Aug 29, 2024 at 6:53=E2=80=AFAM Yuesong Li <liyuesong@vivo.com> wro=
te:
>
> Use ERR_CAST() as it is designed for casting an error pointer to
> another type.
>
> This macro uses the __force and __must_check modifiers, which are used
> to tell the compiler to check for errors where this macro is used.
>
> Signed-off-by: Yuesong Li <liyuesong@vivo.com>
> ---
>  fs/smb/client/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index c1c14274930a..c51b536aa9ad 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4069,7 +4069,7 @@ __cifs_construct_tcon(struct cifs_sb_info *cifs_sb,=
 kuid_t fsuid)
>
>         ses =3D cifs_get_smb_ses(master_tcon->ses->server, ctx);
>         if (IS_ERR(ses)) {
> -               tcon =3D (struct cifs_tcon *)ses;
> +               tcon =3D ERR_CAST(ses);
>                 cifs_put_tcp_session(master_tcon->ses->server, 0);
>                 goto out;
>         }
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
