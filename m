Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D6640D574
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782699346; cv=none; b=thPvLkjocefqetDrzRjYmIFDQQ1mC2yDJgJKrOV9gIKwufoL4SxcldlMwvASmX1dsC4vOf8Lnscd/k/0AbEOP2lZcOnfpM8ipGmH0gmsn5hP1Qogt+RDCJHjSrVQhzdIVai7R/PUGeYVQ8HPHevkYFVehOQ9pakPkt3ZohYsGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782699346; c=relaxed/simple;
	bh=9lpFSy9kTWmN1gs0c3qGak//bZTYKWif2KZ5t/Un3vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zp6WYYqY/CJENIXmxGF28Uh6/p6s/mw9IaU4NRX2KSxKGRYMTGW6jMM6m90TvYBY7Pj8Sc4tvKWQw5BKOIDa09iBZcsOwsexxvHfxmi186W4uQMzOzVaAxlOyD8PZg/qmNBdW8mLRXXbDl6L1QxxCZJcePp9E8f/4A9aygyPyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tNXcI1mS; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tNXcI1mS"
Message-ID: <93d481fc-15d4-48c9-961a-3253200ece80@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782699342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yayGSPMtaEYtOOnP8Yqrh9xRJWQAoPRLg9Rq8kYBEBQ=;
	b=tNXcI1mSLDWX8cjypWaejsVfU13dvugteYQI3CKQEgMwI5fK4O9znOJIRyd+ZLn8VA1lvd
	zVVnBPqtwxewqIAiWQHpFnfkXrek7Wx4qqdhefzZw3do45JOBPBc3ONaZWWhL4rT4iDZs0
	0TlUKYYLlaQZ7gQ4M81siWqaPri51gA=
Date: Mon, 29 Jun 2026 10:14:41 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/7] smb/client: fix fallocate and allocation
 accounting
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
References: <20260626134719.158270-1-huiwen.he@linux.dev>
 <CAH2r5mscAwv1BU25XouJpX_5gx2Xatnh=g6BiLnQj0DvVjrxSw@mail.gmail.com>
 <CAH2r5mtzjPHuAvko1zSW65DeOcX8KmQJuvy5b4RGxCAm0=4yqA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5mtzjPHuAvko1zSW65DeOcX8KmQJuvy5b4RGxCAm0=4yqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

After looking at this more, I think the key issue is not only which 
xfstests pass, but whether we need to implement real fallocate(mode=0) 
preallocation semantics in the CIFS client.

For fallocate(mode=0), CIFS currently relies on SetEOF in some paths. 
SetEOF only changes the logical file size and does not request real
space allocation from the server.

For servers that can actually preallocate space, such as Samba with
`strict allocate=yes` or ksmbd, the client probably needs to use the
SMB allocation request and update i_blocks from server-reported 
AllocationSize.

So I think we may need to separate two topics:

1. preserving Samba `strict allocate=no` compatibility;
2. implementing real fallocate preallocation semantics when the
    server supportsit.

However, these two goals can conflict in some tests.  For example, 
generic/228 expects `falloc 0 50m` to succeed, which matches the old 
Samba `strict allocate=no` behavior, while generic/496 needs a 
fallocated swapfile to have real allocated blocks, which requires 
server-side allocation.

So using FILE_ALLOCATION_INFORMATION without verifying the resulting
AllocationSize may preserve compatibility, but it would still not 
guarantee real fallocate preallocation semantics.

Thanks,
Huiwen

在 2026/6/28 02:13, Steve French 写道:
> With all patches (including smb/client: preserve errors from
> smb2_set_sparse) except
>      smb/client: verify allocation after EOF-extending fallocate
> tests 496 and 701 fail
> 
> On Sat, Jun 27, 2026 at 1:06 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Everything passes with six of these seven as long as I leave out:
>>
>>            smb/client: verify allocation after EOF-extending fallocate
>>
>> and revert the earlier patch:
>>
>>            smb/client: preserve errors from smb2_set_sparse()
>>
>> On Fri, Jun 26, 2026 at 8:47 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>>
>>> From: Huiwen He <hehuiwen@kylinos.cn>
>>>
>>> Changes in v4:
>>>
>>> - Add new patch 1 to refresh i_blocks after successful duplicate-extents.
>>>    This fixes stale st_blocks after reflink and avoids the generic/370
>>>    swapon hole-check regression.
>>>
>>> The following patches from v2 have already been merged into cifs-2.6.git for-next:
>>>    - smb/client: do not account EOF extension as allocation
>>>    - smb/client: preserve errors from smb2_set_sparse()
>>>    - smb/client: name the default fallocate mode
>>>
>>> Link to v3:
>>> https://lore.kernel.org/linux-cifs/20260625160154.104450-1-huiwen.he@linux.dev
>>>
>>> Link to v2:
>>> https://lore.kernel.org/linux-cifs/20260624021550.1548952-1-huiwen.he@linux.dev
>>>
>>> Thanks,
>>> Huiwen
>>>
>>> Huiwen He (7):
>>>    smb/client: refresh allocation size after duplicate extents
>>>    smb/client: handle smb2_set_sparse() failure in EOF-extending
>>>      fallocate
>>>    smb/client: handle smb2_set_sparse() failure in non-extending
>>>      fallocate
>>>    smb/client: handle overlapping allocated ranges in fallocate
>>>    smb/client: reduce fallocate zero buffer allocation
>>>    smb/client: emulate small mode 0 fallocate ranges at or past EOF
>>>    smb/client: verify allocation after EOF-extending fallocate
>>>
>>>   fs/smb/client/smb2ops.c   | 169 +++++++++++++++++++++++++++++++++-----
>>>   fs/smb/client/smb2pdu.c   |  19 +++++
>>>   fs/smb/client/smb2proto.h |   3 +
>>>   fs/smb/common/fscc.h      |   5 ++
>>>   4 files changed, 175 insertions(+), 21 deletions(-)
>>>
>>> --
>>> 2.43.0
>>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 

