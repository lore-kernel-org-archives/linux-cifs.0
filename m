Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506B233E34E
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 01:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776648530; cv=none; b=sRzTtRbxNgaGkYpgdPMXJnrYumSa7FMQbUPQAUFZzYCEAgibQtxJoYXFZ7yearCwuJ5XW3bCC0eYK1O0GXqJIyNe7CHmzCW6mrQD49dqsOINnaIhtqtN4wDJP36HzqEwuZGWeOmHGPwpFcNMZM5WHDQ+ueQGayrAMnkPaiymbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776648530; c=relaxed/simple;
	bh=nDhqbfnQUsARKZvjBJ06Bn0aF5eFj/S58zIRRm3ouMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QdTLgkMT918vH0CEyAlEXTEXpaUuFYxsifa9l1SZf+MBB7txK+VvT8uuXUfjVRawbzYN98We3ndOyZ2cw43Fh+Tue7P6V3BXcoYK7e8v+eNIo202L90Sa6MVPBV+evfXqkuZPtXKm2PWQLzXknfdo+oZywB7viTMBPO06fg1Ess=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9Gs4DMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9Gs4DMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF39C2BCAF
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776648529;
	bh=nDhqbfnQUsARKZvjBJ06Bn0aF5eFj/S58zIRRm3ouMw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E9Gs4DMeM0hQsvR94K4JXZ2BQ405+2M14/OM6pFDksI9jzzx0fIfoukdRHncdI8Ic
	 qCMVa2QqEMndbjcbwdDLih6+mhneIHFLr69TEgW3vzy5IkNqI1a1LvG3FwRiZu/MfU
	 nP2Ci1lXpmi2A4sNH0hTqTQe5ZDd6pCN5f0+QLBOVFWeQXacnTxsVRoWqrqLohmAn2
	 kIATwhYUz6+Q2GEHp+M9i9x9rzf4AXaOWzOb7V2iBMimIczpddj+Xrf7VPiziJ1DLS
	 RNtcDZKrTs5xATXOe4yXg7wbjqCYYmjtAL5D8uyBi0lb2McHLU4ficj7U4xS2flZ9u
	 dy3hyqtZ8zIrA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6714f678bdaso4147857a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 18:28:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+oIImuvmBetwfew6bgEPeqFzhPnCVkrDKFD1BvbyyvR8wYb9wJNVf7ythEe4mqN4bwbgOQOn9uWljH@vger.kernel.org
X-Gm-Message-State: AOJu0YyAIiqcWasKHHSgNzwQ0/NM+yolqovcc9tzPQ6ZiBls5QnCkhEF
	5zSjSUfOQTb+xs3BVYN1suswKHLhMrLfKz+WZzM7LQN60QY6yCOOdRd9GUJ2zslMBhduSad+sty
	ZOC+llaYGAHCT1Ui538gBb4lrFEc4fzw=
X-Received: by 2002:a05:6402:e9c:b0:672:7109:61a0 with SMTP id
 4fb4d7f45d1cf-672bfd975e5mr4199192a12.9.1776648528446; Sun, 19 Apr 2026
 18:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419110255.2477785-1-charsyam@gmail.com> <20260419110255.2477785-3-charsyam@gmail.com>
In-Reply-To: <20260419110255.2477785-3-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Apr 2026 10:28:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9E+T-fyeo=Cyb3L8AevbdN+zUhXenffL4mBovdrvDs5A@mail.gmail.com>
X-Gm-Features: AQROBzCKD2uY6PElWh-wRWg1jsPlD_DcAfDDNFA_Rn2WTrrhEHTNBWPQFpMqBYU
Message-ID: <CAKYAXd9E+T-fyeo=Cyb3L8AevbdN+zUhXenffL4mBovdrvDs5A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: destroy async_ida in ksmbd_conn_free()
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 8:03=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> When per-connection async_ida was converted from a dynamically
> allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
> removed from the connection teardown path but no matching
> ida_destroy() was added.  The connection is therefore freed with the
> IDA's backing xarray still intact.
>
> The kernel IDA API expects ida_init() and ida_destroy() to be paired
> over an object's lifetime, so add the missing cleanup before the
> connection is freed.
>
> No leak has been observed in testing; this is a pairing fix to match
> the IDA lifetime rules, not a response to a reproduced regression.
>
> Fixes: d40012a83f87 ("cifsd: declare ida statically")
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
