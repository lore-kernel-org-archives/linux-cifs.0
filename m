Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4898139A7EF
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 06:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786517970; cv=none; b=Ns541jAMjYACwI/kq2QF7IlljVChMX60Tvh43hluovoPDR+BurNR0/zp/vVS2gIff1QsmX9BsupXz0oCaBvYfTR8rCDHEVo7A2vkRmnWfEyGVOFF39wgL7y93e2VeCH6fn1/mWaaPKRCF5TMDYbH1q7pJ0Hb0+5Sm8r+3Z/XXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786517970; c=relaxed/simple;
	bh=9ag0vvGmZ8MRMCn+QKCT1bU0EtJ3hyQsmThWCRsQKbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZOrS1seM8p6N1EsM0QB2MpQ0JqEbYa8dN25/wHcf1c/ZXolsD3+ibiFrZpRhVkU3GGtfb0y7c3vyj29rkfiD+XvtpvTdewvbGJihRZ7lwiJXjvBc8SrBNIXrGbSPyaTQmUNSWi4LlIkNq0ale1gW6A8qmD4eXRS0bsuCBcEty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GbaReHCg; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GbaReHCg"
Message-ID: <caad5646-eba3-4629-9a21-c2000a37c0f3@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786517962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iyBYFe9jsO6WS9zWCHeqv2xBbHPzNZ19SscvV6TQv0=;
	b=GbaReHCguxgIpbG3em1o1Sh+HUyZIInMD050u3DiD39aFL5O+Qly1udbb/X2vRy4tbCZ/d
	kZpPxDq3ihEMe9n4d9wAroKr3AOHvtIOs3DS/Tc00qM5Pu2dvoZUYoA7x/i17CWjCSRI5b
	Z4PQ5wE9JLJUG1r5N8gLhNfIpsRP/biXaG3FO9lZbYKRbtUmrw1157kPjDLzn2pKLR5KTh
	UbrbG0h5ZOJJ05IfonFd/k/tCGtezJ02yGLrOfog9QyV1NDcx5Fqoskt8rBL1L8J8Czh8N
	JfI9c4MRaQtYoBkHYvQYJIEFFyzjxJ8r1G7b8RiFWFqycgypAva8q8UWOCl7zg==
Date: Wed, 12 Aug 2026 14:58:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I am trying to setup kerberos test environment. If you have any better 
related documentation, that would be very helpful to me.

On 8/11/26 20:50, Namjae Jeon wrote:
> Can you check two smbtorture failures from this patch-set ?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

