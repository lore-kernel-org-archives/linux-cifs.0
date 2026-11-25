Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795622906;
	b=OamM2UAvesJeLGAsSuVuBQudOQzi0qAm+GB+ovDrH+/K5CpA87zsXmezfIU/Oh6JH7Zw
	 fKzXJ+HgZg8n8Nwiys1FVyWext6+bInsyxiF1xYvo9oWSiBEWYEIo83ufOh9zlmvxqRXQ
	 TkbSdtRmg2V52rKkAarswQ2SfBedXwm/sk9o9a9Sz8A0vO4yX/8vIhQLAMfMOJ/SMMosZ
	 K9u8gjxkonVeN6CENL0vp5zzS25+Yi0IjnZgGCLDPPaMRhEM+XqUGw9mlsstblP7i8gsB
	 mZNN0jLO+t4PIJQvyxRqv1ajo2uuRQPMpSRZvTAYc9mH497AoLyktz+NAYQ4MClPN2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622906;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=KKuY8t/dbdWbbzJkpzDyiBMYI2cCzIotmQHdtsfJbL0=;
	b=SkHEchYexZGAsbyZhRqURvfbi0DQnwD5xWVrwMNT0AL6hXwdB1xngHtfe2L/4odEVim1
	 McicyzOMvVPqbflG6BUBSqlJ87HxkIGYo3bL2L449Q213eYYZqfVov0bRO4mZinc6vEA7
	 TJxbuRapN5IpHi4QvmTXao6ANHGrHqL6IrdOlpLmGb7H0QMPnDi9ucgvu01R5gVChJAq2
	 DXl8L0xExl57zk0wg5cFT3k1+/TjE8mTg2RGSDMZYtRdri+9hWGkAcpGxfZQCpRRwap1j
	 ixKj3TmLPdR1JrjwDS04CARODhSLxMqv681houkSS9g4dDiDFfm4RnktbBAehPfY6tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BkWP7QTN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC335606A32D
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 16:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC335606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BkWP7QTN
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so3621754b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:08:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795622905; cv=none;
        d=google.com; s=arc-20260327;
        b=OmX3zoVunxeNB7hMHMwi7R5kGcIT9F0ciuW49OKQcxO9l2MMPj/e4O1wyrIj4vrpo1
         8WhPIkqc6q4spHI23aKF4BKI8Q3IEn/TaKi/7sTcXI29w2TNp9ffe5DBL1BdB350skZN
         Y6DZPAkIQ+xALecTHBrTvwWTsKBmK8rlwix6GUBkTHr+lVmZGTGviFiEuaHZEzN1n7Cz
         t9RJ0IfhesebywCDgekFQs4KjcKhyphsAGr70CT/pWfO/gfUeGvOPdhAHBkO4UIFQY6d
         Rv0ssOifzQf6uVj0ZkOSG9Ki7U2Np3RUilcv4mvGhnY5rnRU4tdcOpjnJN5RVw49BvYN
         YPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KKuY8t/dbdWbbzJkpzDyiBMYI2cCzIotmQHdtsfJbL0=;
        fh=XlquUxWVvfpoNfy+92FbHtE63gXeCXNHtjm1UXQdSYQ=;
        b=BMEGjDabSjyrdUWtEf5RR4s5AMCv/RjWW+yR2nswiW07W8GPl1S2urU6RAnGyFD6fZ
         zVqMlSW9ISQoIa7uVfGFLdjL+Ev2fQRoYAaF/DKCmQQNrf0Ft+40kCY1NGTm2omQ8/27
         e1b8Rg3FTJTVB7YQ9OdOKreAfZwMWfAnzwiVE1eh8pd38o6++B/6afuLs0iGP5eDkguQ
         sUULp74Pp5eqP+evDg8j0X3jhACG728MpaZgqJXN+/jQJ/gYYyIXxj2TRfHsKH2QH5uh
         cFiZ0BIOpqt5QvRERu06plmIAvcFqTZStKdaPm4is4Dk/EY4gAnAxU7f2D3FvJJNU+Jk
         vcfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795622905; x=1796227705; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KKuY8t/dbdWbbzJkpzDyiBMYI2cCzIotmQHdtsfJbL0=;
        b=BkWP7QTN7xKZYCs2UdtyKo7D7prWq/8rIs3EAQKujeYUM3FMt2kgdM4l7WGs9wY4+k
         K5vSb1JBvlgVaZ51KMw24Cfmh5EKOzixpPUFzRkmKCuT/aYdh4s1fudl/aJztt4hAla7
         7WpzTFcWaRcrlkvD9Cuty/4tyAzUX0k8nG8858rHl7dOMxaLfTIH+d+AsUYBeU7GiRbi
         w4TbXW2PWtt6aEk2xgIqIouvqU6Dz2R4OpdsoAmUQtaxdDZ0k87l59qynWq1VXj6B+7S
         K9iauNga0fRvu/00WOAjWBeTAs0gqYHCIY0pRIE+X4S80IO/eCctTVh61o5+kOtvjY7l
         kn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795622905; x=1796227705;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KKuY8t/dbdWbbzJkpzDyiBMYI2cCzIotmQHdtsfJbL0=;
        b=Nop0xfRdfP/0gHtZz+kW5IZDjM4fuqAw/TdjDiLkXIEhAJbhB7qyh432imnvz6cg4x
         NsP/4rskHObjbIF1W/7V6FkaEMR3FePIP+iLO3WF+yEFvRtFzpUzbhuLpLxqE9ML6LDy
         F2Gt80DGJAg1Np+Ism0R06Q9SHnXzfcx55dsoOiABcpA8ELgmqn9cYLaO9lxUJpC07G1
         QNDKzafxiAkJUurTD3u+ppWGML8tEPwml8LdHQ9SU+hEAvSDBCqwUKLNGXb+vP9J8IzI
         XQywRKxF4F8RR5KCmLVE8d7OYRLqpfnv9uHW0pRkjhhqGKTp70cERDgslc+EFy7jJb1g
         1ntQ==
X-Forwarded-Encrypted: i=1; AL+hErH0x62UedHpZegC9hKOFxw7N4z0We+eC8quHsSHakcoNH+Er4HOR8FSBAFw588wU6KCyilxaxuAMVpY@vger.kernel.org
X-Gm-Message-State: APuU4Z+9VS1bbwMZg67tMnRje+m5rDjjEphqB3STGISWEdHdU+0hmzl6
	fE5XGKXsCZLOJQaKvheix5LgkMcu3DP4b0NfNhbf9wksP/NKCgrxuMwspnLsH6oYDkosy2sjJ5j
	caGN9iu8Z25RQFn/IX+rvcME7C+rtyLk=
X-Gm-Gg: AZFdTZe8eUJqoQSjD9NPnXpEEoeMGuxEGaCZf35Oh9yG+dsZgGRFm92PC2NSDSx2RZa
	VK8T+TQwLBsBfTQuswSVEpyMhgA9CtZ98f4s086mpUYlpr8PNPvD83oJjl+Yj833OTN9/YSE7V/
	YokvauxMqaXkfRxct21L+kgVVojwLT1my5dfJdepshp7yF5lTm69We/KoIpzXywr/AAMi3Z0jrm
	SpCj1FFxltzwHqybbToXUhZ4OKBWgJFbmIdvdMtv+iWEC8c6rTZ4yu0l9sUrQduern5UWRu6nNM
	LRO9MRQ4px7L2/HGIZsP3rf8/MZz2/RRgVrmmSJy/6VBxqyH1uy0XaU9UDQrqqKhQMUSrZR7GLv
	PGcAfIcZAQvU94q6RNju0TiCTrjaC3xNCpoUL8VzTQi46Wg3aAmraYspqEVAXKeAvjnWKqAH8gV
	yTatdvVbKYai1i7q0S+BlmYW1qp1lrspQ7/+2ZjRSgaMzSPjQfZHXGTl8S3raL0YD7ZupR
X-Received: by 2002:a05:6a00:3003:b0:8a0:550f:bb43 with SMTP id
 d2e1a72fcca58-8c7ddfb0281mr12625739b3a.34.1795622904926; Wed, 25 Nov 2026
 08:08:24 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <052a21a5f6e57bb7f6db0f6e274dce9d8523805c.1795393691.git.lucien.xin@gmail.com>
 <179548326987.3135.7163509585500687471@kernel.org>
In-Reply-To: <179548326987.3135.7163509585500687471@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 11:08:12 -0500
X-Gm-Features: Aa3M54qL5y7t-zsr7Zjl1jU3nL68ghyjsBOlROKwWzkNuGB0w_9pDg7lono20_w
Message-ID: <CADvbK_cCgi6udMNENyEOth6QpNftOijLJFLT05u6bgGC=79d0A@mail.gmail.com>
Subject: Re: [PATCH net-next v19 06/15] quic: add stream management
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org, 
	pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com, 
	kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org, 
	steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com, 
	matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com, 
	sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se, 
	andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:21=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic: broken next stream ID type update in
>   quic_stream_set_param()
>
> --
>
> > diff --git a/net/quic/stream.c b/net/quic/stream.c
> > --- /dev/null
> > +++ b/net/quic/stream.c
> > @@ -0,0 +1,426 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* QUIC kernel implementation
> > + * (C) Copyright Red Hat Corp. 2023
> > + *
> > + * This file is part of the QUIC kernel implementation
> > + *
> > + * Stream management.
> > + *
> > + * Written or modified by:
> > + *    Xin Long <lucien.xin@gmail.com>
> > + */
> > +
> > +#include <net/netns/hash.h>
> > +#include <linux/jhash.h>
> > +#include <linux/quic.h>
> > +
> > +#include "common.h"
> > +#include "stream.h"
> > +
> > +/* Check if a stream ID is valid for sending or receiving. */
> > +static bool quic_stream_id_valid(s64 stream_id, bool is_serv, bool sen=
d)
> > +{
> > +     u8 type =3D (stream_id & QUIC_STREAM_TYPE_MASK);
> > +
> > +     if (stream_id < 0)
> > +             return false;
> > +
> > +     if (send) {
> > +             if (is_serv)
> > +                     return type !=3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +             return type !=3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +     }
> > +     if (is_serv)
> > +             return type !=3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +     return type !=3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +}
> > +
> > +/* Check if a stream ID belongs to the local endpoint. */
> > +static bool quic_stream_id_local(s64 stream_id, bool is_serv)
> > +{
> > +     return is_serv ^ !(stream_id & QUIC_STREAM_TYPE_SERVER_MASK);
> > +}
> > +
> > +/* Check if a stream ID represents a unidirectional stream. */
> > +static bool quic_stream_id_uni(s64 stream_id)
> > +{
> > +     return stream_id & QUIC_STREAM_TYPE_UNI_MASK;
> > +}
> > +
> > +#define QUIC_STREAM_HT_SIZE  64
> > +
> > +static struct hlist_head *quic_stream_head(struct quic_stream_table *s=
treams,
> > +                                        s64 stream_id, struct net *net=
)
> > +{
> > +     u32 hash =3D jhash_1word((u32)(stream_id >> 1), net_hash_mix(net)=
);
> > +
> > +     return &streams->head[hash & (QUIC_STREAM_HT_SIZE - 1)];
> > +}
> > +
> > +struct quic_stream *quic_stream_find(struct quic_stream_table *streams=
,
> > +                                  s64 stream_id, struct net *net)
> > +{
> > +     struct hlist_head *head =3D quic_stream_head(streams, stream_id, =
net);
> > +     struct quic_stream *stream;
> > +
> > +     hlist_for_each_entry(stream, head, node) {
> > +             if (stream->id =3D=3D stream_id)
> > +                     break;
> > +     }
> > +     return stream;
> > +}
> > +
> > +static void quic_stream_add(struct quic_stream_table *streams,
> > +                         struct quic_stream *stream, struct net *net)
> > +{
> > +     struct hlist_head *head;
> > +
> > +     head =3D quic_stream_head(streams, stream->id, net);
> > +     hlist_add_head(&stream->node, head);
> > +}
> > +
> > +static void quic_stream_delete(struct quic_stream *stream)
> > +{
> > +     hlist_del_init(&stream->node);
> > +     kfree(stream);
> > +}
> > +
> > +/* Create and register new streams for sending or receiving. */
> > +static struct quic_stream *quic_stream_create(struct quic_stream_table=
 *streams,
> > +                                           s64 max_stream_id, bool sen=
d,
> > +                                           bool is_serv, struct net *n=
et,
> > +                                           gfp_t gfp)
> > +{
> > +     struct quic_stream *pos, *stream =3D NULL;
> > +     struct quic_stream_limits *limits;
> > +     struct hlist_node *tmp;
> > +     HLIST_HEAD(head);
> > +     s64 stream_id;
> > +     u32 count =3D 0;
> > +
> > +     gfp |=3D __GFP_ACCOUNT;
> > +     limits =3D send ? &streams->send : &streams->recv;
> > +     stream_id =3D limits->next_bidi_stream_id;
> > +     if (quic_stream_id_uni(max_stream_id))
> > +             stream_id =3D limits->next_uni_stream_id;
> > +
> > +     /* rfc9000#section-2.1: A stream ID that is used out of order res=
ults in
> > +      * all streams of that type with lower-numbered stream IDs also b=
eing
> > +      * opened.
> > +      */
> > +     while (stream_id <=3D max_stream_id) {
> > +             stream =3D kzalloc_obj(*stream, gfp);
> > +             if (!stream)
> > +                     goto free;
> > +
> > +             stream->id =3D stream_id;
> > +             if (quic_stream_id_uni(stream_id)) {
> > +                     if (send) {
> > +                             stream->send.max_bytes =3D
> > +                                     limits->max_stream_data_uni;
> > +                     } else {
> > +                             stream->recv.max_bytes =3D
> > +                                     limits->max_stream_data_uni;
> > +                             stream->recv.state =3D
> > +                                     QUIC_STREAM_RECV_STATE_RECV;
> > +                             stream->recv.window =3D stream->recv.max_=
bytes;
> > +                     }
> > +                     hlist_add_head(&stream->node, &head);
> > +                     stream_id +=3D QUIC_STREAM_ID_STEP;
> > +                     continue;
> > +             }
> > +
> > +             if (quic_stream_id_local(stream_id, is_serv)) {
> > +                     stream->send.max_bytes =3D
> > +                             streams->send.max_stream_data_bidi_remote=
;
> > +                     stream->recv.max_bytes =3D
> > +                             streams->recv.max_stream_data_bidi_local;
> > +             } else {
> > +                     stream->send.max_bytes =3D
> > +                             streams->send.max_stream_data_bidi_local;
> > +                     stream->recv.max_bytes =3D
> > +                             streams->recv.max_stream_data_bidi_remote=
;
> > +             }
> > +             stream->recv.state =3D QUIC_STREAM_RECV_STATE_RECV;
> > +             stream->recv.window =3D stream->recv.max_bytes;
> > +             hlist_add_head(&stream->node, &head);
> > +             stream_id +=3D QUIC_STREAM_ID_STEP;
> > +     }
> > +
> > +     hlist_for_each_entry_safe(pos, tmp, &head, node) {
> > +             hlist_del_init(&pos->node);
> > +             quic_stream_add(streams, pos, net);
> > +             count++;
> > +     }
> > +
> > +     /* Streams must be opened sequentially. Update the next stream ID=
 so the
> > +      * correct starting point is known if an out-of-order open is req=
uested.
> > +      * Note overflow of next_uni/bidi_stream_id is impossible with s6=
4.
> > +      */
> > +     if (quic_stream_id_uni(stream_id)) {
> > +             limits->next_uni_stream_id =3D stream_id;
> > +             limits->streams_uni +=3D count;
> > +             return stream;
> > +     }
> > +
> > +     limits->next_bidi_stream_id =3D stream_id;
> > +     limits->streams_bidi +=3D count;
> > +     return stream;
> > +
> > +free:
> > +     hlist_for_each_entry_safe(pos, tmp, &head, node) {
> > +             hlist_del_init(&pos->node);
> > +             kfree(pos);
> > +     }
> > +     return NULL;
> > +}
> > +
> > +/* Check if a stream ID was already used. */
> > +static bool quic_stream_id_closed(struct quic_stream_table *streams,
> > +                               s64 stream_id, bool is_serv)
> > +{
> > +     bool local =3D quic_stream_id_local(stream_id, is_serv);
> > +     struct quic_stream_limits *limits;
> > +
> > +     limits =3D local ? &streams->send : &streams->recv;
> > +     if (quic_stream_id_uni(stream_id))
> > +             return stream_id < limits->next_uni_stream_id;
> > +     return stream_id < limits->next_bidi_stream_id;
> > +}
> > +
> > +/* Check if a stream ID would exceed local (recv) or peer (send) limit=
s. */
> > +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 str=
eam_id,
> > +                         bool send)
> > +{
> > +     u64 nstreams;
> > +
> > +     if (!send) {
> > +             /* recv.max_uni/bidi_stream_id is updated in
> > +              * quic_stream_max_streams_update() already based on
> > +              * next_uni/bidi_stream_id, max_streams_uni/bidi, and
> > +              * streams_uni/bidi, so only recv.max_uni/bidi_stream_id =
needs
> > +              * to be checked.
> > +              */
> > +             if (quic_stream_id_uni(stream_id))
> > +                     return stream_id > streams->recv.max_uni_stream_i=
d;
> > +
> > +             return stream_id > streams->recv.max_bidi_stream_id;
> > +     }
> > +
> > +     if (quic_stream_id_uni(stream_id)) {
> > +             if (stream_id > streams->send.max_uni_stream_id)
> > +                     return true;
> > +             stream_id -=3D streams->send.next_uni_stream_id;
> > +             nstreams =3D quic_stream_id_to_streams(stream_id);
> > +
> > +             return nstreams + streams->send.streams_uni >
> > +                    streams->send.max_streams_uni;
> > +     }
> > +
> > +     if (stream_id > streams->send.max_bidi_stream_id)
> > +             return true;
> > +     stream_id -=3D streams->send.next_bidi_stream_id;
> > +     nstreams =3D quic_stream_id_to_streams(stream_id);
> > +
> > +     return nstreams + streams->send.streams_bidi >
> > +            streams->send.max_streams_bidi;
> > +}
> > +
> > +/* Get or create a send or recv stream by ID. Requires sock lock held.=
 */
> > +struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
> > +                                 s64 stream_id, u32 flags, bool is_ser=
v,
> > +                                 bool send, struct net *net, gfp_t gfp=
)
> > +{
> > +     struct quic_stream *stream;
> > +
> > +     if (!quic_stream_id_valid(stream_id, is_serv, send))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     stream =3D quic_stream_find(streams, stream_id, net);
> > +     if (stream)
> > +             return stream;
> > +
> > +     if (quic_stream_id_closed(streams, stream_id, is_serv))
> > +             return ERR_PTR(-ENOSTR);
> > +
> > +     /* Cannot create if the other side must initiate this stream. */
> > +     if (send !=3D quic_stream_id_local(stream_id, is_serv))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     if (!(flags & MSG_QUIC_STREAM_NEW))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     if (quic_stream_id_exceeds(streams, stream_id, send))
> > +             return ERR_PTR(-EAGAIN);
> > +
> > +     stream =3D quic_stream_create(streams, stream_id, send, is_serv, =
net,
> > +                                 gfp);
> > +     if (!stream)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     if (send || quic_stream_id_valid(stream_id, is_serv, !send))
> > +             streams->active_stream_id =3D stream_id;
> > +
> > +     return stream;
> > +}
> > +
> > +/* Release or clean up a send or recv stream. This function updates st=
ream
> > + * counters and state when a send stream has either successfully sent =
all data
> > + * or has been reset, or when a recv stream has either received all da=
ta or has
> > + * been reset. Requires sock lock held.
> > + */
> > +void quic_stream_put(struct quic_stream_table *streams,
> > +                  struct quic_stream *stream, bool is_serv, bool send)
> > +{
> > +     if (quic_stream_id_uni(stream->id)) {
> > +             /* For uni streams, decrement uni count and delete stream=
. */
> > +             if (send) {
> > +                     streams->send.streams_uni--;
> > +                     quic_stream_delete(stream);
> > +                     return;
> > +             }
> > +             streams->recv.streams_uni--;
> > +             streams->recv.uni_pending =3D 1;
> > +             quic_stream_delete(stream);
> > +             return;
> > +     }
> > +
> > +     /* For bidi streams, proceed only if both send and receive in a f=
inal
> > +      * state.
> > +      */
> > +     if (send) {
> > +             if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
> > +                     return;
> > +     } else {
> > +             if (stream->send.state !=3D QUIC_STREAM_SEND_STATE_RECVD =
&&
> > +                 stream->send.state !=3D QUIC_STREAM_SEND_STATE_RESET_=
RECVD)
> > +                     return;
> > +     }
> > +     if (quic_stream_id_local(stream->id, is_serv)) {
> > +             /* Local-initiated stream: decrement send.bidi count. */
> > +             streams->send.streams_bidi--;
> > +     } else {
> > +             /* Remote-initiated stream: decrement recv.bidi count. */
> > +             streams->recv.streams_bidi--;
> > +             streams->recv.bidi_pending =3D 1;
> > +     }
> > +     quic_stream_delete(stream);
> > +}
> > +
> > +/* Updates the maximum allowed incoming stream IDs if any streams were=
 recently
> > + * closed. Recalculates the max_uni and max_bidi stream count limits b=
ased on
> > + * the number of open streams and whether any were marked for deletion=
.
> > + *
> > + * Returns true if either max_uni or max_bidi was updated, indicating =
that a
> > + * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the pee=
r.
> > + */
> > +bool quic_stream_max_streams_update(struct quic_stream_table *streams,
> > +                                 s64 *max_uni, s64 *max_bidi)
> > +{
> > +     s64 max, rem;
> > +
> > +     *max_uni =3D 0;
> > +     *max_bidi =3D 0;
> > +     if (streams->recv.uni_pending) {
> > +             rem =3D streams->recv.max_streams_uni - streams->recv.str=
eams_uni;
> > +             max =3D streams->recv.next_uni_stream_id - QUIC_STREAM_ID=
_STEP +
> > +                   (rem << QUIC_STREAM_TYPE_BITS);
> > +
> > +             streams->recv.max_uni_stream_id =3D max;
> > +             *max_uni =3D quic_stream_id_to_streams(max);
> > +             streams->recv.uni_pending =3D 0;
> > +     }
> > +     if (streams->recv.bidi_pending) {
> > +             rem =3D streams->recv.max_streams_bidi -
> > +                   streams->recv.streams_bidi;
> > +             max =3D streams->recv.next_bidi_stream_id - QUIC_STREAM_I=
D_STEP +
> > +                     (rem << QUIC_STREAM_TYPE_BITS);
> > +
> > +             streams->recv.max_bidi_stream_id =3D max;
> > +             *max_bidi =3D quic_stream_id_to_streams(max);
> > +             streams->recv.bidi_pending =3D 0;
> > +     }
> > +
> > +     return *max_uni || *max_bidi;
> > +}
> > +
> > +int quic_stream_init(struct quic_stream_table *streams)
> > +{
> > +     struct hlist_head *head;
> > +     int i;
> > +
> > +     head =3D kmalloc_objs(*head, QUIC_STREAM_HT_SIZE, GFP_KERNEL_ACCO=
UNT);
> > +     if (!head)
> > +             return -ENOMEM;
> > +     for (i =3D 0; i < QUIC_STREAM_HT_SIZE; i++)
> > +             INIT_HLIST_HEAD(&head[i]);
> > +     streams->head =3D head;
> > +     streams->active_stream_id =3D -1;
> > +     return 0;
> > +}
> > +
> > +void quic_stream_free(struct quic_stream_table *streams)
> > +{
> > +     struct quic_stream *stream;
> > +     struct hlist_head *head;
> > +     struct hlist_node *tmp;
> > +     int i;
> > +
> > +     if (!streams->head)
> > +             return;
> > +
> > +     for (i =3D 0; i < QUIC_STREAM_HT_SIZE; i++) {
> > +             head =3D &streams->head[i];
> > +             hlist_for_each_entry_safe(stream, tmp, head, node)
> > +                     quic_stream_delete(stream);
> > +     }
> > +     kfree(streams->head);
> > +     streams->head =3D NULL;
> > +}
> > +
> > +/* Populate transport parameters from stream hash table. */
> > +void quic_stream_get_param(struct quic_stream_table *streams,
> > +                        struct quic_transport_param *p)
> > +{
> > +     struct quic_stream_limits *limits =3D p->remote ? &streams->send =
:
> > +                                                     &streams->recv;
> > +
> > +     p->max_stream_data_bidi_remote =3D limits->max_stream_data_bidi_r=
emote;
> > +     p->max_stream_data_bidi_local =3D limits->max_stream_data_bidi_lo=
cal;
> > +     p->max_stream_data_uni =3D limits->max_stream_data_uni;
> > +     p->max_streams_bidi =3D limits->max_streams_bidi;
> > +     p->max_streams_uni =3D limits->max_streams_uni;
> > +}
> > +
> > +/* Configure stream hashtable from transport parameters. */
> > +void quic_stream_set_param(struct quic_stream_table *streams,
> > +                        struct quic_transport_param *p, bool is_serv)
> > +{
> > +     struct quic_stream_limits *limits =3D p->remote ? &streams->send =
:
> > +                                                     &streams->recv;
> > +     u8 bidi_type, uni_type;
> > +
> > +     limits->max_stream_data_bidi_local =3D p->max_stream_data_bidi_lo=
cal;
> > +     limits->max_stream_data_bidi_remote =3D p->max_stream_data_bidi_r=
emote;
> > +     limits->max_stream_data_uni =3D p->max_stream_data_uni;
> > +     limits->max_streams_bidi =3D p->max_streams_bidi;
> > +     limits->max_streams_uni =3D p->max_streams_uni;
> > +
> > +     if (p->remote ^ is_serv) {
> > +             bidi_type =3D QUIC_STREAM_TYPE_CLIENT_BIDI;
> > +             uni_type =3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +     } else {
> > +             bidi_type =3D QUIC_STREAM_TYPE_SERVER_BIDI;
> > +             uni_type =3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +     }
> > +
> > +     limits->max_bidi_stream_id =3D
> > +             quic_stream_streams_to_id(p->max_streams_bidi, bidi_type)=
;
> > +     if (limits->next_bidi_stream_id < bidi_type)
> > +             limits->next_bidi_stream_id =3D bidi_type;
> > +
> > +     limits->max_uni_stream_id =3D
> > +             quic_stream_streams_to_id(p->max_streams_uni, uni_type);
> > +     if (limits->next_uni_stream_id < uni_type)
> > +             limits->next_uni_stream_id =3D uni_type;
> > +}
>
> [Severity: Medium]
> This guard only works when the low two bits of next_bidi_stream_id
> and next_uni_stream_id already match the type being applied. It does
> not correct them if the role changes before any stream is opened.
>
> Suppose quic_stream_set_param() is first called for the local
> parameters (p->remote =3D=3D 0) while quic_is_serv() is still false, for
> example before listen() sets sk_max_ack_backlog. Then
> recv.next_bidi_stream_id becomes 1 and recv.next_uni_stream_id
> becomes 3. When the same parameters are applied again after the
> socket has become a server, bidi_type is 0 and uni_type is 2.
> Neither comparison is true (next < 0 can never be true for the
> client bidi type), so the stale server parity stays.
>
> After that, quic_stream_id_closed() treats client streams 0 and 2 as
> already closed, and quic_stream_get() fails them with -ENOSTR.
>
> It gets worse if the peer opens stream 4 first. quic_stream_create()
> starts from 1 and steps by QUIC_STREAM_ID_STEP, so it inserts stream
> 1 into the hash table, counts it in recv.streams_bidi, and returns it
> in place of stream 4. When quic_stream_put() later releases it,
> quic_stream_id_local(1, true) is true. So send.streams_bidi is
> decremented instead, and that u16 wraps to 65535.
>
> Opening any stream moves next_*_stream_id to at least
> QUIC_STREAM_ID_STEP. Would it be enough to compare against
> QUIC_STREAM_ID_STEP here instead of the type value? Another option
> is to keep the upper bits and replace only the type bits. If
> set_param() can never be re-applied across a client/server
> transition, could that be documented here?
>
False.

The listen socket doesn't use next_*_stream_id. streams are only opened on
accepted sockets. The accept path fetches transport parameters from the
listener and applies them fresh on the new socket, which already has the
correct server role. The stale values on the listener are never read.

> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
