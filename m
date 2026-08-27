Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D3379960
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797231; cv=none; b=jzzIzQJwXDvsY1dehAdVUTvEAR5HU0cE+HSLLOgIbwsN2BcLmbpD5935G5fmQSdVQJYoBvyPz5Z/ygVyOhQHL3PwJDT0L3o3i95s5BI+n56p90gmvWAxmmCoNjSKGwLyHiAT75/Iki3Go4SAHJt5B1d+WIqkmm1qjWb+0biIqLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797231; c=relaxed/simple;
	bh=6dFjeyQQ/Wv8GBIsegjan4HKf5eK0/5BV5ojJVTRmcc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=USOlzLMdYyc7iWBMXSXmwR46o9kkR+3Xm3/nz9u1mU1aWdx8idfbemrv13hmpoH3MLAxABjfrWfBPjKdpidotXWeI3DI+/YOE4agDf3aEgUwVzsgY9SyIOM2zKHsckkQhFqEUrsFzLO9GkLOKz1ABHc0XXSUpc9WRLaMAZvQeO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=sVAM4n8V; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="sVAM4n8V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gtAhTXuodi1m+SLlrE8Hom1KdtShNRl0vM/pdbUgd60=; b=sVAM4n8VWcSk3kEqgQqhM+wUsG
	Shd5h2xrQqVCc0OKecCH3ysprYNs+rF6Ix8FfOwy3KC7LzBxT/OSasVVgxBLSqUKcgXkN4LYKf+Os
	I28c1oTk4YhnNPa2MLpHftDUqjDqHh7930b4WoUxQSYWH7dzNnVONuGAUpcMkI+k9XNxyriUH7w5a
	bL/OoZQ9ISrCrxH5w5rDreFZp77M6YvwAAZX/aZJCSaP7gxHgPyYUa/B2XK1GIKo3D1y+fOpXOWvb
	rY/bX3oCpbTCqtt9kThrKzEqKlFE7gAxURD4zj651E4RvVnv9qDT4dnMoXYEwRPALj/ru42RV9OpM
	jjH1FFPg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPj9-000000004ih-1oaT;
	Wed, 26 Aug 2026 23:20:27 -0300
Message-ID: <34161ce396b2c966de08e120d5198b61@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 6/7] smb/client: fix stale page cache in
 insert/collapse range
In-Reply-To: <20260823151053.935889-7-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-7-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:20:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> smb3_insert_range() and smb3_collapse_range() use
> truncate_pagecache_range() to invalidate the affected page cache.
> However, if off or old_eof is not page-aligned, the boundary pages are
> only partially zeroed and remain uptodate. As a result, the client may
> return stale data after a successful insert/collapse range operation.
>
> For example, with 4K pages:
>
>     page 0          page 1          page 2
>     0------4K       4K------8K      8K------12K
>        ^                                ^
>     off=2K                       old_eof=10K
>
> Page 1 is removed from the page cache, while the boundary pages are
> only partially zeroed. After COPYCHUNK moves the data on the server,
> these cached pages may still return stale data.
>
> This can be reproduced on a CIFS mount:
>
>     bash -c '
>             FILE=/mnt/scratch/repro
>
>             # Use a 6 KiB file so EOF is not page-aligned.
>             dd if=/dev/urandom of=/tmp/src bs=1K count=6 status=none
>
>             # Expected: a 4 KiB hole followed by the original data.
>             rm -f /tmp/expected
>             truncate -s 4K /tmp/expected
>             cat /tmp/src >> /tmp/expected
>
>             cp /tmp/src "$FILE"
>
>             # Prime the page cache before moving data on the server.
>             cat "$FILE" > /dev/null
>
>             fallocate --insert-range -o 0 -l 4K "$FILE"
>
>             if cmp -s /tmp/expected "$FILE"; then
>                     echo "readback: OK"
>             else
>                     echo "readback: STALE DATA"
>             fi
>     '
>
> Fix this by writing back dirty data and discarding the page cache from
> the start of the page containing off to EOF before moving data on the
> server.
> ...

Applied.
