Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C39B36DA1D
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 08:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526840; cv=none; b=UvZllpolWqRueNaKo726ekFqPFXZP9+fRd0oRo0BM9EQ39fXv9UxxaPvzAGL2x/NCSO1lzMHDNEg2W5GJh/1E6gfw1wdBEW39mNkQ4eDKx2dk6QEaKX08FkrBZ/3Tfecpbsl1867aUiuQFjMR+smzaPkBiqqNTt/G5WiTYrV9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526840; c=relaxed/simple;
	bh=ZXBhN3fvM6cgBMN2UiwYKLCLU+IWWPTUpcXxsrjaxDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6Bi/pTlMEwr9zzD3AZP8ViEYDv50zaNPmwWtxsU6ufeBYZ6PHoeQ4I2eO/ks2s9OryqmKk89zVF2ecxj4sg84UOcgGXBZjr0CBHrYKx2Qk72w42rbRpK2Jis3xZFANgpKFN0RktGIsTftJ9Ty9qAaEoluLY5q6KNIagrExylEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORKIPtam; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORKIPtam"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772526838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+n3C6EGPxvSt3Rgl6vkaTvXwcCH/3QpnO5pBFLGRLc=;
	b=ORKIPtama3NXeDcDF4HtumGfG2ImhKfzdKPbjtgXcOYbWot1N0qMsgkCF1grUQ7cmIzUau
	sFsOKbAuH1P9MILsZiA1YStyWe2ONDnuYviKrdKHVGH4YYSRmNXaIFPRDyV44FnfZ9CRDx
	jDxbIv49GZFuFwAsTMQZ8dmVyO2b93Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-wFlWTGnANrmdJp4L7vXSTA-1; Tue,
 03 Mar 2026 03:33:55 -0500
X-MC-Unique: wFlWTGnANrmdJp4L7vXSTA-1
X-Mimecast-MFC-AGG-ID: wFlWTGnANrmdJp4L7vXSTA_1772526832
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FF671956096;
	Tue,  3 Mar 2026 08:33:51 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.134])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CC161800349;
	Tue,  3 Mar 2026 08:33:41 +0000 (UTC)
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
Subject: Re: [net-next,v10,14/15] quic: add packet builder base
Date: Tue,  3 Mar 2026 09:33:38 +0100
Message-ID: <20260303083338.35544-1-pabeni@redhat.com>
In-Reply-To: <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
References: <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
quic: add packet builder base

This patch introduces 'quic_packet' to handle packing of QUIC packets on
the transmit path, including frame packing, packet construction,
encryption, bundling, and transmission logic.

> diff --git a/net/quic/Makefile b/net/quic/Makefile
> index 2ccf01ad9e22..0f903f4a7ff1 100644
> --- a/net/quic/Makefile
> +++ b/net/quic/Makefile
> @@ -6,4 +6,4 @@
>  obj-$(CONFIG_IP_QUIC) += quic.o
>
>  quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
> -	  cong.o pnspace.o crypto.o timer.o
> +	  cong.o pnspace.o crypto.o timer.o packet.o
> diff --git a/net/quic/packet.c b/net/quic/packet.c
> new file mode 100644
> index 000000000000..a56edc745bb1
> --- /dev/null
> +++ b/net/quic/packet.c

[ ... ]

> +/* Perform routing for the QUIC packet on the specified path, update header length and MSS
> + * accordingly, reset path and start PMTU timer.
> + */
> +int quic_packet_route(struct sock *sk)
> +{
> +	struct quic_path_group *paths = quic_paths(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	union quic_addr *sa, *da;
> +	u32 pmtu;
> +	int err;
> +
> +	da = quic_path_daddr(paths, packet->path);
> +	sa = quic_path_saddr(paths, packet->path);
> +	err = quic_flow_route(sk, da, sa, &paths->fl);
> +	if (err)
> +		return err;
> +
> +	packet->hlen = quic_encap_len(da);
> +	pmtu = min_t(u32, dst_mtu(__sk_dst_get(sk)), QUIC_PATH_MAX_PMTU);
> +	quic_packet_mss_update(sk, pmtu - packet->hlen);
> +
> +	quic_path_pl_reset(paths);
> +	quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
> +	return 0;
> +}
> +
> +/* Configure the QUIC packet header and routing based on encryption level and path. */
> +int quic_packet_config(struct sock *sk, u8 level, u8 path)
> +{

[ ... ]

> +
> +	/* Perform routing and MSS update for the configured packet. */
> +	if (quic_packet_route(sk) < 0)
> +		return -1;
> +	return 0;
> +}

Should quic_packet_config() propagate the error code from
quic_packet_route() instead of returning -1?

The function quic_packet_route() returns proper negative errno values
(via quic_flow_route()), but quic_packet_config() replaces any error
with -1 (which is -EPERM). This could be misleading when diagnosing
routing failures.

> diff --git a/net/quic/packet.h b/net/quic/packet.h
> new file mode 100644
> index 000000000000..8c23be386207
> --- /dev/null
> +++ b/net/quic/packet.h

[ ... ]

> +static inline u8 quic_packet_taglen(struct quic_packet *packet)
> +{
> +	return packet->taglen[!!packet->level];
> +}
> +
> +static inline void quic_packet_set_taglen(struct quic_packet *packet, u8 taglen)
> +{
> +	packet->taglen[0] = taglen;
> +}
> +
> +static inline u32 quic_packet_mss(struct quic_packet *packet)
> +{
> +	return packet->mss[0] - packet->taglen[!!packet->level];
> +}
> +
> +static inline u32 quic_packet_max_payload(struct quic_packet *packet)
> +{
> +	return packet->mss[0] - packet->overhead - packet->taglen[!!packet->level];
> +}
> +
> +static inline u32 quic_packet_max_payload_dgram(struct quic_packet *packet)
> +{
> +	return packet->mss[1] - packet->overhead - packet->taglen[!!packet->level];
> +}

This isn't a bug, but quic_packet_mss(), quic_packet_max_payload(),
and quic_packet_max_payload_dgram() all repeat the expression
'packet->taglen[!!packet->level]'.

Could these use quic_packet_taglen(packet) instead for consistency?

[ ... ]

