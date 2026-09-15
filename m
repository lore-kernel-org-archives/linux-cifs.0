Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2F37E5E9;
	Tue, 15 Sep 2026 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501827; cv=none; b=C9mX+tdKnLQ4uWTgo2O5oaBNa9DQbFe6sHXCIRtmTa8MDAetZ0Cnr3XH7rEfxmJXd0rX88MT6RLUrEesre/RCRg/HG0oNn+eHQuC+vPfAXcT2pdbnJ/JXN/0LDo43z3l/9Yhu2C6qv39cjGWjA6jzU6XbHEdtTjDywZRZFeGz7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501827; c=relaxed/simple;
	bh=H9V74awVIuDUKLi7/wsQZmx2nUgC56/MKHJdwds+Xrg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HD7S5+yT5UhXehoViCKHbPMKAcdIpxd4v//ebDdn5CBiROB/dhAIpj1xdE9FJYDWPoCPsPDli83Q1OzJmBcjeEgPby564v480WRVpkhfPL12FTuAlRET0/rz1MW7Sa9UAYSTtbobomkAl5UGfT1hXk59JtqE4IIX9AYdxp+lZGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9afK+AS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9afK+AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8115A1F000FF;
	Tue, 15 Sep 2026 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501825;
	bh=EwzVtkbA5LH9Erj8q4RPgjCDh9tMT6UX7ZqdPxb6gQI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f9afK+ASMEhYo2hVRX9dsEZQ81zFUd+DzCyutcEBDfXHu4sAGCOT2GDs6EdkMJpAM
	 6JW3SEY4NIMfS9g9A7IwEdSnIKtFocNjZOoEUvDG4qvHtdfj200tj2h9QZQrMpczVz
	 /bOZy1c3isjpm2OuTJmd76z6YL8+5D2KIJZ32a+YWQR/UXOuaEUeYPJIbnrag1Z0kA
	 vu78rSSWoQOk4FQzSTOXumgq8VjNAhnj9G7KwTZXdTGqC5JI6snXRJ/HH79Ns6sPh3
	 CsJlMxBPOqUTC6YneYp0gRFjxxHxS6hQ3VJl9DLLcOGIUd0d9RLK32wsWWdcGR3PEA
	 rg3vX1XT13WWQ==
Subject: Re: [PATCH net-next v15 03/15] quic: provide common utilities and
 data structures
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:23 +0000
Message-ID: <178950182306.22033.14152384539754204368@kernel.org>
In-Reply-To: =?utf-8?q?=3C1cf83a4eb178197cd842e34468f4e357f42b9c28=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C1cf83a4eb178197cd842e34468f4e357f42b9c28=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] Weak hash seeding in the new QUIC hash helpers:
  `quic_sock_hash()` (net/quic/common.c:40-53) reduces IPv6 addresses to…

--

quic: provide common utilities and data structures

This patch adds net/quic/common.c and net/quic/common.h with the QUIC
packet header types, connection ID and address helpers, the socket and
connection ID hash tables, and the varint/transport-parameter encoding
helpers. quic_init() now initializes and tears down the hash tables.

One question below about the hash helpers.

> diff --git a/net/quic/common.c b/net/quic/common.c
> new file mode 100644
> index 0000000000000..51d71b6733c7d
> --- /dev/null
> +++ b/net/quic/common.c
> @@ -0,0 +1,565 @@

[ ... ]

> +u32 quic_sock_hash(struct net *net, union quic_addr *s, union quic_addr *d)
> +{
> +	u32 ports = ((__force u32)s->v4.sin_port) << 16 |
> +		    (__force u32)d->v4.sin_port;
> +	u32 saddr = (s->sa.sa_family == AF_INET6) ?
> +		    jhash(&s->v6.sin6_addr, 16, 0) :
> +		    (__force u32)s->v4.sin_addr.s_addr;
> +	u32 daddr = (d->sa.sa_family == AF_INET6) ?
> +		    jhash(&d->v6.sin6_addr, 16, 0) :
> +		    (__force u32)d->v4.sin_addr.s_addr;
> +	u32 hash = jhash_3words(saddr, daddr, ports, net_hash_mix(net));
> +
> +	return hash & (quic_sock_hash_size() - 1);
> +}

[Severity: Medium]
Should the inner IPv6 fold in quic_sock_hash() be seeded?

The per-netns secret is only mixed in the outer jhash_3words() call, while
the 128-bit address is first reduced to 32 bits with jhash(..., 0). Since
jhash_3words(a, b, c, initval) is a pure function of its inputs, two peer
addresses whose unseeded 32-bit fold is equal produce identical (saddr,
daddr, ports) triples and therefore the same bucket for every value of
net_hash_mix(net).

Does that let a peer controlling an IPv6 prefix pick colliding source
addresses offline, without knowing the secret, and collapse many
connections into one chain of quic_hashinfo.chash (capped at 16K buckets)
that the per-packet lookup then walks?

Compare with sctp_hashfn() in net/sctp/input.c, which the commit message
cites as the model and which passes the seed into the inner fold:

	if (paddr->sa.sa_family == AF_INET6)
		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
	else
		addr = (__force __u32)paddr->v4.sin_addr.s_addr;

	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
			     (__force __u32)lport, net_hash_mix(net), seed);

Would jhash(&s->v6.sin6_addr, 16, net_hash_mix(net)) here be equivalent in
cost?

[ ... ]

> +struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *scid,
> +						 u32 len)
> +{
> +	u32 hash = jhash_1word(jhash(scid, len, 0), net_hash_mix(net));
> +	struct quic_shash_table *ht = &quic_hashinfo.shash;
> +
> +	return &ht->hash[hash & (ht->size - 1)];
> +}

[Severity: Medium]
Same pattern here: the connection ID bytes are folded with jhash(scid, len,
0) before the secret is applied, so any two connection IDs colliding in
that unseeded fold share a bucket for any secret. Would passing
net_hash_mix(net) as the initval of the inner jhash() be preferable?

Note the connection IDs inserted in this series come from
quic_conn_id_generate() using get_random_bytes(), so the practical exposure
is smaller than for the connection socket table.

> +u32 quic_addr_hash(struct net *net, union quic_addr *a)
> +{
> +	u32 addr = (a->sa.sa_family == AF_INET6) ?
> +		   jhash(&a->v6.sin6_addr, 16, 0) :
> +		   (__force u32)a->v4.sin_addr.s_addr;
> +
> +	return jhash_2words(addr, (__force u32)a->v4.sin_port,
> +			    net_hash_mix(net));
> +}

[Severity: Medium]
And the same unseeded sin6_addr fold appears in quic_addr_hash(), so
address-keyed hashing inherits the same property. Should all three helpers
be updated together?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
