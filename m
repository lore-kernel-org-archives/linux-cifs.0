Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2B2F0C48
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772043542; cv=pass; b=hy4CLXRd2OWBU0c/1HtST0NiPJAm+avwRdpVhvcLSdpoehwegihKckHNGnxGz7tqwFUvACu31JXcrckLAqaeyEbuAO9UxF1DHMrsXGTQTP36cu0lCQiRSHFVRvqX2fJ+b6YzCB1tqRlBrS37MCwFJuVApCNmtx7JgslC5WTF4EU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772043542; c=relaxed/simple;
	bh=LRDz82JED2xeQckEz7H9ChbpfUpio2zNn3f/OFDohv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhGujbm2ciONuKxNRYnJOvevOmpf0x0pgkMf22zFDgGAtjKODRyWkrAo/lhyAHhaE4jV2793ie9+ODwxTpe9VvC0dFQnLHZdOgv3SG02Rz6V0ombGtP4CtlyS+vKtBJudveQPJ5F8pO565vb25+gg3+Rjq7fYFRuksxQQ7uz/Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com; spf=pass smtp.mailfrom=enakta.com; dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b=MmZQJqoD; arc=pass smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enakta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b="MmZQJqoD"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so5813261a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 10:19:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772043540; cv=none;
        d=google.com; s=arc-20240605;
        b=D9l5+HGqcCecLlvNI5dTMXiLg4oGVbGf8dwW+fGWRllpQy+cyUrhNSENYWd3F5dnuz
         WdoAGyXdCM98CAAJxjTPpPhWelosmiVnbMdDsDCvdH4eIcE4vAe0glxCqL4wM2o2e/zP
         TekUtRd7GQapdt+JDTmmGsGRWUArUJvyYN/kJoE891H1kMa6ER6+8E1yCZdRTKgPvD+m
         DIeP88h6nLnIckDCYX1dz+t/qXmoEnYTMkl9o45vDb3NqxhhM6yk8g5Q85HYgQDw5OSK
         I5SMPp9UHp2N1zJCv5kqzO2OzhrrJW8m9ZCzh9Hpmw2iMxTvYQkglO0f3If1WOfSf+aN
         8eyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zUmyD9mZSPiz34Jxj++5qqJO6oRTMfL2GZK09sjFXQc=;
        fh=IC4dYosEsdX1pI0u7/smn16KgxSOLKL5tWaBtRSFqmg=;
        b=lQtCUQcUPzm3gqjxOdLQ5oHIt/RW4XTGnOqcV8icZRSSVvndfI7uun/bivg6dpzspy
         0LIqrnRhUQkmxDA/ZCLbl1V5odlUpqcoJQ5Lnj3DwQUyBcZrsLBH4TaTrwyWuIDQJ2vL
         8IXoJdqCp9RtmFygyFvvEmFPegIKrQGvs8h9f+zYr+TxNuIKSoyzblm/zPMXGvcqxaoF
         9KAZmYoX2EibT1mjTxP+ih2MSMA52YKUHIVU6WuzUboajJrFpB6ViqL3nTFplOMPUsb0
         ytz+ZCuC0y7ZJPHvdmbQiv8ccqm0cUhx2vkCLVA1Dg/2IBVSCHRFTgTcXmfNWmOkh3PI
         cUjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=enakta-com.20230601.gappssmtp.com; s=20230601; t=1772043540; x=1772648340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zUmyD9mZSPiz34Jxj++5qqJO6oRTMfL2GZK09sjFXQc=;
        b=MmZQJqoD8T6f/BYIYZM9jMLo0IgFRm0gJg3J04nFvOuk26Okp1RrUIkemPRUtRiaIf
         I+SCGX6To7W7CkBeE2PnGfjc9eW4rDeVVwuYDRqWAk8nh0yVSW/FRnvWcfkoOYW3YiGW
         Q4TRsim46L7l90IZKcKajJo6N0qfDbiZ8+s1GRomPftbQQv9c7PrTEUwTO1jBTFHALMD
         kg54Ei0mvOZOLPGAylyp8Vu7Dx/EBpgA6i5yyEd3hK57IvUFpz8pN81Iyh01vfnnc5gy
         BtnlXTDKqywozw12SSDF/GtRLZvSdzAuVlqZ5aHUdIu5jJ5CAHYChBmAY6L3S/uysoPn
         xtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772043540; x=1772648340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zUmyD9mZSPiz34Jxj++5qqJO6oRTMfL2GZK09sjFXQc=;
        b=c1R8gv+7qPeK0HlnW7DqamiC6fBBIPJQgkQGjFBcrPW+E0Si7bMCh5OPiiYbYYUs/C
         qqIFRMfeQ3LKKa8jtyWlT4DqXmkkCuTftyhrysDOmIja1yZBacUZ5J4TPnAQLtt2Z1L7
         x5nERXUBXwLWoeUJm2l0kMhEvifddZS957dDPBMfIx1s/EcW/4nLyvO464dbxTDB8vSW
         bLOpdzzCCJLYpQxhI98CQ9ZSGJNSJ+4QGO+MJZ3oW0UROLM8tV+OkRyxUmcJDwDpAIQ6
         33mEmVCAJzZdSx1X6qJxPQighSRmh44z8O//Fsp/l8LTGtyJlljfHWdFyLvhITG12eRV
         bQsA==
X-Forwarded-Encrypted: i=1; AJvYcCXYF4Ucnt1G3G12nh3s0TEe6qdOjBcRVcZ0u/ZCxK5JDL9BTrd8ieNVvBCFsgqrZxle2To0AGbwuhri@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfzb0rTOcOxJG+mxZBLHqE5IWBpOLmXiQ5M48FmQyOM9mDNNCy
	sGILgfo2di+h5iscbd6CSTBLByoZEMRnzqZHARZjmEnoduoisWorjW9uTsNsa00BSwrjIf712JL
	DQKeobND+QaAtRVTCtXDq7gI624ZlOrvQVO5umGgn6Q==
X-Gm-Gg: ATEYQzw/l3QVAwoBXyLEXNe5nhPe/tFZwiI9ywY0Ur48GlW2IJdnSeylCA88E2I2Diu
	QvO4T777MAIfkzLo8aAr9k6rfTDVEqijC4GEJftFJ9019QKCW65EF0/cu6COcgoxmN+zcuyGSz8
	lvb0/OB0UcQCiCMqHKLCPFG9bR1usOsN9eaptesE7YbJ8VnplaPtEy3ooMaNJSFGBFTbSR/RAVg
	1D65N3iOkqRrULsi7lHD4j98KQIIcgHGQQv8yIU/DpPZXdSo6fqBX+25tFNQOD+nFvKJUKscxkJ
	6RQurn4V5H/MKMubxkLsQlpEK/xi/8bzi0fPxeudP9B4zJu29NYvBOfNHpW2IYaZbaCrmYaDryg
	KV6o=
X-Received: by 2002:a17:90b:564d:b0:354:9c20:83e4 with SMTP id
 98e67ed59e1d1-358ae7c8ae1mr14170605a91.2.1772043540402; Wed, 25 Feb 2026
 10:19:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
 <CAH2r5mvcrt3T9x-Wqpz_OXVr9cWtBSft=JpASsFDT25CYtXJmw@mail.gmail.com>
 <f47fdd45-21b9-45cb-b322-d7de77b6bdea@talpey.com> <CAH2r5mv-JuF3GgyMdpSnaqazT4xP9U_8PorRiVy2Pt_v5bhSbQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv-JuF3GgyMdpSnaqazT4xP9U_8PorRiVy2Pt_v5bhSbQ@mail.gmail.com>
From: Denis Nuja <dnuja@enakta.com>
Date: Wed, 25 Feb 2026 18:18:49 +0000
X-Gm-Features: AaiRm53y-pSZ_FU93QPHGKjNKt5HSaQemliMXq6RInicI5L2X8bpkZvQbudDpQQ
Message-ID: <CAGk60SFUePkcYAWJmAYVMU_MxB6y0XuaMBoDT_ze5R5+Vxi7VQ@mail.gmail.com>
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-kbuild@vger.kernel.org, Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for looking into this Tom and Steve :)

Cheers
Denis

On Wed, 25 Feb 2026 at 17:09, Steve French <smfrench@gmail.com> wrote:
>
> Good catch
>
> Thanks,
>
> Steve
>
> On Wed, Feb 25, 2026, 11:08=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>>
>> It *did* reproduce - you saw the server config, but the client
>> config was not set!
>>
>> I bet this is the reason that Ubuntu and other distros don't enable
>> client SMBDirect by default! This is a significant issue and should
>> probably be fixed in numerous stable trees.
>>
>> Tom.
>>
>> On 2/25/2026 11:48 AM, Steve French wrote:
>> > It didn't repro with 7.0-rc1 when I tried it. Any ideas?
>> >
>> > smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ ./scripts/config
>> > --enable CONFIG_CIFS_SMB_DIRECT
>> > smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ make olddefconfig
>> > #
>> > # No change to .config
>> > #
>> > smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ grep SMBDIRECT .c=
onfig
>> > CONFIG_SMB_SERVER_SMBDIRECT=3Dy
>> >
>> > On Wed, Feb 25, 2026 at 10:24=E2=80=AFAM Denis Nuja <dnuja@enakta.com>=
 wrote:
>> >>
>> >> Hi everyone
>> >>
>> >> CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=3Dm and
>> >> CONFIG_INFINIBAND=3Dm, despite all declared dependencies being
>> >> satisfied. The option is silently dropped by olddefconfig and
>> >> menuconfig refuses to save it, even though menuconfig displays it as
>> >> [*] (enabled).
>> >>
>> >> Kernel version: 6.4.0
>> >>
>> >> File: fs/smb/client/Kconfig
>> >>
>> >> Current dependency:
>> >>
>> >> if CIFS
>> >> config CIFS_SMB_DIRECT
>> >>      bool "SMB Direct support"
>> >>      depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CI=
FS=3Dy
>> >> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
>> >>
>> >> Root cause:
>> >>
>> >> CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=
=3Dm
>> >> and INFINIBAND=3Dm, the left side of the || expression evaluates to:
>> >>
>> >> CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
>> >> =3D m && m && y =3D m
>> >>
>> >> The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
>> >> Kconfig engine coerces m to n and silently drops the option. The righ=
t
>> >> side of the || requires CIFS=3Dy && INFINIBAND=3Dy which forces both =
to be
>> >> built-in =E2=80=94 an unnecessarily restrictive requirement.
>> >>
>> >> Additionally, the CIFS=3Dm/y conditions inside the depends on are
>> >> redundant since the option is already inside an if CIFS block, which
>> >> handles that guard.
>> >>
>> >> Observed behaviour:
>> >>
>> >> menuconfig shows [*] SMB Direct support (appears enabled)
>> >> Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=3Dy to .=
config
>> >> olddefconfig emits warning: override: reassigning to symbol
>> >> CIFS_SMB_DIRECT and drops it
>> >> scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect
>> >>
>> >> Proposed fix:
>> >>
>> >> Since the option is inside if CIFS, the CIFS=3Dm/y conditions are
>> >> redundant. The dependency should simply be:
>> >>
>> >> - depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=
=3Dy
>> >> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
>> >> + depends on INFINIBAND && INFINIBAND_ADDR_TRANS
>> >>
>> >> This correctly expresses the intent (RDMA stack must be present)
>> >> without the tristate/bool coercion problem, and is consistent with ho=
w
>> >> the surrounding if CIFS block already guards the option.
>> >>
>> >> The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
>> >> identical pattern:
>> >>
>> >> depends on CIFS=3Dm && FSCACHE || CIFS=3Dy && FSCACHE=3Dy
>> >>
>> >> which should also be simplified to:
>> >>
>> >> depends on FSCACHE
>> >>
>> >> To reproduce:
>> >>
>> >> # Start with a config where CONFIG_CIFS=3Dm, CONFIG_INFINIBAND=3Dm
>> >> scripts/config --enable CONFIG_CIFS_SMB_DIRECT
>> >> make olddefconfig
>> >> grep SMBDIRECT .config   # empty =E2=80=94 option was dropped
>> >>
>> >>
>> >> Cheers
>> >> Denis
>> >> Enakta Labs
>> >>
>> >
>> >
>>
