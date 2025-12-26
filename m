Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB4221F39
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 04:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766723864; cv=none; b=g0WgbxDwIs/NigT+tVIUk+ZoyZD1oPfeODn/FwP08KJJsbaHsQKuh469wkQweX1/qvXXith8txE9jAaN+X4ZRYbIYIA+s6ZLMWBT1F4zpqoKPz3abjxhd0u/lld1ehSBX1JrkENgpwSwg5oImLqmyRyBzcbknu0RYdySy7MW3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766723864; c=relaxed/simple;
	bh=jPV5V7ywM9AjISLF3kc2JuT2SMBMAnNZWocRa65XZi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuiuGUBqopWAYh5gbsxeeIIPDEbQNu+udNT9z47APOQNiNeaLFlmsZIJXMWpYN2ug1ypGVrpajudsvWLbw4/AAEZLo49FIEhRCbYiMSFndPDQSHV1JaI8MdcxoHRTwtDTqadITzQuJKMCwtgaezq7POWYV8SVHobbCjMXTHUh/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nl/4lDvp; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nl/4lDvp"
Message-ID: <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766723856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWfWHujFPhpWENhkliR8dykUD6qgh51XLlx4pjLMCnI=;
	b=Nl/4lDvpvVWKYOTzqMHz0N8bPq2j/T7TXH5vKFHm28W6NfgGMJZmGd3IfwZwGwz8FarQPx
	5lLZws1NbUcDKtRMmls33IHbvPaPUrCdSV0V5VSrtR958CLToI5ApHHx6w03OyZihlSdzL
	8XaVmLwctYjhyiiGqSID1U03EUzhwJo=
Date: Fri, 26 Dec 2025 12:36:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <smfrench@gmail.com>, gustavoars@kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Henrique,

I can reproduce this UBSAN error. You need to compile the kernel code 
using the latest version of Clang.

I would like to give special thanks to Tang Youling 
<tangyouling@kylinos.cn> for his guidance on UBSAN and Clang.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/24/25 23:02, Henrique Carvalho wrote:
> This UBSAN report is consistent with struct copychunk_ioctl_req::Chunks[]
> being annotated with __counted_by_le(ChunkCount) while ChunkCount is not
> set to the allocated capacity before we start populating the array. This is
> the same class of issue described in [1].
> 
> A fix would be to set ChunkCount to chunk_count (capacity) at the start
> of each iteration before accessing Chunks[]. Proposed patch is attached.
> 
> However, if my interpretation is correct, I would expect the first
> population to trip as well since ChunkCount starts at 0, which does not
> happen.
> 
> @Gustavo do you have any insight into why the first access might not
> trigger?
> 
> [1] https://people.kernel.org/gustavoars/how-to-use-the-new-counted_by-attribute-in-c-and-linux
> 

