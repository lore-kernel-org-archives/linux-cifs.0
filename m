Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED4433F8BA
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769703640; cv=none; b=IL4JwryFutLt4uK3Y2SIy5F+MCfix55DghgLFVpSzd6rRocyCWw7yLsaQuifi63pKfrDA7YwzUJlwKD7e2JpJjj6sAieD2vVnbbXPKtpb+Ag71tIqKbEt4T36MKDRigh0J1k64Ii91SdIMKeJcOXtav1lOhuznfCe3VdfrYO8Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769703640; c=relaxed/simple;
	bh=G/Xf9G1ti577G+bBblG0MUwFPwZ9vzAAm3ze1AAlLbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNQa4bROUIYE93uW5VUeDqr2dZAh+yhUfkUGdOaYZ0e//3WvS73tOQvl526pMtDqXeyukAY7s9QalEHEQxW3Umjrx9K11uuoYVSBTJtTFPbXrUhZveGdVKyo+DZfNftgZemn3Mjnqa4DC5lzf9mQ5ysVU6/Ihj+raP7PH0OhCTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dDlhcAy4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=d4dvgZ/5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDlhcAy4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4dvgZ/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769703637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TkAH62E02KTShvHQ/Vaw4buCmlxPxGf9ryljHEUHAo=;
	b=dDlhcAy4AVXAOtccdJanWLFgyzRqK/7As+Ti9f1Z9nSnhKgOcCxGopvFdUUhBaV6nun9Xh
	5oNhmj7xFSk46jEMilX3qSO5DLDaLFzwjrwr9WcUFaYaautA9+Ym97oWcNJJLX2Si+G0YM
	MfLxoRsTJYi5Y979hQMsds0xlLqQIuE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-0uQ60QgdMhS8z-ZSvEZEkw-1; Thu, 29 Jan 2026 11:20:36 -0500
X-MC-Unique: 0uQ60QgdMhS8z-ZSvEZEkw-1
X-Mimecast-MFC-AGG-ID: 0uQ60QgdMhS8z-ZSvEZEkw_1769703635
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4802bb29400so17440405e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 08:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769703635; x=1770308435; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4TkAH62E02KTShvHQ/Vaw4buCmlxPxGf9ryljHEUHAo=;
        b=d4dvgZ/5xdLKBJ1SSTBfjjc+kv2/87hB5GjCwbxfMNFpfXlEgAeYO/9bBIEotO8hwR
         ISR5zUpCbPpq/Rro34z//M9v8wPmnyM0+9h1qjZUEho/MjJF76195fflV9xhUvI23BQI
         5ckNIT6xHqhQ5VnYQDzcv+QrMd5lOlqfpzKpep50NySFiu57E7dVVS9/ch4eKW7vZ9oA
         0RbkwL+LNxvFn8DnKZhpLqQYQd98JAM2xobkXPP5zStkVgSOTDBdB5u7dRsMJo7nC4H3
         EIzqIlvufJ3ogZWjAswdmRuj7r7KW0DoRbeNgPCK56a42PyAACOmZgNKTHsvvwt98sWb
         y3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769703635; x=1770308435;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4TkAH62E02KTShvHQ/Vaw4buCmlxPxGf9ryljHEUHAo=;
        b=VCqgbh87fbi04DwukIGqKJ8BETrRXsUUbwPRWUO4u4Q3fyV/IG4mUNE53hZDUw/bgV
         GhBXiGhR9wr23ntv6NID1Rz7ax2zekKZeJMTU09qFFBnrJNfxSXtks4ZRQpl2NWpzNDL
         BxnQPBWcVIyKLxk3Eotw/Vg7+/1zn1UjvJFW6I3g4+mty8fd8OYuct0f9q6gtuR1EqnT
         k0PIdS3jI3tXioaxHYyeBgaUltldPbjHH6cnjScI3hLKiXRXl5+KcfSh9ieEs7b3fMp1
         ND/JO6U10iu0jAB0TsVv7Z1dZLHdHDOmNxWWLPNP9uxA7kGLqfO3hixazbqlb02g1XDE
         2tbw==
X-Forwarded-Encrypted: i=1; AJvYcCU1x4FAXA0dEn4UxIQ3rku2OQOVMq1qUTXHTuQ91KMFbk1DxoVZDQRQTQs9hxLUsE9Jnjq/JFYMqZFl@vger.kernel.org
X-Gm-Message-State: AOJu0YzsM7BsepRqIC/aP91LrRUFmpnMkWZfcPEwaaS+tjqHI5+4D4lz
	LU/ZfZete38rSL2avxZH/ca/+7pHjI+Edudm4h6qw4yMRIYhviJGR2z8JM5aLftVDI0JoiY70IC
	EbRZCCNHDEJIQuM+rs8g6av6Ls/Lzlvw65umV18stNYPbswQV41Nk13zKju0HTuk=
X-Gm-Gg: AZuq6aK7g6GOFHQ3oNsj80cGD6Uh5DGhkN/urN82RUmvvXTJbnuOKoaZAMJW0Ng+fQx
	5bAqlgyBkyuhusElb1cqvmOID0HDjol8Q7lBs13f3Gtd5cJ5w2G0rJR8yt4UOZdZuq7BkoORH5Z
	fRQeFFmUbienRA95/lsbYAs6sMDhvdCjEhQksUdNE+Dc3Ly7DkqaPtAYF+aAFx2aDRinaOh9Kix
	Ayym11zF5g33g6Gr1t4Ea5/SWqzBV4Igcd9wAss5YQI0lj6mTJYUCO8vj+rlwxFl4K171H6g908
	EbFYTwAltnyzPCnGWouJObLBI3lXB3h4xtP7twn+yICEHWoD956b7xyWVMSAYfWuz+3bvous2Gl
	XPzTb16sFg+SW
X-Received: by 2002:a05:600c:8b22:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-48069c2335cmr143437845e9.16.1769703634799;
        Thu, 29 Jan 2026 08:20:34 -0800 (PST)
X-Received: by 2002:a05:600c:8b22:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-48069c2335cmr143437275e9.16.1769703634240;
        Thu, 29 Jan 2026 08:20:34 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5dab86asm281675e9.6.2026.01.29.08.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 08:20:33 -0800 (PST)
Message-ID: <a7b64f16-5ca9-4344-b7e8-c0d4508e43cc@redhat.com>
Date: Thu, 29 Jan 2026 17:20:31 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 08/15] quic: add path management
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
 <2367f77787fa0a29913f48c91087397dcc82c35f.1769439073.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <2367f77787fa0a29913f48c91087397dcc82c35f.1769439073.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 3:51 PM, Xin Long wrote:
> This patch introduces 'quic_path_group' for managing paths, represented
> by 'struct quic_path'. A connection may use two paths simultaneously
> for connection migration.
> 
> Each path is associated with a UDP tunnel socket (sk), and a single
> UDP tunnel socket can be related to multiple paths from different sockets.
> These UDP tunnel sockets are wrapped in 'quic_udp_sock' structures and
> stored in a hash table.
> 
> It includes mechanisms to bind and unbind paths, detect alternative paths
> for migration, and swap paths to support seamless transition between
> networks.
> 
> - quic_path_bind(): Bind a path to a port and associate it with a UDP sk.
> 
> - quic_path_unbind(): Unbind a path from a port and disassociate it from a
>   UDP sk.
> 
> - quic_path_swap(): Swap two paths to facilitate connection migration.
> 
> - quic_path_detect_alt(): Determine if a packet is using an alternative
>   path, used for connection migration.
> 
>  It also integrates basic support for Packetization Layer Path MTU
> Discovery (PLPMTUD), using PING frames and ICMP feedback to adjust path
> MTU and handle probe confirmation or resets during routing changes.
> 
> - quic_path_pl_recv(): state transition and pmtu update after the probe
>   packet is acked.
> 
> - quic_path_pl_toobig(): state transition and pmtu update after
>   receiving a toobig or needfrag icmp packet.
> 
> - quic_path_pl_send(): state transition and pmtu update after sending a
>   probe packet.
> 
> - quic_path_pl_reset(): restart the probing when path routing changes.
> 
> - quic_path_pl_confirm(): check if probe packet gets acked.
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v3:
>   - Fix annotation in quic_udp_sock_lookup() (noted by Paolo).
>   - Use inet_sk_get_local_port_range() instead of
>     inet_get_local_port_range() (suggested by Paolo).
>   - Adjust global UDP tunnel socket hashtable operations for the new
>     hashtable type.
>   - Delete quic_workqueue; use system_wq for UDP tunnel socket destroy.
> v4:
>   - Cache UDP tunnel socket pointer and its source address in struct
>     quic_path for RCU-protected lookup/access.
>   - Return -EAGAIN instead of -EINVAL in quic_path_bind() when UDP
>     socket is being released in workqueue.
>   - Move udp_tunnel_sock_release() out of the mutex_lock to avoid a
>     warning of lockdep in quic_udp_sock_put_work().
>   - Introduce quic_wq for UDP socket release work, so all pending works
>     can be flushed before destroying the hashtable in quic_exit().
> v5:
>   - Rename quic_path_free() to quic_path_unbind() (suggested by Paolo).
>   - Remove the 'serv' member from struct quic_path_group, since
>     quic_is_serv() defined in a previous patch now uses
>     sk->sk_max_ack_backlog for server-side detection.
>   - Use quic_ktime_get_us() to set skb_cb->time, as RTT is measured
>     in microseconds and jiffies_to_usecs() is not accurate enough.
> v6:
>   - Do not reset transport_header for QUIC in quic_udp_rcv(), allowing
>     removal of udph_offset and enabling access to the UDP header via
>     udp_hdr(); Pull skb->data in quic_udp_rcv() to allow access to the
>     QUIC header via skb->data.
> v7:
>   - Pass udp sk to quic_path_rcv() and move the call to skb_linearize()
>     and skb_set_owner_sk_safe() to .quic_path_rcv().
>   - Delete the call to skb_linearize() and skb_set_owner_sk_safe() from
>     quic_udp_err(), as it should not change skb in .encap_err_lookup()
>     (noted by AI review).
> v8:
>   - Remove indirect quic_path_rcv and late call quic_packet_rcv()
>     directly via extern (noted by Paolo).
>   - Add a comment in quic_udp_rcv() clarifying it must return 0.
>   - Add a comment in quic_udp_sock_put() clarifying the UDP socket
>     may be freed in atomic RX context during connection migration.
>   - Reorder some quic_path_group members to reduce struct size.
> ---
>  net/quic/Makefile   |   2 +-
>  net/quic/path.c     | 520 ++++++++++++++++++++++++++++++++++++++++++++
>  net/quic/path.h     | 170 +++++++++++++++
>  net/quic/protocol.c |  11 +
>  net/quic/socket.c   |   3 +
>  net/quic/socket.h   |   7 +
>  6 files changed, 712 insertions(+), 1 deletion(-)
>  create mode 100644 net/quic/path.c
>  create mode 100644 net/quic/path.h
> 
> diff --git a/net/quic/Makefile b/net/quic/Makefile
> index eee7501588d3..1565fb5cef9d 100644
> --- a/net/quic/Makefile
> +++ b/net/quic/Makefile
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_IP_QUIC) += quic.o
>  
> -quic-y := common.o family.o protocol.o socket.o stream.o connid.o
> +quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o
> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 000000000000..9556607a009e
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,520 @@
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
> +static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
> +{
> +	memset(skb->cb, 0, sizeof(skb->cb));
> +	QUIC_SKB_CB(skb)->seqno = -1;
> +	QUIC_SKB_CB(skb)->time = quic_ktime_get_us();
> +
> +	skb_pull(skb, sizeof(struct udphdr));
> +	skb_dst_force(skb);
> +	kfree_skb(skb);
> +	return 0; /* .encap_rcv must return 0 if skb was either consumed or dropped. */
> +}
> +
> +static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
> +{
> +	return 0;
> +}
> +
> +static void quic_udp_sock_put_work(struct work_struct *work)
> +{
> +	struct quic_udp_sock *us = container_of(work, struct quic_udp_sock, work);
> +	struct quic_uhash_head *head;
> +	struct sock *sk = us->sk;
> +
> +	/* Hold the sock to safely access it in quic_udp_sock_lookup() even after
> +	 * udp_tunnel_sock_release(). The release must occur before __hlist_del()
> +	 * so a new UDP tunnel socket can be created for the same address and port
> +	 * if quic_udp_sock_lookup() fails to find one.
> +	 *
> +	 * Note: udp_tunnel_sock_release() cannot be called under the mutex due to
> +	 * some lockdep warnings.
> +	 */
> +	sock_hold(sk);
> +	udp_tunnel_sock_release(sk->sk_socket);
> +
> +	head = quic_udp_sock_head(sock_net(sk), ntohs(us->addr.v4.sin_port));
> +	mutex_lock(&head->lock);
> +	__hlist_del(&us->node);
> +	mutex_unlock(&head->lock);
> +
> +	sock_put(sk);
> +	kfree(us);
> +}
> +
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

Possibly you need to adjust UDP_MAX_TUNNEL_TYPES in udp_offload.c. You
could check running a kernel with QUIC enabled and geneve, vxlan, FOU
and xfrm disabled.

> +
> +	refcount_set(&us->refcnt, 1);
> +	us->sk = sock->sk;
> +	memcpy(&us->addr, a, sizeof(*a));
> +	us->bind_ifindex = sk->sk_bound_dev_if;
> +
> +	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
> +	hlist_add_head(&us->node, &head->head);
> +	INIT_WORK(&us->work, quic_udp_sock_put_work);

Is unclear to me if quick udp socket lookup be done locklessy with
future series?

/P

