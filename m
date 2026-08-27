Received: from mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C66631D72E
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787800706; cv=none; b=BRXnMT6ukSLcoKkJ8NOU+CX5eWiaSgYay0RVcOnuKhocfBL3xx83E0gklbZFx1YSa7zzrQU85e0FGHLrYc6/e1QZfLR2lWEkMb9qRr0EAcNV1DwC7+moha3MzMvKWxmL29MPmL1ur4OCvBMMouL/BSS1ARvaKb/q5x0vrl/Vzgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787800706; c=relaxed/simple;
	bh=yYK3ISC1GrGkXrJaoMCTJVBzVm6SINLK5WcEuUPp1b8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2FJt+gxTlSIgmZ3iYHtysMXLskGMusID6BsObrAlzkXPczxLR5fG1XPyyHPtj6YL4LlvbyJYap2J1lBmV6HnAnComsA8CyoWFj0geUruaxC6HMPvVwxUJethfou2atHHZq8s+VkxSDwA82GuR/PwhSJfZO1OWf6ls1D8AjgaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GeHf8eLA; arc=none smtp.client-ip=95.215.58.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GeHf8eLA"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yYK3ISC1GrGkXrJaoMCTJVBzVm6SINLK5WcEuUPp1b8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787800703; v=1; x=1788405503;
 b=GeHf8eLA0vwsZ+ihkN5vOtOqZA1MP8K6bZe8CZ0CK3nAOkqG3RK5QBe+5CKco8D2fkwGTCfk
 +lApebRNoTeKIaHUDx4PC9q9/Fc/pK1CpCknmXlKXivukuxU/MY9CNe0e/2rViDTmuJPQftOgqq
 mRKPqC1aJIGBlEtDmXIekesg=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [10.42.20.36] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id c855c83659b5ee82;
	Thu, 27 Aug 2026 03:18:13 +0000
X-Mizu-Trace-ID: c855c83659b5ee82
X-Migadu-Flow: FLOW_OUT
Message-ID: <69832461-b644-42bd-b3f5-b0371a4c2a22@linux.dev>
Date: Thu, 27 Aug 2026 11:18:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] smb/client: mark file sparse before emulating
 insert range
To: Paulo Alcantara <pc@manguebit.org>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-4-huiwen.he@linux.dev>
 <8847b8a47388c3d197514e1e477ec65c@manguebit.org>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <8847b8a47388c3d197514e1e477ec65c@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thanks. I repeated a controlled A/B test with the same kernel tree,
reverting/restoring only this patch.

Without the patch:

./check -d generic/064
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 localhost 7.2.0-rc6+ #71 SMP 
PREEMPT_DYNAMIC Tue Aug 25 15:38:06 CST 2026
MKFS_OPTIONS  -- //192.168.10.1/scratch_share
MOUNT_OPTIONS -- -o 
username=smbuser,password=Kylin123,vers=3.1.1,mfsymlinks,noperm 
//192.168.10.1/scratch_share /mnt/scratch

generic/064  2s ... QA output created by 064
Extent count after inserts has value of 1
Extent count after inserts is NOT in range 50 .. 53
- output mismatch (see /src/xfstests-dev/results//generic/064.out.bad)
     --- tests/generic/064.out	2026-05-08 16:46:07.377810776 +0800
     +++ /src/xfstests-dev/results//generic/064.out.bad	2026-08-27 
11:11:58.000000000 +0800
     @@ -1,2 +1,3 @@
      QA output created by 064
     -Extent count after inserts is in range
     +Extent count after inserts has value of 1
     +Extent count after inserts is NOT in range 50 .. 53
     ...
     (Run 'diff -u /src/xfstests-dev/tests/generic/064.out 
/src/xfstests-dev/results//generic/064.out.bad'  to see the entire diff)
Ran: generic/064
Failures: generic/064
Failed 1 of 1 tests
---------------------------------------------------------------

With the patch:

./check -d generic/064
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 localhost 7.2.0-rc6+ #71 SMP 
PREEMPT_DYNAMIC Tue Aug 25 15:38:06 CST 2026
MKFS_OPTIONS  -- //192.168.10.1/scratch_share
MOUNT_OPTIONS -- -o 
username=smbuser,password=Kylin123,vers=3.1.1,mfsymlinks,noperm 
//192.168.10.1/scratch_share /mnt/scratch

generic/064  2s ... QA output created by 064
Extent count after inserts is in range
  2s
Ran: generic/064
Passed all 1 tests

--------------------------------------------------------------
Server configuration:

     Fedora 43
     Samba 4.23.7-2.fc43
     btrfs backing filesystem
     strict allocate = yes

As noted in the v1 cover letter, the Windows Server result is expected: 
aligned 64 KiB and 128 KiB insert ranges are reported as holes, while 
generic/064 uses 4 KiB inserts, which are below the observed
sparse deallocation granularity on Windows.

Thanks,
Huiwen

在 2026/8/27 10:13, Paulo Alcantara 写道:
> Hi Huiwen,
> 
> Huiwen He <huiwen.he@linux.dev> writes:
> 
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
>> and SET_ZERO_DATA.
>>
>> SET_ZERO_DATA creates a hole only when the file is sparse. On a
>> non-sparse file, it clears the inserted range but leaves its blocks
>> allocated, causing the extent count check in xfstests generic/064 to
>> fail.
>>
>> Fix this by marking the file sparse before modifying it.
>>
>> Tested with xfstests generic/064 against Samba and ksmbd.
> 
> After applying this patch, generic/064 still fails for me against
> samba-4.24.5-1.fc44.x86_64.  Tested it with both btrfs and xfs, and
> 'strict allocate = yes'.  It also fails against Windows Server 2022.
> 
> SECTION       -- smb3
> FSTYP         -- cifs
> PLATFORM      -- Linux/x86_64 fed 7.2.0 #4 SMP PREEMPT_DYNAMIC Wed Aug 26 21:42:48 -03 2026
> MKFS_OPTIONS  -- //192.168.124.43/scratch2
> MOUNT_OPTIONS -- -ousername=testuser,password=foo-321,vers=3.1.1,mfsymlinks,noperm //192.168.124.43/scratch2 /mnt/scratch
> 
> generic/064        - output mismatch (see /root/g/xfstests/results//smb3/generic/064.out.bad)
>      --- tests/generic/064.out   2024-02-15 10:35:04.361833706 -0300
>      +++ /root/g/xfstests/results//smb3/generic/064.out.bad      2026-08-26 21:58:54.469813041 -0300
>      @@ -1,2 +1,3 @@
>       QA output created by 064
>      -Extent count after inserts is in range
>      +Extent count after inserts has value of 1
>      +Extent count after inserts is NOT in range 50 .. 53
>      ...
>      (Run 'diff -u /root/g/xfstests/tests/generic/064.out /root/g/xfstests/results//smb3/generic/064.out.bad'  to see the entire diff)
> Ran: generic/064
> Failures: generic/064
> Failed 1 of 1 tests
> 
> What am I missing?
> 
> Could you please provide details of your server version and settings?
> 
> Thanks.

