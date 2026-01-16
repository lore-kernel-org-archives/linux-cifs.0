Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F50330FF27
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 03:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768532862; cv=none; b=HPugkwC8udR8WTDIS4w3ax7/7NrczJfQsfRGwmZsRh7chNIekeZZzkrJeIfzSzPPw1pW0+ccu8foXpCpVEtFHzZ125qGw04rEWigpeaHyfa2ywERlzq65ntGP3l83xYMAc+aazYbAkZZlTxzRTAW6J0TKpgYSwFEZ9juPBeYFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768532862; c=relaxed/simple;
	bh=jt6n2J/H4tz7wZJdl2QBwEq9nW6atH6SGEWdEOiOFfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=If3irGhur/bnHdB9/HubyglEXhISpqebgegMTBLkYNBL9D2PjJFLRkTzaibQH1Zs0IPM2c6fSvuMTp2Wh2vNsiV2K2HfJ0WXwl4qju/n0O6JbewokiS2JL4Nx0ejHiNkQnSRvLxsB8ncRu6EBzr/uiFuUniuBUGWz4udXcuAjtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sXrUEgAA; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sXrUEgAA"
Message-ID: <ccbe5da5-0922-4ba2-b4cb-fc1d0f4ce325@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768532858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdGHOmJlRXQc4r4nqzLuSwhnQBPTvpW4xD4Qvc1cNrg=;
	b=sXrUEgAAn82S+0CoCmnLv5asNgxPwEdNRFJE3RxovQlHtvDribzmjGmygXz+nnd97pb0kI
	XfSkAfJZRJiNXts7AEf9R36u57fIReyQeIwplV7Pdp7GEiK7KZOfTUuDEqxjoP34NgZYXP
	4fu9EJf9ZyqaxLYx5pqS/oXJQR1udYs=
Date: Fri, 16 Jan 2026 11:06:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/37] cifs: Scripted header file cleanup and SMB1 split
To: Steve French <smfrench@gmail.com>, Enzo Matsumiya <ematsumiya@suse.de>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, henrique.carvalho@suse.com,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251222223006.1075635-1-dhowells@redhat.com>
 <sijmvmcozfmtp3rkamjbgr6xk7ola2wlxc2wvs4t4lcanjsaza@w4bcxcxkmyfc>
 <CAH2r5mtgC_s2J9g0smr5NDxSp1TO7d+dtZ7=afnuw9hMxQ4TYQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mtgC_s2J9g0smr5NDxSp1TO7d+dtZ7=afnuw9hMxQ4TYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

There are some conflicts when merging my patches into cifs-2.6.git 
for-next: 
https://lore.kernel.org/linux-cifs/20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev/

Should I send a new version, or would you prefer a kernel tree with the 
conflicts resolved?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/16/26 10:50, Steve French wrote:
> Chen,
> Will we need to rebase your patch series as well? Let me know your
> current cifs.ko patches for 6.20-rc

