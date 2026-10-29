Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261970;
	b=bo6gYygROlVO2OYbKw1YrYRNHvRwZlRdwRXEofVyLY3ErYJ2hFTML6U4bweTMNSGjnes
	 Usak9W9nDZs4CHBuIpIp0OyArPRLS6xJGWwqZhqj4G748L3spHDkCs6FtjaOlnvM8DU7D
	 FHoT2jvtdzGW5Lxoxv33GyVILk2+39H3SgNQjn70KI2alJhO3psvWWqycaDBYTZGb/K8c
	 mSwLibhZz8mrNi1TkpC0NalIcl90T5NWcZBXGHI076DsyvZ17Cr693d/AIV5ezjliRy7i
	 /KsvhzZOPCWmjhctCFJ5AnIR3i7gIi+2I/dEiFuVs67MN2pIET8zXhM4H+uSFXQHbCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261970;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FeXIiIhrvwIbQYpkMBfVZTtFWwz8pmkJmpDbtGyoWCM=;
	b=nRv4cRrTXIQjgk8P4d91+csGDZHdYL5wX31Y5Wpi7rX4F7w1MAslQ3oYMvKiDxlmdU5S
	 IgFGNgMnO3jZeCSHQ/TeO+1kqq4Ks5ReFBN8WG5JtKuIFF0f/kINWtXqeKy6EOHTzfJEv
	 m8XSntaBzGQ0J0QKip/CrQv7in0jM2MDYstzAW4AoxxFW7AT/bOeTKmf9tUkbNCiBc2gH
	 3CWyXDInthHK5zxYUl4eJxiHRXVs8ga/0djTvZxIgnzoeJORL+aDnCaFsSzm7X6PBAvHy
	 H7diisUOin3TQMSCAXBOGfmvKIc67Vygkq6hSsZJISihLTDMS1KWRnGUekXz9CRyA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaS1trDJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A44D606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaS1trDJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D7F1F031E1
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261970;
	bh=FeXIiIhrvwIbQYpkMBfVZTtFWwz8pmkJmpDbtGyoWCM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SaS1trDJ1gzpH2U0IGvtIQG3LLppT2u2ZK7Xc53HihvkiYLkdwb9aAzBz3yolfStB
	 C+qdRJMnj+8s/u5mu7VKoZajBeywc20wIPRj4qHjp6aC7Aejh9PfZ0o3xV3DQnzeQO
	 5uHcAErIy90MHIduVX6vVyt+oe/pDa9TeRhdevpt2X7IriDBvfVOQQNwMLDokKQT2i
	 hQy2qAhWWYGTDFa6Rghl9T6RcB13GdA0r9rQRM5XjcNKSBc07rzL2eacqUyUGAFmG4
	 L/OhGuk7kHzuizwgqX15M2B+2gwt+BdnywdgLJnUOAkZbaBwG0ZN8nDrSwEZQtYeyA
	 kdSIF6XEs71kQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2e8c710847so252654266b.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 01:19:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxQrOPUyXm6Uv51oQdfCZvZMF0tmDQohlECk/pJ32Uzo2t87YhDlmEmatvABswZKfHZ25o/qodiY2ho@vger.kernel.org
X-Gm-Message-State: AFq9FYI5lEjVr5LWNYzsUB92yZSKc5m6cHgZr/NjV8Id0lMzY1YExRG5
	0+PHDUs78T7LBtdcLoyaRtBFsZhyiIyz0LISPRYcYz0vvHF6+c3m7te12pcyjXARmGsvT1h/qlW
	Zw05gZIKkf9gDOW6dXJH43N3bwgFASvc=
X-Received: by 2002:a17:907:d78a:b0:c49:8fa6:f585 with SMTP id
 a640c23a62f3a-c49be05b2f0mr389440166b.38.1793261968871; Thu, 29 Oct 2026
 01:19:28 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029012532.222013-1-icb@fastmail.org>
In-Reply-To: <20261029012532.222013-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 17:19:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ne0aJudrs2GEqOfTAzquTRN5Q4qfafCFgAo9baqH8OA@mail.gmail.com>
X-Gm-Features: AclHuK8ji3dmaGQDuALVjPa9jyjsHAG8Ln84jsSSYMUvBfi-wh1jPoXMHUmzyQA
Message-ID: <CAKYAXd9ne0aJudrs2GEqOfTAzquTRN5Q4qfafCFgAo9baqH8OA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: enforce the read-only share flag when creating a stream
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Gael Blivet <gael.blivet@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 10:25=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> When a share is read-only, smb2_open() rejects opens that would create
> or truncate a file. Creating a named stream on an existing file with
> streams_xattr sets neither O_CREAT nor O_TRUNC, so it passes this check,
> and smb2_set_stream_name_xattr() then creates the stream. On a Time
> Machine share, opening a missing AFP_AfpInfo stream also writes one. A
> user who can write a file at the filesystem level can therefore add
> streams to it through a read-only share.
>
> Do not create a stream or synthesize AFP_AfpInfo when the share is not
> writable. Existing streams still open normally, and a missing stream
> opened with FILE_OPEN still returns STATUS_OBJECT_NAME_NOT_FOUND.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first =
probe")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
