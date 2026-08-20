Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F03CAE8F
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212045; cv=none; b=fgZUYEiJr+sd4WylqEbtBd5C4EUgGzJyr0RDiIB1NHI2PmPsmo5MPR7cbp0Lzz4wd2OQNsKI4aEFZHLnimU7fKKO5EMlLyObVxJ21FSOx6e2OKStjelYWOJ8J3TxRrgCsGRospuzDFD+an1Xxa0kVQvx4WeNENkiT+mG7mMEgvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212045; c=relaxed/simple;
	bh=PGxkqbptRpVRN5rOKhtKx5bKfMQ05kt6PiApt0Bxd9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WlRUa0VTEY99PjpJcUhbhl57Yu1yzsyUoIk6VFyjq3vcwmGwx20ATSPnpfKtHPyqCT03p0uXZVmdC3b2qCr9384r3g80TCNr74RtcIxl0aHDcu37K+2CRBSLugNU38S/nmtRiASuY3Y1wLjrsa/w7ywLqNaOIItVzeWYbeXpkq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6+RIqQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6+RIqQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241241F00A3A
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787212044;
	bh=PGxkqbptRpVRN5rOKhtKx5bKfMQ05kt6PiApt0Bxd9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=N6+RIqQL9mcpZknEIbGACUQKnsDdt1shKpuWh6IHGHL0IrtBqjyFjec+xVH/KB0AT
	 TkIKu2C0WgkzBFox1Kw9o1Ssv3cc5iKZYCfOoYrKDURi984tSvAAYYJpTXgieJUSyG
	 0SOnfPEounFl2ymK3B2GikwR12QnVpGGmglKto1lYeskre37SkqzHexVhtRIjFnHwo
	 KN1Ep4Pkx8HJC1ojRF0JuXYCLymgi9HTGQx1VwTEK6FbV1KLfMGBbjBrmCkz2rxFC3
	 NSXoZm0YwaQOIdBcqLKoI9G47V3eHR9EbeRBCGMlOKogx7dN30pujTFapKsiYeKhC4
	 LcgVnJyoXrTsw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so3263209a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 00:47:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpjYFgBux+4VSyJNeu4J+dLhd2904r1J2OPNHJdNYQA4Bolud6AADutQ5fdtwpDFuW1KHEUqXy4aWpz@vger.kernel.org
X-Gm-Message-State: AFuF++kxAnTnx0GdejCP6BXCXA0l5UutHkGDG9dekTNc3cCx0KWRWb+k
	h8/OEnL+BtK+Fsz3qIaaCEK/lofy7RNgH599ohDwTFukDEeBWo+kfdDy0kcw3oDoJ8IhaIi6zhn
	WDUan5J6KMPnc9BWzu1AagQc85GmqIJA=
X-Received: by 2002:a05:6402:e0e:b0:6a3:6d83:ba44 with SMTP id
 4fb4d7f45d1cf-6a403297189mr7493619a12.2.1787212042764; Thu, 20 Aug 2026
 00:47:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820065816.44267-1-thuth@redhat.com>
In-Reply-To: <20260820065816.44267-1-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Aug 2026 16:47:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wMUVL+4nSVWS5PpC63vxrQzW5eK+om8gHzXE-cu4B1Q@mail.gmail.com>
X-Gm-Features: AcwNN1XGAz2GB_zH2eNSJ0hcZi_UxsPWjtpTYbuedJU79NyZBM2_TZsl5D1mXtA
Message-ID: <CAKYAXd_wMUVL+4nSVWS5PpC63vxrQzW5eK+om8gHzXE-cu4B1Q@mail.gmail.com>
Subject: Re: [PATCH] smb: server: Remove obsolete "select CRYPTO_LIB_DES" from
 Kconfig file
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 3:58=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> The DES encryption in the smb server code has been removed in 2021
> with the removal of the insecure NTLMv1 authentication code. Thus
> we don't need this "select" statement here anymore.
>
> Fixes: ce812992f239f ("ksmbd: remove NTLMv1 authentication")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
Applied it to #ksmbd-for-next.
Thanks!
