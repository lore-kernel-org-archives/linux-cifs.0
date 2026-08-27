Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE9F379960
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797250; cv=none; b=jFqu7OWdadFaraUoetpwp/R0JvcSkiYzPn+3U5sJQzkqt3FBwO9oW9+z0RWYdVOGiNu7BRe3IYpGtf96aZqrVSPj7bEJm2qpMtveSL0pdKw+PE6xHZF+KZLvyBSjclXdrVE8Q/vcK0TsjF6cGhwgYf09LUQ5Xhp/DPw0QrFG8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797250; c=relaxed/simple;
	bh=smelnvJdld3RwoYrDm2oD04K5vzKubxj35kDRdsAOnk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=kggVEkkROBG9sUUCLh96sg4L1IBQ/ZeH56GM7kGQIYG+NGBQ2V6t9pnWkDPLD0qJ8T/uIsOenibet/q6nLH6DvU395EYATfhEr35u8Wg3zPk/PvgT1KJLhWhW/5z2LsOx6hpK3KB0FWwvcG4sqGxON2lh+BYvrAio7Cf+3iOKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=V7qPElPq; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="V7qPElPq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=smelnvJdld3RwoYrDm2oD04K5vzKubxj35kDRdsAOnk=; b=V7qPElPqI1dWMLHi1+ASA33bw9
	MZ7S+7g3d4y2bp+GdlU0ucLQez+td/G6l2gf2owreD594NPiVZm4Hvf/rSOqMambxFYKe4JtjenA6
	nUKQQoDBvXIgVYbySC6+3AyxhDLz3oQYVj8OhvThVmeI92Z3ZgIz00cw8CTCjBkiS4UEq/PJMDzoQ
	7sDK/cCnRbolwRiOpoQWZt1kuU5GggWyWB2cOwGec7Lvqd0piKx+aBGFLhhrteWbBp9JNmDO4+z7V
	T3XYg7Ty36h66yHJPXq/298wSd+4N0OgKIALe/lHA7hLbt2GXVHjRrksYRoZL53EP7uPg1jGFk7n+
	PMc9uUXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPjT-000000004iz-18HS;
	Wed, 26 Aug 2026 23:20:47 -0300
Message-ID: <461661292820743c54bd8d67bc0f36bf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 7/7] smb/client: invalidate fscache for fallocate
 range operations
In-Reply-To: <20260823151053.935889-8-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-8-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:20:46 -0300
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
> smb3_zero_range(), smb3_punch_hole(), smb3_insert_range(), and
> smb3_collapse_range() modify file contents through server-side range
> operations. These operations discard the affected page cache, but leave
> the FS-Cache cookie valid, so a later read may return data cached before
> the range operation.
>
> Fix this by invalidating FS-Cache after outstanding I/O has completed
> and before modifying the file on the server.
> ...

Applied.
