Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9573175A8F
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 04:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783483311; cv=none; b=C+nCnfDIArg8qmIN55jIMm26A2WlSMZNMs2PUBWgDGu3tmnKcAKDgDjlXSIP/rlix9Hob373DF5WRU8tPKX43pZ5oJsaPlniZp+vJtBGuwQ8/y9+yLxK09p1ebapNVvpztoC9pasIZYknJUEdlbwepnE7G8ozlsHunjwgHXrTXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783483311; c=relaxed/simple;
	bh=oFUJm1n996+vOPSGEdnoOi1UEgZkR+CilLwsVr1YQvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ent+GCrQVYJnZJi/PTsuNIaXZ6hN/8Dr7aZIxtEGjbB9rd+G1O8GS4sqyCTzitUnFijIzTnumHHdKMyyjRhUg0I5yslM7PwJ5O6u4PCm8r80q6KPoKcncOPbC/2GqTpVTOjNx1QjpExDQwcJm1K/9vcCMr2DVngLR81tjPZnEjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/PE8ONx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/PE8ONx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E921F00A3A
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 04:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783483310;
	bh=b2hVhlB9xAFe3YG/NqA2YfAXHeb5jiCYY8is2BoQPBM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C/PE8ONxBRGJw3yx/pXFGqj9wX8Ldtlxo97mmN+Xt5+gtGz7If1WU1ff4z0aBvyek
	 jWsSs4BTp2DFZIMA2CQ8rvoebT5zgVXXSMXxU9t2VaFI8lATrzsTLqv6xnuQJfWEHx
	 nLdNSCZdkssKC79jjsfnJtuWDEUy5FBjdDDk53/rr3Kpgf9xbEuaQcdF3hWYT09iYq
	 jUHEF7YIfaKDVHHkjI+6U6CJBVJvv61+Z6As/Naq+d2N+1XTKfW5Brk6lfQ1RboFnP
	 IyKchEEEN5S81I61+WczYNrM+rv4c8JUWuK1VTMK/ywyeOurNzT6THMBEsgELrmRqa
	 fvGIoeBc2Lezw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c029505b389so195406066b.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 21:01:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YxMz76K7rIQba+9jtR7Rbo4/wmVasFg1vnd3jm99nWy+cC6BFpG
	z8DhzGvvi4YRAi8ffv4z0cWYOjV9JNTcT7HF9rGovE4kUawTnRLoe8aL9JaHgvADmCCFNkmNuL2
	kBIXAgI2/FQgM5W1G5x0rSW7NbuU2NiE=
X-Received: by 2002:a17:906:8d89:b0:c08:5bdb:e904 with SMTP id
 a640c23a62f3a-c15cdd00c2fmr39576866b.9.1783483308762; Tue, 07 Jul 2026
 21:01:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707100033.47512-1-g.blivet@me.com>
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jul 2026 13:01:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-fZu5oFELRcDxuOHMpLrepyH0kSwOZVySKXyorza-0gQ@mail.gmail.com>
X-Gm-Features: AVVi8Cfh0kxdnt3OADQImpvDGrJAJvmgHpfkVcrTi_q-WyXQUsklAL2_I13yIoI
Message-ID: <CAKYAXd-fZu5oFELRcDxuOHMpLrepyH0kSwOZVySKXyorza-0gQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] ksmbd: assorted fixes found while adding macOS/Time
 Machine support
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 7:01=E2=80=AFPM Ga=C3=ABl Blivet-Bailly <gael.blivet=
@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> These 7 fixes are independent of each other and of any Apple-specific
> behavior -- they affect any SMB2/SMB3 client. Found while developing
> and live-testing macOS Time Machine support against ksmbd (that series
> is being sent separately, based on the same tree).
>
> Two are worth flagging specifically:
>
> - "fix COPYCHUNK for ADS streams" and "report actual xattr value length
>   for stream EndOfFile/AllocationSize" affect any client using alternate
>   data streams, not just macOS.
>
> - "fix off-by-one rejecting minimal COPYCHUNK query-limits request"
>   affects any client probing server copy limits with a minimal
>   FSCTL_SRV_COPYCHUNK request (ChunkCount=3D0).
>
> Each commit builds standalone against ksmbd-for-next-next and has been
> checked with checkpatch.pl --strict. The underlying bugs and fixes
> were found and verified during live Time Machine/Finder testing on an
> earlier baseline; this re-derivation against ksmbd-for-next-next has
> been verified to build cleanly but not independently re-tested at
> runtime.
>
> Gael Blivet (7):
>   ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
>   ksmbd: route stream FileDispositionInformation through stream delete
>     flag
>   ksmbd: report actual xattr value length for stream
>     EndOfFile/AllocationSize
>   ksmbd: return STATUS_OBJECT_NAME_NOT_FOUND for unknown IPC pipe names
>   ksmbd: quiet mdssvc RPC log spam
>   ksmbd: fix stale sparse-file attribute after share reconfiguration
>   ksmbd: fix COPYCHUNK for ADS streams
Applied them to #ksmbd-for-next-next except 0007 patch.

I have applied the following patches instead of 0007 patch.
https://github.com/smfrench/smb3-kernel/commit/165e5b86fd2c5894c9d81ebb3dc8=
98a82e55c440
https://github.com/smfrench/smb3-kernel/commit/8afe741dbd67df46274434a83de7=
67f6dc3ef247

Thanks.
