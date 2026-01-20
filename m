Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC64500978
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768923286; cv=pass; b=r8ZbP1Vb6x/F/O6PrkxwQIMjRp7zgQrC//sKIXe6FXVxqCEonJRxZtSfRI4SH2/WbLtarmdYB2mZoBQ0AADvDGkjjfspnrseJ/Sl6LripX3LuD0IMueXs21ietG5c5k7qogxigsN8CiLbzl9xbNA/xIVvedKdrKpYqHUWwl4b2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768923286; c=relaxed/simple;
	bh=1yN6HAEO40QcoyUmpcQZqYl18nEWpx0GzR2VbJpP/3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FCemAQb+oDEQ7lF3yW+NQk97e9nrzOJQO1Jgb/SzMycqST8PXLNzdTFQn4sxnrdJAMgeFhfmVJXnbe7PHfmgWOZN+oZLv6cG73czEnbI1+74kD0G3PVGYQ5LV6iNKsGnoeIkmUGFlbRvSXyYJHmVRqUuwsIfWAHCpJ75EEhV9Mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+R+UBtl; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+R+UBtl"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81f47610542so3126857b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 07:34:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768923284; cv=none;
        d=google.com; s=arc-20240605;
        b=CTG1fcSF/dRVrXJlvgLtGWU/LSC+Wi363GsATbQCe9kZRZD3wb3TxW4TN0I69ju0B4
         Vl1fPJbZ2/N1VN6dbNTLnxMnriwnYzmW6c3gxXMfJ0725s9SkuLlFpnK/LiKKRgsjrrt
         +y5vPYfsLzs1VlTiQZUEAMNOYC8H81V2lFV8hyWz33OZotcco7RPgd4R1tp8DcPrCtMc
         T/JtI6y8BXbVsVUwnVo5siigkjkFPURXdI5C2eiQ2jLmywQR/b9AaQf+OPSt1CbRLKKQ
         uPOgzLESKpK8EjJVVvJ5NXnSZ7ptbUFpHOwzGe0L1R2iSa7P9bWy4rK0oUjEmWdredmh
         rnAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T2NmNela4GRw6AQkwyD5Rk7RKIpCKu04jdsKYK8kc2M=;
        fh=WVfIhs6EtOBv2ydgkkjAWEoVsiPhZMOEw4Dmq8Wwn7c=;
        b=TfUSR+Xda9aM1pKtjSZd0azZ1DxgNoQJJtz2LbzXjgVJcLaPykbTOO2tOCLJkTvOmS
         0CNkCffVf9zOEKXmuNUSRxuArD1e8Jb7UDoqIxpd/3xXa6H9AAdUV2qv+4nKo0zIee4n
         hAzSgqPc7RPNng6iVCz0I+ePCIhXNScl9b9Oi0cr3CwOUWP6Zibm+Kdwr3/TMKpaUsOn
         qHmMmNyRZeBSsj38aP5UMrsKcqSBe89vgFjJz1DNKN07rI1KvTHlwYlCyWa5tEnk99hV
         CCFYl5B2KzVxNhDWejpED6YjI883Qq0Cpp8O86/K5uzxl+XbvH2HY2bybm+3cQRRP6MA
         WnqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768923284; x=1769528084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2NmNela4GRw6AQkwyD5Rk7RKIpCKu04jdsKYK8kc2M=;
        b=G+R+UBtlydBQVVO2eq7SJyphEixE7YnJUt9J9M5iJlBf+qydvWP7oHuwlnS199qoZH
         +ziFM3VW84z4V+PaANii7+gTOY8FBSkpXepUGXivvwXMKYazNfRYgonSNJtzX1tBDvx3
         A/rsYc8poIKmv8cgGNgMYdc6iJjSF1Klw9KYvrCo/8jKC84eIgRY5lWlHEQ3/LLIHmqc
         d/P0eBkD/kCgp+knHMoQjYNlA8fLwEXnnJ41BjguPFATNq8IZaVoh4CuXNvAFJAlyBPv
         X/UgFl8Hx/pkxr0H/j5BETIwzENnQ6YRH7yJvbozWisBdTRetyz1h0w+Th2DG3+buuCc
         EEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768923284; x=1769528084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2NmNela4GRw6AQkwyD5Rk7RKIpCKu04jdsKYK8kc2M=;
        b=I8xakhs3Deprp/l7j5oRJXi75p3gdORfEwVAfhBLpt2x61Cn8JU3v87Uq8eSB8i0fb
         hqQyiXQUBIslaIIE/hQLy08sHJf4KfkPif+W/98iH6keenampT+u3r+c9eVVgJAWbNt5
         pY7Ek7sECWJ0G9dP+kjGZ+NyTuADxTQkle3vOa67kyixmmZSQ0y2VzdybdG79EXSjAu9
         JViJaV9AeYCpLgWkW6PkuUxedxkCg76B/8FhBxTm9GhTHQy7vwsqYkcvrcA+3P+W3QwU
         viMT6V6GN7wEOwDMcE67p3oKZFgZN0pA/rj0GJOvA1JNs646ykKKPtWwdSyt/mkCw0lw
         PPTg==
X-Forwarded-Encrypted: i=1; AJvYcCXd1ZESXcA69qQ2cesBP+FcNTOsCasXNcBtzkQDQ3P8CJu46Lvk2U+InWgPb70wKE1qMkXs9KU6LcCt@vger.kernel.org
X-Gm-Message-State: AOJu0YxKUu0fmziBhj5sNKIVN7UjDrF35pBSCkX7cUVcX29ryuKDhMZm
	yfwBKKGOcVR7ywgJLljY5buZyLklgD/6n/7oVcFOfyPsdlRot8UAjUXdJ8hnxcb/LCSrSLusZBm
	1fT/3OutiCxofJ05NwPEdUWHZ7IkfDa0=
X-Gm-Gg: AZuq6aLk83ipPlWOXV+WnpQVtzz1uuS0U6JcTsBeoxskoVHzMzCEHNpk380TMkX88MG
	u5vdmO5L/kQ9NCoF1TKM5VMGD4n6JzPPwj8jOcH+CYRAfWQFdSo702wU53+1uy0clYEWQnvAhLn
	3EMCuNscMxAl1yjMmnZF9dihPEaontyEBpYPIComE+eRIf86d0ix+7+BjR/vveEYvOYd5qs0TL+
	evbVvOWvf7NuDQODTnyWvUhVxK7w91a8v5XT8ZFqtIOG/hj0LaN0DI8l//le+KkzKitIbiy3e4b
	hOBM8s1mL4U+RKAevFjJjBmaCzVp
X-Received: by 2002:a05:6a00:138d:b0:81f:9907:e503 with SMTP id
 d2e1a72fcca58-81f9f6ab90emr15585317b3a.16.1768923284205; Tue, 20 Jan 2026
 07:34:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768489876.git.lucien.xin@gmail.com> <3771dfc211626a9f0c603c90113e38f325ceb456.1768489876.git.lucien.xin@gmail.com>
 <71705484-46fc-469f-9357-07a076ee0e73@redhat.com>
In-Reply-To: <71705484-46fc-469f-9357-07a076ee0e73@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Jan 2026 10:34:32 -0500
X-Gm-Features: AZwV_Qh1cQDFjcFB0vVqm1_VmBk3f4OEQi8_hpHzwrIYtAE_UmESsrIJnbspVXo
Message-ID: <CADvbK_dYbMa-nVi_8M-XS1QcVUw25t4CZdvcq_HcACx38bH86g@mail.gmail.com>
Subject: Re: [PATCH net-next v7 08/16] quic: add path management
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 9:13=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/15/26 4:11 PM, Xin Long wrote:
> > @@ -0,0 +1,524 @@
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
> > +#include <net/udp_tunnel.h>
> > +#include <linux/quic.h>
> > +
> > +#include "common.h"
> > +#include "family.h"
> > +#include "path.h"
> > +
> > +static int (*quic_path_rcv)(struct sock *sk, struct sk_buff *skb, u8 e=
rr);
>
> It's unclear why an indirect call is needed here. At least some
> explanation is needed in the commit message, possibly you could call
> directly a static function.
>
This patchset makes the path subcomponent more independent from the core
implementation. Aside from a few shared helper functions, it doesn't
rely on code outside the subcomponent, in particular socket.c and
packet.c.

Other subcomponents, such as stream, connid, pnspace, cong,
crypto, common, and family follow the same approach. They expose
APIs to the core QUIC logic and don=E2=80=99t see the main process.

Will leave an explanation here.

> > +
> > +static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     memset(skb->cb, 0, sizeof(skb->cb));
> > +     QUIC_SKB_CB(skb)->seqno =3D -1;
> > +     QUIC_SKB_CB(skb)->time =3D quic_ktime_get_us();
> > +
> > +     skb_pull(skb, sizeof(struct udphdr));
> > +     skb_dst_force(skb);
> > +     quic_path_rcv(sk, skb, 0);
> > +     return 0;
>
> Why not:
>         return quic_path_rcv(sk, skb, 0);
> ?
I checked the udp tunnel users:

- bareudp: bareudp_udp_encap_recv()
- vxlan: vxlan_rcv()
- geneve: geneve_udp_encap_recv()
- tipc: tipc_udp_recv()
- sctp: sctp_udp_rcv()

they all are returning 0 in .encap_udp(), I think because they all
take care of the
skb freeing in their err path already.

is it safe to return error to UDP stack if the skb is already freed?
Do you know?

>
> > +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk, uni=
on quic_addr *a)
> > +{
> > +     struct udp_tunnel_sock_cfg tuncfg =3D {};
> > +     struct udp_port_cfg udp_conf =3D {};
> > +     struct net *net =3D sock_net(sk);
> > +     struct quic_uhash_head *head;
> > +     struct quic_udp_sock *us;
> > +     struct socket *sock;
> > +
> > +     us =3D kzalloc(sizeof(*us), GFP_KERNEL);
> > +     if (!us)
> > +             return NULL;
> > +
> > +     quic_udp_conf_init(sk, &udp_conf, a);
> > +     if (udp_sock_create(net, &udp_conf, &sock)) {
> > +             pr_debug("%s: failed to create udp sock\n", __func__);
> > +             kfree(us);
> > +             return NULL;
> > +     }
> > +
> > +     tuncfg.encap_type =3D 1;
> > +     tuncfg.encap_rcv =3D quic_udp_rcv;
> > +     tuncfg.encap_err_lookup =3D quic_udp_err;
> > +     setup_udp_tunnel_sock(net, sock, &tuncfg);
> > +
> > +     refcount_set(&us->refcnt, 1);
> > +     us->sk =3D sock->sk;
> > +     memcpy(&us->addr, a, sizeof(*a));
> > +     us->bind_ifindex =3D sk->sk_bound_dev_if;
> > +
> > +     head =3D quic_udp_sock_head(net, ntohs(a->v4.sin_port));
> > +     hlist_add_head(&us->node, &head->head);
> > +     INIT_WORK(&us->work, quic_udp_sock_put_work);
> > +
> > +     return us;
> > +}
> > +
> > +static bool quic_udp_sock_get(struct quic_udp_sock *us)
> > +{
> > +     return refcount_inc_not_zero(&us->refcnt);
> > +}
> > +
> > +static void quic_udp_sock_put(struct quic_udp_sock *us)
> > +{
> > +     if (refcount_dec_and_test(&us->refcnt))
> > +             queue_work(quic_wq, &us->work);
>
> Why using a workqueue here? AFAICS all the caller are in process
> context. Is that to break a possible deadlock due to nested mutex?
> Likely a comment on the refcount/locking scheme would help.
>
quic_udp_sock_put() will also be called in the RX path via
quic_path_unbind() for the connection migration (after changing
to a new path.), which is in the patchset-2.

I will leave a comment for an explanation here.

Thanks.
