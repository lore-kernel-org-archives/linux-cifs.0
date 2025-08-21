Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F08D2367AE
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755785935; cv=none; b=gGwZfmh5qBU2LLGKuV+RGkdDK10I2Ptk2z6GXpXVaRiOamwyVAzyyKFtuMxUgh6ewhOQMlqGuhoUSvVjF7gGO7tujn3LcAumAu4fD5A+sXqf/eBaAxs6ILzOJ2+qFrTBEPn+R7fuf4epnNZMRub/g8NE8Wa0puyTzA4icc+Ijcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755785935; c=relaxed/simple;
	bh=6fYOKYDWtJXk/nb3SNwoXg8QDC7pMUsBU5vYe0/EFT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u6rU4HetNMZ5qEbWFZ7c1rH5TplfcaRYmFDA0j4vqFNmnr+RtFMkvL39Fl5gZIBRys0FuXxUvaXmTmsZ9wg59bI1sAdLW1JHTO/0NCay3AyRaiXVcHcJbDfWNvp6JL0s4nh/3CLaSC3SfDhQwD9KyXA/5QvlYmlz6oTcri+AbWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Stx6P6L4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Stx6P6L4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755785933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2W2WJn9o2ImqIVXfkc9IKgb9T6LWDj6xaBh01W7LZY=;
	b=Stx6P6L47llTHL2eB1Ln/9GTfyg/8Wq3gvrwXg4k9E/sP0Bsub+k+2543U+RORGcEusQwr
	HO5XK+Y0Ke8jGFhE2hZKDLSq9GfCNFG+X9KI+XPlAHfBga7pLoNumxp+E/K6WBg0lCVjc7
	E4PdTtjNFnVtLrA9jcKKcJluSbxJCDM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-s30yfSJfOLGC1tcChyE2fA-1; Thu, 21 Aug 2025 10:18:46 -0400
X-MC-Unique: s30yfSJfOLGC1tcChyE2fA-1
X-Mimecast-MFC-AGG-ID: s30yfSJfOLGC1tcChyE2fA_1755785926
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0060bfso6692105e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 07:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755785926; x=1756390726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2W2WJn9o2ImqIVXfkc9IKgb9T6LWDj6xaBh01W7LZY=;
        b=nAB3OaKvPRTqI31qzVpWQNYC+nCKdHpeII3e00BqT1Qb24xnTe2fqARSTP43lMsyqM
         /2p5TDHwEPJlr5e1lvkEPy+YLNHAuXKady4Q4PFembqHLR9w4/GWVeZarIL/owM7nzVH
         UU3FemetORpc/y6yF12rOKqgIOfv9GPWfsaT3qfGV6JanhLdZHe5f+WDe2F85EuvQWSQ
         XmaOe32YZKeUMgg/qlskvhPEJJt8uXFsWQxgKgnWbMIfcwhTCSHiLvKViD4VPMcYs8p7
         j4CeActWWnJFB1s63sAf/kNJ0xyc4Qzf9bAkqGM0BGB4AU68FoqsDbWojSEL0zeJuM0+
         +kVw==
X-Forwarded-Encrypted: i=1; AJvYcCUSHC1asfYppAoBO2F1QKQ/yy3XZ1VxMvTodzAylwuYVm8IVGuTr82RkI7L1Zhrw73vkPR/dwR/5kds@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3wjshZC2w4gLgpICbZ2BVJ/SJ7EYaOweqcn21MjGJC6x4rhXq
	0udfKSouMBtl4EH8m+zLxOR1PgLoABKlLGT6Q578S2wBo6NBVmIOQkxmuJCJmwEmN+esbFfJKs2
	RKz1DlwRMZyQEgy9bUZcrVMxNf9AAAE9SWogN9yGsWZXMHPJh1RwVlw+89ply134=
X-Gm-Gg: ASbGnct3UV2G+3gkesR2AMDZCCdLJo/+lvJzJ1M+ZWEzCrm/AszSdvSOQXEKyiMWiLp
	uTxUCv696BJ7Nk7vWT4WymQJIst4mIngJW9AmSeplkKolVkPsGXUaWTJX69hTwIgP2Xbq0Dzxi7
	GkNWKUB6vDNH/JKGzWIY8IXyf/NAQFWQFK+Gfj5vAKYtkUeuNjPXnqHVtNEJPBE8RS3B3KQ8m40
	Bo0P2TxUgrnKrmp01noiC4EvItftbLQ5ONyfUEq7Bcc4geuKuF0RUyXAtwLKBYsE/ml2JFxqWoE
	EosU/HpHWY2xNKIPdgv9i3LlHr9OBa7/vutjdOhxXxJZxo4eEj0jfDwq+7P3vf+CGhmE3x+ZrsI
	NkA7pKhv5QyU=
X-Received: by 2002:a05:600c:3147:b0:458:b4a6:19e9 with SMTP id 5b1f17b1804b1-45b4d7ea0e6mr21934655e9.13.1755785925631;
        Thu, 21 Aug 2025 07:18:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLwKJXKyCXn0Ep8Pg/fTs01OWaVxGdAUn91+tk/jR7dvj0U5zOA0d/juE648QGc7ZwVXZL8Q==
X-Received: by 2002:a05:600c:3147:b0:458:b4a6:19e9 with SMTP id 5b1f17b1804b1-45b4d7ea0e6mr21934385e9.13.1755785925123;
        Thu, 21 Aug 2025 07:18:45 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077788b39sm11839502f8f.47.2025.08.21.07.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 07:18:44 -0700 (PDT)
Message-ID: <a45ba272-685f-41dd-8582-6bbc5bc086bb@redhat.com>
Date: Thu, 21 Aug 2025 16:18:42 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 08/15] quic: add path management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
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
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
 <507c85525538f0dc64e536f7ccdd7862b542a227.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <507c85525538f0dc64e536f7ccdd7862b542a227.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 4:04 PM, Xin Long wrote:
> +/* Lookup a quic_udp_sock in the global hash table. If not found, creates and returns a new one
> + * associated with the given kernel socket.
> + */
> +static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk, union quic_addr *a, u16 port)
> +{
> +	struct net *net = sock_net(sk);
> +	struct quic_hash_head *head;
> +	struct quic_udp_sock *us;
> +
> +	head = quic_udp_sock_head(net, port);
> +	hlist_for_each_entry(us, &head->head, node) {
> +		if (net != sock_net(us->sk))
> +			continue;
> +		if (a) {
> +			if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
> +			    (!us->bind_ifindex || !sk->sk_bound_dev_if ||
> +			     us->bind_ifindex == sk->sk_bound_dev_if))
> +				return us;
> +			continue;
> +		}
> +		if (ntohs(us->addr.v4.sin_port) == port)
> +			return us;
> +	}
> +	return NULL;
> +}

The function description does not match the actual function implementation.

> +
> +/* Binds a QUIC path to a local port and sets up a UDP socket. */
> +int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
> +{
> +	union quic_addr *a = quic_path_saddr(paths, path);
> +	int rover, low, high, remaining;
> +	struct net *net = sock_net(sk);
> +	struct quic_hash_head *head;
> +	struct quic_udp_sock *us;
> +	u16 port;
> +
> +	port = ntohs(a->v4.sin_port);
> +	if (port) {
> +		head = quic_udp_sock_head(net, port);
> +		mutex_lock(&head->m_lock);
> +		us = quic_udp_sock_lookup(sk, a, port);
> +		if (!quic_udp_sock_get(us)) {
> +			us = quic_udp_sock_create(sk, a);
> +			if (!us) {
> +				mutex_unlock(&head->m_lock);
> +				return -EINVAL;
> +			}
> +		}
> +		mutex_unlock(&head->m_lock);
> +
> +		quic_udp_sock_put(paths->path[path].udp_sk);
> +		paths->path[path].udp_sk = us;
> +		return 0;
> +	}
> +
> +	inet_get_local_port_range(net, &low, &high);

you could/should use inet_sk_get_local_port_range().

/P

