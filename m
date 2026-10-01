Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDE0374A11
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 01:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790818989; cv=none; b=eNlBWd9x5PQlEI6iR3Lrc2kMfX5FMptcujEg8R3vhwbYfELDkW88Q3+K2vByyukNQGMeOPAcbKK9TG+A96aFWHBynjfdQTBzRDXTmSbAnIH/bUHDeL4ChcUjSdo9Ga0jEv+ywQw+J9OB3MXhEnf49tUu0DRwFUXYNIQ/WN18Zkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790818989; c=relaxed/simple;
	bh=FKo/WL6GEBPxG97QIhHxjQAZe/2UYXq1OzpeQBo1oOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k3AbhOyr4MahHicPexJGasHb+5/dwhyTKC/k9+uSfikc4TDkfdwrkJv2QK9Ilzpu72GiTl/BMHVQGYCs813dKzoGYG7ymIIfdgK325jYJEu2N+8Yu2RQ+Tqn+v8ktAvV6BIcb8vP0mYCdZc4qS6zh+yrelRNvjg7rPnLKOkvxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvRzvuaP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvRzvuaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197191F000FF
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 01:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790818987;
	bh=G7E4UeSrbjUK93BASaojP7qyESFSIJ4ZQB3ORFNLlb8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KvRzvuaPmwwGqHBtBsKBQiPhr1hyHg6T9R5Ws8upZmliqa0aNzdI/3ERuFi3klwnO
	 l07AnI+x59rvm7GO2mbINILLQ7pj9yyp1tI2pUomf3nRwe6I/SAkiJQEO06pxTliSH
	 jS0gW28F7FwR6zTYUFCJ5CtAiAp1/ydLzBJr74u/Kbf0DsAXhJNn1P/hKVC2s/zJo0
	 om/LiOZa1Z0tF7QzixqygiZMEZEtW1xFVwdoVP5/SV+4tRJl3ddTm759yvJoLtI9GI
	 uC1EkzzrgL38Z61c1xWzPh1DkCIJsOBl9x8d0xQosMucvQv1jxOCc3MG5vZnQpccvl
	 5Bwv6+TKCcZmA==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e1d2d7dc9so84070666b.0
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 18:43:07 -0700 (PDT)
X-Gm-Message-State: AFq9FYIP3vMKUtKcrXMDNRcJo2BR39Pf/VEvic8GBx1vTwf1Lws+O7fa
	0wt/fV+csvYY9fI5zqWfbOb3+ZkP2KQn5roOqoCnyqrJZCRFuHSI4xhilHBHa8xG+s0JzrLSgxR
	faGnu/Qwv5eJ/DV8GmtyrcPuz5yBY3BI=
X-Received: by 2002:a17:907:c499:b0:c29:c575:de84 with SMTP id
 a640c23a62f3a-c2e33cec3b6mr113440766b.8.1790818985779; Wed, 30 Sep 2026
 18:43:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930204723.1555769-1-sorenson@redhat.com>
In-Reply-To: <20260930204723.1555769-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 1 Oct 2026 10:42:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9d3JoneM9OAMbS5hET7t9VaPdRced3bY6Px-s1zLmFNg@mail.gmail.com>
X-Gm-Features: AclHuK-gfkXw42R8VGPy62Y_I-kbUFF8aS_3q-v0KgU1PIqrtUDNRxBMgjMoMgo
Message-ID: <CAKYAXd9d3JoneM9OAMbS5hET7t9VaPdRced3bY6Px-s1zLmFNg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: split cifsFileInfo bitfields to avoid
 shared-byte RMW races
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 5:47=E2=80=AFAM Frank Sorenson <sorenson@redhat.com>=
 wrote:
>
> The invalidHandle, swapfile, oplock_break_cancelled, offload,
> and status_file_deleted fields are stored in the same bitfield byte
> in struct cifsFileInfo, but are updated in different code paths that
> may run simultaneously, and are protected by different locks.  Since
> bitfield assignments generate byte-level read-modify-write operations,
> a modification to one flag can overwrite a concurrent modification to
> another flag.
>
> To avoid these races, convert these flags from a bitfield to
> separate bool fields.
>
> Cc: stable@vger.kernel.org
> Fixes: 3bc303c254335 ("cifs: convert oplock breaks to use slow_work facil=
ity (try #4)")
> Fixes: 4e8aea30f7751 ("smb3: enable swap on SMB3 mounts")
> Fixes: ffceb7640cbfe ("smb: client: do not defer close open handles to de=
leted files")
> Fixes: 173217bd73365 ("smb3: retrying on failed server close")
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
