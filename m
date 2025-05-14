Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FD2205AA8;
	Wed, 14 May 2025 08:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747212307; cv=none; b=AQELMf+EbZCdultmELdy7RvWEW+UnodFId8238o6D1pxLEKv24CyJQpegmzv7T834+K1ivnNv5oOyvxkfaQCGrUUfjmdE/541dDedoWBXozgJPncrKupgCISVfr2RaQUqoXvIXPFNFZv9ZbwkF9rjwQFjaSiLHYWQZfjb6cX8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747212307; c=relaxed/simple;
	bh=fYGfM9KGKQ2rzwWSn3+P5jzIdCtcvTxXdsoSKU+gNUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A67SgJ3y5m3D0LfQ87V5Zc/sjRK5ZQ6UNC3MPnrFHq4zjn7tnbZUWv2hynCdOmzS9am4eqaMERnGyZz2t6y11AbViGmw0HyrjV075x0uIqU1uXHv0wWaWhCgZzj0GWgmbj3vRGvyEISuXlq8JW/oWyC4hfe3t4HigY2mxmTkC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0ACT7AD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0ACT7AD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F51C4CEF2;
	Wed, 14 May 2025 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747212306;
	bh=fYGfM9KGKQ2rzwWSn3+P5jzIdCtcvTxXdsoSKU+gNUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m0ACT7ADC/Q3rHFRlBSgBEcglDjTpqVI963CZtjJ3eVBSmYQMBV80zcyzE+a0lpMW
	 aSHetup4vr/NQdGJVZOdUwue494zJduu1+fUjXNwsu9/2h8wvRiEyY8FrmzAr1MEvz
	 tznSvyY/+mN9AHLwFcUzisE/lgWAHGKjIfRNI9eWtExqZrrYj59Fzdljo+rgUG4zoH
	 vV503b9to/ToQljM0W+GBXLCUutHZW7H6uW5IEwosm72AwFszD2daDrVR1zQY3Bqe8
	 8rgHvZyDdjf1RbEO4v5KjSubBsB3Iz+rTiLH+Rp98HGCtD4ykmJ0+S0Q7xLt4C0TNL
	 gfGPV7C0ZMKnA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad2414a412dso602305766b.0;
        Wed, 14 May 2025 01:45:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmldzBHujrbqDcseJn3bAFL8deBll2hw/shGfhV6h6eS2Br0od0vz7X9vIie6fvp9rYk4HKPWB6SYf@vger.kernel.org, AJvYcCXPw3FyBqCHujhfL1AH46bXPSaa2/4rjhbCowsXIndCIrHUQxB7kTRkgz/YekmTOnwSDPwqoaYKLHct3HKF@vger.kernel.org
X-Gm-Message-State: AOJu0YwUGVg2jN3R0GraEjg0WvD8j66nAKJNhStyEOYPcZiQo7b4RPgD
	C2swEBDf1o4lytjn5kVFXs2Y5V3xLeLHcfRKfLfXc7K2vJ6AYyVptYwqJx2B4BoBjcnpkYmD5No
	kTo4eJtsWdMfqxQFT16kVO2eoLkc=
X-Google-Smtp-Source: AGHT+IEONbjJZqBPnIzfBcNkwFXSwYWrj4NIzJAcnxfbGPYJG20VicNqfeKHYMap3qX4pGcJcAfXWJfrJaDpdYYSYuw=
X-Received: by 2002:a17:907:9723:b0:ad2:4e96:ee11 with SMTP id
 a640c23a62f3a-ad4f70d3306mr246891366b.8.1747212305158; Wed, 14 May 2025
 01:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514045034.118130-1-ebiggers@kernel.org>
In-Reply-To: <20250514045034.118130-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 14 May 2025 17:44:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8XBT7Vv3qr0=p86R-KtNk=v-GFW82BsKWkppzcfvzvFQ@mail.gmail.com>
X-Gm-Features: AX0GCFux6U5HmBRaMBdTYnXJdStXI_x0P8BfjrmFoTVxMibxs_xhdm40mn6jCEU
Message-ID: <CAKYAXd8XBT7Vv3qr0=p86R-KtNk=v-GFW82BsKWkppzcfvzvFQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use SHA-256 library API instead of crypto_shash API
To: Eric Biggers <ebiggers@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 1:51=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> ksmbd_gen_sd_hash() does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
Applied it to #ksmbd-for-next-next.
Thanks!
