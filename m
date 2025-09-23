Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3D425EFBC
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758650257; cv=none; b=nVTjNdbp778LB8k3/Vz4oGv6+dEkBMkvW43kU79uaQtrotBjfIlba67tiaWaqWLmEsWxt50ebvltMQiFGOpMSXE2CZFLdkE4VVTSflDh73McmwS6W42kS18fU5vRefs2yfFwkqDBxdwPUlr7Obiohev2CDgw8y+8uANuX6BDb6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758650257; c=relaxed/simple;
	bh=y/G88UjMYSxmXMgKEB7dyY548Jt/ioDjjbupV/B82oo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QnKRq5gsNgX54yVQ+k1SuaX3lOPeGigGBPFdXb0XJbehUehHtQT8zboayroTI0vJ+Hl6nhK/DJSlqtnbEDlNtRpvmJLYuRStLNiZ2/4QxanYX4OHhmUNUPc5IJ3ZQ3UgSEmAwQK0qzKQihBhX6ZuCYVphDqCP3tslyO4e4zOVc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUvpcglo; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUvpcglo"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77dedf198d4so6478408b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 10:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758650254; x=1759255054; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AmDBgIqa0GQv/6KlVcndAFVjR2baAAmtK92NT5CTo0=;
        b=QUvpcglouDvHDi/Ucof7RdxEzGQSuPRttRnPtxXuOfv2kPXynk7w4GnjCYbzvgilFc
         O0HLhg3pkpPWhtw7oQ5Am8+iL9GBx+kL/MyA1p2GE4XlbdBV9pX5TAnXzsiM3L7WtHvG
         k/xrdlSN2zWfHJQT09oKp+bBeE14vcJqx01NsK2uB34VDDwq6p26GNxL6+KWxDL1r4HK
         e/rlFRhQJH2PvpDAmWmQkKjT4lgF7vWZoks9u2tVQgAn6EeqG8xYUgI7YqwCrmaA0n69
         5ZZXEgPP0Y6tmd0QxOqSX6OQSx/hEAD4Z9yTjJ62bgOl/7b+zJ3NqRTRtinbakjiNbbx
         oapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758650254; x=1759255054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1AmDBgIqa0GQv/6KlVcndAFVjR2baAAmtK92NT5CTo0=;
        b=XFg8Rttrnt0eI+OSr6KsSZ0alkHhh4OuFmZ8TTfSb1PwBXFweGPYKoS2F3z/occRvG
         8xmgj4G+jMd4ypyqi8t85ch6Hgg8Of7tixyA1p1tvq6ghifUO/Ea9u3Rm3rdJ8orvtY9
         3ssC7YiC0PJ2HfLY/5O8GexzxuXpVSe0eor/+/7eGdPyl+ZCQgV9Pjl1Fg+nIsh9KQBO
         W9REwYXZgVEVMDltuMXbTDU4mUqIL1vPaxUY2d/1XjFE2yRIyBGl+T7NmClF+EBg3Sym
         +UxnUGTBFn52831cA0FAj3qF9EgEmXY/YmGVHePEv/HJwlcyXBBeUEXihUcoQxovRiqZ
         w+wg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ9Fsy9HsGNkXgwVVFFrsLoEaGtlNeNHf6Wj7916bxBHie7fH+bQtXTU0C4g786sq9S1m7311ClBQ6@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1A5U5DZGQnLzLdQrhm+WH5S/z+QJNrUCo0325V5Snen1nkW6l
	3BAgTGgv8YjSVQbsBa7XkxSxNrFQ47blGLZ7q3LSlBpeEOrdLEJiLjic0A9gERs+8zsaBrqmz2p
	772Zl8H2AgO7nmDO5NAiuqBhPpKa2dvE=
X-Gm-Gg: ASbGncufIqPRD1vH7NjeoooUAA0RdzghxhQIteb5zx3eTyrOy6JQ9fPCC+wxzwuqDt6
	0WxTnz0hldLQOTnLgVGdPwuiVrULbWuXAKF93J6aVD7ndNQwzCKy6GLiZGNnAheHzddfj+FDVT1
	phFxdJBJ1V9wkyCbXkwoWTs7yu1ojuC/aRR+d3GRhjVIFAjUswIHJgBTyFCuBpxMJ0x9CThZxXr
	ad0RAwqmCNYNsxQC2WH
X-Google-Smtp-Source: AGHT+IE2yrnjqr6a/d2F9JpSJ3fKE/tBDXIcVfjLA5i2kIJdnBi4ppu1dEMj7GfZ5CUkqovx62NduVZt8+JKZlibwJI=
X-Received: by 2002:a05:6a00:2e1f:b0:77f:2de7:eef3 with SMTP id
 d2e1a72fcca58-77f53897e35mr3765409b3a.5.1758650254151; Tue, 23 Sep 2025
 10:57:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
 <2ef635de-7282-4ffe-bdfc-eceafa73857e@redhat.com>
In-Reply-To: <2ef635de-7282-4ffe-bdfc-eceafa73857e@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 13:57:21 -0400
X-Gm-Features: AS18NWBglKznECkCvBSvE49wohtKt7Wb-bJD9HSQrOopK0dNd_e3hdXuel4AAoU
Message-ID: <CADvbK_fE1KHbgtZV4zY1xXo94avimgxBcoakyoAYPOsb-U3rSw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 06/15] quic: add stream management
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

On Tue, Sep 23, 2025 at 9:39=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/25 12:34 AM, Xin Long wrote:
> > +/* Create and register new streams for sending. */
> > +static struct quic_stream *quic_stream_send_create(struct quic_stream_=
table *streams,
> > +                                                s64 max_stream_id, u8 =
is_serv)
> > +{
> > +     struct quic_stream *stream;
> > +     s64 stream_id;
> > +
> > +     stream_id =3D streams->send.next_bidi_stream_id;
> > +     if (quic_stream_id_uni(max_stream_id))
> > +             stream_id =3D streams->send.next_uni_stream_id;
> > +
> > +     /* rfc9000#section-2.1: A stream ID that is used out of order res=
ults in all streams
> > +      * of that type with lower-numbered stream IDs also being opened.
> > +      */
> > +     while (stream_id <=3D max_stream_id) {
> > +             stream =3D kzalloc(sizeof(*stream), GFP_KERNEL);
> > +             if (!stream)
> > +                     return NULL;
>
> How many streams and connections ID do you foresee per socket? Could
> such number grow significantly (possibly under misuse/attack)? If so you
> you likely use GFP_KERNEL_ACCOUNT here (and in conn_id allocation).
connections ID: 8 (QUIC_CONN_ID_LIMIT) at most per socket.
streams: 4096 (QUIC_MAX_STREAMS) at most per socket.

I can switch to GFP_KERNEL_ACCOUNT in quic_stream_send_create().

For quic_stream_recv_create(), it=E2=80=99s typically invoked in atomic con=
text.
Since there=E2=80=99s no predefined GFP_ATOMIC_ACCOUNT, I assume using
(GFP_ATOMIC | __GFP_ACCOUNT) should be acceptable.

Thanks.
>
> /P
>
> > +
> > +             stream->id =3D stream_id;
> > +             if (quic_stream_id_uni(stream_id)) {
> > +                     stream->send.max_bytes =3D streams->send.max_stre=
am_data_uni;
> > +
> > +                     if (streams->send.next_uni_stream_id < stream_id =
+ QUIC_STREAM_ID_STEP)
> > +                             streams->send.next_uni_stream_id =3D stre=
am_id + QUIC_STREAM_ID_STEP;
> > +                     streams->send.streams_uni++;
> > +
> > +                     quic_stream_add(streams, stream);
> > +                     stream_id +=3D QUIC_STREAM_ID_STEP;
> > +                     continue;
> > +             }
> > +
> > +             if (streams->send.next_bidi_stream_id < stream_id + QUIC_=
STREAM_ID_STEP)
> > +                     streams->send.next_bidi_stream_id =3D stream_id +=
 QUIC_STREAM_ID_STEP;
> > +             streams->send.streams_bidi++;
> > +
> > +             if (quic_stream_id_local(stream_id, is_serv)) {
> > +                     stream->send.max_bytes =3D streams->send.max_stre=
am_data_bidi_remote;
> > +                     stream->recv.max_bytes =3D streams->recv.max_stre=
am_data_bidi_local;
> > +             } else {
> > +                     stream->send.max_bytes =3D streams->send.max_stre=
am_data_bidi_local;
> > +                     stream->recv.max_bytes =3D streams->recv.max_stre=
am_data_bidi_remote;
> > +             }
> > +             stream->recv.window =3D stream->recv.max_bytes;
> > +
> > +             quic_stream_add(streams, stream);
> > +             stream_id +=3D QUIC_STREAM_ID_STEP;
> > +     }
> > +     return stream;
> > +}
> > +
> > +/* Create and register new streams for receiving. */
> > +static struct quic_stream *quic_stream_recv_create(struct quic_stream_=
table *streams,
> > +                                                s64 max_stream_id, u8 =
is_serv)
> > +{
> > +     struct quic_stream *stream;
> > +     s64 stream_id;
> > +
> > +     stream_id =3D streams->recv.next_bidi_stream_id;
> > +     if (quic_stream_id_uni(max_stream_id))
> > +             stream_id =3D streams->recv.next_uni_stream_id;
> > +
> > +     /* rfc9000#section-2.1: A stream ID that is used out of order res=
ults in all streams
> > +      * of that type with lower-numbered stream IDs also being opened.
> > +      */
> > +     while (stream_id <=3D max_stream_id) {
> > +             stream =3D kzalloc(sizeof(*stream), GFP_ATOMIC);
> > +             if (!stream)
> > +                     return NULL;
> > +
> > +             stream->id =3D stream_id;
> > +             if (quic_stream_id_uni(stream_id)) {
> > +                     stream->recv.window =3D streams->recv.max_stream_=
data_uni;
> > +                     stream->recv.max_bytes =3D stream->recv.window;
> > +
> > +                     if (streams->recv.next_uni_stream_id < stream_id =
+ QUIC_STREAM_ID_STEP)
> > +                             streams->recv.next_uni_stream_id =3D stre=
am_id + QUIC_STREAM_ID_STEP;
> > +                     streams->recv.streams_uni++;
> > +
> > +                     quic_stream_add(streams, stream);
> > +                     stream_id +=3D QUIC_STREAM_ID_STEP;
> > +                     continue;
> > +             }
> > +
> > +             if (streams->recv.next_bidi_stream_id < stream_id + QUIC_=
STREAM_ID_STEP)
> > +                     streams->recv.next_bidi_stream_id =3D stream_id +=
 QUIC_STREAM_ID_STEP;
> > +             streams->recv.streams_bidi++;
> > +
> > +             if (quic_stream_id_local(stream_id, is_serv)) {
> > +                     stream->send.max_bytes =3D streams->send.max_stre=
am_data_bidi_remote;
> > +                     stream->recv.max_bytes =3D streams->recv.max_stre=
am_data_bidi_local;
> > +             } else {
> > +                     stream->send.max_bytes =3D streams->send.max_stre=
am_data_bidi_local;
> > +                     stream->recv.max_bytes =3D streams->recv.max_stre=
am_data_bidi_remote;
> > +             }
> > +             stream->recv.window =3D stream->recv.max_bytes;
> > +
> > +             quic_stream_add(streams, stream);
> > +             stream_id +=3D QUIC_STREAM_ID_STEP;
> > +     }
> > +     return stream;
> > +}
> > +
> > +/* Check if a send or receive stream ID is already closed. */
> > +static bool quic_stream_id_closed(struct quic_stream_table *streams, s=
64 stream_id, bool send)
> > +{
> > +     if (quic_stream_id_uni(stream_id)) {
> > +             if (send)
> > +                     return stream_id < streams->send.next_uni_stream_=
id;
> > +             return stream_id < streams->recv.next_uni_stream_id;
> > +     }
> > +     if (send)
> > +             return stream_id < streams->send.next_bidi_stream_id;
> > +     return stream_id < streams->recv.next_bidi_stream_id;
> > +}
> > +
> > +/* Check if a stream ID would exceed local (recv) or peer (send) limit=
s. */
> > +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 str=
eam_id, bool send)
> > +{
> > +     u64 nstreams;
> > +
> > +     if (!send) {
> > +             if (quic_stream_id_uni(stream_id))
> > +                     return stream_id > streams->recv.max_uni_stream_i=
d;
> > +             return stream_id > streams->recv.max_bidi_stream_id;
> > +     }
> > +
> > +     if (quic_stream_id_uni(stream_id)) {
> > +             if (stream_id > streams->send.max_uni_stream_id)
> > +                     return true;
> > +             stream_id -=3D streams->send.next_uni_stream_id;
> > +             nstreams =3D quic_stream_id_to_streams(stream_id);
> > +             return nstreams + streams->send.streams_uni > streams->se=
nd.max_streams_uni;
> > +     }
> > +
> > +     if (stream_id > streams->send.max_bidi_stream_id)
> > +             return true;
> > +     stream_id -=3D streams->send.next_bidi_stream_id;
> > +     nstreams =3D quic_stream_id_to_streams(stream_id);
> > +     return nstreams + streams->send.streams_bidi > streams->send.max_=
streams_bidi;
> > +}
> > +
> > +/* Get or create a send stream by ID. */
> > +struct quic_stream *quic_stream_send_get(struct quic_stream_table *str=
eams, s64 stream_id,
> > +                                      u32 flags, bool is_serv)
> > +{
> > +     struct quic_stream *stream;
> > +
> > +     if (!quic_stream_id_valid(stream_id, is_serv, true))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     stream =3D quic_stream_find(streams, stream_id);
> > +     if (stream) {
> > +             if ((flags & MSG_STREAM_NEW) &&
> > +                 stream->send.state !=3D QUIC_STREAM_SEND_STATE_READY)
> > +                     return ERR_PTR(-EINVAL);
> > +             return stream;
> > +     }
> > +
> > +     if (quic_stream_id_closed(streams, stream_id, true))
> > +             return ERR_PTR(-ENOSTR);
> > +
> > +     if (!(flags & MSG_STREAM_NEW))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     if (quic_stream_id_exceeds(streams, stream_id, true))
> > +             return ERR_PTR(-EAGAIN);
> > +
> > +     stream =3D quic_stream_send_create(streams, stream_id, is_serv);
> > +     if (!stream)
> > +             return ERR_PTR(-ENOSTR);
> > +     streams->send.active_stream_id =3D stream_id;
> > +     return stream;
> > +}
> > +
> > +/* Get or create a receive stream by ID. */
> > +struct quic_stream *quic_stream_recv_get(struct quic_stream_table *str=
eams, s64 stream_id,
> > +                                      bool is_serv)
> > +{
> > +     struct quic_stream *stream;
> > +
> > +     if (!quic_stream_id_valid(stream_id, is_serv, false))
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     stream =3D quic_stream_find(streams, stream_id);
> > +     if (stream)
> > +             return stream;
> > +
> > +     if (quic_stream_id_local(stream_id, is_serv)) {
> > +             if (quic_stream_id_closed(streams, stream_id, true))
> > +                     return ERR_PTR(-ENOSTR);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> > +     if (quic_stream_id_closed(streams, stream_id, false))
> > +             return ERR_PTR(-ENOSTR);
> > +
> > +     if (quic_stream_id_exceeds(streams, stream_id, false))
> > +             return ERR_PTR(-EAGAIN);
> > +
> > +     stream =3D quic_stream_recv_create(streams, stream_id, is_serv);
> > +     if (!stream)
> > +             return ERR_PTR(-ENOSTR);
> > +     if (quic_stream_id_valid(stream_id, is_serv, true))
> > +             streams->send.active_stream_id =3D stream_id;
> > +     return stream;
> > +}
> > +
> > +/* Release or clean up a send stream. This function updates stream cou=
nters and state when
> > + * a send stream has either successfully sent all data or has been res=
et.
> > + */
> > +void quic_stream_send_put(struct quic_stream_table *streams, struct qu=
ic_stream *stream,
> > +                       bool is_serv)
> > +{
> > +     if (quic_stream_id_uni(stream->id)) {
> > +             /* For unidirectional streams, decrement uni count and de=
lete immediately. */
> > +             streams->send.streams_uni--;
> > +             quic_stream_delete(stream);
> > +             return;
> > +     }
> > +
> > +     /* For bidi streams, only proceed if receive side is in a final s=
tate. */
> > +     if (stream->recv.state !=3D QUIC_STREAM_RECV_STATE_RECVD &&
> > +         stream->recv.state !=3D QUIC_STREAM_RECV_STATE_READ &&
> > +         stream->recv.state !=3D QUIC_STREAM_RECV_STATE_RESET_RECVD)
> > +             return;
> > +
> > +     if (quic_stream_id_local(stream->id, is_serv)) {
> > +             /* Local-initiated stream: mark send done and decrement s=
end.bidi count. */
> > +             if (!stream->send.done) {
> > +                     stream->send.done =3D 1;
> > +                     streams->send.streams_bidi--;
> > +             }
> > +             goto out;
> > +     }
> > +     /* Remote-initiated stream: mark recv done and decrement recv bid=
i count. */
> > +     if (!stream->recv.done) {
> > +             stream->recv.done =3D 1;
> > +             streams->recv.streams_bidi--;
> > +             streams->recv.bidi_pending =3D 1;
> > +     }
> > +out:
> > +     /* Delete stream if fully read or reset. */
> > +     if (stream->recv.state !=3D QUIC_STREAM_RECV_STATE_RECVD)
> > +             quic_stream_delete(stream);
> > +}
> > +
> > +/* Release or clean up a receive stream. This function updates stream =
counters and state when
> > + * the receive side has either consumed all data or has been reset.
> > + */
> > +void quic_stream_recv_put(struct quic_stream_table *streams, struct qu=
ic_stream *stream,
> > +                       bool is_serv)
> > +{
> > +     if (quic_stream_id_uni(stream->id)) {
> > +             /* For uni streams, decrement uni count and mark done. */
> > +             if (!stream->recv.done) {
> > +                     stream->recv.done =3D 1;
> > +                     streams->recv.streams_uni--;
> > +                     streams->recv.uni_pending =3D 1;
> > +             }
> > +             goto out;
> > +     }
> > +
> > +     /* For bidi streams, only proceed if send side is in a final stat=
e. */
> > +     if (stream->send.state !=3D QUIC_STREAM_SEND_STATE_RECVD &&
> > +         stream->send.state !=3D QUIC_STREAM_SEND_STATE_RESET_RECVD)
> > +             return;
> > +
> > +     if (quic_stream_id_local(stream->id, is_serv)) {
> > +             /* Local-initiated stream: mark send done and decrement s=
end.bidi count. */
> > +             if (!stream->send.done) {
> > +                     stream->send.done =3D 1;
> > +                     streams->send.streams_bidi--;
> > +             }
> > +             goto out;
> > +     }
> > +     /* Remote-initiated stream: mark recv done and decrement recv bid=
i count. */
> > +     if (!stream->recv.done) {
> > +             stream->recv.done =3D 1;
> > +             streams->recv.streams_bidi--;
> > +             streams->recv.bidi_pending =3D 1;
> > +     }
> > +out:
> > +     /* Delete stream if fully read or reset. */
> > +     if (stream->recv.state !=3D QUIC_STREAM_RECV_STATE_RECVD)
> > +             quic_stream_delete(stream);
> > +}
> > +
> > +/* Updates the maximum allowed incoming stream IDs if any streams were=
 recently closed.
> > + * Recalculates the max_uni and max_bidi stream ID limits based on the=
 number of open
> > + * streams and whether any were marked for deletion.
> > + *
> > + * Returns true if either max_uni or max_bidi was updated, indicating =
that a
> > + * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the pee=
r.
> > + */
> > +bool quic_stream_max_streams_update(struct quic_stream_table *streams,=
 s64 *max_uni, s64 *max_bidi)
> > +{
> > +     if (streams->recv.uni_pending) {
> > +             streams->recv.max_uni_stream_id =3D
> > +                     streams->recv.next_uni_stream_id - QUIC_STREAM_ID=
_STEP +
> > +                     ((streams->recv.max_streams_uni - streams->recv.s=
treams_uni) <<
> > +                      QUIC_STREAM_TYPE_BITS);
> > +             *max_uni =3D quic_stream_id_to_streams(streams->recv.max_=
uni_stream_id);
> > +             streams->recv.uni_pending =3D 0;
> > +     }
> > +     if (streams->recv.bidi_pending) {
> > +             streams->recv.max_bidi_stream_id =3D
> > +                     streams->recv.next_bidi_stream_id - QUIC_STREAM_I=
D_STEP +
> > +                     ((streams->recv.max_streams_bidi - streams->recv.=
streams_bidi) <<
> > +                      QUIC_STREAM_TYPE_BITS);
> > +             *max_bidi =3D quic_stream_id_to_streams(streams->recv.max=
_bidi_stream_id);
> > +             streams->recv.bidi_pending =3D 0;
> > +     }
> > +
> > +     return *max_uni || *max_bidi;
> > +}
> > +
> > +#define QUIC_STREAM_HT_SIZE  64
> > +
> > +int quic_stream_init(struct quic_stream_table *streams)
> > +{
> > +     struct quic_shash_table *ht =3D &streams->ht;
> > +     int i, size =3D QUIC_STREAM_HT_SIZE;
> > +     struct quic_shash_head *head;
> > +
> > +     head =3D kmalloc_array(size, sizeof(*head), GFP_KERNEL);
> > +     if (!head)
> > +             return -ENOMEM;
> > +     for (i =3D 0; i < size; i++)
> > +             INIT_HLIST_HEAD(&head[i].head);
> > +     ht->size =3D size;
> > +     ht->hash =3D head;
> > +     return 0;
> > +}
> > +
> > +void quic_stream_free(struct quic_stream_table *streams)
> > +{
> > +     struct quic_shash_table *ht =3D &streams->ht;
> > +     struct quic_shash_head *head;
> > +     struct quic_stream *stream;
> > +     struct hlist_node *tmp;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ht->size; i++) {
> > +             head =3D &ht->hash[i];
> > +             hlist_for_each_entry_safe(stream, tmp, &head->head, node)
> > +                     quic_stream_delete(stream);
> > +     }
> > +     kfree(ht->hash);
> > +}
> > +
> > +/* Populate transport parameters from stream hash table. */
> > +void quic_stream_get_param(struct quic_stream_table *streams, struct q=
uic_transport_param *p,
> > +                        bool is_serv)
> > +{
> > +     if (p->remote) {
> > +             p->max_stream_data_bidi_remote =3D streams->send.max_stre=
am_data_bidi_remote;
> > +             p->max_stream_data_bidi_local =3D streams->send.max_strea=
m_data_bidi_local;
> > +             p->max_stream_data_uni =3D streams->send.max_stream_data_=
uni;
> > +             p->max_streams_bidi =3D streams->send.max_streams_bidi;
> > +             p->max_streams_uni =3D streams->send.max_streams_uni;
> > +             return;
> > +     }
> > +
> > +     p->max_stream_data_bidi_remote =3D streams->recv.max_stream_data_=
bidi_remote;
> > +     p->max_stream_data_bidi_local =3D streams->recv.max_stream_data_b=
idi_local;
> > +     p->max_stream_data_uni =3D streams->recv.max_stream_data_uni;
> > +     p->max_streams_bidi =3D streams->recv.max_streams_bidi;
> > +     p->max_streams_uni =3D streams->recv.max_streams_uni;
> > +}
> > +
> > +/* Configure stream hashtable from transport parameters. */
> > +void quic_stream_set_param(struct quic_stream_table *streams, struct q=
uic_transport_param *p,
> > +                        bool is_serv)
> > +{
> > +     u8 type;
> > +
> > +     if (p->remote) {
> > +             streams->send.max_stream_data_bidi_local =3D p->max_strea=
m_data_bidi_local;
> > +             streams->send.max_stream_data_bidi_remote =3D p->max_stre=
am_data_bidi_remote;
> > +             streams->send.max_stream_data_uni =3D p->max_stream_data_=
uni;
> > +             streams->send.max_streams_bidi =3D p->max_streams_bidi;
> > +             streams->send.max_streams_uni =3D p->max_streams_uni;
> > +             streams->send.active_stream_id =3D -1;
> > +
> > +             if (is_serv) {
> > +                     type =3D QUIC_STREAM_TYPE_SERVER_BIDI;
> > +                     streams->send.max_bidi_stream_id =3D
> > +                             quic_stream_streams_to_id(p->max_streams_=
bidi, type);
> > +                     streams->send.next_bidi_stream_id =3D type;
> > +
> > +                     type =3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +                     streams->send.max_uni_stream_id =3D
> > +                             quic_stream_streams_to_id(p->max_streams_=
uni, type);
> > +                     streams->send.next_uni_stream_id =3D type;
> > +                     return;
> > +             }
> > +
> > +             type =3D QUIC_STREAM_TYPE_CLIENT_BIDI;
> > +             streams->send.max_bidi_stream_id =3D
> > +                     quic_stream_streams_to_id(p->max_streams_bidi, ty=
pe);
> > +             streams->send.next_bidi_stream_id =3D type;
> > +
> > +             type =3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +             streams->send.max_uni_stream_id =3D
> > +                     quic_stream_streams_to_id(p->max_streams_uni, typ=
e);
> > +             streams->send.next_uni_stream_id =3D type;
> > +             return;
> > +     }
> > +
> > +     streams->recv.max_stream_data_bidi_local =3D p->max_stream_data_b=
idi_local;
> > +     streams->recv.max_stream_data_bidi_remote =3D p->max_stream_data_=
bidi_remote;
> > +     streams->recv.max_stream_data_uni =3D p->max_stream_data_uni;
> > +     streams->recv.max_streams_bidi =3D p->max_streams_bidi;
> > +     streams->recv.max_streams_uni =3D p->max_streams_uni;
> > +
> > +     if (is_serv) {
> > +             type =3D QUIC_STREAM_TYPE_CLIENT_BIDI;
> > +             streams->recv.max_bidi_stream_id =3D
> > +                     quic_stream_streams_to_id(p->max_streams_bidi, ty=
pe);
> > +             streams->recv.next_bidi_stream_id =3D type;
> > +
> > +             type =3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +             streams->recv.max_uni_stream_id =3D
> > +                     quic_stream_streams_to_id(p->max_streams_uni, typ=
e);
> > +             streams->recv.next_uni_stream_id =3D type;
> > +             return;
> > +     }
> > +
> > +     type =3D QUIC_STREAM_TYPE_SERVER_BIDI;
> > +     streams->recv.max_bidi_stream_id =3D
> > +             quic_stream_streams_to_id(p->max_streams_bidi, type);
> > +     streams->recv.next_bidi_stream_id =3D type;
> > +
> > +     type =3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +     streams->recv.max_uni_stream_id =3D
> > +             quic_stream_streams_to_id(p->max_streams_uni, type);
> > +     streams->recv.next_uni_stream_id =3D type;
> > +}
> > diff --git a/net/quic/stream.h b/net/quic/stream.h
> > new file mode 100644
> > index 000000000000..c53d9358605c
> > --- /dev/null
> > +++ b/net/quic/stream.h
> > @@ -0,0 +1,136 @@
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
> > +#define QUIC_DEF_STREAMS     100
> > +#define QUIC_MAX_STREAMS     4096ULL
> > +
> > +/*
> > + * rfc9000#section-2.1:
> > + *
> > + *   The least significant bit (0x01) of the stream ID identifies the =
initiator of the stream.
> > + *   Client-initiated streams have even-numbered stream IDs (with the =
bit set to 0), and
> > + *   server-initiated streams have odd-numbered stream IDs (with the b=
it set to 1).
> > + *
> > + *   The second least significant bit (0x02) of the stream ID distingu=
ishes between bidirectional
> > + *   streams (with the bit set to 0) and unidirectional streams (with =
the bit set to 1).
> > + */
> > +#define QUIC_STREAM_TYPE_BITS        2
> > +#define QUIC_STREAM_ID_STEP  BIT(QUIC_STREAM_TYPE_BITS)
> > +
> > +#define QUIC_STREAM_TYPE_CLIENT_BIDI 0x00
> > +#define QUIC_STREAM_TYPE_SERVER_BIDI 0x01
> > +#define QUIC_STREAM_TYPE_CLIENT_UNI  0x02
> > +#define QUIC_STREAM_TYPE_SERVER_UNI  0x03
> > +
> > +struct quic_stream {
> > +     struct hlist_node node;
> > +     s64 id;                         /* Stream ID as defined in RFC 90=
00 Section 2.1 */
> > +     struct {
> > +             /* Sending-side stream level flow control */
> > +             u64 last_max_bytes;     /* Maximum send offset advertised=
 by peer at last update */
> > +             u64 max_bytes;          /* Current maximum offset we are =
allowed to send to */
> > +             u64 bytes;              /* Bytes already sent to peer */
> > +
> > +             u32 errcode;            /* Application error code to send=
 in RESET_STREAM */
> > +             u32 frags;              /* Number of sent STREAM frames n=
ot yet acknowledged */
> > +             u8 state;               /* Send stream state, per rfc9000=
#section-3.1 */
> > +
> > +             u8 data_blocked:1;      /* True if flow control blocks se=
nding more data */
> > +             u8 done:1;              /* True if application indicated =
end of stream (FIN sent) */
> > +     } send;
> > +     struct {
> > +             /* Receiving-side stream level flow control */
> > +             u64 max_bytes;          /* Maximum offset peer is allowed=
 to send to */
> > +             u64 window;             /* Remaining receive window befor=
e advertise a new limit */
> > +             u64 bytes;              /* Bytes consumed by application =
from the stream */
> > +
> > +             u64 highest;            /* Highest received offset */
> > +             u64 offset;             /* Offset up to which data is in =
buffer or consumed */
> > +             u64 finalsz;            /* Final size of the stream if FI=
N received */
> > +
> > +             u32 frags;              /* Number of received STREAM fram=
es pending reassembly */
> > +             u8 state;               /* Receive stream state, per rfc9=
000#section-3.2 */
> > +
> > +             u8 stop_sent:1;         /* True if STOP_SENDING has been =
sent */
> > +             u8 done:1;              /* True if FIN received and final=
 size validated */
> > +     } recv;
> > +};
> > +
> > +struct quic_stream_table {
> > +     struct quic_shash_table ht;     /* Hash table storing all active =
streams */
> > +
> > +     struct {
> > +             /* Parameters received from peer, defined in rfc9000#sect=
ion-18.2 */
> > +             u64 max_stream_data_bidi_remote;        /* initial_max_st=
ream_data_bidi_remote */
> > +             u64 max_stream_data_bidi_local;         /* initial_max_st=
ream_data_bidi_local */
> > +             u64 max_stream_data_uni;                /* initial_max_st=
ream_data_uni */
> > +             u64 max_streams_bidi;                   /* initial_max_st=
reams_bidi */
> > +             u64 max_streams_uni;                    /* initial_max_st=
reams_uni */
> > +
> > +             s64 next_bidi_stream_id;        /* Next bidi stream ID to=
 be opened */
> > +             s64 next_uni_stream_id;         /* Next uni stream ID to =
be opened */
> > +             s64 max_bidi_stream_id;         /* Highest allowed bidi s=
tream ID */
> > +             s64 max_uni_stream_id;          /* Highest allowed uni st=
ream ID */
> > +             s64 active_stream_id;           /* Most recently opened s=
tream ID */
> > +
> > +             u8 bidi_blocked:1;      /* True if STREAMS_BLOCKED_BIDI w=
as sent and not ACKed */
> > +             u8 uni_blocked:1;       /* True if STREAMS_BLOCKED_UNI wa=
s sent and not ACKed */
> > +             u16 streams_bidi;       /* Number of currently active bid=
i streams */
> > +             u16 streams_uni;        /* Number of currently active uni=
 streams */
> > +     } send;
> > +     struct {
> > +              /* Our advertised limits to the peer, per rfc9000#sectio=
n-18.2 */
> > +             u64 max_stream_data_bidi_remote;        /* initial_max_st=
ream_data_bidi_remote */
> > +             u64 max_stream_data_bidi_local;         /* initial_max_st=
ream_data_bidi_local */
> > +             u64 max_stream_data_uni;                /* initial_max_st=
ream_data_uni */
> > +             u64 max_streams_bidi;                   /* initial_max_st=
reams_bidi */
> > +             u64 max_streams_uni;                    /* initial_max_st=
reams_uni */
> > +
> > +             s64 next_bidi_stream_id;        /* Next expected bidi str=
eam ID from peer */
> > +             s64 next_uni_stream_id;         /* Next expected uni stre=
am ID from peer */
> > +             s64 max_bidi_stream_id;         /* Current allowed bidi s=
tream ID range */
> > +             s64 max_uni_stream_id;          /* Current allowed uni st=
ream ID range */
> > +
> > +             u8 bidi_pending:1;      /* True if MAX_STREAMS_BIDI needs=
 to be sent */
> > +             u8 uni_pending:1;       /* True if MAX_STREAMS_UNI needs =
to be sent */
> > +             u16 streams_bidi;       /* Number of currently open bidi =
streams */
> > +             u16 streams_uni;        /* Number of currently open uni s=
treams */
> > +     } recv;
> > +};
> > +
> > +static inline u64 quic_stream_id_to_streams(s64 stream_id)
> > +{
> > +     return (u64)(stream_id >> QUIC_STREAM_TYPE_BITS) + 1;
> > +}
> > +
> > +static inline s64 quic_stream_streams_to_id(u64 streams, u8 type)
> > +{
> > +     return (s64)((streams - 1) << QUIC_STREAM_TYPE_BITS) | type;
> > +}
> > +
> > +struct quic_stream *quic_stream_send_get(struct quic_stream_table *str=
eams, s64 stream_id,
> > +                                      u32 flags, bool is_serv);
> > +struct quic_stream *quic_stream_recv_get(struct quic_stream_table *str=
eams, s64 stream_id,
> > +                                      bool is_serv);
> > +void quic_stream_send_put(struct quic_stream_table *streams, struct qu=
ic_stream *stream,
> > +                       bool is_serv);
> > +void quic_stream_recv_put(struct quic_stream_table *streams, struct qu=
ic_stream *stream,
> > +                       bool is_serv);
> > +
> > +bool quic_stream_max_streams_update(struct quic_stream_table *streams,=
 s64 *max_uni, s64 *max_bidi);
> > +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 str=
eam_id, bool send);
> > +struct quic_stream *quic_stream_find(struct quic_stream_table *streams=
, s64 stream_id);
> > +
> > +void quic_stream_get_param(struct quic_stream_table *streams, struct q=
uic_transport_param *p,
> > +                        bool is_serv);
> > +void quic_stream_set_param(struct quic_stream_table *streams, struct q=
uic_transport_param *p,
> > +                        bool is_serv);
> > +void quic_stream_free(struct quic_stream_table *streams);
> > +int quic_stream_init(struct quic_stream_table *streams);
>
