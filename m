Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8877211A05
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766762913; cv=none; b=TFsQ0obF56ZbjUy2dMyjQbXn3W+54jIb7T3SRhnWoV6Dj+Mno8haxJ4tVzlmwovXVL2lKqG5Rx8vIAmINC06+DdkVMECaJGW7Jpa16jWTkT0E3fODtO1eyqfhOAYiPSSQCFmCq6pgeYX8gvhxPP3SqWpX2NnFh/iZvM4XqLL/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766762913; c=relaxed/simple;
	bh=zRa1ch2Q7XDsbSP0aPqVA7GHkIDJGPTjnf6wuUX0Emw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dB+YuZc7SJ5YkjYcajs/kuinndFObAPaYCXVhCmN3hSQStCsFo7yt7Nsk9DS0DK6PiIp9OBzMOdPExHfopfOsZXrlIKtIBws/zGnXkEzjhpjTpa8ncs2VbiphwIeGyTHEp4PsI+LC69nOYIQZgVZQ/K5KFuyKqQdUGZrujWqoV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ARI0sI/0; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ARI0sI/0"
Message-ID: <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766762908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1RnHKi78DAUuIzrc+y8eC/IuFS4HmpjI0za3IhOe38=;
	b=ARI0sI/0qfcMPGFYGSXxgXdhwTm1CaNs6lXSenrGb1voOsoONkgfjLbCw2b9QmKYkonwGD
	2jjhVk6ipmyOQzB5jPOlrw9fg62JGaUk5K0gdMP0v6r8Am8pUM9yxBSXS5nIQZ4mbEevWg
	nXVRsBbi3FLFl1Se5AGMRGMbtvJlzg0=
Date: Fri, 26 Dec 2025 23:28:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in
 smb2_error_map_table
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <1236711.1766750798@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1236711.1766750798@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi David,

We cannot use "return b->smb2_status - a->smb2_status".

For example:

	a_status = 0xC0000005
	b_status = 0x00000001

The subtraction is evaluated in an unsigned type:

	a_status - b_status = 0xC0000004 > 0

But the comparison function returns int, so the value is converted:

	(int)(a_status - b_status) < 0

Thanks,
ChenXiaoSong.

On 12/26/25 8:06 PM, David Howells wrote:
> chenxiaosong.chenxiaosong@linux.dev wrote:
> 
>> +static __always_inline int cmp_smb2_status(const void *_a, const void *_b)
>> +{
>> +	const struct status_to_posix_error *a = _a, *b = _b;
>> +
>> +	if (a->smb2_status < b->smb2_status)
>> +		return -1;
>> +	if (a->smb2_status > b->smb2_status)
>> +		return 1;
>> +	return 0;
>> +}
> 
> Actually...  It's probably sufficient to do:
> 
> 	static __always_inline
> 	int cmp_smb2_status(const void *_a, const void *_b)
> 	{
> 		const struct status_to_posix_error *a = _a, *b = _b;
> 
> 		return b->smb2_status - a->smb2_status;
> 	}
> 
> as __inline_bsearch() only cares about the zeroness or sign of the return
> value.  (Note the arguments to the subtraction might need to be flipped).
> 
> It might even better just to cast the smb status you're looking for to the key
> parameter:
> 
> 	__inline_bsearch((const void *)(long)status, ...);
> 
> and then do this in the comparison function:
> 
> 	static __always_inline
> 	int cmp_smb2_status(const void *key, const void *_b)
> 	{
> 		const struct status_to_posix_error *b = _b;
> 		int status = (long)key;
> 
> 		return b->smb2_status - status;
> 	}
> 
> as __inline_bsearch() doesn't attempt to dereference key.
> 
> David

