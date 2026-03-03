Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0802431716B
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526855; cv=none; b=Wgu4Le9FFkME6HAbmmkpd8xe1i4bB1ZPg5zwfRIDx0sPV9JqAZai6RTvc8dbZpeRi+Xu0DXPicqoc1KPZrqpwfvfz7L5tNMUbjuTfzpSC8KkMt/Dyhgc8sHzwv59H33FAM+VJ1a+LjMj2PmgGuVw0kniRbxIUJ6siN9cxyFrXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526855; c=relaxed/simple;
	bh=28/2SD0zKnxVxONz58kqvH8l9p8IW3PnbEu16NUlN4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC6Do9ND82DRWJPXkwSFtwtDRJbPDqcbd8dTtdME8TmVCVywonGbpsOz6OoFplRU2/VxZAsYiYvNlLaMrf8X9UIK20eWmmmM0R5GXaR5M44YpfgWFqCby/R7/M8MW3kDUsoKEiZbzd4B3xi3cxiwm3JNYpZ3eHLKxQzFSUL9Z9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KPvlmQyY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPvlmQyY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772526853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oGGteXDhadojqghSFLLImSNgVRBGSngpOjwddhC7BTg=;
	b=KPvlmQyY+cezzjS0QNCMwuUPcw5X9mJ5wRzS0dE+KMQUHMcIvtlMMVipHi+JkmAD4aj/5C
	ukxu6/pnj8MPa8LYA/8CRluHudRUzvPuvYK0ofU1OLP6EbMea6UWy9qPV4IvpA80IXMWf4
	CuvJ9pa7wJaIadGmoDX7/s3HjhHiaDo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-UHN8XmceNhG8w14WNhQxuw-1; Tue,
 03 Mar 2026 03:34:08 -0500
X-MC-Unique: UHN8XmceNhG8w14WNhQxuw-1
X-Mimecast-MFC-AGG-ID: UHN8XmceNhG8w14WNhQxuw_1772526844
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63C481956048;
	Tue,  3 Mar 2026 08:34:04 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6964219560A2;
	Tue,  3 Mar 2026 08:33:54 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: lucien.xin@gmail.com
Cc: hepengtao@xiaomi.com,
	kuba@kernel.org,
	jlayton@kernel.org,
	metze@samba.org,
	davem@davemloft.net,
	kernel-tls-handshake@lists.linux.dev,
	horms@kernel.org,
	hare@suse.de,
	aahringo@redhat.com,
	tfanelli@redhat.com,
	mail@johnericson.me,
	andrew.gospodarek@broadcom.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	matttbe@kernel.org,
	xiyou.wangcong@gmail.com,
	dreibh@simula.no,
	jbaron@akamai.com,
	quic@lists.linux.dev,
	pc@manguebit.com,
	marc@fiuczynski.com,
	edumazet@google.com,
	pabeni@redhat.com,
	alibuda@linux.alibaba.com,
	steved@redhat.com,
	illiliti@protonmail.com,
	tom@talpey.com,
	marcelo.leitner@gmail.com,
	sd@queasysnail.net,
	linux-cifs@vger.kernel.org,
	netdev@vger.kernel.org,
	mbuhl@openbsd.org,
	smfrench@gmail.com,
	chuck.lever@oracle.com,
	daniel@haxx.se
Subject: Re: [net-next,v10,15/15] quic: add packet parser base
Date: Tue,  3 Mar 2026 09:33:51 +0100
Message-ID: <20260303083351.35558-1-pabeni@redhat.com>
In-Reply-To: <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
References: <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
quic: add packet parser base

This patch uses 'quic_packet' to handle packing of QUIC packets on the
receive (RX) path. It introduces mechanisms to parse the ALPN from
client Initial packets to determine the correct listener socket.
Received packets are then routed and processed accordingly.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index a56edc745bb1..a23ce99a6656 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c

[ ... ]

> +/* Extract the Destination Connection ID (DCID) from a QUIC Long header packet. */
> +int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *skb)
> +{
> +	u32 plen = skb->len;
> +	u8 *p = skb->data;
> +	u64 len;
> +
> +	if (plen < QUIC_HLEN + QUIC_VERSION_LEN)
> +		return -EINVAL;
> +	plen -= (QUIC_HLEN + QUIC_VERSION_LEN);
> +	p += (QUIC_HLEN + QUIC_VERSION_LEN);
> +
> +	if (!quic_get_int(&p, &plen, &len, 1) ||
> +	    len > plen || len > QUIC_CONN_ID_MAX_LEN)
> +		return -EINVAL;
> +	quic_conn_id_update(dcid, p, len);
> +	return 0;
> +}

This parsing logic looks nearly identical to what's already in
quic_packet_get_version_and_connid().  Both skip QUIC_HLEN +
QUIC_VERSION_LEN, read the length byte, validate against
QUIC_CONN_ID_MAX_LEN, and call quic_conn_id_update().

Could quic_packet_get_dcid() call quic_packet_get_version_and_connid()
with dummy parameters, or could both share a helper to extract just the
DCID portion?

> diff --git a/net/quic/path.c b/net/quic/path.c
> index 9414c4f813c5..655f38af4107 100644
> --- a/net/quic/path.c
> +++ b/net/quic/path.c
> @@ -17,6 +17,8 @@
>  #include "family.h"
>  #include "path.h"
>
> +extern int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 err);

Could this include packet.h instead? The canonical declaration already
exists in packet.h (after this patch). Using 'extern' here creates a
duplicate signature.

If the signature in packet.h changes later, this extern could silently
become stale depending on calling conventions. Since packet.h has no
include directives and wouldn't create a circular dependency, including
it would keep the declaration in sync.

> +
>  static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
>  {
>  	memset(skb->cb, 0, sizeof(skb->cb));

