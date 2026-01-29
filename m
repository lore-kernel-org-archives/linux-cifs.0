Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0582E33DEF5
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769703994; cv=none; b=l1ffZbrB/rDa5EVB1bc9NNFcjaK+gWeVcx8p+a3UZ53kDSidNZ0TysOGmMfAqEMz4QHtd47pm8NAq5LfwX6EZpENkvROIv5SqVksotTwFoErKL6jKzdW5kUb8KWzlkYxNmKXT+J1QmB1H44S4Y4aoIeox+e2Ia66RnXYDw5fYZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769703994; c=relaxed/simple;
	bh=l86OLD8ANrV0mU8pNoPBa0/YPrKD248BWDWu+9LLv88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmxNv6MsXvlAf7XzNtjybbAr6KDmGAYzWHcdzvyJN2SmkhNMfU4WfJslJ3r1TQHSTNVf80xxZoFzxmQZCideA+iXkE6ILjooqr+7K65mUK/jc9ZrYbihtJpxJ+hxWwLJC2ei6jYrgs+izghUgaK7U0CQRUZvuVP467xhnViBtRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L97rwyNU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lwszMLZN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L97rwyNU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lwszMLZN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769703992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smuqHJFpRj+j2xYajnlqs/VsDNhOWtBkZ67qclJoWoE=;
	b=L97rwyNUmhXr6951Rn0dMEipSXGsv0y8/Sdvh3YtnKEp+8eo/03Oap1s/3O9AAdEMyAbrT
	7MlNh4/PgIPK83iXXlAC82gfy6uk1eNftRgewOxbBwOmgfaLrSqCdNn/eQZU1HHp8IjqtN
	/Wwbfe21h2G9v0BOi6tNTrTv5+qA8oE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-8jprCNEVOreCiRj4r9tmlA-1; Thu, 29 Jan 2026 11:26:30 -0500
X-MC-Unique: 8jprCNEVOreCiRj4r9tmlA-1
X-Mimecast-MFC-AGG-ID: 8jprCNEVOreCiRj4r9tmlA_1769703989
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435ab907109so611649f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 08:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769703989; x=1770308789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smuqHJFpRj+j2xYajnlqs/VsDNhOWtBkZ67qclJoWoE=;
        b=lwszMLZNs0uY6Ze1d9sLX4JgzRX93miaHkilgOrGHmpDJ61G0hy5JX9H1ama2Mwhb2
         j1hUFI9rK6SBC//wTkmy0qnCEuzRCGJn8+0mBXuslwiOX8o5c4YJSrKSGre/9nEg4qXT
         vnai37+CtSPf4Yv+h0zApOJlw6WCdrVYPxsOPJkJkz7ypKg7KbzA9fmztGqh+Kizr75S
         yWVUjKbP0KQOBDeHxDlSRWlBA4Age5kzkRMeCzgULuUlk76Y25PH2Dh7Ow0wtRVvp2Yr
         ZIU8Tk2YFiOzA59VE4S81ZghkIKC1WSue8bWUj+i24ge0anGpYrs+QI+gYNSBxO9UdAC
         WuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769703989; x=1770308789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smuqHJFpRj+j2xYajnlqs/VsDNhOWtBkZ67qclJoWoE=;
        b=gawuH/gQwS6xMrZHyqwXNbWtWMpahcfL5a8oQSn64SmVrTFRo3GbJQ4VD+XPLLfMz5
         vd5HCUjwYrHzkaUmuUzO4mi35yaU31ISOyMN58fhKgOp5dix1SsoSv0BiRAIC1LxLxPS
         gYBEWsDZi0mSR7o1enGuojCTdrgYONiV0wB3gatHrwlC3AXhp/ghV5wSb7ANQFSD1jKA
         xWuaXenufXjtfPaeRsR2XjEpx1SVqswR2wfxpuUHAJ1fkMsOspylJZJLA/boz6bpebIy
         FQJNLvP0Oka1+wIvD9jB4pmoJx5ZbtMZGupdNRkvKzEAIsvTGy5k5GCmcAwhaLdhTJ4k
         fPfA==
X-Forwarded-Encrypted: i=1; AJvYcCUgh8Ly9VEaEOCQo+i74510q/5yZBev7IwHr7JNkmYDJ8q/3heCwy9i54cMhlxsHTJu3IS5IXYk695m@vger.kernel.org
X-Gm-Message-State: AOJu0YxIYz4LM5twOhvnyb01GXFnjWMBYZXMQay+8/HCwp5hbYXNeXfd
	E2fn47v5Pf7AMdvnDsEt3Z4pOEshqRPU9FfvYCG2TrKhBZhdwpvBzvbM/YqGBM9VAqP978l1sM7
	zQ07IcObq/RgCY/pN4T3L2NeX+r0w50l+WgPhN6ohYt0/O9IsH5hut9g9Q8OdSjo=
X-Gm-Gg: AZuq6aJj3TJbuZoyEmdecikHK7cgAQzvt5ameuOLn4al1Uy90VTFQ6dEHLZO1947J3k
	BtGQQxS/GniWkop67+YnOqYyV07shiG444MT+PVysthFDyv9YeXHmOL/r4iocCtutKZNRIrW/pE
	1VwOa+wLZOw1m2TEtZ5aWqMRJOW0ViDIpLVkKBA2KYY/b5HBNX5SQZXhlBUeI8BntR7wcvPkWLH
	HuSrRx8x0cPDDEKCBEwiTxG++iaLfKsz65fzJxZ+sYnQcjnCKcGRhvuceYS8AGqZywtsNa5cJMt
	itUk0kCLmeYbkU6Jq3M8SWNJAQh/0JJE9bl586hk1kOQwl75kgW/94CPeVVQGjVq2Ec6GX1YWMv
	egxf/a+bthlV7
X-Received: by 2002:a05:6000:18a7:b0:430:fdc8:8be3 with SMTP id ffacd0b85a97d-435f3aafd25mr246910f8f.29.1769703988778;
        Thu, 29 Jan 2026 08:26:28 -0800 (PST)
X-Received: by 2002:a05:6000:18a7:b0:430:fdc8:8be3 with SMTP id ffacd0b85a97d-435f3aafd25mr246869f8f.29.1769703988173;
        Thu, 29 Jan 2026 08:26:28 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee562sm15878577f8f.18.2026.01.29.08.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 08:26:27 -0800 (PST)
Message-ID: <9c17e0f5-0a07-4800-9356-0ee9445e3922@redhat.com>
Date: Thu, 29 Jan 2026 17:26:25 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 03/15] quic: provide common utilities and data
 structures
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1769439073.git.lucien.xin@gmail.com>
 <1cbfbd45fda48c82f629b000fc102ee011515e12.1769439073.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <1cbfbd45fda48c82f629b000fc102ee011515e12.1769439073.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 3:51 PM, Xin Long wrote:
> +struct quic_skb_cb {
> +	/* Callback and temporary context when encryption/decryption completes in async mode */
> +	void (*crypto_done)(struct sk_buff *skb, int err);
> +	void *crypto_ctx;
> +	union {
> +		struct sk_buff *last;	/* Last packet in bundle on TX */
> +		u64 time;		/* Arrival timestamp in UDP tunnel on RX */
> +	};
> +	s64 number;		/* Parsed packet number, or the largest previously seen */
> +	u32 seqno;		/* Dest connection ID number on RX */
> +	u16 errcode;		/* Error code if encryption/decryption fails */
> +	u16 length;		/* Payload length + packet number length */
> +
> +	u16 number_offset;	/* Offset of packet number field */
> +	u8 number_len;		/* Length of the packet number field */
> +	u8 level;		/* Encryption level: Initial, Handshake, App, or Early */
> +
> +	u8 key_update:1;	/* Key update triggered by this packet */
> +	u8 key_phase:1;		/* Key phase used (0 or 1) */
> +	u8 backlog:1;		/* Enqueued into backlog list */
> +	u8 resume:1;		/* Crypto already processed (encrypted or decrypted) */
> +	u8 path:1;		/* Packet arrived from a new or migrating path */
> +	u8 ecn:2;		/* ECN marking used on TX */
> +};
> +
> +#define QUIC_SKB_CB(skb)	((struct quic_skb_cb *)&((skb)->cb[0]))

Please add a build time check on quic_skb_cb size.

Thanks,

Paolo

