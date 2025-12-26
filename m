Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0018821
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766789325; cv=none; b=Ivfza7rOIck09HAKi8B4to3wFrOTReBDKLoiTiGLQUgRSsZfANnJ84iuSR9HW4eue7n2xoifuDPYt4i9yTCgZNBInpIANShYeoK0aAUWNNh1+WRzPDCYOb6vgtOwOGB2O3eoqamZWhS4O815SvkrY1KK6dmhLeiSzC3FuOFQ6hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766789325; c=relaxed/simple;
	bh=QCvFKfmdG+QL4YRK+r4iEXEqP78RU4GYbOITbqtMHW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTH7OKntT3MNJv4faQiK+1+XWjMG0HDAoRtpoE665mbMlw7D/LGpJUi2oU4iIBvEwW2qajgcMrpoZk8E4UQvDtCWGHTEIsVxByy3HdD3Hcm03SB1cA3AIhvcUgdbiyTS8HhlOET/Yyyo3jCe9hmEy3VOdI9yBKT+CHZL4ok0nZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xww1kOAp; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xww1kOAp"
Message-ID: <1afdefff-0ce5-4875-b480-0b3aba541d28@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766789320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2w+nfxIRMUTPz6G620HRdjx7X4zRCCicbjys9Qp9D1o=;
	b=xww1kOAp2BsfGtrmWe9mheBemCJUIL8JNuDi3isKP5fC/xs0N6nEG1wfr4DTlxvElmgWmi
	bpyzUqnkNZP57jjFwTQHeXIGRGCOql0pDyKUagK7t83CwlvkknoI2YXhrnseJxiQUeBDuS
	JnBwF/MrwIPLr5sQFtLi6lw/s2hvuKY=
Date: Sat, 27 Dec 2025 06:48:14 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <smfrench@gmail.com>
Cc: Youling Tang <tangyouling@kylinos.cn>, Namjae Jeon
 <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 CIFS <linux-cifs@vger.kernel.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
 <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
 <b75f093a-6546-4b90-b4d0-879aa81cd327@linux.dev>
 <7duojyv45sv3x65fmaggbhl2rydgisaqesedqqbrk2pg6jyo5m@2cwq23g2sw2v>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <7duojyv45sv3x65fmaggbhl2rydgisaqesedqqbrk2pg6jyo5m@2cwq23g2sw2v>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I think the comment in your change is easy to understand. Looks good to me.

Steve, what do you think? I see that you have already sent the pull 
request for 6.19-rc3. Should we merge Henrique's patch in rc3?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/27/25 2:05 AM, Henrique Carvalho wrote:
> Your change does make the code semantically tighter, since ChunkCount would
> track initialized elements as we populate the array.
> 
> That said, I still slightly prefer setting ChunkCount to the allocated
> capacity before we first index Chunks[], and then setting it to the final
> chunks value before the IOCTL.
> 
> This both satisfies __counted_by_le() during population, it isn't wrong
> given the allocation is chunk_count, and avoids an extra ChunkCount
> update on every chunk entry (in my build this is not optimized away).
> It's cheap either way, but if we can avoid per-iteration overhead, I'd
> rather do so.
> 
> What do you think? Do you see any correctness or tooling downside with
> this approach?

