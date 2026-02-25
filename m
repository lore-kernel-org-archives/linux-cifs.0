Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33F3D3D02
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038150; cv=pass; b=heTX2ynlO/KGLdsi5yrMXqPzIEX7ZAPn4H4EgSV4IE4ghlRQPspPBVn1LI6byULupMZFKoF3y6nbmPAbSe1ij4pGCKk/kbBphUrKhg8ywu46j3r5FWw6c/e5TPdgDU6Mv+h36F69l12WWndwsdZ35D3bWplS4Pj2Y41Jl8KevcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038150; c=relaxed/simple;
	bh=qUcBfUVCJMHQ02HDUivowOpgA68okT+NNgCAK6huiPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tn2gwjTtg3yKkqt+ptTEzoMeDiKTnUIN+jmsHyBhPK88sdCWWXRdakTYu4y+Mi9v6v910vOirrXfUudVqynET2xmxhsc0YB5izw/NCzId3f0T1mYrvZjS6RpY32XXAFShRqMyBx0QysvWd7vTU6/a7BZuXhHVWpaNZFsk26JPE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7V6jOwa; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7V6jOwa"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-896f44dc48dso62943736d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 08:49:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772038148; cv=none;
        d=google.com; s=arc-20240605;
        b=J1zaNg+KYQa9d2CJJj7Ujg6Lv+sW2WHiUCDPztd05eCKmoNTBh7+Xd0r0x8Tbcbvnf
         mvQSGP9o/ELAmnlhRk9zjmy2AXN7tnRcQ4UvGzSfu4zlo69QPQNjWHSKyAVJmcQtcA//
         JCopmlEF+6RX9vG3p9JWdq0hUECcPGTl3MEPuH9kBIgL8MGc+ZTnwXdFIjKNIsZSNjre
         ot27HZW6Laxsugrtwu/MEHbKy75OADU8BNqd0DpAMBlL+nzdxXtV1HwBu2Ei54dymBcK
         1g5lm9TvynCFrudNWaaJRx2n5RuQrz+GQ0Vc2FuuPTUqhS8NX+ivwrUvavY/3pZigA0Z
         elrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c5ZB9cOqF+3obiDHat6tao77QSa8bRb2BeyDLbs5Nxc=;
        fh=hjypnCz1rKtuhN0ly/Yyg4pcVoZck+sguE5NgiK1G8E=;
        b=W7Q8xn2T9mbf8+c8PFdP6aLwXXkSc9IESkLXAILNBzCJDYvCuO5mgsZRoq+vcXTHaF
         gSG16+2nyiGHIuBmFs4Z1niFLZTLj7i+gvpNvxVVw19lAPuQ5Le5h51LyILjX73IADpZ
         LzT89SDfpnjgnrGNneelkgVa8hYkK6hogj7tHpFMMZURkUMVFk3F+bCt7HE6N65bEPT0
         sxtuTrdlgbB0ugVuhrwql8umOh8N+LfgbQQgQxguAS6Jr8f35vbzCe+hyruHQ8NSGcuD
         0l4dHV0kd+iSpXGZzYWGrSvcTGqudBpZzQpDa/5f3LDaeO6qhcUumwq6YbEDkF9lPKa4
         LEew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772038148; x=1772642948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5ZB9cOqF+3obiDHat6tao77QSa8bRb2BeyDLbs5Nxc=;
        b=b7V6jOwaPrT1J0osWNvxTb29b1RaaKyy2aNIRhCwIf/5ahh2BoTMll9tG9G9wrzzxP
         p+MQ5opSDOAHOne9APBLPZ9K5W8hgyz3LP0eM7Z8E77gZgigcq8cIwpppEhWQBdH1Qyz
         YZ3rY/6gNZ2MKrlJ6NLXd9U8rA+hnaPE7A2l18J8J5fcik4CMwVfU0w1m42fO8pVVN6u
         nHCAu5dL42bPoN9oi7AJGFvag+bDxCo3MRFD4inN0ga5JozR0SFxOueZF0V4V5gz83K5
         aoHoX3lTXa6RtNztDvLnQN7HLkWaIT0BJOZtujLJ4bHxerLvOd+S0TV1XJQ4bj2vnMGA
         +bJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772038148; x=1772642948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c5ZB9cOqF+3obiDHat6tao77QSa8bRb2BeyDLbs5Nxc=;
        b=Y+DCUCNuTLb+OMZg3jr+O4p606bmL9I5w6uPXT7X+Np7Eny1snUO1u4LMiuVmDWrTx
         TApiwROeEx/finDH9+HoEcMQPI+SL4hjI/2A8fizrkQ7gCjJVyLVlfmcRwafPxbvR62P
         vOqmVIZt35Nqlvvexku1RU7ZHJxvbgnkhObL/27tUAa2gBDnd4BAzQIkdgSWlKDTWiTI
         ok09YNks71edHl7ZOCIxYUePn8cg7Em+cNs7AQzoxFYdzc/pnZy60u3ti2kS527a2GCi
         rd2Ir4j0GxIfxXyMTg0XEiP9hQgM/bLffYgC3U3vEO/WJMnZpaY4LKLKOucjS0cbztOj
         8Vnw==
X-Gm-Message-State: AOJu0YyE1N9kxe9lbtVtlTJZF2Jrxd6PIaUTQmfqZyu/DgNutR4hUiNo
	/SWa+kbp/m7r05aBH01wzOWKYWPeJUl6AiKNY0lsFbP0oKFCgHzxlARpd8TpCDpK4bQwm+XSQYM
	cp0euqSya9n2Ro2YdrkVbftE3g8ujbMI=
X-Gm-Gg: ATEYQzxz0tvcRp1NAsqFulQVaeCXyxZ0lYDxVnBBPYCAodY7yKURrfoZi1NF6F9YR3W
	IL/XyuJOIPbFsNVTwQKupner0gcDxcoHSsTsjraYHAIONwNHRn7gtkEGg3Nsp/wsIK6LcHAmbuu
	gX2bQDTNMeLWKH09gR6LowSFjXj7y7kh/UbbVGSJeBzD60AhlYTXn3tJEaolQMJaQfaTxkqv0pQ
	m3SUf5h4eCoNFokzR0qbbS1e2zKWvSHxn3NqOJLQEi76OmntAyvQ/j/xosPihKlSvxqo4zqnXCR
	Fp+Ffjo+RvllCccWUdlQzfr7H9FFv2s2dH0gS3JYm8KyCwn73cjjgplNdmyAy34hpjezo3H9wuz
	mRN/b2t0DPrLq7i5forAQ8swPYDTHj00FIrnxn9yASgmhH3oWThPtvp5OwnvkqcU=
X-Received: by 2002:ad4:5aa6:0:b0:88f:ce04:3261 with SMTP id
 6a1803df08f44-89979c3bdf9mr237199666d6.6.1772038147473; Wed, 25 Feb 2026
 08:49:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
In-Reply-To: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Feb 2026 10:48:54 -0600
X-Gm-Features: AaiRm53yJClvWg8bTS6f_4qJmoNm5UPG5U2HBe0cLcAxbG_AlHCfRnAmxbyr5vo
Message-ID: <CAH2r5mvcrt3T9x-Wqpz_OXVr9cWtBSft=JpASsFDT25CYtXJmw@mail.gmail.com>
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Denis Nuja <dnuja@enakta.com>
Cc: linux-cifs@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It didn't repro with 7.0-rc1 when I tried it. Any ideas?

smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ ./scripts/config
--enable CONFIG_CIFS_SMB_DIRECT
smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ make olddefconfig
#
# No change to .config
#
smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel$ grep SMBDIRECT .config
CONFIG_SMB_SERVER_SMBDIRECT=3Dy

On Wed, Feb 25, 2026 at 10:24=E2=80=AFAM Denis Nuja <dnuja@enakta.com> wrot=
e:
>
> Hi everyone
>
> CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=3Dm and
> CONFIG_INFINIBAND=3Dm, despite all declared dependencies being
> satisfied. The option is silently dropped by olddefconfig and
> menuconfig refuses to save it, even though menuconfig displays it as
> [*] (enabled).
>
> Kernel version: 6.4.0
>
> File: fs/smb/client/Kconfig
>
> Current dependency:
>
> if CIFS
> config CIFS_SMB_DIRECT
>     bool "SMB Direct support"
>     depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=3D=
y
> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
>
> Root cause:
>
> CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=3Dm
> and INFINIBAND=3Dm, the left side of the || expression evaluates to:
>
> CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
> =3D m && m && y =3D m
>
> The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
> Kconfig engine coerces m to n and silently drops the option. The right
> side of the || requires CIFS=3Dy && INFINIBAND=3Dy which forces both to b=
e
> built-in =E2=80=94 an unnecessarily restrictive requirement.
>
> Additionally, the CIFS=3Dm/y conditions inside the depends on are
> redundant since the option is already inside an if CIFS block, which
> handles that guard.
>
> Observed behaviour:
>
> menuconfig shows [*] SMB Direct support (appears enabled)
> Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=3Dy to .conf=
ig
> olddefconfig emits warning: override: reassigning to symbol
> CIFS_SMB_DIRECT and drops it
> scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect
>
> Proposed fix:
>
> Since the option is inside if CIFS, the CIFS=3Dm/y conditions are
> redundant. The dependency should simply be:
>
> - depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=3Dy
> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
> + depends on INFINIBAND && INFINIBAND_ADDR_TRANS
>
> This correctly expresses the intent (RDMA stack must be present)
> without the tristate/bool coercion problem, and is consistent with how
> the surrounding if CIFS block already guards the option.
>
> The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
> identical pattern:
>
> depends on CIFS=3Dm && FSCACHE || CIFS=3Dy && FSCACHE=3Dy
>
> which should also be simplified to:
>
> depends on FSCACHE
>
> To reproduce:
>
> # Start with a config where CONFIG_CIFS=3Dm, CONFIG_INFINIBAND=3Dm
> scripts/config --enable CONFIG_CIFS_SMB_DIRECT
> make olddefconfig
> grep SMBDIRECT .config   # empty =E2=80=94 option was dropped
>
>
> Cheers
> Denis
> Enakta Labs
>


--=20
Thanks,

Steve
