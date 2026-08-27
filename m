Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4F364EA6
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 07:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817285; cv=none; b=OBXmTVTcs+kca/bzsO0Y7Qv3vNi6M1qeMuYB0Aqwj1aPJNfLUTG/MYztCHYvMOCCWKFGyOPuUMZQk0/+NRmMKaTPZBlM6/SWk1f4vxqR33ZO6m+znyhqebhpEnsUiGLVlQ6XlS+xDIN4CvaLd/IhATZEJwt3cevxn4b13948JUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817285; c=relaxed/simple;
	bh=qb0PWynkgX7ZqlP/vfLORb2xoDpmNeppiR9R7jrEYf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqxw+uue9ZqehTZPN27VU1+r2CUE+ED4NxzwBO29HCLp8+fqcUsmSEgpjt6qQQ/eAjBvvZ+s5DUH6gEGp+R4w64qT71I1RNaj8oBxxPNElnBcuoDhGsPFv0N7TFKjLGhsRFP0ONB/kchzyJgQ3RO8WV7KmKLuBxpRqdNGBUxcfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBxdNP98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBxdNP98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F441F00A3D
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 07:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787817284;
	bh=qb0PWynkgX7ZqlP/vfLORb2xoDpmNeppiR9R7jrEYf4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hBxdNP98No4qOomlVSSzzAY3RyGWZuIGgaPxVptL0xwUR0jpfRIUL15Yvtss1fyHG
	 DQXOFDawBDe1QxVIc7kZsFSRtdjhyynwfZD5xhXMzTbw+4g0rvRQk+gWm6oGJLagUh
	 qwMPEmeokidJLYg2j81vS77xVqj0fjkUpHUofid21r2P9g5bFaePC69/rZUehSdSGR
	 WFpO6mIlTs9i/MWzDd5Q7kJTrz5sLS/aY0pLm91aMMyhnTE079Vc9n9VordmGDTQy1
	 bDkLUfjb+ySfoLOJQCpUVA1BgRsJTCnDxhUwdRj7meiZBUEt/cPtBjVnezX6zn+3/8
	 3YY4gi3T0YUug==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a5e392b2b3so2917002a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 00:54:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqm8IU+Y3VIHeFZihK9qTJ4CuS+lsuDguyvw7ENsuEfOVrjd/CaYJttA6uEGNsUQuDDWTIoYFiUDFqg@vger.kernel.org
X-Gm-Message-State: AFuF++mLS0t49sKbIQZQ0Czq3qApHWhI+/dI1Wyij4IspN6jrKW65WJ6
	mKU37yEblY4yf+EohfOr7kowMDppmhGfk/c+KjAwfy238nMDiIe5M7sKQL3Y+1e79KqfFho8aRZ
	Q3OJiuEbz3f+XUwE3H/Udjh7CC1VTLrQ=
X-Received: by 2002:a05:6402:42c5:b0:6a0:8885:e6f0 with SMTP id
 4fb4d7f45d1cf-6a5df5f0b61mr13356485a12.3.1787817283113; Thu, 27 Aug 2026
 00:54:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
In-Reply-To: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 27 Aug 2026 16:54:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Pp=197vL1w88d2=Y6yrpbfxzULuR04gDo1Y0-woTinA@mail.gmail.com>
X-Gm-Features: AcwNN1UkM2FI4wg9N2qkwxxZN32HhZ9XruvdLAwsxY8RhVHBXYVHxTlZgkHNGug
Message-ID: <CAKYAXd_Pp=197vL1w88d2=Y6yrpbfxzULuR04gDo1Y0-woTinA@mail.gmail.com>
Subject: Re: [PATCH 0/4] ksmbd: implement Continuously Available (CA) share support
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ysk@kzalloc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 9:56=E2=80=AFAM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> Enable the Continuously Available (CA) share infrastructure in ksmbd,
> allowing SMB clients to request and use persistent handles on configured =
shares.
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> KSMBD already has a complete in-memory durable handle v1/v2
> implementation including the persistent handle data model
> (fp->is_persistent), protocol parsing (DH2Q with
> SMB2_DHANDLE_FLAG_PERSISTENT), and reconnect validation (DH2C). However,
> the server never advertises SMB2_GLOBAL_CAP_PERSISTENT_HANDLES or sets
> SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY, making this code path unreachable
> by clients.
>
> Per MS-SMB2, a client can only request a persistent handle on a share
> that advertises SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY. This creates a
> chicken-and-egg: we cannot test persistent handles without first
> advertising the CA capability.
This looks like a useful first step, but I don't think it provides CA
support yet.
The handle state is still kept only in memory. The existing code can
reconnect a durable handle after a connection or session loss while
the server is still running, but that state is lost when ksmbd or the
kernel is restarted. The server therefore can not reconstruct the open
from the persistent-id or CreateGuid.

I think this should be implemented in two stages:
1. Standalone CA: add a local crash-safe journal/state store and
recover the open state after a server restart, including
persistent-handle, lease/oplock, ownership, and replay state.
2. Cluster CA: make the persistent open state available to the node
that takes over the share, then add cluster ownership management,
stale-node fencing, and cross-node failover support.

Standalone CA should be implemented and validated first. Cluster CA,
including cross-node failover, should then be built on top of it.
Until standalone recovery is available, advertising the
persistent-handle and CA capabilities seems premature. It seems that
many updates will be needed to ksmbd-tools when implementing Cluster
CA.

Thanks.
