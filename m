Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDECE2367B8
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 10:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762252061; cv=none; b=bHN1DoWTl1YwbdsmCpWswb6B26HbgSO3sC4uN3iOSAwXBQQZRz5hLqo85GAXfzf95NQUww+BeY4smYfS4IWJVHGpvfJNQxkxfbKJv6MvzlhRFPNhS6VoC8hIivtlzaOn68WYuKtiXY8vMiL+sx9YKD87A4KxnMUgvT8oC2r+Bfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762252061; c=relaxed/simple;
	bh=PXwkPg6t9gZHTPHYFMBxi8xJdrgBYRM08StHpo40yRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e6ogavbAdtC5JhS+5fZAaTJDBODndd8C4O8deCtDUmL1cuqKfpL17wPyk4Pr80r4RCXHzT1K85UnDoMfdUrZphA0kw+ggEcrFZcAUnYnwb4dNC7FmctHfk77NyP50+LYc6951Gt5QDQNPE2QNbN5Xq3n6XpSPuOTWdA3n2KvJ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QqLEX14+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLoCUK+x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QqLEX14+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLoCUK+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762252058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9BJHzXVXTqUYAlxMYc+x6/745b/YJuqB0StnnaDGEuM=;
	b=QqLEX14+Arw9P7MXXee4iXBvxtaedbzB8Nw6Erg7M7MewUCDwZcgxAokacLY2MI1Lc+dSj
	narHjl67aHkvJmT0HGETYt/5c7cW3kv5if16iOQktO5GqpShjasWqyhqfVWD0fDKdNUEh8
	ZLLDnTVY44BedsqqG9Q4stMGGlIV91I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-UFPLiduXP-Kdsuvcve1zbQ-1; Tue, 04 Nov 2025 05:27:37 -0500
X-MC-Unique: UFPLiduXP-Kdsuvcve1zbQ-1
X-Mimecast-MFC-AGG-ID: UFPLiduXP-Kdsuvcve1zbQ_1762252056
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477563e531cso4503505e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 02:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762252056; x=1762856856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9BJHzXVXTqUYAlxMYc+x6/745b/YJuqB0StnnaDGEuM=;
        b=BLoCUK+xUR87ap72Vvb7y6KsDH3z1PvX6Mzd42Qdr+zdPTTXNi6RZ9iqf5Cv79tMBy
         zurDWT4xAvCQz+xHct1lL3XxkjQiVV9/L4YHZJSuCVoQhFsDW1ZJEBiS8S7UYmkP2du4
         qAGzsRB1cC54hvUzu/gPGAMZIn/MUA+b9gFMIxSF5M5uA1my/mEDqms9fzthgJ7p+8wU
         646JeGSEjk8rrCIba+uOPhKn19yDyOiFulk4tEehUETrSry/VxzVEAYyZO8PaPd57y1u
         7gfaep0TDq5/sugmb/vZPq+gmRIULmF7V9TXpVSBf2NOYV4p8IlaGgrwWl5rzdZljkee
         tJ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762252056; x=1762856856;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BJHzXVXTqUYAlxMYc+x6/745b/YJuqB0StnnaDGEuM=;
        b=I+S2nTKFYgciwp8bRuN0kpLzeoLkuU/tESOkOSXHBzoHG8zFFOz8Ex1LXS514Vxy0F
         y7MctiNJ/a150DAX5+w+7Jg+Nl6s3y890s6J8yisLG1GODLxjU/ezBXGBzyGQiEinV0p
         ChoWNqHflb8R6XLqFwqX+ggob2bhrymMiHKAgwLvP9+1GMX0q/TLr3PnWFxXFSwXkIi0
         nrMWAXy8Yzbv+dxtIhMpetthRCaFMYBTpF77qeqLZVDRZ4dntRiP4ILw3MPyUHajDStk
         r76T1h7NOfRyQ6mk1Am4Xr1Y9ioSgAQUx3dWSisR6719JdAHLT58ymCk3z4KnxUJXbr8
         PmCA==
X-Forwarded-Encrypted: i=1; AJvYcCX3XdoAHVJnvlLkg4DAuVzLjjUI2NCqyRm3v9d5xSmdf/0zIOluY1b15Jbxm5xoEdImRhlHeAKVpV0W@vger.kernel.org
X-Gm-Message-State: AOJu0YyimZqJfWW5zJDhfZzhhFsLhRljd43hAYM75H4oAwwwJyzcdCez
	z3BBV32EKt1OButLJYQ80IQmZQFtcQmWHEUTUI5uL2QC1lKifYw9Py87E8nBMJUTQZKIIyLhZuo
	plnTB2WC4cjyxgcWhr/2Qe7dD2ePwn8p7oe4VyD5I19weLffcd9YLGG1OIVzRKR8=
X-Gm-Gg: ASbGnctOUuQw/qdeVSPRtRwtPlmdp2/1MkedWmXF3g64AWhxwxhebOyoyUDQSVnzUmo
	MInY9Xf4nslWzKUfBoTdJBNP+HKPyaYtdqwLJGSIVW+kamKW2e8h4xEidlNi3seWTqhBpTUdcHR
	a5NA2LX7ZyzgyLVW3LDzEZKhYK5c6OARGPS6BGJi3zFvgXQYsVkT3QWBF5JMowAtZgMWPxdc9zm
	4yNU/D3dUp0DQxiBK9zOpB1wHPy2b9KJvt/010vO8lULqxF/8urnbB6v+AzGTuSUGfO3J321CvG
	wBSwvFYJx+r6cfoMctPrGuFU1w38PFrSNgx0RQAydjAZLbF0g82UfWaCw4MUH4ufyKIv9vreRt+
	hI/Kta6k+A3tecPzAJmBWktTnEOcB6nU6wElkWYvUlOkR
X-Received: by 2002:a05:600c:1f0e:b0:46e:4704:b01e with SMTP id 5b1f17b1804b1-477305a24bcmr155433335e9.8.1762252056291;
        Tue, 04 Nov 2025 02:27:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDIikHrNRel31D0YOz3lp7mI8RIh/7Fkt/R7xUHROdiwAly3TJjMPIf8hmo3m6Yoq37eLQaQ==
X-Received: by 2002:a05:600c:1f0e:b0:46e:4704:b01e with SMTP id 5b1f17b1804b1-477305a24bcmr155432885e9.8.1762252055721;
        Tue, 04 Nov 2025 02:27:35 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c48daa0sm210093085e9.3.2025.11.04.02.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 02:27:35 -0800 (PST)
Message-ID: <f557c3eb-9177-4e4f-b46e-e83bf938e2b0@redhat.com>
Date: Tue, 4 Nov 2025 11:27:32 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 04/15] quic: provide family ops for address
 and protocol
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
 <204debefcf0329a04ecd03094eb4d428bf9a44f1.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <204debefcf0329a04ecd03094eb4d428bf9a44f1.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +static int quic_v4_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
> +			      struct flowi *fl)
> +{
> +	struct flowi4 *fl4;
> +	struct rtable *rt;
> +
> +	if (__sk_dst_check(sk, 0))
> +		return 1;
> +
> +	memset(fl, 0x00, sizeof(*fl));
> +	fl4 = &fl->u.ip4;
> +	fl4->saddr = sa->v4.sin_addr.s_addr;
> +	fl4->fl4_sport = sa->v4.sin_port;
> +	fl4->daddr = da->v4.sin_addr.s_addr;
> +	fl4->fl4_dport = da->v4.sin_port;
> +	fl4->flowi4_proto = IPPROTO_UDP;
> +	fl4->flowi4_oif = sk->sk_bound_dev_if;
> +
> +	fl4->flowi4_scope = ip_sock_rt_scope(sk);
> +	fl4->flowi4_dscp = inet_sk_dscp(inet_sk(sk));
> +
> +	rt = ip_route_output_key(sock_net(sk), fl4);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +
> +	if (!sa->v4.sin_family) {

The above check is strange. Any special reason to not use
quic_v4_is_any_addr()?

> +		sa->v4.sin_family = AF_INET;
> +		sa->v4.sin_addr.s_addr = fl4->saddr;
> +	}
> +	sk_setup_caps(sk, &rt->dst);
> +	return 0;
> +}
> +
> +static int quic_v6_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
> +			      struct flowi *fl)
> +{
> +	struct ipv6_pinfo *np = inet6_sk(sk);
> +	struct ip6_flowlabel *flowlabel;
> +	struct dst_entry *dst;
> +	struct flowi6 *fl6;
> +
> +	if (__sk_dst_check(sk, np->dst_cookie))
> +		return 1;
> +
> +	memset(fl, 0x00, sizeof(*fl));
> +	fl6 = &fl->u.ip6;
> +	fl6->saddr = sa->v6.sin6_addr;
> +	fl6->fl6_sport = sa->v6.sin6_port;
> +	fl6->daddr = da->v6.sin6_addr;
> +	fl6->fl6_dport = da->v6.sin6_port;
> +	fl6->flowi6_proto = IPPROTO_UDP;
> +	fl6->flowi6_oif = sk->sk_bound_dev_if;
> +
> +	if (inet6_test_bit(SNDFLOW, sk)) {
> +		fl6->flowlabel = (da->v6.sin6_flowinfo & IPV6_FLOWINFO_MASK);
> +		if (fl6->flowlabel & IPV6_FLOWLABEL_MASK) {
> +			flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
> +			if (IS_ERR(flowlabel))
> +				return -EINVAL;
> +			fl6_sock_release(flowlabel);
> +		}
> +	}
> +
> +	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
> +	if (IS_ERR(dst))
> +		return PTR_ERR(dst);
> +
> +	if (!sa->v6.sin6_family) {

(similar question here)

[...]
> +static int quic_v4_get_mtu_info(struct sk_buff *skb, u32 *info)
> +{
> +	struct icmphdr *hdr;
> +
> +	hdr = (struct icmphdr *)(skb_network_header(skb) - sizeof(struct icmphdr));

Noting the above relies on headers being already pulled in the linear
part. Later patch will do skb_linarize(), but that looks overkill and
should hit performance badly. Instead you should use pskb_may_pull() &&
friends.

> +	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED) {
> +		*info = ntohs(hdr->un.frag.mtu);
> +		return 0;
> +	}
> +
> +	/* Defer other types' processing to UDP error handler. */
> +	return 1;
> +}
> +
> +static int quic_v6_get_mtu_info(struct sk_buff *skb, u32 *info)
> +{
> +	struct icmp6hdr *hdr;
> +
> +	hdr = (struct icmp6hdr *)(skb_network_header(skb) - sizeof(struct icmp6hdr));
> +	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG) {
> +		*info = ntohl(hdr->icmp6_mtu);
> +		return 0;
> +	}
> +
> +	/* Defer other types' processing to UDP error handler. */
> +	return 1;
> +}
> +
> +static u8 quic_v4_get_msg_ecn(struct sk_buff *skb)
> +{
> +	return (ip_hdr(skb)->tos & INET_ECN_MASK);
> +}
> +
> +static u8 quic_v6_get_msg_ecn(struct sk_buff *skb)
> +{
> +	return (ipv6_get_dsfield(ipv6_hdr(skb)) & INET_ECN_MASK);
> +}
> +
> +static int quic_v4_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
> +				 int addr_len)
> +{
> +	u32 len = sizeof(struct sockaddr_in);
> +
> +	if (addr_len < len || addr->sa_family != AF_INET)
> +		return 1;
> +	if (ipv4_is_multicast(quic_addr(addr)->v4.sin_addr.s_addr))
> +		return 1;
> +	memcpy(a, addr, len);
> +	return 0;
> +}

It looks like the above function is not used in this series?!? (well
it's called by quic_get_user_addr() which in turn is unsed.

Perhaps drop from here and add later as needed?

Also the name sounds possibly misleading, I read it as it should copy
data to user-space and return value could possibly be an errnum.

> +static void quic_v4_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
> +{
> +	u8 *p = *pp;
> +
> +	memcpy(&addr->v4.sin_addr, p, QUIC_ADDR4_LEN);
> +	p += QUIC_ADDR4_LEN;
> +	memcpy(&addr->v4.sin_port, p, QUIC_PORT_LEN);
> +	p += QUIC_PORT_LEN;
> +	addr->v4.sin_family = AF_INET;
> +	/* Skip over IPv6 address and port, not used for AF_INET sockets. */
> +	p += QUIC_ADDR6_LEN;
> +	p += QUIC_PORT_LEN;
> +
> +	if (!addr->v4.sin_port || quic_v4_is_any_addr(addr) ||
> +	    ipv4_is_multicast(addr->v4.sin_addr.s_addr))
> +		memset(addr, 0, sizeof(*addr));
> +	*plen -= (p - *pp);
> +	*pp = p;
> +}

Similarly unused?

> +static bool quic_v4_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
> +{
> +	if (a->v4.sin_port != addr->v4.sin_port)
> +		return false;
> +	if (a->v4.sin_family != addr->v4.sin_family)
> +		return false;
> +	if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY) ||
> +	    addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
> +		return true;
> +	return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
> +}
> +
> +static bool quic_v6_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
> +{
> +	if (a->v4.sin_port != addr->v4.sin_port)
> +		return false;
> +
> +	if (a->sa.sa_family == AF_INET && addr->sa.sa_family == AF_INET) {
> +		if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY) ||
> +		    addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
> +			return true;
> +		return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
> +	}
> +
> +	if (a->sa.sa_family != addr->sa.sa_family) {
> +		if (ipv6_only_sock(sk))
> +			return false;
> +		if (a->sa.sa_family == AF_INET6 && ipv6_addr_any(&a->v6.sin6_addr))
> +			return true;
> +		if (a->sa.sa_family == AF_INET && addr->sa.sa_family == AF_INET6 &&

Below this code assumes that sa_family is either AF_INET or AF_INET6. If
such assumtion hold, you should use here, too. and drop the
'addr->sa.sa_family == AF_INET6' condition.

> +		    ipv6_addr_v4mapped(&addr->v6.sin6_addr) &&
> +		    addr->v6.sin6_addr.s6_addr32[3] == a->v4.sin_addr.s_addr)
> +			return true;
> +		if (addr->sa.sa_family == AF_INET && a->sa.sa_family == AF_INET6 &&
> +		    ipv6_addr_v4mapped(&a->v6.sin6_addr) &&
> +		    a->v6.sin6_addr.s6_addr32[3] == addr->v4.sin_addr.s_addr)
> +			return true;

Nothing this branch does not handle the 'ipv6_addr_any(&addr->v6.sin6_addr)'

/P

