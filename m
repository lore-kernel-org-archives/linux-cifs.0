Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717DA3D413F
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 12:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770295915; cv=none; b=h4AMf9s0/DDaZCMz3AWEWcGP5LHKGAb+wScb4hetusZS1xnXrbw8gWQ5MR3qZ9Pi+4oZnJLczQ3TV1RlKcoCbAkPSFlQTC1R4eYsR2twijraTfZwbeVk3prB3Ja4zbkhplht6/WS4IkDFQjmmA0knU35v7SwQKF5qEkyXRqZL84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770295915; c=relaxed/simple;
	bh=cIIrTOVlC3bXSKi+mZruvQiu25kMcY3J4iVTy2b63e0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwfBJrWJ9c0D6O454Yy8aCRoXJ7EcLXp/Pw7EPdFHkIN9NMFl8D7F51aI5HpWS7e+jm8WdgYbIduZKbB9+kmb3WzLscLUYc5aJdziFmmESFvOTlUA2lx91bo37JYLf7wWmEXoi4yV1me4E0MVa9XjOmGoSyDdpKAKGYqXDQfO3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B1DibesS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQXTmh7A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1DibesS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQXTmh7A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770295914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KqqY7o17giM2jgPy+d2XiGnDvxNW+2fee3IUyYpT+c=;
	b=B1DibesSfMf+ZAa3f6axClUZDVcmnWHtT8sxYCQcCGJUyMfWYSgeHoKH1tD/JaTH0/wf58
	/AQPfAEaZO39H/5h6oyAgTU0X6FSlJwhaMwowXyOP9npwvbydJ/9CQWZno9ZANXPD6gmBb
	0vIgMiVbWxi99ywfOFURMyFDZJbVoXo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Yo8bYRpENXyVcFcEZni4oQ-1; Thu, 05 Feb 2026 07:51:51 -0500
X-MC-Unique: Yo8bYRpENXyVcFcEZni4oQ-1
X-Mimecast-MFC-AGG-ID: Yo8bYRpENXyVcFcEZni4oQ_1770295910
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so12995765e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 04:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770295910; x=1770900710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+KqqY7o17giM2jgPy+d2XiGnDvxNW+2fee3IUyYpT+c=;
        b=AQXTmh7A3wMg4M4qTeXzbGgbHLL3W9iS5cysrP7ufRhL7cSknHPvepB37VBnqdMe+T
         u/wxO833plyPePFB0zmt5LeUH2v6zjL+sAx3uabqx69DVeqFGPGHySZSQMHRCMNL1O5u
         yE4eEE47k+lM3lCXJacxQzl5P1FTRHIEFtIVTquGMePQr7+LjvTkAnISe4OEFsuvEak0
         dn790XcHT3Vln8M4Ub40ZslSczEzNWgW5W8bCaDvyPT3cgw6IBAk2GAPLwarsaowIbi5
         ERGx0AyZqnkp/TQnc/q8z5yfikjflLgAYIMmjyB9wGD9ZTYOXue4bqQzLn7fhnrymzbl
         kqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770295910; x=1770900710;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KqqY7o17giM2jgPy+d2XiGnDvxNW+2fee3IUyYpT+c=;
        b=G2Kp5UPNc8ovh3DArWJU17XdNhnRTRgBaiwy8xowr6PRsbgzebpF0zFvWIq+8BS2Vt
         fMHLclvOhPF0sHOvSz04B3pYN6Pqkr4EmdgWazqRa+4pK8k42lwVZLtYrFooLn4N/OYo
         qolbY2Jlgrda/G5rtxqt7Wcv+UQm4pHo07rgnKxEWIgBBbUXRnvO07cWVnQ5IDIP2Sl5
         r1RSSSI/SHzSZyAwRg33EOOo6ZCYFNnqWj733zPcjTmG3ucPPhtoLE4HyL9b+pPWqeQE
         Oka6ft1MFGVhsj1qf6+7ybIz663ibX+MKv2GXIR7eSk4HQLnMHLgUYZ/BolcpAXVW9qA
         Lssw==
X-Forwarded-Encrypted: i=1; AJvYcCWecK3SXtaV2d5EzAsy/wrA0pEl3AmsRGKgsoewyXpstVmHV4KvFOFEfVWTruwKnRD4+d8pEGkECshO@vger.kernel.org
X-Gm-Message-State: AOJu0YzWnic2chihhc8PrUtRaDwmMX4WzLVZkaS0BkHGRSJMc03OMWXD
	RcmbF6Pfy003Rp3Brwu5VF5mHlYlqkwNIOV1IbfKz4Q3z3MOwpdCDiaQr1/3+TKSTCe5fPYwJ6Q
	Od2LMBHGX9J16/DhYKZ/u2VU6U1xeAKArAsRKyRC+24djhq5bgOB3xi5TJJ0efFs=
X-Gm-Gg: AZuq6aLGaXP9lPaJBELe7rJcf3Orrba6Op1rl8TEm5X2AKgxU7hwX41BhH4rT+/Eeyv
	C4Xa3pCw1Ti+jO9ZHuEje1NRt2JRgixohNLuecXWh6aDmvajhghI0PtXpCyFFnew2K++chbX0lJ
	4jU43uzaxemKcVH3C/7gQez9ofIpHDPhyV3zvpmvwEDdSk3d0CiHJjvKQ3FzZDVo76sJGqet8k4
	5JGmWIXFy89JvySRK8a1mLENJ1omjcPwmjdKsc7a4NldAj8mWI7g9UOhbQd+iqCJ3nj2GcFj3b8
	Ood7+qjbW2lb1pdSA+JYBSW3iCuEPqObrYepQQZ+llcIWbHYTWGkytKHW9fMbiF02WzDht6FWbH
	Lr26fvRsQvcH6
X-Received: by 2002:a05:600c:3e0d:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-4830e96fb0cmr71819415e9.20.1770295910320;
        Thu, 05 Feb 2026 04:51:50 -0800 (PST)
X-Received: by 2002:a05:600c:3e0d:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-4830e96fb0cmr71818865e9.20.1770295909848;
        Thu, 05 Feb 2026 04:51:49 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830fe5614asm63353995e9.4.2026.02.05.04.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 04:51:49 -0800 (PST)
Message-ID: <1bcfe20e-0103-44a5-82b5-90cba7ba5a60@redhat.com>
Date: Thu, 5 Feb 2026 13:51:46 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [net-next,v9,03/15] quic: provide common utilities and data
 structures
To: Simon Horman <horms@kernel.org>, lucien.xin@gmail.com
Cc: steved@redhat.com, marcelo.leitner@gmail.com, aahringo@redhat.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, hare@suse.de, kuba@kernel.org,
 tom@talpey.com, linux-cifs@vger.kernel.org, daniel@haxx.se,
 quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com,
 dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com,
 pc@manguebit.com, kernel-tls-handshake@lists.linux.dev,
 illiliti@protonmail.com, xiyou.wangcong@gmail.com,
 andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com,
 matttbe@kernel.org, netdev@vger.kernel.org, smfrench@gmail.com,
 metze@samba.org, mbuhl@openbsd.org, chuck.lever@oracle.com,
 dreibh@simula.no, davem@davemloft.net, sd@queasysnail.net
References: <74174c085fb11b8a63e72a7df730b6f4a7479c5c.1770042461.git.lucien.xin@gmail.com>
 <20260205115449.2195294-1-horms@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260205115449.2195294-1-horms@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/26 12:54 PM, Simon Horman wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> 
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> ---
> quic: provide common utilities and data structures
> 
> This patch provides foundational data structures and utilities for
> the QUIC stack, including hash tables for socket lookup, connection
> ID management, and helpers for encoding/decoding transport parameters.
> 
>> diff --git a/net/quic/common.c b/net/quic/common.c
>> new file mode 100644
>> index 000000000000..94321f3f213d
>> --- /dev/null
>> +++ b/net/quic/common.c
> 
> [ ... ]
> 
>> +/* Reads a QUIC transport parameter value. */
>> +u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
>> +{
>> +	u64 valuelen;
>> +
>> +	if (!quic_get_var(pp, plen, &valuelen))
>> +		return 0;
>> +
>> +	if (*plen < valuelen)
>> +		return 0;
>> +
>> +	if (!quic_get_var(pp, plen, pdest))
>> +		return 0;
>> +
>> +	return (u8)valuelen;
>> +}
> 
> Does quic_get_param() need to verify that quic_get_var() consumed exactly
> valuelen bytes?
> 
> The function reads valuelen at the first quic_get_var() call, then decodes
> the value with the second quic_get_var(). However, quic_get_var() determines
> how many bytes to consume based on the varint prefix in the data, not from
> valuelen.
> 
> If a malformed packet has valuelen=2 but the varint encoding requires 4 bytes,
> quic_get_var() will consume 4 bytes while the function returns valuelen=2.
> This could desynchronize parsing of subsequent parameters since the caller
> expects the buffer to have advanced by valuelen bytes based on the return
> value.

Hard to tell without any caller for this function. Possibly you could
drop it? IDK if enforcing such check would be correct/safe from an
interoperability PoV.

>> diff --git a/net/quic/common.h b/net/quic/common.h
>> new file mode 100644
>> index 000000000000..bfec0aaf2907
>> --- /dev/null
>> +++ b/net/quic/common.h
> 
> [ ... ]
> 
>> +#define QUIC_CONN_ID_MAX_LEN	20
> 
> [ ... ]
> 
>> +struct quic_conn_id {
>> +	u8 data[QUIC_CONN_ID_MAX_LEN];
>> +	u8 len;
>> +};
>> +
>> +static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data, u32 len)
>> +{
>> +	memcpy(conn_id->data, data, len);
>> +	conn_id->len = (u8)len;
>> +}
> 
> Should quic_conn_id_update() validate that len does not exceed
> QUIC_CONN_ID_MAX_LEN before the memcpy?
> 
> The destination buffer conn_id->data is a 20-byte array, but the len
> parameter is u32 with no bounds check. If a caller passes len > 20, the
> memcpy would overflow the buffer.

It looks like the check responsibility is on the callers. I guess it
would make things more robust and simpler move the check here.

/P

