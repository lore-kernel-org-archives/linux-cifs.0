Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCB830C168
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797167; cv=none; b=JEwYSum3+IHfVHtJF+uwOPYnLVs+/RcGs6F90KMP+FCp0AMylbLAxIfaCKgfOA5VKdJj2ykLkPuOB5FhlMI2ebEVV5TVQ+c0A+sARLDAjAOp/H6AJD1bKuYNdKZGi2sx72Ek2G+yyHa3xjARqfcX5J1U+j5/Ubc1DpAqxvhyF8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797167; c=relaxed/simple;
	bh=O0neAGIkdQ/7/tskGGCfLxitTaEi2XvtD5uK2DFLa/4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=qGx9h+xA0L/CsHWyUefgmz9tO+ch3ZR1A0FeyxDckppQsdsPFdoMZ7AmTAAtxkOOXW8SN4aO8HOBdNNBRWzyU2Yh1pZW7F/fEVz1uj0Sq2rloBfWYHDdPNy8D/Tq90ji6XNlY+3qYAFb/7CLG3CifB2CdLpPKSnPTt/3XKiNCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=DoWA8S2H; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="DoWA8S2H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W3Q2jqaafeW3dredNV0n8k3zKa12Mc+NvVJWJtpAniY=; b=DoWA8S2HOa/pO//c8NRakUWpBm
	e82pxH2MLlidYJJbMpl/L/K9Kvq4/UiglUscaNktQi0/c6vcUC6GfzrdDdvV7rVdmh3DozGe2sdpo
	bN+S06b6zUIiT34Sukxboh6JP7P/ZZzZyFKvgLJcjuNN2r43Z4qehsy5XNO46nuLtIyL2eigJq0F/
	WwA1CX0WIuDaZVSwGlr5enlSJah1X3j6JsC3oUmQk2HylB79PpExKA3zPfrZBD7S14SYRKC3Z/azQ
	ccccNo7l0ZaGSeX4S7uk0a8Dknzr8jeaVQlmF8RGZ11ARMcoY4Yym7LzVa8NAd7M2nKJIn1kukwp0
	NsrovFoQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPi7-000000004i7-3rt1;
	Wed, 26 Aug 2026 23:19:23 -0300
Message-ID: <a228fb66678a69c7f85bfbf89f47b2ad@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 4/7] smb/client: fix data corruption in emulated
 insert range
In-Reply-To: <20260823151053.935889-5-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-5-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:19:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Huiwen,

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> smb3_insert_range() shifts [off, EOF) right with COPYCHUNK, copying from
> low to high offsets. When the ranges overlap, the copy can overwrite
> source data that has not yet been copied. For a 1 MiB insert at offset 0:
>
>   offset:    0       1M      2M      3M      4M      5M
>   before:   |   A   |   B   |   C   |   D   |
>   expected: | hole  |   A   |   B   |   C   |   D   |
>   current:  | hole  |   A   |   A   |   A   |   A   | (corrupted)
>
> Let x be the insertion offset, L the total length to move, delta the
> insert length, and C the normal chunk size allowed by the server.
> Insert range maps
>
>   [x, x + L) -> [x + delta, x + delta + L).
>
> When delta >= L, the complete source and target ranges are disjoint, so
> the normal copy order and chunk size are safe:
>
>   offset: 0       4       8      12      16      20      24      28      32
>   source: [--S0--][--S1--][--S2--][--S3--]
>   target:                                 [--T0--][--T1--][--T2--][--T3--]
>
> When delta < L, the complete source and target ranges overlap, so the
> copy must proceed from EOF backwards. There are two subcases.
>
> If C <= delta, each corresponding source and target chunk is disjoint.
> The 1 MiB example has L = 4 MiB and delta = C = 1 MiB:
>
>   offset: 0       1M      2M      3M      4M      5M
>   source: [--S0--][--S1--][--S2--][--S3--]
>   target:         [--T0--][--T1--][--T2--][--T3--]
>
> Copying S0 from [0, 1M) to [1M, 2M) overwrites S1 before it is copied.
> Processing chunks from EOF backwards prevents this inter-chunk
> overwrite.
>
> If delta < C, the source and target ranges of a normal chunk also
> overlap. For example, with L = 16, delta = 2 and C = 4:
>
>   offset: 0   2   4   6   8  10  12  14  16  18
>   source: [--S0--][--S1--][--S2--][--S3--]
>   target:     [--T0--][--T1--][--T2--][--T3--]
>
> Here S0 and T0 overlap over [2,4), S1 and T1 over [6,8), and so on.
> Backward ordering cannot control how the server copies bytes inside one
> descriptor, so the chunk size must be limited to delta.
>
> Fix this by copying overlapping right shifts from EOF backwards. Limit
> the chunk size to delta when delta < C so that each chunk's source and
> target ranges do not overlap. Reject insert lengths below 4 KiB when
> this limit is needed to avoid excessive COPYCHUNK requests.
>
> Therefore:
>
>   delta >= L:
>     keep the normal copy order and chunk size
>
>   delta < L:
>     delta >=C: copy backwards and keep the normal chunk size
>     delta < C: copy backwards and limit the chunk size to delta
>
> Only the delta < C subcase requires reducing the chunk size for data
> integrity.
>
> Reproducer:
>
>   bash -c '
>           MNT=/mnt/scratch
>
>           # Generate four 1 MiB random blocks: [A][B][C][D].
>           dd if=/dev/urandom of=/tmp/src bs=1M count=4 status=none
>
>           # With C = 1 MiB, test delta = C and delta < C.
>           for delta in 1M 4K; do
>                   truncate -s 0 /tmp/expected
>                   truncate -s "$delta" /tmp/expected
>                   cat /tmp/src >> /tmp/expected
>
>                   cp /tmp/src "$MNT/file"
>                   fallocate --insert-range -o 0 -l "$delta" "$MNT/file"
>
>                   if cmp -s /tmp/expected "$MNT/file"; then
>                           echo "delta=$delta: OK"
>                   else
>                           echo "delta=$delta: CORRUPTED"
>                   fi
>           done
>   '

Without this patch and running above reproducer against Windows Server
2022, I get no data corruption.  Samba requires this patch to make it
work, though.

Besides, after applying this patch, generic/064 fails differently when
running against samba-4.24.5-1.fc44.x86_64

SECTION       -- smb3
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 fed 7.2.0 #4 SMP PREEMPT_DYNAMIC Wed Aug 26 21:42:48 -03 2026
MKFS_OPTIONS  -- //192.168.124.43/scratch
MOUNT_OPTIONS -- -ousername=testuser,password=foo-321,vers=3.1.1,mfsymlinks,noperm //192.168.124.43/scratch /mnt/scratch

generic/064        [not run] xfs_io finsert  failed (old kernel/wrong fs/bad args?)
Ran: generic/064
Not run: generic/064
Passed all 1 tests

Could you please verify?

Thanks.
