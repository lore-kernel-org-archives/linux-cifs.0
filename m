Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F97C175A94
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777252023; cv=none; b=g2w4erHeGs0X2gUYvPkYe89bsZdT+mJlHWsbBUKDcFMwBINS0c1yz6y7tAhjkgA5aGRmNfsGoSazBkZRU/XBEREOSVFvlO/fQTbSFah2320B3CEbjrMMyXOgtZYJ9OZK7w4aqbXCTuqEvNSmmvEMJrfukUuDOxjD5GBhTQOsX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777252023; c=relaxed/simple;
	bh=SP/GVYPG/eEei7gw40gtFLPAanmcFHffJN39FXiZEWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHyhjVdNjMy+aSk+wb/ztrvzZUGH9nhv+doDm9hH58aOPmTVd3iw3Cngj21QmqPdVloGIqMVfKc0pHgMKfIXE8qongGZwaWZd6pr5ZJkKPVPU3PObt1Fyy6o7YIbUcUg4ASvKfe1J0AI13XE7uSro7MnlquvxANnbsNgPdGL2qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBb5utJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBb5utJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0855C2BCB3
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777252022;
	bh=SP/GVYPG/eEei7gw40gtFLPAanmcFHffJN39FXiZEWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bBb5utJ5xKSXs/U9fmY4ORvprsLSNR4l6M4LvCH+GA0psC9pgfB+7KhLgXi5MPVjv
	 wliE3L3LsvllX96gPK/qh/oOuWz9EUJbwUK/B6PrnL/QoK6K5JBqKj+LdnWIv8RGMH
	 /gaFygt3+E+qBssKEfUy/IM2ozWBrODcT2QyldaIXDNKbN62OcdHZaQXXA1B4URNlg
	 x45TI1rnDJatUO3b9HwyCnrae6/wt6f/CkB08JTaTSKIe+ZJr8U9V0iNeKvK9jk1uO
	 RsNJ+x5ki+EC8RjnNUwPqHojI37KD6n2ASoYxkcvx4rPRw8TZ1OM15LLS9kPQRgOLF
	 S/OPMxyhlSWUw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-678e678970fso2375801a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Apr 2026 18:07:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8XCQEdSBgtFwuwHc2Ann8FLc8hZ7bKQTeePmr0rhRx/+CBT9wvPEjtyYwH2LR0PTzdLHLmEmhLVbR+@vger.kernel.org
X-Gm-Message-State: AOJu0YzNZqDpU6AgtevrHKbnn+Yoel0h1k+MgIdyaWwQcce1BdLxTEct
	VVJK0zA+RGgohPtYJ5hempXKQpKZJ/JCvWEPmLKLLlLEC444vRk3nW9K8NQ88Owgsl4e9nZ+Vk0
	ADsnC4SlW5HHqHZ/UxtEXnph1a826xNw=
X-Received: by 2002:a05:6402:24dc:b0:671:c31a:575a with SMTP id
 4fb4d7f45d1cf-672bfdd4dbemr13673687a12.23.1777252021463; Sun, 26 Apr 2026
 18:07:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260425093829.4004785-1-charsyam@gmail.com> <20260425093829.4004785-3-charsyam@gmail.com>
In-Reply-To: <20260425093829.4004785-3-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 27 Apr 2026 10:06:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1q_6jXT+A17s5Q6JgUFJvYAt4=GJ3vYG7ruz5x3PexA@mail.gmail.com>
X-Gm-Features: AVHnY4JbCsWkwfsFjUWPEBH-HaEq4c8C0MSse37IOOPABIYuuA9JbObwRN3VUoA
Message-ID: <CAKYAXd_1q_6jXT+A17s5Q6JgUFJvYAt4=GJ3vYG7ruz5x3PexA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: centralize ksmbd_conn final release to plug
 transport leak
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> -
> -               if (skip(tcon, fp, sess->user) ||
> -                   !atomic_dec_and_test(&fp->refcount)) {
> +               saved_id = id;
What is the reason for backing up the id to saved_id?

> +               if (!atomic_inc_not_zero(&fp->refcount)) {
>                         id++;
>                         write_unlock(&ft->lock);
>                         continue;
>                 }
