Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E377464A8D;
	Wed, 26 Aug 2026 23:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785417; cv=none; b=f4YtJIVhHSW8m6KKOMvSvvr9jY9hR9rLEqpssSA+AfM4+yWo3BMkw6xg253MqpWUMt3fBZ+he1IuWVfbAyjQQRG02rQ0JfFId6uFC+kxAU9bwGnCmhMjqdivE+ybwqj//Q3Iti04wjBY4Lyfodumy+ORR4GYuqGUYE7jABafbAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785417; c=relaxed/simple;
	bh=iaenvkdqMrNnS9dP4HaAXbRDQSBF88XyPljlUpay8Mg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NSI4yefGxjzlvhSVOHjLqfPNr/yX390CEYOn8UA9vsQYCaeU549cCKPR+R1fIpXfZJMVNWEoS6htEP1xCCOvEGBzehi0xq2lBmVjtODyFNN1Vi0BIkEe+8O0gDTsD10JzKyoI9KJfJzI2sOMIfp1dBbn8FJO7aLncfffhMuTP80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=XcgrnpcX; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="XcgrnpcX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=09N66383U/vYPVDY7XTqyNAsNHY46liZU7GiNCEVDiI=; b=XcgrnpcXRDgGxpZEwEzXModim5
	2Kfr27+1+CcC65SXmi/7jTCbJuOaDgEI7JWEY4CvbznSDI2BsZPD7RHiR9vxA1V0ClEuXs8xaovor
	fiBryjICd42OD9k5wa5PKBjXShFFXtgNS7J9ABZFfYyuS65nRLEKIg0PkwYOXCRjeM4KScRz5K0f1
	xoBS9I4a6Q9hgSkMPnHhFdZ+BrBdJ7aHKi2ncYic+dzQYApCgKQZBkT0G4frbRctHNceix/EXv9Cb
	CCqjYlQrqwlAarCws5aS/kxPQFNXC1K4BOahO7DJ6y+0jd0fF04Gl/35/r/qUsY7gCru+ii7cwOYb
	9HXxSHNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzMeb-000000004HN-3GCi;
	Wed, 26 Aug 2026 20:03:33 -0300
Message-ID: <f67877e37eeede299fbbe86914cd58f2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: tighten validate_t2() offset bounds
 against actual buffer size
In-Reply-To: <20260825030948.3577275-1-sorenson@redhat.com>
References: <20260825030948.3577275-1-sorenson@redhat.com>
Date: Wed, 26 Aug 2026 20:03:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Frank Sorenson <sorenson@redhat.com> writes:

> validate_t2() rejects ParameterOffset and DataOffset only when they
> exceed 1024, far below the allocated buffer ceiling.  Raise the
> individual offset guard to CIFSMaxBufSize + MAX_CIFS_HDR_SIZE.  Add
> joint offset+count checks against frame_end =E2=80=94 bytes from hdr.Prot=
ocol
> to the end of the received payload, derived from WordCount and BCC to
> match smbCalcSize() =E2=80=94 so a large offset with zero count cannot re=
ach
> beyond the received frame.
>
> In CIFSFindFirst and CIFSFindNext, bound lnoff <=3D DataCount: since
> validate_t2() guarantees data_off + DataCount <=3D frame_end, this
> transitively bounds data_off + lnoff within the frame.
>
> Add min_param_size and min_data_size parameters to verify the offset
> clears the byte past ByteCount and that offset + struct size fits in the
> frame.  validate_t2() computes the minimum valid offset dynamically as
> frame_end - BCC, which accounts for SetupCount > 0 (WordCount > 10)
> responses where extra setup words shift ByteCount and the data area
> later.  Non-obvious sizes at the call sites:
>
> - CIFSPOSIXCreate: sizeof(OPEN_PSX_RSP) + sizeof(FILE_UNIX_BASIC_INFO),
>   as the caller memcpys FILE_UNIX_BASIC_INFO immediately after OPEN_PSX_R=
SP.
> - CIFSSMBQPathInfo: legacy ? offsetof(FILE_INFO_STANDARD, EASize) :
>   sizeof(FILE_ALL_INFO); the legacy path skips EASize intentionally.
> - CIFSSMBQAllEAs: offsetof(struct fealist, list), not sizeof, because an
>   empty EA list returns DataCount=3D4 (list_len only).
> - CIFSSMBPosixLock: (0, sizeof(struct cifs_posix_lock)) =E2=80=94 pSMBr a=
liases
>   the small request buffer on the waitFlag path; defer
>   cifs_small_buf_release(pSMB) to plk_err_exit so the pLockData branch
>   does not read from freed memory.  validate_t2()'s frame_end bound covers
>   both the waitFlag (small buffer) and !waitFlag (transport-chosen buffer)
>   paths correctly.
> - CIFSGetDFSRefer: (0, 0) =E2=80=94 parse_dfs_referrals() reads from the =
fixed
>   dfs_data struct offset, not from DataOffset; add an explicit check that
>   dfs_data + DataCount fits within the received frame.

Besides all these LLM-generated messages and comments, would you have a
reproducer or a real use case that would require such changes?
