Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27F155C97
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 01:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787017444; cv=none; b=Xq0G+iIVIp+VAE6l5vwlVJggEffceGiqePgBSu+DS5Mvyir1Hdgr8Kx2prjJOll4M02xi7UYiQyKYoBgD729kygoG+jmcT2q1PSRgjO8p208gvaWfqvNdeVCynEvud9ESz82AfS/d5J0TZWTD8px1PaMVepWU0JX63i/r37bJ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787017444; c=relaxed/simple;
	bh=kbRtekxz6vRjSe1gV57DEsfT94OAkKqKU1bDtY+mQco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZjMiH6LDsNuspJ1hlewECn9LSp6u8m9jEcXE6rCyRmWOrcNLguCAOOwcGga3Kt2h3jzYH+HR+gr6fwmhfv2G28I+shkdEmUbuFL1Gz1Q2bZX0UrkW+LfqNIMpdo0+DYCxp+9mTL+8fmnPNXB6HKwErh/8Z71GJUqKTy4Hdq/g30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCUqZOhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCUqZOhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDBB1F00A3F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 01:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787017443;
	bh=x8/DTRNCVBz+0ciuHqwc4iioW4Y59RTv871XaRpaiW8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HCUqZOhJLe8NAmSYoL2TVbDK2sZVkYrehq9aSIQa1nClewud39BngYqTFRLxTZpci
	 N0YnCyFlSlpgOtNRp4oMojdjR2nUA/ylOA5I2VjOUQS5ZP4n1f5FuoLe9WgXao7PYA
	 Eh4iEc7CwkwZHaNu/F1yd1ryOOvXo+XcMsKIU0n4ectlwHqykExR6sufxuhSfrV0vm
	 Dcl5AeQIn/jWEHg8q/jlXjWxNd7PtKyvyD/cmnLHHboBZ8m7fvOSv5SP8lUdd+VWDi
	 9fKRIpv4Jpb2NhsTHm7ZzXTvN7J9R8tDr99f49Gq5So5w1ybNVcrem0T+7BvedeLHP
	 uJNguzJ8A3WYg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso5692291a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 18:44:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YxM9LG1PWsk4ypjBWQyyXLrMyAoq2ew88AnhMnVdvyD5Evu0sGP
	If4Kdr8PrljuH7nQe5wh4ddoxzeHZjwNnPh1JTOQOTFOYHWhHK/P+2HITikWgAv/vrGQWm6W4oT
	psEiyu9dK+2G8aFTruYfPw0XAJyUXnGQ=
X-Received: by 2002:a05:6402:e9b:b0:6a1:28d8:2306 with SMTP id
 4fb4d7f45d1cf-6a38a91250cmr13440785a12.1.1787017441539; Mon, 17 Aug 2026
 18:44:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731171231.686427-1-sorenson@redhat.com>
In-Reply-To: <20260731171231.686427-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 10:43:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ArB-_=cPuFC1gcLw8UnsHTQxw8fD0aRCPpqjoXPHn+w@mail.gmail.com>
X-Gm-Features: AcwNN1UaG92V0sS9G8dvsANjStSeIqke6J0pdFnU7FHKaJBqTwOV2QJ6MujpLqE
Message-ID: <CAKYAXd_ArB-_=cPuFC1gcLw8UnsHTQxw8fD0aRCPpqjoXPHn+w@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] cifs: follow-on fixes after fscache_resize_cookie()
 consolidation
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com, 
	hehuiwen@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 2:47=E2=80=AFAM Frank Sorenson <sorenson@redhat.com>=
 wrote:
>
> After commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
> cifs_setsize()") consolidated fscache cookie resizing into cifs_setsize()=
,
> two further fixes are needed and two dead-code blocks became removable.
>
> Patch 1 fixes cifs_do_truncate() (O_TRUNC via cifs_open()).  That path
> runs without i_rwsem, so it cannot use the locked resize path.
> cifs_invalidate_cache() is the correct alternative: it works without the
> lock and ensures stale cached data is not served once the cookie is later
> activated.
>
> Patch 2 addresses a race identified during review: cifs_setsize() calls
> fscache_resize_cookie() without i_rwsem, but another concurrent open may
> already have the cookie active (IS_CACHING set), making fscache_resize_co=
okie()
> a real operation requiring the lock.  The fix strips fscache_resize_cooki=
e()
> from cifs_setsize() and introduces cifs_resize_file_locked(), which
> temporarily activates the cookie with fscache_use_cookie(), performs the
> resize under i_rwsem, then deactivates it.  Callers that already hold
> i_rwsem (cifs_file_set_size, smb2_duplicate_extents, smb3_simple_falloc)
> switch to the wrapper; cifs_do_truncate() continues to use cifs_setsize()
> followed by cifs_invalidate_cache() as established in patch 1.
>
> Patches 3 and 4 remove dead code.  Patch 3 removes a caller-side
> truncate_setsize() + fscache_resize_cookie() block from
> cifs_remap_file_range() that became redundant once smb2_duplicate_extents=
()
> started performing the full size update via cifs_setsize() under the
> i_rwsem held by lock_two_nondirectories().  Patch 4 removes equivalent
> dead blocks from cifs_setattr_unix() and cifs_setattr_nounix(): since
> cifs_file_set_size() calls cifs_setsize() on success, i_size always equal=
s
> attrs->ia_size on the success path, making the subsequent size-inequality
> blocks unreachable.
>
> v3: Fixed broken patch
> v2:
>   - Added patch 2 (cifs_resize_file_locked): based on review feedback
>     (Huiwen He) that the fscache cookie is not guaranteed to be quiescent
>     in cifs_do_truncate() - another concurrent open may already have it
>     active.  The fix strips fscache_resize_cookie() from cifs_setsize() a=
nd
>     adds a locked wrapper for callers that hold i_rwsem.
>   - Patch 1 commit message updated: the original rationale (cookie is
>     always quiescent in cifs_do_truncate) was incorrect; the correct reas=
on
>     is that i_rwsem cannot be held in that path.
>   - Patches 2-3 from v1 renumbered to 3-4 to place fixes before cleanups.
>   - Patches 3-4: add Reviewed-by from Huiwen He; otherwise unchanged from=
 v1.
>   - All patches: add Reviewed-by from Paulo Alcantara.
>
> Frank Sorenson (4):
>   cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
>   cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie()
>     under i_rwsem
>   cifs: remove redundant size-update block in cifs_remap_file_range()
>   cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
I will apply this patch-set to #for-next.
Thanks!
