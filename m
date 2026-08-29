Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E4F283FD9
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787992419; cv=none; b=frDsyXaLevvrAuxG/UYDAwSASPe5rGcvdJFksBTpI+y4idz3H8ddW3vzsD/WOxikcfpEGtTzllSGjUY0g9TOlyMmJgKri51/Ptw1WKqiy/Vg+IIjZu2Ra+02NXIQ521vSgxBa+dkOgnzZBeZmCR4c7iM5UJ3vHk6p+SL6/a6IGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787992419; c=relaxed/simple;
	bh=Dy6oWb7lZ4dhDyxnyavQpwjGmxSU1wtoKSU1FuS7AAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzBdimyVZQzqMb1WKLVXqytGr5lQF4fBN4dLhIlbMIpGv2Ewjm7zgWaoi0P4I7ajfucJAaEzW3BUrOxEV07yy8ILwrh3zCvHh75t9tSOcOeoti1U1dz0X1EsGN4JVtOFHSq3B4cJNjiIPFy1hwLE8nWuQN+yi+EOCCYXfke+No8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BivmIfnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BivmIfnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D0B1F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787992417;
	bh=Dy6oWb7lZ4dhDyxnyavQpwjGmxSU1wtoKSU1FuS7AAg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BivmIfnDhj+VvKF6t/7WagXWRkXTW1A2W9esJEnqVSYVxSC80RLSGbT3FcoecsReo
	 /qq2n+b9ZJtcqQgLxSb+jZb5jsaWRXus1JOBAwRB9LjPC8wUDSAKH9KcC/lw+sbPim
	 JQ4brKVN0oy1W7FgcbAfEJD1O2DayLJ3k7vKs1bKc8L/PrUtQW1oHi5Ags92jyzUZl
	 vdFizGt0N12sto+MH6vLdpduJ0r/G1hSa5h3yB0UW1FUYNsngMv/O5KRutKkIY1tjy
	 50oYg3SLzaNmNwqBWXklyjImhT2LX8vElf2sUqU2FUUrZ6LqnZD/A1V59gi5/mHcQM
	 rrDbKzT31J8nA==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-857ff9fef54so21350337b3.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 01:33:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy5O4ThvfTG3FNzASMs7FpaGgAmuXSjl4OrZS2eSFpk6zo2GiTbz2COEOgh5vu1agFui7ycayNU4+PA@vger.kernel.org
X-Gm-Message-State: AFuF++m9KYwOJUAj2v/yeVvY4CNqt+5GUSwrGD3lvsi8h4ZwM9OhnshF
	nqv4XYQPNx0mYzi33G90PyXKt6HSxtNoI2io8we9rJpbh+jKTLK/XT2+i3INkR9G+7H5k8tdw9i
	z8t97nm7oDSBaAozO4iGzgX55MCC2dGU=
X-Received: by 2002:a05:690e:4511:20b0:66e:5bff:66cf with SMTP id
 956f58d0204a3-66e5bff6af9mr382853d50.32.1787992417088; Sat, 29 Aug 2026
 01:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829-review-ksmbd-normalized-name-v1-v1-1-4fab73835057@berkeley.edu>
In-Reply-To: <20260829-review-ksmbd-normalized-name-v1-v1-1-4fab73835057@berkeley.edu>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 17:33:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_tdxLTY3VYpMFekC4j48NK_hZB=bwhG9QN-soipE0R-Q@mail.gmail.com>
X-Gm-Features: AcwNN1W76Bmp3Cu1MVEWZ-VaTdXw1SOtInuN9gJINxvLJ7XkKzzsxkesgqVhDbU
Message-ID: <CAKYAXd_tdxLTY3VYpMFekC4j48NK_hZB=bwhG9QN-soipE0R-Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate normalized name response length
To: shakevsky@berkeley.edu
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 3:27=E2=80=AFPM Alon Shakevsky via B4 Relay
<devnull+shakevsky.berkeley.edu@kernel.org> wrote:
>
> From: Alon Shakevsky <shakevsky@berkeley.edu>
>
> FILE_NORMALIZED_NAME_INFORMATION converts the open file path to UTF-16.
> smb2_allocate_rsp_buf() leaves these responses in the 448-byte small
> buffer, and get_file_normalized_name_info() converts the path without
> checking the remaining space.
>
> An authenticated client can query a long path and make
> smbConvertToUTF16() write beyond work->response_buf.
>
> Use the large response buffer for normalized-name queries. Before
> conversion, verify that the response has room for the worst-case UTF-16
> output and its terminator.
>
> Fixes: 10aeff72ab82 ("ksmbd: support normalized name information")
> Assisted-by: Antiproof:GPT-5.6-Sol
> Signed-off-by: Alon Shakevsky <shakevsky@berkeley.edu>
Applied it to #ksmbd-for-next.
Thanks!
