Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D56F4418EC
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918416; cv=none; b=hQe21M/YotmSgWEQ1+1+blZLWCYQtsRGUT3xWpTpDO12ieuF5IfODJ0NgG0C3/OZKdYIjMzu5H+eantNX+VrsEU5MJ/L5o8TDIXFB6yvZDhp+hcEnhvWONR2kkemJEsffZ7nf3MQrFtZmeWEOVzQsfIe63n1jnrZ9E7olDpWouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918416; c=relaxed/simple;
	bh=MTXAttGcmQV+gKT1VuxP3RbxteQV73dhqFSiu5vTsKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6KZnR+5DpsdcPL2hAJPn2Xa1EW3nvPf38I7dQb1TqwExluK4vIc3xIceeDcbKgGrXTj2+2+6VW/+mPGwzNMguwXLCL2FRGDIXDSKd9a1Q7LcQjz7Mzv3qONCxLqOjz2WAH+Nw3OTJDgVDXeovDaEl/UPa4CfB80kqg9xUY+SzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F6nRyobx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QiAfRtf9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F6nRyobx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiAfRtf9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768918412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o4YIZav5bzJmQLAgwNywWVFJIuBH5AeoqXsTBWn1nZk=;
	b=F6nRyobxxQ8YvcWxJKiDL0VR0iacWnJWXTrVL2kQW40sMKnf58/ifcxNcRLqEPi453oYOI
	JQ35hNkdm3pXOysiNhIejzA1m2sbSH943hhLJWymVT4Bc8fY7/BUCPNEAAX30VnCJT6nyb
	eEBsIRUWbpf/a+rFqafbcVOqHHCHOFg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-G3WWsc1cMz-VO8wvtJVO6w-1; Tue, 20 Jan 2026 09:13:31 -0500
X-MC-Unique: G3WWsc1cMz-VO8wvtJVO6w-1
X-Mimecast-MFC-AGG-ID: G3WWsc1cMz-VO8wvtJVO6w_1768918410
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42fd46385c0so3187402f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768918410; x=1769523210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o4YIZav5bzJmQLAgwNywWVFJIuBH5AeoqXsTBWn1nZk=;
        b=QiAfRtf9cyycvkVyc0yBvW6VQG51+xrGU/cDcp2l5jHvShuJ2wEnJwTkyoAM7F6ezS
         lawZ01R1YFkGLb4eYz3sxhbRXZSQtetWGBBtAWgh4jLxLSvsU6ixE1eNIiYyYP52vFj3
         SunwV6p/dKBtZkav1sIi0/QMBW+RInhLSFNQeT9H6un+0j9BKLx7SopZQqv/5rNLeLjG
         4aXNHB1a29nsZIlh7WAV6s3NjqmsV5Mp9gVxmWB9g4T5JjBsew3YKwTFnfTZZUXFg74B
         qNunI4qEASWmzr6Vc+6iAnV37p4qYQa/T5Pud0IVf7dFXqMVbMs164MGefDnWTmnWeTU
         QRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768918410; x=1769523210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4YIZav5bzJmQLAgwNywWVFJIuBH5AeoqXsTBWn1nZk=;
        b=wQjs4siLouHQKm0b2jvCu43i4huyVwZKYvZBmoiD8cUwCOL35lUynrPt1RiiIh7HG3
         hOYMD3bmXdvy7i6X6ASPOVGEan1AJI2sVe+vBiVC+cxsdIRLjV7JQ316U3kZRgY+Vv3L
         ECrtj5B8WmwnjthgEbjlaRoYHRShFHTv+HkkM0vtPq0n3LIToGS6/dw9Wk0OKVD/IaiZ
         KrXNpKKgsGbepR2V3VqpfVZurbVKEEUgU5e6eYAAtYYNjbh8XfaRXyG8+XmuSh/PQpHl
         rxaZVaorj4Y/rGqBozhfWNEwiUaFaDN86szuilr6fsjmB1BNq/CpK3Ss9bglpudtm5kB
         5R8A==
X-Forwarded-Encrypted: i=1; AJvYcCUW2IjdYl6JG+3sHl7E6ZhZbTWvZluPauB9PIN2zF2yP+DAFixetfuquElx6ZS9BI4e9C6ixFreGttd@vger.kernel.org
X-Gm-Message-State: AOJu0YzSTWt933/ZoCVWSpg4nrO9OQt3PR+jCjhUOVY3HYnZPxS99Pnv
	yH03r7DrNky5QG5d4Wu81wCiEltKMdoBsvc0WDtS3Rc2Nlg9ln+FgnOy2MA7Om801z8NDM3k67P
	IEj7XFMBUw6yo+YL1NgXFaP6F5cOM9CrpP1TXUArV3FuOPeceMYxzsRg1IhGnkrA=
X-Gm-Gg: AZuq6aIC/KiicYAgAnKpGdKkLxSgQ7hOmI7d15CpI1IjrjkvJXRlX3cOopv4U/BdXb0
	EOaLArCreQGcatkNNtNLNiiGWbVm0OxDhtaMF2k+mcGKKvPzyc9SB4lytlFBLAkHQhJkmQQE6Gy
	7YR647IlxoPv9n9o2qBcerctD8BQXFgJo+Xu4gVQMOCL5y6Y2F5qqZf6Z7krbjmpWqBOGVeqrQL
	VZBL5lVDE0tHnsh8QiArM2DXiQVYMYUtTIjWS469VNsGKiMz0QuLdUh/tanUzo5G2NfV8NdtR+b
	jDnjMSixaASxcRDkJCsO7zg3h67YanafN67dlNWs0VIXC0GzCKBvUyJvfsVSShGOE1vrBJI12+Z
	uqTVjRA/0E60g
X-Received: by 2002:a5d:5887:0:b0:432:8504:8d5b with SMTP id ffacd0b85a97d-43569bcb816mr18237033f8f.50.1768918409947;
        Tue, 20 Jan 2026 06:13:29 -0800 (PST)
X-Received: by 2002:a5d:5887:0:b0:432:8504:8d5b with SMTP id ffacd0b85a97d-43569bcb816mr18236980f8f.50.1768918409485;
        Tue, 20 Jan 2026 06:13:29 -0800 (PST)
Received: from [192.168.88.32] ([150.228.93.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43596b62700sm581337f8f.42.2026.01.20.06.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 06:13:28 -0800 (PST)
Message-ID: <71705484-46fc-469f-9357-07a076ee0e73@redhat.com>
Date: Tue, 20 Jan 2026 15:13:22 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 08/16] quic: add path management
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
References: <cover.1768489876.git.lucien.xin@gmail.com>
 <3771dfc211626a9f0c603c90113e38f325ceb456.1768489876.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <3771dfc211626a9f0c603c90113e38f325ceb456.1768489876.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 4:11 PM, Xin Long wrote:
> @@ -0,0 +1,524 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Initialization/cleanup for QUIC protocol support.
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <net/udp_tunnel.h>
> +#include <linux/quic.h>
> +
> +#include "common.h"
> +#include "family.h"
> +#include "path.h"
> +
> +static int (*quic_path_rcv)(struct sock *sk, struct sk_buff *skb, u8 err);

It's unclear why an indirect call is needed here. At least some
explanation is needed in the commit message, possibly you could call
directly a static function.

> +
> +static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
> +{
> +	memset(skb->cb, 0, sizeof(skb->cb));
> +	QUIC_SKB_CB(skb)->seqno = -1;
> +	QUIC_SKB_CB(skb)->time = quic_ktime_get_us();
> +
> +	skb_pull(skb, sizeof(struct udphdr));
> +	skb_dst_force(skb);
> +	quic_path_rcv(sk, skb, 0);
> +	return 0;

Why not:
	return quic_path_rcv(sk, skb, 0);
?

> +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk, union quic_addr *a)
> +{
> +	struct udp_tunnel_sock_cfg tuncfg = {};
> +	struct udp_port_cfg udp_conf = {};
> +	struct net *net = sock_net(sk);
> +	struct quic_uhash_head *head;
> +	struct quic_udp_sock *us;
> +	struct socket *sock;
> +
> +	us = kzalloc(sizeof(*us), GFP_KERNEL);
> +	if (!us)
> +		return NULL;
> +
> +	quic_udp_conf_init(sk, &udp_conf, a);
> +	if (udp_sock_create(net, &udp_conf, &sock)) {
> +		pr_debug("%s: failed to create udp sock\n", __func__);
> +		kfree(us);
> +		return NULL;
> +	}
> +
> +	tuncfg.encap_type = 1;
> +	tuncfg.encap_rcv = quic_udp_rcv;
> +	tuncfg.encap_err_lookup = quic_udp_err;
> +	setup_udp_tunnel_sock(net, sock, &tuncfg);
> +
> +	refcount_set(&us->refcnt, 1);
> +	us->sk = sock->sk;
> +	memcpy(&us->addr, a, sizeof(*a));
> +	us->bind_ifindex = sk->sk_bound_dev_if;
> +
> +	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
> +	hlist_add_head(&us->node, &head->head);
> +	INIT_WORK(&us->work, quic_udp_sock_put_work);
> +
> +	return us;
> +}
> +
> +static bool quic_udp_sock_get(struct quic_udp_sock *us)
> +{
> +	return refcount_inc_not_zero(&us->refcnt);
> +}
> +
> +static void quic_udp_sock_put(struct quic_udp_sock *us)
> +{
> +	if (refcount_dec_and_test(&us->refcnt))
> +		queue_work(quic_wq, &us->work);

Why using a workqueue here? AFAICS all the caller are in process
context. Is that to break a possible deadlock due to nested mutex?
Likely a comment on the refcount/locking scheme would help.

/P

