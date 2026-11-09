Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223543;
	b=kAkqiSgfhnLf6xt6EHStbtbIGslrjkOrTI1G9fgRvsrSNMYrefekQwXKTi9WfzIQGobh
	 6V42H4FYHkzfd3S3Zv5LbTX3fyhBWc6BmtGxNoZ1GttB4tD8P+NCGdrib0bgIYyg6JgRw
	 e13b98t0mS1JU9UpXIrqzeB4i+LKPQp4wdVO+xsECfY1oik3SKIHopInqYkW3UvrX0HUW
	 uT9/myqqtMr9y6+zuaJD8k98juRNAXtTXPIMjIAx3oWqukUIAsIy9UdUtKCdHlrB1VRQG
	 9X98ghYU3yTff65z6XtJyyk7jRszFoj2yA8XIAfykCV+q568cxI7UMfzAAL3JiHkkTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223543;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CbwDqCCHasq9DNEhUXtm1GHYFn7se7+hF+mPE/dcVHQ=;
	b=ta+IWAD9SZmDr7GJZO1Jh7svIf787KUM0TTlSD829kFA/vQFLQuW7E3RM14j4Tcroov6
	 jzYGphEdK+9GB+F3KODa5x5PCxDKUy6wFljz1CkD8d9y82Yaeo0vWCghWXOkVbh5yJHlC
	 xKQfTJ+lSbd9c7+QJgFXvzrK2daJBKqJY76H/pQG6eenY8n5fGB437Da43V9Y0zvX0t08
	 d6QfFsu1JnQ2ssp/PwzOVsYd1gHlrAl8NoNIvEN+ZWY6a7ydF+WstZSTSzhY9BhCQls9J
	 NNH+opDtigWjQgYByhpP9wPd6Y0fqdw3OMVRcRUd+/6LDZ+OAkF1dNO4IhpCvFmW2cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AvwjWz/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18D3606A321
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AvwjWz/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9621F008A3
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794223542;
	bh=CbwDqCCHasq9DNEhUXtm1GHYFn7se7+hF+mPE/dcVHQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AvwjWz/iXuzr70RNpq1/onzvj2lFVw+EnU3AanIh3HXq22A2Nv7zDdh/djlD5SrKj
	 6dFpL4DFUtAJTM30Pfc8Jao5+2vgQZ3hsHKLxDNZr8Ftz1VzNsiOO6a62r6PVUPwhT
	 SAwUrbce31AWT1h4z9LHjkUNA5Ftk/Kiz0icLOL4+WSjTygInWD+871TKblub46vhr
	 rlRB4vHI6ZNrnI/veFZLE+5dqoAJwBrhAP3+u5MFEH2Tn5uP2SPhIkf/HCkgkXpmyc
	 3izRrp73dnFUijKNHSemm/q0a9AzVmMHkHzVHNYcChSUst2xir3JozdbUQeg8Py5+A
	 5Vi3c9pFVCRpA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c445c95d553so93830366b.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 03:25:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFt9Js9aiInPD9qUSODknXZidM4Hzbqv1CmHlHifx024+1yG2uuWTn5y+l9f5fFesjW5uz4hYD+szfU@vger.kernel.org
X-Gm-Message-State: APuU4Z+nwWFZHY2cGYkD6ui0yz5OLJGn36fcMVjxja7z1l3jKTlaBNjv
	T+Xu4sPeek1cgtlvAC83lvtOHaPSfcjOFod2F55mj1XJspOG1UGkAcWAhidip8bOuIYmRVQ8Fz+
	hORr7PpDydGVyGaNOLP6ljwOOallVjrw=
X-Received: by 2002:a17:907:1ca1:b0:c4c:b681:38b2 with SMTP id
 a640c23a62f3a-c4d6d4f2e14mr249925866b.19.1794223540939; Mon, 09 Nov 2026
 03:25:40 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261108182011.1888520-1-icb@fastmail.org>
In-Reply-To: <20261108182011.1888520-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 9 Nov 2026 20:25:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8dL4Ci4JO_R9LNeW_KXQo1=snVK+=NReZJToWN2nXSXw@mail.gmail.com>
X-Gm-Features: AclHuK899ETLng_czFSgyYAfA-cg4CGy-TppyQBm1yWxdmk_WuZ6i9jpBAneUxQ
Message-ID: <CAKYAXd8dL4Ci4JO_R9LNeW_KXQo1=snVK+=NReZJToWN2nXSXw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ksmbd: fix explicit DACL checks and parent-derived rights
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 3:20=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrote=
:
>
> smb_check_perm_dacl() mishandles explicit access requests. It can turn a
> deny ACE into a grant, ignore earlier deny ACEs, and treat guest and
> anonymous sessions as Authenticated Users. This can grant read or write
> access that the stored DACL does not grant.
>
> The function also ignores rights granted by the parent directory.
> FILE_DELETE_CHILD can grant DELETE on a child, and FILE_LIST_DIRECTORY
> can grant FILE_READ_ATTRIBUTES.
>
> Patch 1 evaluates explicit requests in DACL order and excludes guest and
> anonymous sessions from Authenticated Users. Patch 2 obtains explicitly
> requested DELETE and FILE_READ_ATTRIBUTES rights from the parent DACL.
>
> Patch 2 uses the authentication state added by patch 1. It also restores
> parent-derived rights that patch 1 can remove from guests. Backport the
> patches in order.
>
> Older stable trees first need commit cc2f133e80eb ("ksmbd: fix maximum
> allowed access checks") and the preceding DACL fixes through "ksmbd:
> grant a caller what its groups and OWNER RIGHTS ACEs allow".
>
> Changes since v2:
> - Patch 1: keep the POSIX ACL fallback from replacing the DACL result
>   when an Authenticated Users ACE is present, including for guest and
>   anonymous sessions. Namjae found that the fallback could otherwise
>   grant access denied by the DACL.
> - Rebase onto the current ksmbd-for-next.
>
> Changes since v1:
> - Patch 2: let group and OWNER RIGHTS ACEs decide the strict parent
>   check before the POSIX ACL fallback. Sashiko's review of v1 found that
>   a POSIX ACL entry could otherwise hide a FILE_DELETE_CHILD grant.
> - Patch 2: add a comment on which MAXIMUM_ALLOWED requests omit group
>   ACEs.
>
> v1: https://lore.kernel.org/linux-cifs/20261107062233.1579198-1-icb@fastm=
ail.org/
> v2: https://lore.kernel.org/linux-cifs/20261107231941.1824289-1-icb@fastm=
ail.org/
>
> Both patches were tested with KASAN on ksmbd-for-next 6f42553e493d.
> Its fs/smb/server tree is identical to current head 2f14fe2d5895.
> smbtorture results are unchanged.
>
> This series was developed with LLM assistance.
>
> Ian Bridges (2):
>   ksmbd: evaluate the DACL in order for explicit access requests
>   ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES
Applied them to #ksmbd-for-next.
Thanks!
