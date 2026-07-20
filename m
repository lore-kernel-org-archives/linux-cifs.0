Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04B3A3E7A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784524903; cv=none; b=GyMEFE1/kUNR4RaDkyyeQ9rX/5apSSv/m/RWWEEp7Bh0ITfTPR9s8CQVxxMUYGDUto0bWyMlOZtTkrsd2lTqMxCF6ljckIWtPvQpD2gxKl4CFgylSOQlq77CGWtPdf8/QwJvK/ypGRBeSujbzhddkl9llKC6UfUMX0ScVPSMtd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784524903; c=relaxed/simple;
	bh=sB2tKdYdDBU9hLWCfozBQ3IKgOT11XenHzdiumvXRZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SjnyRrtVpLAaFysfkKcQoc+9CwvPeZ6YV2OhRowXR3CitcHLL/XpjZsWYfHeNpUoOtYo59ziO7hKZCKhVgyIVXGiEv4N4WxtFOCLgHBKUlmiICZOwPOrgANmOxof+n3OUO4OkVHTSCPVW62+jr+tjV1acNz7wAr4UUjXhQM5CL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MN/rw9UB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MN/rw9UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C251F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784524901;
	bh=sB2tKdYdDBU9hLWCfozBQ3IKgOT11XenHzdiumvXRZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MN/rw9UBni1XPWlfsC8IS+58Dy3t9bVS1PbRU/DNeNmD2Ag1rbRlj5CYlz4rtImHu
	 erNEtsZiyKKP4EyBV+YmhYgVKVZ4hVRCwwrj0AtSLdW+SPFVp2/PHUQJtwZQjF5VIF
	 g+3N6uKkkladaaBLA/moIZHfQHAMs92WR35INU9ry2pLSjXcykuRxx92haosKt4ZF2
	 GfZW/A8J+7MbOikK9r7XtSzzKFCBympRa+D21IMIWEALb5i/9O4yLVt6BHFnylYTjx
	 P1lPJetCW2qse4t2QuHyfxy811wFaaXKWMEZl3Nj5EcDNRy+9DzsTXsHgdUdTOfU9u
	 IEiXTq7AQ1pEg==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6986287534eso18125882a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 22:21:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnyAGP9cIyh0ESdwPQZDi4aIHonpvS/LpPOFe45/2or7Vw49TY3KTFKLrRNphGZBOk3xW75P/jTmnH@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3muhlQ4Z/qq0lLGrIQCxyrCAm/PFqCAYUtdfnLGEmq6zF4jo7
	1OihRyEzfkaK0Ka0TkR/t6nL/cIJdUGMsY7clVIAxfi6zb+qc6NRLLLq9DKivNUqHZLa1luwqnM
	Z0Nqvzh4OaqDxhj4jpK/LAke5r5v0pdI=
X-Received: by 2002:a17:907:3f8b:b0:c12:5e3d:4023 with SMTP id
 a640c23a62f3a-c16b457b127mr492916066b.10.1784524900590; Sun, 19 Jul 2026
 22:21:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784258165.git.tanze@kylinos.cn> <03e3fb98415d9e861588b165d78a22f18e14eb9c.1784258165.git.tanze@kylinos.cn>
In-Reply-To: <03e3fb98415d9e861588b165d78a22f18e14eb9c.1784258165.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Jul 2026 14:21:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8CkqDd5uc4Mdtt3N5XRqVk7kC1nedqkCpV3RxQ+mcOng@mail.gmail.com>
X-Gm-Features: AUfX_mzxN0NU4s4cEEYSlXslmNmDxmdKMKq0zdN9w0yV1gLadDOZzhrK6NEPWkQ
Message-ID: <CAKYAXd8CkqDd5uc4Mdtt3N5XRqVk7kC1nedqkCpV3RxQ+mcOng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/9] smb: client: support security.capability over EAs
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, pc@manguebit.org, sprasad@microsoft.com, 
	tom@talpey.comm, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 12:40=E2=80=AFPM Ze Tan <tanze@kylinos.cn> wrote:
>
> generic/093 uses setcap and getcap to check that a write clears the file
> capability. The CIFS client does not have a security xattr handler, so
> these commands cannot set or read security.capability through SMB EAs.
>
> Register a security xattr handler and build the complete EA name for
> SET_INFO and QUERY_INFO. Keep security.capability unchanged in EA lists.
> Reject other security xattrs.
>
> Signed-off-by: Ze Tan <tanze@kylinos.cn>
The client exposes these EA names through security.* regardless of
whether SMB3 POSIX extensions were
negotiated. Is that right?
