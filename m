Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E58F1CD15
	for <linux-cifs@vger.kernel.org>; Mon, 15 Dec 2025 03:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768354; cv=none; b=u476itDy81vzx3gMOf+xpeU0INpY3s0TejhcFmQYcoT+LCPKqJSYhc9dcK6LMGrgGNUg+6/mF6F/CmfP9OJnGe8HfOSU0Mu+K67El5U5K4bJXIE/AlmTaPcHrmsl1WGBBFdkLPtmoZjwuUU21YEyKEamYetPtIw1TJRb8lKIevQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768354; c=relaxed/simple;
	bh=4PEjHAENNavcmFF4yEIumyuoIX3tHzthbkn5/KeRoFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdJL9gchG2oRHYm28i7pCXzcisQJDMVsnmnyb21ZGzovE/gp4yFtOLEj36xkTviyPlL0LeFPirxumm/yRjaDWtbgh615+7IkyD0gwEgUmFUBp7WJZwBBdO+T77wTJYAvHzD4D882PPmIVqxdHhncBiNoxDreg0xpj4DxbosvUhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AXqjhFTa; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AXqjhFTa"
Message-ID: <798228cc-f403-4016-89d9-320c89944d31@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765768348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gzPMS/S8BPaUw+7dkd3ZkmNBRgaITRK1XYWdFER3G1g=;
	b=AXqjhFTawksolbM9Zi1XOxX5a8MSqP3Ke0Rrm4mMmK6fvY+E2a/h9pXMiU7D+Y55bGHhQF
	7z7j7TgKv1inWv4n3xuabBYTe2syvUC1X4B2EbDwBHe+IpOL3bv/pZ10PEsQaUXyP31RJZ
	DBmaIViQkm/Rv/YBs/N0BvRVr11mZ4A=
Date: Mon, 15 Dec 2025 11:11:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, liuzhengyuan@kylinos.cn,
 huhai@kylinos.cn, liuyun01@kylinos.cn, Paulo Alcantara <pc@manguebit.org>,
 CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>
References: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev>
 <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev>
 <650896.1765407799@warthog.procyon.org.uk>
 <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev>
 <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
 <782578.1765465450@warthog.procyon.org.uk>
 <811840.1765532505@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <811840.1765532505@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Personally, I think using enum is a good idea.

Thanks,
ChenXiaoSong.

On 12/12/25 17:41, David Howells wrote:
> Also note that the format we end up going with for smb2status.h is up for
> discussion.  My preferred idea is something along the lines of:
> 
> 	enum nt_status_codes {
> 		STATUS_SUCCESS		= 0x00000000, // 0
> 		STATUS_WAIT_0		= STATUS_SUCCESS,
> 		STATUS_WAIT_1		= 0x00000001, // -EIO
> 		STATUS_WAIT_2		= 0x00000002, // -EIO
> 		STATUS_WAIT_3		= 0x00000003, // -EIO
> 		...
> 	};
> 
> and switching to using cpu-endian in the code.
> 
> David

