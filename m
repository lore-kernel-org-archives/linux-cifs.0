Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D633F8B7
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704859; cv=none; b=OAtNXxA7J1/MWBkU4M+GTUvVp9j3hOivlXGtwPK0hok6WpMMa70NlanEorILGVIzfZ4mjsz3PyhD/V9pGCTpBiaAt8hMyKJOuH8I5s+6NBlIy6XYTV5MwFQZQhUm6bAKU3535EQ2stWnkWWr5CsNUcYqT21cYiYiHvAHzRiwLtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704859; c=relaxed/simple;
	bh=tAGcf2qHYt65xo/mPlZWfHpD6g4PeOJZ15QDP/sjPeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kl9sdJ1zvVQKmFKqCl/S4YtIJeTs7DsZdfM4yAqIDTi7L8t7bCl7617cK0IotTPC1P4OFsT99/cFHw8nHig2JyGuF5JrL4tTDPJa41Do30BGnlHklyzRJUmM5Nmjrze1Uu6sG4uLSBnShaZdMPubeGb5+F4FTeCtux5y5uIsiKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ioslu35z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWdbRHZI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ioslu35z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWdbRHZI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769704855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmP+ZaocLWbsQYSfK1kgq3CFYftfiEuO4FH3b4mkBqg=;
	b=ioslu35zlYCS4YcWn+lNjeV6SVCAzIw8UmfwnmfLPFrXYl58THELPsKisH1PQ4N85DA1Uy
	aatqig7vtNhCswndjOh92bTqC60SerFoueP61rJHjgFCPoVlZ4jeRKJn00lYzkA1YLuzpK
	KUV50OCgd1C7msJr+3y9rASCqCzI3/o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-DF1tjecbMaup4DgT97KkXA-1; Thu, 29 Jan 2026 11:40:54 -0500
X-MC-Unique: DF1tjecbMaup4DgT97KkXA-1
X-Mimecast-MFC-AGG-ID: DF1tjecbMaup4DgT97KkXA_1769704853
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-480711d09f1so22956935e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 08:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769704853; x=1770309653; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BmP+ZaocLWbsQYSfK1kgq3CFYftfiEuO4FH3b4mkBqg=;
        b=VWdbRHZIx69iisJuR3kKnCUnv3yOraE+Jb82+KUDkMB5O5kG52rIh1h7uyzBCNtKfO
         nEytYvvKc+aaurX1G8dIEsESoT8hZe6GTO5fu2mCnLpSj6sfYR0gUhjsDn6wXFsFimND
         lgBwqBfCSylNWT1cvTYw9j7ySQMxSfaEH6l8FNmy0ZRV/YwHfwZ89DKUYF3Vc9paUbYd
         EAasHMGKKZ8xkeX1SEMC+cpdUTRJz/OfIKx02l7Q0qysHN1xKJBeuNSYXVOD/3oUy18A
         yuMSyuMn1QPH4jKII/RnyKT5Lkm6oRhM/UvvBEM3UWTaU2LXbAy4ZVRdEGU2HiJXs6t6
         Xtpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704853; x=1770309653;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BmP+ZaocLWbsQYSfK1kgq3CFYftfiEuO4FH3b4mkBqg=;
        b=WOfoiFfnawHWcmfY4h8OQ9i+d4VHBjomW21mDALt5Wxr+aBs2GUer3MChC6Ua5saMG
         hwxpQ0/ataakp5YxNkRkEvZflG4rkluCUCvVvnAkFIT7/O9h3p7IREFGbB7eJoyBnemo
         Psi3EDrOuWzpY4CuVcb0ip9Y7Gb4RF4D/JthHR8QJjeeCaEkeIYxQgXowLt+N1GE1LvJ
         BZo/BhBzc45ZxQnR53gVikAWU07f9XbMuR3QN1YOeDC3uNSng6tqrxupHlpJb35QP+az
         0bZXTgeKCCFw4OPp1OS9j3Yd8yuBQ5GtJrqXzmhxmiy5LW2PE5VpdQ0PMATflH7Xv/Gf
         KF3w==
X-Forwarded-Encrypted: i=1; AJvYcCUH9hk+2uDgrkaNYv+wylPiAewJNR9j9wTK6kOmoDbzyD26cor6c8a/52Rn150qvkzUavBvRVQnCrqz@vger.kernel.org
X-Gm-Message-State: AOJu0YxV0AJbvq3eit8/CowNNpGa2uqglX8mopzmYdfjgIxWbxcx0HpA
	1gQsl8NfVo/7HPzc8qhXnCkmdvKk+raUp8xIzYf2CT71ZDUXwvmDPfV8FLWBILoa4eNAxQPsv58
	WpaB4P67nOk2rw6N2b0sCTrOGIsWRg496cbRfrLv2ZHgVC7FxLp/+16E6x0fvFlY=
X-Gm-Gg: AZuq6aJpEQ4JMBnklUBqzVZsWSwkn8uRUxnMwapEVcCNCF2Cmwk3ad3B3to4wnJ5KnC
	2G3dfEOzraIvmgynSA/l9f6xMcbwrvMR8PeiBwRbFZE9KhkyHczsM2b91gJbOIduKyYB0/E0xdl
	Pqau6Y7F8DsjllIwqUOedGOqttSk77Do9LS2WiZxWwCA4Uut2egydIESrTpfC5gzwVa0vhNXok9
	ZRW4eNo21fZhU00bI2bz4iMBoxjfZdgZwgLe6n4L2WAiHY7dthYY926tMUb/Sks//56SFpRgB0H
	vmzCqyl7tZsZiseTZ/dEbQ8LfHYLwfvfrPenx5Qup3i4zk/n+j21/o+tFroHZvO9+PaduvoFkdf
	ZxITGdgdeuhp5
X-Received: by 2002:a05:600c:1e85:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-48069c89792mr113972995e9.30.1769704852856;
        Thu, 29 Jan 2026 08:40:52 -0800 (PST)
X-Received: by 2002:a05:600c:1e85:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-48069c89792mr113972655e9.30.1769704852398;
        Thu, 29 Jan 2026 08:40:52 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e46cesm15195228f8f.7.2026.01.29.08.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 08:40:52 -0800 (PST)
Message-ID: <b0045978-ea65-422b-8260-d079b43eb553@redhat.com>
Date: Thu, 29 Jan 2026 17:40:49 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 14/15] quic: add packet builder base
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
 <4ec3ade7dfc709658a2b1839dbe29c9467b25fdf.1769439073.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <4ec3ade7dfc709658a2b1839dbe29c9467b25fdf.1769439073.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 3:51 PM, Xin Long wrote:
> +/* Configure the QUIC packet header and routing based on encryption level and path. */
> +int quic_packet_config(struct sock *sk, u8 level, u8 path)
> +{
> +	struct quic_conn_id_set *dest = quic_dest(sk), *source = quic_source(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_config *c = quic_config(sk);
> +	u32 hlen = QUIC_HLEN;
> +
> +	/* If packet already has data, no need to reconfigure. */
> +	if (!quic_packet_empty(packet))
> +		return 0;
> +
> +	packet->ack_eliciting = 0;
> +	packet->frame_len = 0;
> +	packet->ipfragok = 0;
> +	packet->padding = 0;
> +	packet->frames = 0;
> +	hlen += QUIC_PACKET_NUMBER_LEN; /* Packet number length. */
> +	hlen += quic_conn_id_choose(dest, path)->len; /* DCID length. */
> +	if (level) {
> +		hlen += 1; /* Length byte for DCID. */
> +		hlen += 1 + quic_conn_id_active(source)->len; /* Length byte + SCID length. */
> +		if (level == QUIC_CRYPTO_INITIAL) /* Include token for Initial packets. */
> +			hlen += quic_var_len(quic_token(sk)->len) + quic_token(sk)->len;
> +		hlen += QUIC_VERSION_LEN; /* Version length. */
> +		hlen += QUIC_PACKET_LENGTH_LEN; /* Packet length field length. */
> +		/* Allow fragmentation if PLPMTUD is enabled, as it no longer relies on ICMP
> +		 * Toobig messages to discover the path MTU.
> +		 */
> +		packet->ipfragok = !!c->plpmtud_probe_interval;
> +	}
> +	packet->level = level;
> +	packet->len = (u16)hlen;
> +	packet->overhead = (u8)hlen;

Given the above math, it looks like hlen can never be > 255, but
possibly a DEBUG_NET_WARN_ON_ONCE() could save from future bug and make
the code more clear?

> +
> +	if (packet->path != path) { /* If the path changed, update and reset routing cache. */
> +		packet->path = path;
> +		__sk_dst_reset(sk);
> +	}
> +
> +	/* Perform routing and MSS update for the configured packet. */
> +	if (quic_packet_route(sk) < 0)
> +		return -1;
> +	return 0;
> +}
> +
> +static void quic_packet_encrypt_done(struct sk_buff *skb, int err)
> +{
> +	/* Free it for now, future patches will implement the actual deferred transmission logic. */
> +	kfree_skb(skb);
> +}
> +
> +/* Coalescing Packets. */
> +static int quic_packet_bundle(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct quic_skb_cb *head_cb, *cb = QUIC_SKB_CB(skb);
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct sk_buff *p;
> +
> +	if (!packet->head) { /* First packet to bundle: initialize the head. */
> +		packet->head = skb;
> +		cb->last = skb;
> +		goto out;
> +	}
> +
> +	/* If bundling would exceed MSS, flush the current bundle. */
> +	if (packet->head->len + skb->len >= packet->mss[0]) {
> +		quic_packet_flush(sk);
> +		packet->head = skb;
> +		cb->last = skb;
> +		goto out;

The same code is duplicate a few lines above; you could reduce
duplication jumping to a common label.

/P

