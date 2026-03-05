Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1172E40B
	for <linux-cifs@vger.kernel.org>; Thu,  5 Mar 2026 00:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772669698; cv=pass; b=qGHlytWUdyqE6EFoYNscYqJB4XZFma5pJQIkDJjpMwNtURoYWOCfJJ67kMC4nt1K387NBCBciFwl2aMTBpZJGlvGw4mdC7BTIRmLh8PUH1sDD6Ys6hTj5AMuita+5AwaURPqSIpYKW/9f51gz/WnhtxbvyFyOakeYuPMFsIjfFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772669698; c=relaxed/simple;
	bh=SNH6I/hhPmgSL35V+oZOn5ErlBAd3yoW65QFOWZVpMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zi9/cIgUNYiNoes76xGfavPqKgzFWbUQvHqLm7kmDJTbxk7Hi7vdw0evLoVrKWVOEtUqoGrNJ3UpscmQVGMRq+6HqzpT0nnDEx67XTX+Dc5UcJKAedFiK35CkkfA8gZ+rXR2MIT/Pu8rQC4S2SbDsI4twJFDukVJeesifZSExX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMvbfNck; arc=pass smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMvbfNck"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5ff174502ffso5312237137.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 16:14:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772669695; cv=none;
        d=google.com; s=arc-20240605;
        b=NnPouUXh9rEYmAhs0pVgRmkTWKI1Bbmj/uy1G5UCmol2MfI20LfRtEV1gjPX12ttJX
         uJrtHbrVz2f8acjk2jvEWdBNuzDS/sH6FJzlPfS4hWl8szu8TqXGa0bqezMbhR9Fmw8F
         VS269Ovd8l/HT9pHmDvumrZxtczph2YCHenshMi+Zt1Oo4SWtje4W88UZh+whgggttTe
         ubgJXb+y0Z9seT166J+jFsTKt23SvA3xWyo7CwpGPmPoFMRtEtAdSg6HBNQ1S8VBjLQL
         YmSngU7xHouy6y4O5UnHZwoP3a4sYgh4koT9wnI/ZH+gL8KDu3ZcuMhShmtD/lqfGaol
         /avw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HSyN+e/bXp99YEHDDoss7T3ytoS/JigyhF1102UzIKE=;
        fh=ogbq6eGGyJ7D6Q9tIdaoLkQ5TMjI4Qe3I7y6YUIWdTI=;
        b=H38TU86Ienh+CVFqdd/ImzNsS5v1G/tZ2KcvGRhe5pgiM9zipGflLbVIULAf/aPfdk
         lXyY2xoW6sAY1Qko3mNYsQTi4OlhlZuCWwfkj4etJfYg8+1wdVXMkCC1Dlz6+5zPknBK
         exZ+uSUE+Xl9heI/tW/rHHUYfaM++YimxBRzSH7Q0TERbuoRQkRZ+08Hz14r49UFEInY
         IoC5F2TvdAO0AxJfLk6kSy1LDHCTGpDtO7pRIZFKrN82GoM1pdtOiiNCwqkB0VMsobHk
         pnzOhQu/wAWgy20QgvOxehOCoMNDdVxM+pacBYmp4P7vwyIUrgbKJV5zrFh0RQGl+XCv
         LmkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772669695; x=1773274495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSyN+e/bXp99YEHDDoss7T3ytoS/JigyhF1102UzIKE=;
        b=gMvbfNckr7poFIay0xfEtVO85POu8CD81C22BjoCgh4dXKCUUv2Zk2hGr5pDneYXmX
         bhcUpFunTFbEzea+izqtxvpUlHD6/2qiasshOiKilYhtxaVA+xe3KWR/Ng8io3FriPKz
         wvQ4LuPJGOAiSY/FrhyCdUPHhu5qA2v1R/H3AA8ZXs6IkjiVq9sSQlAjrqGlAZB1/Kmk
         PFDgVYNT4jYmsSOnbgva+BbpeMBb5sWMg+RimSuAQuxz95oY5jxy3b42mXCrreeEanTv
         F3+XhdrX0WiD4YznA3mMieSETuHpYfQelEVSC+M6LoxKSRBeKke+UmvbsXeK09p4Dav2
         6nQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772669695; x=1773274495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HSyN+e/bXp99YEHDDoss7T3ytoS/JigyhF1102UzIKE=;
        b=RD9ucEdJFuGPTpIuw58Q/ywWP9BBzSZhVKHYRJjc1xqz9QzwbDPt2pziDS8S9KH2kl
         mO7jAs2f47CrAxzDqDQNokV58WGJvQSzGs+/6VwjehpCVp3VO9Z3D4rY6tUknOq+aUQo
         PY5GS6utnFv+/AcTy0ipIth43uRKSAYawYgUlalt0ecHTrh/JsZcCXYkRCmB+byuNYF8
         ZETHlFK+DaiyDltjlSgFq96kQLY12G/8JLvt4TmmwWxgPVA6EcO3hlJhiVWlUAZZmaiB
         pG6c9LMuhk0S3Awe9V1p1hFwHUjOUZMEG19PwhNsS7YmKiCP53U+GlxSUE5OMctr6CvK
         P1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYLl1tteSn4TnC6jRtDLKvCqh3tiovv5V8l8FL9NXNdOJcalg2YbHR0a1hah1iCOFw83zdNrulTyUE@vger.kernel.org
X-Gm-Message-State: AOJu0Yx68mztbAj9QYXhV4pZaO0JPrq/y/E3G+cpfLopKtG6awLzQ3f5
	daHGxt0u8XCFvMxil7c6rd8e43n51BRSkjUJRSFe6Y7XYiwPpzB8rMJXleHTi7a0CDow7Efxyfa
	NPLI69YOuJjRlpDihJzO/CQW3Y0Gfmsg=
X-Gm-Gg: ATEYQzycMKyBVoAtHzha+3LKBzLq7YPt4yCho/3fHdRETKFfmj56xozO/+9ZYZqqAp8
	AS2zexArntkzK1NEMw0DomB4X9c8vYg88Mvc4Ny0fJWKczGrQ1aklBN2LfGNePb2th8K2dd0/wN
	4JDxsTagvyPnwgjJ6eLY8OHTl/85hYJDD9c1fTX69+c9kcN5gWdjfX9bDHhL3uVjLOOcwrVvfo3
	aM5tn60lPVu5BS/BqwhR0jIlgF1+hgn/S5B6HdB54TSmmqk7IicPkE41fwgZl0NQ/w5e8WfuOAf
	YIZ5YHf7D59ctuzCOOk9f0PXnXnTQasjz8Y71+YLGiccU2hPP/9WJbyiF9XAS3bwi/xxly+u/6x
	2Hp3pow==
X-Received: by 2002:a05:6102:2ace:b0:5ff:8b8:9f8c with SMTP id
 ada2fe7eead31-5ffaaf4b3bemr1900512137.26.1772669695494; Wed, 04 Mar 2026
 16:14:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
 <CAF6piCKOiwMz9Le2vBV4_W3R0NR3TW_je+ow4SCm5eX867awyg@mail.gmail.com>
In-Reply-To: <CAF6piCKOiwMz9Le2vBV4_W3R0NR3TW_je+ow4SCm5eX867awyg@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 19:14:43 -0500
X-Gm-Features: AaiRm50hxZ3LZQ8rWfNDJR5FazO0dRJs8u8F_F7HjgEpz5HRVEpNVToAMcIZlRk
Message-ID: <CADvbK_dhG7LZaRnz9JihHtboQmTLmudptGF1P+w5gyi=6Ls_2g@mail.gmail.com>
Subject: Re: [PATCH net-next v10 15/15] quic: add packet parser base
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

On Tue, Mar 3, 2026 at 4:16=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/25/26 3:34 AM, Xin Long wrote:
> > +/* Find the listening QUIC socket for an incoming packet.
> > + *
> > + * This function searches the QUIC socket table for a listening socket=
 that matches the dest
> > + * address and port, and the ALPN(s) if presented in the ClientHello. =
 If multiple listening
> > + * sockets are bound to the same address, port, and ALPN(s) (e.g., via=
 SO_REUSEPORT), this
> > + * function selects a socket from the reuseport group.
> > + *
> > + * Return: A pointer to the matching listening socket, or NULL if no m=
atch is found.
> > + */
> > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_a=
ddr *sa, union quic_addr *da,
> > +                                  struct quic_data *alpns)
> > +{
> > +     struct net *net =3D sock_net(skb->sk);
> > +     struct hlist_nulls_node *node;
> > +     struct sock *sk =3D NULL, *tmp;
> > +     struct quic_shash_head *head;
> > +     struct quic_data alpn;
> > +     union quic_addr *a;
> > +     u32 hash, len;
> > +     u64 length;
> > +     u8 *p;
> > +
> > +     hash =3D quic_listen_sock_hash(net, ntohs(sa->v4.sin_port));
> > +     head =3D quic_listen_sock_head(hash);
> > +
> > +     rcu_read_lock();
> > +begin:
> > +     if (!alpns->len) { /* No ALPN entries present or failed to parse =
the ALPNs. */
> > +             sk_nulls_for_each_rcu(tmp, node, &head->head) {
> > +                     /* If alpns->data !=3D NULL, TLS parsing succeede=
d but no ALPN was found.
> > +                      * In this case, only match sockets that have no =
ALPN set.
> > +                      */
> > +                     a =3D quic_path_saddr(quic_paths(tmp), 0);
> > +                     if (net =3D=3D sock_net(tmp) && quic_cmp_sk_addr(=
tmp, a, sa) &&
> > +                         quic_path_usock(quic_paths(tmp), 0) =3D=3D sk=
b->sk &&
> > +                         (!alpns->data || !quic_alpn(tmp)->len)) {
> > +                             sk =3D tmp;
> > +                             if (!quic_is_any_addr(a)) /* Prefer speci=
fic address match. */
> > +                                     break;
> > +                     }
> > +             }
> > +             goto out;
> > +     }
> > +
> > +     /* ALPN present: loop through each ALPN entry. */
> > +     for (p =3D alpns->data, len =3D alpns->len; len; len -=3D length,=
 p +=3D length) {
> > +             quic_get_int(&p, &len, &length, 1);
> > +             quic_data(&alpn, p, length);
> > +             sk_nulls_for_each_rcu(tmp, node, &head->head) {
> > +                     a =3D quic_path_saddr(quic_paths(tmp), 0);
> > +                     if (net =3D=3D sock_net(tmp) && quic_cmp_sk_addr(=
tmp, a, sa) &&
> > +                         quic_path_usock(quic_paths(tmp), 0) =3D=3D sk=
b->sk &&
> > +                         quic_data_has(quic_alpn(tmp), &alpn)) {
> > +                             sk =3D tmp;
> > +                             if (!quic_is_any_addr(a))
> > +                                     break;
> > +                     }
> > +             }
> > +             if (sk)
> > +                     break;
> > +     }
> > +out:
> > +     /* If the nulls value we got at the end of the iteration is diffe=
rent from the expected
> > +      * one, we must restart the lookup as the list was modified concu=
rrently.
> > +      */
> > +     if (!sk && get_nulls_value(node) !=3D hash)
> > +             goto begin;
> > +
> > +     if (sk && sk->sk_reuseport)
> > +             sk =3D reuseport_select_sock(sk, quic_addr_hash(net, da),=
 skb, 1);
> > +
> > +     if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > +             sk =3D NULL;
>
> Note that you could avoid the refcount if you keep using the sk in an
> RCU critical section. i.e. plain UDP does that. Same consideration for
> established lookup.
>
Doesn't seem easy to adjust the code for this, I will leave it as it is for=
 now.

Thanks.
