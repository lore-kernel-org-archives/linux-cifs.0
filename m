Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F62C3AF656
	for <linux-cifs@vger.kernel.org>; Tue,  1 Sep 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273179; cv=none; b=Wr85fw3ldqJv65sw2YMBXGLtBGStMPaah8rxg8SBBJc5y4bfEmCTvic2m78tWJg8IM4GAx6mWo4zYaCfTRRYOFURRJO1tSepflhU+fotDKOv13cEhrzOEU1mDEvX36W+JWj0f3wEMKzUdzONk4hnYt9szdRtC+kZb+McKBmGcIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273179; c=relaxed/simple;
	bh=z58Mm0SN1LgkTu0f/4HwY7CvRWym7uV6CGhbgIDTtNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKF4Wo8TdAp3sO3czvNmKH0oW4S25rxI9MEBWvRp/uBFQXVanApitQAK+K3+u3ig1Ojdc+mSCj6TYptT+tYeMfqqhAD+wZntFqNLUkdXaxyIgOnq8Isdiwdt/k8LeNNz157q4qg+9Pw7PpmSh72VbeXw0nakE0oYqTI8rqu7zDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn8lPlYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn8lPlYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463AC1F000E9
	for <linux-cifs@vger.kernel.org>; Tue,  1 Sep 2026 14:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273178;
	bh=z58Mm0SN1LgkTu0f/4HwY7CvRWym7uV6CGhbgIDTtNI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dn8lPlYeZTPhptTul0UnF5JWJ7f9F1uQGbasZMnUw2xM85hZeGG+EEoFiOKHR5k13
	 YZK9GqeBO4qbSq20s24asshpuxHat82qrnI88cXuDDH4hMAl7UF+zWgox7V9NrR0Ig
	 oH2BzDdTaeh/WcmjdoQCC3DqBOflqD6F1ZgwbO8K+NI20ADZd/HErT8HOT763cLUjN
	 9EegC1sawsqTefhcTLvyAPI9NfhD+wymz+d/OZIfUPqdhQEv1ySGQoG4t/9zwxypca
	 AY3bndTsQsnsOmZvTuSRt1+Uqc3rwtYKE6E4x1yTBG1QFzhFufvZt6KS01BYHmXa6z
	 66ZuH+LXsFQ8w==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c255acff671so689963966b.0
        for <linux-cifs@vger.kernel.org>; Tue, 01 Sep 2026 07:32:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzs1ekCtXfWEkDtMDvUzik3d2eemDd36i61hDVWDDbpHZMYEh1ck5TDWAtEomznU0uklmwqVQx/L0WP@vger.kernel.org
X-Gm-Message-State: AFuF++kX5O4JprKoch914R2MtfjgohMZXoLsX3dZKYfU1ZFDo6iqtAJY
	+0WTaJnM+KkmzEpaLBxlEfJ0+vnq5TtGdjf3BXEaATLoL4mY64dBh+306ZPzscc5heWNDekkdrh
	19bBoM9JOAhwGpRGUUY7JUV5HN47/9vU=
X-Received: by 2002:a17:907:7241:b0:c25:88e2:fe25 with SMTP id
 a640c23a62f3a-c2588e305d8mr1164228966b.7.1788273176940; Tue, 01 Sep 2026
 07:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901-review-ksmbd-copychunk-offsets-v2-v1-1-4a7f598eb9c9@berkeley.edu>
In-Reply-To: <20260901-review-ksmbd-copychunk-offsets-v2-v1-1-4a7f598eb9c9@berkeley.edu>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 23:32:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_JgQA15ET-djXDN_eJo4P1oSx+Ccn=GeXJUnMNFKy6VA@mail.gmail.com>
X-Gm-Features: AcwNN1V3EHowwTRoCfjcL7ag3fkg-hNgWFZZw7IB4QGNKR2r65GeV2Qe4lrHfcY
Message-ID: <CAKYAXd_JgQA15ET-djXDN_eJo4P1oSx+Ccn=GeXJUnMNFKy6VA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate COPYCHUNK source and target ranges
To: shakevsky@berkeley.edu
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 9:05=E2=80=AFAM Alon Shakevsky via B4 Relay
<devnull+shakevsky.berkeley.edu@kernel.org> wrote:
>
> From: Alon Shakevsky <shakevsky@berkeley.edu>
>
> ksmbd_vfs_copy_file_ranges() rejects negative source offsets in the
> copy loop, but it does not validate target offsets. It also calculates
> lock and overlap endpoints before ensuring that either range fits within
> MAX_LFS_FILESIZE.
>
> When the target is an alternate data stream, the buffered path passes a
> negative target offset to ksmbd_vfs_stream_write(). Let n be Length and
> let -d be TargetOffset, where 0 < d < n <=3D XATTR_SIZE_MAX. For an empty
> stream, the writer allocates n - d bytes, then copies n bytes starting d
> bytes before the allocation. An authenticated SMB client can control d
> and the source data, overwrite kernel heap memory, and crash the host.
>
> Validate both ranges before lock, overlap, or I/O calculations.
>
> Fixes: 8482150a0743 ("ksmbd: support copychunk for alternate data streams=
")
> Assisted-by: Antiproof:GPT-5.6-Sol
> Signed-off-by: Alon Shakevsky <shakevsky@berkeley.edu>
Applied it to #ksmbd-for-next.
Thanks!
