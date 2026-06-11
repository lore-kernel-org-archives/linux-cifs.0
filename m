Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5230146C
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781166043; cv=none; b=qZPI46+Bw9QRhEyJSc3Y1UfIbpPUIUFUANkHtAx23W3iVSDzLiktPf9p7IdQ2Sc9ZPx+QA8VdjMUH+1dI2ergCyypJ6uLhXZ8/UuvHtjhTchu+gv36c53e/6lHjwhGDG1jMQ/3XOpm3yZqMes//5y7qidq6g5UFdH629ZDYFbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781166043; c=relaxed/simple;
	bh=kkcQnZHnYFny0i1w/9shp6dqBz5e0LrlromRHt8KlPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2AeRK8YNEupAvjYse0/L/HP9DAw9fAdbT8ikjuXk/I926G2HmIPR3nXTB29Sw/9mMFWf7elpaiDA1t+Hn4wdmbF4ristcz+ZTbQdr9nDYP7laFR+YZ9C0LbgHRL9wp1h4z1+j2cMfpjWu146lTMlh7phtCy9cUYC42TF1Xok5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsWym5ao; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsWym5ao"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781166041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V3hQIL6Il9n0pGlq7JeeRoDQSxplVOOUfBIF2DUxuG8=;
	b=dsWym5aoQAW5yS3fSKfDh92K5Dsdg9xPI8pGfCzo2lkRqEqqPfUZ5G1jUT4tgkKC4yPSlm
	yudVSQ3efLiS34ODrOFHlVgpPtlGFqXT6fPmpSR3CUWr/JcVyhAdInvkaKHJzhmwK08jRj
	QO88JP+OQstTmDvQw8u4lN7pFggkbJk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-cWV9Wn1UPYSFUoUMAlqHmA-1; Thu,
 11 Jun 2026 04:20:38 -0400
X-MC-Unique: cWV9Wn1UPYSFUoUMAlqHmA-1
X-Mimecast-MFC-AGG-ID: cWV9Wn1UPYSFUoUMAlqHmA_1781166035
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E188B1944D1C;
	Thu, 11 Jun 2026 08:20:33 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.48.53])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C66531800347;
	Thu, 11 Jun 2026 08:20:23 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org,
	quic@lists.linux.dev,
	davem@davemloft.net,
	kuba@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	metze@samba.org,
	mbuhl@openbsd.org,
	tfanelli@redhat.com,
	hepengtao@xiaomi.com,
	dreibh@simula.no,
	linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	kernel-tls-handshake@lists.linux.dev,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	steved@redhat.com,
	hare@suse.de,
	aahringo@redhat.com,
	dhowells@redhat.com,
	matttbe@kernel.org,
	mail@johnericson.me,
	xiyou.wangcong@gmail.com,
	alibuda@linux.alibaba.com,
	jbaron@akamai.com,
	illiliti@protonmail.com,
	sd@queasysnail.net,
	marcelo.leitner@gmail.com,
	daniel@haxx.se,
	andrew.gospodarek@broadcom.com,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org
Subject: Re: [PATCH net-next v13 15/15] quic: add packet parser base
Date: Thu, 11 Jun 2026 10:20:08 +0200
Message-ID: <20260611082008.138377-1-pabeni@redhat.com>
In-Reply-To: <0b03854cabaac243a0cdf42375c66cd033750bd0.1780855297.git.lucien.xin@gmail.com>
References: <0b03854cabaac243a0cdf42375c66cd033750bd0.1780855297.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: AI Reviewer <ai@example.com>

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/
---
quic: add packet parser base

This patch adds the QUIC packet RX parser, including ALPN extraction
from the Client Initial to demux to the right listener, an ICMP-driven
PMTU update path, and a per-net backlog/work for deferred parsing.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index ba5204aceda6..430fc06d0012 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c

[ ... ]

> +static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len)
> +{
> +	int err = -EINVAL, found = 0, exts = 0;
> +	u64 length, type;
> +

[ ... ]

> +	while (len >= 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). */
> +		if (!quic_get_int(&p, &len, &type, 2))
> +			break;
> +		if (!quic_get_int(&p, &len, &length, 2))
> +			break;
> +		if (len < (u32)length) /* Incomplete TLS extensions. */
> +			return 0;

[Medium]
Should this branch be treated as a parse failure rather than a success?

The other length-bound checks in this same function return err (-EINVAL)
when a declared length exceeds the remaining buffer, but this one returns
0 without populating alpn. The callers initialise alpn as

	struct quic_data alpns = {};

and quic_listen_sock_lookup() then takes the no-ALPN branch:

    if (!alpns->len) { /* No ALPNs or parse failed */
        sk_nulls_for_each_rcu(tmp, node, &head->head) {
            ...
            if (... && (!alpns->data || !quic_alpn(tmp)->len)) {

Because alpns->data is still NULL, the match collapses to true and any
listener bound to the address/port will match, including ones that
registered a specific ALPN list. Can a peer reach an ALPN-restricted
listener by sending a Client Initial with one extension whose declared
length is larger than what is left in the ClientHello?

Would returning err here (or always assigning alpn->data before
returning) match the comment in quic_listen_sock_lookup() that
distinguishes "TLS parsing succeeded but no ALPN was found" from "parse
failed"?

> +		if (type == TLS_EXT_alpn) { /* Found ALPN extension. */
> +			if (length > QUIC_ALPN_MAX_LEN)
> +				return err;
> +			len = length;
> +			found = 1;
> +			break;
> +		}
> +		/* Skip non-ALPN extensions. */
> +		p += length;
> +		len -= length;
> +		if (exts++ >= TLS_MAX_EXTENSIONS)
> +			return err;

[Low]
Is the post-increment intended here? With TLS_MAX_EXTENSIONS == 128, the
check (exts++ >= 128) first becomes true when exts has already reached
129, so 129 extensions are consumed before bail-out even though the
constant name suggests a cap of 128. Would

	if (++exts > TLS_MAX_EXTENSIONS)
		return err;

(or moving the check to the loop top) better reflect the intended limit?

> +	}

[ ... ]

> +static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn)

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 8f348d7c678b..19b164baf55d 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c

[ ... ]

> +struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
> +			      union quic_addr *da, struct sock *usk,
> +			      struct quic_conn_id *dcid)
> +{

[ ... ]

> +	rcu_read_lock();
> +begin:
> +	sk_nulls_for_each_rcu(tmp, node, &head->head) {
> +		if (net != sock_net(tmp))
> +			continue;
> +		paths = quic_paths(tmp);
> +		odcid = quic_path_orig_dcid(paths);
> +		if (quic_cmp_sk_addr(tmp, quic_path_saddr(paths, 0), sa) &&
> +		    quic_cmp_sk_addr(tmp, quic_path_daddr(paths, 0), da) &&
> +		    quic_path_usock(paths, 0) == usk &&
> +		    (!dcid || !quic_conn_id_cmp(odcid, dcid))) {
> +			sk = tmp;
> +			break;
> +		}
> +	}

[High]
Is the sk memory itself RCU-protected here? sk_nulls_for_each_rcu()
dereferences fields of tmp (sock_net(tmp), quic_paths(tmp),
quic_path_saddr(...), etc.) before any reference is taken. That is only
safe when the sk allocation is freed via RCU.

quic_init_sock() does not call sock_set_flag(sk, SOCK_RCU_FREE), and
neither quic_prot nor quicv6_prot sets slab_flags to SLAB_TYPESAFE_BY_RCU,
so sk_destruct() (and quic_sock_destruct()) runs synchronously on the
last sock_put(). Can a parallel close on tmp free the sock between
sk_nulls_for_each_rcu() exposing it and the field dereferences above?

The same shape appears in quic_listen_sock_lookup() further down, where
quic_alpn(tmp)->len is read inside the RCU walk before
refcount_inc_not_zero().

> +	if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> +		sk = NULL;
> +	rcu_read_unlock();
> +	return sk;
> +}

[ ... ]

> +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
> +				     union quic_addr *da,
> +				     struct quic_data *alpns)
> +{

[ ... ]

> +	rcu_read_lock();
> +	if (!alpns->len) { /* No ALPNs or parse failed */
> +		sk_nulls_for_each_rcu(tmp, node, &head->head) {

[ ... ]

> +			a = quic_path_saddr(quic_paths(tmp), 0);
> +			if (net == sock_net(tmp) &&
> +			    quic_cmp_sk_addr(tmp, a, sa) &&
> +			    quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
> +			    (!alpns->data || !quic_alpn(tmp)->len)) {

[ ... ]

> @@ -48,6 +196,9 @@ static void quic_sock_destruct(struct sock *sk)
>  	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
>  		quic_crypto_free(quic_crypto(sk, i));
>  
> +	/* Deferred ALPN free for RCU readers in quic_listen_sock_lookup(). */
> +	quic_data_free(quic_alpn(sk));
> +

Without SOCK_RCU_FREE or SLAB_TYPESAFE_BY_RCU on quic_prot/quicv6_prot,
does moving the alpn free into the destruct callback actually defer it
past an RCU grace period? quic_sock_destruct() is invoked from
sk_destruct() on the final sock_put() and is not itself an RCU callback,
so the comment's "Deferred ALPN free for RCU readers" assumption seems to
rely on a guarantee that is not configured on this protocol. Should this
patch also set sock_set_flag(sk, SOCK_RCU_FREE) in quic_init_sock(), or
alternatively take refcount_inc_not_zero() in the lookup helpers before
touching any fields of tmp?

>  	quic_sk_destruct(sk);
>  }
>  

[ ... ]
-- 
This is an AI-generated review.

