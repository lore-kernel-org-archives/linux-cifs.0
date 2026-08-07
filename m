Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4441DE894
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 01:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786064506; cv=none; b=OvaNTROl/PrLJmRqzfclmAU/l/2zoBtctRiYRMk5w3sw4dVeyh3Dtugr4taIb2bgiYW7X7FkTi3zelz5bpqseVk/C4GY66f/XywmJxcUpePk6L+YKlF9lOe2Dhm4DDoYYNX5LZ3IkK04xzoQzQO1yJy+9fKLZfQAYzwqgtJ8MD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786064506; c=relaxed/simple;
	bh=GeASNSWyaMH5geJpb1hP6Yls0WEqHn03Q7rBpSdqlF0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UQxMNuyr//8KbrVuCTyM/jLtQ91f9pFb+oTwz21vrhABMeLgl9rq+0d413brewd6gSAucQuK9OnlLf5vAyuq5/034jE2f8WdJDYf0lZyp8uyqvhMfFm+u6K22hrXJPg8d/WKlyYo1D1OgMf+XoP6d83YvUaw2JcfYC6MFbM9z+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=jWKP3sUE; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="jWKP3sUE"
Message-ID: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786064106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpRtSel0xJP8TJX947bv7zbxIIBd32noIiI8xUz+9h8=;
	b=jWKP3sUEp40izZp6RN4P8LA7wHePTTCYoku6dZu5qscwD1b0z0j323FXr0Sh3bEk+nkR1E
	0TaQ29KCtC2lbYjIH+rEeZkMTFHkhJTDu+ziFfVTaBN8uxAKVoBPkjGk4t/9rIbcfdrZ5/
	pLxi/2CJyBjvTBAHkVJoYyjjAjJAAFn6JqRjPRptSew3FQqJm98PJjl5W1ySEouJBrdu6x
	kJYbMZyZKB1GsZjjsU7E3kSITt8tNMgL5+yuenbWZebaqvTT01RVT5XvARCEaQzHFgBcRM
	Na2/P7QKnXDJxpq5m4XfbbjpilsAZPjDOtRJlLH0wR9F+J3fcZo6a+MHOUM13g==
Date: Fri, 7 Aug 2026 08:54:10 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Hang Nan <2122295973@qq.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_1C4F8C48E45F6AE9D165CC17B3F620C40C08@qq.com>
 <b626fa81-e019-46e0-b071-e4806f08b1ac@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <b626fa81-e019-46e0-b071-e4806f08b1ac@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There are not any KUnit tests in fs/smb/server. It would be great if you 
could submit the first KUnit test.

On 8/7/26 04:35, ChenXiaoSong wrote:
> Hi Hang,
> 
> Thanks for your patch. Please rebase it on ksmbd-for-next-next branch.
> : https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next/
> 
> Could you share the semantic KUnit test harness?
> 
> 在 2026/8/7 0:04, Hang Nan 写道:
>> Validation:
>> - semantic KUnit harness shows the post-boundary ACE is selected
>>    before the fix and rejected (EACCES) after it
>> - linux master (7.2-rc6), x86_64
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

