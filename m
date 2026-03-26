Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15BC37C0F2
	for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774537601; cv=pass; b=m5lZd36BclXgfidcoZ8BwsMHS8BberR7lVmPYthOdr42WtE4XyIzZuZ1FtFMGwlB6zF9/YUF+BxriSOVB2d2SmPwo1nH67nXUBPgw/Tr9uCcik9Z+y2JorCDcwaShnMVTgS45t33DIockGcwDiDsk+q9OWLmqIFzz1yUw+UCrf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774537601; c=relaxed/simple;
	bh=nx+HteyFFI7AdLCbzO0p1t9BN73xaw3YXEyCtzkUVzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJSNk7snnVV4IYFNZdGLlz2ZL69lp1/57X3ARbuf+j26TQiBnQ38EpfwNBFRFJBUHgdiO+czGp8ClDtUsqIkKCFizQskx+hEFWhn59kO5GjYFrQEZgZCQlfRi6KrH+HnyUP4QR9L68SsHUdgxTmT7lABixJxubsFJWEahKs+daI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gipltejb; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gipltejb"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82c68339cf0so1417618b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 08:06:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774537599; cv=none;
        d=google.com; s=arc-20240605;
        b=ATsQ56rsRkauWaoW53/aAtOTl3UdYNLF2CvrY+1qk4XodlNIqFWqoYX1GoGVpgoLSX
         eGRFXWrxOGkdWtcr7/6zsAw9jodI46oHTDrpIA0yxW38pqAtlnlImAnqk2me+0v6ic3R
         /qJW5qmH5Z/ii7yNpLWgv2UuO1Mlg8pHzHXePVlKnhgYacmzeZo0tIZP4dhtiWD/g4ss
         qTjxGFaLa3aiTlz0pPc8ayrsxigGYVElf2NRKy5leae/jkPQKodPMnwQUbY3gBHT0IUu
         JmbgqXhGDIQWKGRAe8wC5zPRZ6lvcd8HqVtTjb6KnwK7QafRLc9vv4OVJYDKQoxTUD30
         c5FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FUKqGwYD1hO9AzJAT2EYReBMkJDIVIx9w5Zc+Jzl0to=;
        fh=7F2Euq8g6F37ssbf6o/37GBJ628edL7oTmtCwOCpvmI=;
        b=Y2TqRwQfhUJbh7F0AXgpg3LwdLFfM8OzpS6S2/G1eBigAPHX3XYJKwVC9DKkpcWr90
         jc1hhtfMyWy5h/8inoflvTjca3F732BxVQ7c+hEnvvnd34AievZ2rJ3iOsEwGvHknEcV
         vUKDgrRfBeT944hzd2j+pR+0QrUEKj0cc1kvp2qLLhhvxP538KtFkTBs6YKeW3IAcwVE
         +xoam4Lb6UgTwAAyxfhFvn72T5A2I1LJ6NbyNEWcFHH7ojkAijk78vhAc09P23A9L5UW
         HXD2eylkkt9iXm4na+xWtvIj9H+djU+vydMskJDLqgIia4x0Ri8AHMGUF0iGBARa+9bf
         a+Eg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774537599; x=1775142399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUKqGwYD1hO9AzJAT2EYReBMkJDIVIx9w5Zc+Jzl0to=;
        b=Gipltejbu8PcyXLyatr9VpWcZW/SjQnL8a7RnVt7utJAeZcl3/eKPvnW4pkw7yX2Sb
         7KlscCBYz+KTrG1CW/iWf+nPtw+CclmCogkJzmid6BNJnH5T2H0/mTbG1CSfD5AjQeFP
         HsAw4OqRTr82h2452k86F8sZw6BDtQDR5HFQEtCHdYwSX3ENl9H8coly4Pa2kmr/+foC
         JNWldNLbtNlsaoGxLx+DKaIJi/lXH/m4hNRdAVZMyRBsiKgMRjPSHHjMd+TRRp0B9bO+
         sGKGKwaH4rjjDa9t0N4/vbUDsrJKF0qJqFpdu0LgdImfcyaIv+BQ3h2EHyW2wUKRO12V
         ruCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774537599; x=1775142399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FUKqGwYD1hO9AzJAT2EYReBMkJDIVIx9w5Zc+Jzl0to=;
        b=NmzHDmPDzGx7jSCnxJLgTN2AYEPQWJynqAwKd5SLDkGsf9Y1OXJt3igXFfJmahr+WJ
         3fOqvdDBzQ8sSHBoBhljhpGfk71GrGrI/Tz3eIpJUTLxxsH8iCes/s0qYLdD82z5on9y
         tURH+6l55LMCNQJ2xIOqRkH4cMWQ/OVntHEH8Iu0q8mxTA03A1x5KEfhvGVtOQsHhX/a
         yaokj2JMwColwNw/uhaLzDov6Xn/S1f5OlABf0HsgjQ8XgkXxtPWFCw5W2KT4CKK0bH5
         ul7Uc1fmpc1zeKwpT88hVp+C5ClnwCrhJJ9Oe2eiAVrv1YmrnpmJF7i/DuQRQuW9b+tW
         Fodw==
X-Forwarded-Encrypted: i=1; AJvYcCXn3GOQ/TaJxMgJrSOUS6KRZca7OhGzV1FIY0sPUry08qsRdTE5uVOisweTlwAZnuiIbo0phgUkcOML@vger.kernel.org
X-Gm-Message-State: AOJu0YxPfY8KGC+nmcFO+TpDmBU6JTQ+oJGMxqfPkvnJVZ7I1T8l87YX
	2xKV6+NfhGBJm5CpcjymnZLx3/fARQCK4i5BD9odlNN5VnwkroWItfbGse4+JZptmZOffYgGj6I
	/idt1JXDA0w+MS/KwlSZSksxZu1yT0YI=
X-Gm-Gg: ATEYQzxbztyZsiUA3K7ylP9erFB9H0g45lA85v8THGpkK7OfEPj07llxt2E7Zn6I7hK
	2PD7Q5Tx3nFpiQQJWY0zsfnoL8HXZ+w6lHiBm74qfNvAIWSuGUl/CaDQxweBwBCGz0StC//zKrF
	gRhlHGEjHUD+qdWc+pREMjuyxM572P072c5S/50R3nQkyCAWyg61zDt6ezyrcAQFRXAvzX9v1+l
	NOp6mIUaQOWldQRpQutxS2SewfpTveT0QFcqjEuS9ro2Oze5ad5dkLk6LHuw0MVziB2x7DG+EWH
	o9NQDVxnB2O9abqWzwPCrjQ3OerfCxQNZk2Lv4C/7qc19PV2FZLZlj1YXqCGBNtzI5AjH5h/NTR
	uob7IMoJuYYSyVyb5Lj5jvbCw5/50FTmrnx7LX2O+
X-Received: by 2002:a05:6a00:4c98:b0:81e:1b77:9e61 with SMTP id
 d2e1a72fcca58-82c869d2a33mr2142434b3a.25.1774537598837; Thu, 26 Mar 2026
 08:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1774410440.git.lucien.xin@gmail.com> <91c6fd0a44eb15a98f945171ead8062badb89a60.1774410440.git.lucien.xin@gmail.com>
In-Reply-To: <91c6fd0a44eb15a98f945171ead8062badb89a60.1774410440.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Mar 2026 11:06:26 -0400
X-Gm-Features: AQROBzACuwjYsLpIayq--PQOH3i87OCQN6VqDXDB4GciP-GOMwzf9UMuCvDrrpY
Message-ID: <CADvbK_eXUfnGGQgGc_k-ecCW3-Co1MpGb7UvMgLonPy3HRhyFA@mail.gmail.com>
Subject: Re: [PATCH net-next v11 06/15] quic: add stream management
To: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 11:49=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wr=
ote:
>
> This patch introduces 'struct quic_stream_table' for managing QUIC stream=
s,
> each represented by 'struct quic_stream'.
>
> It implements mechanisms for acquiring and releasing streams on both the
> send and receive paths, ensuring efficient lifecycle management during
> transmission and reception.
>
> - quic_stream_get(): Acquire a send-side stream by ID and flags during
>   TX path, or a receive-side stream by ID during RX path.
>
> - quic_stream_put(): Release a send-side stream when sending is done,
>   or a receive-side stream when receiving is done.
>
> It includes logic to detect when stream ID limits are reached and when
> control frames should be sent to update or request limits from the peer.
>
> - quic_stream_id_exceeds(): Check a stream ID would exceed local (recv)
>   or peer (send) limits.
>
> - quic_stream_max_streams_update(): Determines whether a
>   MAX_STREAMS_UNI/BIDI frame should be sent to the peer.
>
> Note stream hash table is per socket, the operations on it are always
> protected by the sock lock.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v3:
>   - Merge send/recv stream helpers into unified functions to reduce code:
>     * quic_stream_id_send/recv() =E2=86=92 quic_stream_id_valid()
>     * quic_stream_id_send/recv_closed() =E2=86=92 quic_stream_id_closed()
>     * quic_stream_id_send/recv_exceeds() =E2=86=92 quic_stream_id_exceeds=
()
>     (pointed out by Paolo).
>   - Clarify in changelog that stream hash table is always protected by so=
ck
>     lock (suggested by Paolo).
>   - quic_stream_init/free(): adjust for new hashtable type; call
>     quic_stream_delete() in quic_stream_free() to avoid open-coded logic.
>   - Receiving streams: delete stream only when fully read or reset, inste=
ad
>     of when no data was received. Prevents freeing a stream while a FIN
>     with no data is still queued.
> v4:
>   - Replace struct quic_shash_table with struct hlist_head for the
>     stream hashtable. Since they are protected by the socket lock,
>     no per-chain lock is needed.
>   - Initialize stream to NULL in stream creation functions to avoid
>     warnings from Smatch (reported by Simon).
>   - Allocate send streams with GFP_KERNEL_ACCOUNT and receive streams
>     with GFP_ATOMIC | __GFP_ACCOUNT for memory accounting (suggested
>     by Paolo).
> v5:
>   - Introduce struct quic_stream_limits to merge quic_stream_send_create(=
)
>     and quic_stream_recv_create(), and to simplify quic_stream_get_param(=
)
>     (suggested by Paolo).
>   - Annotate the sock-lock requirement for quic_stream_send/recv_get()
>     and quic_stream_send/recv_put() (notied by Paolo).
>   - Add quic_stream_bidi_put() to deduplicate the common logic between
>     quic_stream_send_put() and quic_stream_recv_put().
>   - Remove the unnecessary check when incrementing
>     streams->send.next_bidi/uni_stream_id in quic_stream_create().
>   - Remove the unused 'is_serv' parameter from quic_stream_get_param().
> v7:
>   - Free the allocated streams on error path in quic_stream_create() (not=
ed
>     by Paolo).
>   - Merge quic_stream_send_get/put() and quic_stream_recv_get/put() helpe=
rs
>     to quic_stream_get/put() (suggested by Paolo).
>   - Add more comments in quic_stream_id_exceeds() and quic_stream_create(=
).
> v8:
>   - Replace bitfields with plain u8 in struct quic_stream_limits and stru=
ct
>     quic_stream (suggested by Paolo).
> v9:
>   - Fix grammar in the comment for quic_stream::send.window.
> v10:
>   - Move quic_stream_init() to after sock_prot_inuse_add() ensure counter=
s
>     are incremented before any early return paths in quic_init_sock(),
>     preventing underflow in quic_destroy_sock() (noted by AI review).
>   - Initialize the output parameters '*max_uni' and '*max_bidi' to 0 at t=
he
>     start of quic_stream_max_streams_update()
>   - Use 'stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD' instead of '!=
=3D'
>     for clearer intent.
>   - Simplify some state checks in quic_stream_put() by using range
>     comparisons (> or <) instead of multiple !=3D conditions.
>   - streams_uni/bidi are u16 type, and their overflow is already prevente=
d
>     by QUIC_MAX_STREAMS indirectly. Update comment in quic_stream_create(=
).
>   - Replace open-coded kzalloc(sizeof(*stream)) with kzalloc_obj(*stream)
>     in quic_stream_create().
> v11:
>   - Set maximum line length to 80 characters.
>   - Change is_serv parameter type to bool in quic_stream_id_local().
> ---
>  net/quic/Makefile |   2 +-
>  net/quic/socket.c |   5 +
>  net/quic/socket.h |   8 +
>  net/quic/stream.c | 444 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/quic/stream.h | 133 ++++++++++++++
>  5 files changed, 591 insertions(+), 1 deletion(-)
>  create mode 100644 net/quic/stream.c
>  create mode 100644 net/quic/stream.h
>
> diff --git a/net/quic/Makefile b/net/quic/Makefile
> index 13bf4a4e5442..094e9da5d739 100644
> --- a/net/quic/Makefile
> +++ b/net/quic/Makefile
> @@ -5,4 +5,4 @@
>
>  obj-$(CONFIG_IP_QUIC) +=3D quic.o
>
> -quic-y :=3D common.o family.o protocol.o socket.o
> +quic-y :=3D common.o family.o protocol.o socket.o stream.o
> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 8dc2cb7628db..0006668551f4 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -45,11 +45,16 @@ static int quic_init_sock(struct sock *sk)
>         sk_sockets_allocated_inc(sk);
>         sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
>
> +       if (quic_stream_init(quic_streams(sk)))
> +               return -ENOMEM;
> +
>         return 0;
>  }
>
>  static void quic_destroy_sock(struct sock *sk)
>  {
> +       quic_stream_free(quic_streams(sk));
> +
>         quic_data_free(quic_ticket(sk));
>         quic_data_free(quic_token(sk));
>         quic_data_free(quic_alpn(sk));
> diff --git a/net/quic/socket.h b/net/quic/socket.h
> index 61df0c5867be..e76737b9b74b 100644
> --- a/net/quic/socket.h
> +++ b/net/quic/socket.h
> @@ -13,6 +13,7 @@
>
>  #include "common.h"
>  #include "family.h"
> +#include "stream.h"
>
>  #include "protocol.h"
>
> @@ -33,6 +34,8 @@ struct quic_sock {
>         struct quic_data                ticket;
>         struct quic_data                token;
>         struct quic_data                alpn;
> +
> +       struct quic_stream_table        streams;
>  };
>
>  struct quic6_sock {
> @@ -65,6 +68,11 @@ static inline struct quic_data *quic_alpn(const struct=
 sock *sk)
>         return &quic_sk(sk)->alpn;
>  }
>
> +static inline struct quic_stream_table *quic_streams(const struct sock *=
sk)
> +{
> +       return &quic_sk(sk)->streams;
> +}
> +
>  static inline bool quic_is_serv(const struct sock *sk)
>  {
>         return !!sk->sk_max_ack_backlog;
> diff --git a/net/quic/stream.c b/net/quic/stream.c
> new file mode 100644
> index 000000000000..4d980f9b03ce
> --- /dev/null
> +++ b/net/quic/stream.c
> @@ -0,0 +1,444 @@
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
> +#include <linux/quic.h>
> +
> +#include "common.h"
> +#include "stream.h"
> +
> +/* Check if a stream ID is valid for sending or receiving. */
> +static bool quic_stream_id_valid(s64 stream_id, bool is_serv, bool send)
> +{
> +       u8 type =3D (stream_id & QUIC_STREAM_TYPE_MASK);
> +
> +       if (send) {
> +               if (is_serv)
> +                       return type !=3D QUIC_STREAM_TYPE_CLIENT_UNI;
> +               return type !=3D QUIC_STREAM_TYPE_SERVER_UNI;
> +       }
> +       if (is_serv)
> +               return type !=3D QUIC_STREAM_TYPE_SERVER_UNI;
> +       return type !=3D QUIC_STREAM_TYPE_CLIENT_UNI;
> +}
> +
> +/* Check if a stream ID was initiated locally. */
> +static bool quic_stream_id_local(s64 stream_id, bool is_serv)
> +{
> +       return is_serv ^ !(stream_id & QUIC_STREAM_TYPE_SERVER_MASK);
> +}
> +
> +/* Check if a stream ID represents a unidirectional stream. */
> +static bool quic_stream_id_uni(s64 stream_id)
> +{
> +       return stream_id & QUIC_STREAM_TYPE_UNI_MASK;
> +}
> +
> +#define QUIC_STREAM_HT_SIZE    64
> +
> +static struct hlist_head *quic_stream_head(struct quic_stream_table *str=
eams,
> +                                          s64 stream_id)
> +{
> +       return &streams->head[stream_id & (QUIC_STREAM_HT_SIZE - 1)];
> +}
> +
> +struct quic_stream *quic_stream_find(struct quic_stream_table *streams,
> +                                    s64 stream_id)
> +{
> +       struct hlist_head *head =3D quic_stream_head(streams, stream_id);
> +       struct quic_stream *stream;
> +
> +       hlist_for_each_entry(stream, head, node) {
> +               if (stream->id =3D=3D stream_id)
> +                       break;
> +       }
> +       return stream;
> +}
> +
> +static void quic_stream_add(struct quic_stream_table *streams,
> +                           struct quic_stream *stream)
> +{
> +       struct hlist_head *head;
> +
> +       head =3D quic_stream_head(streams, stream->id);
> +       hlist_add_head(&stream->node, head);
> +}
> +
> +static void quic_stream_delete(struct quic_stream *stream)
> +{
> +       hlist_del_init(&stream->node);
> +       kfree(stream);
> +}
> +
> +/* Create and register new streams for sending or receiving. */
> +static struct quic_stream *quic_stream_create(struct quic_stream_table *=
streams,
> +                                             s64 max_stream_id, bool sen=
d,
> +                                             bool is_serv)
> +{
> +       struct quic_stream_limits *limits =3D &streams->send;
> +       struct quic_stream *pos, *stream =3D NULL;
> +       gfp_t gfp =3D GFP_KERNEL_ACCOUNT;
> +       struct hlist_node *tmp;
> +       HLIST_HEAD(head);
> +       s64 stream_id;
> +       u32 count =3D 0;
> +
> +       if (!send) {
> +               limits =3D &streams->recv;
> +               gfp =3D GFP_ATOMIC | __GFP_ACCOUNT;
> +       }
> +       stream_id =3D limits->next_bidi_stream_id;
> +       if (quic_stream_id_uni(max_stream_id))
> +               stream_id =3D limits->next_uni_stream_id;
> +
> +       /* rfc9000#section-2.1: A stream ID that is used out of order res=
ults in
> +        * all streams of that type with lower-numbered stream IDs also b=
eing
> +        * opened.
> +        */
> +       while (stream_id <=3D max_stream_id) {
> +               stream =3D kzalloc_obj(*stream, gfp);
> +               if (!stream)
> +                       goto free;
> +
> +               stream->id =3D stream_id;
> +               if (quic_stream_id_uni(stream_id)) {
> +                       if (send) {
> +                               stream->send.max_bytes =3D
> +                                       limits->max_stream_data_uni;
> +                       } else {
> +                               stream->recv.max_bytes =3D
> +                                       limits->max_stream_data_uni;
> +                               stream->recv.window =3D stream->recv.max_=
bytes;
> +                       }
> +                       hlist_add_head(&stream->node, &head);
> +                       stream_id +=3D QUIC_STREAM_ID_STEP;
> +                       continue;
> +               }
> +
> +               if (quic_stream_id_local(stream_id, is_serv)) {
> +                       stream->send.max_bytes =3D
> +                               streams->send.max_stream_data_bidi_remote=
;
> +                       stream->recv.max_bytes =3D
> +                               streams->recv.max_stream_data_bidi_local;
> +               } else {
> +                       stream->send.max_bytes =3D
> +                               streams->send.max_stream_data_bidi_local;
> +                       stream->recv.max_bytes =3D
> +                               streams->recv.max_stream_data_bidi_remote=
;
> +               }
> +               stream->recv.window =3D stream->recv.max_bytes;
> +               hlist_add_head(&stream->node, &head);
> +               stream_id +=3D QUIC_STREAM_ID_STEP;
> +       }
> +
> +       hlist_for_each_entry_safe(pos, tmp, &head, node) {
> +               hlist_del_init(&pos->node);
> +               quic_stream_add(streams, pos);
> +               count++;
> +       }
> +
> +       /* Streams must be opened sequentially. Update the next stream ID=
 so the
> +        * correct starting point is known if an out-of-order open is req=
uested.
> +        * Note overflow of next_uni/bidi_stream_id is impossible with s6=
4.
> +        */
> +       if (quic_stream_id_uni(stream_id)) {
> +               limits->next_uni_stream_id =3D stream_id;
> +               limits->streams_uni +=3D count;
> +               return stream;
> +       }
> +
> +       limits->next_bidi_stream_id =3D stream_id;
> +       limits->streams_bidi +=3D count;
> +       return stream;
> +
> +free:
> +       hlist_for_each_entry_safe(pos, tmp, &head, node) {
> +               hlist_del_init(&pos->node);
> +               kfree(pos);
> +       }
> +       return NULL;
> +}
> +
> +/* Check if a send or receive stream ID is already closed. */
> +static bool quic_stream_id_closed(struct quic_stream_table *streams,
> +                                 s64 stream_id, bool send)
> +{
> +       struct quic_stream_limits *limits =3D send ? &streams->send :
> +                                                  &streams->recv;
> +
> +       if (quic_stream_id_uni(stream_id))
> +               return stream_id < limits->next_uni_stream_id;
> +       return stream_id < limits->next_bidi_stream_id;
> +}
> +
> +/* Check if a stream ID would exceed local (recv) or peer (send) limits.=
 */
> +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 strea=
m_id,
> +                           bool send)
> +{
> +       u64 nstreams;
> +
> +       if (!send) {
> +               /* recv.max_uni_stream_id is updated in
> +                * quic_stream_max_streams_update() already based on
> +                * next_uni/bidi_stream_id, max_streams_uni/bidi, and
> +                * streams_uni/bidi, so only recv.max_uni_stream_id needs=
 to be
> +                * checked.
> +                */
> +               if (quic_stream_id_uni(stream_id))
> +                       return stream_id > streams->recv.max_uni_stream_i=
d;
> +
> +               return stream_id > streams->recv.max_bidi_stream_id;
> +       }
> +
> +       if (quic_stream_id_uni(stream_id)) {
> +               if (stream_id > streams->send.max_uni_stream_id)
> +                       return true;
> +               stream_id -=3D streams->send.next_uni_stream_id;
> +               nstreams =3D quic_stream_id_to_streams(stream_id);
> +
> +               return nstreams + streams->send.streams_uni >
> +                      streams->send.max_streams_uni;
> +       }
> +
> +       if (stream_id > streams->send.max_bidi_stream_id)
> +               return true;
> +       stream_id -=3D streams->send.next_bidi_stream_id;
> +       nstreams =3D quic_stream_id_to_streams(stream_id);
> +
> +       return nstreams + streams->send.streams_bidi >
> +              streams->send.max_streams_bidi;
> +}
> +
> +/* Get or create a send or recv stream by ID. Requires sock lock held. *=
/
> +struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
> +                                   s64 stream_id, u32 flags, bool is_ser=
v,
> +                                   bool send)
> +{
> +       struct quic_stream *stream;
> +
> +       if (!quic_stream_id_valid(stream_id, is_serv, send))
> +               return ERR_PTR(-EINVAL);
> +
> +       stream =3D quic_stream_find(streams, stream_id);
> +       if (stream) {
> +               if (send && (flags & MSG_QUIC_STREAM_NEW) &&
> +                   stream->send.state !=3D QUIC_STREAM_SEND_STATE_READY)
> +                       return ERR_PTR(-EINVAL);
> +               return stream;
> +       }
> +
> +       if (!send && quic_stream_id_local(stream_id, is_serv)) {
> +               if (quic_stream_id_closed(streams, stream_id, !send))
> +                       return ERR_PTR(-ENOSTR);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       if (quic_stream_id_closed(streams, stream_id, send))
> +               return ERR_PTR(-ENOSTR);
> +
> +       if (send && !(flags & MSG_QUIC_STREAM_NEW))
> +               return ERR_PTR(-EINVAL);
> +
> +       if (quic_stream_id_exceeds(streams, stream_id, send))
> +               return ERR_PTR(-EAGAIN);
> +
> +       stream =3D quic_stream_create(streams, stream_id, send, is_serv);
> +       if (!stream)
> +               return ERR_PTR(-ENOSTR);
> +
> +       if (send || quic_stream_id_valid(stream_id, is_serv, !send))
> +               streams->send.active_stream_id =3D stream_id;
> +
> +       return stream;
> +}
> +
> +/* Release or clean up a send or recv stream. This function updates stre=
am
> + * counters and state when a send stream has either successfully sent al=
l data
> + * or has been reset, or when a recv stream has either consumed all data=
 or has
> + * been reset. Requires sock lock held.
> + */
> +void quic_stream_put(struct quic_stream_table *streams,
> +                    struct quic_stream *stream, bool is_serv, bool send)
> +{
> +       if (quic_stream_id_uni(stream->id)) {
> +               if (send) {
> +                       /* For uni streams, decrement uni count and delet=
e
> +                        * immediately.
> +                        */
> +                       streams->send.streams_uni--;
> +                       quic_stream_delete(stream);
> +                       return;
> +               }
> +               /* For uni streams, decrement uni count and mark done. */
> +               if (!stream->recv.done) {
> +                       stream->recv.done =3D 1;
> +                       streams->recv.streams_uni--;
> +                       streams->recv.uni_pending =3D 1;
> +               }
> +               /* Delete stream if fully read or reset. */
> +               if (stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD)
> +                       quic_stream_delete(stream);
> +               return;
> +       }
> +
> +       if (send) {
> +               /* For bidi streams, only proceed if receive side is in a=
 final
> +                * state.
> +                */
> +               if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
> +                       return;
> +       } else {
> +               /* For bidi streams, only proceed if send side is in a fi=
nal
> +                * state.
> +                */
> +               if (stream->send.state !=3D QUIC_STREAM_SEND_STATE_RECVD =
&&
> +                   stream->send.state !=3D QUIC_STREAM_SEND_STATE_RESET_=
RECVD)
> +                       return;
> +       }
> +
> +       if (quic_stream_id_local(stream->id, is_serv)) {
> +               /* Local-initiated stream: mark send done and decrement
> +                * send.bidi count.
> +                */
> +               if (!stream->send.done) {
> +                       stream->send.done =3D 1;
> +                       streams->send.streams_bidi--;
> +               }
> +       } else {
> +               /* Remote-initiated stream: mark recv done and decrement =
recv
> +                * bidi count.
> +                */
> +               if (!stream->recv.done) {
> +                       stream->recv.done =3D 1;
> +                       streams->recv.streams_bidi--;
> +                       streams->recv.bidi_pending =3D 1;
> +               }
> +       }
> +
> +       /* Delete stream if fully read or reset. */
> +       if (stream->recv.state > QUIC_STREAM_RECV_STATE_RECVD)
> +               quic_stream_delete(stream);
> +}
> +
> +/* Updates the maximum allowed incoming stream IDs if any streams were r=
ecently
> + * closed.  Recalculates the max_uni and max_bidi stream ID limits based=
 on the
> + * number of open streams and whether any were marked for deletion.
> + *
> + * Returns true if either max_uni or max_bidi was updated, indicating th=
at a
> + * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the peer.
> + */
> +bool quic_stream_max_streams_update(struct quic_stream_table *streams,
> +                                   s64 *max_uni, s64 *max_bidi)
> +{
> +       s64 max, rem;
> +
> +       *max_uni =3D 0;
> +       *max_bidi =3D 0;
> +       if (streams->recv.uni_pending) {
> +               rem =3D streams->recv.max_streams_uni - streams->recv.str=
eams_uni;
> +               max =3D streams->recv.next_uni_stream_id - QUIC_STREAM_ID=
_STEP +
> +                     (rem << QUIC_STREAM_TYPE_BITS);
> +
> +               streams->recv.max_uni_stream_id =3D max;
> +               *max_uni =3D quic_stream_id_to_streams(max);
> +               streams->recv.uni_pending =3D 0;
> +       }
> +       if (streams->recv.bidi_pending) {
> +               rem =3D streams->recv.max_streams_bidi -
> +                     streams->recv.streams_bidi;
> +               max =3D streams->recv.next_bidi_stream_id - QUIC_STREAM_I=
D_STEP +
> +                       (rem << QUIC_STREAM_TYPE_BITS);
> +
> +               streams->recv.max_bidi_stream_id =3D max;
> +               *max_bidi =3D quic_stream_id_to_streams(max);
> +               streams->recv.bidi_pending =3D 0;
> +       }
> +
> +       return *max_uni || *max_bidi;
> +}
> +
> +int quic_stream_init(struct quic_stream_table *streams)
> +{
> +       struct hlist_head *head;
> +       int i;
> +
> +       head =3D kmalloc_array(QUIC_STREAM_HT_SIZE, sizeof(*head), GFP_KE=
RNEL);
> +       if (!head)
> +               return -ENOMEM;
> +       for (i =3D 0; i < QUIC_STREAM_HT_SIZE; i++)
> +               INIT_HLIST_HEAD(&head[i]);
> +       streams->head =3D head;
> +       return 0;
> +}
> +
> +void quic_stream_free(struct quic_stream_table *streams)
> +{
> +       struct quic_stream *stream;
> +       struct hlist_head *head;
> +       struct hlist_node *tmp;
> +       int i;
> +
> +       if (!streams->head)
> +               return;
> +
> +       for (i =3D 0; i < QUIC_STREAM_HT_SIZE; i++) {
> +               head =3D &streams->head[i];
> +               hlist_for_each_entry_safe(stream, tmp, head, node)
> +                       quic_stream_delete(stream);
> +       }
> +       kfree(streams->head);
The AI report on

  https://netdev-ai.bots.linux.dev/ai-review.html?id=3D1624d906-c0b6-4e12-a=
63f-5cbfc51b660e#patch-5

is false positive.

As the sk_alloc() calls sk_prot_alloc() with __GFP_ZERO, and the streams->h=
ead
is always initialized to NULL.
