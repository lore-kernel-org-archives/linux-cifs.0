Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CF2857F9
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 21:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758229362; cv=none; b=UAG6sNM4Q559Lg2PyarQWsqCad9jSDuao8gbM675j7XLjTU3vRAcfGkwvf7KkuyydKyryDqw6VovnVPY7rAR9VDkpmwxOlNDNs02lnijlACFuEeasWWiBQEH7xcagy1xoQLOdPo+9mTDPRlUB0Hriza8bDDvZctQql9k6jjIgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758229362; c=relaxed/simple;
	bh=xyaz1RD4ScrVbBvNKum/hYRu3QWgmfaUcOxWmbnqDdc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=add3It1RaGllnOMNM5WQ9nKh/DiI69Q6/AMJGO0uX3yWq7dRz7pq0f0uhx4rE+ZullUuoOy5nz3K3oiqBcsfvykQd+Lr9rUyZNwq8tUCbqnyoKOrEio+6q6MhinIybpKXqkEi82lQNsn2tEoRtpnnjEDdYMu2IVW08kxSYSYA40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fi6fmHHt; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fi6fmHHt"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3eebc513678so147950f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 14:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758229359; x=1758834159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=no721FqqCLV3JdyJlNSekmacHbg841rm6Jv9LJqT9hY=;
        b=fi6fmHHtyrRwTxqBBJZGCbRLtIrT7fNx6CCCruJKkGZRs729MyBn7NOhAmJ4gTS7G5
         VboTVeSgBWOguk2sfsbAAASxsmEh/JX4r7uBVwvOuAz989km6dvzQleeH/Drd26u7JpX
         7mWv3WqOTCpY6LJzKGIykf/vCNUSgzTJ2KbDwekb0eVhOxT+fMzgOf9zZHkAuQAeO7m7
         mR1u4ypjKmBoEa3mNXU2tiq4J7UnQl6st8YfQjW63slGHkeUNXbtAFGOqyAh8jhRqEFF
         qQdP9FogJKGCPCHIgxV035hTEjOEJjkcsLb7hsy/Ac6U6aH4gEF3oBE/E/uFQgUMpy0N
         d0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758229359; x=1758834159;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=no721FqqCLV3JdyJlNSekmacHbg841rm6Jv9LJqT9hY=;
        b=wJ+OqQAraTYhabNR8UpPq6gnlBwhwriLBr2NN7wIjVdPp/tIRmWMbyBk1WVs2sqQn3
         lhO0E+0ZCiji7BqDy02xd2ol5UdmE6vzN6oiUw7xzBn3QAeHM70CBY+shV7N1RSfD9ja
         d6kdugmIXXNQFx0d7XzU/FaBOAaph5t9fYEbAGjwgAVKHjUzk0jYzNpd4E2tvtq/KGL0
         dDCISgL2KRd+1ejneXGIr/ENa0TsbKkr6U4J7HG2eq7KtN7FZkBy5CnvWv4hdKdDdurH
         Klp/BTGgNwjfmGfLXbal6zxExctG/zWX9JeMgz+HfwXrty9zIJ9k/3EpWkvrHRB1TRe+
         Y8Ww==
X-Gm-Message-State: AOJu0YwL4swDwfAlJMoEdV4rNBvxJXx68IfB4BEu4eHz+kWapt4Ge9fL
	CRtC/Tzb3sCa17cQ7ckFynvis3tZ4loAC8xeAvJKPKFrb6VPFvCagbLfEl0E9tsGzBUgqEZvS2z
	og85n
X-Gm-Gg: ASbGncsetgi0shFNUoUmo6eryLniewQbl5CLYotXL9diM4L7feHLaOb3IhZGvkkHTBd
	rlatgydwmN4BThTLApVSX2ShhMJGt/tOIlioQ0WopAmZfulSbFIpQ2lJETjOivOs6YNyh71Kmlz
	oVIf4pc/MUDaZx6SlBxS7y91dxrDIOeemmGIk1ir0aZncCLFPLRJ59HKtx5GZ6rw+BmTA8e8PMQ
	qntluDJvTK7KLMrK8JytJdEtvktSfOuhTswn1BtcvcmO33Zh+BuDimth4fPdxCkG1EXEgOd5W8b
	vzmXFfEweTo5WdX/eSHmaDhexQvD09X1GYhz3eQIylnuVxUP4v9A1LTIisl72+YDZhQ3xA1Sedk
	mEwDDpXJMET7uD37jP1URUZRNGW+YndEq++VKX8flF/3t7jrBsOfLuixuInjK
X-Google-Smtp-Source: AGHT+IEcR5l1E07h/v8gGeDvITcEhBge4U2i7Tsde7nOoe/Ddr6YcVVnLHbshCfbIQA3LULr9pDlUQ==
X-Received: by 2002:a05:6000:290a:b0:3e7:63dc:1ff6 with SMTP id ffacd0b85a97d-3ee7c5529c9mr363080f8f.8.1758229358729;
        Thu, 18 Sep 2025 14:02:38 -0700 (PDT)
Received: from ?IPV6:2804:14c:658f:8614::1cfe? ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980318743sm33943925ad.118.2025.09.18.14.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 14:01:54 -0700 (PDT)
Message-ID: <0f832353-d0b0-4677-b4f0-5b5d9d6dad73@suse.com>
Date: Thu, 18 Sep 2025 17:59:46 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] smb: client: batch SRV_COPYCHUNK entries to cut
 roundtrips
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-cifs@vger.kernel.org
References: <aMvUdFU-ciu7Rgc6@stanley.mountain>
 <d06bcf7d-81bb-495c-92e4-582c44df9de8@suse.com>
Content-Language: en-US
In-Reply-To: <d06bcf7d-81bb-495c-92e4-582c44df9de8@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/25 5:19 PM, Henrique Carvalho wrote:
> Hi Dan,
> 
> Thanks for the report.
> 
> On 9/18/25 6:44 AM, Dan Carpenter wrote:
>> Hello Henrique Carvalho,
>>
>> Commit 4e3acdf94c89 ("smb: client: batch SRV_COPYCHUNK entries to cut
>> roundtrips") from Sep 16, 2025 (linux-next), leads to the following
>> Smatch static checker warning:
>>
>> 	fs/smb/client/smb2ops.c:1937 smb2_copychunk_range()
>> 	error: uninitialized symbol 'ret_data_len'.
>>
>> --> 1937                 if (ret_data_len != sizeof(struct copychunk_ioctl_rsp)) {
>>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Using unintialized variables doesn't work because runtime checkers like
>> UBSan will complain as well as static checkers.
> 
> I will update the patch to initialize ret_data_len.
> 
>> But the other issue is that this code treats -EINVAL as having a special
>> meaning.  -EINVAL is the most common error code.  All the places which
>> treat -EINVAL as having a special meaning end up buggy in the end.  Mostly
>> they start out buggy, but even the ones which aren't buggy from the start
>> end up buggy over time.
> 
> -EINVAL is mapped from the SMB2 server returned error
> STATUS_INVALID_PARAMETER, so I don't know if there is anything that can
> be done here.
> 
> After your email, I considered returning -EOPNOTSUPP instead to trigger
> kernel-side copy fallback, but returning -EINVAL also seems to have the
> practical advantage of having a successful copy, but with fewer network
> roundtrips (apparently due to userspace fallback, but I haven't digged
> too much into it).

Correction: -EOPNOTSUPP seems to result in fewer network roundtrips for
big files. If anyone thinks this is worth digging more into, please let
me know.

But returning either errno will *not* result in an error to userpace in
case of cp.

> 
> If there's consensus that changing this error mapping would improve the
> overall robustness of the code path, I'm open to that approach.
> 

-- 
Henrique
SUSE Labs
