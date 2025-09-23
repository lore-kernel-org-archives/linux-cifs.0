Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6810C2798FE
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758626501; cv=none; b=W/fQ2h5shz0EdvI2FWDnyUNYNS6FNiqC420++/uReXsX2Gx51k5olQybAoRvAeuWX93a8nRyl0451EPVuGi8Uo9ue0mj/2TK2o2gbTcNn0Lc+t1SNVzK8zB9ZGuMNXQySEaK1nqydu+v0cBd5bBkirgnXuSgYj3jqyp01lo5A8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758626501; c=relaxed/simple;
	bh=t+QZDhTto1uLLFwLELmutlOR0nLBR5O3CYGMg93yR9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QEebCTkgJ8uxPoFXAUclOi3BG2h40BDMF9oYEZ+byJGtJk6yTb/pNcMq8+faweRy/fOFufA4BYGFgfLS287gtXDQ2V3C0ecf/zG+AdwMmIUp5wsmvSFMrR9k4dC/V/tVOD8dXVxXLXjauviKsNtOI1wFYoDKjQekHwvU5y8s7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XHahVRyX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XHahVRyX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758626499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HRiwAmUD+4/mMUYIIKXqkLb49gsCM2cGlAg51GqgPDQ=;
	b=XHahVRyXxa1ur/96lz9oUCwMiWbLZiP77AJ3Ic1BsOiULYjIRvQfwJDNqYyJAmTM2WmuFa
	ZtF0vJBe+T0u5Tr+A7jNjBgJ7qLoHdk6D7JGhMUxnx9qLAm/9RF7SYd+FCM85qZSv4NUV/
	np/xVQCdVsWhW/pjFYQfojKz1PB3WJE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-sXZplndjMhalbLNGx8yLvA-1; Tue, 23 Sep 2025 07:21:38 -0400
X-MC-Unique: sXZplndjMhalbLNGx8yLvA-1
X-Mimecast-MFC-AGG-ID: sXZplndjMhalbLNGx8yLvA_1758626497
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e1b05b42fso10272165e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 04:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758626497; x=1759231297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HRiwAmUD+4/mMUYIIKXqkLb49gsCM2cGlAg51GqgPDQ=;
        b=rASf9NpRpt31QCZC9zA7X5MEsYl/7jjaXM4HYWUzq5sMIqXv0rnxqGOqY/FVzvqEqs
         pIN58v/KxIf1fK4N9eYBYOgXaQwUfDP6AgjEI+lZLPGQoPoa5t+dHTj9mwuUmM/5qEpu
         0yTCEXmik9A0kKocKRAdqkHjGux2pWRg8c1smRqzTaTeILJkAqCqse5/w0thKUvbbea+
         A2Dn9ZkXXy1ilNPfDm820I5645q4sWbp4SJRdVsVt1rJ6+CPPWt4g8RNNgzgkGAHC6LC
         9QU9ZAtUFbM7TlA1SklbpKCZ4Ct5MvgUb54XgbIAaAort3/GFusnyql72esCNkw6Hma9
         F+OA==
X-Forwarded-Encrypted: i=1; AJvYcCXRKI6NBNANrFXb9ApPnA+tGRCVS+m3vDNip/jR8xWoB2FdvFkft7irmLuOmgB9xrnnFAhQG44eT1eF@vger.kernel.org
X-Gm-Message-State: AOJu0YzJhBgogx3UsZ53pmnP9ff88oMmZ3Vtm7CR9ezoBx2IXF1Ro3dP
	wA1zrtifhpLPb5PUFHM1VdJ7UzJGZ1LbOoz75avHcj19TbhMwgSpfHbmRZMa2lwrNiBfB8Hz7UW
	0BOSuaKwlQSf/KZILQEr9FAqanHe2Gta5vWzOpxN5ZOuf9ZD47oDKJZnlIrRh7js=
X-Gm-Gg: ASbGnctFfagdO1xEgQijYp56aHT5PWsaSzg4NOdG9CRsDXczhRJLSAjyKj9dCtaXdEe
	a4p+apOK3oOS1Iv15cHpTsnafHcO3TyTNH5Nzzos/gZ8y0SqYgUM2u9G+C3HJxJ+Wo2XgPe40AP
	TsavMMGqJ+LQQ7aXnWvre3dzpEAtA/p/VkPFXozkMdul0Bafp+7nYaV9dkrhqpz6w5wlwXWXZv3
	X3/095+MJ3Et2HunER8KD+SehullYCLjy62L1rI4DrDC8IUhOcIq11AQT5Z4faVQKA4Sqyvxo82
	MKYrfFaNR9poJ7nMe1NPfI7+rlhdZSkoYCEGbujb0QVowS8FvU3IodibGUeqetn82gUFL9ztyPr
	dlu1DEquV4Ma2
X-Received: by 2002:a05:600c:468a:b0:45b:5f3d:aa3d with SMTP id 5b1f17b1804b1-46e1dad1bc0mr17677885e9.21.1758626496739;
        Tue, 23 Sep 2025 04:21:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVl5LwJCSoJe18fqUI2zrrluC6snkXwQxOKaMoTUidlB/HP/Iah2lrSfVasHGUh0FtzoWWMQ==
X-Received: by 2002:a05:600c:468a:b0:45b:5f3d:aa3d with SMTP id 5b1f17b1804b1-46e1dad1bc0mr17677575e9.21.1758626496239;
        Tue, 23 Sep 2025 04:21:36 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e1dab52d7sm13706445e9.2.2025.09.23.04.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 04:21:35 -0700 (PDT)
Message-ID: <871ed254-c3d8-49aa-9aac-eeb72e82f55d@redhat.com>
Date: Tue, 23 Sep 2025 13:21:33 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 03/15] quic: provide common utilities and data
 structures
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 12:34 AM, Xin Long wrote:
> This patch provides foundational data structures and utilities used
> throughout the QUIC stack.
> 
> It introduces packet header types, connection ID support, and address
> handling. Hash tables are added to manage socket lookup and connection
> ID mapping.
> 
> A flexible binary data type is provided, along with helpers for parsing,
> matching, and memory management. Helpers for encoding and decoding
> transport parameters and frames are also included.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v3:
>   - Rework hashtables: split into two types and size them based on
>     totalram_pages(), similar to SCTP (reported by Paolo).
>   - struct quic_shash_table: use rwlock instead of spinlock.

Why? rwlock usage should be avoided in networking (as it's unfair, see
the many refactors replacing rwlock with rcu/plain spinlock)

[...]
> +
> +static int quic_uhash_table_init(struct quic_uhash_table *ht, u32 max_size, int order)
> +{
> +	int i, max_order, size;
> +
> +	/* Same sizing logic as in quic_shash_table_init(). */
> +	max_order = get_order(max_size * sizeof(struct quic_uhash_head));
> +	order = min(order, max_order);
> +	do {
> +		ht->hash = (struct quic_uhash_head *)
> +			__get_free_pages(GFP_KERNEL | __GFP_NOWARN, order);
> +	} while (!ht->hash && --order > 0);

You can avoid a little complexity, and see more consistent behaviour,
using plain vmalloc() or alloc_large_system_hash() with no fallback.


> +/* rfc9000#section-a.3: DecodePacketNumber()
> + *
> + * Reconstructs the full packet number from a truncated one.
> + */
> +s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n)
> +{
> +	s64 expected = max_pkt_num + 1;
> +	s64 win = BIT_ULL(n * 8);
> +	s64 hwin = win / 2;
> +	s64 mask = win - 1;
> +	s64 cand;
> +
> +	cand = (expected & ~mask) | pkt_num;
> +	if (cand <= expected - hwin && cand < (1ULL << 62) - win)
> +		return cand + win;
> +	if (cand > expected + hwin && cand >= win)
> +		return cand - win;
> +	return cand;

The above is a bit obscure to me; replacing magic nubers (62) with macro
could help. Some more comments also would do.

/P

