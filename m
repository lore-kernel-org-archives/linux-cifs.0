Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E430231F9A3
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 01:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773366567; cv=none; b=rTtb7vCSBzDB1Wxo6VoOcyvjklfiDJQYX2TNGU689q11nQZImCYnobPVoqwwEqufvwXp6vIrGKh8ugl1bTXcJXPTPWrZE8vy6Wel/bZaTqd+Fy/kpuB1bVRAHNrVvObYptxh5JMAgXvY3X5eml9aHkTPS2lQ9GTVxUPeC7TruwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773366567; c=relaxed/simple;
	bh=gKUbH7pXSsf6Uh79RDKN5aGbvEBFYzsNjjrRkejw1+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WT0MQYcEcMGFR6EZK+jM2auAIk26AmnCd6d+i4yjlUN0o1tGov4pcuLyAzuyQSKJg5HC2+ED+kG8Kk2SSZm0oW5gYQ5i6vV0IeY04o3oELpJSqqwJxaSTDJysCEHHvQC0XPGhXoAzg9ktX/ERiku3hTy9BjblPV3g7qsFOgNKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3v/3QPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3v/3QPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79682C2BC9E
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 01:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773366566;
	bh=gKUbH7pXSsf6Uh79RDKN5aGbvEBFYzsNjjrRkejw1+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f3v/3QPNduq0VfGuegdt4s+GCRikIehvB00sHtMy5RfuNqOkW0ntoTdh7rh/coGHx
	 pTBqjJGDtOLvBnPtI3tD0ZiHKvIGyoLCcUEn2juLRIj6a9Ad1P4Ofj9hiSFQZ7nkxo
	 VhWu3XZhxqWF26bSZAgEBpnCdCL/GGlJit+8UFpHO1WywX9djmBUKdkj8EHAz/ujdX
	 XhlOCS3XASYlelVfiG4WR95vdjIsIAddJXgMNH9j+QK2/lXy9yaHRfCgi0c4/60OPJ
	 nZnycPocHi8C7yzK6XAIGJkeywi3A7bSdLluF1oWkN94/g8lAwl6sHsQbRkJHW1t2c
	 4jMKaRmnJR0lA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6638ce09a31so2054043a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 18:49:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVK2pxM9K41d0Z9MdcJTk6uP7M/pOth1nIUXkuC78K+foLeHVSeppZRDQq1Ti2O+KcI+ThwqNj1FxAP@vger.kernel.org
X-Gm-Message-State: AOJu0YyYfEHmfhEAfLtLtmyXBLNgqaeYjMn+KNsF1kp2n9F4VPqxbUqJ
	plJ7+3mnAAHisRiSPHf4TUclte7SUHkUHJpdO9QT7U6NtmPny0qkwHmAnS5dYaAZQaT75qQ0VCd
	QdL09CAglnp1Qrt93DLG7q7qBV/l1jaM=
X-Received: by 2002:a17:907:9452:b0:b94:244b:2ba8 with SMTP id
 a640c23a62f3a-b9765103493mr93652266b.29.1773366564981; Thu, 12 Mar 2026
 18:49:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <abJ2NzsiCzxyySzS@v4bel>
In-Reply-To: <abJ2NzsiCzxyySzS@v4bel>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Mar 2026 10:49:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd80h13M=vj4aF3_JYvwRy=xP5zi-kXWz-1qqvh2bx2iyg@mail.gmail.com>
X-Gm-Features: AaiRm53fqeoRc8hMx-gKtxzeQriREgWBCAceQnRvuekBAFCzqbWBfx5RQXpPzPI
Message-ID: <CAKYAXd80h13M=vj4aF3_JYvwRy=xP5zi-kXWz-1qqvh2bx2iyg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in durable v2 replay of active
 file handles
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Fix by removing the unconditional fp->conn assignment and rejecting the
> replay when fp->conn is non-NULL. This is consistent with
> ksmbd_lookup_durable_fd(), which also rejects file handles with a
> non-NULL fp->conn. For disconnected file handles (fp->conn == NULL),
> ksmbd_reopen_durable_fd() handles setting fp->conn.
>
> Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
