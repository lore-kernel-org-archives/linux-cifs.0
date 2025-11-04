Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E295032E752
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762267501; cv=none; b=rjnoYnaMbGw499xBwrVPSZ9nX66j9QCYZopQ8rNCp+IsP3NGQz++WYTvXOSYmQFHqH0QdS36yDSQiJ5QUcIlNiT9llUWfu8ua0TEoBSRyw71fl2F+tDGV60rTSgEFRSdwYFrDxDyWfek0JtqU7MxE+K26wBpzqo1r/rrSMNthb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762267501; c=relaxed/simple;
	bh=/gUZ7NXNKW376ebhwPQM7kkgplLwpgHBzzf3jEaYi9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aHQdkgdrrUHeJM+97rRMhsUnDpySecd6ttdy8Hc6Om4w0iyNJrfJId3rk+qMB1KI16fvjB7xLWDvvPR043AACbKZdn6tqckAWBT06JL5cefW+OAtqYoaE/TTttHF3IU/Ma2f79uQG/XZctuj1FZk5prQy2GQCOLCd4fLRx31Sco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ATkuPUkv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aR4TwQrO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATkuPUkv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aR4TwQrO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762267497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFRG9IF03+gMGO6BdiROzZyf1knfO0IKnAs2JmyrLOs=;
	b=ATkuPUkv65i9AzAmcDuK7a07SicNprWETStTxLxThxVoUIUftQ6o1QZ7jXiXfiagCATEFC
	emPI28HCgxTjmIHAHOaXobOtrV+BQ0G5mz+8fQBnMxDHmYfNwDKzMgNuGF977g9PVMiSew
	PsI9tGG3rUBFAmYDqW9GdkGII/kvRqk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-LcC-ZuQMOhWFIaEYYxY5eg-1; Tue, 04 Nov 2025 09:44:56 -0500
X-MC-Unique: LcC-ZuQMOhWFIaEYYxY5eg-1
X-Mimecast-MFC-AGG-ID: LcC-ZuQMOhWFIaEYYxY5eg_1762267496
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso48925815e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 06:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762267495; x=1762872295; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFRG9IF03+gMGO6BdiROzZyf1knfO0IKnAs2JmyrLOs=;
        b=aR4TwQrOIf17tHMPx5NT1wekAhiACtiFgfiVbMN2+9wqU3Dy2Gp5tDcohmlA+5gBDc
         CZOpL8yoiQqoP6h4qguLrVuCuK1FCi79gciXW8FThVGFXkimXVoKLbquUlHhmtFj1R26
         YcoCrCGvcGE3JdOCqYgpkyhd/ZuNMEkCVFToIDka2pZX7yw6WMJzdninEBikd5K33sGA
         t8iq6lAiJ1dFcs0gZ8bm/OCZ1WEhxAmNL70hDZri0TwWkbNdp6uyo8KI+6gcz6im6f8w
         SyADX0GFGlTmK40iJbPFCcoug+jzz3Fqh51CUzXeo+WJwtNJbRLhV/xEJJVjyE8Vzpk5
         kNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762267495; x=1762872295;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SFRG9IF03+gMGO6BdiROzZyf1knfO0IKnAs2JmyrLOs=;
        b=PnY6UzVFID5zQed11boXvhovFoAibpoaq3yNOYEpEVMrS9j1MFoFK9mPKVy605QIJi
         sa5rZo+jxhjIT9o+KT1odaz7utGN/avxRCgqQoXwlz80j0vEtQt9cji01C5b8H0oPqoq
         k566WWdpIJmXNd1isW58ssB2a4vP18QU3PEQS9/GZl2tJGkIgJPqQ7mSJm6b5fH4haaK
         zy08zHwdjsJuI2xoWOrySCwKWT5dbi4/Hi/Vjt6oTM71QQKJlYwTPixiOaeNuCZh1Pg+
         82itytYBlqYyOtAtf07R5ovvvwdl1XBZumT2cKOGxrVtUTxsfZrUiPN6LWz0e8hf04MP
         gQVw==
X-Forwarded-Encrypted: i=1; AJvYcCUDCSHe99Xp0GnQIoif/rKb8ACj4RAW8bPNds5Xk2WB1OKEIeKBY6BcoMuQvvzhrTShNJJMIGddMOeE@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqpec39WKxGLlLuec9AOQ/Mt/idncwPmR17aR3wigTqtcfcX+X
	FeLyvqMWr57YsrqVOakKlQlzeNPWYpXKkU3PIGSD1eU7zmVxBPYbF4uhXfgtSOrOTrdeuD7a9pd
	KeNsVRlzVc9x+wBgzWmKyGUAz/IFGyMtSRoLbPwfliCK/IMT2ECQ5+ekoKjJp48I=
X-Gm-Gg: ASbGncvH3LcdMchwvFjQZRpGKSLe0ck/QAmN3HfX+9FfwfFtFYPDWbX9FNE1iOwl1d8
	yqcEHTEiuQOkwILKQRjZppopwu5IzuEP5GmHo4AtEHWsxIvb12VVUzjHjHO/vhBW2hNBDWpMACW
	/4lUmdUoyQYNUPGhANZfxqV08n/+ABPiQ4eipaRM37ihFvpw5uAMHi4hTuLLLPuFtcuBS8koEZN
	sEH+klHx/Dai3FDWamZgSgsZy46qoNLpf6OQUpBQ9U4hTz9pBjsQhRMHHy2VBwntUY89/2+h690
	BTGA4hcSor7hm6tFGCypVq59w3tn7y0aRpBBu+HW1bCU9rfP5uTQMtjVDF4Uqw7TNTTTmh3TcWY
	7EGsrR32pxGkf0KRzgI83MR/MZYHR9/CwKNLUK9i5sliW
X-Received: by 2002:a05:600d:8346:b0:477:54cd:202f with SMTP id 5b1f17b1804b1-47754cd2267mr21657325e9.3.1762267495408;
        Tue, 04 Nov 2025 06:44:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6+Gw3mfCjedQ9pUcBjjf5DA+gJGiTRJ2ckAQDBQkXav+IsQw9f3hw8sBpEo9Sd27YF2Q4zQ==
X-Received: by 2002:a05:600d:8346:b0:477:54cd:202f with SMTP id 5b1f17b1804b1-47754cd2267mr21656845e9.3.1762267494897;
        Tue, 04 Nov 2025 06:44:54 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c23b8d9sm256870135e9.0.2025.11.04.06.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 06:44:54 -0800 (PST)
Message-ID: <6dfd2fe8-65b6-40db-b0f2-34aa0e4f3e9b@redhat.com>
Date: Tue, 4 Nov 2025 15:44:52 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 15/15] quic: add packet builder and parser
 base
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
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
 <c9b7d644059fcd181a710ef2aff089e002133046.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <c9b7d644059fcd181a710ef2aff089e002133046.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +/* Process PMTU reduction event on a QUIC socket. */
> +void quic_packet_rcv_err_pmtu(struct sock *sk)
> +{
> +	struct quic_path_group *paths = quic_paths(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_config *c = quic_config(sk);
> +	u32 pathmtu, info, taglen;
> +	struct dst_entry *dst;
> +	bool reset_timer;
> +
> +	if (!ip_sk_accept_pmtu(sk))
> +		return;
> +
> +	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
> +	/* If PLPMTUD is not enabled, update MSS using the route and ICMP info. */
> +	if (!c->plpmtud_probe_interval) {
> +		if (quic_packet_route(sk) < 0)
> +			return;
> +
> +		dst = __sk_dst_get(sk);
> +		dst->ops->update_pmtu(dst, sk, NULL, info, true);
> +		quic_packet_mss_update(sk, info - packet->hlen);
> +		return;
> +	}
> +	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and AEAD tag.  Also
> +	 * notify the QUIC path layer for possible state changes and probing.
> +	 */
> +	taglen = quic_packet_taglen(packet);
> +	info = info - packet->hlen - taglen;
> +	pathmtu = quic_path_pl_toobig(paths, info, &reset_timer);
> +	if (reset_timer)
> +		quic_timer_reset(sk, QUIC_TIMER_PMTU, c->plpmtud_probe_interval);
> +	if (pathmtu)
> +		quic_packet_mss_update(sk, pathmtu + taglen);
> +}
> +
> +/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
> +static int quic_packet_rcv_err(struct sk_buff *skb)
> +{
> +	union quic_addr daddr, saddr;
> +	struct sock *sk = NULL;
> +	int ret = 0;
> +	u32 info;
> +
> +	/* All we can do is lookup the matching QUIC socket by addresses. */
> +	quic_get_msg_addrs(skb, &saddr, &daddr);
> +	sk = quic_sock_lookup(skb, &daddr, &saddr, NULL);
> +	if (!sk)
> +		return -ENOENT;
> +
> +	bh_lock_sock(sk);
> +	if (quic_is_listen(sk))

The above looks race-prone. You should check the status only when
holding the sk socket lock, i.e. if !sock_owned_by_user(sk)

> +		goto out;
> +
> +	if (quic_get_mtu_info(skb, &info))
> +		goto out;

This can be moved outside the lock.

> +
> +	ret = 1; /* Success: update socket path MTU info. */
> +	quic_paths(sk)->mtu_info = info;
> +	if (sock_owned_by_user(sk)) {
> +		/* Socket is in use by userspace context.  Defer MTU processing to later via
> +		 * tasklet.  Ensure the socket is not dropped before deferral.
> +		 */
> +		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED, &sk->sk_tsq_flags))
> +			sock_hold(sk);
> +		goto out;
> +	}
> +	/* Otherwise, process the MTU reduction now. */
> +	quic_packet_rcv_err_pmtu(sk);
> +out:
> +	bh_unlock_sock(sk);
> +	sock_put(sk);
> +	return ret;
> +}
> +
> +#define QUIC_PACKET_BACKLOG_MAX		4096
> +
> +/* Queue a packet for later processing when sleeping is allowed. */
> +static int quic_packet_backlog_schedule(struct net *net, struct sk_buff *skb)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct quic_net *qn = quic_net(net);
> +
> +	if (cb->backlog)
> +		return 0;

The above test is present also in the only caller of this function. It
should be removed from there.

[...]> +/* Work function to process packets in the backlog queue. */
> +void quic_packet_backlog_work(struct work_struct *work)
> +{
> +	struct quic_net *qn = container_of(work, struct quic_net, work);
> +	struct sk_buff *skb;
> +	struct sock *sk;
> +
> +	skb = skb_dequeue(&qn->backlog_list);
> +	while (skb) {
> +		sk = quic_packet_get_listen_sock(skb);
> +		if (!sk)
> +			continue;
> +
> +		lock_sock(sk);

Possibly lock_sock_fast(sk);

> +		quic_packet_process(sk, skb);
> +		release_sock(sk);
> +		sock_put(sk);
> +
> +		skb = skb_dequeue(&qn->backlog_list);
> +	}
> +}

[...]> +/* Create and transmit a new QUIC packet. */
> +int quic_packet_create(struct sock *sk)
Possibly rename the function accordingly to its actual action, i.e.
quic_packet_create_xmit()

[...]> @@ -291,6 +294,8 @@ static void __net_exit quic_net_exit(struct
net *net)
>  #ifdef CONFIG_PROC_FS
>  	quic_net_proc_exit(net);
>  #endif
> +	skb_queue_purge(&qn->backlog_list);
> +	cancel_work_sync(&qn->work);

Likely: disable_work_sync()

>  	quic_crypto_free(&qn->crypto);
>  	free_percpu(qn->stat);
>  	qn->stat = NULL;

EPATCHISTOOBIG, very hard to process. Please split this one it at least
2 (i.e. rx and tx part), even if the series will grow above 15

/P

