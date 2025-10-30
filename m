Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B179334363
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 08:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811913; cv=none; b=NXY48ZpbVmVn6zXf+QR22MsTOoMZrnkpOnPHRefQv/KqlzCourkducDmPiqXGBemPv6uRS68UijCKQWHh82WRg8Hx+9Ob3ugmkiuu5XTWQE7AggMvWw4CvdURm/xxFX+aUsOODZDObGvbgpoqjIm2VuKJFH/YcNoDVQJNmPmhfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811913; c=relaxed/simple;
	bh=vCcTYuH6mTu6qyvg70BghXWQVnQ8I0gdNc3/3b60Ajw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKv9NJ2ERZa3EAq5isW9SaTihschfn+7eveOE8qBqGUbUnubTH9E0gPYeNgPUD0/4Ytv45K/XqH6yxbl6JPnFEsS5pBLwI87dSicF/wcOUBBApb+aBrKoykzAhVnSkZOgHwA3RXC7TvoMKs5wCEVRbv5iw/TPFHuze9dL0TjMnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4iTK/Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4iTK/Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B314C16AAE
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 08:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761811913;
	bh=vCcTYuH6mTu6qyvg70BghXWQVnQ8I0gdNc3/3b60Ajw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b4iTK/FmXmNI6qUZedlTwzN5uSyHwBXWniVl8o7fCmHXlHzGzlso/P/nfsGTdExpP
	 M21qPYWOTnF0oOR12CpycfC1yosNRFGW0/4VpPOeyhsXJQLXitdRMUBFugwU5n0el3
	 cFr6846EQWLhfz3rkB4PGzVtGbjdCI+TFCcuDy5xaLKg1G2Si28sGruIskjPv9d5Bt
	 ZjZoHm2HIeGeDQbghisjN8hNvwJfswpv3bXg5OovTbO2CN7eMXGA5zsEG0+1shUWut
	 C3dMfb+Ubd53l/JGFANxD7fX2fSpmrPRzfeQHAx5WO6xNVoe/q/mwVJcCqVok/xbVL
	 VVXp08t6X/PmA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b70406feed3so209939266b.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 01:11:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWdXHzSmoJGqjhWBYCNgJzun4yjF4Oy9u2cIxEg65XqFxr1FIXrhaOlZfhnmCQcmw549DvZUTy+SbpN@vger.kernel.org
X-Gm-Message-State: AOJu0YyXbHhWJmCVgRaaN4axCvA2N2Wck1vuKINvC4rVxR1U1sr6aiv0
	7LzWiIoGOjVvWa6QnDIJE0gTQkEzdRe76hmgp91UuflxanX9VOCRY0axyY0YlvAcER5D6pmJujS
	mBcQ0Mx1liJYc3QMVN/TDObsIo71Fndg=
X-Google-Smtp-Source: AGHT+IF5P/qdVOfbIIV+SEJSLe/A1R1mpnSYlz9hP4HAxa+hEO5mYBlCRES28Qi95wHLRZ3k7iN612R/4zMk5bAAmFs=
X-Received: by 2002:a17:907:940a:b0:b6d:692e:9a84 with SMTP id
 a640c23a62f3a-b7053e2c694mr214741166b.38.1761811911789; Thu, 30 Oct 2025
 01:11:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030064736.24061-1-dqfext@gmail.com>
In-Reply-To: <20251030064736.24061-1-dqfext@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Oct 2025 17:11:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
X-Gm-Features: AWmQ_bl_8SFNU2Ia4p8afvCEYgPx8n2HX4p9nIHde5wt-h4qbFdQlg8ez7H-da0
Message-ID: <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
To: Qingfang Deng <dqfext@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 3:47=E2=80=AFPM Qingfang Deng <dqfext@gmail.com> wr=
ote:
>
> The ksmbd listener thread was using busy waiting on a listening socket by
> calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
> -EAGAIN. Since this thread is dedicated to accepting new connections,
> there is no need for non-blocking mode.
>
> Switch to a blocking accept() call instead, allowing the thread to sleep
> until a new connection arrives. This avoids unnecessary wakeups and CPU
> usage.
>
> Also remove:
>   - TCP_NODELAY, which has no effect on a listening socket.
>   - sk_rcvtimeo and sk_sndtimeo assignments, which only caused accept()
>     to return -EAGAIN prematurely.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
