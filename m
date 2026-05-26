Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7961A18EB0
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 00:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779754613; cv=none; b=HsuaH/K+kqpeOvSHFXzaTr1zapqLVlgwehhdh7AUvzX+jCzi+HTGsC3WpBo15qyNxfzJVdqNZGD9K+3EivMPHEAU8yE4L7oy6Eh2BZYWqOev6IApNxd2RVk0H+a/A08xQKbNrreAz/AuXa9jG+8JA1rIJNpkRk31y6wiRbDdmCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779754613; c=relaxed/simple;
	bh=ik/jebGWml1NW8F/nWsNabEQIRtY/SZ6wh69bGf0lY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o38IIU195FcpXvaB3dXmIHJMlk/nCq2P/w41dG4GS8z0OX12uh4k0pAJ3oGoWTPWnmG7EzTDBOUmNizOICSkHO9HYLHMWZgQwTmTZmF6xQgxnMISAkbThDQgpusuFMAtNybaSlSPNa66nSxN2+8tXfXPLWUmM0WYAliXOXuT0Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNeH7qTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNeH7qTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80AE1F00A3A
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779754611;
	bh=OGAQFzUaomGDPXh0erDMLXUH9zBhUXqLRE38UMpX5oE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LNeH7qTBcH6GEtyxEg3FzZwVdZcy6pzWZD5atf5vUIt5ukXoqkcISB3xONxkWZqRF
	 kX2FFyW3Z5A4uR890VEeae8SWc713WkFgl29q+lZhzo8aYqJBH5al40BHeFKyMTBk/
	 oEbbr39xjLip4QEBpFrgyJ52YHssqj8RAUOXgQlaLbGgHLkz3Gds/rZv9a62ozjtYY
	 rS73ecdcuFhqlsbf+ysjH/mjbAd6vfWascTrJeog/LZVybtIfvpzxy5h4/dLl4qJZ6
	 wtJ3NeBe5HLYA0w6VUmZjtEZYoKzUBSBHGYNlfyORWc6eQJuqyp8xt6uGLkRe1weHN
	 RLHh4FuvB8a9A==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bcceb394417so1218862466b.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 17:16:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+rhlxt7SOa5aoRrWLhw9Tgi8YV8IMv/PGOb0ZkWUZYLpeiXWdGAGfEhhsbH6WLvSYpoqqAEbiTEzOF@vger.kernel.org
X-Gm-Message-State: AOJu0YweUluzE2zXsB+BrZs9M3yuratDgnkc95g4hOEaJphBGtGmC9TW
	Wy/uvEtPP9UmsiNH5q8fbiHcqSUbKQ6WZbf1jxkbhK0oK24W8kSAE9gkLSlWjYCGwL1zkYwM6Jo
	/hGrd6MPQWCkCfUWeMlifizEaJAQhNZ4=
X-Received: by 2002:a17:906:845a:b0:bd3:5e5d:f895 with SMTP id
 a640c23a62f3a-bdd2aada464mr647052066b.35.1779754610601; Mon, 25 May 2026
 17:16:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525185018.1206-1-cofedish@gmail.com>
In-Reply-To: <20260525185018.1206-1-cofedish@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 26 May 2026 09:16:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8fqFqKxPWvVm4zH4d=C5atNvMBE6RnF5OmXW1uif4pRQ@mail.gmail.com>
X-Gm-Features: AVHnY4KKdDTl3UZ-gWlHC1pdSmYnsAu8joOSvwSpD5yNGP09ZU7iczGoZ3SbwQw
Message-ID: <CAKYAXd8fqFqKxPWvVm4zH4d=C5atNvMBE6RnF5OmXW1uif4pRQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: release ksmbd_inode ref via ksmbd_inode_put on
 lookup paths
To: Aleksandr Golovnya <cofedish@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 3:50=E2=80=AFAM Aleksandr Golovnya <cofedish@gmail.=
com> wrote:
>
> ksmbd_query_inode_status() and ksmbd_lookup_fd_inode() both take a
> reference on a ksmbd_inode via __ksmbd_inode_lookup() (which performs
> atomic_inc_not_zero()) and later release it using a bare
> atomic_dec(&ci->m_count).  Unlike ksmbd_inode_put(), a bare
> atomic_dec() does not check whether the reference count has reached
> zero, so if the caller happens to drop the last reference, the
> ksmbd_inode is leaked: it stays in the global inode hash table with
> m_count =3D=3D 0, future __ksmbd_inode_lookup() calls reject it via
> atomic_inc_not_zero(), and ksmbd_inode_free() is never invoked.
>
> The race is:
>
>     T1: __ksmbd_inode_lookup()    -> atomic_inc_not_zero(): m_count =3D 2
>     T2: ksmbd_inode_put()         -> atomic_dec_and_test():  m_count =3D =
1
>                                                             (not freed)
>     T1: atomic_dec(&ci->m_count)                          ->  m_count =3D=
 0
>         return                                            (LEAK)
>
> In ksmbd_lookup_fd_inode() the matched-fp path (which now also uses
> ksmbd_inode_put()) cannot currently reach m_count =3D=3D 0 because the
> matched ksmbd_file holds its own reference on ci, but converting it to
> the proper API keeps the three call sites consistent and avoids
> future regressions if the locking changes.
>
> Because ksmbd_inode_put() may free the ksmbd_inode if this drops the
> last reference, the call must happen after up_read(&ci->m_lock) on the
> two affected paths in ksmbd_lookup_fd_inode().  On the no-match path
> this is a pure reordering; on the matched path ksmbd_fp_get() is
> moved above the unlock so that the returned ksmbd_file is pinned
> before the inode reference is released.
>
> Signed-off-by: Aleksandr Golovnya <cofedish@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
