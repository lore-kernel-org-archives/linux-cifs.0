Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BE61C943E;
	Thu, 22 Aug 2024 12:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724328103; cv=none; b=SOum+1WCdX3SpZz7eVmZloiM3ijRE1ouE2mx1lg8kn0MRFvKk019onJlg+/enzJzWjU588q8p1ya+3Mf+5OBzAHSB9vyR5nzSBiqIFig9H5QquhzS2AZVXCXrPh9NNn+auiSym4rVqsQe3SUvwOcDfOH0Y8WTt/C1dRPrVnQ50c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724328103; c=relaxed/simple;
	bh=rnP3ScPpv0mfReICPxXjJIQ5VK/7m9rc8+Ri/xWWkts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aPn2v7QDssebGyX2mynEcz/1mLOgq3TuPQ7z0hNYphkpuIiD1e/UnXm9iIpWiMwB734NzMWVk2OuOV0MqOes6ciXfkekFxj6H5QmvgBP4hXLPX09FA3v5VHn5IbVun+YBeZU3xq4yUjyrRVqwG5k0B3FIkxso4MfzqvVT6Zx8nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTryvd1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTryvd1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016E4C4AF09;
	Thu, 22 Aug 2024 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724328103;
	bh=rnP3ScPpv0mfReICPxXjJIQ5VK/7m9rc8+Ri/xWWkts=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oTryvd1j5i5/vd3LWNElkGFGkV+uolwxL8EuAeh7LniqG8h4U5RcxD6CksULdFJ0Y
	 m8eu5yR25fIUNh5x4q18o8BgHa8Cam3q4rJB5BgnVSeWvP5FLp6YxKC6qYkvV0i20I
	 cLCT2bRr3SuG8qFH7h0INAMgnispijpyM9dOdskU5jcoa9hdYTOidlt8OtMwmXVERi
	 mab9jQQxeVutniGSPb66/qbd5fABL0frxOOyj3XN2OZkiQBeeGUJUjdBfX0/bLpauF
	 ZFC8yuqsWj7RY5CoLyKff+jViDsS6Uj1LFT12muoOJIy3yz+NZe2Wtqdm02JyFIBot
	 j9rVxHWYEABqA==
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-27018df4ff3so478580fac.1;
        Thu, 22 Aug 2024 05:01:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVoxe63FoulYKbvxWW4tFFcyNzDuBzgSf34hhNkBeUX9YzjtfZ2jmC5XqAyoIdjCdkxoCufnXjgjGL3@vger.kernel.org, AJvYcCX4bHKmdmern+RLfsacLgknrrZfhHVNK/PwHK1Z3v+23lDNRnnsUaI4jgCaC7D5JeNlVJIPMd365hQRIWHis1fX@vger.kernel.org, AJvYcCXRwGYM98CGbBk1k2FhtB2HJfii+A0luj9zwFXYMItUml4DFvwr0T3x1tjL9wjxetWqiVEuXdGIFYc5eEMp@vger.kernel.org
X-Gm-Message-State: AOJu0YyBvJu7lQRcgLzOjFsk4b4ZQtdyXTV2r/T/QsBkMjsa7I4DMHbd
	T5H8Txt7ZTCIMMJY4jDzXmT80os2NTkHCcK5fos42DaGvGxSReJhxOGuzvLjJ9FVFNopIDumQtq
	xwsYiyvJFme4XTv11inP2BS+I6vQ=
X-Google-Smtp-Source: AGHT+IFoXcfXn7ZzU3WuwPr4w1SrdkIUcw0L0cr2GQE3IvzOhU9bm8FeIdTzdcRaquclfLgsRsz5pxESttvywdHkfrU=
X-Received: by 2002:a05:6870:332c:b0:260:e3fa:ab8d with SMTP id
 586e51a60fabf-273cff2117bmr1798113fac.37.1724328102315; Thu, 22 Aug 2024
 05:01:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820191520.100224-2-thorsten.blum@toblux.com>
In-Reply-To: <20240820191520.100224-2-thorsten.blum@toblux.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 21:01:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_T4JzjOVFqxSt=RQG7w0yzPX62-AihQHUepvS+80BZJQ@mail.gmail.com>
Message-ID: <CAKYAXd_T4JzjOVFqxSt=RQG7w0yzPX62-AihQHUepvS+80BZJQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Replace one-element arrays with flexible-array members
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 4:15=E2=80=AFAM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Replace the deprecated one-element arrays with flexible-array members
> in the structs copychunk_ioctl_req and smb2_ea_info_req.
>
> There are no binary differences after this conversion.
>
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
> Changes in v2:
> - Use <=3D instead of < and +1 as suggested by Namjae Jeon and Tom Talpey
> - Link to v1: https://lore.kernel.org/linux-kernel/20240818162136.268325-=
2-thorsten.blum@toblux.com/
Applied it to #ksmbd-for-next-next.
Thanks!
