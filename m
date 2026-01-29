Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BF432860B
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 19:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715589; cv=pass; b=qpbjs1eMuCQZr3M13WpL/ux0ityrvDYEavUVUTUPsHc+lBY5tcZdm1aBeQalOBfL9n4R98AYd86e/xRzzPCfiNrIi1yEybg/PSYMi3U3Yw3/U6YOAAoPapSHeNwLM1bvq4ZM9E7DQ+bwoR7bNo6E2o87wB0Orlr9lfrNhGEC8KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715589; c=relaxed/simple;
	bh=slWb1gPv2FtqXq1twLRiSOtOOA1QvUUzSYzROoZg1Y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMzlIaORqB7gdifpTFCR66Bxbw/5TaEQYAZOHMOyzv1dH3iS6axdd/WNxzgXVjV/+aMGOJRz37HLlf259CMyR+4dkP8lRN05acMN6vZwokNbdkboVQlpPtnG8LNHJQKSKYI9i00IGFh6ozYTfY9KkNGJeEXIjFhS6tA1zbWiues=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBskQaXk; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBskQaXk"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso1535258a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 11:39:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769715587; cv=none;
        d=google.com; s=arc-20240605;
        b=bGnCHMIa0J+6DewC4OxaWu6x7z5Q+fCVznfuUl3dOY8txxM0myFtWX5pjarWI0EMEK
         eRZTRvgeGnb+hqub7ZeS/KriaY7VH3250wpbGhTNbOf1PbwXcVDiQru1Cz64wCsXOCZv
         cxCOrSh+0Bte/LlLqSyGk/wmnW49+Yd+QarYpXy6CdRT2Os39DhEhogGXTLDXKQjY8fI
         jMq/zcx3OSe1SjwSaks7Bs9jBcr5NmLLeLsw40w44YC0hXEGCpU4IEpr5eoQGhFXpn/j
         pyUZq0LiHwsTAVB1QcLVrhAm/z/Q3dZPGiVXHUax3eZLoQXcmulNpTkT4KpoFdhVQeYT
         B0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=76tIsRX/4Fg/g4PCHkk+TBEOGwkN2KFdE8yBjFB4Hrg=;
        fh=z2UJEYGpv40pWLLlf2+oo0W3wnAYeW+nPdoH/XDjfCw=;
        b=jdHm+T+DvHDGekGP+m25XMlj9lo19u356ptMDJhZZ3ptgPmJT84HuM9Yltp3XMKcYZ
         XjidIDNq/IDGSGgczwWK5OZbOFJ+vzQkSSTUUInwogiwcqO+amp5Q4N6w6I2TuitnW/v
         toihCptHPUCyTu9fIb4jx9EkDeJbHUVN2ldJb+qabItMH2Gv8MH+oYg+d/I0GqJ16DIy
         PSzhISuAcMk0fQuAloWjS7+17EJxp1PYQjQgrOVtVN2aCNcRnjSNegnNj9B3XsA9Rr8d
         pZcNA7NiTthWGiCB9aFqnGwv3lE2dHqKhK1cghfL1KXs0jwIBBWwdW821R/A/F0FwD3G
         1mTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769715587; x=1770320387; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76tIsRX/4Fg/g4PCHkk+TBEOGwkN2KFdE8yBjFB4Hrg=;
        b=eBskQaXk2hQaEIK86G5J0Iyuznrw1oI+qxFpSkyfjH4X/Yw2JJRtEjEp2EPpyZLGJV
         KVDcaAy0zRkFE8JpigO72TLmHotHxmjgJorVXIXpoO8SyKZ1IVMDD/n468JZcRld9ZD9
         lK09kaph6FaXUv+6wCBSYLzPN0b6P4xes2zpDpBMRXBiNQm8zL9KqsKLxEf8PUjTR9Rb
         CdIBnGY37raWztdpv9odTDzrH+OSHmX1R62r9jP94/C90ni36ZO9zpdbcxJWCmsBpoXZ
         SwtcUUzNNTnbw7GNiobI7xbvZk8QVNyL2wQkZuCXzsz/0Sx5r/El1/YT4EWJxub41r/x
         lPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769715587; x=1770320387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=76tIsRX/4Fg/g4PCHkk+TBEOGwkN2KFdE8yBjFB4Hrg=;
        b=JQVpmhogOGhIydUjjbXu/oQdyQN+gQzqWwUsatsAbsAcuXjUf9FH18SX/u1Ebhq4mN
         Luy41CcJWNJef3coDYTa+wOrGf9aguaJXL2ccrMnJPruuRB2OcxrUIGl6hdax2W6P2RE
         GB6hDd3ajSwmQUzAx9y1GGoLTmEpFdRMeFnJnq3ik/qLQtnTlOaWZEzp0ij4y9Dq7kv2
         hZ+mjBgRsbl8YNCZ3T7igvUPOZKZDzaTz0ZMkVJsR1Iv7JMb8i0yWacms+ilh9ud9TBS
         f02ZFLj+glf4CWgj/S+Vq5SiZnWZduqJqVAnaO6F2kiZJXCk/AvPg0GGjryY/WTjaWVc
         B1cw==
X-Forwarded-Encrypted: i=1; AJvYcCUib0izyIDhSxdqYrqPYjHf3bKkZca7olSg95RGUDOw8OC/Q/ml6wJGy4F4gmnIIAAWoPV88pKq31F5@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9CZ3R/VBeZTYNeFurAsvC5DLtY8XeyXhJkrG8ed6CbckPnucP
	fk5Cv1pTeOlNbTMgkT6DP6gG6d4ZzYxo4Yf/RjHPW39rnS00xbpLEjlxenC52y7zM4GrvpL6K4P
	ftJwXReRnUlH3Kr84p8VSr9NmCKh9Cgg=
X-Gm-Gg: AZuq6aJ8wP4f8FZzA8XY6OcGIMuphfu5ZgU8nnKwl8FNVL2Eb54GKlVZjD8dzyUStmI
	d0erkfrKWUP1Kvue8Gpf+dytMWlRX9pbGJAbHrVnvRzIoCUdyocR4IQkJKNKOey3RTEUhsTyeGs
	CR5H16k8JlkoWE0MLHbJgx6TOxG2N0Ii6YiZh7NQv0PrfjKSW2cx0380yGpMxKRHwWDgSp8jys5
	9AH3Rad8sl/YjwjmrMsyc31wyL/sPVbTbLigN/Zeaam/wZ8ZJurJJC/Y+tAXr4+EM+QKWzqvZRS
	/lyeL4hABz4gggHJ+/HqTcCoReOPCA==
X-Received: by 2002:a17:90b:33c1:b0:34a:c671:50df with SMTP id
 98e67ed59e1d1-35429b2e55cmr3308198a91.17.1769715587450; Thu, 29 Jan 2026
 11:39:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769439073.git.lucien.xin@gmail.com> <4ec3ade7dfc709658a2b1839dbe29c9467b25fdf.1769439073.git.lucien.xin@gmail.com>
 <b0045978-ea65-422b-8260-d079b43eb553@redhat.com>
In-Reply-To: <b0045978-ea65-422b-8260-d079b43eb553@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Jan 2026 14:39:36 -0500
X-Gm-Features: AZwV_QhlVoBaCiIz5kopBTHIpw23-lZlR_vHRkTAGEfDtCF_CgQBWEVXy3dNJWo
Message-ID: <CADvbK_d9FE+Z72JpdFER65dJ7X19Or_m0sLBPdWOZP9DPbksQA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 14/15] quic: add packet builder base
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

On Thu, Jan 29, 2026 at 11:40=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
>
> On 1/26/26 3:51 PM, Xin Long wrote:
> > +/* Configure the QUIC packet header and routing based on encryption le=
vel and path. */
> > +int quic_packet_config(struct sock *sk, u8 level, u8 path)
> > +{
> > +     struct quic_conn_id_set *dest =3D quic_dest(sk), *source =3D quic=
_source(sk);
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct quic_config *c =3D quic_config(sk);
> > +     u32 hlen =3D QUIC_HLEN;
> > +
> > +     /* If packet already has data, no need to reconfigure. */
> > +     if (!quic_packet_empty(packet))
> > +             return 0;
> > +
> > +     packet->ack_eliciting =3D 0;
> > +     packet->frame_len =3D 0;
> > +     packet->ipfragok =3D 0;
> > +     packet->padding =3D 0;
> > +     packet->frames =3D 0;
> > +     hlen +=3D QUIC_PACKET_NUMBER_LEN; /* Packet number length. */
> > +     hlen +=3D quic_conn_id_choose(dest, path)->len; /* DCID length. *=
/
> > +     if (level) {
> > +             hlen +=3D 1; /* Length byte for DCID. */
> > +             hlen +=3D 1 + quic_conn_id_active(source)->len; /* Length=
 byte + SCID length. */
> > +             if (level =3D=3D QUIC_CRYPTO_INITIAL) /* Include token fo=
r Initial packets. */
> > +                     hlen +=3D quic_var_len(quic_token(sk)->len) + qui=
c_token(sk)->len;
> > +             hlen +=3D QUIC_VERSION_LEN; /* Version length. */
> > +             hlen +=3D QUIC_PACKET_LENGTH_LEN; /* Packet length field =
length. */
> > +             /* Allow fragmentation if PLPMTUD is enabled, as it no lo=
nger relies on ICMP
> > +              * Toobig messages to discover the path MTU.
> > +              */
> > +             packet->ipfragok =3D !!c->plpmtud_probe_interval;
> > +     }
> > +     packet->level =3D level;
> > +     packet->len =3D (u16)hlen;
> > +     packet->overhead =3D (u8)hlen;
>
> Given the above math, it looks like hlen can never be > 255, but
> possibly a DEBUG_NET_WARN_ON_ONCE() could save from future bug and make
> the code more clear?
>
sounds good.

> > +
> > +     if (packet->path !=3D path) { /* If the path changed, update and =
reset routing cache. */
> > +             packet->path =3D path;
> > +             __sk_dst_reset(sk);
> > +     }
> > +
> > +     /* Perform routing and MSS update for the configured packet. */
> > +     if (quic_packet_route(sk) < 0)
> > +             return -1;
> > +     return 0;
> > +}
> > +
> > +static void quic_packet_encrypt_done(struct sk_buff *skb, int err)
> > +{
> > +     /* Free it for now, future patches will implement the actual defe=
rred transmission logic. */
> > +     kfree_skb(skb);
> > +}
> > +
> > +/* Coalescing Packets. */
> > +static int quic_packet_bundle(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     struct quic_skb_cb *head_cb, *cb =3D QUIC_SKB_CB(skb);
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct sk_buff *p;
> > +
> > +     if (!packet->head) { /* First packet to bundle: initialize the he=
ad. */
> > +             packet->head =3D skb;
> > +             cb->last =3D skb;
> > +             goto out;
> > +     }
> > +
> > +     /* If bundling would exceed MSS, flush the current bundle. */
> > +     if (packet->head->len + skb->len >=3D packet->mss[0]) {
> > +             quic_packet_flush(sk);
> > +             packet->head =3D skb;
> > +             cb->last =3D skb;
> > +             goto out;
>
> The same code is duplicate a few lines above; you could reduce
> duplication jumping to a common label.
>
will add a goto label at the end for this:

init:
        packet->head =3D skb;
        cb->last =3D skb;
        goto out;

Thanks.
