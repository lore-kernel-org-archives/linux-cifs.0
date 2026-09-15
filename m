Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F119B394EB0
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508072; cv=pass; b=U6ML1pjnM/tzfIE0/wPg2NRqbyL4MZOgJQhRk9xf1dQDTHQKaf9j/M0t8jivaeTGf6EW1h0OsuCEeCbjje4agrbsN2SoE78k4UDgloFq+Rkg7va73G4IX7UwZsuwjE8c4u41Bpe0SiLIG+qc8uEeL4JFUZ2WF8+W87I0i5C6aRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508072; c=relaxed/simple;
	bh=3tSi6YPO6dZgLOttRBqCdbt4IoBwpA72PAaMe+M45Sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TaKZtZc8TL3b2vc6KcmC/IOchjKmVYfjFYuDek1SyUhxqD/H1XPsfPRhZCASXIvgwRu3jNC74M4LDUFRcySNXvBGbKRFStK7cRDAARiUc2xDwTt23WonaqWtvAAQpo+uyX8dD8x6MBT4Z0NE2uMTKbFq9liNfc2GhRFvrB9oqs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LP0DNZKW; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LP0DNZKW"
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc50d1b048eso111605a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 14:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789508069; cv=none;
        d=google.com; s=arc-20260327;
        b=Tch7dlQRyaiyWto5tOZJo2qP60Qr+Zkg1iujbUycdMGu2XAnnWcqz58XVL9VSpXbAH
         I/4R0YjNkzZCkK71L3YSceMN+NQUGvEDlroEm6zz1HdE3uqCn7D+koCJITM62HNMPzME
         1MN4yWpzSFoIw8AsX172N5nlsxNQ1MYyiXizHgDdWfeVzOTroNuCIn0thoVwvdlN1IlF
         tsfBQcU0y9pRb8kbuFEWYgYV7EnK+n51st8F1FGN1/N1kTwecgfklCmw9JVFeyTw46t0
         IKrNRGs5KRuU60WvbjpS630fgx5DJmQpYqqJn8TKGRPk4w6oM1y93BRqV1fOnAbu+Ss4
         Zjfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0fEUb43A7umW3ihvJnwkK88IB+JsXUCBhQ/HexoLCXg=;
        fh=DGlC4pzzQI0SFw7wX8CLBk4H2807uFY0Q3/UJJQyiGA=;
        b=bgjrIKAUF0FOl1OwbeDFu6Q6bxy/LTkjKy89o3OkB63pQMfspdt8oV6Mn5/i8bcZex
         L4RsRFftdIS7wRdQvCN1vRGdDlvkoL8fiJMnsmmhU5EYQlULVlTdP5n342w0U6xtpDud
         DKWQcwZRG5sumtoZoHvclNCmSQd9wHQ7htndmlUs6wGm/M2qJ5TaWkdHP6Frs0r/icT/
         ZhKz9njw9XTs0X5lLnbxocsIq8pZHk/I+vL2nzMtfccJPrH0SwEO1I6bFFVq6VKZeOa2
         Kxq2r+qb8WvSsFRBG4LtR5rWHaQyW+4ZaQ9Mr2fyGluA/x7aNDi2ryPHoBIm9cnuVlp3
         oSVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789508069; x=1790112869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0fEUb43A7umW3ihvJnwkK88IB+JsXUCBhQ/HexoLCXg=;
        b=LP0DNZKWysZ2JYOYBxhqxiM+dpgatrCyCQnRqnwO1C3zhethVTLhkjatrz2rns4kM8
         1x4MByDKQi8rzvAiQY+q+aQO0+2RMXxCczO2LwqYtMhf08bCUWU+t27zt9XXEeq8YBH1
         u0M+G+n2gDga8jlPxBJHpGSCema977WNdk7QMyLQTg9TsPhIBD2mNdY/wV89vwx3/gZM
         Kq9T5EHfdhFXhnBcpifVf3vNiaQ5jrC89O1pCtImWpTMwwH6+vfu97Rt7jTq2+FmcRpz
         h378UKWLGV5Z75lXYPDJw7vkfGDoxaC5Rh+Pdzxj8EJj85plvi0o8C9IvQguyra5Dhru
         KnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789508069; x=1790112869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0fEUb43A7umW3ihvJnwkK88IB+JsXUCBhQ/HexoLCXg=;
        b=XGhWyqsKD7sH2eDxwvDfsBc4EcRCE2IUPovnz7sk3M2I8dMEJkHRcVg82A4lbhfUrA
         nypJ1Vs0kWzBaRgho9ZEIDoDoULb5mwXqSk5FPTHh3S2Lgk7xBUtbGqB0CdrU+QVEeg/
         FOimzhtyiyr99Nr64/74jvzfEXeEgBF6BmhHkymX5k27hlEOaMH5rQf7McL7dylPGcol
         cdtlmO31gENAPB96cqgaNaMLF15o0vflckt+jsgoSj0GsNTrSwfwtUxeuGjekwWFJ5+Z
         EYqe3E1DlgaL7u9P1i7VfFsv/KW7EF4h5M5synk6I8DOC87EYlg09EjmSTRcUhfk9MlP
         d6Dw==
X-Forwarded-Encrypted: i=1; AKwUvBz+xOtnq0NnYPd4I4TgF5e2IZMtemAjP+N4DO6srnfJdhdaBR9G6p91TQvKDFr3ss7QpW7SVl8/YFIU@vger.kernel.org
X-Gm-Message-State: AFuF++mZVPrzI+1w7UHWeM93HG3tzIBweeXmL3gxAhScRLtnN3gTzNoJ
	pV9E8zcewVjerF1e9VFIG9djCQHTAsC0tia44MZnX09RleXBN7iGURuFZ26XgyTCdLU81bhFB5B
	fWPSslnaDSdivz3TFs7Jq09TM71RgXww=
X-Gm-Gg: AYBFou1rEk6accjkcDNyoysH9LeeIspgwcwHZ4E0UqWTScZE3NXQD+oDQpHAvyR9JNj
	YWoY5VxiP/xn17BtbwtGDYn/1ZPQPJaDertWuTVU5M4TSLXxu/n8cQsrPMFoafQ0DCZ1L90ISq/
	gwjmxsyyaO4qJSFhIstXOdj26am518ni0ofwz0cDMNCI45BvOGDN5sqpwVrWw/Mwvcth4AmPM30
	4nmZ4MHlKfVCx5hCuAcuWmpFlZdX+4H8BI37uXkkiIFt/xyhy2lbjbEp803+PFN7M6ix6qzNFFL
	qHwoduY67BPhu9SMxTAG/LSvf8MaxcIL47et9aaeHuvzQW58N7XPTGN+NIUSlvWIrm0+8/aKFUT
	ubFcbJTyyQvXx75//sfTpufDJypmkaBhTiGfk4J0pwWVORHWub0oHWQ==
X-Received: by 2002:a05:6a20:914f:b0:3da:bd6d:bef4 with SMTP id
 adf61e73a8af0-3dd5f5ab21cmr393026637.13.1789508069183; Tue, 15 Sep 2026
 14:34:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <40d0796769992c78bffe59b179833d71ed80e771.1789393775.git.lucien.xin@gmail.com>
 <178950186149.22033.824022402798948504@kernel.org>
In-Reply-To: <178950186149.22033.824022402798948504@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 15 Sep 2026 17:34:17 -0400
X-Gm-Features: AcwNN1UCuBUgm-EOueiaZPczPJIdPSEaimJ2WD6qHGHnlwNL-00IDB4em_SMmw4
Message-ID: <CADvbK_foTup7AgsmLPa0=Wabmkj=6QFrzYZ1jFRQX+Wti1_Vbw@mail.gmail.com>
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
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

On Tue, Sep 15, 2026 at 3:51=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 5 =C2=B7 Low: 1
>
> - [High] quic_request_sock_create() publishes a newly allocated request
>   before its first packet is successfully queued: it links req into=E2=80=
=A6
> - [Medium] Commit message understates the scope of the patch and does not
>   disclose that the newly added listen-side connection-establishment=E2=
=80=A6
> - [Medium] quic_listen_sock_lookup() passes hdr_len =3D 1 to
>   reuseport_select_sock() (net/quic/socket.c:292-293), but by the time=E2=
=80=A6
> - [Medium] In quic_accept_sock_exists() (net/quic/socket.c:132-135) and
>   quic_listen_sock_switch() (socket.c:~330) the indirect call is=E2=80=A6
> - [Medium] A QUIC Initial decryption failure inside
>   quic_packet_get_alpn() is counted twice and once under the wrong=E2=80=
=A6
> - [Medium] quic_packet_listen_process() treats every non-zero return of
>   quic_crypto_verify_token() as a peer token-validation failure.
> - [Low] The documented meanings of struct quic_packet's saddr/daddr are
>   the reverse of the new receive-side implementation.
>
> --
>
> quic: add packet parser base
>
> This adds the RX side of the QUIC packet handling: quic_packet_rcv() look=
s
> up the socket for an incoming datagram, quic_packet_process() dispatches =
it,
> and ICMP Packet Too Big errors are turned into PMTU updates.  A listener
> path with ALPN parsing, request sock creation and a per-socket deferred
> workqueue is added as well.
>
> A few questions on the new code below.
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 1e278a2109b2f..0fcb123d31bba 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -24,6 +24,324 @@ static void quic_enter_memory_pressure(struct sock =
*sk)
>
> [ ... ]
>
> > +/* Create and enqueue a QUIC request sock for a new incoming connectio=
n. */
> > +struct quic_request_sock *quic_request_sock_create(struct sock *sk,
> > +                                                struct quic_conn_id *o=
dcid,
> > +                                                u8 retry, gfp_t gfp)
> > +{
>
> [ ... ]
>
> > +     /* Enqueue request into listen socket=E2=80=99s pending list for =
accept(). */
> > +     list_add_tail(&req->list, quic_reqs(sk));
> > +     sk_acceptq_added(sk);
> > +     return req;
> > +}
> > +
> > +int quic_request_sock_backlog_tail(struct sock *sk,
> > +                                struct quic_request_sock *req,
> > +                                struct sk_buff *skb)
> > +{
> > +     u32 limit =3D sk->sk_rcvbuf / sk->sk_max_ack_backlog;
> > +     int len =3D skb->truesize;
> > +
> > +     limit =3D  max_t(u32, limit, QUIC_MIN_UDP_PAYLOAD * 4);
> > +     if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false=
)) {
> > +             QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> > +             kfree_skb(skb);
> > +             return -ENOBUFS;
> > +     }
>
> [Severity: High]
> Can this path leak the quic_request_sock and permanently consume an accep=
t
> queue slot?
>
> quic_request_sock_create() already published the request before the first
> packet was queued:
>
>         list_add_tail(&req->list, quic_reqs(sk));
>         sk_acceptq_added(sk);
>
> and quic_packet_listen_process() then hands it straight to the enqueue:
>
> net/quic/packet.c:
>         out:
>                 /* Add to backlog list and wake blocked accept() calls */
>                 return quic_request_sock_backlog_tail(sk, req, skb);
>
> On the -ENOBUFS path above only the skb is freed.  The request stays link=
ed in
> quic_reqs(sk) with an empty backlog, and sk_acceptq_added() is not undone=
.
>
> The size test is deterministic for a given packet size, since limit is
> max(sk_rcvbuf / sk_max_ack_backlog, QUIC_MIN_UDP_PAYLOAD * 4), so a clien=
t
> sending a large Initial fails on the first attempt and on every
> retransmission, and the slot is never reclaimed.  Repeating with differen=
t
> addresses or DCIDs would then make sk_acceptq_is_full() refuse all furthe=
r
> connections.
>
> Should this failure path unlink and free a freshly created request, or sh=
ould
> the request only be created after the first packet is successfully queued=
?
>
False:

This does not leak the quic_request_sock. The request remains on the
listener's accept queue, so accept() can still consume it and create the
accept socket.

Dropping the skb here only means that this particular packet was not queued
due to the buffer limit. The peer is expected to retransmit the packet, and
once the connection is accepted, the retransmitted packet will be processed
by the accept socket.

(I will check those with 'Severity: Medium' of this patchset tomorrow.)

Thanks.
