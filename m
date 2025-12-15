Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6BD1FE45A
	for <linux-cifs@vger.kernel.org>; Mon, 15 Dec 2025 04:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765773214; cv=none; b=uweLbOldkglFyQH2p2S3wAT4wfj+hTaXPM2eWgA6g4ixg3HDHFBAzl7wG5QDblPWLJ5kFML7pTwa+hSneafS/IKX7PsrGPXBYaJv/062kbOzIS4Xn+jJUObu3JN+7uD/47bwye6K/3VyWvFJHsLksRXCnHbstoYfYXEksRKk+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765773214; c=relaxed/simple;
	bh=niiiMeZl8RDVOq4rpPwLwvcoNvPVab3ne8dCA3x6O0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBgGvaI3wY8Uq26FkEoe5NYWa3zi1XDwHCL4igSswcdp/9vpuuTermakGb43JzLFuG8ttry9NnEhuyvMEbFzuMk6p2MCutPy/5gdd45jWubyVIPyR5poiEYEkz4rb/9xvJnE+EsDdm2Hcd8Xc+f9IWdfRWN9uNHdRn4JdIaTkmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CHQqz3w7; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CHQqz3w7"
Message-ID: <d72f2535-5ef7-4e7e-a2ca-c0e7c37f49ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765773208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uMD/pJnG+a6vFEkXKcBFt3yvwUgt6lYGh26ipmM3WAE=;
	b=CHQqz3w7QnaaMl+XfNY6mYEdJBHbknbYpP53V7dPG0OWufrjeQmdtD61m+NsnxrrXSKWJ1
	uFkm5Xr6EPVuW25K5u5WkmPfaXOT0vEXQN9tdeePLMBpenkjgwCCOht1dsQ8XKYvu15hX1
	fnQ7GPMNZrcWg+Mhw9Cq9NXUf+WnErw=
Date: Mon, 15 Dec 2025 12:33:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev>
 <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev>
 <650896.1765407799@warthog.procyon.org.uk>
 <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev>
 <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
 <782578.1765465450@warthog.procyon.org.uk>
 <811840.1765532505@warthog.procyon.org.uk>
 <798228cc-f403-4016-89d9-320c89944d31@linux.dev>
 <CAH2r5mvpz4BWM4Uua17Cg+vw-PrVpZOQLHmU8xi6XDmY8vuA=w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mvpz4BWM4Uua17Cg+vw-PrVpZOQLHmU8xi6XDmY8vuA=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi David,

Based on Steve's suggestions, should we consider only using the 
`gen_smb2_mapping` script to reorder the smb2_error_map_table[] array in 
client/smb2maperror.c?

This way, we can keep the code changes minimal (of course, we might have 
the opportunity for larger changes in the future).

Thanks,
ChenXiaoSong.

On 12/15/25 12:03, Steve French wrote:
> I would prefer not a large line of code change unless some perf benefit 
> but if alongside a perf improvement or bug fix then easier to justify
> 
> Thanks,
> 
> Steve
> 
> On Sun, Dec 14, 2025, 9:12 PM ChenXiaoSong 
> <chenxiaosong.chenxiaosong@linux.dev 
> <mailto:chenxiaosong.chenxiaosong@linux.dev>> wrote:
> 
>     Personally, I think using enum is a good idea.
> 
>     Thanks,
>     ChenXiaoSong.
> 
>     On 12/12/25 17:41, David Howells wrote:
>      > Also note that the format we end up going with for smb2status.h
>     is up for
>      > discussion.  My preferred idea is something along the lines of:
>      >
>      >       enum nt_status_codes {
>      >               STATUS_SUCCESS          = 0x00000000, // 0
>      >               STATUS_WAIT_0           = STATUS_SUCCESS,
>      >               STATUS_WAIT_1           = 0x00000001, // -EIO
>      >               STATUS_WAIT_2           = 0x00000002, // -EIO
>      >               STATUS_WAIT_3           = 0x00000003, // -EIO
>      >               ...
>      >       };
>      >
>      > and switching to using cpu-endian in the code.
>      >
>      > David
> 

