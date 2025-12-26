Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4244A4A3C
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 06:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766731532; cv=none; b=RTfGIIg2bW0pDZJP5BX/c01BGk8mNDDqMtwiYyO423PsbBGJjaoJhOPxYtK7L9MrgZT7DlXnStSQMgRRsO41C67IiSkYhRozQ7EkWBzVifTX3la+fpjq6Ra8Ex7eNSwF2fjGQWqYoW1iy0DrG6Rw23fRLJMeNemY/TDgPNiKJ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766731532; c=relaxed/simple;
	bh=cPS4djvm6Fts40O/ZDCKiXBHhyoh/v2dr5vGOZszgo4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hi2JrQWLPRWq6hlCIDWPk7DEKYoPWFx4mf1J0m9u8YhToPcypImziG+IcNR70ZBx435VuG/Ew2YMiVk0hIpei//HLiZF6m1Xma3CaoDBXnQV6F1sBiJhPRrc28E1l1jpcPMQcQRXTR0TrwBBC2xDtWr/94OW7T7UNI9IUdYRhEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=STdA3iLm; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="STdA3iLm"
Message-ID: <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766731527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4AgCRNKKuoekdBNHIbjbaZSDSzyk0s/aspB9cEwUqfo=;
	b=STdA3iLm7w4UQOduTE4u1giuuWPgulMB40q0zG5zL42MduDlx1DPFmM0Hd+mPUixeSagX7
	dLqxGZO9iakBmvd7zzdAzwphohjmEsx/qckwkm4TqKxW9vnCTWYE5yh/mYU9QYdoDXeeh4
	OyHj99jOSz5AkhavBNpdH9Bgcb74g3A=
Date: Fri, 26 Dec 2025 14:44:26 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <smfrench@gmail.com>, Youling Tang <tangyouling@kylinos.cn>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
Content-Language: en-US
In-Reply-To: <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Henrique,

The following is the modifications I suggest. If you have a better 
solution, please let me know.

If you agree with my modifications, could you send the v2 patch?

Give special thanks once again to Youling Tang <tangyouling@kylinos.cn> 
for his guidance on UBSAN and Clang.

If you build the kernel code with the latest version Clang (I am using 
version 21.1.7), and `CONFIG_UBSAN_BOUNDS` has been enabled, you will be 
able to see this UBSAN error every time.

It seems that we need to add two Fixes tags:
Fixes: 68d2e2ca1cba ("smb: client: batch SRV_COPYCHUNK entries to cut 
round trips")
Fixes: cc26f593dc19 ("smb: move copychunk definitions to common/smb2pdu.h")

The key modifications are as follows:
```
smb2_copychunk_range()
{
	// remove `chunk_count`, and use only `cc_req->ChunkCount`
	...
	cc_req->ChunkCount = 0;
	while (copy_bytes_left > 0 && cc_req->ChunkCount < chunk_count) {
		cc_req->ChunkCount++;
		chunk = &cc_req->Chunks[cc_req->ChunkCount - 1];
		...
	}
	...
}
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/26/25 12:36, ChenXiaoSong wrote:
> Hi Henrique,
> 
> I can reproduce this UBSAN error. You need to compile the kernel code 
> using the latest version of Clang.
> 
> I would like to give special thanks to Tang Youling 
> <tangyouling@kylinos.cn> for his guidance on UBSAN and Clang.
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> On 12/24/25 23:02, Henrique Carvalho wrote:
>> This UBSAN report is consistent with struct copychunk_ioctl_req::Chunks[]
>> being annotated with __counted_by_le(ChunkCount) while ChunkCount is not
>> set to the allocated capacity before we start populating the array. 
>> This is
>> the same class of issue described in [1].
>>
>> A fix would be to set ChunkCount to chunk_count (capacity) at the start
>> of each iteration before accessing Chunks[]. Proposed patch is attached.
>>
>> However, if my interpretation is correct, I would expect the first
>> population to trip as well since ChunkCount starts at 0, which does not
>> happen.
>>
>> @Gustavo do you have any insight into why the first access might not
>> trigger?
>>
>> [1] https://people.kernel.org/gustavoars/how-to-use-the-new- 
>> counted_by-attribute-in-c-and-linux
>>
> 

