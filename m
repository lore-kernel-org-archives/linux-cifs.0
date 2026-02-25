Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375B374734
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 23:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772060769; cv=pass; b=lCjDGsgstyVr19/H/PFee04EnuDp28qB1Y08AVLR60oBSlzbjR3svW/xC85BLS1+VuVXoZUBISZHW9nlAU4c6kXUPCFficvEnEHohjsH39r5uZnJBpoWMvkiecJWKmywHkbYF1NRrAlA+Y2lGYIkoXsAiF7cAsCJyhive+AU8gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772060769; c=relaxed/simple;
	bh=slOEbYemEfCyMn9kbsAqfk2eTY1SotE7lLrt0UcwR50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSC/lSjG7uuUolvUgYrlArdnG+fjAiP1PJPwuOZpW1IB+zXyDiMWkpbkPMNfoOgd8m/vsTUtbwISUNCsnCHnPnXqqCuZPopR7RsQ+BFitTSfe3EllkiWWl9vGPwZ4Z59a+bYfuHtDc1PftTHhxxQ7MM0lwhW1XdhP9+3sOZBXu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com; spf=pass smtp.mailfrom=enakta.com; dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b=dJ67xo4I; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enakta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b="dJ67xo4I"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-358ed696623so36804a91.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 15:06:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772060768; cv=none;
        d=google.com; s=arc-20240605;
        b=TsX4kCPADJ67TXhZxHL3lBTayoKtOrVthkBt09hbr0A+58vjUnv2IiQGefJVZjHxec
         3AqZNljq+QtM9PMcwmT9mvSQiPHKhyPqkNhvfTy0QnKfkffOrqCzvEJ06JHSvKX2jPUb
         g1AedBJRnArxs9lLmbEZxAY2f8BcTcsTtGkY+Lzz0kkz3GX7FQv+oVxqt6066CXtnVyJ
         9Mp3Ie6BnGum9RT59YlB8z0IjRKu0KgWko5xRM79k2VFG2EKWUESq21JjYLN6gnAuWRF
         4DP5XfWYLZePlW/rbfO3kNnrKbepIpY+/n76is4MM4BA6QsxM0LAmyXnTvoMzbMLKYpC
         1G5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1oR+2sKSuT8g7i9hudQ+Z3EzBJ2PNv6gfLnbNBcE9rM=;
        fh=XdpHtknMr1uO8UnA4bKdwg45vrboHkG7r5Xt16QW5Gw=;
        b=F852sYYHMOXfpzmqhL9iSJccwDHgI48RVRl721wv3NPbyXFWbnNydHFbf3lmK6aooE
         ftwxdy9eUKdYGIg/QHo5PXtoIAFD6lFGGoGdC93LSdxCaZBXhaFjY4dF+Q1DPfJVYqB2
         GNCdKwfPWh6JCSGYpTB6JBJFkenHgOnI5j11qdll4AKbgKlihZTsUZYBujW523SiFYPF
         DTh4QD7Ajq1XC9e01NQPlPOrdZLdW4j8WCp/W/RIdg/X7yVFn58hbOE1fHBIEUHILhNK
         hoV9h3YOD7aHNcZqHKfAeGwkM37m9Llyho32n5md2629ANV1X9na+W6Rxv3ss54XpoDC
         AU4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=enakta-com.20230601.gappssmtp.com; s=20230601; t=1772060768; x=1772665568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oR+2sKSuT8g7i9hudQ+Z3EzBJ2PNv6gfLnbNBcE9rM=;
        b=dJ67xo4Ix5OXglF8bSKyzDMM9t8Gob1brdzQfbnmYQD+/zTCpTFFDHL+LEDzW4I9hp
         xExrrcWuKQT1sVuUccUXFnh7RKjQLqXuYRE41SRNwbaxAabFJIOJBRNHuCIjIqH3pMDq
         O9u2LuYm+lM1mEH0AoGBg71ew3y/WQegdmdPCutU2FxU2OKvJuiFYIJKzWUUmr7tC5z/
         42osESDVdYN2YtwXATskrV1Ah1qgrwGH6uNwGN2/26dKG6wHBAkLjIyfAzMnucaULNNi
         rjwqqhzVPXV6FLYrnzEV/xKr8mJ3qY8D+UadC4n61KM1SjqB6E4P/JYFOBC3G+GXMLJV
         DU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772060768; x=1772665568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1oR+2sKSuT8g7i9hudQ+Z3EzBJ2PNv6gfLnbNBcE9rM=;
        b=OgUwPEdFeZqyQTCPsI8FdzJK1ku+A3ULFfzJk0HlKDyH/aDJNZqyvOh8XHLgVTB7+O
         //z2WJ1IKoO+AiW0F0zm39oVrBeu3pCF1Z1+YjW5mBd4fGFyeCOQvgDVUWdsSiEyBmHH
         0TEIzAA1WldVSApPXSozHxkzYi+8s0PbwgDD6/bNVwEHrVjUs1o5LcTYWCdD2YI73kNk
         W+UNW3pcLcAOYNwzEpPYAZKuTxy/pzlqeaU6wCuRAkAD5J20pkPqSlGx7UFX0hqxq6C+
         z69X5oTUPBubfkCFF+3V/Td5ZTYEdKjHXTkhAvRGNtEG+ib7ewx6EiLaKZUL88kwHrnC
         yK/Q==
X-Gm-Message-State: AOJu0YxeoZiWKFRwYJ0DLQhDv7pwUQhHxU4RcwYueG92W+YUXKOHcwIb
	wGDYJqe/aQMA8e6GGckmd6wSwAp2q0w4q5QE9iipcVcNd8bE9G3wXWRJI7tYlQRPxoLEDgyOkm2
	kXoGyAlw8koR8LzExroCJ1pu0JIaAeKFNdNFcdYI9IA==
X-Gm-Gg: ATEYQzzbezSUBeRivfFonDV/iPEhBmQfOe6prgwp2H56sZe8gVohuUn5XTtPxXiA5ZD
	UF3Iv2X0egvaQvAz1JAxiR6lUIs1eccfiejx2SCr9x+GWTppsOd3Z2JLqzpFWmSBaua4Qa6xgkk
	DaPeRnU4u9TnmW8TTlsfCHyusm5Mr7/jPVQQiRHItGvMN/im5AwfWxcGqtthSPEakufiE6+anzG
	HKShvB+T7GLu6h55AZSHmusquqo/0lAk2pK2cVwF7+x7aEdbtXFS5M/P7LkuRZHCTjgFfi+fzd6
	xsv7aoYYkK+sxWLQiJTis2Scabms5w9+LIutStoMERil6faZ0TBpI8eZbQygg4iUDkaZ
X-Received: by 2002:a17:90a:fc46:b0:358:ee2d:df2d with SMTP id
 98e67ed59e1d1-35928a916afmr1434473a91.8.1772060767806; Wed, 25 Feb 2026
 15:06:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
 <2cb12a60-32f1-4656-8a9f-305bd0be069e@infradead.org> <c7fda6fb-5095-4fd5-ad1a-22319bdf0d4b@infradead.org>
In-Reply-To: <c7fda6fb-5095-4fd5-ad1a-22319bdf0d4b@infradead.org>
From: Denis Nuja <dnuja@enakta.com>
Date: Wed, 25 Feb 2026 23:05:56 +0000
X-Gm-Features: AaiRm52kXr0tv3uCvUgiWWAiKPcU3fFLlyvqaZ5yFoGa8Q9BieQpuGf7F-857kM
Message-ID: <CAGk60SEw7xgSLc5+5EhgOnZkC6PTx-N98R94t5jQZ4wZKRVfkg@mail.gmail.com>
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-cifs@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	stfrench@microsoft.com, Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was tested on kernel tree of SLES 15 SP7 running
6.4.0-150700.53.31-default.

Randy could you please confirm what is in your config for :

CONFIG_CIFS
CONFIG_INFINIBAND
CONFIG_INFINIBAND_ADDR_TRANS

in default builds of SUSE (and probably ubuntu i will check) it is :

CONFIG_INFINIBAND_ADDR_TRANS=3Dy
CONFIG_INFINIBAND=3Dm
CONFIG_CIFS=3Dm

Cheers
Denis

On Wed, 25 Feb 2026 at 22:02, Randy Dunlap <rdunlap@infradead.org> wrote:
>
>
>
> On 2/25/26 1:53 PM, Randy Dunlap wrote:
> > Hi,
> >
> > On 2/25/26 8:08 AM, Denis Nuja wrote:
> >> Hi everyone
> >>
> >> CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=3Dm and
> >> CONFIG_INFINIBAND=3Dm, despite all declared dependencies being
> >> satisfied. The option is silently dropped by olddefconfig and
> >> menuconfig refuses to save it, even though menuconfig displays it as
> >> [*] (enabled).
> >>
> >> Kernel version: 6.4.0
> >>
> >> File: fs/smb/client/Kconfig
> >>
> >> Current dependency:
> >>
> >> if CIFS
> >> config CIFS_SMB_DIRECT
> >>     bool "SMB Direct support"
> >>     depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=
=3Dy
> >> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
> >>
> >> Root cause:
> >>
> >> CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=
=3Dm
> >> and INFINIBAND=3Dm, the left side of the || expression evaluates to:
> >>
> >> CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
> >> =3D m && m && y =3D m
> >
> > Where do you get the last "y =3D m" part?
> >
> > xconfig says: (This is 7.0-rc1. Guess I'll check 6.4.0 also.)
> >
> > Prompt: SMB Direct support
> > Depends on: NETWORK_FILESYSTEMS [=3Dy] && CIFS [=3Dm] && (CIFS [=3Dm]=
=3Dm [=3Dm] && INFINIBAND [=3Dm] && INFINIBAND_ADDR_TRANS [=3Dy] || CIFS [=
=3Dm]=3Dy [=3Dy] && INFINIBAND [=3Dm]=3Dy [=3Dy] && INFINIBAND_ADDR_TRANS [=
=3Dy])
> >
> > so my .config has:
> > CONFIG_CIFS=3Dm
> > CONFIG_CIFS_STATS2=3Dy
> > CONFIG_CIFS_ALLOW_INSECURE_LEGACY=3Dy
> > # CONFIG_CIFS_UPCALL is not set
> > # CONFIG_CIFS_XATTR is not set
> > CONFIG_CIFS_DEBUG=3Dy
> > # CONFIG_CIFS_DEBUG2 is not set
> > # CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
> > # CONFIG_CIFS_DFS_UPCALL is not set
> > # CONFIG_CIFS_SWN_UPCALL is not set
> > CONFIG_CIFS_SMB_DIRECT=3Dy
> > # CONFIG_CIFS_COMPRESSION is not set
> >
> > Working in 7.0-rc1.
> > What am I missing?
> >
> >
> >> The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
> >> Kconfig engine coerces m to n and silently drops the option. The right
> >> side of the || requires CIFS=3Dy && INFINIBAND=3Dy which forces both t=
o be
> >> built-in =E2=80=94 an unnecessarily restrictive requirement.
> >>
> >> Additionally, the CIFS=3Dm/y conditions inside the depends on are
> >> redundant since the option is already inside an if CIFS block, which
> >> handles that guard.
> >>
> >> Observed behaviour:
> >>
> >> menuconfig shows [*] SMB Direct support (appears enabled)
> >> Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=3Dy to .c=
onfig
> >> olddefconfig emits warning: override: reassigning to symbol
> >> CIFS_SMB_DIRECT and drops it
> >> scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect
> >>
> >> Proposed fix:
> >>
> >> Since the option is inside if CIFS, the CIFS=3Dm/y conditions are
> >> redundant. The dependency should simply be:
> >>
> >> - depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=
=3Dy
> >> && INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
> >> + depends on INFINIBAND && INFINIBAND_ADDR_TRANS
> >>
> >> This correctly expresses the intent (RDMA stack must be present)
> >> without the tristate/bool coercion problem, and is consistent with how
> >> the surrounding if CIFS block already guards the option.
> >>
> >> The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
> >> identical pattern:
> >>
> >> depends on CIFS=3Dm && FSCACHE || CIFS=3Dy && FSCACHE=3Dy
> >>
> >> which should also be simplified to:
> >>
> >> depends on FSCACHE
> >>
> >> To reproduce:
> >>
> >> # Start with a config where CONFIG_CIFS=3Dm, CONFIG_INFINIBAND=3Dm
> >> scripts/config --enable CONFIG_CIFS_SMB_DIRECT
> >> make olddefconfig
> >> grep SMBDIRECT .config   # empty =E2=80=94 option was dropped
>
> I also have no problem enabling CIFS_SMB_DIRECT on kernel version
> 6.4.0 using menuconfig or nconfig.
> Or using scripts/config.
>
> --
> ~Randy
>
