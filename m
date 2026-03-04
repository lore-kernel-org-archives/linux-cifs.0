Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24634E774
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 23:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666011; cv=pass; b=asQ/SvEar+Dwa1eDzXj1K60IuMuG3JIuaUjAdAmvmIRNOFu7mg/qKQ0aTYB5Y3Kq4yBjTFc60LxbrVchx32dGg/uzfV+3GBeH1Ztd6U9Zm+Mu95O+9FyL9fA874N8NbC8G3Yj7tEVvPUTR4t9UNqXotyc55F1F/TOtvGVaKHU8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666011; c=relaxed/simple;
	bh=5l7t5GUb2D/4t62FXPSct37+0hReMV23ketRmHriGMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PD4sCREhiSZUnk9xJsZ94RWse/7vW7HDRqaySeBbh4ampvIrbwYIOQPDJH0D9+JHqVBhtzOiqU5itJj65VzySJcyNTKV2W/0y76XlOVteFwUyMfM/jR9UvqfN1vy2VVYG/KZu3MBe+GnoQW/5DmRTKUfCRTglsdpCFlTxWPVrEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoM+7H9G; arc=pass smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoM+7H9G"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5ffbbf07c11so638366137.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 15:13:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772666008; cv=none;
        d=google.com; s=arc-20240605;
        b=fCfRBGFHe3SknM6HA/Bs/iN90p7rEF10o8jBR06oA1Z2/qVqPcfY9rDpoGiXREYtMP
         +8NnT5BV+xBCeChtq/mjwvwYGLli3ViiqGtzKakpn8SO9gx9f3EZ7gGNGbC/IXRt3+lj
         mAEmfHik6ZLZVZdXWPR+J7zqTzE6WeTpNOvFwu3s6gqFO17JeomRgXQbKi7xNyN4NGQZ
         Q5YlbsqREyXC/0vkweTeZb9kiO+o37PFa6wLiJKI4K8DfuGXy2UpayijpjjKMlrCEN26
         NbS4eTXew6pJslIiLG17treHvNRfzT2mJmeYh+6azVJl52foTKmJevB0rhXk5PDS8pRW
         gtlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cT8TknxJNuHJgHXdge5Ni6drCi6rxzjYWQCjsyroxlk=;
        fh=2l4CjG9akMrdED3Cwo6tsLNl06S+LnGB6CPbH2YdbjY=;
        b=lauUZCycafL/H+pgiGHEoXaBDdZeCohcNnA8Myjfoj9NOvZSxTON/Pi1f5PpfjYRXa
         3nhi6W71oTcxa0lrG1K5jSiQxtTHKbIkSTQh3U8OF9DCosaZRfwflqs1etvDrVfS1HKv
         MOzOeloute3cYZVqDQWhZM/jXLLw1BeYteaFztl3Ww15eyeA0tsnzqKkDJEY5x3rjfjE
         d02cDJNrq8r6Ad1L1CbdHNX8+5Kc1Z/JX9CZrw8gyU7WoDp2VZUmn2GydATzO03itk1n
         69Dhngg+Qw59qDJqnPjPnAe6jsHTySXYilk6X+TZzcYcVPse3SJT9PTWDPBynZJXdL6S
         mKMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772666008; x=1773270808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT8TknxJNuHJgHXdge5Ni6drCi6rxzjYWQCjsyroxlk=;
        b=FoM+7H9G6QmKyKIpSt7BuADbqN6Y46624d1yiJkV2lFt2bXbo6y7zJ7w69sefkqHYt
         stw+2pKpN2Fve9nXj1jmeLSjMiwH5IuFwRfztJ44f0oFi5Xq3cjs8tikVUynRA4/HcUt
         v3UwKJKuqOaoCAaedkq00VktAtmIbFmM1p3nt/HeKn+ZAfR6nBaBAsMPYEDDuvt1/YHw
         e6QThDGY6a2QQNSFUYiVT7KxBEtQx621jO9D6+DCis7czg3KTr1y7yE2IqpfFR8Trf4V
         jl89SG40RPLh9wtrDiLPaLS60YY9wXOmHtjg7qV1HP8ufdS6HQgrh2N6uCMrhsu9b++E
         L7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772666008; x=1773270808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cT8TknxJNuHJgHXdge5Ni6drCi6rxzjYWQCjsyroxlk=;
        b=f1wk8zD06DbADIiri+r47KWqQUU+zYdHj+CsGb8DwYwkKSMqu7jlORchEO3/SXN12p
         2ZOlUyFJVHqE3QJRfOGnARnTr8g0R1HCap1pljnz5ul2VPufNY+dFqYg94MR5FcAmYZ8
         KExI+sEtOSKX/awOH0goHPl1x5cGWJHV50M53Z+bq7zdPXDrt0zhdc3lZ4rFhnxTYwrZ
         aNxtIkQtxLtMs/K+0+pyH23vjW3CyMD7v6LKZMte/n84+XtMtOy0fGML2JbeRj2a0rLU
         KnMuTPm/hoK4IGy63Jnfw4+xAd1MuhDDzZlo6vDZ/C+MsZWAxS0NRy9aekcLERHEUXFS
         +GhA==
X-Forwarded-Encrypted: i=1; AJvYcCXK8bHFgrjR1GBC7eguSWia6XGJdILa1j3GKxjONyIn4VypjwH52aNAIEbfbH4MkktMUQDEhCS1SBi5@vger.kernel.org
X-Gm-Message-State: AOJu0YwfpUuQ47ob6qkn/s/sPqGubS5CnbTwbR5pc+RfpMMQt4BvDHgY
	IAEq1rivYqYlq2965pNBckeLn41QErYsC+SmWcrMBBR2TWbAGCVM+u/W8daWJxbrgc/xySddC7/
	oy4HVpSmOYn3zZtsJQne73V+OAKOIaVo=
X-Gm-Gg: ATEYQzzLfQ6Ae16FbDbDtmYKpfh0LvWZqGAn/FVtLwSspqtqeJxOwoYSvzrVCHUsxtl
	PLdO1os6/d8ml6UUugmFcDQnpUptlATLswy88OaiX65wUL/hSIu89DslEY6pk2wV2wKeiSOI64n
	pqyBppTjLPzEketgNgniKQ7g1g4ZPchCyPDP/kueXfulJnYWp5KxZ3MOQgQwvrZrMLU6ov0Mg+b
	FEgMv6wYszJBvLdUW+CfrMuor2RPzCrW4G//0cqXbbCy7wsJFQUW8XomLq0BZ7W+NJSQpxGNT5R
	IdxDu5OZY/5410Fof1ptTxy3m/2xZLpAhrWqTlaJHUJUS2QHog8pdQ2gWmfKVffClVZxPp9IuF6
	2HDGIzJjcRzk/JDf8
X-Received: by 2002:a05:6102:5489:b0:5fe:652:5d2e with SMTP id
 ada2fe7eead31-5ffaaef0e47mr1704970137.24.1772666008447; Wed, 04 Mar 2026
 15:13:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
 <20260303083338.35544-1-pabeni@redhat.com>
In-Reply-To: <20260303083338.35544-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 18:13:15 -0500
X-Gm-Features: AaiRm527Z74RAkiN-mCfJkeNg8yTAxvy5WGzpm2A5_gQLEbJOF1OYgOVWbRr1Wc
Message-ID: <CADvbK_eo-aMrhr39ai6i+QU4d30_-Z=_5Cn4K9Yr2=XQat_51w@mail.gmail.com>
Subject: Re: [net-next,v10,14/15] quic: add packet builder base
To: Paolo Abeni <pabeni@redhat.com>
Cc: hepengtao@xiaomi.com, kuba@kernel.org, jlayton@kernel.org, metze@samba.org, 
	davem@davemloft.net, kernel-tls-handshake@lists.linux.dev, horms@kernel.org, 
	hare@suse.de, aahringo@redhat.com, tfanelli@redhat.com, mail@johnericson.me, 
	andrew.gospodarek@broadcom.com, linkinjeon@kernel.org, dhowells@redhat.com, 
	matttbe@kernel.org, xiyou.wangcong@gmail.com, dreibh@simula.no, 
	jbaron@akamai.com, quic@lists.linux.dev, pc@manguebit.com, 
	marc@fiuczynski.com, edumazet@google.com, alibuda@linux.alibaba.com, 
	steved@redhat.com, illiliti@protonmail.com, tom@talpey.com, 
	marcelo.leitner@gmail.com, sd@queasysnail.net, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, mbuhl@openbsd.org, smfrench@gmail.com, 
	chuck.lever@oracle.com, daniel@haxx.se
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:33=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add packet builder base
>
> This patch introduces 'quic_packet' to handle packing of QUIC packets on
> the transmit path, including frame packing, packet construction,
> encryption, bundling, and transmission logic.
>
> > diff --git a/net/quic/Makefile b/net/quic/Makefile
> > index 2ccf01ad9e22..0f903f4a7ff1 100644
> > --- a/net/quic/Makefile
> > +++ b/net/quic/Makefile
> > @@ -6,4 +6,4 @@
> >  obj-$(CONFIG_IP_QUIC) +=3D quic.o
> >
> >  quic-y :=3D common.o family.o protocol.o socket.o stream.o connid.o pa=
th.o \
> > -       cong.o pnspace.o crypto.o timer.o
> > +       cong.o pnspace.o crypto.o timer.o packet.o
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > new file mode 100644
> > index 000000000000..a56edc745bb1
> > --- /dev/null
> > +++ b/net/quic/packet.c
>
> [ ... ]
>
> > +/* Perform routing for the QUIC packet on the specified path, update h=
eader length and MSS
> > + * accordingly, reset path and start PMTU timer.
> > + */
> > +int quic_packet_route(struct sock *sk)
> > +{
> > +     struct quic_path_group *paths =3D quic_paths(sk);
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     union quic_addr *sa, *da;
> > +     u32 pmtu;
> > +     int err;
> > +
> > +     da =3D quic_path_daddr(paths, packet->path);
> > +     sa =3D quic_path_saddr(paths, packet->path);
> > +     err =3D quic_flow_route(sk, da, sa, &paths->fl);
> > +     if (err)
> > +             return err;
> > +
> > +     packet->hlen =3D quic_encap_len(da);
> > +     pmtu =3D min_t(u32, dst_mtu(__sk_dst_get(sk)), QUIC_PATH_MAX_PMTU=
);
> > +     quic_packet_mss_update(sk, pmtu - packet->hlen);
> > +
> > +     quic_path_pl_reset(paths);
> > +     quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
> > +     return 0;
> > +}
> > +
> > +/* Configure the QUIC packet header and routing based on encryption le=
vel and path. */
> > +int quic_packet_config(struct sock *sk, u8 level, u8 path)
> > +{
>
> [ ... ]
>
> > +
> > +     /* Perform routing and MSS update for the configured packet. */
> > +     if (quic_packet_route(sk) < 0)
> > +             return -1;
> > +     return 0;
> > +}
>
> Should quic_packet_config() propagate the error code from
> quic_packet_route() instead of returning -1?
>
> The function quic_packet_route() returns proper negative errno values
> (via quic_flow_route()), but quic_packet_config() replaces any error
> with -1 (which is -EPERM). This could be misleading when diagnosing
> routing failures.
Currently quic_packet_config() callers will either skip the process or
return -ENETUNREACH on the failures. But maybe it's better to use the
errno from quic_packet_route(). I will try to improve this.

>
> > diff --git a/net/quic/packet.h b/net/quic/packet.h
> > new file mode 100644
> > index 000000000000..8c23be386207
> > --- /dev/null
> > +++ b/net/quic/packet.h
>
> [ ... ]
>
> > +static inline u8 quic_packet_taglen(struct quic_packet *packet)
> > +{
> > +     return packet->taglen[!!packet->level];
> > +}
> > +
> > +static inline void quic_packet_set_taglen(struct quic_packet *packet, =
u8 taglen)
> > +{
> > +     packet->taglen[0] =3D taglen;
> > +}
> > +
> > +static inline u32 quic_packet_mss(struct quic_packet *packet)
> > +{
> > +     return packet->mss[0] - packet->taglen[!!packet->level];
> > +}
> > +
> > +static inline u32 quic_packet_max_payload(struct quic_packet *packet)
> > +{
> > +     return packet->mss[0] - packet->overhead - packet->taglen[!!packe=
t->level];
> > +}
> > +
> > +static inline u32 quic_packet_max_payload_dgram(struct quic_packet *pa=
cket)
> > +{
> > +     return packet->mss[1] - packet->overhead - packet->taglen[!!packe=
t->level];
> > +}
>
> This isn't a bug, but quic_packet_mss(), quic_packet_max_payload(),
> and quic_packet_max_payload_dgram() all repeat the expression
> 'packet->taglen[!!packet->level]'.
>
> Could these use quic_packet_taglen(packet) instead for consistency?
>
OK.

Thanks.
