Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D8282F34
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789869895; cv=none; b=lIMC6CoK4bWMVIj7VRW3tO6NOh/geE7DrJSKhDTYDqTHYipcZVMLjY74RTQRS0gLZv7nD+8pObQjBb03wj6NuOW1+PAF34lR5LcRuT90uTgAVBYdYRJn4/B0HoBB2O70GuG8O0IcceHChemZMLEjH5I0KJm9AevjTGEz6l7fVhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789869895; c=relaxed/simple;
	bh=Ng5BuS8ch79WVnD9NVgziFe0emmd31FwSzLMOJTUGkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nj+NPk1A2FRqt7sWdkgRmpdVsGAFeWCws3lgxtUB4ajkb53io4zUMFG4KbyLGu5zLCjXHvkpT9CHLUB/kjKhn+Ra6Te+OXHrf4w8oKIMDUyvK5vLegSZ0W3KFE7wBSik44MvEqNxe9mLknAul1jSlfpNCYw0Im15KuZs2w/zF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HM9WUbFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HM9WUbFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D241F00898
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789869894;
	bh=U8Ml/KBmJEXhkod6xmK760NWSufKM1r/IvqwHM4jtrE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HM9WUbFOOauZ6gWoPLFD+05I6T+k6JTtkPAm+fwX1+gHum9UOmU0gn0WCBr+jeLP3
	 YcaOQz1pz7gg3HLmWkAEtbk9OrUjr7LqOoKmQAAmniP+8RRk9Q+VU9oNc4qXyDQ5cY
	 IiO1RxmjOgxdZQQHRcflPIxOtmCmGR5kxJKDqmUdziWT/Fws1p4eDm+y8MeRtBK1tl
	 XRLwbqVNdPo/2q8ByiwleIbgl5jY/VLtgmgekdCxTfZH3pqWk0FH5X7kisZhnCp3Cc
	 vQXr0vZCgswxaVAZjP/TXvzUrZUF5ET5UWfNdRsHu018zxTaWxpy05uTtt/TsOhBxl
	 hIbE51tUsZEqg==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a985fba28bso2233715a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 19:04:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwi22DMQcA0POTdXcHjdI7B2O1pvl8DNDVezQrhgwVf971GcPKAUThczuPIrfJTiTcnQKVfAneRHH4L@vger.kernel.org
X-Gm-Message-State: AFuF++mW6HKnWjKGC9j/+L8p2ioIE+poIMS8GkMn71JPQcaqQx+tT8CC
	IUqnTRE4pnqR5Xnsyb+X+TAeEdZwg6DzNVbx8AAuvnevD3qpRl+qp5RZU8cvYjqO/n54p5rEJ1x
	3c/px3F5EgWADHH56KFb1ghe3kXffPjk=
X-Received: by 2002:a05:6402:46d8:b0:6a9:b549:eed6 with SMTP id
 4fb4d7f45d1cf-6aa531b83aemr4714626a12.32.1789869893014; Sat, 19 Sep 2026
 19:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919165828.2230488-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260919165828.2230488-2-Jeremy.Jean@oss.cyber.gouv.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 20 Sep 2026 11:04:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9z1VTUXEXzMwgd=tTv9HXzTWAqSp3YAtK3apN77xO0ug@mail.gmail.com>
X-Gm-Features: AcwNN1VD9WG7RkXv1plzl1tPk2D4zbi1yZwi4tsHgffuTqqcujSjmFhhkBlBBvQ
Message-ID: <CAKYAXd9z1VTUXEXzMwgd=tTv9HXzTWAqSp3YAtK3apN77xO0ug@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix SMB2 CREATE response buffer overflow
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +       if (cmd == SMB2_CREATE_HE) {
> +               size_t create_sz;
> +
> +               /*
> +                * A CREATE response may contain any combination of fixed
> +                * response contexts. Account for the 4-byte length field
> +                * because work->response_sz includes it while smb_get_msg()
> +                * skips over it.
> +                */
> +               create_sz = sizeof(__be32) +
> +                           offsetof(struct smb2_create_rsp, Buffer);
> +               create_sz += vals->create_lease_size;
> +               create_sz += max_t(size_t,
> +                                  vals->create_durable_size,
> +                                  vals->create_durable_v2_size);
> +               create_sz += vals->create_mxac_size;
> +               create_sz += vals->create_disk_id_size;
> +               create_sz += vals->create_posix_size;
> +               create_sz += vals->create_aapl_size;
> +               sz = max_t(size_t, sz, create_sz);
Since these sizes are fixed for each SMB dialect, we should avoid
recalculating them for every request. It would be cleaner to define
the required CREATE response size in advance and use that predefined
value during buffer allocation.
Thanks.
