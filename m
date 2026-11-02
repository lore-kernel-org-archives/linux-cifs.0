Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610921;
	b=wUFyDCp94Bi44CBfsO5MJlHqtNW+K8Xo4LudHAf+gofMkOQ1jZjd8OHextxBzCRxR8uy
	 ozXmFW9YY0U++7QFLCSm9hVT9nhdirQ1PcRTWg7LiFoCAnsO8KJsAV1ZxmKespAi5z9wP
	 xrsiwk3oS8fDtCc0yM1qGyep94I76/cBrBNYE4SvW8tSar1HBA+z6RklHEhyw3h6o634D
	 0HlLEoMu7wP0yafjCkE6TzsLI3Wv4FFfwEZ03LSyXw6mfSl2pdRXT8iQgiDMFS/PrLBF0
	 8uT2r72w9ky3mhXQc1pgP4KwD0y3Y6oqbP64GTgwrbpNmExMGYm/BL6TC2b344AdjFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610921;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yAj3kTVVeqmRRAKsN3LaxsDqAsQSkzpAUGUwsfCiFCY=;
	b=cXtVIl7eHsi4AmuzxLAS1DA4t9R+jZXd5hg9+VY/qcp7ipCY0r1Yw+34aR7MDzdv91mr
	 Fw93yHuxte0dEaluC0EndIwRKdDWdhXQSSO4hKsetCU9vI5WkxPK+wiffk4HZ/o40VrNW
	 QkWsg3UXbAJ0pwoB2JEh1X8g8wfVIZeA6bNTuq7dJv23eajy6deSJVrWe7uICXlJ1Jnpr
	 vYkK0ayRpa5bfnFoW1gIinS1psX2/QgMNVGKdln0xgejZMbPv6fvGCBPlMt/foyK7DLIr
	 BLMYU+LnTnuLV2MoTuH79nVd0fKK72W7NfesNwBu54s927HwJOU6lwwUvbqLtMAnjdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4C6TALz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896FB606A32C
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4C6TALz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161991F00A02
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610921;
	bh=yAj3kTVVeqmRRAKsN3LaxsDqAsQSkzpAUGUwsfCiFCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z4C6TALzhRAdKW3AfclTHcTTuVofX/3JBDB/CYYuf6pGz80CI7CYneT9ajjVYrJTQ
	 Rmmi/xFIO7FBt8V1p+YWAejZuxkhagxA8H9NxN47qG4EDffrJn9pDtlcBps967xd04
	 +2Q7bBccN7A7oLJPaqv+audsDkGXy7YN2iOPF8I6bdSDqV87mGhotKvI2TKTQjdmMn
	 w6AaqHaIqE6sCm6iuAN+xva7BBpnt5sbjXqlT0sxv2jGGI6rLRMky7QnpUKzog4hw/
	 A5zKcdW8LPMVS4UlDIx2Ltc6qY0Ei5u14KtpljK//+nLSAA6YvdgJSd7KhMHT63yMY
	 zzRSged5eitMQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4326803b54so135467266b.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 01:15:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzO7x0HTsreumLwcWgjE0C8FzfFrQfYy9vmIWh5MMkrTgOVrpWQScpULObzVF7NjYg4oI8SWGKL2H4s@vger.kernel.org
X-Gm-Message-State: AFq9FYJz4bCGkjsiTiLFgYgMijmRRvNgfd/IRuyGm0BxQYdDqTKqnkXN
	v+1QTgMh5htSdDBQZx2YcNDXgMpfgd1UsAlzdXAlz9/La4U3AXSvFp3U+SrLo4OWocVf60kCnq5
	S2KCf/3WV9zgYkn+ZZOIPQmWG7zXmJNI=
X-Received: by 2002:a17:907:3e05:b0:c2e:52d6:1fb7 with SMTP id
 a640c23a62f3a-c4ca7a4f249mr743679966b.22.1793610919556; Mon, 02 Nov 2026
 01:15:19 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102061537.830714-1-icb@fastmail.org> <20261102061537.830714-3-icb@fastmail.org>
In-Reply-To: <20261102061537.830714-3-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 2 Nov 2026 18:15:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Om3RcrgxAKbQZGT2Lxs7XSktm2bhLTUEJB96Oc0-iZg@mail.gmail.com>
X-Gm-Features: AclHuK9x-NX3ZXILj8-TFee78y_hbo226_n8Kf0CYW0MTO4mXOzL731kOYddAmY
Message-ID: <CAKYAXd9Om3RcrgxAKbQZGT2Lxs7XSktm2bhLTUEJB96Oc0-iZg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: grant a caller what its groups and OWNER
 RIGHTS ACEs allow
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aamir Ahmed <elb12345@hotmail.co.uk>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:16=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrote=
:
>
> smb_check_perm_dacl() does not match ACEs for the caller's groups. It
> also refuses an owner named only by an OWNER RIGHTS ACE, although its
> MAXIMUM_ALLOWED walk already counts that ACE. These callers cannot use
> rights the DACL grants them under MS-DTYP 2.5.3.2.
>
> Run the existing ordered walk for every request and match Unix group
> ACEs (S-1-22-2) against the caller's credentials. Use its result when
> the existing SID lookup and POSIX ACL fallback do not decide the open.
>
> Group ACEs remain excluded from MAXIMUM_ALLOWED. Adding them requires
> corresponding changes in smb2_open(), which derives open flags and the
> maximal access reply from that answer.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Please check Sashiko's review comments.

https://sashiko.dev/#/patchset/20261102061537.830714-1-icb%40fastmail.org

Thanks!
