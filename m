Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A5B3C4554
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 06:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791441026; cv=none; b=rJY99+h/L0fCpCoB59XHGEQ4ksVAOzLlhIWsxaJ5S0/5FUgu1KmmTcKVEp5By6LGhB/tFrJzobQRJt6MWgwAL9KcpXXwNpQZlv71NwI+9HE94+n9FcuRZrZNwkx1MU0TG3neREdX7RxuKUMGxVRZd84LNZMytt4PhFTGCqQcxa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791441026; c=relaxed/simple;
	bh=vY9cv10EiDqAYKI3zi0x2UDFVDwoMp33I/kFa65iMOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+FVPy77OTVP+FQBvEsminMLur3rfg/Xgga9DR+BaWIcpb111/LKR6gt+N3aCyGKsA9bPrCDsXdDwKTK2h84N86Kva1TNjgMfk6qH9FsV1gzftK3PbmjNQGXFKbFNJg50QcSDFhJYW6zuli7h9U1yWhghaB5XtIBMdIPnqDsVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcxxgU8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcxxgU8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0861F00899
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791441024;
	bh=vY9cv10EiDqAYKI3zi0x2UDFVDwoMp33I/kFa65iMOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WcxxgU8+kfneCAPFaGNPCRCo/Y+P0Z7LpPJ46cmPEwMU4BNcRdg9fIArSVZb6bzz8
	 McBy7BvUm2mYJ0NQ7vB7O0uCtdzzcRpWqdoij8JsDZg8ibxLcAYPn96Hs8QZF/49iy
	 KguyZhH87ebHYAnze9f23FQnrJo60MAD9Bi5TUobNPr62ozcijG9h49wZZjucmXzvH
	 NIfmNgh4/5pcAusxAsZW1kTcgUGztc6CcY0hMVFix7WCu9Kz7pz19x773+Gk0iJH3K
	 yyFJQX2UqI/c2XxY1NWmbM/kGHajZ11hBnTmF6zFZw0dQmMAdCHzwVeid8Ux9NkS1W
	 wxzp2jEiqK7XQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e5f8fe879so405325666b.3
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 23:30:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxs0e23U3Sg0WuzTrtLRftqGmM7FLY0NfjMeqvKbb00iaa9OVAm/Oq5z92RLSl2KgVxF5UyjFaTQQ6C@vger.kernel.org
X-Gm-Message-State: AFuF++mW3T37iILwE+fBM9AjnnSeWjc1k2cDzqR+5uzre4F/3wT7oOkO
	WdxYPgfpEKV4K1KWlH/P8ZmxL0sySosxYt5fmYKNvp9ZcKxQmw89Yb7/3jdgV72fR2TSSMsDPkr
	NuFEmLOWXbkG0znNjbqRUmsHO/mBFMgo=
X-Received: by 2002:a17:906:1011:10b0:c31:86b9:5525 with SMTP id
 a640c23a62f3a-c3186b95c42mr214826566b.30.1791441023269; Wed, 07 Oct 2026
 23:30:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007131351.2968640-1-charsyam@gmail.com>
In-Reply-To: <20261007131351.2968640-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 8 Oct 2026 15:30:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_cVup3rUM+7u3s=D7Tr8TxhvC1KZy9eOp_ymzpWAZ2Lg@mail.gmail.com>
X-Gm-Features: AclHuK_bVDSRbo-CtIIIZEeFhwlZhmOaM3DWMHffbTVYPIF0V4qz3-E46Mxxozs
Message-ID: <CAKYAXd_cVup3rUM+7u3s=D7Tr8TxhvC1KZy9eOp_ymzpWAZ2Lg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix named stream write and EOF handling
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 7, 2026 at 10:14=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> An SMB WRITE to an existing named stream can silently discard data after
> its written range. ksmbd stores streams as xattr values, but the write
> path passes offset + count as the length of the replacement xattr even
> when the old stream is longer. Writing 26 bytes at offset 0 to a 60-byte
> stream reports 26 bytes written while discarding the remaining 34 bytes.
>
> Keep the existing xattr length when an in-place write ends before EOF.
> Reject writes that cross XATTR_SIZE_MAX rather than storing only the
> portion that fits while reporting the full requested count.
>
> Commit 4ea0bb8aaedf ("ksmbd: handle set/get info file for streamed file")
> intentionally skipped ordinary inode truncation for stream handles: an
> EOF SetInfo on an ADS had truncated the base file. That fixed the base
> file corruption but left stream EOF changes reporting success without
> resizing the stream. Handle these requests by resizing only the stream
> xattr; the base file size remains untouched. Zero-fill stream extensions.
> This is needed alongside the write fix: a short write's accidental
> truncation previously masked an ignored explicit EOF change. The stream
> resize helper returns xattr errors directly rather than using the
> base-file truncate path's EBADF conversion.
>
> Fixes: f44158485826 ("cifsd: add file operations")
> Fixes: 4ea0bb8aaedf ("ksmbd: handle set/get info file for streamed file")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
