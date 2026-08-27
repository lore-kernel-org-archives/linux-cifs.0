Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4705352001
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787845545; cv=none; b=BdWRgLmq2PmRDJ7tIw1tzB1lWAluRyacMlnb5bg8NaV78tZCPJGhWJp6C5r8PQrlkaciAiFDfSgBYxc6/cMg70qiHRuSrZ3t/KMWK4c7H8WvAY2ljmI8dWPEJizcVmdmaHWtaPaWdz3WaB86oZC9yB1mmrE3LDrBra1jnydFS/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787845545; c=relaxed/simple;
	bh=wFeldRYixaIZjyp7JOtOkiJ6cqCx/wOlohJ147RNa7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnL9hldmxiyGNAY//D+OA3ZD3QNwfqVyrZ5DQK7loDaqFfc5ZW00Ox+ZNEP/HMdKY8hPVCavygreouKFgTxqCc1e/SHYsOrFk694sThZ/r47qXgl0KBJdkdPlbRZVAQJLlY5GuZPWd0yJ9+s2GtjeIxyAnj8mhDdUtJDVg+sjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E6l94p4O; arc=none smtp.client-ip=91.218.175.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E6l94p4O"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wFeldRYixaIZjyp7JOtOkiJ6cqCx/wOlohJ147RNa7s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787845540; v=1; x=1788450340;
 b=E6l94p4ORrj6YeLFjNtW6LxQ3xFYYKL0DqP/wMpYwQD4hl6jtzVXcnP+GkfSngU68/zUBwxk
 CCYFnZt9lDkjbyrwpJu6cHCGnBSpGAMD/F0KLjPiocPBQtFruolJR1jUmgP79J+cvoCqEcnWZKJ
 TwWR1EHwgTVwNOWdxtXFpkpw=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db04c8eb737eb613;
	Thu, 27 Aug 2026 15:45:30 +0000
X-Mizu-Trace-ID: db04c8eb737eb613
X-Migadu-Flow: FLOW_OUT
Message-ID: <c2b5c3cf-f961-4522-bb61-eb40deb87f6e@linux.dev>
Date: Thu, 27 Aug 2026 23:45:25 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] smb/client: fix data corruption in emulated insert
 range
To: Paulo Alcantara <pc@manguebit.org>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-5-huiwen.he@linux.dev>
 <a228fb66678a69c7f85bfbf89f47b2ad@manguebit.org>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <a228fb66678a69c7f85bfbf89f47b2ad@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Paulo,

Thanks for testing.

Windows Server 2022 handles overlapping same-file COPYCHUNK ranges
internally, so the old forward copy does not cause corruption there.
Samba and ksmbd do not handle such overlap safely.

The generic/064 result is caused by the 4 KiB minimum added by this 
patch.Samba reports a 1 KiB block size by default, so the test's
finsert probe uses a range smaller than 4 KiB and gets -EINVAL,
resulting in [not run].

My Samba setup used "block size = 4096", so I did not see this locally.

I will reconsider how to handle this and address it in v4.

Thanks,
Huiwen


在 2026/8/27 10:19, Paulo Alcantara 写道:
> Hi Huiwen,
> 
> Huiwen He <huiwen.he@linux.dev> writes:
> 
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> smb3_insert_range() shifts [off, EOF) right with COPYCHUNK, copying from
>> low to high offsets. When the ranges overlap, the copy can overwrite
>> source data that has not yet been copied. For a 1 MiB insert at offset 0:
>>
>>    offset:    0       1M      2M      3M      4M      5M
>>    before:   |   A   |   B   |   C   |   D   |
>>    expected: | hole  |   A   |   B   |   C   |   D   |
>>    current:  | hole  |   A   |   A   |   A   |   A   | (corrupted)
>>
>> Let x be the insertion offset, L the total length to move, delta the
>> insert length, and C the normal chunk size allowed by the server.
>> Insert range maps
>>
>>    [x, x + L) -> [x + delta, x + delta + L).
>>
>> When delta >= L, the complete source and target ranges are disjoint, so
>> the normal copy order and chunk size are safe:
>>
>>    offset: 0       4       8      12      16      20      24      28      32
>>    source: [--S0--][--S1--][--S2--][--S3--]
>>    target:                                 [--T0--][--T1--][--T2--][--T3--]
>>
>> When delta < L, the complete source and target ranges overlap, so the
>> copy must proceed from EOF backwards. There are two subcases.
>>
>> If C <= delta, each corresponding source and target chunk is disjoint.
>> The 1 MiB example has L = 4 MiB and delta = C = 1 MiB:
>>
>>    offset: 0       1M      2M      3M      4M      5M
>>    source: [--S0--][--S1--][--S2--][--S3--]
>>    target:         [--T0--][--T1--][--T2--][--T3--]
>>
>> Copying S0 from [0, 1M) to [1M, 2M) overwrites S1 before it is copied.
>> Processing chunks from EOF backwards prevents this inter-chunk
>> overwrite.
>>
>> If delta < C, the source and target ranges of a normal chunk also
>> overlap. For example, with L = 16, delta = 2 and C = 4:
>>
>>    offset: 0   2   4   6   8  10  12  14  16  18
>>    source: [--S0--][--S1--][--S2--][--S3--]
>>    target:     [--T0--][--T1--][--T2--][--T3--]
>>
>> Here S0 and T0 overlap over [2,4), S1 and T1 over [6,8), and so on.
>> Backward ordering cannot control how the server copies bytes inside one
>> descriptor, so the chunk size must be limited to delta.
>>
>> Fix this by copying overlapping right shifts from EOF backwards. Limit
>> the chunk size to delta when delta < C so that each chunk's source and
>> target ranges do not overlap. Reject insert lengths below 4 KiB when
>> this limit is needed to avoid excessive COPYCHUNK requests.
>>
>> Therefore:
>>
>>    delta >= L:
>>      keep the normal copy order and chunk size
>>
>>    delta < L:
>>      delta >=C: copy backwards and keep the normal chunk size
>>      delta < C: copy backwards and limit the chunk size to delta
>>
>> Only the delta < C subcase requires reducing the chunk size for data
>> integrity.
>>
>> Reproducer:
>>
>>    bash -c '
>>            MNT=/mnt/scratch
>>
>>            # Generate four 1 MiB random blocks: [A][B][C][D].
>>            dd if=/dev/urandom of=/tmp/src bs=1M count=4 status=none
>>
>>            # With C = 1 MiB, test delta = C and delta < C.
>>            for delta in 1M 4K; do
>>                    truncate -s 0 /tmp/expected
>>                    truncate -s "$delta" /tmp/expected
>>                    cat /tmp/src >> /tmp/expected
>>
>>                    cp /tmp/src "$MNT/file"
>>                    fallocate --insert-range -o 0 -l "$delta" "$MNT/file"
>>
>>                    if cmp -s /tmp/expected "$MNT/file"; then
>>                            echo "delta=$delta: OK"
>>                    else
>>                            echo "delta=$delta: CORRUPTED"
>>                    fi
>>            done
>>    '
> 
> Without this patch and running above reproducer against Windows Server
> 2022, I get no data corruption.  Samba requires this patch to make it
> work, though.
> 
> Besides, after applying this patch, generic/064 fails differently when
> running against samba-4.24.5-1.fc44.x86_64
> 
> SECTION       -- smb3
> FSTYP         -- cifs
> PLATFORM      -- Linux/x86_64 fed 7.2.0 #4 SMP PREEMPT_DYNAMIC Wed Aug 26 21:42:48 -03 2026
> MKFS_OPTIONS  -- //192.168.124.43/scratch
> MOUNT_OPTIONS -- -ousername=testuser,password=foo-321,vers=3.1.1,mfsymlinks,noperm //192.168.124.43/scratch /mnt/scratch
> 
> generic/064        [not run] xfs_io finsert  failed (old kernel/wrong fs/bad args?)
> Ran: generic/064
> Not run: generic/064
> Passed all 1 tests
> 
> Could you please verify?
> 
> Thanks.

