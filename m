Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59883B71AA
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572117; cv=pass; b=mktmdKeVBQUF+cVMIHZyuTrs1xt8sdx9Bhzu0z+CFBLGE+XQvZNDKVCVpBuDgfJX6z3Bzb6aQpeq/Kie+NhRnsG67movVvwwmswKVVR1u7CWxmSQIyTwBpZ10ekMHC1KkRkuf8F6n6UmB64Q7w3IZemXPvwF9R8H4BXDDaqDfss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572117; c=relaxed/simple;
	bh=ZLzBSbLHdIx7oKJft5euLp5tK8dytE+WWJeEygpcoPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mxZGOxZRqGEJpYaYnhEftAwEnHf90hSy7anAdKK2flMu9n/m0+3qgkDRuohzhVS6rcifpg/b3WexPl1ttqa+5IVYkVEeCfIscchrOhuwNvFyq3w4qL0LPEbSajR7PWEKlihuWFiBx8Srg6OLbNNyufN5elOzPp9mOjJh9c/H1wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q/oljoSn; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/oljoSn"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so923996b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789572109; cv=none;
        d=google.com; s=arc-20260327;
        b=YXCUFjCkQohkAkMD3n3tr1OzDPvgwD5VkKEshpwpHXXYQeoC0VdxyILebgT9qMUvni
         DzC9qSgw57bGnFgl5IjJQ8FdpnGgmNFnyi81ADMjcQk7wFBMiHyjFB6rx3rieLbJCjML
         1LkKWjAa2rkiECs84LKj1bsyu1Gb+LFIg0nrSsGOukLTvySwQ44roLYuQI39JOWr/5PM
         y3IddnLZtnsTbhBbOmIa9+OLE4mSCYiY4AE+670X2+p2DLsOhEvzv31e6ADTz/xDO9Qx
         8FrxhF9XJ5Z62U4/Z8/SyGxOUdjYQNVpMGsB5w74/GKctpk8MDiv5CYOQbRR6dJdI2tf
         HBJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p1eY0XzQHV53ynXnFivLaDlowT7CeoLCfbXUtFiZQ8o=;
        fh=FDJH6pZ9Jp2sXnF6+7F4sxgOzbsMYZR8h0wSnAV9UIs=;
        b=Yf/bqhnY1JInwL2LlC0WuO6lSuuIkdYhdx2iu1F9GaFZMrbDddXO3faLxUIQWS/UlP
         MqaISB1z+ORUI47xs69KYGZTRBjBbcqKaNCW87a7BriQHaxi9TBPrL99e5IgU6jvG6KA
         T8hDF0ytzF/IjKEX38CppmEuI0EZPbmYz+R04oHisaE0BF8VVpbxAG24Qx+mndHJL1OT
         EQQArrST7FYDRHH/D6WGPHBGXf+8dqMb35EanAlepEx0qhZ9zJHIXBtPGvByI1lDGCJH
         DQupoUf3bCDt9t+zwhCA+Rzo6SgjlwJOHM2ZD4kZbOw4ByYIfjAENMf56PhcDsfz8EL+
         SyCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789572109; x=1790176909; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p1eY0XzQHV53ynXnFivLaDlowT7CeoLCfbXUtFiZQ8o=;
        b=q/oljoSng/SVRm/Bujcm3uQnDd7ITD961bNsR2YS5xwjwuEt8LkNL1N/CebjYR7wlh
         ILtTP2ncqsaViM2SJULaMmxpzepMBixcWIHz8sz6Lv/ZEAplYiO2Zm4W2gUWjZZfmIm0
         UVgza+SbSWWxIvA8JOgpqAVlWhmozdC9MeuSd9ZEx6KYG6XQfnBXrgZ+NI7mhJTp8KbS
         0T7kXDGYUGSKdxC4+2HH6MnTng/TWP60Hz3Sz9jGvHRPlcuKzhsUw8yUDbNi2Ks8Mdp+
         SgU+am5n+u9TK1hp2YrEjbwDp1Y5SSn18jJUr4+9wkAZhMfmDIF5tJTt8kbRQXQuWjO4
         Is6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572109; x=1790176909;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p1eY0XzQHV53ynXnFivLaDlowT7CeoLCfbXUtFiZQ8o=;
        b=uhUN+aNUQ69SiHJOIJo7mgap7D3Wcllok5Cg8NjnCyGRRhmku+DpLPWEr73Qqfm9/y
         zN0FvbilldxBCVSE7e8TgK/2k+XCZMG4iUr5hSo/vvG/zPy/6QEdsBwnLzQTxeTiZuuT
         v4RYBnFV80Z0JFJzTTRqHWY9oc4ahxQmKMfQbedpZZU6qKesgJOyFYqTnO7DsErrD7BI
         xqXhwxyqI3Y6IlXkeBHWUoRYu777th2dr9ySqB9qlPDDo02RCRoR75AARmTCIAIZ9/NS
         xiwMHCR3Sg8d6q2YcRKuC2x23aDBJ3NoxEFVzAngyICEUWsSMP9KOKc4f75QfTObMVIh
         23kg==
X-Forwarded-Encrypted: i=1; AKwUvBw5JMlnmPIW1En89EK6+dnMyqCVlZZjodZ3OZEZbOuQZGCAv+domvIG3BM3FgGJ96VG0YC3g22aZXYS@vger.kernel.org
X-Gm-Message-State: AFuF++lR47L9eQ7n0YiZCHp7b3jqDu/P5DOERLdIzC5mFVk/jG2GfZ0K
	foxS326riramHrkilgqCHijKL+2oM+sLb9eimihgIkV24jhqK6vjIcLvl1kOUc9XgJmDGvqdHEB
	lsq5ki84vMO1a/zb87PcKbr878pb1zhg=
X-Gm-Gg: AYBFou2xSFMuA62jD8izycDoALRQqtwRB70J9kEOgBzgbnQV+vN0MtdN3i6zxO12zkf
	cYIthB2d13G3AkB2ez3giHRcQ5wLpfOaeNhMFiPIZ2F+gfgRi9+gpZ0y3Xp6q8Q5+nihStZNKW/
	TePZ771CGEcIxsqP5XPqTqP2akWou4Ar1vUPGNTM8hL3GG4NHU8SfF2O51CoYjZVh+g8DTGNDb/
	sbH+bCGgm/M4Myxi5Olf109p7TDbjbAdcORjT9uC7Bz/+FkyYiJaTipxN4l3yH8XaARvIR3pqQQ
	LHlhhJNMtMZ7/L0VRCKJq/0eH7pVrgMuSHRiInMmwrVHqGSBa8E1RmqspDdNcOQ5152ZQD6sPvm
	yzngUB2VzHU4k9nUIu0OC0FbEhQG3Jxibti2bPQLAXi8e2w489h+mi0TW
X-Received: by 2002:a05:6a00:4fc3:b0:86f:2d2f:48ef with SMTP id
 d2e1a72fcca58-87236ddb105mr6042886b3a.1.1789572108837; Wed, 16 Sep 2026
 08:21:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6d7bfc9ba424a7170befff9ca9eaed1663017ca8.1789393775.git.lucien.xin@gmail.com>
 <178950183921.22033.10083649522216474862@kernel.org>
In-Reply-To: <178950183921.22033.10083649522216474862@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 11:21:36 -0400
X-Gm-Features: AcwNN1UD3xdvGptxprJEVONmj0qpc-MJ-3juUKU_3i9i2Xyg8-vDsV7GrGmZ3i4
Message-ID: <CADvbK_ejqDoS3bA33Ryi-qeNV7eRbTE9QPc-90XDoRujmuaoxg@mail.gmail.com>
Subject: Re: [PATCH net-next v15 06/15] quic: add stream management
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev, 
	chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de, 
	aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org, 
	mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com, 
	jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net, 
	marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 2
>
> - [Medium] quic_stream_set_param() (net/quic/stream.c:387-416) treats the
>   UAPI field `struct quic_transport_param::remote` (a __u8, so 0..255)=E2=
=80=A6
> - [Low] quic_stream_create() (net/quic/stream.c:83-160) allocates each
>   stream with kzalloc_obj() and explicitly initializes only id,=E2=80=A6
> - [Low] Concern: quic_stream_free() is called from quic_destroy_sock()
>   (net/quic/socket.c:60), i.e. from proto->destroy, which=E2=80=A6
>
> --
>
> quic: add stream management
>
> Adds struct quic_stream_table and struct quic_stream along with the
> per-socket stream hash table, the acquire/release helpers
> quic_stream_get()/quic_stream_put(), the stream ID limit checks, and the
> transport parameter get/set helpers.  The table is allocated in
> quic_init_sock() and released in quic_destroy_sock().
>
> A few questions below about stream state initialization, the handling of
> the transport parameter "remote" field, and the teardown ordering.
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 0e0a13235fa42..731c1e00dba2b 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -49,11 +49,16 @@ static int quic_init_sock(struct sock *sk)
> >       sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
> >       INIT_LIST_HEAD(quic_reqs(sk));
> >
> > +     if (quic_stream_init(quic_streams(sk)))
> > +             return -ENOMEM;
> > +
> >       return 0;
> >  }
> >
> >  static void quic_destroy_sock(struct sock *sk)
> >  {
> > +     quic_stream_free(quic_streams(sk));
>
> [Severity: Low]
> Is the stream table teardown ordering here what is intended for later
> patches?  quic_destroy_sock() is proto->destroy, and sk_common_release()
> runs it before ->unhash(), with no socket lock held:
>
> net/core/sock.c:sk_common_release() {
>         ...
>         if (sk->sk_prot->destroy)
>                 sk->sk_prot->destroy(sk);
>         ...
>         sk->sk_prot->unhash(sk);
>         ...
> }
>
> So quic_stream_free() frees streams->head and then stores NULL into it at
> a point where the socket is no longer reachable from user space but is
> still, in principle, reachable from the network.  A concurrent
> quic_stream_find() would then walk freed hlist heads, or dereference NULL
> in quic_stream_head().
>
> Nothing can hit this in the current tree, since quic_hash() is
> "return 0;" and quic_unhash() is empty, so a QUIC socket is never inserte=
d
> into a hash table and cannot be looked up from the receive path.  Would i=
t
> still be worth doing the free after unhash, or under the socket lock the
> way udp_destroy_sock() does with lock_sock_fast(), so this stays correct
> once the lookup paths land?
>
> [ ... ]
>
> > diff --git a/net/quic/stream.c b/net/quic/stream.c
> > new file mode 100644
> > index 0000000000000..6b34b117103a8
> > --- /dev/null
> > +++ b/net/quic/stream.c
> > @@ -0,0 +1,416 @@
>
> [ ... ]
>
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
> > +                             stream->recv.window =3D stream->recv.max_=
bytes;
> > +                     }
>
> [Severity: Low]
> Should stream->recv.state be initialized here?
>
> The stream comes from kzalloc_obj(), and only id, send.max_bytes,
> recv.max_bytes and recv.window are assigned, so recv.state stays 0.  The
> send and receive states share one enum in include/uapi/linux/quic.h:
>
>         enum {
>                 QUIC_STREAM_SEND_STATE_READY,
>                 ...
>                 QUIC_STREAM_SEND_STATE_RESET_RECVD,
>
>                 QUIC_STREAM_RECV_STATE_RECV,
>                 ...
>         };
>
> which makes 0 equal to QUIC_STREAM_SEND_STATE_READY, while
> QUIC_STREAM_RECV_STATE_RECV is 6.
>
> net/quic/stream.h documents the field as a receive state:
>
>                 u8 state;  /* Receive stream state, per rfc9000#section-3=
.2 */
>
> and quic_stream_put() compares it against the receive constants:
>
>                 if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
>                         return;
>
> This comparison happens to give the same answer for 0 as for 6, so nothin=
g
> misbehaves today, and the same field is what gets reported to user space =
as
> struct quic_stream_update::state.  Would setting recv.state to
> QUIC_STREAM_RECV_STATE_RECV at creation time (or documenting that 0 means
> "Recv") avoid an equality test going wrong later?
>
> [ ... ]
>
> > +/* Configure stream hashtable from transport parameters. */
> > +void quic_stream_set_param(struct quic_stream_table *streams,
> > +                        struct quic_transport_param *p, bool is_serv)
> > +{
> > +     struct quic_stream_limits *limits =3D p->remote ? &streams->send =
:
> > +                                                     &streams->recv;
> > +     u8 bidi_type, uni_type;
> > +
> [ ... ]
> > +     if (p->remote ^ is_serv) {
> > +             bidi_type =3D QUIC_STREAM_TYPE_CLIENT_BIDI;
> > +             uni_type =3D QUIC_STREAM_TYPE_CLIENT_UNI;
> > +     } else {
> > +             bidi_type =3D QUIC_STREAM_TYPE_SERVER_BIDI;
> > +             uni_type =3D QUIC_STREAM_TYPE_SERVER_UNI;
> > +     }
>
> [Severity: Medium]
> Can the two different interpretations of p->remote in this function
> disagree?  It is a __u8 in the uAPI (struct quic_transport_param), so it
> can hold 0..255.  The limits selection uses a truth test, while the type
> selection uses a bitwise XOR, so for p->remote =3D=3D 2 with is_serv =3D=
=3D true:
>
>         limits    =3D &streams->send              /* truth test: non-zero=
 */
>         2 ^ 1 =3D 3 -> non-zero                   /* takes the CLIENT bra=
nch */
>         bidi_type =3D QUIC_STREAM_TYPE_CLIENT_BIDI
>
> which leaves streams->send.next_bidi_stream_id =3D 0 on a server instead =
of
> 1.  Would !!p->remote ^ is_serv (or rejecting p->remote > 1) keep the two
> tests consistent?
>
> The follow-on in that state is that quic_stream_get() for the server's
> first bidi stream (ID 1) passes every gate: quic_stream_id_valid(1, true,
> true) is true, find() returns NULL, quic_stream_id_local(1, true) is true=
,
> quic_stream_id_closed() is false because 1 < 0 is false, and
> quic_stream_id_exceeds() is false.  quic_stream_create() then starts at
> stream_id 0:
>
> > +     while (stream_id <=3D max_stream_id) {
>
> allocates a single stream with id 0, advances stream_id to 4 and returns
> that stream.  quic_stream_get() reports success and records
> streams->send.active_stream_id =3D 1 for a stream that does not exist, wh=
ile
> ID 1 is now permanently -ENOSTR because next_bidi_stream_id is 4.
>
> A later quic_stream_put() on the returned stream 0 evaluates
> quic_stream_id_local(0, true) as false and decrements
> streams->recv.streams_bidi, which was never incremented, so that u16
> underflows and feeds quic_stream_max_streams_update().
>
> quic_stream_set_param() has no caller yet in the tree, so this is
> forward-looking rather than something reachable today.  Along the same
> lines, should quic_stream_create() return an error rather than a stream
> whose id differs from the requested max_stream_id, since no caller can
> detect that today?
>
False:

The caller of quic_stream_set_param() added in the next patchset validates
p->remote and ensures it can only be 0 or 1.

Thanks.
