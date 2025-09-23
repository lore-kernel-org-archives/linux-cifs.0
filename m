Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B45A267AF6
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758642439; cv=none; b=q3+6xqF7EBil9OsaUZLPznSNoaCiTMu/HugNi7e3VYqzaqmCIu5XYSs4fn5XDm35kSvh3mjW9Jlptc6mUJo75WscSpIRKdnqYEKcnFdZcwKMgbWCLTgh99/owlyuLBhII3yEVT7KLzm/FsIqdISjzrxfmDPYC7JXjxtaurc3PuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758642439; c=relaxed/simple;
	bh=9p9i27tUyKdfKZGTPyYzDE0lmLfpf9V2AqPccZf7Pk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=diq+3W3PWIjrcD0smHPC3j2gRiQM+rq3EJF/vbiQMfpPL0SYjvjPQSOXr5RcxRCUJQIQcvbmSf84lufHjMbro0B2VKj/tLtRtYmN7iqdAFmBT5M6ILIEb5b06NulRbDZwApKdt2+Q5GljNlkEv6ZezAoqIkX+SyjoRhw2INWPOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ix6wTGDi; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ix6wTGDi"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77f0efd84abso2954480b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 08:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758642437; x=1759247237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhpqH9TkrxXvAreo6l0vcwYoZQHmwa+llxfXYxYt+Qw=;
        b=ix6wTGDilNGc1K4rw7gocrP1y88Q66X2sR1hqEuy1ptYN+RNCgCLwyForI1KEQxBAh
         /NcYxuiutgGJA9QvwrAUzUjYHnPzYmJia+WnCChCWdDlxzb1BCPg86Mg6UTA0mHL49ZH
         pozNZRYZeUfDhPjOed18wNKBH2WUNETLrfdRCD9GLxXP0q6Wlw2EgWjWfu+CXZwWeLN/
         xJKUnYEUxRjCcDArYO5C7p3Wqj2Lj8gMnKBX/7A0p/GZB0+VF6siiFPpS40nNArhjioK
         MNr/n4B/ogLY26u5o2FLX5RmnUxT4AHp/j3lsHnWo45Q7xTWxSTRPXsoDCyCc6/WLY0P
         UDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758642437; x=1759247237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhpqH9TkrxXvAreo6l0vcwYoZQHmwa+llxfXYxYt+Qw=;
        b=c+d/KTmsgjP8XM6Qehmw4lLtSHwi5cK7xyOrM2Wc/qMtquMzXK8KOBnjNDVQBreGyj
         EbtJowKs3e5F+6ukFp2W9a7R3MMeLekhlzraVttI23eUL0VNDhXpeaAbrBxpMhU4j0TF
         3HKrumnuxYRmDN02uzRhnBuYc11sDw/uA6El9rPe+sq4OiKm5insqlhuFpU3rJ7Zlro3
         lLUwHKRLh1d5xqo/NNg8SffxY0w4svZ27GZdD4KGAOENJOIU/sizC3ErKaTKOwCuN6E6
         Q1V3aveffaY4jvNdQ11oaUALx9DKnIIndGKcV/bM7v13ybF8QSdHLeVIKVJ48UmAp/K0
         Mt5A==
X-Forwarded-Encrypted: i=1; AJvYcCX5k9ax2VyyFqz1OT3kcP8IjYpu33kzBPnwOe6l9Scf/0KexMReRLnOo85nQQKMSZ8ob+GqZUbCaOCo@vger.kernel.org
X-Gm-Message-State: AOJu0YwE67YdW6oQPZv5sO4rNlwtm2CmRgWMlMcQMDi9Qt5xZVsxMUCX
	gma49A2zbYyDifE4wR+ZP1iTtt/5Es5ElTZ423xvfsFfXndKWxlKD7JGvP7NOFBjqUXTLvGlwU0
	Of/gd9gIn6gQc2hNQunTsBWdSNW3nYRw=
X-Gm-Gg: ASbGnctrGfzrq0csmrpzaViPrYlqkfWG69P+ltTtZdfDx9aSTmuRUp+y4C572d4Yzkr
	Xr/Y7eiADnjTUtsT5kDKRwajbR40phW7wCp9ZXUiENrOIGOMNcAtOKFt0AsJ8Bk9Q4bWQynkLGO
	1Pt9eFEL5lw1saS0AKy2+ucnyVeUL4RBcj1GlPXOxADGLmIrk39ofvkHZaY8nOsBpVuUyLWkBPQ
	eTb4Eh05ceI9pc3cahJJnDNHWRW32p3k9mvLUCfoQ==
X-Google-Smtp-Source: AGHT+IFN/oaB5/gk3KWElKiAaSQb1o1xjeVkko+CwZ/pASyULfoho/ZKUXbJLQUPfB5WBG+juhRExqZmRAnXZkeFJw0=
X-Received: by 2002:a17:902:cf07:b0:26c:bcb5:1573 with SMTP id
 d9443c01a7336-27cc7120837mr31767975ad.53.1758642437350; Tue, 23 Sep 2025
 08:47:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <b55a2141a1d5aa31cd57be3d22bb8a5f8d40b7e2.1758234904.git.lucien.xin@gmail.com>
 <7fa38c12-eece-45ae-87b2-da1445c62134@redhat.com>
In-Reply-To: <7fa38c12-eece-45ae-87b2-da1445c62134@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 11:47:05 -0400
X-Gm-Features: AS18NWDVh9Ut3oT-GZAbfWLi8dW5scSVH2ja6lUmEjpU4ERb5oyr4BIw0IFHYeE
Message-ID: <CADvbK_dxOHmDycm1D3-Ga4YSP7E2S91SQD1bdL+u2s-f+=Bkxg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 02/15] net: build socket infrastructure for
 QUIC protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 7:07=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/25 12:34 AM, Xin Long wrote:
> > This patch lays the groundwork for QUIC socket support in the kernel.
> > It defines the core structures and protocol hooks needed to create
> > QUIC sockets, without implementing any protocol behavior at this stage.
> >
> > Basic integration is included to allow building the module via
> > CONFIG_IP_QUIC=3Dm.
> >
> > This provides the scaffolding necessary for adding actual QUIC socket
> > behavior in follow-up patches.
> >
> > Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> > v3:
> >   - Kconfig: add 'default n' for IP_QUIC (reported by Paolo).
> >   - quic_disconnect(): return -EOPNOTSUPP (suggested by Paolo).
> >   - quic_init/destroy_sock(): drop local_bh_disable/enable() calls (not=
ed
> >     by Paolo).
> >   - sysctl: add alpn_demux option to en/disable ALPN-based demux.
> >   - SNMP: remove SNMP_MIB_SENTINEL, switch to
> >     snmp_get_cpu_field_batch_cnt() to align with latest net-next change=
s.
> > ---
> >  net/Kconfig         |   1 +
> >  net/Makefile        |   1 +
> >  net/quic/Kconfig    |  36 +++++
> >  net/quic/Makefile   |   8 +
> >  net/quic/protocol.c | 379 ++++++++++++++++++++++++++++++++++++++++++++
> >  net/quic/protocol.h |  56 +++++++
> >  net/quic/socket.c   | 207 ++++++++++++++++++++++++
> >  net/quic/socket.h   |  79 +++++++++
> >  8 files changed, 767 insertions(+)
> >  create mode 100644 net/quic/Kconfig
> >  create mode 100644 net/quic/Makefile
> >  create mode 100644 net/quic/protocol.c
> >  create mode 100644 net/quic/protocol.h
> >  create mode 100644 net/quic/socket.c
> >  create mode 100644 net/quic/socket.h
> >
> > diff --git a/net/Kconfig b/net/Kconfig
> > index d5865cf19799..1205f5b7cf59 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -249,6 +249,7 @@ source "net/bridge/netfilter/Kconfig"
> >
> >  endif # if NETFILTER
> >
> > +source "net/quic/Kconfig"
> >  source "net/sctp/Kconfig"
> >  source "net/rds/Kconfig"
> >  source "net/tipc/Kconfig"
> > diff --git a/net/Makefile b/net/Makefile
> > index aac960c41db6..7c6de28e9aa5 100644
> > --- a/net/Makefile
> > +++ b/net/Makefile
> > @@ -42,6 +42,7 @@ obj-$(CONFIG_PHONET)                +=3D phonet/
> >  ifneq ($(CONFIG_VLAN_8021Q),)
> >  obj-y                                +=3D 8021q/
> >  endif
> > +obj-$(CONFIG_IP_QUIC)                +=3D quic/
> >  obj-$(CONFIG_IP_SCTP)                +=3D sctp/
> >  obj-$(CONFIG_RDS)            +=3D rds/
> >  obj-$(CONFIG_WIRELESS)               +=3D wireless/
> > diff --git a/net/quic/Kconfig b/net/quic/Kconfig
> > new file mode 100644
> > index 000000000000..1f10a452b3a1
> > --- /dev/null
> > +++ b/net/quic/Kconfig
> > @@ -0,0 +1,36 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +#
> > +# QUIC configuration
> > +#
> > +
> > +menuconfig IP_QUIC
> > +     tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Exp=
erimental)"
> > +     depends on INET
> > +     depends on IPV6
> > +     select CRYPTO
> > +     select CRYPTO_HMAC
> > +     select CRYPTO_HKDF
> > +     select CRYPTO_AES
> > +     select CRYPTO_GCM
> > +     select CRYPTO_CCM
> > +     select CRYPTO_CHACHA20POLY1305
> > +     select NET_UDP_TUNNEL
> > +     default n
> > +     help
> > +       QUIC: A UDP-Based Multiplexed and Secure Transport
> > +
> > +       From rfc9000 <https://www.rfc-editor.org/rfc/rfc9000.html>.
> > +
> > +       QUIC provides applications with flow-controlled streams for str=
uctured
> > +       communication, low-latency connection establishment, and networ=
k path
> > +       migration.  QUIC includes security measures that ensure
> > +       confidentiality, integrity, and availability in a range of depl=
oyment
> > +       circumstances.  Accompanying documents describe the integration=
 of
> > +       TLS for key negotiation, loss detection, and an exemplary conge=
stion
> > +       control algorithm.
> > +
> > +       To compile this protocol support as a module, choose M here: th=
e
> > +       module will be called quic. Debug messages are handled by the
> > +       kernel's dynamic debugging framework.
> > +
> > +       If in doubt, say N.
> > diff --git a/net/quic/Makefile b/net/quic/Makefile
> > new file mode 100644
> > index 000000000000..020e4dd133d8
> > --- /dev/null
> > +++ b/net/quic/Makefile
> > @@ -0,0 +1,8 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +#
> > +# Makefile for QUIC support code.
> > +#
> > +
> > +obj-$(CONFIG_IP_QUIC) +=3D quic.o
> > +
> > +quic-y :=3D protocol.o socket.o
> > diff --git a/net/quic/protocol.c b/net/quic/protocol.c
> > new file mode 100644
> > index 000000000000..f79f43f0c17f
> > --- /dev/null
> > +++ b/net/quic/protocol.c
> > @@ -0,0 +1,379 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* QUIC kernel implementation
> > + * (C) Copyright Red Hat Corp. 2023
> > + *
> > + * This file is part of the QUIC kernel implementation
> > + *
> > + * Initialization/cleanup for QUIC protocol support.
> > + *
> > + * Written or modified by:
> > + *    Xin Long <lucien.xin@gmail.com>
> > + */
> > +
> > +#include <net/inet_common.h>
> > +#include <linux/proc_fs.h>
> > +#include <net/protocol.h>
> > +#include <net/rps.h>
> > +#include <net/tls.h>
> > +
> > +#include "socket.h"
> > +
> > +static unsigned int quic_net_id __read_mostly;
> > +
> > +struct percpu_counter quic_sockets_allocated;
> > +
> > +long sysctl_quic_mem[3];
> > +int sysctl_quic_rmem[3];
> > +int sysctl_quic_wmem[3];
> > +int sysctl_quic_alpn_demux;
> > +
> > +static int quic_inet_connect(struct socket *sock, struct sockaddr *add=
r, int addr_len, int flags)
> > +{
> > +     struct sock *sk =3D sock->sk;
> > +     const struct proto *prot;
> > +
> > +     if (addr_len < (int)sizeof(addr->sa_family))
> > +             return -EINVAL;
> > +
> > +     prot =3D READ_ONCE(sk->sk_prot);
>
> Is the above _ONCE() annotation for ADDRFORM's sake? If so it should not
> be needed (only UDP and TCP sockets are affected).
I will delete it.

>
> > diff --git a/net/quic/socket.h b/net/quic/socket.h
> > new file mode 100644
> > index 000000000000..ded8eb2e6a9c
> > --- /dev/null
> > +++ b/net/quic/socket.h
> > @@ -0,0 +1,79 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/* QUIC kernel implementation
> > + * (C) Copyright Red Hat Corp. 2023
> > + *
> > + * This file is part of the QUIC kernel implementation
> > + *
> > + * Written or modified by:
> > + *    Xin Long <lucien.xin@gmail.com>
> > + */
> > +
> > +#include <net/udp_tunnel.h>
> > +
> > +#include "protocol.h"
> > +
> > +extern struct proto quic_prot;
> > +extern struct proto quicv6_prot;
> > +
> > +enum quic_state {
> > +     QUIC_SS_CLOSED          =3D TCP_CLOSE,
> > +     QUIC_SS_LISTENING       =3D TCP_LISTEN,
> > +     QUIC_SS_ESTABLISHING    =3D TCP_SYN_RECV,
> > +     QUIC_SS_ESTABLISHED     =3D TCP_ESTABLISHED,
> > +};
>
> Any special reason to define protocol-specific states? I guess you could
> re-use the TCP ones, as other protocols already do.
>
I know TIPC and SCTP define the states like this:

enum {
        TIPC_LISTEN =3D TCP_LISTEN,
        TIPC_ESTABLISHED =3D TCP_ESTABLISHED,
        TIPC_OPEN =3D TCP_CLOSE,
        TIPC_DISCONNECTING =3D TCP_CLOSE_WAIT,
        TIPC_CONNECTING =3D TCP_SYN_SENT,
};

and

enum sctp_sock_state {
        SCTP_SS_CLOSED         =3D TCP_CLOSE,
        SCTP_SS_LISTENING      =3D TCP_LISTEN,
        SCTP_SS_ESTABLISHING   =3D TCP_SYN_SENT,
        SCTP_SS_ESTABLISHED    =3D TCP_ESTABLISHED,
        SCTP_SS_CLOSING        =3D TCP_CLOSE_WAIT,
};

It should be fine to keep as is, or you have more and better
examples from other protocols.

Thanks.
