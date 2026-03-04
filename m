Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEDF481B1
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666819; cv=pass; b=GteCJy+1jYfJq47Qyb1JG/EIi91UG16IG62uJDa+3c9rA6Y91peENFFttvQKyQhgHXrDfmqv9sVjbRM7Ed1DnEMYdEMrJkBgzwp//O9//aquLMaxr5W/E/8eBzOGu9cdjcqIALPefmFX9BOen5lMbKJR++cS7DqgiGm1taRufIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666819; c=relaxed/simple;
	bh=mNEKFaRMnDHfe0orczkAXGRlU1VB7gl1INEnkvG/KwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iI3GdHd9q6lgdvgebq6ymguf6QYgdEC0d52rm0zIyhJ6zZ9FJhzY8Ueo+uYBmVNQHR7K9Mz2JMaCuN88uXvifWkXwsowC5gGJBggUMvxYb9FvXsCAUCFjiopRlUcwJZz2JnWmhy6WPr+sNPdVdHWFlreaEw/n+SaE/dM4/y/q4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izqTeLNJ; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izqTeLNJ"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ffa0b23a1aso702680137.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 15:26:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772666817; cv=none;
        d=google.com; s=arc-20240605;
        b=ljuAcDSkrIbVH8H0HMm2KxAouWkV6fQUoX5wLiiTjL/pEQhawkgdl07iOKcn85CxqC
         73TqlwHmSndAAWOsJdyz50zPLPLbbLbjg/8VpXfqQM05qC9TyZqYgZkbA3bTd6loQRkC
         sXqdFfJhbCw2bCLc5mGaPvFNUOwaz1XQLcMMP/J+90XkWvmr+LjIjmyJeqrTOY/8Xffn
         c8mc0xEag73P0ESqobnfjZ1xsqlD8aoudZtd2YXHR799XYkvZrc+1bmAeHhfsnD6Z6ub
         xNXOO1YduGeVx778AlcfPcBofzd7sBk5dYmRgx+deIniA3qqfylIzjHNtoK3lU+W1I8s
         H+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cTFDYsqZ964fQZj00eGDb1NQ/WjjGh2BRCQyhHEgw9o=;
        fh=oZSMUTfFXbHl1R39FTsqI7go/eV92W3GLqOaydP6+kI=;
        b=bB9H2lJmG1rwehzBr5HfZ7nueR9mzv2JxFNgYJLJYGBhTakfaAN2vw3l4ayw5rj3YT
         4ThF0wrY8yXMnYIO/0AYMlh+ywC9aCpvARhK/Rp84rPcI9Qp7r2KA783BxbKwsyqXcMm
         BmhueJiw/AQ5FQxTsGrG7OYM5fYTyedQpYVVCiAdsrmbfv5mQokLwfyKT7OSNITR7/dB
         uiLM/C3xlrtu36YnTuhqC4GLSzo7cSQUqu0hyt26z/TJEz4RAafu/rliKyJyhecUjjYF
         W+VAjZPvSEaO6UCBd8OUljRl0xK9gneCBFxPd0kgIlqjzSwyvsf8dKiNfSAcfYeS3+hE
         Gq3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772666817; x=1773271617; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTFDYsqZ964fQZj00eGDb1NQ/WjjGh2BRCQyhHEgw9o=;
        b=izqTeLNJ3HfRvPWHAlCZs+OC5FPcEQu2CpDIzTlRJWn0fztcypamBGdhwNXJigHZOC
         kQxTZh+l7zyd90FHTiPScMAVWQQZZ1iXYgDZsJ1fgVUxzzI+IoB+ps7HCaoz/baECq1J
         v4R1ClyKQy8b060NiH8s9fvZCWRO/Iu9T2j1nRWlHkfpUWHPjcsrgPPQwegt8OnlQzsa
         LI9MbZU/a0gPDuK+oL+KigeI7YbZEvsZgEVtXHTve8PBLsuPweVY0jpWSdt9W2zJUh55
         kOU0QjGiIE3F0Ica82vaD3XjGcqq4fbKnwu+H0RlwCNmVm4NcCaf4oM9mEwfyRzGDOjg
         3YZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772666817; x=1773271617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cTFDYsqZ964fQZj00eGDb1NQ/WjjGh2BRCQyhHEgw9o=;
        b=w/1jL8sPHQq0JbtoHTnmlAaI5MoKK/qzDxKCqQ7pEvA9JnVnMfqv+liz6DPogC8EOe
         BBSbJa1bTnfb7acSRLRf7+sWYUt63IM0/jE1YYMi8wRkaLh2T01L3L/K9ap3NYfrQnx3
         la2j5a5FheNcTa0J+SEZFobyqJHdCxHazTHnkk8awJ6PRW0YBZC0t0xKFO/OBOVn+1RP
         ZwpiGjFkRFpoU7TovIKdutfJMzD0DAbfN8zCJs36uVRXTHm9HhzyuoV8+0h7WTNasSPX
         OHx9zGf4q2/ZhaiGK70Osr+S38PslDGNAsb4kYMdPn0oz9LQeQZ3WihyFQRFxxdn/4bm
         qyKA==
X-Forwarded-Encrypted: i=1; AJvYcCVQUdbQ+l6WYfbOX49HgyV5lkHME8979ayYSDWIBSGtrMLGsOajV4DlsJIfARlgFNwmF9NQGDHeBmJX@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9cPoEQ9Enj4TebKOhn8TwwMK2W1miYSnzhmzZmc8niXTtFAHW
	mdCArtn7VfMJTNDVpg7+iksRC1V4TwK9e9LQrq7Mz5OthpT0gvC9hkwaThnI08dDfbXf/WHMlhb
	P44HvgJSYSixOdZV78/MN37WP80nLeZU=
X-Gm-Gg: ATEYQzy74aXeRiJdH0rVJYk38qjJg2+Rc5lJLs2+bJBMS8VqgGkQ+81+2r9bXPOxnf9
	ygJVZA24hjuYCfkfYtxKZq1VhDBj0B4qQdg9ZNbKAOS6GrBIcnikE8S7jRB3pQBHia6RGIrqlQF
	0PsrIfoKVMpbK/fuGba9mkzGt9jiBu+uYLTWESgeQ322qnjVXFAF5JfP0cSi4jtIXMpBQnrrQtF
	hkYmTLiuui4+SgdOP6IjWY8m+0GaVYSm/YJjQGdT8hpgIk9vWuUgEb3FxWEnZIytiiy8mFfaJkN
	DW3fB9RFDYZbVuXQAkdrDka4xtH/ehWXEsasXzouYfskL3JRegb9aPPQeBy9tdmIF6IjeSR8vpD
	T6Z6d6LmEiqBIZB9U
X-Received: by 2002:a05:6102:6106:20b0:5ff:b684:f796 with SMTP id
 ada2fe7eead31-5ffb684fcb5mr841879137.13.1772666816783; Wed, 04 Mar 2026
 15:26:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
 <CAF6piCJDWjOmgkspuk28qAF8+9xj_o-zTXkUdB+3_waZqaMXBA@mail.gmail.com>
In-Reply-To: <CAF6piCJDWjOmgkspuk28qAF8+9xj_o-zTXkUdB+3_waZqaMXBA@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 18:26:43 -0500
X-Gm-Features: AaiRm51sN3852302sTemIODlyAcPk2eG-uFfqRRmkPhePbFyqTDKIq6vNte4qKM
Message-ID: <CADvbK_djqHEaj1nO1mAR0h9qpkTUX1cXGMPEjrswySM_1bXNvw@mail.gmail.com>
Subject: Re: [PATCH net-next v10 14/15] quic: add packet builder base
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 4:19=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/25/26 3:34 AM, Xin Long wrote:
> > +/* Transmit a QUIC packet, possibly encrypting and bundling it. */
> > +int quic_packet_xmit(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     struct net *net =3D sock_net(sk);
> > +     int err;
> > +
> > +     /* Skip encryption if taglen =3D=3D 0 (e.g., disable_1rtt_encrypt=
ion). */
> > +     if (!packet->taglen[quic_hdr(skb)->form])
> > +             goto xmit;
> > +
> > +     cb->crypto_done =3D quic_packet_encrypt_done;
> > +     /* Associate skb with sk to ensure sk is valid during async encry=
ption completion. */
> > +     WARN_ON(!skb_set_owner_sk_safe(skb, sk));
>
> This is the TX path, how can sk refcout be 0 here? Possibly use
> skb_set_owner_r() directly? At least use the WARN_ON_ONCE() variant and
> add a comment documenting why is needed,
>
skb_set_owner_r() will do memory account with the skb->truesize, which
is not what it wants here. skb_set_owner_sk_safe() is used to keep the
sk not released during async encryption completion, as the comment
above says.

I don't see another set_owner_sk helper for this. Please let me know if
you have a better way for this.

For now I will change from WARN_ON() to WARN_ON_ONCE(), but still keep
skb_set_owner_sk_safe().

> > +     err =3D quic_crypto_encrypt(quic_crypto(sk, packet->level), skb);
> > +     if (err) {
> > +             if (err !=3D -EINPROGRESS) {
> > +                     QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCDROP);
> > +                     kfree_skb(skb);
> > +                     return err;
> > +             }
> > +             QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCBACKLOGS);
> > +             return err;
> > +     }
> > +     if (!cb->resume) /* Encryption completes synchronously. */
> > +             QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCFASTPATHS);
> > +
> > +xmit:
> > +     if (quic_packet_bundle(sk, skb))
> > +             quic_packet_flush(sk);
> > +     return 0;
> > +}
> > +
> > +/* Create and transmit a new QUIC packet. */
> > +int quic_packet_create_and_xmit(struct sock *sk)
> > +{
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     err =3D quic_packet_number_check(sk);
> > +     if (err)
> > +             goto err;
> > +
> > +     if (packet->level)
> > +             skb =3D quic_packet_handshake_create(sk);
> > +     else
> > +             skb =3D quic_packet_app_create(sk);
> > +     if (!skb) {
> > +             err =3D -ENOMEM;
> > +             goto err;
> > +     }
> > +
> > +     err =3D quic_packet_xmit(sk, skb);
> > +     if (err && err !=3D -EINPROGRESS)
> > +             goto err;
> > +
> > +     /* Return 1 if at least one ACK-eliciting (non-PING) frame was se=
nt. */
> > +     return !!packet->frames;
> > +err:
> > +     pr_debug("%s: err: %d\n", __func__, err);
> > +     return 0;
> > +}
> > +
> > +/* Flush any coalesced/bundled QUIC packets. */
> > +void quic_packet_flush(struct sock *sk)
> > +{
> > +     struct quic_path_group *paths =3D quic_paths(sk);
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +
> > +     if (packet->head) {
> > +             quic_lower_xmit(sk, packet->head,
> > +                             quic_path_daddr(paths, packet->path), &pa=
ths->fl);
> > +             packet->head =3D NULL;
> > +     }
> > +}
> > +
> > +void quic_packet_init(struct sock *sk)
> > +{
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +
> > +     INIT_LIST_HEAD(&packet->frame_list);
> > +     packet->taglen[0] =3D QUIC_TAG_LEN;
> > +     packet->taglen[1] =3D QUIC_TAG_LEN;
> > +     packet->mss[0] =3D QUIC_MIN_UDP_PAYLOAD;
> > +     packet->mss[1] =3D QUIC_MIN_UDP_PAYLOAD;
>
> The magic number above looks quite obscure, and AFAICS looking at struct
> quick_packet comments have different meaning. Please use some macro inste=
ad.
>
Sure.
