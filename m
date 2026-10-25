Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897726;
	b=w59cAyczYb/PpAz4JqM5MDNL1TzJ1VASqfO5OB62IgK8mT2XoL0qKxYZaYr+TWJjmm/G
	 xwiVQuY43rCY1mDOI6u54XA0qOHjG5jmK1v5T67tr3+/4v62uvzsOVPw9wc5c5N2q/PrV
	 Yx4XtyItdzb70j4BX2j8ucE3ZzwhFI1ZaiHuvt21ODQW+2WzvAZRUaudspdphsJqMTnqi
	 zEVx/BlOsSs4fM7JysE80kQj3cBg/jPcXuiGGDQ7ePHsJyxlaQ5jEObuhZuSxA2+miq+q
	 iPSPuNm8Z3tY1o357iKiWDLlohXqRDuausoX3Y5c82YY6SzT9tt0oOvrMoEhy0yA5UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897726;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=VhbrVnCYvHtqMzAN/zHk6naxMQVy+tIgDvg+bbfA2y8=;
	b=ZjwpDgXHLx7VsqEtflTN4/lzzbYGSKgZzwZK1ANxo56H0wQvFjr1qMV79DU/BQQnrZ2O
	 +FHF2t7sA98ZYOb3GE0x06sZiZ7a8nEGdrDavrjUjxhQnB4G/DYvQWb687BFSdGbIdjWS
	 e3MpkqNCaaUY8hggiU70hvviSRLdnJ1jMtzTOAtvCpTDo4ko+LlFkVKmIgX1rkMbO2xds
	 8jhbLM5DbxWfjWk5LqPwQJoBJ2OHP7ciMzTkMV47NdebIPSxsO/IhK3///f5OqNmKgRgg
	 vsX3KwgUp6g0z4P9CRR577/N3JusrHxi08MeRl0YcgS1to3RZBFk/BNKV3lQMJ1oX+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4uEI2L2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732EE606A31B
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4uEI2L2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECF41F01829
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792897726;
	bh=VhbrVnCYvHtqMzAN/zHk6naxMQVy+tIgDvg+bbfA2y8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=N4uEI2L2zWQDG6KJXxqBJwJzrMHcL+nODGfrbm4K4q3msnSPa3Sa43foRA5waKkyb
	 lNye8s9LTAHioKNDu/5gL3FyzlcV9wLI5bMoVitLAVsDFd/xWsGYB/sX4/1GMWtTFa
	 Zd9k1ATuRgOeMN3Bz4N7IbW4nLTwLp468foVnb98gsDnwM2pHC3abMhAuvMrE6c2wl
	 S11huFElk7oqUn0cv1bHmVGLYkrKy0rNqGR2oJRHOck7B0n0Y8cv9OUaqK9UlILVoU
	 xJKXnMgPJhz/FuuZsbfJ8Mx4ro7RIjwUvtr1+i4/w0e10ClYDXTCJgFD/sO6w8AWfM
	 qfXtpJ6V3jFqQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso5257696a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 20:08:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByYEJwffucfHJq/eccfIJvwq+a0f2DqXWnPwf6ed0VuG+vD3FvD0RLTHgad3BMT0Zp+axe9aNznd8fM@vger.kernel.org
X-Gm-Message-State: AFq9FYIMH40JkkaRdLyCAOQrGw0gQtSt4FOCjyE7og2M0I7y8OeQiJ09
	B4Zq/yvQ8T18YYmKnQT2Bba10IY/mFkfqHvsPqAviZ2xEcNwRPMrHT5+NP7F+KpLlCP3IH/ILhZ
	3d+MYqp8efHR01eRKhIpnadez4HuQeMQ=
X-Received: by 2002:a17:907:60cb:b0:c29:519b:3aee with SMTP id
 a640c23a62f3a-c46bde57fb2mr383807166b.33.1792897724620; Sat, 24 Oct 2026
 20:08:44 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
 <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com> <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
 <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com>
In-Reply-To: <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 25 Oct 2026 12:08:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jE4jXXVv_evHxzarw3M-2Uuzi3wrOKD0=RO8-V-tWWg@mail.gmail.com>
X-Gm-Features: AclHuK-rdvlIc99PUEOdB1ehh8GqX0ils_Q0gSsLAwMW6RI4JkDLmZsj-wzzMbg
Message-ID: <CAKYAXd_jE4jXXVv_evHxzarw3M-2Uuzi3wrOKD0=RO8-V-tWWg@mail.gmail.com>
Subject: Re: ksmbd: AES-GMAC signing support?
To: mixalhs <mike.michalo@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Michalis,

> Questions:
>  1. Is the series OK to send as-is, given GMAC is slower on arm64
>     until the library improves? ksmbd uses the client's first choice,
>     and Windows and macOS put GMAC first.
Yes, please send the signing negotiation fix and AES-GMAC support
patches for review. It would be good to include test results with a
Windows client when you post the series.

>  2. Would you mind if I raise the GHASH speedup with Eric Biggers on
>     linux-crypto? It's outside ksmbd, so I wanted to check with you
>     first.
No, You can raise the GHASH optimization with Eric on linux-crypto.
The results look promising, and reusing the existing POLYVAL
implementation seems worth exploring. If you could also send a patch
series for this work, it could be reviewed independently of the ksmbd
series.

>  3. I also have a follow-up that prepares signing keys once per
>     session/channel instead of per message (in a microbenchmark of
>     ksmbd's signing path, AES-CMAC on 64-byte messages drops from
>     about 125 to 32 ns on the M4). Should I send that later on its
>     own, or as part of this series?
I'd prefer the key-caching change as a separate follow-up series. It
benefits the existing algorithms as well, and keeping it separate will
make review and performance comparisons easier.
Thanks!
