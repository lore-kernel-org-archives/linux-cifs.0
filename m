Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D30B321F4C
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758625658; cv=none; b=Q65uO1m3GKl6b4bcJL42wba7uJ/w+IfgM3ssEF3yCjR7pipXpA/yLiYXyr+I3lWW4rNxkrS6NWKje66BPc+OcNurmR1mWr25Qcs7Ndev6B7jplfKaRsvni0+3U1dOUxse1YtoZ3WIT7G77FdP/7sqvtQaiWYmqIpsdQm6bSMPZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758625658; c=relaxed/simple;
	bh=UmbTsquAUMinpPwTpCPJxW3SPvEozfbyjpEYZQMalA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iE5BbaoLZXDiIMF/flHXNu5cL4K6ZcTdDdGaAs6fw8PA8lvjhx7IDLQt3F2kaUKzOGYgK2bU0+emoS+fK6XL9QDk8pvwjoDOke+2kkgppUpxa3JSivTpBXqSAI/YzmchHTF4H2OGaTzaZz2ohMpMGbje96k9VOkI7vPRKCFikDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfGgsiyW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfGgsiyW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758625655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wzOBhyw0VdH6DHC7wg7R415fxU0fgQEUqv8xb9rt14=;
	b=PfGgsiyWJHk/cV8K67eNTOIVlP7r3j5pZmHYIM0kd/X2qnuPREU8IHKFl7nHSkMDum5Mw7
	f6CrRTvzaNErY1/g5BearjBw0CTA2+2i0udndcOsEvDj2HR5h/rW5k2c2JHbODL70XS1RW
	ejRpZ1AHAUTGto1q/3siWyDq5TtZe6I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-rOSA11QoP4CG3qCrX5clAQ-1; Tue, 23 Sep 2025 07:07:33 -0400
X-MC-Unique: rOSA11QoP4CG3qCrX5clAQ-1
X-Mimecast-MFC-AGG-ID: rOSA11QoP4CG3qCrX5clAQ_1758625653
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdfe971abso6479847f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 04:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758625652; x=1759230452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wzOBhyw0VdH6DHC7wg7R415fxU0fgQEUqv8xb9rt14=;
        b=u7zfwlQBt4P7ayJnKJbOZnj/JzcXTwn9ezS8NgWwyFsM7v4lfCEiKKpogaQBDuwTYQ
         58jM6oNSEO4nnY8NmoLKovlUz4W6+jyrWwHs6F13M65GWVrqS8kGB8Zb1ttW78RSDKOp
         1u13XnuQ43KL5hCFAm8qZvKGZAHMwbUgjr8tr5UMuF4hK0cHFdjRGM4fCFJRS8GZ6HYD
         X/9HRcAjL6f+XQrfZICx+WWcR6crzn0JbBHBp8nAV+8Ns6eGK956eRN1lVw63IHwmDR9
         PPmuVq8Kahprx6UhcWIdFFZdTEbauJHGQRt0LJczjP2dvB8qb1f6t1o5CwU8LROUsMYB
         1LBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVTXiGsXNaUQppDhnXuOuSIj00S32WQqSMeRWoDfrok/+2BepspR4tfVYE9vMFfkT1Z2qnX7b+PLmp@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxc/rj4/7ok/Gtx5FLEvigQfGHkytdaXt/CmzOXJstZRQTmotb
	LgWp+ogvX58chfWWp9w6ukxnlJfeSTcAuw6iCmFHzhZzc6C+1AzOnHxjhGjMYiSpzOrOgcMJQZA
	Sj8f84bn5m2Ihd6vpUbhbHfTCEgq76HDUoJKxgyjZtitaOZCGkUT1xVgzTsO2PRg=
X-Gm-Gg: ASbGncsUXRbupYBwhliszzNHIkwDtnyqJu26WO8xm5MZ99aTUZqENUWTAxvWcYl4G9k
	vQhC0uOR6b/H9sZkLb+n1Wa8pKwoM9bgE0nha+34B8FnwOV5ylxovZCXrZ2JmXb6628Uts0X5xF
	wKXNR01j/ZSrx+d0Nug81LLeiefkttHKPrOgeWbSBWPALtV8GIsLQSuB/cwedUl7mKnXRcubHDd
	YfwppVPWeHhkHxriQfT+lvZb4GfbCZG58kB3JLaXeb2rezUPz6Jw7bszFPPk61MGVrT1+AJ+d7i
	Pf/Ui7LVsGy6vlmpYVzzTKr5X2jXHiBWkh17B+ZT+KrSG/68zTtfgpUc/dqqP8xB3GL3J99f45T
	60eYjUXdD2nrI
X-Received: by 2002:a05:6000:2512:b0:3ec:ce37:3a6a with SMTP id ffacd0b85a97d-405c59e17a9mr1491810f8f.22.1758625652559;
        Tue, 23 Sep 2025 04:07:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiNVrh1Vb4Z2SR9W3OxoavNX4r+DNnG1BTKk7kY4JP8xc64yZnQmJJOmaVmCkqxRBWoAYFjQ==
X-Received: by 2002:a05:6000:2512:b0:3ec:ce37:3a6a with SMTP id ffacd0b85a97d-405c59e17a9mr1491754f8f.22.1758625652064;
        Tue, 23 Sep 2025 04:07:32 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407fa3sm23492432f8f.21.2025.09.23.04.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 04:07:31 -0700 (PDT)
Message-ID: <7fa38c12-eece-45ae-87b2-da1445c62134@redhat.com>
Date: Tue, 23 Sep 2025 13:07:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 02/15] net: build socket infrastructure for
 QUIC protocol
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
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
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <b55a2141a1d5aa31cd57be3d22bb8a5f8d40b7e2.1758234904.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <b55a2141a1d5aa31cd57be3d22bb8a5f8d40b7e2.1758234904.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 12:34 AM, Xin Long wrote:
> This patch lays the groundwork for QUIC socket support in the kernel.
> It defines the core structures and protocol hooks needed to create
> QUIC sockets, without implementing any protocol behavior at this stage.
> 
> Basic integration is included to allow building the module via
> CONFIG_IP_QUIC=m.
> 
> This provides the scaffolding necessary for adding actual QUIC socket
> behavior in follow-up patches.
> 
> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v3:
>   - Kconfig: add 'default n' for IP_QUIC (reported by Paolo).
>   - quic_disconnect(): return -EOPNOTSUPP (suggested by Paolo).
>   - quic_init/destroy_sock(): drop local_bh_disable/enable() calls (noted
>     by Paolo).
>   - sysctl: add alpn_demux option to en/disable ALPN-based demux.
>   - SNMP: remove SNMP_MIB_SENTINEL, switch to
>     snmp_get_cpu_field_batch_cnt() to align with latest net-next changes.
> ---
>  net/Kconfig         |   1 +
>  net/Makefile        |   1 +
>  net/quic/Kconfig    |  36 +++++
>  net/quic/Makefile   |   8 +
>  net/quic/protocol.c | 379 ++++++++++++++++++++++++++++++++++++++++++++
>  net/quic/protocol.h |  56 +++++++
>  net/quic/socket.c   | 207 ++++++++++++++++++++++++
>  net/quic/socket.h   |  79 +++++++++
>  8 files changed, 767 insertions(+)
>  create mode 100644 net/quic/Kconfig
>  create mode 100644 net/quic/Makefile
>  create mode 100644 net/quic/protocol.c
>  create mode 100644 net/quic/protocol.h
>  create mode 100644 net/quic/socket.c
>  create mode 100644 net/quic/socket.h
> 
> diff --git a/net/Kconfig b/net/Kconfig
> index d5865cf19799..1205f5b7cf59 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -249,6 +249,7 @@ source "net/bridge/netfilter/Kconfig"
>  
>  endif # if NETFILTER
>  
> +source "net/quic/Kconfig"
>  source "net/sctp/Kconfig"
>  source "net/rds/Kconfig"
>  source "net/tipc/Kconfig"
> diff --git a/net/Makefile b/net/Makefile
> index aac960c41db6..7c6de28e9aa5 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_PHONET)		+= phonet/
>  ifneq ($(CONFIG_VLAN_8021Q),)
>  obj-y				+= 8021q/
>  endif
> +obj-$(CONFIG_IP_QUIC)		+= quic/
>  obj-$(CONFIG_IP_SCTP)		+= sctp/
>  obj-$(CONFIG_RDS)		+= rds/
>  obj-$(CONFIG_WIRELESS)		+= wireless/
> diff --git a/net/quic/Kconfig b/net/quic/Kconfig
> new file mode 100644
> index 000000000000..1f10a452b3a1
> --- /dev/null
> +++ b/net/quic/Kconfig
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# QUIC configuration
> +#
> +
> +menuconfig IP_QUIC
> +	tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Experimental)"
> +	depends on INET
> +	depends on IPV6
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_HKDF
> +	select CRYPTO_AES
> +	select CRYPTO_GCM
> +	select CRYPTO_CCM
> +	select CRYPTO_CHACHA20POLY1305
> +	select NET_UDP_TUNNEL
> +	default n
> +	help
> +	  QUIC: A UDP-Based Multiplexed and Secure Transport
> +
> +	  From rfc9000 <https://www.rfc-editor.org/rfc/rfc9000.html>.
> +
> +	  QUIC provides applications with flow-controlled streams for structured
> +	  communication, low-latency connection establishment, and network path
> +	  migration.  QUIC includes security measures that ensure
> +	  confidentiality, integrity, and availability in a range of deployment
> +	  circumstances.  Accompanying documents describe the integration of
> +	  TLS for key negotiation, loss detection, and an exemplary congestion
> +	  control algorithm.
> +
> +	  To compile this protocol support as a module, choose M here: the
> +	  module will be called quic. Debug messages are handled by the
> +	  kernel's dynamic debugging framework.
> +
> +	  If in doubt, say N.
> diff --git a/net/quic/Makefile b/net/quic/Makefile
> new file mode 100644
> index 000000000000..020e4dd133d8
> --- /dev/null
> +++ b/net/quic/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# Makefile for QUIC support code.
> +#
> +
> +obj-$(CONFIG_IP_QUIC) += quic.o
> +
> +quic-y := protocol.o socket.o
> diff --git a/net/quic/protocol.c b/net/quic/protocol.c
> new file mode 100644
> index 000000000000..f79f43f0c17f
> --- /dev/null
> +++ b/net/quic/protocol.c
> @@ -0,0 +1,379 @@
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
> +#include <net/inet_common.h>
> +#include <linux/proc_fs.h>
> +#include <net/protocol.h>
> +#include <net/rps.h>
> +#include <net/tls.h>
> +
> +#include "socket.h"
> +
> +static unsigned int quic_net_id __read_mostly;
> +
> +struct percpu_counter quic_sockets_allocated;
> +
> +long sysctl_quic_mem[3];
> +int sysctl_quic_rmem[3];
> +int sysctl_quic_wmem[3];
> +int sysctl_quic_alpn_demux;
> +
> +static int quic_inet_connect(struct socket *sock, struct sockaddr *addr, int addr_len, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	const struct proto *prot;
> +
> +	if (addr_len < (int)sizeof(addr->sa_family))
> +		return -EINVAL;
> +
> +	prot = READ_ONCE(sk->sk_prot);

Is the above _ONCE() annotation for ADDRFORM's sake? If so it should not
be needed (only UDP and TCP sockets are affected).

> diff --git a/net/quic/socket.h b/net/quic/socket.h
> new file mode 100644
> index 000000000000..ded8eb2e6a9c
> --- /dev/null
> +++ b/net/quic/socket.h
> @@ -0,0 +1,79 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <net/udp_tunnel.h>
> +
> +#include "protocol.h"
> +
> +extern struct proto quic_prot;
> +extern struct proto quicv6_prot;
> +
> +enum quic_state {
> +	QUIC_SS_CLOSED		= TCP_CLOSE,
> +	QUIC_SS_LISTENING	= TCP_LISTEN,
> +	QUIC_SS_ESTABLISHING	= TCP_SYN_RECV,
> +	QUIC_SS_ESTABLISHED	= TCP_ESTABLISHED,
> +};

Any special reason to define protocol-specific states? I guess you could
re-use the TCP ones, as other protocols already do.

/P

