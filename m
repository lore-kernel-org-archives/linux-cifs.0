Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9732EE617
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063067; cv=pass; b=QTjXY0Ri1PDgYmGRhBMpaB6KAq+0FGN29G1IEmTV972fSqVMNZlc0s3cMiAZxWYdIM6LRDeRRq2EzhUN+rJrtOYaKDUtXmFFCleLWAjEI3jz89PV51atqoz5ub9wncG6iufAOpVYvBgxva39RTkye0O3eaTshlYVapDK6VZa7kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063067; c=relaxed/simple;
	bh=XdKE3yy8wq2vvQgm9uACWKk0p0lqSdkMYrlPacxCtKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LetvzYbZU2BfXrLZsp5I/vExsGvZqeOYO2B5AdZhYWs6XRxki+7godcBE8LIS/5ySrPjmIXyWtJNq26Qni4s3AKSfaEFSqlL4z1185wHnBGMoHa5p0upR/yuqK9aW5U7Lt4WUNQl8RP2fRUHUom+3pX247EU3FU2M0lqRGojM7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5yBgpzO; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5yBgpzO"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8972a14e27bso3456686d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 15:44:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063065; cv=none;
        d=google.com; s=arc-20240605;
        b=EUSKNhf098qT+GN7ztk1uBJkTHpmaITeBkLWlh+CPonzg0xUWQmhNvq436WRbkbXhR
         baQt1MIELi5AeZg0dvm0RdqHWMHwTFL2KYXnskB6U3Ys0ihABNnsBAo7D6T5jm60YjZu
         EC7+dhReQA2U8i30WtQQUPRwNNNhqhE9+KC/57N4/KzJ+hlEAiyhTeWLA9/0tIIXmS3L
         vaGOPdLCzlUTglMmZyyReFLBe+yrhTWchv/LidcdLokiLrLDhGnBRNItkONwVHmTXuD2
         nMVankqUzrmre67dd3mfeuD0KhQTp/bR6sj3iA10CcyJYuUPdYBuBA72SaWSGRFZvLE1
         eLbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aX/9nbCzmF+1Y2euIFT278sMLN+4qQZ+ZIeORha/tRY=;
        fh=hjypnCz1rKtuhN0ly/Yyg4pcVoZck+sguE5NgiK1G8E=;
        b=MTD26WWAhCFhJIOGk51idCMoYt0lDDJIzsRpyOq2l875Kurb8PuKSFn2O1c+JrRGR+
         NQ8XtR6iKSDT4W4X/Ipr4BjhzX8fA8X631cn0mPddmFOaY8USYaQF9H2EuU+XV7vHi4Y
         xNYDuL6qWS+QlBQB6ipx1zyeWMgZgJceS4oQ/gFoFDXJJHnnPYk8nLy4qW6wBGpd3jAB
         Gr26d7Ig35TMYOm9t4E5QmY7s3YuQiHONSHsRAuGq6pXh2xsKf4u/wImYc7wE0TX3Gev
         f3L6ESveShY5YXJ/OO5u3yd1PS2VhoGOVu8vlog/joaCPGwYoe0aurVdKTCy8EHt1IEO
         QjEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772063065; x=1772667865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aX/9nbCzmF+1Y2euIFT278sMLN+4qQZ+ZIeORha/tRY=;
        b=k5yBgpzOiSKajjVkj4aLuVhyNW7n2gViJDsqNCi+q2u5LJq1X+uOHuzIZ1laInCQQn
         AOEih7Tls1MNmz/NTmtKxIk36Qfm3jZYLGPo+Wq/45l7MFIbNOFCnXkQeRXkYTK8eBsF
         EU+o9hNjo1hTQBpl1q9HOgmU1JWDYKAi4A59eWkLKx4VOVBrVdP/gynrg/65laBUkag/
         YlOH8FViDZ92HxDwIQO9QYV1Kxr6kAHuO+Rl5+f8AXYYuujLDcanF+qVAR/TuADY3uUa
         pqr+e/xjiD1mhI2/I2izfpahiVophWK8jtp3Td7MufOK1K4SwMvcPVdAWJdZ/WRLbfw8
         28zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063065; x=1772667865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aX/9nbCzmF+1Y2euIFT278sMLN+4qQZ+ZIeORha/tRY=;
        b=EWB+M+nLjV0UGEM8MXO4dYSq7STmpdZr30VXxCkXSy0HJDAOG4wwX5+HwM3GVXQ9OE
         IEpL5v/qVcnJM3xL5WUfSkP8yneHgAuSXg7bmbJZHQ3HjGfIqDe8PYIETIYDji/3s14Z
         QOuKceDi62+U8XTzyNvMkYl+7LN5MrY3z7Jmlce4U/kJuP2UPu7AHGF0SZtYJ/H/6XAU
         7dZ37zhU8YYnpPYf7U2Upw1p79OgMQ+sXBLHoekN5Yq31R6hAvLilG9Z0/0k/ep8xbUk
         qQ3Zl1ZcwV+hc/CbX49EhpmsSCqenkgx6YxznIhKMeSgYN3H9suY3CGWBpMLGmAkZi18
         BBzw==
X-Gm-Message-State: AOJu0YzsGmb5vCi+AWOfWc78ToxJ5AsKeEzoDLCFKcZ9Q6vwuCNd9ccu
	2xuH/FkNENP0MWDeyRYitRGv/XOSOIZ9DV60nM5G3YSOjZgIRUnwtNHCLiEL2KuEQyhS9wzZDAO
	YRuaLc1bIXT6qxRJ/5azEOot8u2No0B0=
X-Gm-Gg: ATEYQzyhrBojtREaVUzEvYwAprl+1voEGUUIhRQgKqPqDpOSJA7bvWV49r3TP92TOqY
	97rKjVCHmaTr/N9qmFqroVwytOc5cy7QetU3bmihTh5H3/IMczXw8CkXyvoZcUVTNFJOsdyHA77
	BQBxJpUusmwOwOGkAu0bN874QCkNlx95zOXGJU9qM0aILedRaew1VE+ItOK1FREjR1ETg09n52E
	xXDPywjfwULFggC0N1d8j7sovnWLRGYwS9PFmlqidgXz6gncPQrQz+rh6Akln2sz+mD7NVxf7vZ
	Lc1TcLblpGWokF+7CsHeJidAQXZu8AVjTYilsrENcUtp+oVZyc+4oc9QPxjVO9Uey2k/th+Gtcj
	7c4YTL6755syhGCq1I4mMGnjUwR1j3i8F4lFUP82O14XAM5wR2sTNVeI3DsNnX0Y=
X-Received: by 2002:a05:6214:c2e:b0:895:4b79:83a5 with SMTP id
 6a1803df08f44-89979e1bb72mr255943186d6.5.1772063064749; Wed, 25 Feb 2026
 15:44:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
 <CAH2r5mvcrt3T9x-Wqpz_OXVr9cWtBSft=JpASsFDT25CYtXJmw@mail.gmail.com>
In-Reply-To: <CAH2r5mvcrt3T9x-Wqpz_OXVr9cWtBSft=JpASsFDT25CYtXJmw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Feb 2026 17:44:13 -0600
X-Gm-Features: AaiRm506jZKxMy5M-FfXTya2AEiZlvM5b9TBUAOlxpKMdmSwkWkP6Pu_5WC8u1I
Message-ID: <CAH2r5msOakDTcskvxWEy19Z9N3OaR91qtDDfPQWRTVbizjDR3g@mail.gmail.com>
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Denis Nuja <dnuja@enakta.com>
Cc: linux-cifs@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Are you sure you are grepping for the right thing?

> grep SMBDIRECT .config   # empty =E2=80=94 option was dropped.

You grepped for the server, not the client config option.  Can you
repro the problem?

/cifs-2.6$ grep SMB_DIRECT .config
CONFIG_CIFS_SMB_DIRECT=3Dy

On Wed, Feb 25, 2026 at 10:48=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> It didn't repro with 7.0-rc1 when I tried it. Any ideas?
>
> smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ ./scripts/config
> --enable CONFIG_CIFS_SMB_DIRECT
> smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ make olddefconfig
> #
> # No change to .config
> #
> smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ grep SMBDIRECT .conf=
ig
> CONFIG_SMB_SERVER_SMBDIRECT=3Dy
>
> On Wed, Feb 25, 2026 at 10:24=E2=80=AFAM Denis Nuja <dnuja@enakta.com> wr=
ote:
> >
> > Hi everyone
> >
> > CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=3Dm and
> > CONFIG_INFINIBAND=3Dm, despite all declared dependencies being
> > satisfied. The option is silently dropped by olddefconfig and
> > menuconfig refuses to save it, even though menuconfig displays it as
> > [*] (enabled).
> >
> > Kernel version: 6.4.0
> >
> > File: fs/smb/client/Kconfig
> >
> > Current dependency:
> >
> > if CIFS
> > config CIFS_SMB_DIRECT
> >     bool "SMB Direct support"
> >     depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=
=3Dy
> > && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
> >
> > Root cause:
> >
> > CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=3D=
m
> > and INFINIBAND=3Dm, the left side of the || expression evaluates to:
> >
> > CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
> > =3D m && m && y =3D m
> >
> > The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
> > Kconfig engine coerces m to n and silently drops the option. The right
> > side of the || requires CIFS=3Dy && INFINIBAND=3Dy which forces both to=
 be
> > built-in =E2=80=94 an unnecessarily restrictive requirement.
> >
> > Additionally, the CIFS=3Dm/y conditions inside the depends on are
> > redundant since the option is already inside an if CIFS block, which
> > handles that guard.
> >
> > Observed behaviour:
> >
> > menuconfig shows [*] SMB Direct support (appears enabled)
> > Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=3Dy to .co=
nfig
> > olddefconfig emits warning: override: reassigning to symbol
> > CIFS_SMB_DIRECT and drops it
> > scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect
> >
> > Proposed fix:
> >
> > Since the option is inside if CIFS, the CIFS=3Dm/y conditions are
> > redundant. The dependency should simply be:
> >
> > - depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=3D=
y
> > && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
> > + depends on INFINIBAND && INFINIBAND_ADDR_TRANS
> >
> > This correctly expresses the intent (RDMA stack must be present)
> > without the tristate/bool coercion problem, and is consistent with how
> > the surrounding if CIFS block already guards the option.
> >
> > The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
> > identical pattern:
> >
> > depends on CIFS=3Dm && FSCACHE || CIFS=3Dy && FSCACHE=3Dy
> >
> > which should also be simplified to:
> >
> > depends on FSCACHE
> >
> > To reproduce:
> >
> > # Start with a config where CONFIG_CIFS=3Dm, CONFIG_INFINIBAND=3Dm
> > scripts/config --enable CONFIG_CIFS_SMB_DIRECT
> > make olddefconfig
> > grep SMBDIRECT .config   # empty =E2=80=94 option was dropped
> >
> >
> > Cheers
> > Denis
> > Enakta Labs
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
