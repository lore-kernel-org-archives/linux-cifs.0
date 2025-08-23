Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BE142E83;
	Sat, 23 Aug 2025 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755972973; cv=none; b=mCZKe3oJsYYKsayeQuYm4dZ4ljdt8g0C9tyOSeFpJSyGhjRVPdN9EA/CrQ4GBdIIaIVTCfCWCx0IromiNyHLvHem7OStLFcWFlC53BD7hivtl4C8GlcYeeg35x+srosU99aJsBYaC16gjfHy1OY5w5Cb9GTPzz1MzS3nBgOMGDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755972973; c=relaxed/simple;
	bh=njSLvwIt8LiAq10rNFQp6mYMq/wOxOCeSrjPbSwxDqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DRpT5nvZofCvJYlQv7ftXhaX8U5S9czfRZZU1g/hKBrZNwdiwowlmD8hi1QeBa1Jb0t3yAbD2PuYMudzI2Mgwpj7RiE/oE2G5qLgzZAQoikb46SkCnpHmL/8NAB3IllU/7r8pDLCVP23hmv4NJh8x0nqcBM+wNeknW9RMOjyflA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gIhRj9Vj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIhRj9Vj"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3eb6da24859so2411375ab.3;
        Sat, 23 Aug 2025 11:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755972970; x=1756577770; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg2L8ubuEXpnhwtGksuVh66eJv1X6jJCQin96Spl1OI=;
        b=gIhRj9VjbNYAI5A0Cj2NTh+bhErzAL2BaGW4G2bH9m7348RVwQP9vqZ6uax+Q5e6Cz
         H+FVQS3mof4LVExHOJOEHHtJnbrAevnV8Ml1yaC603SkXuatbI13E0QWv/KMfBZHRqN3
         sPmVcx/Fjw4vbJn5LAtNr8PWTROHLrNob+YPicoure2Fu7jprLgLtYZD5Uem3SGbzo9Z
         okk0KivCtGALOForD9O2b2vp0HkWmf5A/5SfRAYcF8QZWuLWt3gfcp7ifDVRpezmDrc5
         nLQbJDjVC64RLt18F0JNEdd2n8F41P7vuyWyTRqnnvyEcgx15CKLpN4g0johvQcZMI9t
         crnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755972970; x=1756577770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg2L8ubuEXpnhwtGksuVh66eJv1X6jJCQin96Spl1OI=;
        b=F1IyFONsJ1Ef57m6XXm79Q9KEAtaQ0olRHGHLkB4wDoP1LzeRA/N97fbGTu3m/NHEz
         BYxB9T1hrvlYSjhTD3SxKpLhqW4QVoG1q41Arx4JRlVu6WK2gfYkDoQK8rDlWBnaFrhV
         MGKKhroPTZxXqS4xJ11k4/MnobiSs/L3QtCYwakRd3uM5XMlCQFmKdgrA079PhsClOOr
         IPhYj70OAMtQUrKHb/LQrIEJauuB3RYc5aEyvxbt5Lh6Vkq2W9+NBRUbmqnkj5XxRpbz
         gDetj+S6/ofglohrLUL++klU8qEevPqq2+HdCgP/Z0F4PpwW6LANb0OQopdDQ9w+O7ZQ
         SrDw==
X-Forwarded-Encrypted: i=1; AJvYcCVSX5394KBtPEhY3QrydS3pZSrp3jnI6CFsoaICIU0ulfkR5SNxfsB18HG1sqj/415LlhtCFgqHlpuO@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw1bBpdWptIZVqnz1q58YtOEdInZQLu2dHz1/YwLDVLYknhRap
	Axd6THEiQBJpL8aMosqxaB11KaRrgxAF/m2TH6nVNdqLDX33yAh8aiHNh4MFvRPUrTE7+sPXTib
	LYAmGDy6vsNVcjVBjWiCCjdkpKmxDSFA=
X-Gm-Gg: ASbGnctPGlnA9PlNGZNWrJREH9rnNChSGTPwK3yu5CraFYEHoTv6ndpj4kKqoaDqbCU
	v4x2+OtQrw8t9xb1Wytxh78bpZej5Rx26by3ckVJM3oCVOZI22j43DmRoOckyc6+kTfj2War04q
	ihyT6X0fkEr771k2KJb22C6WGGbVfmpTFbVU97/G53f7Z9MC0j1YX21DIvGUxCj60LDxP8czchQ
	x6Xp0G7EOl983g+/8sN
X-Google-Smtp-Source: AGHT+IEsgK/H0gyqBtqG9vpi3Iq1De6iE9KkdVlqWS5KyCYd33nd2HrGTegNdtikqERSb7XLsM7bvadHfWDP7iqnBCY=
X-Received: by 2002:a05:6e02:1709:b0:3e6:7151:a895 with SMTP id
 e9e14a558f8ab-3e91d393a49mr102597415ab.0.1755972969699; Sat, 23 Aug 2025
 11:16:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <7788ed89d491aa40183572a444b91dfdb28f20c4.1755525878.git.lucien.xin@gmail.com>
 <c06ff3eb-f69d-4bd8-b81a-a28b8b69ba52@redhat.com>
In-Reply-To: <c06ff3eb-f69d-4bd8-b81a-a28b8b69ba52@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 14:15:58 -0400
X-Gm-Features: Ac12FXwqN5JfN3XpNwS7ROWPGnRJsuMytXn7hIk2yr-_xDtZWIh6E6fyFkzoCKE
Message-ID: <CADvbK_e4=-JjYiVFWN-Uuroog-+AxCzgDsFg5OQqHND+RPw1Ow@mail.gmail.com>
Subject: Re: [PATCH net-next v2 03/15] quic: provide common utilities and data structures
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 8:58=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 8/18/25 4:04 PM, Xin Long wrote:
> [...]
> > +void quic_hash_tables_destroy(void)
> > +{
> > +     struct quic_hash_table *ht;
> > +     int table;
> > +
> > +     for (table =3D 0; table < QUIC_HT_MAX_TABLES; table++) {
> > +             ht =3D &quic_hash_tables[table];
> > +             ht->size =3D QUIC_HT_SIZE;
>
> Why?
>
> > +             kfree(ht->hash);
> > +     }
> > +}
> > +
> > +int quic_hash_tables_init(void)
> > +{
> > +     struct quic_hash_head *head;
> > +     struct quic_hash_table *ht;
> > +     int table, i;
> > +
> > +     for (table =3D 0; table < QUIC_HT_MAX_TABLES; table++) {
> > +             ht =3D &quic_hash_tables[table];
> > +             ht->size =3D QUIC_HT_SIZE;
>
> AFAICS the hash table size is always QUIC_HT_SIZE, which feels like too
> small for connection and possibly quick sockets.
indeed.

>
> Do yoi need to differentiate the size among the different hash types?
Yes, I will change to use alloc_large_system_hash() for these
hashtables, align with TCP:

- source connection IDs hashtable -> tcp_hashinfo.ehash
For Data receiving
- QUIC listening sockets hashtable -> tcp_hashinfo.lhash2
For New connections
- UDP tunnel sockets hashtable -> tcp_hashinfo.bhash
For binding
- QUIC sockets hashtable -> tcp_hashinfo.bhash
For some rare special cases, like receiving a stateless reset.

>
> > +             head =3D kmalloc_array(ht->size, sizeof(*head), GFP_KERNE=
L);
>
> If so, possibly you should resort to kvmalloc_array here.
>
> > +             if (!head) {
> > +                     quic_hash_tables_destroy();
> > +                     return -ENOMEM;
> > +             }
> > +             for (i =3D 0; i < ht->size; i++) {
> > +                     INIT_HLIST_HEAD(&head[i].head);
> > +                     if (table =3D=3D QUIC_HT_UDP_SOCK) {
> > +                             mutex_init(&head[i].m_lock);
> > +                             continue;
> > +                     }
> > +                     spin_lock_init(&head[i].s_lock);
>
> Doh, I missed the union mutex/spinlock. IMHO it would be cleaner to use
> separate hash types.
Yeah, I will separate them. :D

>
> [...]
> > +/* Parse a comma-separated string into a 'quic_data' list format.
> > + *
> > + * Each comma-separated token is turned into a length-prefixed element=
. The
> > + * first byte of each element stores the length (minus one). Elements =
are
> > + * stored in 'to->data', and 'to->len' is updated.
> > + */
> > +void quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
> > +{
> > +     struct quic_data d;
> > +     u8 *p =3D to->data;
> > +
> > +     to->len =3D 0;
> > +     while (len) {
> > +             d.data =3D p++;
> > +             d.len  =3D 1;
> > +             while (len && *from =3D=3D ' ') {
> > +                     from++;
> > +                     len--;
> > +             }
> > +             while (len) {
> > +                     if (*from =3D=3D ',') {
> > +                             from++;
> > +                             len--;
> > +                             break;
> > +                     }
> > +                     *p++ =3D *from++;
> > +                     len--;
> > +                     d.len++;
> > +             }
> > +             *d.data =3D (u8)(d.len - 1);
> > +             to->len +=3D d.len;
> > +     }
>
> The above does not perform any bound checking vs the destination buffer,
> it feels fragile.
>
 This function needs two checks:

1. len < U8_MAX
2. to->data memory len >=3D len + 1.

Although the caller like quic_sock_set_alpn() ensures that, I guess they
should still be done in this function as a common helper.

Thanks.
