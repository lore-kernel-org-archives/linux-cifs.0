Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEC1368296
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 02:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354414; cv=none; b=XN04yYQsVfenPwVoMqGLV4xCRMj1tllI8HVZ92glhLi1jhPDnp4U/b7/ley8V7Zdg59HeTxSr6Nv1YcnPghtoMNdjOuwW7j3m4rTXcRsaP6rZtvNrcwiEf4Se2SytI442r3x0HLgH1xnL5jghJqMUNY+ioHZYHdKJIUBYJAhDso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354414; c=relaxed/simple;
	bh=fPv5gqgdswI3n5cZXUf///QdtNSEQ7Qejtseng1tLy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYDrdOW6HgMyVViFj1Ewt69N/2C8wtNq2oFVUkFaNFoTMUngeWq8D3WASvyOhF1TXpDyA2V65yJT9EHkmM9o8jc/eel9IjELBADpkyFmAPvc6SGcqG0uZZ35mdrHZOmAoMBAJxnU3z2ygMRbrmRLgfspwdnxpCm0Ej71auwbv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TgAnRJmL; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TgAnRJmL"
Message-ID: <28c08c0f-6806-491b-89e2-8b20e67dac77@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782354409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XYzze1O7HgJkW1+zVodeBBHAHzb6ob3008jefGrAGCM=;
	b=TgAnRJmLJH2RX6S/DcI7Zc9E+EuDRvOMRVrT/FOudDaKPK8bQgRWNyGqW5j3zPVRqnv/JH
	OjFHwZ7rFKQ0twm8HxTqGbydSXGlrufspL9hMclWzYB4e2ZQddJ3L0xX+lL4uY4xm48h57
	3RYlrxXW4H9Z157s4dAapaPcQAfRf/c=
Date: Thu, 25 Jun 2026 10:25:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/9] smb/client: handle smb2_set_sparse() failure in
 EOF-extending fallocate
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
 <20260624021550.1548952-4-huiwen.he@linux.dev>
 <CAH2r5mtLZTXGcCGy5y24CH_uDRr6tPq21i6wS4SZHhqHn7o13w@mail.gmail.com>
 <392ac41f-7f54-465f-a514-0293300747d6@linux.dev>
 <CAH2r5ms8bqK-Ywa0RsLPbB8fJikhA3N44oMRBFLzwD+J--nrDw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5ms8bqK-Ywa0RsLPbB8fJikhA3N44oMRBFLzwD+J--nrDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

I I agree with your point. On local filesystems such as ext4, XFS and 
btrfs,fallocate can reserve space for the requested range, including a 
range beyond EOF, while leaving other holes in the file untouched.

However, patches 3 and 4 do not introduce new clear-sparse cases. They 
only stop ignoring errors from the existing smb2_set_sparse(..., false) 
calls. In the paths where CIFS still relies on FSCTL_SET_SPARSE to 
provide the preallocation guarantee, failure from that operation should 
fail fallocate; otherwise we can return success while the requested 
range may remain sparse.

But you reminded me to rethink two related questions:

1.Is clearing the SMB sparse attribute a reasonable approximation for 
Linux fallocate semantics in some limited cases? Linux fallocate is
byte-range based, while FSCTL_SET_SPARSE is a file-level operation,
so it may not be a good fit as a general range allocation mechanism.

2.If that approximation is acceptable only for limited cases, are all
current fallocate paths that use smb2_set_sparse(..., false) actually 
safe? In other words, do we need to tighten the current cases where
CIFS relies on clearing the sparse attribute to emulate fallocate?

I will check the current code paths more carefully and make sure the all
operations are actually safe, assuming that clearing the sparse 
attribute can be used to approximate fallocate semantics in some limited 
cases.

I would be glad to hear your thoughts on this.

Thanks,
Huiwen


在 2026/6/25 05:26, Steve French 写道:
> So presumably I should skip patches 3 and 4 since it is allowed to have a
> sparse file which has allocated beyond end of file, and also allowed to
> have a falloc in a file that has holes - so we shouldn't be failing
> fallocate just because clearing sparse bit fails. Any thoughts?
> 
> On Tue, Jun 23, 2026 at 11:05 PM hehuiwen <huiwen.he@linux.dev> wrote:
> 
>> Hi Steve,
>>
>> Yes, that is possible. I checked ext4, XFS and btrfs with examples like:
>>
>>           truncate -s 1M file
>>           fallocate -n -o 2M -l 1M file
>>           filefrag -v file
>>
>> and:
>>
>>           truncate -s 1M file
>>           fallocate -o 2M -l 1M file
>>           filefrag -v file
>>
>> With FALLOC_FL_KEEP_SIZE, the file size stays at 1M while the range
>> [2M, 3M) is preallocated. Without FALLOC_FL_KEEP_SIZE, the file size
>> grows to 3M, but the filesystems still only allocate the requested
>> range [2M, 3M). Holes before that range are not removed.
>>
>> Patch 3 only changes the error handling around the existing
>> smb2_set_sparse(..., false) call. I agree that clearing the sparse
>> attribute is not a general byte-range allocation mechanism.
>>
>> Patch 9 handles the sparse EOF-adjacent case differently: small ranges
>> are allocated by writing zeroes only to the requested range, and larger
>> ranges remain unsupported. That avoids clearing the sparse attribute
>> for this case.
>>
>> Thanks,
>> Huiwen
>>
>>
>> 在 2026/6/24 10:48, Steve French 写道:
>>> Would it be possible in Linux to have a sparse file but still with
>>> space reserved beyond end of file?  In other words are there cases
>>> where you could have a file with holes in it in Linux which still
>>> fallocated beyond end of file.  What happens to ext4, xfs, btrfs if
>>> you try that?  Does fallocate beyond of file remove all holes in a
>>> (sparse) file?
>>
>>
> 

