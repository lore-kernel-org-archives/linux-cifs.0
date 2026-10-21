Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590252;
	b=kLzXsodyhBk6Q7GSMcatJpGVNu6ft/qqORG1pjYvfyLZZpcpymbE2Aif9347hM/S+CjA
	 NYNet155puO3jPwoDC48pydNHg++1QGNdqywuZDp4F8y1ppHZNKbZYcr8huYABV7OR/pM
	 1NUbnsso3RaJ8ZjzYftYZBgIdUhXrfucvsP7Z76+XOTNxnc7DOXNYRwYCHV0e7VSUYdf7
	 TRTvZUinGtj6erIBrRqEm3zmFM0i2bzf8/WDyUPoR05OpAu5pN+UR7Sw1l2e8lRxA22Em
	 Ywh3iks8b6prBfv/7EXQ7fpSjXoTIrqmr7HXWxtY+XFxyfb8aA4fs6DNMAvTybfFUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590252;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cqDKtFMuzM9nM0G2aV2TVkGy3zyEu8z8hK7b+kmnLG4=;
	b=DccDIUrY3Hhd0kxAFwdhPnn83kjINYy1BDd2MBm/KSkotQ1xnjPFf6t6lV7g18ZRU+Ka
	 Xoc12rh8O9LNfYIjofGaaJe/ziJ0hbGaihcjtWI+pdbeT05NZDgdtDpeJtz5AKjc4+qYP
	 PbTc7c5OaQmUOGl5mq1fxPydjnIK+9tva1o3xjF72EDXGCeaGURjUr3oJ7cVltRL0i3J8
	 Vg12RDrpdAsmLASB7cr9gDE8+dx5uBvzU8uQ1gC4KAcm7E4Wwqche/HcXTmOEZPS2LMmY
	 R6SUnturo8akeLw0QuG6t11g1JJpo7N/Q89zlUHP3IhCBOLATSLz9nNuuoIRLtRP/Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ox4s7H7B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC89606A320
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ox4s7H7B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4F11F000C8
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792590252;
	bh=cqDKtFMuzM9nM0G2aV2TVkGy3zyEu8z8hK7b+kmnLG4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ox4s7H7BoeYAZ8zyjP1xMQfAqSlN7aFGnFrA34DAsPj/FrYMN8nthOupxOowRluNO
	 1UHuW3V7e5rHXNZW+G4zirVII6VYjzhW7r9PnpP8TN7qXTWFe07numuVI4Nczu2bnG
	 M0sFy6z6rdZK/zFyCPWLwx3mVg+c7HOJ6tmWC8KEQMVol45a/F/TuPmPcDK+rpC3o5
	 BhzofZaBn+6uMsG0X0YJU33ohtDw1KydVkSung2QVv8BXSbZybtt/T8WYDqAeLdZGM
	 93ZQIQPxh6/jUy1bw2jZqar82+av+MVcWTHAn+qm59pTlrn4i3McLgMku+L/izmJtn
	 bqUvI5U3Xe38Q==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6740e7ae219so630640d50.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 06:44:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1iCBZGTlgHSonie4n0J9te2KE09vlsXU+k9gNtdATuYRujKd1aPv9X4KJ0cqsUqxa15OJjeKazWKe@vger.kernel.org
X-Gm-Message-State: AFq9FYJbVO0MD2Jv1p47T6T6ehC9Z/M4Lygn4eJZg1ZDuxw7qBeY6gff
	80yh+MG+MxO0yA2SzPFSfNd7mHLYccpM+fWJVWV8Yi02XOuyes6TxhPOUW5hWhbs91Sjx6bBxEW
	G4KMzyM7X7RqKufuSSmTiOZU9AVTg9T8=
X-Received: by 2002:a05:690e:804:20b0:677:a8c0:38c6 with SMTP id
 956f58d0204a3-67a0e4cf21amr417304d50.57.1792590251399; Wed, 21 Oct 2026
 06:44:11 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260929024352.1433257-1-neilb@ownmail.net>
In-Reply-To: <20260929024352.1433257-1-neilb@ownmail.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 22:43:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8GogxyNSt3NZpcm9-fP019PmWAgsNzwKCdYrQFvOyvkw@mail.gmail.com>
X-Gm-Features: AclHuK-re9OmwPwi_QV1RyAbfMBgOF9gAwJh6SamYX146AyGEclwJIeQKPZJtkw
Message-ID: <CAKYAXd8GogxyNSt3NZpcm9-fP019PmWAgsNzwKCdYrQFvOyvkw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] smb/client(cifs): prepare for VFS locking changes.
To: NeilBrown <neil@brown.name>
Cc: Paulo Alcantara <pc@manguebit.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 11:44=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> The previous version of this series had a couple of problems reported by =
sashiko,
> both in 2/3.
> 1/ an error from cifs_lookup() wasn't handled properly - it should be fat=
al
> 2/ The d_is_positive() tested the wrong dentry.
>
> Original intro message below.
> Thanks,
> NeilBrown
>
>
> I am working on changes to directory locking.  The medium term goal is
> to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
> can be run unlocked, and consequently cannot be called when ->i_rwsem is
> held.
>
> The requires:
>  1/ that d_alloc_parallel() not be called while i_rwsem is held.  cifs
>     does this in a couple of places.  A new interface d_alloc_trylock()
>     is now available and can be used instead.
>
>  2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
>     unlocked d_alloc_parallel() would then be able to create a new
>     dentry with the same name.  In particular d_rehash() must be phased
>     out as it won't be safe.  This particularly affects the mechanism to
>     block lookups/revalidates while an unlink/rename is happening.  The
>     mechanism is changed to use one similar to how NFS addresses this
>     needed, though using the new LOOKUP_PRIVATE flag.
>
> The patches depend on patches recently added to the vfs tree.  I would
> prefer these land in that tree too with an Acked-by or similar from cifs
> maintainers.
>
> Thanks,
> NeilBrown
>
>  [PATCH v2 1/3] smb/client: don't unhash and rehash to prevent new
>  [PATCH v2 2/3] smb/client: use d_alloc_trylock in
>  [PATCH v2 3/3] smb/client: Use d_alloc_trylock() in
Looks good to me:)
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
