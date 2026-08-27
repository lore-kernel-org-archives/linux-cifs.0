Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F78D3815E8
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796838; cv=none; b=ZVFhLtxBJPJo0OBXJZc4w0PRUGRJAJSK1VQzu67jPzXP0I6klWH/tE+tgxy5iT7Mggt0v2x+ULywt231PZNLKVIto7+rxW3SieB4Xt2hdda5upxi05jQ3/k/p8SWG5Kxiqvq29jPQTHBX8o2bBjTzw0avXJGIOieH5Ys0v8AmXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796838; c=relaxed/simple;
	bh=tNkpqRHJW8ZZrtAF9ylN6qjA8GOxvAmHr/UzYiW2wwI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=O5jAlvoaZ1ZpJohm3hhTdNFDk+hQL/uhmIuW7o10MS1Y1owmD/YokaoHZCwTQxBREfD/SpjtLMaV8AQztxwrjja35KtQ4/7RTdGyYX9E1NoOqjiJRFxCaV/WHHojtjXESQhi2Fy5bpmyc5RwgsFfsW0a3IAUmweqn+X+6KKhb3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rh8Bo/1w; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rh8Bo/1w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6te1OZ/OZNZxudLrkTZlRTU8rI64wihivoDhUHJw8iI=; b=rh8Bo/1wZEPyC4S6nggL57ogzO
	iDrrHrp6jZYMcA4w0Vn7rwZhXvjpwtLKnjNSz/21LfmhjF0miqkAReiERt5V5m/R6CZKvbSCweCNe
	N+G0dpl94zxNZ9dvfx14J2ZqapmoKA15HmLfJLjc822CIwV1a85K2zmDpo0hg3E32QAs+2zVYrxRV
	7k2aGBNxjQbCT7And/BvAd80nkK/4QxOvy4T18JPQqHTiSaOHsAhwQq3bzy0WZ5phGVE6bHjya/lK
	TdyEu68XklWiW/oWs+r3oasqlqsYh8KlZliRbvRhWZrwvHKl5TCBJygPn6Up+EC7lSRZKu8jGVdmX
	d6a4zQ6Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPcp-000000004gf-2Fhi;
	Wed, 26 Aug 2026 23:13:55 -0300
Message-ID: <8847b8a47388c3d197514e1e477ec65c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 3/7] smb/client: mark file sparse before emulating
 insert range
In-Reply-To: <20260823151053.935889-4-huiwen.he@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-4-huiwen.he@linux.dev>
Date: Wed, 26 Aug 2026 23:13:55 -0300
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
> The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
> and SET_ZERO_DATA.
>
> SET_ZERO_DATA creates a hole only when the file is sparse. On a
> non-sparse file, it clears the inserted range but leaves its blocks
> allocated, causing the extent count check in xfstests generic/064 to
> fail.
>
> Fix this by marking the file sparse before modifying it.
>
> Tested with xfstests generic/064 against Samba and ksmbd.

After applying this patch, generic/064 still fails for me against
samba-4.24.5-1.fc44.x86_64.  Tested it with both btrfs and xfs, and
'strict allocate = yes'.  It also fails against Windows Server 2022.

SECTION       -- smb3
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 fed 7.2.0 #4 SMP PREEMPT_DYNAMIC Wed Aug 26 21:42:48 -03 2026
MKFS_OPTIONS  -- //192.168.124.43/scratch2
MOUNT_OPTIONS -- -ousername=testuser,password=foo-321,vers=3.1.1,mfsymlinks,noperm //192.168.124.43/scratch2 /mnt/scratch

generic/064        - output mismatch (see /root/g/xfstests/results//smb3/generic/064.out.bad)
    --- tests/generic/064.out   2024-02-15 10:35:04.361833706 -0300
    +++ /root/g/xfstests/results//smb3/generic/064.out.bad      2026-08-26 21:58:54.469813041 -0300
    @@ -1,2 +1,3 @@
     QA output created by 064
    -Extent count after inserts is in range
    +Extent count after inserts has value of 1
    +Extent count after inserts is NOT in range 50 .. 53
    ...
    (Run 'diff -u /root/g/xfstests/tests/generic/064.out /root/g/xfstests/results//smb3/generic/064.out.bad'  to see the entire diff)
Ran: generic/064
Failures: generic/064
Failed 1 of 1 tests

What am I missing?

Could you please provide details of your server version and settings?

Thanks.
