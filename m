Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E022E3B0E
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758643615; cv=none; b=IzumaCUwYwjp9X6ycJVvRayd6JBBSlqRCOIBb3XGMeiu41/8DdyRjj5B8IqEtWDKSocvo2X4PNchL+OhE9lgZsS3M5T9FckPnRHGGZgeWrq/6/Wachv40zFaqmDFFrQDI5Ro772TjExOplaqKLh7A9D/D6GvQt7/icw5dtJDQTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758643615; c=relaxed/simple;
	bh=LSZaSxvgiNpblG6l7iGMnvMkhnGQyUdC6rYhgCCt/B4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=al3kWsaO1iOGacVVP9eBKFPfvMN7Den1EEO/Ex084EVbaLh+KMyyl3XplA8SjT0+E1qtCYsw1fnR70M0JEVAN59AsV8r/MUh/JblJaNJTb/UMsScgyb192QuxLEUZz72j9mfLtXd3G97r8I5tuXNXFMPgnszb026xRI9cnvyUXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDAZQFLb; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDAZQFLb"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-279e2554b5fso288405ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758643614; x=1759248414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfZwWS5AXjSjh47+jujhHs0PNbVVMWVBOW1GeBhi9ZA=;
        b=jDAZQFLbYRjypsVLouT9JktzAGT65qfWajmhbBYcLDoe6lf1WQ2s8ns7TuAb+y1buj
         LqfsfmHJg20yW5zp7bsSRORX3VSChltKpnBt9nPYyWTRFw10QImNwec4CSoiif0F0zfN
         qLIZdzu0zDbPAQ2DfoWZjUNgceQiBcRgfQCrZqA8EnyqRAhRg8T2r8HbzDuqtHOyTdEX
         9Ur04TDIpRh71U5BB9NWJwklFZgnOD20VrXv/du4pYv9JCmQaHoAmOvW5ziY7t6Jm1Go
         c7eWs8PU1CoWTtnxPY/yYgFKf++IvfK1o/qJDTg1v1JVWQ13z6J9/CeNpdNd4iVJy3Oj
         kdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758643614; x=1759248414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lfZwWS5AXjSjh47+jujhHs0PNbVVMWVBOW1GeBhi9ZA=;
        b=InxotGrCkQtcFeSn2V89RT8NX3jOCwEgYj9+6nSiZTmA9iZG1peLR+JcqOvgVL4zce
         4gCeIEx7W+IRk9hUdiKjIDBFur8JWR1oGYLJJRjgszGCt9K3d0DPI7yrkNfO8+EHc5do
         dVJuM/9CYldoF6IWfd4Sjlu0jmvLX/ahAXMfXB0T6XjGiigUB569FlMoAmDvZ+2jh5qL
         B/lzNm2mr4SpS4nTtgaBUcwVq21sLwCRqNUihM1XMN9EgCJ9qfJmG+qHifB1SxyFUNf5
         mTufQPa/a5SK6CPsjSiRkUTCXxyxVrcUiitBLU1vyDTTwg/hF10+JdFhu2hLcEBYF/gq
         7P6w==
X-Forwarded-Encrypted: i=1; AJvYcCX9Fk1seftJHQfCeQvqM0UQKP/Wv9ehR5j05W6uC7ZfKANBce1hr3KEf6YLNGn/XDtgokim5RgVcPWM@vger.kernel.org
X-Gm-Message-State: AOJu0YymURRjf7lD30G268G/rb2QBbYQ1c31i4IXmjCZZVES6vh+5cOp
	reeSld2N2A6P8a8JPEYrx4Uxw+lId79QOfa3kvcdKN3WlOe3Zxl9CwTAdU7a4E0ommL+U6r+oDg
	L61HgUPDsFgCP8VWFznzuEP0AvzeKTGE=
X-Gm-Gg: ASbGncuY6l4RcTVi7EOJEiR4jg0ZdlcyJc1POF2/bfDS1P54EvHkGyeOxps5NOR65Oz
	3jYp2K3BfNoIjJdCBFClTysdRqNGsrN6BC58FogIYIuRR7tZEZUKsBr3pTo9EkDQT5q2p9XK0sx
	M2/Imz8s3oYw9KPqds1V9K2TZvrM/pOXX5yOi7EH/1Awd5kY+CUWxc0lOrAySFX6Y7EdyjpnGe2
	X+1Fuo7LaLx6qxujNnIx9dQQQ3IA0GtgHoqLX4VVw==
X-Google-Smtp-Source: AGHT+IElrnbiPc11xcIlgx/7eLp17j7KN5c1/0biJ0i/uJUb0MwRHW0VDJc6A4N7uhdDkUSkX1wG1aPAZnUI5GY+570=
X-Received: by 2002:a17:903:2447:b0:266:3f63:3500 with SMTP id
 d9443c01a7336-27cd7a31339mr34522615ad.12.1758643613364; Tue, 23 Sep 2025
 09:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>
 <871ed254-c3d8-49aa-9aac-eeb72e82f55d@redhat.com>
In-Reply-To: <871ed254-c3d8-49aa-9aac-eeb72e82f55d@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 12:06:41 -0400
X-Gm-Features: AS18NWD1Po0NumxImO775C_7VSP655cJIPbmA0dWx2wuT8JxABkrL-E_ndi5lAw
Message-ID: <CADvbK_e20TrcgprXmnZzvoEO6yzoo4Zx7B0qFS0kQPT8Sf63LQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 03/15] quic: provide common utilities and data structures
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

On Tue, Sep 23, 2025 at 7:21=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/19/25 12:34 AM, Xin Long wrote:
> > This patch provides foundational data structures and utilities used
> > throughout the QUIC stack.
> >
> > It introduces packet header types, connection ID support, and address
> > handling. Hash tables are added to manage socket lookup and connection
> > ID mapping.
> >
> > A flexible binary data type is provided, along with helpers for parsing=
,
> > matching, and memory management. Helpers for encoding and decoding
> > transport parameters and frames are also included.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> > v3:
> >   - Rework hashtables: split into two types and size them based on
> >     totalram_pages(), similar to SCTP (reported by Paolo).
> >   - struct quic_shash_table: use rwlock instead of spinlock.
>
> Why? rwlock usage should be avoided in networking (as it's unfair, see
> the many refactors replacing rwlock with rcu/plain spinlock)
Interesting, I thought rwlock works better than spinlock in this case.
I will change back to spinlock.

>
> [...]
> > +
> > +static int quic_uhash_table_init(struct quic_uhash_table *ht, u32 max_=
size, int order)
> > +{
> > +     int i, max_order, size;
> > +
> > +     /* Same sizing logic as in quic_shash_table_init(). */
> > +     max_order =3D get_order(max_size * sizeof(struct quic_uhash_head)=
);
> > +     order =3D min(order, max_order);
> > +     do {
> > +             ht->hash =3D (struct quic_uhash_head *)
> > +                     __get_free_pages(GFP_KERNEL | __GFP_NOWARN, order=
);
> > +     } while (!ht->hash && --order > 0);
>
> You can avoid a little complexity, and see more consistent behaviour,
> using plain vmalloc() or alloc_large_system_hash() with no fallback.
>
I wanted to use alloc_large_system_hash(), but the memory allocated
by it is usually NOT meant to be freed at runtime. I don't see a free_
function to do it either.

If QUIC works as a kernel module, what should I do with this memory
in module_exit()?

>
> > +/* rfc9000#section-a.3: DecodePacketNumber()
> > + *
> > + * Reconstructs the full packet number from a truncated one.
> > + */
> > +s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n)
> > +{
> > +     s64 expected =3D max_pkt_num + 1;
> > +     s64 win =3D BIT_ULL(n * 8);
> > +     s64 hwin =3D win / 2;
> > +     s64 mask =3D win - 1;
> > +     s64 cand;
> > +
> > +     cand =3D (expected & ~mask) | pkt_num;
> > +     if (cand <=3D expected - hwin && cand < (1ULL << 62) - win)
> > +             return cand + win;
> > +     if (cand > expected + hwin && cand >=3D win)
> > +             return cand - win;
> > +     return cand;
>
> The above is a bit obscure to me; replacing magic nubers (62) with macro
> could help. Some more comments also would do.
>
The code is exactly from the commented doc:
/* rfc9000#section-a.3: DecodePacketNumber()

See:
https://datatracker.ietf.org/doc/html/rfc9000#section-a.3

I will bring some comments from there.

Thanks.
