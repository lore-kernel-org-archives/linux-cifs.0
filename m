Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1401A23B628
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 02:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765334970; cv=none; b=n1FjkztPTXkQ+5CFtk5TheZojheoGL5MwrDYaKgzFlQEqCohBig6v40v9V/Gh4NZ676sJjIRNlrGzciL8n0o1Zt5Ho4rJ04gCBXAFLaV/UiXFsJtLv3xg0oNOv3wfxuwBmOFpZhqVkNkTtgIEAG7k9uLeHhG3lsHRVlT/kcM5E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765334970; c=relaxed/simple;
	bh=y72akw+UWw4czhJ8v26CmIJ45aFE1fVEf6ynDqJVkDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOXrK0NWKLueHL6fkX4SUUJ2Enn0PSglZt5orc3zUnyqk7F4DhF3SAvE8/4zqx5okKZk94t0kUoZxt+8uH7C1JBXNy95gAbqtWVdwPUEmuGzQ76mEVlT1Ki2HSGgHFeEQYl6UtmU7CiJrvANwSnZ6y8NRXfkxIqijU/FixoMrYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Luovh8ev; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Luovh8ev"
Message-ID: <48879a08-fcf0-47bb-bf39-c6d36e25f8ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765334965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PsTCVBUUtyItyxH7P6RmGKMR8cgMZp0nmX0G1k3Kzbs=;
	b=Luovh8evpN4Szs0bZFJY9oG2XRbpxgumknls9U5ljOOhvy/Z/C2D+BYc4et9rMtORNOuQB
	Mo2ukRlGGVN7HTsNrmbPODigj4FpY4lvbyGjE1RoWLr8EsGscWKDWH2s6w3B3IkzgTXkWE
	S+aQ9VhpOqxZpyVGPonJcbG1PkzEa0c=
Date: Wed, 10 Dec 2025 10:48:42 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] smb: improve search speed of SMB1 maperror
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Namjae Jeon <linkinjeon@samba.org>, Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAH2r5mvy6zoD3UKto6uOknFFMKCncJOPiDYqEUwKB_Zcpuj2pw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mvy6zoD3UKto6uOknFFMKCncJOPiDYqEUwKB_Zcpuj2pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve and Namjae,

I have updated the list of patches that have not been merged yet: 
https://chenxiaosong.com/en/smb-patch.html

I will provide the test results for these patches today.

Thanks,
ChenXiaoSong.

On 12/10/25 07:41, Steve French wrote:
> Merged nine of the client patches from this series into cifs-2.6.git
> for-next.  They looked safe.  Good catch on fixing some of these
> incorrect error definitions.
> 
> a691ac0cdd97 (HEAD -> for-next, origin/for-next) smb: move
> file_notify_information to common/fscc.h
> c0fd2fbe4f73 smb: move SMB2 Notify Action Flags into common/smb2pdu.h
> 787a2b803211 smb: move notify completion filter flags into common/smb2pdu.h
> 14a6f0e19fc7 smb/client: add parentheses to NT error code definitions
> containing bitwise OR operator
> 1e4c7c9ab176 smb: add documentation references for smb2 change notify
> definitions
> 833f0f46368f smb/client: add 4 NT error code definitions
> 3a0a34572269 smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
> 954cbce76316 smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
> b9695d00b605 smb/client: fix NT_STATUS_NO_DATA_DETECTED value
> 3d99347a2e1a (linus/master, linus/HEAD) Merge tag
> 'v6.19-rc-part1-smb3-client-fixes' of
> git://git.samba.org/sfrench/cifs-2.6
> 
> On Mon, Dec 8, 2025 at 12:22 AM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Before applying this patchset, the patchset ("smb: improve search speed of SMB2 maperror") must
>> be applied first, which introduces `CONFIG_SMB_KUNIT_TESTS` and avoids some conflicts in `fs/smb/client/cifsfs.c`:
>> https://chenxiaosong.com/lkml-improve-search-speed-of-smb2-maperror.html (Redirect to the LKML link)
>>
>> When searching for the last element, the comparison counts are shown in the table below:
>>
>> +--------------------+--------+--------+
>> |                    |Before  |After   |
>> |                    |Patchset|Patchset|
>> +--------------------+--------+--------+
>> | ntstatus_to_dos_map|   525  |    9   |
>> +--------------------+--------+--------+
>> |             nt_errs|   516  |    9   |
>> +--------------------+--------+--------+
>> |mapping_table_ERRDOS|    39  |    5   |
>> +--------------------+--------+--------+
>> |mapping_table_ERRSRV|    37  |    5   |
>> +--------------------+--------+--------+
>>
>> ChenXiaoSong (30):
>>    smb/client: fix NT_STATUS_NO_DATA_DETECTED value
>>    smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
>>    smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
>>    smb/server: remove unused nterr.h
>>    smb/client: add 4 NT error code definitions
>>    smb/client: add parentheses to NT error code definitions containing
>>      bitwise OR operator
>>    smb/client: introduce DEFINE_CMP_FUNC()
>>    smb/client: sort ntstatus_to_dos_map array
>>    smb/client: create netmisc_test.c and introduce
>>      DEFINE_CHECK_SORT_FUNC()
>>    smb/client: introduce KUnit test to check sort result of
>>      ntstatus_to_dos_map array
>>    smb/client: introduce DEFINE_SEARCH_FUNC()
>>    smb/client: use bsearch() to find target in ntstatus_to_dos_map array
>>    smb/client: remove useless elements from ntstatus_to_dos_map array
>>    smb/client: introduce DEFINE_CHECK_SEARCH_FUNC()
>>    smb/client: introduce KUnit test to check search result of
>>      ntstatus_to_dos_map array
>>    smb/client: sort nt_errs array
>>    smb/client: introduce KUnit test to check sort result of nt_errs array
>>    smb/client: use bsearch() to find target in nt_errs array
>>    smb/client: remove useless elements from nt_errs array
>>    smb/client: introduce KUnit test to check search result of nt_errs
>>      array
>>    smb/client: sort mapping_table_ERRDOS array
>>    smb/client: introduce KUnit test to check sort result of
>>      mapping_table_ERRDOS array
>>    smb/client: use bsearch() to find target in mapping_table_ERRDOS array
>>    smb/client: remove useless elements from mapping_table_ERRDOS array
>>    smb/client: introduce KUnit test to check search result of
>>      mapping_table_ERRDOS array
>>    smb/client: sort mapping_table_ERRSRV array
>>    smb/client: introduce KUnit test to check sort result of
>>      mapping_table_ERRSRV array
>>    smb/client: use bsearch() to find target in mapping_table_ERRSRV array
>>    smb/client: remove useless elements from mapping_table_ERRSRV array
>>    smb/client: introduce KUnit test to check search result of
>>      mapping_table_ERRSRV array
>>
>>   fs/smb/client/cifsfs.c       |    2 +
>>   fs/smb/client/cifsproto.h    |    1 +
>>   fs/smb/client/netmisc.c      |  155 ++++--
>>   fs/smb/client/netmisc_test.c |  114 ++++
>>   fs/smb/client/nterr.c        |   12 +-
>>   fs/smb/client/nterr.h        | 1017 +++++++++++++++++-----------------
>>   fs/smb/server/nterr.h        |  543 ------------------
>>   fs/smb/server/smb2misc.c     |    1 -
>>   fs/smb/server/smb_common.h   |    1 -
>>   9 files changed, 739 insertions(+), 1107 deletions(-)
>>   create mode 100644 fs/smb/client/netmisc_test.c
>>   delete mode 100644 fs/smb/server/nterr.h
>>
>> --
>> 2.43.0
>>
> 
> 

