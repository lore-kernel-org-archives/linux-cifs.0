Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D33101D4
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 22:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761862458; cv=none; b=aYlV82EyudIQ/zf6HBOjPtRhDB/aZ+lRqOnchmsTFEmpcRt+yS8p/UFkg49uYiHpNy8u+aHFCcsZHXm/132D2Cs6mWumvo3IpXXcxSHX5M3CFLtD6OXeqqIxEljo2YWGbu90LQqfHQSjvq7rm5CTSVLtRMDRJkqk+mJEfKYUFQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761862458; c=relaxed/simple;
	bh=8W3DIHjw+XIPebScJA/E99yflXcfuVuXVdVgRZyQxMw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=TMlUd6+ZUl2pu0ZZAUdL6hmtFIZ74iCs2FRYYqD+3KYXNwx+kjqMv2U9KztAuvgbu/XHPKWGcA/6JlRExtnn/tdpNoCeUF9S0TmIbUtgeIUAt2WNOI+0zHoB4XHCIV7ibtzQ8Nm9pev3PJy0LalNebX7SsuZXTh7kFAZG5dk3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=v6CWZ5ZU; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="v6CWZ5ZU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+wQrg4r9z6SVNm2+IzbjMhj1FQCbMNuWDTcOJKnZp38=; b=v6CWZ5ZUV4IKFD51JipGdL2snq
	KH88l65eyDX2JJFX70DfZR7NW6SJpqX2i/hE/Ya8Lv9tTbHCQO6XdL2mOVC4EruXuYGdBRwzD+/XC
	PeOZU2pTzgQgKu0hsz4RIHCMxXRh/ZzkWFYtsT5uIecqTL6IzJ9RNQj9uLhydUILTzrRUmPkoPR7v
	eADZN2mz1GM1jh+RG9w4uhmAFdBvwS08wuMjnFsgjEqZZkY7gpMS6dk9JSw0il2ZYS8xtoEyznKLM
	aeuofhvlU4M+GnZpkKlH+KWVwKuDuIKiWbbAIQkDiLguycryOJbo1u9ivcp4m+NHAy1airTqgWkLZ
	CR7Jg+Ug==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vEauM-00000000fHL-2R5p;
	Thu, 30 Oct 2025 19:14:14 -0300
Message-ID: <c13f6f90a69c6079c30353d24f0c2bc8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 sprasad@microsoft.com, smfrench@gmail.com, Bharath SM
 <bharathsm@microsoft.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in
 /proc/fs/cifs/open_dirs
In-Reply-To: <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com>
 <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
 <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
Date: Thu, 30 Oct 2025 19:14:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 10/30, Paulo Alcantara wrote:
>>Bharath SM <bharathsm.hsk@gmail.com> writes:
>>
>>> Expose the SMB directory lease bits in the cached-dir proc
>>> output for debugging purposes.
>>>
>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>>> ---
>>>  fs/smb/client/cached_dir.c |  7 +++++++
>>>  fs/smb/client/cached_dir.h |  1 +
>>>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
>>>  3 files changed, 27 insertions(+), 4 deletions(-)
>>
>>Are you increasing cached_fid structure just for debugging purposes?
>>That makes no sense.
>>
>>cached_fid structure has a dentry pointer, so what about accessing lease
>>flags as below
>>
>>        u8 lease_state = CIFS_I(d_inode(cfid->dentry))->oplock;
>
> Also, I don't think we can even get anything different than RH caching
> for dirs.

Yes.

> Even on RH -> R lease breaks (IIRC this can happen), we don't handle it
> and cfid is gone anyway.

Yep, that can happen.  The code also doesn't seem to handle any sort of
reference count on the @cfid being dumped out, which would definitely
cause UAF.
