Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4213B0AF5
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602783; cv=none; b=j7XdgKacf4Lyf044vYyhPaw9IIR4Ua0Ju0cNJDa+MhFrL9AtJiTV7+Aer2pCClXBWlkMM1zjMO0DJvZ357JRA1kFMbem8Hd1xzcrCO/e+IgaGsOptru7+vdKcE3fTbJmPIc2bD7sCN7hV8TQoMxuyrdI6BuxnkKogLqmuzSDMaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602783; c=relaxed/simple;
	bh=UvixdReq8uC46b17UpRVvutmdKuzR2ENw+ofmkJbiqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DLqEYpCyQ5yS9pa/9XGVq5h1oyPnkZacAN+gJAtjJ/N3S673KwHM/3KlXDXJI70BWw6QkxZNnoxSchhhtmohMpTjggT5kTrhp/L5JuJOPxln6fNhqygThZIgjbgEF17XKpAIOvXIuQgrrMO/b+zSKKcqZvqDEVFXKU0WxPWFM7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxIEH12Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxIEH12Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF601F00893
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790602781;
	bh=wPz9FQk8E73XYxcsndF+zTrW6B2je9XO/xvvkOSvBO8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZxIEH12Qo5xxbs2/AFlx0w140YpCzaiYRATG+ZSQAQvMWM64Y1LUQC0APgNUUz6cM
	 yZyVNTC92Nm/YTi7GgDdZ9ZN01Ls+cEeNr1wZdDf+tGArTaJge1FLW9laxQbR3FS9v
	 U+SlTtZksJVJhVJ/3YF+IPXVpqoFzg9WFrWJbqUDOgGrUSrfBbYgK8NuhxZIEIqdGU
	 RQM9QUrFCdx5rkuBK9I5Sxd8zX/R6l3jT9rxIT/rA09V5HqNR5WNVH4o60CjZ+kn73
	 m+tNpKRVTE8n3s74ZOaFAi8c3wPaANy72YVf4XkMLRj7N9+r56M5G2JdjkPyUbWH1T
	 n1bWaSmO6ZmsQ==
Received: by mail-yx2-f41.google.com with SMTP id 00721157ae682-8a7c33dbfeeso28401867b3.2
        for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 06:39:41 -0700 (PDT)
X-Gm-Message-State: AFq9FYLBb9WvR11fgGbD8h47wXwVEAClLPjBEVjmWU/xn3/GJWaD+MEN
	g7rOQ5ZCyVPTjhFXMbwnhGoCcWCFs8yvmOyFOoRn4LJjpjSkBp6a3W/7jsD8niydPsV6Tbc5ztk
	QqNV9JH/q/Yo3yZOD7AidTHlaaz16WRA=
X-Received: by 2002:a05:690c:7108:b0:8aa:1ecb:531c with SMTP id
 00721157ae682-8aa1ecb548emr16703287b3.37.1790602780715; Mon, 28 Sep 2026
 06:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928031300.1782690-1-zhangdairui@gmail.com> <20260928051742.1789650-1-zhangdairui@gmail.com>
In-Reply-To: <20260928051742.1789650-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 28 Sep 2026 22:39:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_HZweJK8iRU1S1UkUFGn8tTNmEKbaS_uL+U1kh8=inLg@mail.gmail.com>
X-Gm-Features: AclHuK85Yf66L1a3W7JUO-pfT0ZUBKdkX6tsPINDJu9Eo1C6VWkMDacpTHiHbEY
Message-ID: <CAKYAXd_HZweJK8iRU1S1UkUFGn8tTNmEKbaS_uL+U1kh8=inLg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: verify transform SessionId matches the
 decrypted header
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +       for (;;) {
> +               if (first) {
> +                       if (in_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
> +                               pr_err_ratelimited("RELATED_OPERATIONS set on first operation\n");
> +                               return -ECONNABORTED;
> +                       }
> +                       if (le64_to_cpu(in_hdr->SessionId) != tr_sess_id) {
> +                               pr_err_ratelimited("SessionId mismatch between transform and inner header\n");
> +                               return -ECONNABORTED;
> +                       }
> +                       first = false;
> +               } else if (!(in_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) &&
> +                          le64_to_cpu(in_hdr->SessionId) != tr_sess_id) {
> +                       pr_err_ratelimited("SessionId mismatch in compound chain\n");
> +                       return -ECONNABORTED;
> +               }
> +
> +               next = le32_to_cpu(in_hdr->NextCommand);
> +               if (!next)
> +                       return 0;
> +               if (next % 8) {
> +                       pr_err_ratelimited("NextCommand %u is not 8-byte aligned\n", next);
> +                       return -ECONNABORTED;
> +               }
> +               off += next;
Please check for overflow before updating off variable. Invalid
NextCommand can wrap the offset and cause an infinite loop.

And this patch does not apply cleanly to #ksmbd-for-next branch.
Please rebase it on the latest kernel(7.3-rc5) or #ksmbd-for-next and
resend it.

Thanks.
