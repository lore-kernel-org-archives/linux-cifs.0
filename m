Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C561A00F0
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 08:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766566520; cv=none; b=O6Tcm4hjm0WfzrVp3coR/gJVnURgMv00N4mZXamrPKyjUgLsr7wEdZY9vsfhSk5Lu3GxlBuiCF812apuZ46F5eZmBHFFVco9JEJsY7UHi4R3xYscAWcUW2ITzE3PYqCATwCOTi9m/7MvuZDZAm2FYg2f4P95nup2o8yZK8Pyw+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766566520; c=relaxed/simple;
	bh=UHHGboSGU3FxN2m5/weH+D+0RiWy+pljLCpoAz7wW3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPEYPInd4FRz3u/zMTmrfol80quPoxqrCz18MCAfbV94i/qdEypy237YzdhWTJnKWy0BA5Jwu3zmNjnW3h9s5O6dhSwrljXzf7L2h1z+UKYhgCCzfLzL7dy6d7Vk4ZIIHXk5dB9lBYynNPtzfqVu426Zb0nmBnqVszYPYntgSa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QyO172K+; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QyO172K+"
Message-ID: <6dbc433c-eba7-4deb-bc28-3df63a27bc63@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766566516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7pNL6HYNnIsZ5mCBFhrfn9tYuEml2MjkdobdEFO1TA=;
	b=QyO172K+sb7IohcaTbPZInFkou6G9hxL3zql+G5uGEG5Ly6H8PwxGK8t7HDE6dgKq9XHrU
	qWULsCJ5BySqwf9GfkAAAyb4j58+OP8Eo8VnQrhreFnC1YMcG9cK/1fiWNYQmRTYZjlB+/
	yrKfDry8SNdXLXnQEutFQIt0C3x5d34=
Date: Wed, 24 Dec 2025 16:54:35 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 5/5] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev>
 <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
 <1168035.1766564530@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1168035.1766564530@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your suggestions, they are very helpful.

I will update these patches in the next version.

Thanks,
ChenXiaoSong.

在 2025/12/24 16:22, David Howells 写道:
> chenxiaosong.chenxiaosong@linux.dev wrote:
> 
>> +
>> +#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
>> +#include "smb2maperror_test.c"
>> +#endif /* CONFIG_SMB_KUNIT_TESTS */
> 
> This feels weird, but I think I can see what you're doing.  I guess it's not a
> kunit test in loadable module form?
> 
>> +	for (i = 0; i < err_map_num; i++) {
> 
> ARRAY_SIZE(smb2_error_map_table).
> 
> David
> 

