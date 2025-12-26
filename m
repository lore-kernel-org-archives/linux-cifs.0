Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557DA3A1E66
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766764921; cv=none; b=FQkUKzMIGXkALgAMyLDp+jf0DnTJknVW72zDGWfkswq2AEYECOzR2AWSSO4DjhS4k4E+PLkIbJvT0HnAPVvX2U5PyuYF/j5q+kL4t3GJqsNFkZEAUhcbrTtDcNqYhSLX66laEWqpRYOq55FdJxIJnYJAo6mT1XncCJr4DcgvzaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766764921; c=relaxed/simple;
	bh=yfBrdNiE1pZHagwJsRV/D6Uogki417mpBIfs++sy210=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHLqxdSKzlUDcWD2748ruW6W5REHPqO5HOx8+FJiodO7SWw15O7U/kQaenZwl6ei62JtL1xLWHenFCcLpLb7PiH2/pCUEg0DJawADdOcWp9GRTfzCQK1sxM4/GbMgPXaGi0floJ6s41g3jyb5fbkMd+VONMIvb9PpmEOFnzCUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VaLaB27k; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VaLaB27k"
Message-ID: <b75f093a-6546-4b90-b4d0-879aa81cd327@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766764917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bg+xYeOGZuTa90yRZFFEg1tuGkgfZHx0jOHpoSMk15A=;
	b=VaLaB27kGQlytHX4SAfz7IwU2lOko7+UEFaH4iNEFF4Y2gtl2EZcj8d7FEmZS3Vzis4Rfq
	CYb7iCm8EG9dKl+bHeYqv1ZRnYABXN6DL1GE8KG2+aXsWrX3WMUvFC4ZbeBusk6hJan+tA
	KaMLuJcVLiXiwUoVeKwljK0O/7IwvS8=
Date: Sat, 27 Dec 2025 00:01:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Steve French <smfrench@gmail.com>, Youling Tang <tangyouling@kylinos.cn>,
 Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 CIFS <linux-cifs@vger.kernel.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
 <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Yes, you are correct. I didn't consider `cpu_to_le32()`.

How about changing it to the following?
```
smb2_copychunk_range()
{
	...
	chunks = 0;
	while (copy_bytes_left > 0 && chunks < chunk_count) {
		cc_req->ChunkCount = cpu_to_le32(++chunks);
		chunk = &cc_req->Chunks[chunks - 1];
		...
	}
	...
}
```

I also agree with your point about the Fixes tag.

Thanks,
ChenXiaoSong.

On 12/26/25 11:45 PM, Henrique Carvalho wrote:
> I don't agree with the proposed changes for a couple of reasons:
> 
> 1. ChunkCount is an on-wire __le32. Using it as the loop counter mixes
> endianness-annotated storage with CPU-endian arithmetic and would either
> require constant cpu_to_le32()/le32_to_cpu() conversions or be
> type/endianness misuse. The current CPU-endian u32 chunks counter is
> intentional.
> 
> 2. Re: "Fixes:" tags: the UBSAN report exists because Chunks[] is now
> __counted_by_le(ChunkCount). We currently index Chunks[] while
> ChunkCount is still zero, so the __counted_by contract is violated. That
> points to the commit that introduced the annotation as the Fixes target.
> I don't think the batching commit should be tagged unless it introduced
> a functional issue independent of the annotation.

