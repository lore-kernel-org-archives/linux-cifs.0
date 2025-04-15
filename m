Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A7324B28;
	Tue, 15 Apr 2025 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744678828; cv=none; b=Z494IC9i/pMmNG8WOGbSBGdnOYLOyUpJoa8dM4osIPP9Q73dH3dOqgZladhBMYxXjpY11gfjOYStY94Ku5Jh8l3E1R6NZsj/opwrxeZqOwqG8iwLkDKkIl9Csu72mYloKAS4slRk3yTmY1vl67NKwx/5CTQwXtqyw5xs/y/LzgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744678828; c=relaxed/simple;
	bh=K6PEbgnqPaBOxBJLSMKaz5HtTYWkiTxoA1qXO2+0VO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H83hLo241zSonzGohecNsZSxiYj+w12XA3z2xKX+QOMqqv3GSEaRAMqDTEEMEH0s9ZQkJp4cx6WXLT5ttOpg15iiY8hvnyVxR2cTXKqh+xam90L+X0tZ74lKLK1D1myhFLUtRDq8u/kiyZj0HKM3K4ys6nNWkFcqCkGVCYnM+PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5L1SXAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5L1SXAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F352C4AF09;
	Tue, 15 Apr 2025 01:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744678827;
	bh=K6PEbgnqPaBOxBJLSMKaz5HtTYWkiTxoA1qXO2+0VO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q5L1SXAFkvcr54C9yevqkwlPY2fIbFuCYTpQBfzFIJkd7FSiXwaeCRjwlB6BOtLVD
	 zQSg6sM+xVxC0mPUSQkLMhz/KpjRPt4mRvNZxL07XBUTRZwRGH7jP5xu/5KBaJOT4E
	 Lil5YujLxp86yDzSBQJ7af9A1R9YwqtwRsltxhXsfgAJgypkRgQeHTW5I8tfRzZiZX
	 9I0UeMXzba5uSuw5Yeo2m6ZKYeYet2gr7QN6RNbpMHRm8jTG/cdlsWBVvLZpDOA6FN
	 7uby+hXFXNBdH4ETcG3sXBz0bemTYW0ozI/JDYVcSlK8UHZwZgH4cZOz/Qgr4UNeqR
	 SxRioPv/W2w5A==
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6041e84715eso3466376eaf.1;
        Mon, 14 Apr 2025 18:00:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV8Zu9NSJpO4TinwGzQA1dm83jd5LzZqUswvpRpC0zxvEMmpfoaw/ZFnXHMGVS64x3ilX4kZTE9HSpl@vger.kernel.org, AJvYcCVLh3UnymAaZLYIL5lyQdRBbcZ3dWj0Prxu8AZ21Q6vfKMgQ54+7kLB6fevNT1XUfJbAyGLSbxV@vger.kernel.org, AJvYcCVQEck7YtzaXhfPx7qHNfpcxP7WF174+WQB7+ZVMooHsznmN8mP5Gg7KyEYORmLKPBI8dSImhVip6NFR/6H@vger.kernel.org
X-Gm-Message-State: AOJu0YyS4liaBIvallNGQPust4m5a2XU1Alkr/O0bPXLEND9a1z6Ep3J
	raLktIwYWAVXtXUjo1nKH+LGckwxbimzuymQadD9tLqKXXP97f5QS8PvmSrZ6uCLrB3VWnOIuKw
	gJy+y52ExUJooE6KkpdsnkrIHlm0=
X-Google-Smtp-Source: AGHT+IHUMpNbLrVf6vnhveIpcR9pzlxuWln2jN1xHsGdwGfAZK24npjOSma5eyLz98up0FYceSc+owKpOeYv2AaVwFo=
X-Received: by 2002:a05:6830:6285:b0:72b:9674:93ed with SMTP id
 46e09a7af769-72e863c0294mr10325319a34.24.1744678826906; Mon, 14 Apr 2025
 18:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409090450.7952-1-arefev@swemel.ru>
In-Reply-To: <20250409090450.7952-1-arefev@swemel.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 15 Apr 2025 10:00:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-3HeFKhtdOnXWqf=TXqY6-oYb23Cpqwugjb=mGuY9Bvg@mail.gmail.com>
X-Gm-Features: ATxdqUE1y7AdLkJadVp98zaY6hXCz7gfEeGqKwgRAitSLBZGUVH71iEKBSODd40
Message-ID: <CAKYAXd-3HeFKhtdOnXWqf=TXqY6-oYb23Cpqwugjb=mGuY9Bvg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Prevent integer overflow in calculation of deadtime
To: Denis Arefev <arefev@swemel.ru>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 6:05=E2=80=AFPM Denis Arefev <arefev@swemel.ru> wrot=
e:
>
> The user can set any value for 'deadtime'. This affects the arithmetic
> expression 'req->deadtime * SMB_ECHO_INTERVAL', which is subject to
> overflow. The added check makes the server behavior more predictable.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
Applied it to #ksmbd-for-next-next.
Thanks!
