Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453689;
	b=5dImREec1k3NN5oBuTU9UY+qH9dJNqXt/W2VacvE5JQsET56PVZQzjOvUKPo4cYxKYH0
	 P1R3Y3y7txl+jjLzjiRKL575IAAWsMq6GhkWRnPc27Qk0mcV1Ze7B9TUrOFzyxPV7u5kx
	 NfcSMx2lpRT62jREoHtjDdvrVul3SrVC61sU38QwseW22DsklNAr+w+87TdOywBUBW64B
	 qsgyFcCNRzVew5ghHjtN8taYqFwNsw5QhvhiECKir8ezl/g6RQfYLSvaq4x9XD5BL+Ozs
	 a4zfGnEwCuLLW1WGW4xk6TGVuXLf+uOEcRHCYibYw7BXm9hx56mMzszfPm6AakmyavQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453689;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NgUgGYEdXUH4DLTqTb+i6zWjjXHXqFWh5z6PHbqh+Fc=;
	b=2UQeYqN0CRjoKg9AgvV74WTnvdLZkZsbeAPNpRl86rnIGS/Ezal1E0reeWhqmwHFH5HC
	 5nD+lGTlUKuU486/GA00BaozRgVV180fktvrzc4MQINgQXOghT2dzjafAurlbAsuSMgAD
	 8kfaizWmUHHYFgkNX/CulYPanJVgo9KI7pLgiOHewVa5WutYkRLkz2/REVaVx9raB0qMF
	 nhOQsnrwd3V+Z8B9lSutUgmyAV1CxEpsnSaQJaAAr3gW679fQN0vVSdd9BN6jkKvzccpE
	 tw33ogPLWA9+HIR4UrAxBqYli5sLA3YYE6W6EA/8zUuHf0OvvGjd4jZNrzybxbo9oBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FWvDamp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C07606A31B
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 23:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FWvDamp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B6D1F000C9
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792453688;
	bh=NgUgGYEdXUH4DLTqTb+i6zWjjXHXqFWh5z6PHbqh+Fc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FWvDamp7UlG+1r21LWu47kUBu6e+TeMNAsaWBjYJfhBldBbZroHj6YoLtJpCAriEe
	 EqU+o9h1p80DjeOM+QrQzPSf4197Gy8HdUuPgRRhFZyDi5QHFdnwur5iMK5gyCykOR
	 7d4dhhDBO4ZuiGXUR1LV9LrnQQa0rdHUBI57mCXh08xm+lvIq6K39JVbpICPb3GDK0
	 1uMoNi6Ss2w1GKWZgGp+fWPJJnwoAz00tQkMAnQENL5Nli365FTizygkJkFNGte5+R
	 9P4DfnIqlLmo3y06x2QsLSWXzfE7KBN8qiS2UAPSIL2AyF791SEP8k9ZnzMu1ThyCG
	 PMBt/WeuyideA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c37b612635bso340868866b.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 16:48:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByQGRsfAGP/LPtc5T/0I6hqFIHHM082AV90Vom4hyUlDz35bUWeS57so2y8nyOvfWlsW37BKjsFWETK@vger.kernel.org
X-Gm-Message-State: AFq9FYL3vb0Ofl3On3aWQK7d8f4weqRyVyGfepB5cWrRGUrtXfM0w2Wq
	OAdfqWu4M5T4PhNBC6VkLwlJ+KeROw1WEfprgeqWihdp1fF0AyMtTHslAVFf7fu2oJ2vdQXQ+FS
	QtUT+kTybXGTcs1Tf3vZlhCssT/xkl0I=
X-Received: by 2002:a17:907:d86:b0:c41:1750:59a4 with SMTP id
 a640c23a62f3a-c41a0bd6576mr614219766b.39.1792453687521; Mon, 19 Oct 2026
 16:48:07 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
 <20261017034051.72932-1-charsyam@gmail.com>
In-Reply-To: <20261017034051.72932-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Oct 2026 08:47:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ueojJ40xXmVfRKuOZGZ1sxJCtxXiYodgtXRQkfEtf9Q@mail.gmail.com>
X-Gm-Features: AclHuK-LdNI1l4YXOY-OMrlNkd6SJpfpHJiBlt2LrhzNDHSdQOdRrjZr5MXmVuw
Message-ID: <CAKYAXd9ueojJ40xXmVfRKuOZGZ1sxJCtxXiYodgtXRQkfEtf9Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: fix SetAllocation EOF and rounding
To: DaeMyung Kang <charsyam@gmail.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 17, 2026 at 12:40=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com>=
 wrote:
>
> In response to Namjae's review of my earlier SetAllocation patch, this
> series separates two fixes. Patch 1/2 prevents the existing cleanup
> branch from extending EOF on disk and then restoring only the in-memory
> size. It carries Fixes and Cc: stable. Patch 2/2 rounds the request to
> f_bsize, the allocation unit ksmbd advertises in FS_SIZE_INFORMATION,
> instead of 512 bytes.
>
> The other review point, reserving the requested range when shrinking,
> remains open. I tried fallocate before truncate, but the decision to
> shrink uses an EOF value read before vfs_truncate() takes inode_lock.
> The existing block-count branch already has this race; extending
> truncate to additional sparse-file cases would expose it more widely.
> If another client truncates and writes in that interval, our truncate
> can extend the file again with zeros. I reproduced this with an
> injected delay in QEMU. Rechecking EOF after fallocate narrows the
> window but does not close it.
>
> A VFS operation that checks EOF and truncates under the same inode_lock
> without extending the file may be needed. I plan to discuss the
> reservation fix separately with linux-fsdevel and would welcome your
> thoughts on that approach.
>
> DaeMyung Kang (2):
>   ksmbd: avoid restoring only in-memory EOF after allocation change
>   ksmbd: round SetAllocation to the advertised allocation unit
Applied them to #ksmbd-for-next.
Thanks!
